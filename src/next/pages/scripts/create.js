import { useContext, useRef, useState } from "react";
import { Box, Button, Heading, Select, TextInput } from "grommet";
// import CodeEditor from "@uiw/react-textarea-code-editor";
import dynamic from "next/dynamic";
import "@uiw/react-textarea-code-editor/dist.css";
import axios from "axios";
import { useRouter } from "next/router";
import { AlertsContext } from "../../components/Alerts";

const CodeEditor = dynamic(
  () => import("@uiw/react-textarea-code-editor").then((mod) => mod.default),
  { ssr: false }
);

const editorHeight = 500
const languages = [
  ['py', 'Python'],
  ['r', 'R'],
]
const languageOptions = languages.map(i => i[1])
const outputTypes = [
  ['line_chart', 'Line Chart'],
  ['bar_chart', 'Bar Chart'],
]

export default function UploadScriptPage() {
  const router = useRouter()
  const pushAlert = useContext(AlertsContext)

  const [code, setCode] = useState('')
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [outputName, setOutputName] = useState('')
  const [outputType, setOutputType] = useState(outputTypes[0])
  const [language, setLanguage] = useState(languages[0])
  const [busy, setBusy] = useState(false)
  const fileInputRef = useRef()

  return (
    <Box gap='small'>
      <Heading level={3}>
        Upload script
      </Heading>
      <TextInput
        placeholder='Name'
        value={name}
        onChange={e => setName(e.target.value)}
      />
      <TextInput
        placeholder='Description'
        value={description}
        onChange={e => setDescription(e.target.value)}
      />
      <Box direction='row' gap='medium'>
        <Select
          options={outputTypes.map(i => i[1])}
          value={outputType}
          onChange={({ selected }) => setOutputType(outputTypes[selected])}
        />
        <TextInput
          placeholder='Output Name'
          value={outputName}
          onChange={e => setOutputName(e.target.value)}
        />
      </Box>
      <Box direction='row' gap='medium'>
        <Select
          options={languages.map(i => i[1])}
          value={language}
          onChange={({ selected }) => setLanguage(languages[selected])}
        />
        <Button
          label='Upload File'
          onClick={() => fileInputRef.current.click()}
        />
        <Button
          label='Paste from Clipboard'
          onClick={pasteClipboard}
        />
        <Button
          primary
          label='Upload'
          disabled={!code || !name || !outputName || busy}
          onClick={uploadScript}
        />
      </Box>
      <div style={{
        height: editorHeight,
        // margin-top: 50px!important,
        overflow: 'auto',
      }}>
        <CodeEditor
          autoFocus
          value={code}
          language={language[0]}
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
    </Box>
  )

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
    setLanguage(languages.find(([ext, name]) => ext === extension))
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

  function uploadScript() {
    setBusy(true)
    axios.post('/api/upload-script', {
      language: language[0],
      outputType: outputType[0],
      code, name, description, outputName
    })
    .then(() => router.push('/scripts'))
    .catch(err => {
      console.error(err.response.data)
      pushAlert({
        content: err.response.data,
        duration: 10000
      })
      setBusy(false)
    })
  }
}