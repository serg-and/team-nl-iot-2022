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