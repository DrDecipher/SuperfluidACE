// SF> 2025-06-16 15:30 | CommonJS Vitest config to bypass TS bundling and esbuild dependency issues.
const { defineConfig } = require('vitest/config');

module.exports = defineConfig({
  test: {
    threads: false,
    environment: 'node',
  },
});