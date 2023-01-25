import Link from 'next/link';
import { useRouter } from 'next/router';
import Image from 'next/image';
import { AppBar, Button, Container, Stack, Tab, Tabs, Toolbar } from '@mui/material';
import { useSupabaseClient } from '@supabase/auth-helpers-react';

const tabs = {
  '/scripts': 'Scripts',
  '/sessions': 'Sessions',
  '/start-fake-session': 'Start Fake Session',
}

export default function NavBar() {
  const router = useRouter()
  const supabase = useSupabaseClient()
  const tabsValue = Object.keys(tabs).includes(router.route) && router.route

  return (
    <AppBar component="nav">
      <Container maxWidth='xl'>
        <Toolbar disableGutters>
          <Stack direction='row' justifyContent='space-between' width='100%'>
            <Stack direction='row' spacing={2} alignItems='center'>
              <Link href='/scripts'>
                <Image
                  src='/teamnl-logo-black-and-white.png'
                  alt='logo'
                  width={131}
                  height={25}
                />
              </Link>
              <Tabs
                textColor='inherit'
                indicatorColor='secondary'
                value={tabsValue}
                onChange={(e, route) => router.push(route)}
                sx={{
                  color: 'white',
                  '.MuiTab-root': {
                    opacity: '0.8',
                    padding: '0px 10px'
                  },
                  '.MuiTabs-indicator': {
                    backgroundColor: 'white'
                  }
                }}
              >
                {Object.entries(tabs).map(([path, name]) => (
                  <Tab key={path} value={path} label={name} />
                ))}
              </Tabs>
            </Stack>
            <Button variant='text' onClick={logOut} sx={{ color: 'white' }}>
              Log Out
            </Button>
          </Stack>
        </Toolbar>
      </Container>
    </AppBar>
  )

  function logOut() {
    supabase.auth.signOut()
  }
}