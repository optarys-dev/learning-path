const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const ts = require('typescript');
const root = path.resolve(__dirname, '../src');

function files(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
    const file = path.join(directory, entry.name);
    return entry.isDirectory() ? files(file) : /\.tsx?$/.test(file) && !file.endsWith('.d.ts') ? [file] : [];
  });
}
const modules = files(root);
const trees = new Map(modules.map(file => [file, ts.createSourceFile(file, fs.readFileSync(file, 'utf8'), ts.ScriptTarget.Latest, true)]));
function resolve(file, specifier) {
  const base = specifier.startsWith('@/') ? path.join(root, specifier.slice(2))
    : specifier.startsWith('.') ? path.resolve(path.dirname(file), specifier) : null;
  return base && [base + '.ts', base + '.tsx', path.join(base, 'index.ts'), path.join(base, 'index.tsx')].find(candidate => trees.has(candidate));
}
function dependencies(file, tree) {
  return tree.statements.flatMap(statement => {
    if (!ts.isImportDeclaration(statement) && !ts.isExportDeclaration(statement)) return [];
    if (!statement.moduleSpecifier || !ts.isStringLiteral(statement.moduleSpecifier) || statement.isTypeOnly || statement.importClause?.isTypeOnly) return [];
    const bindings = statement.importClause?.namedBindings ?? statement.exportClause;
    if (bindings && ts.isNamedImports(bindings) && !statement.importClause.name && bindings.elements.every(element => element.isTypeOnly)) return [];
    const target = resolve(file, statement.moduleSpecifier.text);
    return target ? [target] : [];
  });
}

test('runtime imports and barrels do not introduce circular dependencies', () => {
  const visited = new Set(), stack = [];
  function visit(file) {
    assert.ok(!stack.includes(file), 'Import cycle: ' + [...stack, file].map(item => path.relative(root, item)).join(' -> '));
    if (visited.has(file)) return;
    stack.push(file);
    dependencies(file, trees.get(file)).forEach(visit);
    stack.pop(); visited.add(file);
  }
  modules.forEach(visit);
});

test('cross-directory imports use the existing alias and public catalog barrel does not load pages', () => {
  for (const [file, tree] of trees) {
    function check(node) {
      if ((ts.isImportDeclaration(node) || ts.isExportDeclaration(node)) && node.moduleSpecifier && ts.isStringLiteral(node.moduleSpecifier)) {
        assert.ok(!node.moduleSpecifier.text.startsWith('../'), 'Parent traversal import: ' + path.relative(root, file));
        if (file === path.join(root, 'features/catalog/index.ts')) {
          assert.ok(!node.moduleSpecifier.text.includes('/pages/'), 'Catalog data barrel eagerly exports a page');
        }
      }
      ts.forEachChild(node, check);
    }
    check(tree);
  }
});

test('static UI prose and accessible names come from translations', () => {
  const brands = new Set(['DevTalles', 'CODE QUEST 2026']);
  const failures = [];
  for (const [file, tree] of trees) {
    function check(node) {
      let text;
      if (ts.isJsxText(node)) text = node.text.trim();
      if (ts.isJsxExpression(node) && node.expression && ts.isStringLiteral(node.expression)) text = node.expression.text.trim();
      if (ts.isJsxAttribute(node) && ['aria-label', 'title', 'placeholder', 'alt'].includes(node.name.getText(tree)) && node.initializer && ts.isStringLiteral(node.initializer)) text = node.initializer.text.trim();
      if (text && /\p{L}/u.test(text) && !brands.has(text)) {
        const line = tree.getLineAndCharacterOfPosition(node.getStart(tree)).line + 1;
        failures.push(path.relative(root, file) + ':' + line + ' ' + text);
      }
      ts.forEachChild(node, check);
    }
    check(tree);
  }
  assert.deepEqual(failures, []);
});
