import { useSupabaseClient } from '@supabase/auth-helpers-react'
import Link from "next/link"
import { useEffect, useState } from "react"
import { Box, Button, Heading, Text } from "grommet"
import { FormTrash } from 'grommet-icons'

export default () => {
  const supabase = useSupabaseClient()
  const [scripts, setScripts] = useState([])

  useEffect(() => {
    const loadData = async () => {
      const { data, error } = await supabase
        .from('scripts')
        .select('id, name, language, output_type, created_at')
      
      setScripts(data)
    }
    loadData()
  }, [])

  return (
    <Box gap='small'>
      <Box direction='row' justify='between' align='center'>
        <Heading level={2}>
          Scripts
        </Heading>
        <Link href='/scripts/create/'>
          <Button label='Create Script'/>
        </Link>
      </Box>
      {scripts.map(script => 
        <ScriptListing
          key={script.id}
          script={script}
          deleteScript={() => deleteScript(script)}
        />
      )}
    </Box>
  )

  async function deleteScript(script) {
    const { error } = await supabase
      .from('scripts')
      .delete()
      .eq('id', script.id)
    
    if (error) {
      console.error(error)
      return
    }
    
    setScripts(scripts.filter(s => s !== script))
   }
}

function ScriptListing({ script, deleteScript }) {
  // console.log(script)
  return (
    <Box direction='row' align='center' gap='large' background='light-grey'>
      <Heading level={4}>
        {script.name}
      </Heading>
      <Text>{script.output_type}</Text>
      <Text>{script.language}</Text>
      <Button
        icon={<FormTrash color='red'/>}
        onClick={deleteScript}
      />
    </Box>
  )
}