import { Box, Header, Text } from 'grommet';
import Link from 'next/link';
import { useRouter } from 'next/router';
import Image from 'next/image';
import styles from '../styles/NavBar.module.css';

export default function NavBar() {
  const router = useRouter()

  const pageButton = (name, route) => (
    <Box border={{ side: 'bottom', size: 'small', color: router.route === route ? 'white' : 'transparent' }}>
      <Link href={route} className={styles.pageLink}>
        <Text color='white' weight={600}>{name}</Text>
      </Link>
    </Box>
  )

  return (
    <Header
      className={styles.container}
      pad='small'
      border={{ color: 'focus', side: 'bottom', size: 'small' }}
      style={{ flex: '0 1 auto' }}
    >
      <Box direction='row' gap='large' align='center'>
        <Link href='/scripts'>
          <Image
            src={'/splash_image_new.png'}
            width={80}
            height={80}
          />
        </Link>
        <Box direction='row' gap='medium'>
          {pageButton('Scripts', '/scripts')}
          {pageButton('Start Fake Session', '/start-fake-session')}
        </Box>
      </Box>
    </Header>
  )
}