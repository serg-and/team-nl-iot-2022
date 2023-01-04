// const theme = {
//   global: {
//     colors: {
//       brand: '#F59509',
//       focus: '#00378A'
//     }
//   }
// }
// export default theme

import { createTheme } from "@mui/material/styles"

export const appTheme = createTheme({
  palette: {
    type: 'light',
    primary: {
      main: '#F59509',
      contrastText: '#FFFFFF'
    },
    secondary: {
      main: '#00378A',
    },
  },
})
