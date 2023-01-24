import fs from 'fs/promises'
import { sessionStorageFolder } from '../../../core/constants.mjs'

export default async (req, res) => {
  const id = req.query.id
  const filename = req.query.filename ?? id
  let json

  try {
    const content = await fs.readFile(`${sessionStorageFolder}/${id}`)
    json = JSON.parse(content)
  } catch {
    return res.status(404).send()
  }

  res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
  res.status(200).json(json)
}
