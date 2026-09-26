const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const compile = spawnSync(process.execPath, [require.resolve('typescript/lib/tsc.js'), '-p', 'tsconfig.tests.json'], { cwd: root, stdio: 'inherit' });
if (compile.status !== 0) process.exit(compile.status ?? 1);
function resolveTestAliases(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const filename = path.join(directory, entry.name);
    if (entry.isDirectory()) resolveTestAliases(filename);
    else if (filename.endsWith('.js')) {
      const code = fs.readFileSync(filename, 'utf8').replace(/require\(["']@\/([^"']+)["']\)/g, (_, target) => {
        let relative = path.relative(path.dirname(filename), path.join(root, '.test-build', target)).replaceAll('\\', '/');
        if (!relative.startsWith('.')) relative = './' + relative;
        return 'require(' + JSON.stringify(relative) + ')';
      });
      fs.writeFileSync(filename, code);
    }
  }
}
resolveTestAliases(path.join(root, '.test-build'));
fs.writeFileSync(path.join(root, '.test-build/package.json'), JSON.stringify({ type: 'commonjs' }));
const tests = fs.readdirSync(__dirname).filter(file => file.endsWith('.test.cjs')).map(file => path.join(__dirname, file));
const result = spawnSync(process.execPath, ['--test', ...tests], { cwd: root, stdio: 'inherit' });
process.exit(result.status ?? 1);
