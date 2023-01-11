/** @type {import('next').NextConfig} */
// const nextConfig = {
//   reactStrictMode: true,
// }

// module.exports = nextConfig

const removeImports = require("next-remove-imports")();

module.exports = removeImports({
  experimental: { esmExternals: true },
  webpack: (config) => {
    config.resolve.fallback = { fs: false }
    return config
  }
  // rewrites: async () => ([
  //   {
  //     source: '/api/sessions/',
  //     destination: `/api/sessions/ok/`,
  //   },
  // ]),
});