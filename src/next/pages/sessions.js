import { useEffect, useState } from "react";
import { useSupabaseClient } from "@supabase/auth-helpers-react";
import { IconButton, Modal, Paper, Stack, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { Download } from '@mui/icons-material';
import { getFormattedDateTime } from "../core/utils.mjs";
import slugify from "slugify";

export default function Sessions() {
  const supabase = useSupabaseClient()
  const [sessions, setSessions] = useState([])
  const [downloadModal, setDownloadModal] = useState()

  useEffect(() => {
    async function loadData() {
      const { data, error } = await supabase
        .from('sessions')
        .select('id, name, ended_at, team_member_ids')
        .not('ended_at', 'is', null)
        .order('id', { ascending: false })
      
      if (data) setSessions(data)
      if (error) console.error(error)
    }
    loadData()
  }, [])

  return (
    <>
      <Stack spacing={3}>
        <Typography variant="h5">Previous Sessions</Typography>
        <div style={{ display: 'flex', height: '100%' }}>
          <div style={{ flexGrow: 1, height: '75vh' }}>
            <DataGrid
              rows={sessions}
              columns={[
                {
                  field: 'name',
                  headerName: 'Name',
                  flex: 1,
                  minWidth: 150,
                },
                {
                  field: 'ended_at',
                  headerName: 'Ended',
                  flex: 0.4,
                  valueGetter: ({ value }) =>
                    getFormattedDateTime(new Date(value), 'short')
                },
                {
                  field: 'actions',
                  headerName: 'Actions',
                  align: 'center',
                  width: 90,
                  sortable: false,
                  renderCell: (params) => (
                    <IconButton onClick={() => openDownloadSession(params.row)}>
                      <Download />
                    </IconButton>
                  )
                }
              ]}
            />
          </div>
        </div>
      </Stack>
      {downloadModal}
    </>
  )

  async function openDownloadSession(session) {
    const { data: sessionMembers, error } = await supabase
      .from('team_members')
      .select('id, name')
      .in('id', session.team_member_ids)

    function onDownload(member) {
      const filename = slugify(`${member.name} - ${session.name}.json`)
      downloadSessionMember(session.id, member.id, filename)
    }

    setDownloadModal(
      <Modal
        open={true}
        onClose={() => setDownloadModal(null)}
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
          <Typography variant='h6'>{session.name}</Typography>
            {sessionMembers.map(member => (
              <Stack
                key={member.id}
                direction='row'
                justifyContent='space-between'
                alignItems='center'
              >
                <Typography>{member.name}</Typography>
                <IconButton onClick={() => onDownload(member)}>
                  <Download />
                </IconButton>
              </Stack>
            ))}
            {!sessionMembers.length && (
              <Typography>Session had no members</Typography>
            )}
          </Stack>
        </Paper>
      </Modal>
    )
  }
}

function downloadSessionMember(sessionId, memberId, filename) {
  location = `/api/download/${sessionId}_${memberId}.json?filename=${filename}`
}
