import { spawn } from 'child_process'
import { supabaseService } from './supabase.mjs'

const programs = {
  py: 'python3',
  r: 'Rscript',
}
const entrypoints = {
  py: 'python_entrypoint.py',
  r: 'r_entrypoint.r',
}

// Starts a session and creates processes to run scripts.
export async function startSession(scriptIds) {
  // Create a session in the database.
  const { data: { id: sessionId }, error: sessionError } = await supabaseService
    .from('sessions')
    .insert({ name: 'No Script Name' })
    .select('id')
    .single()
  
  // Get the given scripts from the database.
  const { data: scripts, error: scriptsError } = await supabaseService
    .from('scripts')
    .select('id, language, output_type')
    .in('id', scriptIds)
  
  // Create output records for each script in the database.
  const { data: scriptOutputs, error: scriptOutputsError } = await supabaseService
    .from('script_outputs')
    .insert(scripts.map(script => (
      { script: script.id, session: sessionId, values: [] }
    )))
    .select('id')
  
  // Create a list of script outputs and their corresponding scripts.
  const outputs = scriptOutputs.map((scriptOutput, i) => ({ ...scriptOutput, script: scripts[i] }))

  // Spawn a process for each script to run it.
  const processes = outputs.map(output => {
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
      } catch {
        // If the data could not be parsed as JSON, log the data as a string.
        console.log('from script:', data.toString())
      }
    })

    // Handle errors from the script.
    child.stderr.on('data', data => {
      console.log(`An error occured in script id:${output.script.id} name:"${output.script.name}",  error -->`)
      console.log(data.toString())
    })

    return {
      // Create a function to send a message to the script.
      sendMessage: (msg) => child.stdin.write(`${msg}\n`),
      // Create a function to kill the script.
      kill: () => child.kill()
    }
  })

  // Create a function to send a message to all scripts.
  function sendMessage
  (msg) {
    processes.forEach(process => process.sendMessage(msg))
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
