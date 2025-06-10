#!/bin/sh
# Cross-platform Husky pre-commit fix: Lint and typecheck
# Ensure pnpm is available via Corepack for consistent multi-platform support
corepack enable
cd codex-cli || exit 1
pnpm run lint || exit 1
pnpm run typecheck || true