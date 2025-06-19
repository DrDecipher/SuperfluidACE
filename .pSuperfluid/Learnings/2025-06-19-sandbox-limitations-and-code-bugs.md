# Sandbox Limitations & Pre-existing Code Issues

Date: 2025-06-19

## 1. Vitest / esbuild `EPERM` Failure inside Codex Sandbox

### Symptom
Running `vitest run` fails on startup with:

```
failed to load config …
Error: spawn EPERM
```

The error originates from **esbuild** when Vitest tries to bundle `vitest.config.ts`. The sandboxed environment disallows spawning the esbuild binary.

### Impact
• Automated unit-tests cannot run inside the sandbox.  
• CI pipelines or local development outside the sandbox remain unaffected.

### Proposed Mitigations
1. **Skip Vitest in sandbox** – Detect `CODEX_SANDBOX` and add a package-script alias that runs `vitest --no-config`, executing files directly (Vitest can run without bundling when test files are ESM-ready).
2. **Use `--browser` flag** – Esbuild isn’t required in browser-mode; experiment with `vitest run --browser --env happy-dom` for headless execution.
3. **Fallback to `tsx` runner** – For simple unit tests, switch to `tsx` or `uvu` when the Vitest bootstrap fails.

## 2. Pre-existing TypeScript Compile Errors

### Symptom
`npx tsc --noEmit` reports ~10 errors in files unrelated to our recent changes (`terminal-chat-response-item.tsx`, `agent-loop.ts`, etc.).

### Impact
• Full type-checks fail, which can mask new errors.  
• Build pipelines that rely on strict `tsc` may break.

### Proposed Mitigations
1. **Incremental Clean-up** – Schedule a sprint to fix these errors module-by-module.
2. **Adopt `eslint-plugin-unused-exports`** – Catch orphan code paths earlier.
3. **CI Gate** – Add a GitHub Action that runs `tsc` in `--noEmit --skipLibCheck` mode and fails on new errors but warns on existing ones (grandfather rule).

---

These findings are recorded here so future sessions can avoid redundant investigation and progressively harden the tool-chain.
