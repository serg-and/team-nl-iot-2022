import { Box, Text } from "grommet"
import { createContext } from "react"

export const AlertsContext = createContext()

export default ({ alerts, popAlert }) => {
  return (
    <Box 
      pad='medium'
      gap='small'
      style={{
        position: 'absolute',
        bottom: '0px',
        right: '0px',
      }}
    >
      {alerts.map(alert =>
        <Box
          key={alert.id}
          direction='row'
          gap='medium'
          justify='between'
          align='center'
          background='red'
          pad='small'
          style={{ color: 'white' }}
        >
          {alert.content}
          <Text onClick={() => popAlert(alert.id)}>X</Text>
        </Box>
      )}
    </Box>
  )
}
