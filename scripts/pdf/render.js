// usage: node render.js in.html out.pdf [landscape]
const { chromium } = require('playwright');
(async () => {
  const [,, inp, out] = process.argv;
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('file://' + inp, { waitUntil: 'load' });
  await page.waitForFunction(() => window.__ready === true, null, { timeout: 120000 });
  await page.pdf({ path: out, format: 'Letter', printBackground: true, preferCSSPageSize: true });
  await browser.close();
})();
