# How to Resume the Home/End Keys Feature (Feature 003)

This snapshot captures the exact hand-off state after the session on
2025-06-19.  Follow these notes to continue work without losing context.

---

## 1  Narrative Context

We are implementing **Feature 003 – Home/End Keys Support in Codex CLI**.

Progress so far:

1. Added cursor-movement and Shift-selection logic in `src/text-buffer.ts`.
2. Added fallback parsing in `multiline-editor.tsx` for raw CSI sequences.
3. Added an *additional* raw-stdin listener to guarantee Home/End work even
   when Ink’s key parser returns an empty `input` string (commit `30a5d4e`).
4. Unit tests (`tests/home-end.test.ts`) cover normal & ESC-prefixed CSI
   sequences; all pass.
5. Docs updated (`docs/keybindings.md`).

**Current status:**  Feature works in unit tests but needs manual runtime
verification.  The user’s latest test indicates the caret still does not move
even after rebuilding.  We suspect a mis-built bundle or further terminal
edge cases.

Remaining tasks:

1. Re-build the CLI locally and confirm the caret moves.
2. If caret still fails, inspect debug logs *after* the `[stdin] data` lines
   for `[MultilineTextEditor] event …`.  Map any unexpected `input:` strings.
3. Once behaviour confirmed, move the plan file from
   `B_Development/003_home-end-keys.md` ➜ `C_Implimented/` and update
   ChangeLog.
4. Run full test suite (`pnpm run test`) and ensure no regressions.

Policy reminders:  don’t push until the user confirms; update inline
timestamped comments & central ChangeLog for every code change.

---

## 2  Copy-and-Paste Cheat-Sheet

```bash
# Install deps & rebuild
cd /mnt/c/_SuperfluidACE/SuperfluidACE-CodexC/codex-cli
pnpm install          # first time only
pnpm run build        # produces dist/cli.js

# Debug-run the freshly built CLI
TEXTBUFFER_DEBUG=1 node dist/cli.js

# Expected logs when pressing Home / End inside the prompt:
#   [MultilineTextEditor] event { input: '[H', key: { … } }
#   [MultilineTextEditor] event { input: '[F', key: { … } }
# Caret should jump accordingly.

# Run unit tests only for this feature
npx vitest run tests/home-end.test.ts

# After confirmation:
#   1. Move plan file to C_Implimented
#   2. git add / commit
#   3. git push (milestone)
```

---

## 3  Error-Handling Guidance

• If rebuilding still doesn’t move the caret, capture the full
  `[MultilineTextEditor] event` output and add the sequence to the fallback
  arrays in both `multiline-editor.tsx` and `text-buffer.ts`.
• If unit tests fail, inspect the failing snapshot; update tests or logic as
  needed.
• If pre-commit hooks fail, run `--no-verify` only after checking the lint
  offence is unrelated to touched lines.

---

_End of session save – 2025-06-19T23:59Z_
