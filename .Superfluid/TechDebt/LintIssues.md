# Lint Issues

1. Pre-commit ESLint failures across multiple files (codex-cli/src/cli.tsx, codex-cli/src/utils/config.ts, codex-cli/src/utils/parsers.ts, codex-cli/tests/full-boat-whitelist.test.ts) are currently blocking commits.

   Recommended approach: schedule a tech-debt task to run `eslint --fix` for auto-fixable issues, refactor code to comply with project style rules, remove unnecessary escape characters and disable directives, and ensure lint checks pass before committing.