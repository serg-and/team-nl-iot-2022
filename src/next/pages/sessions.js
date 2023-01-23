import { useEffect, useState } from "react";
import { useSupabaseClient } from "@supabase/auth-helpers-react";
import { IconButton, Stack, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { Download } from '@mui/icons-material';
import { getFormattedDateTime } from "../core/utils.mjs";

export default function Sessions() {
  const supabase = useSupabaseClient()
  const [sessions, setSessions] = useState([])

  useEffect(() => {
    async function loadData() {
      const { data, error } = await supabase
        .from('sessions')
        .select('id, name, ended_at')
        .not('ended_at', 'is', null)
        .order('id', { ascending: false })
      
      if (data) setSessions(data)
      if (error) console.error(error)
    }
    loadData()
  }, [])

  return (
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
                  <IconButton onClick={() => downloadSession(params.row)}>
                    <Download />
                  </IconButton>
                )
              }
            ]}
          />
        </div>
      </div>
    </Stack>
  )

  function downloadSession(session) {
    alert(`Download session:\n${session.id}`)
  }
}