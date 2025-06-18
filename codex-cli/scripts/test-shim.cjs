// SF> 2025-06-14T12:08 | CommonJS test shim for Vitest (see explanation below).
// SF> 2025-06-16 15:20 | Registered ts-node to compile TypeScript config files, bypassing esbuild bundling.
require('ts-node').register({ transpileOnly: true });

/*
 * This file is injected via the `NODE_OPTIONS=--require` flag in the test
 * script so it must be authored in **CommonJS** (hence the .cjs extension).
 * It supplies a pure-JavaScript fallback implementation for the `esbuild`
 * module, whose pre-built native binaries are missing for the Linux platform
 * within this offline development environment.
 */

const Module = require('module');
// SF> 2025-06-16 15:10 | Added stub for missing rollup native module dependency to prevent require errors in tests.
const rollupStub = {};
const ts = require('typescript');

function transpile(code, options = {}) {
  const tsOptions = {
    module: ts.ModuleKind.ESNext,
    target: ts.ScriptTarget.ES2022,
    jsx: ts.JsxEmit.ReactJSX,
    ...options.tsCompilerOptions,
  };
  const { outputText, sourceMapText } = ts.transpileModule(code, {
    compilerOptions: tsOptions,
    fileName: options.sourcefile || 'anonymous.ts',
  });
  return { code: outputText, map: sourceMapText ?? null };
}

const esbuildStub = {
  version: '0.0.0-stub',
  transformSync: (code, opts = {}) => transpile(code, opts),
  transform: (code, opts = {}) => Promise.resolve(transpile(code, opts)),
  build: () => {
    throw new Error('esbuild.build is not implemented in the stub environment.');
  },
  buildSync: () => {
    throw new Error('esbuild.buildSync is not implemented in the stub environment.');
  },
  formatMessages: () => Promise.resolve([]),
  formatMessagesSync: () => [],
  analyzeMetafile: () => Promise.resolve({}),
  analyzeMetafileSync: () => ({}),
  context: () => Promise.resolve({ dispose() {} }),
  initialize: () => Promise.resolve(),
};

// Expose for packages that import this file directly.
module.exports = esbuildStub;
module.exports.__esbuildStub = esbuildStub;

// Patch the Node module loader so any future `require('esbuild')` returns the
// stub instead of attempting to load missing native binaries.
const originalLoad = Module._load;
Module._load = function patchedLoad(request, parent, isMain) {
  // SF> 2025-06-16 15:15 | Extended esbuild stub to include subpaths and ESM imports, preventing optional dependency errors.
  if (
    request === 'esbuild' ||
    request.startsWith('esbuild/') ||
    request.startsWith('@esbuild/')
  ) {
    return esbuildStub;
  }
  if (request.startsWith('@rollup/rollup-')) {
    return rollupStub;
  }
  return originalLoad.apply(this, arguments);
};

// Ensure ESM resolver also redirects to the stub.  This works because both
// CommonJS and ESM ultimately delegate to `_resolveFilename` under the hood.
const originalResolveFilename = Module._resolveFilename;
Module._resolveFilename = function patchedResolve(request, parent, isMain, options) {
  // SF> 2025-06-16 15:35 | Extended ESM resolver stub to catch esbuild subpaths and @esbuild packages.
  if (
    request === 'esbuild' ||
    request.startsWith('esbuild/') ||
    request.startsWith('@esbuild/')
  ) {
    return 'virtual:esbuild-stub';
  }
  return originalResolveFilename.apply(this, arguments);
};

// Prime the cache — this covers edge cases where a fully qualified path is
// resolved for the first `esbuild` import.
require.cache['esbuild-stub'] = { exports: esbuildStub };
