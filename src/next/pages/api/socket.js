import { Server } from 'socket.io'
import { startSession } from '../../core/sessions.mjs'

// This function handles socket connections for the server.
export default function SocketHandler (req, res) {
  // Check if the server has a socket.io instance.
  if (!res.socket.server.io) {
    // Create a new socket.io instance for the server.
    const io = new Server(res.socket.server)
    res.socket.server.io = io

    console.log('socket.io server started')

    // Listen for new connections.
    io.on('connection', async (socket) => {
      console.log('connection started')

      socket.on('start-session', async message => {
        console.log('got start-session request with message: ', message)

        // sessions must specify atleast one script and teammember to run.
        if (!message.scripts?.length || !message.members?.length) {
          socket.disconnect()
          return
        }
        
        // Start a new session and get functions to control it.
        const { sessionId, sendMessage, endSession } = await startSession({
          name: message.name,
          scriptIds: message.scripts,
          memberIds: message.members,
        })

        console.log('succesfully started session: ', sessionId)
  
        socket.emit('sessionId', sessionId)
  
        // Listen for 'data-point' messages from the client.
        // socket.on('data-point', ({ member, data }) => {
          socket.on('data-point', (msg) => {
            console.log('data-point:  ', msg)
  
            if (!Number(msg.member) || !msg.data ) {
              console.log('bad data-point')
              return
            }
            sendMessage(Number(msg.member), msg.data)
          })
  
        
        // Listen for disconnect events from the client.
        socket.on('stop-session', () => endSession())
        socket.on('disconnect', () => endSession())
      })
    })
  }
  res.end()
}
