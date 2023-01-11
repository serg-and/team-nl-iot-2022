import { createBrowserSupabaseClient } from '@supabase/auth-helpers-nextjs'
import { SessionContextProvider } from '@supabase/auth-helpers-react'
import { useState } from 'react'
import Layout from '../components/Layout'
import '../styles/globals.css'
import { CssBaseline, ThemeProvider } from '@mui/material'
import { appTheme } from '../core/theme'
import { SnackbarProvider } from 'notistack'


function MyApp({ Component, pageProps }) {
  const [supabaseClient] = useState(() => createBrowserSupabaseClient())
  const [alerts, setAlerts] = useState([])

  return (
    <SessionContextProvider
      supabaseClient={supabaseClient}
      initialSession={pageProps.initialSession}
    >
      <ThemeProvider theme={appTheme}>
        <CssBaseline enableColorScheme />
        <SnackbarProvider maxSnack={3}>
          <Layout>
            <Component {...pageProps} />
          </Layout>
        </SnackbarProvider>
      </ThemeProvider>
    </SessionContextProvider>
  )

  function pushAlert(alertProps) {
    alertProps.id = Date.now() // simple unique
    alerts.push(alertProps)
    setAlerts([...alerts])
  }

  function popAlert(alertId) {
    const alert = alerts.find(i => i.id === alertId)
    if (!alert) return
    alerts.splice(alerts.indexOf(alert), 1)
    setAlerts([...alerts])
  }
}

export default MyApp
