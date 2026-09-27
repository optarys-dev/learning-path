const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const html = fs.readFileSync(path.join(__dirname, '../index.html'), 'utf8');
const bootstrap = html.match(/<script>([\s\S]*?)<\/script>/)[1];

function initialAppearance(values, prefersDark = false, storageBlocked = false) {
  const document = { documentElement: { dataset: {}, lang: '' } };
  vm.runInNewContext(bootstrap, { document, performance: { now: () => 0 }, window: {
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

function transitionFixture(elapsed = 0, reducedMotion = false) {
  let clock = elapsed;
  let nextId = 0;
  const timers = new Map();
  const attributes = new Set(['inert', 'aria-busy']);
  const overlay = { dataset: {}, removed: false, remove() { this.removed = true; } };
  const exports = {};
  const source = fs.readFileSync(path.join(__dirname, '../src/components/layout/startupTransition.ts'), 'utf8');
  const compiled = require('typescript').transpileModule(source, { compilerOptions: { module: require('typescript').ModuleKind.CommonJS } }).outputText;
  vm.runInNewContext(compiled, { exports, performance: { now: () => clock }, document: {
    documentElement: { dataset: { startupStartedAt: '0' } },
    getElementById: id => id === 'app-startup' ? overlay : { removeAttribute: name => attributes.delete(name) },
  }, window: {
    setTimeout: (callback, delay) => { const id = ++nextId; timers.set(id, { callback, due: clock + delay }); return id; },
    clearTimeout: id => timers.delete(id),
    matchMedia: () => ({ matches: reducedMotion }),
  } });
  function advance(duration) {
    const until = clock + duration;
    while (true) {
      const next = [...timers].filter(([, timer]) => timer.due <= until).sort((a, b) => a[1].due - b[1].due)[0];
      if (!next) break;
      timers.delete(next[0]); clock = next[1].due; next[1].callback();
    }
    clock = until;
  }
  return { start: exports.finishStartup, advance, overlay, attributes, timers };
}

test('fast startup remains visible before fading and unlocks the page only after the overlay leaves', () => {
  const fixture = transitionFixture(100);
  fixture.start();
  fixture.advance(999);
  assert.equal(fixture.overlay.dataset.state, undefined);
  assert.equal(fixture.attributes.has('inert'), true);
  fixture.advance(1);
  assert.equal(fixture.overlay.dataset.state, 'leaving');
  fixture.advance(239);
  assert.equal(fixture.overlay.removed, false);
  fixture.advance(1);
  assert.equal(fixture.overlay.removed, true);
  assert.equal(fixture.attributes.size, 0);
});

test('slow startup does not add a second waiting period and reduced motion skips the fade', () => {
  const slow = transitionFixture(2500);
  slow.start(); slow.advance(0);
  assert.equal(slow.overlay.dataset.state, 'leaving');
  slow.advance(240);
  assert.equal(slow.overlay.removed, true);
  const reduced = transitionFixture(0, true);
  reduced.start(); reduced.advance(1100);
  assert.equal(reduced.overlay.removed, true);
});

test('Strict Mode cleanup cancels obsolete timers and a second setup completes normally', () => {
  const fixture = transitionFixture();
  const cleanup = fixture.start();
  cleanup();
  assert.equal(fixture.timers.size, 0);
  fixture.advance(50);
  fixture.start(); fixture.advance(1290);
  assert.equal(fixture.overlay.removed, true);
  assert.equal(fixture.attributes.size, 0);
});
