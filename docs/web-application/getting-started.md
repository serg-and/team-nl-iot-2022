# Getting Started
The Web Application is written in Next JS, this is a Node JS framework made for react applications.

## System Requirements
- Node.js 14.6.0 or newer
- MacOS, Windows (using WSL), and Linux are supported

## Running the web application
First clone the project repository ---- ?? Do we have documentation for this ?? ----, the source code of the web application is housed under `src/next`.
To start the web application run:
```shell
npm i
npm run dev
```
This starts a local development server for testing.


## Deployment
To start the web application in production mode run:
```shell
# install all depenencies
npm i
# create a build of the web application
npm run build
# start the created build
npm run start
```
This generates an optimized version of your application for production. This standard output includes:

- HTML files for pages using getStaticProps or Automatic Static Optimization
- CSS files for global styles or for individually scoped styles
- JavaScript for pre-rendering dynamic content from the Next.js server
- JavaScript for interactivity on the client-side through React

This output is generated inside the .next folder:

- `.next/static/chunks/pages` – Each JavaScript file inside this folder relates to the route with the same name. For example, .next/static/chunks/pages/about.js would be the JavaScript file loaded when viewing the /about route in your application
- `.next/static/media` – Statically imported images from next/image are hashed and copied here
- `.next/static/css` – Global CSS files for all pages in your application
- `.next/server/pages` – The HTML and JavaScript entry points prerendered from the server. The .nft.json files are created when Output File Tracing is enabled and contain all the file paths that depend on a given page.
- `.next/server/chunks` – Shared JavaScript chunks used in multiple places throughout your application
- `.next/cache` – Output for the build cache and cached images, responses, and pages from the Next.js server. Using a cache helps decrease build times and improve performance of loading images
All JavaScript code inside .next has been compiled and browser bundles have been minified to help achieve the best performance and support all modern browsers.

## APIs
Read the [API Documentation](api-documentation)

