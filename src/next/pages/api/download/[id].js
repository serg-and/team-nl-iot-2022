import fs from 'fs/promises'
import { sessionStorageFolder } from '../../../core/constants.mjs'

export default async (req, res) => {
  const id = req.query.id
  const filename = req.query.filename ?? id
  let csvFile

  try {
    csvFile = await fs.readFile(`${sessionStorageFolder}/${id}`)
  } catch {
    return res.status(404).send()
  }

  res
    .status(200)
    .setHeader("Content-Type", "text/csv")
    .setHeader("Content-Disposition", `attachment; filename=${filename}`)
    .send(csvFile)
}
