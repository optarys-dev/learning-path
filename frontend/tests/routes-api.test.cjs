const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');
const { ApiError } = require('../.test-build/lib/api/ApiError');
const types = require('../.test-build/features/routes/model/types');
const parsers = require('../.test-build/features/routes/model/parseRoutes');

test('recommendation thumbnails survive parsing and drafting with safe fallbacks', () => {
  const { createDraftRoute } = require('../.test-build/features/routes/model/draftRoute');
  for (const imageUrl of ['https://example.test/course.jpg', null, undefined, '', 'javascript:alert(1)']) {
    const course = { courseId: 123, position: 1, title: 'Course', score: 0.95, reason: 'Reason', estimatedWeeks: 8, imageUrl };
    const route = parsers.parseRouteRecommendation({ method: 'semantic', goal: 'Learn', explanation: null,
      refinementStatus: 'skipped', model: null, courses: [course] });
    assert.ok(route);
    const draft = createDraftRoute(route);
    assert.equal(draft.courses[0].imageUrl, imageUrl?.startsWith('https://') ? imageUrl : null);
    assert.equal(draft.courses[0].courseId, '123');
    assert.equal(draft.courses[0].score, course.score);
    assert.equal(draft.courses[0].position, course.position);
  }
});

function loadRoutesApi(requestJson) {
  const filename = path.join(__dirname, '../src/features/routes/api/routes.ts');
  const output = ts.transpileModule(fs.readFileSync(filename, 'utf8'), {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2023 },
  }).outputText;
  const exports = {};
  const requireDependency = name => {
    if (name === './paths') return require('../.test-build/features/routes/api/paths');
    if (name === '@/lib/api') return { ApiError, requestJson, requestVoid: requestJson };
    if (name === '@/lib/api/apiClient') return { isAbortError: error => error?.name === 'AbortError' };
    if (name === '@/features/routes/model/types') return types;
    if (name === '@/features/routes/model/parseRoutes') return parsers;
    throw new Error('Unexpected dependency: ' + name);
  };
  vm.runInNewContext(output, { exports, require: requireDependency, URLSearchParams }, { filename });
  return exports;
}

test('route adapter distinguishes permission denial from expired session and retains server codes', async () => {
  for (const [status, kind] of [[401, 'unauthorized'], [403, 'forbidden'], [409, 'validation'], [503, 'server']]) {
    const api = loadRoutesApi(async () => { throw new ApiError({ status, code: 'stable_code', message: 'Server detail' }); });
    await assert.rejects(api.getSavedRoutes(), error => error instanceof types.RouteRequestError &&
      error.kind === kind && error.code === 'stable_code' && error.apiMessage === 'Server detail');
  }
});

test('route endpoints encode identifiers, retain cancellation and reject malformed responses', async () => {
  let requested;
  const api = loadRoutesApi(async (url, options) => { requested = { url, options }; return {}; });
  const signal = new AbortController().signal;
  await assert.rejects(api.getSavedRoute('a/b?x=1', signal), error => error.kind === 'invalid-response');
  assert.equal(requested.url, '/routes/a%2Fb%3Fx%3D1');
  assert.equal(requested.options.signal, signal);
  await assert.rejects(api.updateCourseProgress('a/b', 'c/d', true), error => error.kind === 'invalid-response');
  assert.equal(requested.url, '/routes/a%2Fb/courses/c%2Fd/progress');
  assert.equal(requested.options.json.progressPercentage, 100);
  const aborted = new DOMException('Aborted', 'AbortError');
  const cancelled = loadRoutesApi(async () => { throw aborted; });
  await assert.rejects(cancelled.getSavedRoutes(signal), error => error === aborted);
});
