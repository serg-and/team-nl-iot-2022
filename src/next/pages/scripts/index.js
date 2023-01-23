import { useSupabaseClient } from '@supabase/auth-helpers-react'
import Link from "next/link"
import { useEffect, useState } from "react"
// import { Box, Button, Heading, Text } from "grommet"
// import { Close } from 'grommet-icons'
import DeleteForeverIcon from '@mui/icons-material/DeleteForever';
import Close from '@mui/icons-material/Close';
import { Box, Button, Card, IconButton, Modal, Stack, Paper, Typography } from '@mui/material'
import { DataGrid } from '@mui/x-data-grid'

const outputTypeDisplayStrings = {
  'line_chart': 'Line Chart',
  'bar_chart': 'Bar Chart',
}
const languageDisplayStrings = {
  'py': 'Python',
  'r': 'R',
}

export default () => {
  const supabase = useSupabaseClient()
  const [scripts, setScripts] = useState([])
  const [deletionScript, setDeletionScript] = useState()

  useEffect(() => {
    async function loadData() {
      const { data, error } = await supabase
        .from('scripts')
        .select('id, name, language, output_type, created_at')
        .order('id', { ascending: false })
      
      if (data) setScripts(data)
    }
    loadData()
  }, [])

  return (
    <>
      <Stack spacing={3}>
        <Stack direction='row' justifyContent='space-between' alignItems='center'>
          <Typography variant='h5'>Scripts</Typography>
          <Link href='/scripts/create' style={{ textDecoration: 'none' }}>
            <Button variant='contained'>Create Script</Button>
          </Link>
        </Stack>
        <div style={{ display: 'flex', height: '100%' }}>
          <div style={{ flexGrow: 1, height: '75vh' }}>
            <DataGrid
              rows={scripts}
              columns={[
                {
                  field: 'name',
                  headerName: 'Name',
                  flex: 1,
                  minWidth: 150,
                },
                {
                  field: 'output_type',
                  headerName: 'Output Type',
                  valueGetter: ({ value }) => outputTypeDisplayStrings[value]
                },
                {
                  field: 'language',
                  headerName: 'Language',
                  valueGetter: ({ value }) => languageDisplayStrings[value]
                },
                {
                  field: 'actions',
                  headerName: 'Actions',
                  width: 132,
                  sortable: false,
                  renderCell: (params) => (
                    <Stack direction='row' spacing={1}>
                      <Link href={`/scripts/${params.row.id}`} style={{ textDecoration: 'none' }}>
                        <Button
                          variant='contained'
                        >Edit</Button>
                      </Link>
                      <IconButton onClick={() => setDeletionScript(params.row)}>
                        <DeleteForeverIcon color='error' />
                      </IconButton>
                    </Stack>
                  )
                }
              ]}
            />
          </div>
        </div>
      </Stack>
      <Modal
        open={!!deletionScript}
        onClose={() => setDeletionScript(null)}
      >
        <Paper sx={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          width: 'min(90vw, 400px)',
          bgcolor: 'background.paper',
          boxShadow: 24,
          p: 4,
        }}>
          <Stack spacing={3}>
            <Stack direction='row' justifyContent='space-between'>
              <Typography variant='h5'>Delete Script</Typography>
              <IconButton onClick={() => setDeletionScript(null)}>
                <Close />
              </IconButton>
            </Stack>
            <Stack direction='row' spacing={3}>
              <Button variant='outlined' color='secondary' onClick={() => setDeletionScript(null)}>Cancel</Button>
              <Button variant='contained' color='error' onClick={() => deleteScript(deletionScript)}>Delete</Button>
            </Stack>
          </Stack>
        </Paper>
      </Modal>
    </>
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
