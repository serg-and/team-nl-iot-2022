import fs from "fs";
import { Command } from "commander";
import cliProgress from "cli-progress";
import colors from "ansi-colors";
import Papa from "papaparse";
import { languages, startScript } from "../core/runScripts.mjs";

const suppportedLanguages = Object.keys(languages)

const program = new Command();

program
  .name('test-script')
  .description('Test scripts locally before uploading')
  .version('0.1.0')
  .option('-s, --script <script>', 'path to the script to test')
  .option('-c, --csv <csv>', 'path to CSV file containing data')
  .option(
    '-l, --language <extension>',
    `script language (script extension by default) [${suppportedLanguages.join(', ')}]`
  )
  .usage('-- -s <script> -c <csv> [options]')
  .addHelpText(
    'afterAll',
    '\nRead the documentation: https://iot.dev.hihva.nl/2022-2023-sep-jan/group-project/team-nl-beachvolley-data-collection/features/writing-scripts/'
  )

program.parse()

const { script, csv, language = script?.split('.').at(-1)?.toLowerCase() } = program.opts()

if (!script || !csv) {
  program.help()
  process.exit(1)
}

if (!suppportedLanguages.includes(language)) {
  console.log('script language not supported')
  console.log(`supported languages: [${suppportedLanguages.join(', ')}]`)
  console.log('or manually set the script language option using -l')
  process.exit(1)
}

if (!fs.existsSync(script)) {
  console.log(`script doesn't exist: ${script}`)
  console.log('are you sure the path is correct?')
  process.exit(1)
}

if (!fs.existsSync(csv)) {
  console.log(`CSV file doesn't exist: ${csv}`)
  console.log('are you sure the path is correct?')
  process.exit(1)
}
const csvContent = fs.createReadStream(csv)

Papa.parse(csvContent, {
  delimiter: ',',
  fastMode: true,
  complete: onCsvParsed,
  error: (err) => console.log('err', err)
})

async function onCsvParsed(parsed) {
  const keys = parsed.data[0]
  const rows = parsed.data.slice(1)
  const results = []

  const { sendMessage, kill } = startScript(script, language, (result) => results.push(result))

  const bar = new cliProgress.SingleBar({
    format: 'Progress [' + colors.cyan('{bar}') + '] {percentage}% | {value}/{total} Rows | ETA: {eta}s ',
  })
  bar.start(rows.length, 1)

  for (let i=0; i < rows.length; i++) {
    const json = {}
    keys.forEach((key, j) => json[key] = Number(rows[i][j]))
    
    sendMessage(JSON.stringify(json))
    
    bar.update(i + 1)

    // first message takes long due to cold boot of startScript
    if (i === 0) await sleep(1000)
    // prevents multiple messages from being send within one stdin linenp
    else await sleep(5)
  }
  bar.stop()
  kill()
  
  console.log('Results from script:')
  console.log(results)
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
