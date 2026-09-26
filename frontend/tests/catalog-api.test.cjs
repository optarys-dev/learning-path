const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const ts = require('typescript');
const { ApiError } = require('../.test-build/lib/api/ApiError');
const { parseCatalogPage } = require('../.test-build/features/catalog/model/parseCatalogPage');

// Keep the real API module and parser; replace only the HTTP boundary.
function loadCatalogApi(requestJson) {
  const filename = path.join(__dirname, '../src/features/catalog/api/getCatalogCourses.ts');
  const compiled = ts.transpileModule(fs.readFileSync(filename, 'utf8'), {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2023 },
  }).outputText;
  const exports = {};
  const requireDependency = name => {
    if (name === '../../../lib/api') return { ApiError, requestJson };
    if (name === '../model/parseCatalogPage') return { parseCatalogPage };
    throw new Error(`Unexpected dependency: ${name}`);
  };
  vm.runInNewContext(compiled, { exports, require: requireDependency, URLSearchParams }, { filename });
  return exports;
}
const emptyPage = { items: [], page: 2, pageSize: 12, totalCount: 0, totalPages: 0, hasPreviousPage: true, hasNextPage: false };

test('catalog search retains encoded search, pagination, cancellation and validated responses', async () => {
  const requests = [];
  const api = loadCatalogApi(async (url, options) => { requests.push({ url, options }); return emptyPage; });
  const signal = new AbortController().signal;
  assert.deepEqual(await api.getCatalogCourses(2, signal, undefined, '  C# & .NET  '), emptyPage);
  const url = new URL(requests[0].url, 'https://example.test');
  assert.equal(url.searchParams.get('search'), 'C# & .NET');
  assert.equal(url.searchParams.get('page'), '2');
  assert.equal(url.searchParams.get('pageSize'), '12');
  assert.equal(requests[0].options.signal, signal);
  assert.equal(requests[0].options.notifyOnUnauthenticated, false);
  await api.getCatalogCourses(1, signal, 100, '   ');
  assert.equal(new URL(requests[1].url, 'https://example.test').searchParams.has('search'), false);
  assert.equal(new URL(requests[1].url, 'https://example.test').searchParams.get('pageSize'), '100');
});

test('catalog search rejects malformed data and preserves cancellation errors', async () => {
  const malformed = loadCatalogApi(async () => ({ items: null }));
  await assert.rejects(malformed.getCatalogCourses(1, undefined, undefined, 'React'), error => error instanceof ApiError && error.kind === 'invalid-response');
  const aborted = new DOMException('Aborted', 'AbortError');
  const cancelled = loadCatalogApi(async () => { throw aborted; });
  await assert.rejects(cancelled.getCatalogCourses(1), error => error === aborted);
});
