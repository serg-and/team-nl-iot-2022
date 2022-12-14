import fs from 'fs/promises'
import { scriptsFolder } from '../../core/constants.mjs'
import { supabaseService } from '../../core/supabase.mjs'
import { validatePythonScript, validateRScript } from '../../core/validators.mjs'

const scriptValidators = {
  py: validatePythonScript,
  r: validateRScript,
}

// It is a function that handles HTTP requests.
export default async (req, res) => {
  // Only accept POST requests.
  if (req.method !== 'POST') return res.status(405)

  // Destructure the request body.
  const { id, name, description, language, code, outputType, outputName } = req.body
  const extension = language.toLowerCase()
  
  // Check if the script language is supported.
  if (!Object.keys(scriptValidators).includes(extension))
    return res.status(400).send('Unsupported script language')
  
  // Validate the script code.
  try {
    // Call the appropriate validation function for the script language.
    const { error } = scriptValidators[extension](code)
    if (error)
      return res.status(400).send(error)
  } catch (err) {
    // If there is an error validating the code, log it and return a 500 Internal Server Error response.
    console.error(err)
    return res.status(500).send('Error validating script')
  }

  // update existing record if `id` is send
  if (id) {
    // Update the record for the script in the database.
    var { data, error } = await supabaseService
      .from('scripts')
      .update({
        language: extension,
        output_type: outputType,
        output_name: outputName,
        name, description,
      })
      .eq('id', id)
      .select('id')
      .single()
  } else {
    // Insert a new record for the script in the database.
    var { data, error } = await supabaseService
      .from('scripts')
      .insert({
        language: extension,
        output_type: outputType,
        output_name: outputName,
        name, description,
      })
      .select('id')
      .single()
  }

  if (error) {
    // If there is an error inserting the record, log it and return a 500 Internal Server Error response.
    console.error(error)
    return res.status(500).send(error.message)
  }

  // Construct the file path for the script.
  const filePath = `${scriptsFolder}/${data.id}.${extension}`
  // Ensure the target folder exists.
  await fs.mkdir(scriptsFolder, { recursive: true })
  // Write the script code to a file.
  await fs.writeFile(filePath, code)

  // Return a 200 OK response.
  res.status(200).send('ok')
}