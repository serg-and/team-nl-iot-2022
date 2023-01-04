import { Stack, Typography } from "@mui/material";
import { useRouter } from "next/router"
import { promises as fs } from 'fs';
import ScriptEditor from "../../components/ScriptEditor"
import { scriptsFolder } from "../../core/constants.mjs"
import { supabaseService } from "../../core/supabase.mjs"
import axios from "axios";
import { useSnackbar } from 'notistack'

export async function getServerSideProps(context) {
  const id = context.query.id
  const { data: script, error } = await supabaseService
    .from('scripts')
    .select()
    .eq('id', id)
    .single()

  const code = (await fs.readFile(`${scriptsFolder}/${script.id}.${script.language}`)).toString()

  return {
    props: {
      id: script.id,
      name: script.name,
      outputName: script.output_name,
      outputType: script.output_type,
      language: script.language,
      description: script.description,
      code: code
    }
  }
}

export default function EditScript(props) {
  const router = useRouter()
  const { enqueueSnackbar } = useSnackbar()
  
  return (
    <Stack spacing={3}>
      <Typography variant='h5'>Edit Script</Typography>
      <ScriptEditor
        {...props}
        editing={true}
        onSave={async (data) => {
          axios.post('/api/upload-script', {
            id: props.id,
            ...data
          })
          .then(() => router.push('/scripts'))
          .catch(err => {
            enqueueSnackbar(err.response.data, {
              autoHideDuration: 10000,
              variant: 'error',
            })
            console.error(err.response.data)
          })
        }}
      />
    </Stack>
  )
}