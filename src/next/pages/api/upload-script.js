import fs from 'fs/promises'

const scriptsFolder = './storage/uploads/scripts'

export default async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405)
    return
  }

  ['language', 'code', 'name', 'description'].forEach(param => {
    if (!Object.keys(req.body).includes(param)) {
      res.status(400).json({ error: `Param ${param} missing from request` })
    }
  })

  const filePath = `${scriptsFolder}/${req.body.name}.${req.body.language}`
  await fs.writeFile(filePath, req.body.code)

  // validate code
  console.warn('\n TODO: validate code \n')

  res.status(200).send('ok')
}