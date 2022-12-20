import { Server } from 'socket.io'
import { startSession } from '../../core/sessions.mjs'

// This function handles socket connections for the server.
export default function SocketHandler (req, res) {
  // Check if the server has a socket.io instance.
  if (!res.socket.server.io) {
    // Create a new socket.io instance for the server.
    const io = new Server(res.socket.server)
    res.socket.server.io = io

    // Listen for new connections.
    io.on('connection', async (socket) => {
      console.log('connection started')

      socket.on('start-session', async message => {
        const scripts = message.scripts
        // sessions must specify atleast one script to run.
        if (!scripts || !scripts.length) return
        
        // Start a new session and get functions to control it.
        const { sessionId, sendMessage, endSession } = await startSession(scripts)
  
        socket.emit('sessionId', sessionId)
  
        // Listen for 'data-point' messages from the client.
        socket.on('data-point', msg => sendMessage(msg))      
        
        // Listen for disconnect events from the client.
        socket.on('disconnect', () => endSession())
      })
    })
  }
  res.end()
}
