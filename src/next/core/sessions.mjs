import { spawn } from 'child_process'
import { createMemberSessionStorage, updateMemberSessionStorage } from './session_storage.mjs'
import { supabaseService } from './supabase.mjs'
import { getFormattedDateTime } from './utils.mjs'

const programs = {
  py: 'python3',
  r: 'Rscript',
}
const entrypoints = {
  py: 'python_entrypoint.py',
  r: 'r_entrypoint.r',
}

// Starts a session and creates processes to run scripts.
export async function startSession({ name, scriptIds, memberIds }) {
  // generate default name if no session name is given
  if (!name?.length) name = `Session ${getFormattedDateTime()}`

  const { data: members, error } = await supabaseService
    .from('team_members')
    .select('id, name')
    .in('id', memberIds)

  if (!members) throw Error(`no team members found, used IDs: ${memberIds}`)

  // Create a session in the database.
  const { data: { id: sessionId }, error: sessionError } = await supabaseService
    .from('sessions')
    .insert({ name, team_member_ids: memberIds })
    .select('id')
    .single()
  
  // Get the given scripts from the database.
  const { data: scripts, error: scriptsError } = await supabaseService
    .from('scripts')
    .select('id')
    .in('id', scriptIds)
    
  // Create output records for each script for each member in the database.
  const insertScriptOutputs = members.map(member => scripts.map(script => ({
      script: script.id,
      session: sessionId,
      team_member: member.id,
      values: [],
    })))
    .flat()
  // Insert script_outputs in database
  const { data: scriptOutputs, error: scriptOutputsError } = await supabaseService
    .from('script_outputs')
    .insert(insertScriptOutputs)
    .select('id, team_member, script(id, language, output_type)')
  
  // create the file to store the incoming raw data
  members.forEach(async (member) => await createMemberSessionStorage(sessionId, member.id))

  // Spawn a process for each of (members * scripts) to run it.
  const processes = scriptOutputs.map(output => {
    const script_path = `storage/uploads/scripts/${output.script.id}.${output.script.language}`
    const child = spawn(
      programs[output.script.language],
      [`core/script-entrypoints/${entrypoints[output.script.language]}`, script_path]
    )

    // Handle messages from the script.
    child.stdout.on('data', data => {
      try {
        // Parse the data as JSON.
        const parsed = JSON.parse(data)
        if (parsed.type === 'save' && parsed.value && parsed.timestamp)
          // Append the value to the script output in the database.
          appendValueToOutput(output.id, { value: parsed.value, timestamp: parsed.timestamp })
        if (parsed.type === 'error')
          // Log the error message.
          console.log(data.error)
      } catch (err) {
        // If the data could not be parsed as JSON, log the data as a string.
        console.log(
          'failed to handle message from scirpt -->\n',
          'message: ', data.toString(), '\n',
          'error: ', err
        )
      }
    })

    // Handle errors from the script.
    child.stderr.on('data', data => {
      console.log(`An error occured in script id:${output.script.id} name:"${output.script.name}",  error -->`)
      console.log(data.toString())
    })

    return {
      output: output,
      // Create a function to send a message to the script.
      // And update the sensor data storage
      sendMessage: (msg) => {
        child.stdin.write(`${msg}\n`)
      },
      // Create a function to kill the script.
      kill: () => child.kill()
    }
  })

  // sort processes by member for performance reasons
  const processesMemberMapping = {}
  processes.forEach(process => {
    const list = processesMemberMapping[process.output.team_member]
    if (list) list.push(process)
    else processesMemberMapping[process.output.team_member] = [process]
  })

  // Create a function to send a message to all scripts.
  async function sendMessage(memberId, msg) {
    // make sure message is a valid JSON string
    // otherwise abort
    try { JSON.parse(msg) }
    catch { return }

    processesMemberMapping[memberId]
      .forEach(process => process.sendMessage(msg))
    
    await updateMemberSessionStorage(sessionId, memberId, msg)
  }

  // This function ends the session and kills all running scripts.
  async function endSession() {
    // Mark the session as ended in the database.
    const { error } = await supabaseService
      .from('sessions')
      .update({ ended_at: 'NOW()' })
      .eq('id', sessionId)
    
    // Kill all running scripts.
    processes.forEach(process => process.kill())
  }

  // Return functions to control the session and send messages to scripts.
  return { sessionId, sendMessage, endSession }
}

// This function appends a value to a script output in the database.
async function appendValueToOutput(script_output_id, value) {
  const { error } = await supabaseService
    .rpc('output_append_value', {
      script_output_id, 
      value
    })
  
  if (error) console.error(error)
}