import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { test } from 'node:test';
import ts from 'typescript';

const source = await readFile(new URL('../src/features/catalog/model/catalogKind.ts', import.meta.url), 'utf8');
const { outputText } = ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.ESNext } });
const { parseCatalogKinds, visibleCatalogKinds } = await import(`data:text/javascript;base64,${Buffer.from(outputText).toString('base64')}`);

test('older servers and unknown classifications do not imply an entitlement', () => {
  for (const value of [undefined, null, 'pro-exclusive', {}, ['PRO'], ['Angular Pro'], ['future-category']]) {
    assert.deepEqual(parseCatalogKinds(value), []);
  }
});

test('keeps verified overlapping categories and removes duplicates or invalid values', () => {
  assert.deepEqual(parseCatalogKinds(['free', 'free', 42, 'mini-course', null]), ['free', 'mini-course']);
});

test('specific badges retain useful distinctions without repeating the generic course label', () => {
  assert.deepEqual(visibleCatalogKinds(['course', 'mini-course', 'free']), ['free', 'mini-course']);
  assert.deepEqual(visibleCatalogKinds(['course']), ['course']);
});

test('Pro has visual prominence without hiding other verified classifications', () => {
  assert.deepEqual(visibleCatalogKinds(['mini-course', 'pro-exclusive']), ['pro-exclusive', 'mini-course']);
});
