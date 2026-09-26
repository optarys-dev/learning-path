const { test } = require('node:test');
const assert = require('node:assert/strict');
const { es } = require('../.test-build/i18n/locales/es');
const { en } = require('../.test-build/i18n/locales/en');
const { courseLevelTranslationKey } = require('../.test-build/i18n/courseLevel');

function flatten(object, prefix = '') {
  return Object.fromEntries(Object.entries(object).flatMap(([key, value]) => {
    const name = prefix ? prefix + '.' + key : key;
    return typeof value === 'string' ? [[name, value]] : Object.entries(flatten(value, name));
  }));
}
const spanish = flatten(es), english = flatten(en);
const placeholders = text => [...text.matchAll(/{{\s*([^{}]+?)\s*}}/g)].map(match => match[1]).sort();

test('every Spanish UI translation has a nonempty English equivalent with the same placeholders', () => {
  assert.deepEqual(Object.keys(spanish).sort(), Object.keys(english).sort());
  for (const [key, value] of Object.entries(spanish)) {
    assert.ok(value.trim(), 'Empty Spanish text: ' + key);
    assert.ok(english[key].trim(), 'Empty English text: ' + key);
    assert.deepEqual(placeholders(value), placeholders(english[key]), 'Interpolation mismatch: ' + key);
  }
});

test('catalog level aliases use shared ES/EN keys and preserve unknown data', () => {
  for (const [value, key] of [['Avanzado', 'advanced'], [' Intermediate ', 'intermediate'], ['Básico', 'beginner'], ['Beginner', 'beginner']]) {
    const translationKey = courseLevelTranslationKey(value);
    assert.equal(translationKey, 'course.levels.' + key);
    assert.ok(spanish[translationKey]); assert.ok(english[translationKey]);
  }
  assert.equal(courseLevelTranslationKey('Specialist'), null);
});
