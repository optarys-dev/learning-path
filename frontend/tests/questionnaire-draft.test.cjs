const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');
const { DRAFT_KEY, loadQuestionnaireDraft, saveQuestionnaireDraft, clearQuestionnaireDraft } = require('../.test-build/features/questionnaire/model/draft');
const { initialQuestionnaireState } = require('../.test-build/features/questionnaire/model/state');

const draft = { currentStep: 5, answers: { goal: 'backend', interests: ['python'], level: 'basics',
  knownSkills: ['django'], desiredOutcome: 'build-api', experience: 'exercises', legacyContext: null } };

function storage() {
  const entries = new Map();
  return { getItem: key => entries.get(key) ?? null, setItem: (key, value) => entries.set(key, value),
    removeItem: key => entries.delete(key) };
}

function setup(t) {
  for (const name of ['localStorage', 'sessionStorage']) {
    const previous = Object.getOwnPropertyDescriptor(globalThis, name);
    Object.defineProperty(globalThis, name, { configurable: true, value: storage() });
    t.after(() => {
      if (previous) Object.defineProperty(globalThis, name, previous);
      else delete globalThis[name];
    });
  }
}

test('draft writes and repeated hydration use sessionStorage; clearing preserves unrelated keys', t => {
  setup(t);
  sessionStorage.setItem('other', 'keep');
  saveQuestionnaireDraft(draft);
  assert.deepEqual(JSON.parse(sessionStorage.getItem(DRAFT_KEY)), { draftVersion: 3, ...draft });
  assert.equal(localStorage.getItem(DRAFT_KEY), null);
  for (let i = 0; i < 3; i++) assert.deepEqual(loadQuestionnaireDraft(), draft);
  clearQuestionnaireDraft();
  assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
  assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
  assert.equal(sessionStorage.getItem('other'), 'keep');
});

test('legacy localStorage draft is discarded, never restored or copied, and other keys survive', t => {
  setup(t);
  const otherKeys = ['codequest-language', 'codequest-theme', 'token', 'other'];
  for (const key of otherKeys) localStorage.setItem(key, 'keep');
  localStorage.setItem(DRAFT_KEY, JSON.stringify({ draftVersion: 3, ...draft }));
  assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
  assert.equal(localStorage.getItem(DRAFT_KEY), null);
  assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
  saveQuestionnaireDraft(draft);
  localStorage.setItem(DRAFT_KEY, 'stale');
  assert.deepEqual(loadQuestionnaireDraft(), draft);
  assert.equal(localStorage.getItem(DRAFT_KEY), null);
  for (const key of otherKeys) assert.equal(localStorage.getItem(key), 'keep');
});

test('malformed JSON and invalid session drafts are discarded using existing validation', t => {
  setup(t);
  const valid = { draftVersion: 3, ...draft };
  const invalid = ['{', 'null', JSON.stringify({ ...valid, draftVersion: 99 }),
    JSON.stringify({ ...valid, currentStep: 6 }), JSON.stringify({ ...valid, currentStep: -1 }),
    JSON.stringify({ ...valid, currentStep: 1.5 }),
    JSON.stringify({ ...valid, answers: { ...draft.answers, interests: ['unknown'] } }),
    JSON.stringify({ ...valid, answers: { ...draft.answers, desiredOutcome: null } })];
  for (const raw of invalid) {
    sessionStorage.setItem(DRAFT_KEY, raw);
    assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
    assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
  }
  sessionStorage.setItem(DRAFT_KEY, JSON.stringify({ ...valid, draftVersion: 2 }));
  assert.deepEqual(loadQuestionnaireDraft(), draft);
});

test('unavailable legacy storage does not block session hydration; unavailable session storage is tolerated', t => {
  setup(t);
  saveQuestionnaireDraft(draft);
  Object.defineProperty(globalThis, 'localStorage', { configurable: true, get() { throw new Error('Blocked'); } });
  assert.deepEqual(loadQuestionnaireDraft(), draft);
  Object.defineProperty(globalThis, 'sessionStorage', { configurable: true, get() { throw new Error('Blocked'); } });
  assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
  assert.doesNotThrow(() => saveQuestionnaireDraft(draft));
  assert.doesNotThrow(clearQuestionnaireDraft);
});

// Execute the actual page handlers with isolated dependencies, without a backend or browser.
function proposalHandler(name, dependencies) {
  const filename = path.join(__dirname, '../src/features/routes/pages/MyPathPage.tsx');
  const source = ts.createSourceFile(filename, fs.readFileSync(filename, 'utf8'), ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
  let handler;
  function visit(node) {
    if (name === 'save' && ts.isFunctionDeclaration(node) && node.name?.text === 'saveCurrentRoute') handler = node;
    if (name === 'cancel' && ts.isJsxAttribute(node) && node.name.getText(source) === 'onClick' &&
      node.initializer?.expression?.getText(source).includes("t('myPath.confirmDiscardProposal')")) handler = node.initializer.expression;
    ts.forEachChild(node, visit);
  }
  visit(source);
  assert.ok(handler, `Missing ${name} handler`);
  return vm.runInNewContext(`(${handler.getText(source)})`, dependencies);
}

function logoutHandler(dependencies) {
  const filename = path.join(__dirname, '../src/features/auth/context/AuthSessionProvider.tsx');
  const source = ts.createSourceFile(filename, fs.readFileSync(filename, 'utf8'), ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
  let handler;
  function visit(node) {
    if (ts.isVariableDeclaration(node) && node.name.getText(source) === 'logout') handler = node.initializer.arguments[0];
    ts.forEachChild(node, visit);
  }
  visit(source);
  assert.ok(handler, 'Missing central logout handler');
  return vm.runInNewContext(`(${handler.getText(source)})`, dependencies);
}

for (const scenario of ['draft', 'no draft', 'failure']) {
  test(`central logout with ${scenario} respects the draft lifecycle and unrelated preferences`, async t => {
    setup(t);
    if (scenario !== 'no draft') saveQuestionnaireDraft(draft);
    for (const store of [localStorage, sessionStorage]) {
      for (const key of ['codequest-language', 'codequest-theme', 'other']) store.setItem(key, 'keep');
    }
    let resolveLogout, rejectLogout;
    const request = new Promise((resolve, reject) => { resolveLogout = resolve; rejectLogout = reject; });
    let user = { id: 'A' };
    let cancelled = false;
    const logout = logoutHandler({ endSession: () => request, clearQuestionnaireDraft,
      requests: { current: { cancel: () => { cancelled = true; } } },
      setUser: value => { user = value; }, setSessionError: () => {}, setIsLoading: () => {} });
    const loggingOut = logout();
    assert.equal(sessionStorage.getItem(DRAFT_KEY) !== null, scenario !== 'no draft');
    assert.equal(user.id, 'A');
    if (scenario === 'failure') {
      rejectLogout(new Error('Logout failed'));
      await assert.rejects(loggingOut, /Logout failed/);
      assert.deepEqual(loadQuestionnaireDraft(), draft);
      assert.equal(user.id, 'A');
      assert.equal(cancelled, false);
    } else {
      resolveLogout();
      await loggingOut;
      assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
      assert.equal(user, null);
      assert.equal(cancelled, true);
      // The next user's questionnaire initializes from the same tab's storage.
      assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
    }
    for (const store of [localStorage, sessionStorage]) {
      for (const key of ['codequest-language', 'codequest-theme', 'other']) assert.equal(store.getItem(key), 'keep');
    }
  });
}

test('confirmed Cancel clears session draft; declining confirmation preserves the attempt', t => {
  setup(t);
  saveQuestionnaireDraft(draft);
  let confirmed = false;
  let pending = true;
  let navigated = false;
  const cancel = proposalHandler('cancel', { window: { confirm: () => confirmed }, t: key => key,
    clearPendingRoute: () => { pending = false; }, clearQuestionnaireDraft,
    navigate: () => { navigated = true; }, appRoutes: { savedRoutes: '/routes' } });
  cancel();
  assert.deepEqual(loadQuestionnaireDraft(), draft);
  assert.equal(pending, true);
  assert.equal(navigated, false);
  confirmed = true;
  cancel();
  assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
  assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
  assert.equal(pending, false);
  assert.equal(navigated, true);
});

for (const fails of [false, true]) {
  test(`saving ${fails ? 'fails and preserves' : 'succeeds and clears'} the session draft`, async t => {
    setup(t);
    saveQuestionnaireDraft(draft);
    let resolveSave, rejectSave, latest;
    let pending = true;
    let navigated = false;
    const request = new Promise((resolve, reject) => { resolveSave = resolve; rejectSave = reject; });
    const saveInFlight = { current: false };
    const save = proposalHandler('save', {
      state: { status: 'proposal', route: { courses: [{}] }, operation: 'idle' }, saveInFlight,
      setState: state => { latest = state; }, saveRoute: () => request, buildSaveRouteRequest: route => route,
      clearPendingRoute: () => { pending = false; }, clearQuestionnaireDraft,
      navigate: () => { navigated = true; }, appRoutes: { savedRoutes: '/routes' },
      errorMessage: error => error.message, notify: () => {}, t: key => key,
    });
    const saving = save();
    assert.deepEqual(loadQuestionnaireDraft(), draft);
    assert.equal(pending, true);
    assert.equal(navigated, false);
    if (fails) rejectSave(new Error('Save failed'));
    else resolveSave({ routeId: 'saved' });
    await saving;
    assert.equal(saveInFlight.current, false);
    if (fails) {
      assert.deepEqual(loadQuestionnaireDraft(), draft);
      assert.equal(latest.operation, 'idle');
      assert.equal(latest.saveStatus, 'error');
      assert.equal(pending, true);
      assert.equal(navigated, false);
    } else {
      assert.equal(sessionStorage.getItem(DRAFT_KEY), null);
      assert.deepEqual(loadQuestionnaireDraft(), initialQuestionnaireState);
      assert.equal(pending, false);
      assert.equal(navigated, true);
    }
  });
}
