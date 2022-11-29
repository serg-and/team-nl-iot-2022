import { spawn } from 'child_process'

export function startSession() {
  const child = spawn('python3', ['core/script-entrypoints/python/start_script.py'])

  child.stdout.on('data', data => {
    console.log(data.toString())

    try {
      console.log(JSON.parse(data))
    } catch { }
  })

  return [
    (msg) => child.stdin.write(`${msg}\n`),
    () => child.kill()
  ]
}
