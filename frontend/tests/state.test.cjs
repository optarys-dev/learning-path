const { test } = require('node:test');
const assert = require('node:assert/strict');
const { createLatestRequest } = require('../.test-build/lib/api/latestRequest');
const { replaceSavedRouteCourse } = require('../.test-build/features/routes/model/editSavedRoute');
const { readRouteCourseLocalState, saveCourseNote, setCoursePriority, routeStats } = require('../.test-build/features/routes/model/routeLocalState');
const { createSavedRouteDraft, buildUpdateRouteRequest, loadPendingRoute } = require('../.test-build/features/routes/model/draftRoute');

test('a newer session request cancels and invalidates an older response', async () => {
  const requests = createLatestRequest(); const old = requests.start(); const latest = requests.start();
  await Promise.resolve();
  assert.equal(old.signal.aborted, true); assert.equal(old.isCurrent(), false); assert.equal(latest.isCurrent(), true);
  requests.cancel(); assert.equal(latest.signal.aborted, true); assert.equal(latest.isCurrent(), false);
});
const route = { routeId: 'r', goal: 'Draft name', recommendationMethod: 'manual', explanation: 'Draft text', createdAt: '2026-09-26', courses: [{ courseId: '1', uiKey: 'slot-1', position: 1, title: 'Old', reason: 'Old reason', progressPercentage: 100, imageUrl: null, courseUrl: null }, { courseId: '2', uiKey: 'slot-2', position: 2, title: 'Other', reason: null, progressPercentage: 0, imageUrl: null, courseUrl: null }] };
const alternative = { courseId: 3, title: 'New', imageUrl: 'https://example.com/image', courseUrl: 'https://example.com/course' };
test('replacement stages an immutable draft, retains its order and resets inherited progress and reason', () => {
  const next = replaceSavedRouteCourse(route, 'slot-1', alternative);
  assert.equal(route.courses[0].courseId, '1'); assert.equal(next.goal, route.goal); assert.equal(next.explanation, route.explanation);
  assert.equal(next.courses[0].uiKey, 'slot-1'); assert.equal(next.courses[0].position, 1);
  assert.equal(next.courses[0].progressPercentage, 0); assert.equal(next.courses[0].reason, null);
  assert.equal(next.courses[1], route.courses[1]);
  assert.deepEqual(buildUpdateRouteRequest(next).courses.map(course => course.courseId), ['3', '2']);
});
test('a duplicate replacement cannot duplicate a course in the draft', () => {
  assert.equal(replaceSavedRouteCourse(route, 'slot-1', { ...alternative, courseId: 2 }), route);
});
test('saved draft respects server order, stable keys and empty-route statistics', () => {
  const draft = createSavedRouteDraft({ ...route, courses: [...route.courses].reverse() });
  assert.deepEqual(draft.courses.map(course => course.uiKey), ['1', '2']);
  assert.equal(routeStats({ ...route, courses: [] }, { notes: {}, priorities: {} }).percentage, 0);
});
test('corrupt storage entries are discarded independently without losing valid notes', () => {
  const previous = global.window;
  try {
    global.window = { localStorage: { getItem: () => JSON.stringify({ notes: { valid: { content: 'Hello', updatedAt: '2026-09-26' }, bad: { content: 1, updatedAt: 'wrong' }, date: { content: 'note', updatedAt: 'wrong' } }, priorities: { valid: 'high', bad: 'urgent' } }) } };
    assert.deepEqual(readRouteCourseLocalState(), { notes: { valid: { content: 'Hello', updatedAt: '2026-09-26' } }, priorities: { valid: 'high' } });
    global.window.localStorage.getItem = () => { throw new Error('Storage blocked'); };
    assert.deepEqual(readRouteCourseLocalState(), { notes: {}, priorities: {} });
  } finally { global.window = previous; }
});
test('a failed storage write is never announced as successful', () => {
  const previous = global.window; let notifications = 0;
  try {
    global.window = { localStorage: { getItem: () => null, setItem: () => { throw new Error('Quota exceeded'); } }, dispatchEvent: () => notifications++ };
    assert.throws(() => saveCourseNote('r', '1', 'Keep this text'), /Quota exceeded/);
    assert.throws(() => setCoursePriority('r', '1', 'high'), /Quota exceeded/);
    assert.equal(notifications, 0);
  } finally { global.window = previous; }
});
test('pending proposals cannot be read by a different account', () => {
  const previous = global.sessionStorage;
  try {
    global.sessionStorage = { getItem: () => JSON.stringify({ userId: 'someone-else', route: {} }) };
    assert.equal(loadPendingRoute('current-user'), null);
  } finally { global.sessionStorage = previous; }
});
