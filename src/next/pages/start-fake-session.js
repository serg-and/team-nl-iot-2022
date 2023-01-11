import Head from 'next/head'
import io from 'socket.io-client'
import { useEffect, useState } from 'react'
import { Box, Button, Stack, TextField } from '@mui/material'

export default function StartSessionPage() {
  const [socket, setSocket] = useState()
  const [script, setScript] = useState('')

  useEffect(() => {
    if (!socket) return

    socket.on('connect', () => {
      console.log('connected')
    })
  }, [socket])

  return (
    <>
      <Head>
        <title>Start sessions fake data</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        <Box width={400}>
          {socket ? (
            <Stack direction='row' spacing={2}>
              <Button
                onClick={sendMessage}
                disabled={!script}
                variant='contained'
              >Send Message</Button>
              <Button
                onClick={stopSession}
                disabled={!script}
                variant='contained'
              >Stop Session</Button>
            </Stack>
          ) : (
            <Stack spacing={2}>
              <Button
                onClick={startSession}
                disabled={!script}
                variant='contained'
              >Start Session</Button>
              <TextField
                label='Script ID'
                type='number'
                variant='outlined'
                value={script}
                onChange={e => setScript(e.target.value)}
              />
            </Stack>
          )}
        </Box>
      </main>
    </>
  )

  async function startSession() {
    await fetch('/api/socket')
    const socket = io({ transports: ["websocket"] })
    socket.on("connect", () => {
      socket.emit('start-session', {
        scripts: [script]
      })
      socket.on('sessionId', sessionId => console.log('Started session:', sessionId))
      setSocket(socket)
    })
  }

  async function stopSession() {
    await socket.disconnect()
    setSocket(null)
  }

  async function sendMessage() {
    socket.emit('data-point', JSON.stringify({
      timestamp: new Date().getTime(),
      value: Math.random() * 1000
    }))
  }
}
