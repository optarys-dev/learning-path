const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const html = fs.readFileSync(path.join(__dirname, '../index.html'), 'utf8');
const bootstrap = html.match(/<script>([\s\S]*?)<\/script>/)[1];

function initialAppearance(values, prefersDark = false, storageBlocked = false) {
  const document = { documentElement: { dataset: {}, lang: '' } };
  vm.runInNewContext(bootstrap, { document, window: {
    localStorage: { getItem: key => { if (storageBlocked) throw new Error('Storage denied'); return values[key] ?? null; } },
    matchMedia: () => ({ matches: prefersDark }),
  } });
  return { theme: document.documentElement.dataset.theme, language: document.documentElement.lang };
}

test('initial loading screen uses saved appearance before React and respects the system theme fallback', () => {
  assert.deepEqual(initialAppearance({ 'codequest.theme': 'light', 'codequest-language': 'en-US' }, true), { theme: 'light', language: 'en' });
  assert.deepEqual(initialAppearance({ 'codequest.theme': 'dark', 'codequest-language': 'es' }), { theme: 'dark', language: 'es' });
  assert.deepEqual(initialAppearance({ 'codequest.theme': 'invalid', 'codequest-language': 'fr' }, true), { theme: 'dark', language: 'es' });
  assert.deepEqual(initialAppearance({}), { theme: 'light', language: 'es' });
});

test('blocked browser storage does not prevent the initial loading screen or application bootstrap', () => {
  assert.deepEqual(initialAppearance({}, true, true), { theme: 'dark', language: 'es' });
  assert.deepEqual(initialAppearance({}, false, true), { theme: 'light', language: 'es' });
});
