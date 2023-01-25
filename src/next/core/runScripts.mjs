import { spawn } from 'child_process'

export const languages = {
  py: {
    program: 'python3',
    entrypoint: 'python_entrypoint.py',
  },
  r: {
    program: 'Rscript',
    entrypoint: 'r_entrypoint.r',
  },
}
// const programs = {
//   py: 'python3',
//   r: 'Rscript',
// }
// const entrypoints = {
//   py: 'python_entrypoint.py',
//   r: 'r_entrypoint.r',
// }

export function startScript(scriptPath, language, onSaveValue) {
  // const script_path = `storage/uploads/scripts/${scriptPath}`
  const child = spawn(
    languages[language].program,
    [`core/script-entrypoints/${languages[language].entrypoint}`, scriptPath]
  )

  // Handle messages from the script.
  child.stdout.on('data', data => {
    // there might be multiple messages on a single line of the stdout
    // try parsing and handling the single messages
    const lines = []
    let text = data.toString()
    while (true) {
      const splitIndex = text.indexOf('}{') + 1
      if (!splitIndex) {
        lines.push(text)
        break
      }
      lines.push(text.slice(0, splitIndex))
      text = text.slice(splitIndex, text.length)
    }

    lines.forEach(line => {
      try {
        // Parse the data as JSON.
        const parsed = JSON.parse(line)
        if (parsed.type === 'save' && parsed.value && parsed.timestamp)
          onSaveValue({ value: parsed.value, timestamp: parsed.timestamp })
        if (parsed.type === 'error')
          console.log(parsed.error)
      } catch (err) {
        // If the data could not be parsed as JSON, log the data as a string.
        console.log(
          // `failed to handle message from script:${scriptPath} -->\n`,
          // 'message: ', line, '\n',
          // 'error: ', err
          line
        )
      }
    })
  })

  // Handle errors from the script.
  child.stderr.on('data', data => {
    console.log(`An error occured in script:${scriptPath}",  error -->`)
    console.log(data.toString())
  })

  return {
    // Create a function to send a message to the script.
    sendMessage: (msg) => child.stdin.write(`${msg}\n`),
    // Create a function to kill the script.
    kill: () => child.kill()
  }
}
