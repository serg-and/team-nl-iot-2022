import { useSupabaseClient, useSession } from '@supabase/auth-helpers-react'
import { Auth, ThemeSupa } from '@supabase/auth-ui-react'
import { Footer } from 'grommet'
import { Box } from '@mui/material'
import NavBar from './NavBar'

export default function Layout({ children }) {
  const session = useSession()
  const supabase = useSupabaseClient()

  if (!session) return <Auth supabaseClient={supabase} appearance={{ theme: ThemeSupa }} theme="dark" />

  return (
    <Box sx={{ width: '100vw', height: '100vh' }}>
      <NavBar />
      <Box component='main' sx={{
        marginTop: '64px',
        padding: 3,
        minHeight: '100%'
      }}>
        {children}
      </Box>
      <Footer pad='medium' background='grey'>
        Copyright 2022 **** SOME LICENSE!!! ****
        {/* <Anchor color='focus' label='GitHub' target='_blank' href="https://github.com/serg-and/IoT-2022-next-fire"/> */}
      </Footer>
    </Box>
  )
}
