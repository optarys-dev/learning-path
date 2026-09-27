const { test } = require('node:test');
const assert = require('node:assert/strict');
const { shareArtworkSize, shareArtworkGoal } = require('../.test-build/features/routes/model/shareArtwork');
const { es } = require('../.test-build/i18n/locales/es');
const { en } = require('../.test-build/i18n/locales/en');

test('single-image layouts retain all six recommended courses and up to thirty manual courses', () => {
  for (const format of ['landscape', 'square', 'portrait']) {
    const columns = format === 'portrait' ? 1 : 2;
    assert.equal(shareArtworkSize(format, 6).rows * columns, 6);
    assert.equal(shareArtworkSize(format, 30).rows * columns, 30);
    assert.ok(shareArtworkSize(format, 30).height > shareArtworkSize(format, 6).height);
    assert.ok(shareArtworkSize(format, 1).height > 0);
  }
});

test('questionnaire goals follow the export language in both directions without changing custom names', () => {
  for (const key of Object.keys(es.questionnaire.outcomes)) {
    assert.equal(shareArtworkGoal(es.questionnaire.outcomes[key], 'en'), en.questionnaire.outcomes[key]);
    assert.equal(shareArtworkGoal(en.questionnaire.outcomes[key], 'es'), es.questionnaire.outcomes[key]);
  }
  assert.equal(shareArtworkGoal('Mi plan personal: React', 'en'), 'Mi plan personal: React');
});
