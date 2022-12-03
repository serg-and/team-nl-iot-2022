import { createBrowserSupabaseClient } from '@supabase/auth-helpers-nextjs'
import { SessionContextProvider } from '@supabase/auth-helpers-react'
import { useState } from 'react'
import Alerts, { AlertsContext } from '../components/Alerts'
import Layout from '../components/Layout'
import '../styles/globals.css'

function MyApp({ Component, pageProps }) {
  const [supabaseClient] = useState(() => createBrowserSupabaseClient())

  const [alerts, setAlerts] = useState([])

  return (
    <SessionContextProvider
      supabaseClient={supabaseClient}
      initialSession={pageProps.initialSession}
    >
      <AlertsContext.Provider value={pushAlert}>
        <Layout>
          <Component {...pageProps} />
        </Layout>
        <Alerts alerts={alerts} popAlert={popAlert} />
      </AlertsContext.Provider>
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
