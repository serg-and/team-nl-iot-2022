import { Server } from 'socket.io'
import { startSession } from '../../core/sessions.mjs'

export default function SocketHandler (req, res) {
  if (!res.socket.server.io) {
    const io = new Server(res.socket.server)
    res.socket.server.io = io

    io.on('connection', socket => {
      console.log('connection started')

      const [sendMessage, kill_process] = startSession()

      socket.on('data-point', msg => sendMessage(msg))

      socket.on('disconnect', () => kill_process())
    })
  }
  res.end()
}