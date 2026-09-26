const { test } = require('node:test');
const assert = require('node:assert/strict');
const { parseCatalogPage } = require('../.test-build/features/catalog/model/parseCatalogPage');
const { parseSession } = require('../.test-build/features/auth/model/parseSession');
const { parseSavedRoute } = require('../.test-build/features/routes/model/parseRoutes');
const { parseApiError } = require('../.test-build/lib/api/parseProblemDetails');
const { safeExternalUrl } = require('../.test-build/lib/urls');
const catalogCourse = { courseId: 1, title: 'React', slug: 'react', level: null, imageUrl: 'https://example.com/image.png', imageAlt: 'React', courseUrl: 'https://example.com/react' };
const page = { items: [catalogCourse], page: 1, pageSize: 12, totalCount: 1, totalPages: 1, hasNextPage: false, hasPreviousPage: false };
const session = { id: 'google-subject', userId: 'internal-id', username: 'Ana', displayName: null, avatar: null, avatarUrl: null, provider: 'Google', isNewUser: true };
const route = { routeId: 'route-1', goal: 'Learn', recommendationMethod: 'manual', explanation: null, createdAt: '2026-09-26T12:00:00Z', courses: [{ courseId: 1, position: 1, title: 'React' }] };

test('catalog accepts its documented nullable level and rejects malformed items or pagination', () => {
  assert.deepEqual(parseCatalogPage(page), page);
  for (const invalid of [null, {}, { ...page, page: 0 }, { ...page, items: [{ ...catalogCourse, courseId: '1' }] }, { ...page, items: [null] }]) assert.equal(parseCatalogPage(invalid), null);
});
test('untrusted external protocols never reach catalog links and images', () => {
  for (const url of ['javascript:alert(1)', 'data:text/html,hello', 'file:///tmp', '//example.com', '', null]) assert.equal(safeExternalUrl(url), null);
  const result = parseCatalogPage({ ...page, items: [{ ...catalogCourse, imageUrl: 'javascript:alert(1)', courseUrl: 'data:text/html,hello' }] });
  assert.equal(result.items[0].imageUrl, ''); assert.equal(result.items[0].courseUrl, '');
});
test('session accepts either provider and nullable display names; rejects unknown identities', () => {
  assert.deepEqual(parseSession(session), session);
  assert.equal(parseSession({ ...session, provider: 'Discord' }).provider, 'Discord');
  for (const invalid of [{ ...session, userId: '' }, { ...session, provider: 'Other' }, { ...session, isNewUser: 'false' }, { ...session, displayName: 2 }]) assert.equal(parseSession(invalid), null);
});
test('saved routes normalize numeric IDs and absent progress, but reject invalid supplied progress and dates', () => {
  const parsed = parseSavedRoute(route);
  assert.equal(parsed.courses[0].courseId, '1'); assert.equal(parsed.courses[0].progressPercentage, 0);
  for (const progressPercentage of ['bad', null, -1, 101]) assert.equal(parseSavedRoute({ ...route, courses: [{ ...route.courses[0], progressPercentage }] }), null);
  assert.equal(parseSavedRoute({ ...route, createdAt: 'bad-date' }), null);
  assert.equal(parseSavedRoute({ ...route, courses: [null] }), null);
  assert.equal(parseSavedRoute({ ...route, courses: [{ ...route.courses[0], courseId: Number.MAX_SAFE_INTEGER + 1 }] }), null);
  assert.equal(parseSavedRoute({ ...route, courses: [{ ...route.courses[0], position: 1.5 }] }), null);
});
test('ProblemDetails retains server detail and only valid field errors', async () => {
  const error = await parseApiError(new Response(JSON.stringify({ title: 'Invalid', detail: 'Name required', code: 'validation', traceId: 'trace', errors: { goal: ['Required', 5], other: false } }), { status: 422 }));
  assert.equal(error.message, 'Name required'); assert.equal(error.status, 422); assert.equal(error.traceId, 'trace'); assert.deepEqual(error.validationErrors, { goal: ['Required'] });
});
test('non-JSON server failures are still represented as HTTP errors', async () => {
  const error = await parseApiError(new Response('<html>Bad gateway</html>', { status: 502 }));
  assert.equal(error.status, 502); assert.equal(error.kind, 'http');
});
test('cancellation while reading an error response remains a cancellation', async () => {
  const cancelled = new DOMException('Aborted', 'AbortError');
  await assert.rejects(parseApiError({ status: 401, json: async () => { throw cancelled; } }), error => error === cancelled);
});
