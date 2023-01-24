import Head from 'next/head'
import io from 'socket.io-client'
import { useEffect, useState } from 'react'
import { Box, Button, Stack, TextField, Typography } from '@mui/material'

export default function StartSessionPage() {
  const [socket, setSocket] = useState()
  const [script, setScript] = useState('')
  const [memberId, setMemberId] = useState('')
  const [members, setMembers] = useState([])

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
                disabled={(!script || !members.length)}
                variant='contained'
              >Start Session</Button>
              <TextField
                label='Script ID'
                type='number'
                variant='outlined'
                value={script}
                onChange={e => setScript(e.target.value)}
              />
              <Stack direction='row' spacing={2}>
                <TextField
                  label='Member ID'
                  type='number'
                  variant='outlined'
                  value={memberId}
                  onChange={e => setMemberId(e.target.value)}
                />
                <Button
                  onClick={addMember}
                  variant='contained'
                >Add Member</Button>
              </Stack>
              <Typography>
                Members: {members.join(', ')}
              </Typography>
            </Stack>
          )}
        </Box>
      </main>
    </>
  )

  function addMember() {
    const id = Number(memberId)
    if (!id || members.includes(id)) return

    setMembers([...members, Number(memberId)])
    setMemberId('')
  }

  async function startSession() {
    await fetch('/api/socket')
    const socket = io({ transports: ["websocket"] })
    
    socket.on("connect", () => {
      socket.emit('start-session', {
        scripts: [script],
        members: members
      })
      socket.on('sessionId', sessionId => console.log('Started session:', sessionId))
      setSocket(socket)
    })
    
    socket.on("disconnect", () => console.log('socket disconnected'))
  }

  async function stopSession() {
    await socket.disconnect()
    setSocket(null)
  }

  function fakeDataPoint () {
    const randFlipNegative = () => Math.random() > 0.5 ? 1 : -1
    const randAccValue = () => Math.random() * randFlipNegative()

    return JSON.stringify({
      Timestamp: new Date().getTime(),
      ArrayAcc: [
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()},
        {x: randAccValue(), y: randAccValue(), z: randAccValue()}
      ]
    })
  }

  async function sendMessage() {
    members.forEach(id => 
      socket.emit('data-point', JSON.stringify({
        member: id,
        data: fakeDataPoint()
      }))
    )
  }
  
}
