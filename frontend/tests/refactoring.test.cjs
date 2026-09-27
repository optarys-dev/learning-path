const { test } = require('node:test');
const assert = require('node:assert/strict');
const { moveCourseTo } = require('../.test-build/features/routes/model/reorderCourses');
const { toggleSelectedCourse, moveSelectedCourse, buildManualRouteRequest } = require('../.test-build/features/routes/model/manualRoute');
const { routeLimits, routeStorage } = require('../.test-build/features/routes/model/constants');
const { routeErrorDescriptor } = require('../.test-build/features/routes/model/routeError');
const { RouteRequestError } = require('../.test-build/features/routes/model/types');
const { appRoutes } = require('../.test-build/config/navigation');
const { isStepComplete, toggleTechnology } = require('../.test-build/features/questionnaire/model/validation');
const { replaceSavedRouteCourse } = require('../.test-build/features/routes/model/editSavedRoute');

test('course replacement swaps categories and images without inheriting the old course progress', () => {
  const original = { courses: [{ uiKey: 'slot-1', courseId: '1', title: 'Old', imageUrl: 'https://example.test/old.png', catalogKinds: ['free'], progressPercentage: 100, reason: 'Old reason' }] };
  const replacement = { courseId: 2, title: 'New', imageUrl: 'https://example.test/new.png', courseUrl: 'https://example.test/new', catalogKinds: ['pro-exclusive'] };
  const updated = replaceSavedRouteCourse(original, 'slot-1', replacement);
  assert.deepEqual(updated.courses[0].catalogKinds, ['pro-exclusive']);
  assert.equal(updated.courses[0].imageUrl, replacement.imageUrl);
  assert.equal(updated.courses[0].uiKey, 'slot-1');
  assert.equal(updated.courses[0].progressPercentage, 0);
  assert.equal(updated.courses[0].reason, null);
  assert.deepEqual(original.courses[0].catalogKinds, ['free']);
});

test('drag reordering moves either direction without mutating items or duplicating them', () => {
  const courses = ['a', 'b', 'c'].map(uiKey => ({ uiKey, title: uiKey }));
  assert.deepEqual(moveCourseTo(courses, 'a', 'c').map(item => item.uiKey), ['b', 'c', 'a']);
  assert.deepEqual(moveCourseTo(courses, 'c', 'a').map(item => item.uiKey), ['c', 'a', 'b']);
  assert.deepEqual(courses.map(item => item.uiKey), ['a', 'b', 'c']);
  assert.equal(moveCourseTo(courses, 'missing', 'a'), courses);
  assert.equal(moveCourseTo(courses, 'a', 'a'), courses);
  assert.equal(moveCourseTo(courses, 'a', 'b')[1], courses[0]);
});

test('manual selection enforces the limit and always allows removal', () => {
  const full = Array.from({ length: routeLimits.courses }, (_, courseId) => ({ courseId }));
  assert.equal(toggleSelectedCourse(full, { courseId: 99 }), full);
  const removed = toggleSelectedCourse(full, { courseId: 0 });
  assert.equal(removed.length, routeLimits.courses - 1);
  const restored = toggleSelectedCourse(removed, full[0]);
  assert.equal(restored.length, routeLimits.courses);
  assert.equal(new Set(restored.map(item => item.courseId)).size, restored.length);
  assert.equal(full.length, routeLimits.courses);
});

test('manual ordering handles boundaries and its request preserves the chosen order', () => {
  const selected = [{ courseId: 1 }, { courseId: 2 }];
  assert.equal(moveSelectedCourse(selected, -1, 1), selected);
  assert.equal(moveSelectedCourse(selected, 0, -1), selected);
  assert.equal(moveSelectedCourse(selected, 1, 1), selected);
  const reordered = moveSelectedCourse(selected, 0, 1);
  assert.deepEqual(selected.map(course => course.courseId), [1, 2]);
  assert.deepEqual(buildManualRouteRequest('  My goal  ', '   ', reordered), {
    goal: 'My goal', explanation: null, recommendationMethod: 'manual-v1',
    courses: [{ courseId: '2', reason: null }, { courseId: '1', reason: null }],
  });
});

test('route errors localize stable server codes and safely fall back for unknown errors', () => {
  assert.equal(routeErrorDescriptor(new RouteRequestError('validation', 'Spanish server prose', 'course_unavailable')).translationKey, 'myPath.errors.courseUnavailable');
  assert.equal(routeErrorDescriptor(new RouteRequestError('server', 'Private detail', 'unknown')).translationKey, 'myPath.errors.server');
  assert.equal(routeErrorDescriptor(new RouteRequestError('unauthorized')).kind, 'unauthorized');
  assert.equal(routeErrorDescriptor(new Error('unexpected')).translationKey, 'myPath.errors.http');
});

test('route addresses encode IDs and existing storage remains compatible', () => {
  assert.equal(appRoutes.savedRoute('a/b?next=x'), '/my-path/a%2Fb%3Fnext%3Dx');
  assert.deepEqual(routeStorage, {
    courseState: 'learning-path:course-state', pendingRecommendation: 'learning-path:pending-recommendation:v1',
    courseStateChanged: 'learning-path:course-state-change',
  });
});

test('questionnaire validation retains optional questions and required answers', () => {
  const answers = { goal: null, interests: [], level: null, knownSkills: [], desiredOutcome: null, experience: null, legacyContext: null };
  assert.equal(isStepComplete(0, answers), false);
  assert.equal(isStepComplete(0, { ...answers, goal: 'frontend' }), true);
  assert.equal(isStepComplete(1, answers), true);
  assert.equal(isStepComplete(3, answers), true);
  assert.equal(isStepComplete(5, answers), false);
  assert.equal(isStepComplete(99, answers), false);
  assert.deepEqual(toggleTechnology(['react'], 'react'), []);
  assert.deepEqual(toggleTechnology(['react'], 'vue'), ['react', 'vue']);
});
