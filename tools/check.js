// Screenshot the site at desktop and phone width and report errors.
// Usage: node tools/check.js [outdir]   (needs Playwright + Chromium)
const { chromium } = require('playwright');
const path = require('path');
(async () => {
  const out = process.argv[2] || '/tmp';
  const url = 'file://' + path.resolve(__dirname, '..', 'index.html');
  const b = await chromium.launch(); const errs = [];
  for (const [name, vp] of [['desktop', { width: 1440, height: 900 }], ['phone', { width: 390, height: 844 }]]) {
    const p = await b.newPage({ viewport: vp });
    p.on('pageerror', e => errs.push(name + ': ' + e.message));
    await p.goto(url); await p.waitForTimeout(3000);
    await p.screenshot({ path: path.join(out, `leobolt-${name}.png`) });
    const tiles = await p.$$eval('.t', t => t.length);
    const sw = await p.evaluate(() => document.documentElement.scrollWidth);
    console.log(`${name}: ${tiles} tiles, page width ${sw}px`);
  }
  console.log(errs.length ? 'ERRORS:\n' + errs.join('\n') : 'No script errors');
  await b.close();
})();
