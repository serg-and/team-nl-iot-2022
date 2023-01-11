import { Stack, Typography } from "@mui/material";
import axios from "axios";
import { useRouter } from "next/router";
import { useSnackbar } from 'notistack'
import ScriptEditor from "../../components/ScriptEditor";

export default function UploadScriptPage() {
  const router = useRouter()
  const { enqueueSnackbar } = useSnackbar()

  return (
    <Stack spacing={3}>
      <Typography variant='h5'>Create Script</Typography>
      <ScriptEditor
        onSave={async (data) => {
          axios.post('/api/upload-script', data)
          .then(() => router.push('/scripts'))
          .catch(err => {
            console.error(err.response.data)
            enqueueSnackbar(err.response.data, {
              autoHideDuration: 10000,
              variant: 'error',
            })
          })
        }}
      />
    </Stack>
  )
}
