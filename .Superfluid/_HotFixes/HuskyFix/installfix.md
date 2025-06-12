# Permanent Husky Pre-commit Fix: Cross-Platform Lint/Typecheck

This guide walks you through replacing problematic chained pre-commit hooks (e.g. `cd codex-cli && ...`) with a robust portable shell script solution.

## Why?
- On Windows, Husky hooks with chained commands often fail due to cmd/bash incompatibility.
- This fix ensures lint/typechecking always works on every platform when committing code.

---

## 1. Copy Script Into Your Husky Directory

Copy `.Superfluid/HuskyFix/pre-commit-checks.sh` to your project root’s `.husky/` folder:

```
cp .Superfluid/HuskyFix/pre-commit-checks.sh .husky/
```

Or just move and rename as you like.

---

## 2. Make It Executable (if needed)

Run (from project root, in Git Bash, WSL, Mac/Linux terminal):
```
chmod +x .husky/pre-commit-checks.sh
```

---

## 3. Edit `.husky/pre-commit` File

Replace its contents with:
```
#!/bin/sh
.husky/pre-commit-checks.sh
```

---

## 4. Try a Commit!
- Make a code change, add/stage it, and commit.
- Lint and typecheck will run using the robust shell script instead of broken chained lines.
- Works on Windows, Mac, or Linux as long as Git Bash, WSL, or classic sh is available (standard with Git for Windows).

---

## Troubleshooting

- If you see `permission denied`, rerun `chmod +x` (step 2).
- If you use a non-bash/non-posix shell on Windows, try commits in Git Bash from now on.
- You can also invoke the script directly:
  ```sh
  sh .husky/pre-commit-checks.sh
  ```

---

## Summary
- No more "The filename, directory name, or volume label syntax is incorrect" errors
- 100% portable pre-commit checks for Codex CLI

[//]: # (SF> 2025-06-09 16:44 | Added install/setup instructions and robust portable shell for cross-platform Husky pre-commit lint/typecheck.)
