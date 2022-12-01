import { Anchor, Box, Footer, Grommet, Text } from "grommet";
import NavBar from "./NavBar";

export default function Layout({ children }) {
  return (
    <Grommet full>
      <NavBar />
      <Box as='main' pad='medium' style={{ minHeight: '100%' }} >
        {children}
      </Box>
      <Footer pad='medium' background='grey'>
        <Text>Copyright 2022 **** SOME LICENSE!!! ****</Text>
        {/* <Anchor color='focus' label='GitHub' target='_blank' href="https://github.com/serg-and/IoT-2022-next-fire"/> */}
      </Footer>
    </Grommet>
  )
}
