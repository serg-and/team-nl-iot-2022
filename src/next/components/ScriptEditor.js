import { useContext, useRef, useState } from "react";
import dynamic from "next/dynamic";
import "@uiw/react-textarea-code-editor/dist.css";
import { Button, FormControl, InputLabel, MenuItem, Select, Stack, TextField, Typography } from "@mui/material";

const CodeEditor = dynamic(
  () => import("@uiw/react-textarea-code-editor").then((mod) => mod.default),
  { ssr: false }
);

const editorHeight = 500
const languages = {
  'py': 'Python',
  'r': 'R',
}
const outputTypes = {
  'line_chart': 'Line Chart',
  'bar_chart': 'Bar Chart',
}

export default function ScriptEditor(props) {
  const [code, setCode] = useState(props.code ?? '')
  const [name, setName] = useState(props.name ?? '')
  const [description, setDescription] = useState(props.description ?? '')
  const [outputName, setOutputName] = useState(props.outputName ?? '')
  const [outputType, setOutputType] = useState(props.outputType ?? 'line_chart')
  const [language, setLanguage] = useState(props.language ?? 'py')
  const [busy, setBusy] = useState(false)
  const fileInputRef = useRef()

  return (
    <Stack spacing={2}>
      <TextField
        label='Name'
        value={name}
        onChange={e => setName(e.target.value)}
      />
      <TextField
        label='Description'
        value={description}
        onChange={e => setDescription(e.target.value)}
      />
      <Stack direction='row' spacing={2}>
        <FormControl sx={{ width: 180 }}>
          <InputLabel>Output Type</InputLabel>
          <Select
            label='Output Type'
            value={outputType}
            onChange={e => setOutputType(e.target.value)}
          >
            {Object.entries(outputTypes).map(([id, name]) => (
              <MenuItem key={id} value={id}>{name}</MenuItem>
            ))}
          </Select>
        </FormControl>
        <TextField
          fullWidth
          label='Output Name'
          value={outputName}
          onChange={e => setOutputName(e.target.value)}
        />
      </Stack>
      <Stack direction='row' spacing={2}>
        <FormControl sx={{ width: 180 }}>
          <InputLabel>Language</InputLabel>
          <Select
            label='Language'
            value={language}
            onChange={e => setLanguage(e.target.value)}
          >
            {Object.entries(languages).map(([id, name]) => (
              <MenuItem key={id} value={id}>{name}</MenuItem>
            ))}
          </Select>
        </FormControl>
        <Stack direction='row' spacing={2} justifyContent='flex-end' sx={{ width: '100%' }}>
          <Button 
            variant='outlined'
            onClick={() => fileInputRef.current.click()}
          >
            Upload File
          </Button>
          <Button
            variant='outlined'
            onClick={pasteClipboard}
          >
            Paste from Clipboard
          </Button>
          <Button
            variant='contained'
            disabled={!code || !name || !outputName  || !outputType || busy}
            onClick={onSave}
            sx={{ width: 'auto' }}
          >
            Save
          </Button>
        </Stack>
      </Stack>
      <div style={{
        height: editorHeight,
        overflow: 'auto',
      }}>
        <CodeEditor
          autoFocus
          value={code}
          language={language}
          onChange={e => setCode(e.target.value)}
          placeholder='# enter code'
          minHeight={editorHeight}
          style={{
            fontSize: 14,
            backgroundColor: "#f5f5f5",
            fontFamily: 'ui-monospace,SFMono-Regular,SF Mono,Consolas,Liberation Mono,Menlo,monospace',
          }}
        />
      </div>
      <input
        name='file'
        type='file'
        accept='.py,.R,.r'
        style={{ display: 'none' }}
        onChange={pasteFile}
        ref={fileInputRef}
      />
    </Stack>
  )

  async function onSave() {
    setBusy(true)
    await props.onSave({
      language: language,
      outputType: outputType,
      code, name, description, outputName
    })
    setBusy(false)
  }

  function pasteFile(e) {
    e.preventDefault()
    if (!fileInputRef.current.value) return

    const reader = new FileReader()
    reader.onload = async (e) => {
      setCode(e.target.result)
      focusEditor()
    }
    const file = e.target.files[0]
    reader.readAsText(file)
    
    setName(file.name.split('.')[0])

    const extension = file.name.split('.').at(-1).toLowerCase()
    setLanguage(extension)
    fileInputRef.current.value = null
  }

  async function pasteClipboard() {
    const text = await navigator.clipboard.readText()
    // paste above current code
    if (code) setCode(`${text}\n${code}`)
    else setCode(text)
    focusEditor()
  }

  function focusEditor() {
    // yes very ugly, no clean solution seems possible
    document.getElementsByTagName("textarea")[0].focus()
  }
}