const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
test('every referenced design token has a declaration', () => {
  function files(directory) { return fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => entry.isDirectory() ? files(path.join(directory, entry.name)) : entry.name.endsWith('.css') ? [path.join(directory, entry.name)] : []); }
  const sheets = files(path.join(__dirname, '../src')).map(file => fs.readFileSync(file, 'utf8'));
  const declared = new Set(sheets.flatMap(css => [...css.matchAll(/(--cq-[\w-]+)\s*:/g)].map(match => match[1])));
  const references = new Set(sheets.flatMap(css => [...css.matchAll(/var\((--cq-[\w-]+)/g)].map(match => match[1])));
  assert.deepEqual([...references].filter(token => !declared.has(token)), []);
});
