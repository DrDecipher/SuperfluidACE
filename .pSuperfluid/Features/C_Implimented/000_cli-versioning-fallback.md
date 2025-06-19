# Feature 000: CLI Version Fallback

## Goal

Ensure that when developers run the `codex` CLI directly from a local git checkout (where `package.json` on `main` is still at the placeholder version `0.0.0-dev`), the CLI reports the most recent Git tag rather than always showing `0.0.0-dev`.

## Considerations

- **Placeholder version on main**: The repo’s `package.json` uses a dummy `0.0.0-dev` version so that real version bumps only happen via the release workflow.
- **External package.json read**: The build process marks `package.json` as external so runtime code can inspect `pkg.version` directly without needing to rewrite source files.
- **Resilience**: The Git‑based fallback must not break the CLI if Git is missing or fails (e.g. standalone install).
- **Minimal dependencies**: Introduce only a small `child_process.execSync` call inside a `try/catch`.

## Solution

We updated `src/version.ts` to detect the placeholder version and, if present, invoke `git describe` to grab the latest tag:

```ts
import pkg from "../package.json" with { type: "json" };
import { execSync } from "child_process";

// Read the version from package.json, falling back to the latest Git tag
// if package.json still has the placeholder version.
let version = (pkg as { version: string }).version;
if (version.startsWith("0.0.0")) {
  try {
    const tag = execSync("git describe --abbrev=0 --tags", { encoding: "utf8" }).trim();
    version = tag.startsWith("v") ? tag.slice(1) : tag;
  } catch {
    // leave placeholder if Git command fails
  }
}
export const CLI_VERSION: string = version;
```
【F:codex-cli/src/version.ts†L1-L18】

This ensures:

1. **Published versions first**: Uses the real `pkg.version` if it’s already been bumped.
2. **Git fallback**: On a dev checkout, extracts the latest tag from Git to reflect the true version context.
3. **Graceful degradation**: If `git describe` fails (no tags, not a repo), the placeholder remains.

## Verification

1. Rebuild the CLI locally:
   ```bash
   pnpm install
   pnpm build
   ```
2. Run the CLI directly from the build output:
   ```bash
   node dist/cli.js --version
   ```
   The output should match the current Git tag (minus any leading `v`), not `0.0.0-dev`.

With this enhancement, every developer running `codex --version` locally will immediately see the correct tag‑based version, preserving historical context while hacking on the repo.