import { Box, Header, Text } from 'grommet';
import Link from 'next/link';
import { useRouter } from 'next/router';

export default function NavBar() {
  const router = useRouter()

  const pageButton = (name, route) => (
    <Link href={route} style={{color: router.route === route ? "orange" : "black"}}>
      {name}
    </Link>
  )

  return (
    <Header
      pad='medium'
      border={{ color: 'focus', side: 'bottom', size: 'small' }}
      style={{ flex: '0 1 auto' }}
    >
      <Box direction='row' gap='large' align='end'>
        <Link href='/'>
          <Box direction='row' focusIndicator={false}>
            APP NAME/LOGO HERE
          </Box>
        </Link>
        <Box direction='row' gap='medium'>
          {pageButton('Upload', '/upload')}
          {pageButton('Start Fake Session', '/start-fake-session')}
        </Box>
      </Box>
    </Header>
  )
}