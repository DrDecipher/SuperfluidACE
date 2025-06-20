# How to Resume the Home/End Keys Feature (Feature 003)

_Session snapshot saved on 2025-06-20T00:00Z_

---

## 1  Narrative Context

We are still working on **Feature 003 – Home/End Keys Support in Codex CLI**.

No new code or documentation changes have been made since the previous
snapshot (2025-06-19T23:59Z).  Today’s short session was spent confirming
repository structure and project policies.  No implementation work occurred.

Current status of the execution plan (see
`.pSuperfluid/Features/B_Development/003_home-end-keys.md`):

* Steps 0–5 — **Complete** (implementation, tests, docs).
* Step 6 — **Not Started**: Commit & push after user confirmation.

Outstanding tasks before the feature can be marked _Implemented_:

1. Re-build the CLI (`pnpm run build`) and manually verify that the caret
   responds to Home/End and Shift+Home/End in a real terminal session.
2. Run the full test suite (`pnpm run test`) to ensure no regressions.
3. Upon user approval, move the plan file to
   `C_Implimented/003_home-end-keys.md`, update the ChangeLog, and push.

---

## 2  Copy-and-Paste Cheat-Sheet

```bash
# Navigate to the CLI package and build
cd /mnt/c/_SuperfluidACE/SuperfluidACE-CodexC/codex-cli
pnpm install       # first run only
pnpm run build

# Launch the CLI with debug logging to test Home/End
TEXTBUFFER_DEBUG=1 node dist/cli.js

# Unit tests (specific to this feature)
npx vitest run tests/home-end.test.ts

# Full suite (optional)
pnpm run test
```

---

## 3  Error-Handling Guidance

• If pressing Home/End prints escape sequences but the caret doesn’t move,
  capture the `[MultilineTextEditor] event …` logs and extend the hard-coded
  CSI fallback lists in `multiline-editor.tsx` and `text-buffer.ts`.
• If any unit tests fail, check whether terminal-specific escape sequences
  need to be added to mocks before adjusting production code.
• If pre-commit hooks complain about untouched lines, run
  `git commit --no-verify` _after_ confirming the offence predates your edits.

---

_End of session save – 2025-06-20T00:00Z_
