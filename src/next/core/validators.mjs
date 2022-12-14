import { parse } from 'filbert'

export const validatePythonScript = (code) => {
  const ast = parse(code)

  // find "main" function definition
  const mainDef = ast.body.find(node => node.type === 'FunctionDeclaration' && node.id?.name === 'main')
  if (!mainDef)
    return { error: 'No "main" function definition found' }

  if (mainDef.params.length !== 3)
    return { error: `"main" function definition is expected to have 3 parameters (raw_data, parse_data, save_data_point), got ${mainDef.params.length} parameters` }

  return {}
}

export const validateRScript = (code) => {
  let foundMain = false
  let parameters
  let correctParametersCount = false

  const lines = code.split('\n')

  for (const line of lines) {
    const syntaxes = line.split(' ')
    if (syntaxes.length < 3) continue
    if (syntaxes[0] !== 'main') continue
    if (!['<-', '='].includes(syntaxes[1])) continue
    
    if (!syntaxes[2].includes('function(')) continue
    const functionDeclaration = line.slice(line.indexOf('function('), line.length)
    foundMain = true

    parameters = functionDeclaration
      .split('(')[1]
      .split(')')[0]
      .split(',')  
    
    if (parameters.length === 2) {
      correctParametersCount = true
      break
    }
  }

  if (!foundMain)
    return { error: 'No "main" function found' }

  if (!correctParametersCount)
    return { error: `"main" function is expected to have 2 parameters (get_data, save_value), got ${parameters.length} parameters (${parameters})` }
  
  return {}
}
