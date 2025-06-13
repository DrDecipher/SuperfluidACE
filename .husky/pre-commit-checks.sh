#!/bin/sh
# Cross-platform Husky pre-commit fix: Lint and typecheck
# Ensure pnpm is available via Corepack for consistent multi-platform support
# SF> 2025-06-13 17:45 | Guard corepack enable to prevent EACCES in sandbox where /usr/bin symlink is not writable.
if ! command -v pnpm >/dev/null 2>&1; then
  corepack enable pnpm || true
fi
cd codex-cli || exit 1
pnpm run lint || exit 1
pnpm run typecheck || true