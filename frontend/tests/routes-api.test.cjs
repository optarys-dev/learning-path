const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');
const { ApiError } = require('../.test-build/lib/api/ApiError');
const types = require('../.test-build/features/routes/model/types');
const parsers = require('../.test-build/features/routes/model/parseRoutes');

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
