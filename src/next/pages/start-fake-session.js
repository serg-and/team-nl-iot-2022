import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import axios from 'axios'
import io from 'socket.io-client'
import { useEffect, useState } from 'react'

export default function StartSessionPage() {
  const [socket, setSocket] = useState()

  useEffect(() => {
    if (!socket) return

    socket.on('connect', () => {
      console.log('connected')
    })
  }, [socket])

  return (
    <div>
      <Head>
        <title>Start sessions fake data</title>
        {/* <meta name="description" content="Generated by create next app" /> */}
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        {socket ? (
          <>
            <button onClick={sendMessage}>
              Send Message
            </button>
            <button onClick={stopSession}>
              Stop Session
            </button>
          </>
        ) : (
          <button onClick={startSession}>
            Start Session
          </button>
        )}
      </main>
    </div>
  )

  async function startSession() {
    await fetch('/api/socket')
    setSocket(io())
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