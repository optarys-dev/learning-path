const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');
const provider = require('../.test-build/features/auth/model/loginProvider');
const { es } = require('../.test-build/i18n/locales/es');
const { en } = require('../.test-build/i18n/locales/en');

function setup(t) {
  const previous = Object.getOwnPropertyDescriptor(globalThis, 'sessionStorage');
  const entries = new Map();
  Object.defineProperty(globalThis, 'sessionStorage', { configurable: true, value: {
    getItem: key => entries.get(key) ?? null, setItem: (key, value) => entries.set(key, value),
    removeItem: key => entries.delete(key),
  } });
  t.after(() => {
    if (previous) Object.defineProperty(globalThis, 'sessionStorage', previous);
    else delete globalThis.sessionStorage;
  });
  return entries;
}

function loginStarters() {
  const filename = path.join(__dirname, '../src/features/auth/api/session.ts');
  const source = fs.readFileSync(filename, 'utf8').replaceAll('import.meta.env', 'testEnv');
  const code = ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS } }).outputText;
  const exports = {};
  const urls = [];
  vm.runInNewContext(code, { exports, URL, testEnv: {},
    window: { location: { origin: 'https://frontend.test', assign: url => urls.push(url) } },
    require: name => {
      if (name === '@/features/auth/model/loginProvider') return provider;
      if (name === '@/config/navigation') return { appRoutes: { loginCallback: '/login/callback' } };
      if (name === '@/config/api') return { apiUrl: 'https://backend.test' };
      return {};
    },
  });
  return { ...exports, urls };
}

test('real login starters select the correct callback copy in ES/EN without changing redirect URLs', t => {
  setup(t);
  const login = loginStarters();
  for (const [start, name, key, spanish, english] of [
    [login.startDiscordLogin, 'discord', 'welcome.connecting', 'Conectando con Discord…', 'Connecting to Discord…'],
    [login.startGoogleLogin, 'google', 'login.googleConnecting', 'Conectando con Google…', 'Connecting to Google…'],
  ]) {
    start();
    const url = new URL(login.urls.at(-1));
    assert.equal(url.pathname, '/auth/' + name);
    assert.equal(url.searchParams.get('returnUrl'), '/login/callback');
    assert.equal(provider.loginLoadingTranslationKey(), key);
    // Reading is repeatable for React StrictMode; cleanup happens after mounting.
    assert.equal(provider.loginLoadingTranslationKey(), key);
    const [section, message] = key.split('.');
    assert.equal(es[section][message], spanish);
    assert.equal(en[section][message], english);
  }
});

test('callback hint cleanup leaves other storage intact and unknown providers use neutral copy', t => {
  const entries = setup(t);
  assert.equal(provider.loginLoadingTranslationKey(), 'login.completingSignIn');
  provider.rememberLoginProvider('Discord');
  const key = [...entries.keys()][0];
  entries.set(key, 'unexpected');
  assert.equal(provider.loginLoadingTranslationKey(), 'login.completingSignIn');
  entries.set('unrelated', 'keep');
  provider.clearLoginProvider();
  assert.equal(entries.get('unrelated'), 'keep');
  assert.equal(entries.has(key), false);
  assert.equal(provider.loginLoadingTranslationKey(), 'login.completingSignIn');
  assert.equal(es.login.completingSignIn, 'Completando inicio de sesión…');
  assert.equal(en.login.completingSignIn, 'Completing sign in…');
});

test('unavailable storage falls back to neutral copy without blocking OAuth launch', t => {
  setup(t);
  Object.defineProperty(globalThis, 'sessionStorage', { configurable: true, get() { throw new Error('Blocked'); } });
  const login = loginStarters();
  assert.doesNotThrow(login.startDiscordLogin);
  assert.doesNotThrow(login.startGoogleLogin);
  assert.equal(login.urls.length, 2);
  assert.equal(provider.loginLoadingTranslationKey(), 'login.completingSignIn');
  assert.doesNotThrow(provider.clearLoginProvider);
});
