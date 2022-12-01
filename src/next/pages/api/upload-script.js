// import { createServerSupabaseClient } from '@supabase/auth-helpers-nextjs'
import fs from 'fs/promises'
import { supabaseService } from '../../core/supabase.mjs'
import { validatePythonScript } from '../../core/validators.mjs'

const scriptsFolder = './storage/uploads/scripts'
const scriptValidators = {
  py: validatePythonScript,
  r: () => console.log('start R script validator'),
}

export default async (req, res) => {
  if (req.method !== 'POST') return res.status(405)

  const { name, description, language, code, outputType, outputName } = req.body
  const extension = language.toLowerCase()
  
  // validate code
  if (!Object.keys(scriptValidators).includes(extension))
    return res.status(400).send('Unsupported script language')
  
  try {
    const { error } = scriptValidators[extension](code)
    if (error)
      return res.status(400).send(error)
  } catch (err) {
    console.error(err)
    return res.status(500).send('Error validating script')
  }

  const { data, error } = await supabaseService
    .from('scripts')
    .insert({
      language: extension,
      output_type: outputType,
      output_name: outputName,
      name, description,
    })
    .select('id')
    .single()
  
  if (error) {
    console.error(error)
    return res.status(500).send(error.message)
  }

  const filePath = `${scriptsFolder}/${data.id}.${extension}`
  await fs.writeFile(filePath, code)

  res.status(200).send('ok')
}