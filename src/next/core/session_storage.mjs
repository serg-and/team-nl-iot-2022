import fs from 'fs/promises'
import { sessionStorageFolder } from './constants.mjs'

export const getFilePath = (sessionId, memberId) =>
  `${sessionStorageFolder}/${sessionId}_${memberId}.json`

export async function createMemberSessionStorage(sessionId, memberId) {
  await fs.mkdir(sessionStorageFolder, { recursive: true })
  await fs.writeFile(getFilePath(sessionId, memberId), '[]', { })
}

export async function updateMemberSessionStorage(sessionId, memberId, json) {
  const filePath = getFilePath(sessionId, memberId)
  const text = await fs.readFile(filePath)
  const data = JSON.parse(text)
  data.push(JSON.parse(json))
  await fs.writeFile(filePath, JSON.stringify(data))
}

createMemberSessionStorage(14, 15)