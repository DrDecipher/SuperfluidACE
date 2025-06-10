#!/bin/sh
# Cross-platform Husky pre-commit fix: Lint and typecheck
cd codex-cli || exit 1
pnpm run lint || exit 1
pnpm run typecheck || exit 1