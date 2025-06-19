# Feature 003 – Home/End Keys Support in Codex CLI

*Design origin: A_Design/HomeEndKeys.md (copied on 2025-06-19)*

---

## Goal

Enable intuitive `Home`/`End` cursor navigation (and their `Shift`-modified
selection variants) in the Codex CLI multiline text editor – matching the
behaviour users expect from typical shells and text editors.

## Requirements / Acceptance Criteria

* Pressing **Home** moves caret to column 0 of the current line.
* Pressing **End** moves caret to the last column of the current line.
* **Shift+Home** selects text from the caret to column 0.
* **Shift+End** selects text from the caret to end-of-line.
* Works in common terminals (xterm-compatible) on Linux/macOS/WSL.
* No regression of existing key bindings.
* Covered by unit tests (simulate key sequences via Ink’s stdin stub).

## Execution Steps

| # | Description | Status | Files |
|---|-------------|--------|-------|
| 0 | Investigate current key-handling in `multiline-editor.tsx` & TextBuffer | Complete | (context exploration) |
| 1 | Determine raw CSI sequences for Home/End & Shift variants (xterm) | Complete | (handled via Ink key flags) |
| 2 | Extend `multiline-editor` `useInput` parser to recognise these sequences and translate them into `buffer.move("home"|"end")` or selection ops | Skipped | Not required – TextBuffer.handleInput handles key flags |
| 3 | Add selection logic to `TextBuffer` if missing | Complete | codex-cli/src/text-buffer.ts |
| 4 | Write unit tests using `ink-testing-library` to validate behaviour | Complete | codex-cli/tests/home-end.test.ts |
| 5 | Update docs (`FeatureDev.md` quick-ref + CHANGELOG) | Complete | docs/keybindings.md, .pSuperfluid/Logs/ChangeLog.md |
| 6 | Commit & push upon user-approved milestones (Milestone-Push policy) | Not Started | None |

## Potential Pitfalls

* Terminal differences (macOS vs Linux vs Windows terminals) emit slightly different escape sequences.
* Ink’s key parsing may swallow CSI sequences unless raw input is enabled correctly.
* Text selection within the current editor is rudimentary – may require extra state.

## Timeline Estimate

| Task | ETA |
|------|-----|
| Planning | 30 min |
| Coding   | 2 h |
| Tests    | 1 h |
| Docs     | 30 min |

---

## Execution Report

*Status: Complete*

| Date | Note |
|------|------|
| 2025-06-19 | Copied design file and created development plan |
| 2025-06-19 | Implemented logic, tests, and docs; steps 0–5 completed |

### Outstanding Actions

*None – feature implementation complete; awaiting user confirmation.*

---

## Context for Future Sessions

`TextBuffer` already exposes `move("home")` and `move("end")`, but the CLI
does not currently map keyboard events to those commands.  Work will focus on
parsing terminal escape sequences inside `multiline-editor.tsx` and adding
selection support if feasible.

### Reporting Expectations

After each milestone (e.g., investigation complete, feature implemented) add a
short subsection here summarising what changed, any open questions, and a
direct prompt for user confirmation.

---

#### 2025-06-19 – Implementation Complete

• Added Shift-aware Home/End handling in `TextBuffer.handleInput` including selection anchor management.  
• Wrote unit tests (`tests/home-end.test.ts`) covering navigation and selection.  
• Documented keybindings in `docs/keybindings.md`.  

Remaining work: **None** – feature meets the outlined acceptance criteria.  

**Prompt:** Please review the behaviour and let me know if further tweaks (e.g., visual highlight of selection) are desired before we move this feature to *C_Implimented*.
