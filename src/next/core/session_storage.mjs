import { exec } from 'child_process'
import fs from 'fs/promises'
import { sessionStorageFolder } from './constants.mjs'

const csvScheme = 'timestamp,gx,gy,gz\n'

export const getFilePath = (sessionId, memberId) =>
  `${sessionStorageFolder}/${sessionId}_${memberId}.csv`

export async function createMemberSessionStorage(sessionId, memberId) {
  await fs.mkdir(sessionStorageFolder, { recursive: true })
  await fs.writeFile(getFilePath(sessionId, memberId), csvScheme, { })
}

export async function updateMemberSessionStorage(sessionId, memberId, data) {
  // const filePath = getFilePath(sessionId, memberId)
  // const text = await fs.readFile(filePath)
  // const data = JSON.parse(text)
  // data.push(JSON.parse(json))
  // await fs.writeFile(filePath, JSON.stringify(data))

  const values = [data.timestamp, data.gx, data.gy, data.gz]
  const newLine = values.join(',')
  exec(`echo '${newLine}' >> ${getFilePath(sessionId, memberId)}`)
}

createMemberSessionStorage(14, 15)