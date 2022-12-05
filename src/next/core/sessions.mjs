import { spawn } from 'child_process'
import { supabaseService } from './supabase.mjs'

export async function startSession() {
  // create session
  const { data: { id: sessionId }, error: sessionError } = await supabaseService
    .from('sessions')
    .insert({ name: 'No Script Name' })
    .select('id')
    .single()
  
  const { data: scripts, error: scriptsError } = await supabaseService
    .from('scripts')
    .select('id, language, output_type')
  
  // bulk create output records
  const { data: scriptOutputs, error: scriptOutputsError } = await supabaseService
    .from('script_outputs')
    .insert(scripts.map(script => (
      { script: script.id, session: sessionId, values: [] }
    )))
    .select('id')
  
  const outputs = scriptOutputs.map((scriptOutput, i) => ({ ...scriptOutput, script: scripts[i] }))

  // spawn processes for each script
  const processes = outputs.map(output => {
    const script_path = `storage/uploads/scripts/${output.script.id}.${output.script.language}`
    const child = spawn('python3', ['core/script-entrypoints/python/start_script.py', script_path])

    // messages coming from script
    child.stdout.on('data', data => {
      try {
        const parsed = JSON.parse(data)
        if (parsed.type === 'save' && parsed.value && parsed.timestamp)
          appendValueToOutput(output.id, { value: parsed.value, timestamp: parsed.timestamp })
        if (parsed.type === 'error')
          console.log(data.error)
      } catch {
        console.log('from script:', data.toString())
      }
    })

    child.stderr.on('data', data => {
      console.log(`An error occured in script id:${output.script.id} name:"${output.script.name}",  error -->`)
      console.log(data.toString())
    })

    return {
      sendMessage: (msg) => child.stdin.write(`${msg}\n`),
      kill: () => child.kill()
    }
  })

  function sendMessage(msg) {
    processes.forEach(process => process.sendMessage(msg))
  }

  async function endSession() {
    const { error } = await supabaseService
      .from('sessions')
      .update({ ended_at: 'NOW()' })
      .eq('id', sessionId)
    
    processes.forEach(process => process.kill())
  }

  return { sendMessage, endSession }
}

// calls supabase RPC (stored procedure) to add value to ouput values array
async function appendValueToOutput(script_output_id, value) {
  const { error } = await supabaseService
    .rpc('output_append_value', {
      script_output_id, 
      value
    })
  
  if (error) console.error(error)
}
