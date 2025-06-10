# Reference: CLI Input Extension (Multiline, Copy/Paste, Newline)

---

## Where CLI Input Handling Is Implemented

### Main Components:

- **`codex-cli/src/components/chat/terminal-chat-input.tsx`**
  - Top-level React component for chat prompt entry in the Codex CLI.
  - Owns input state, handles submission, integrates with history, file suggestions, and overlays.
  - Calls the underlying multiline text editor for low-level keystroke processing.
- **`codex-cli/src/components/chat/multiline-editor.tsx`**
  - Implements the actual multi-line text input area using Ink and a custom `TextBuffer`.
  - Handles raw keystroke events, including Enter vs. Shift+Enter (for newline-insert), cut/copy/paste via system clipboard if supported, and cursor motion.
  - Contains polyfills and bridges between Node/Ink event models to enable rich editing behaviors.
  - Look for usages of `useInput`, and event checks for e.g. `key.shift` combined with Enter—this is where you would add Shift-Enter for a new line, and where paste logic or copy hotkeys would go.
  - Handles carriage returns, linefeeds, and distinguishes plain Enter (submit) vs. Shift+Enter (newline append).
- **`codex-cli/src/components/vendor/ink-text-input.tsx`**
  - If used in the prompt, provides an additional single-line input experience.

---

## How To Modify CLI Input Behavior

- **To Support Multiline Input (Shift+Enter):**
  - Edit `multiline-editor.tsx` to expand its `useInput` handler, checking if `key.shift && key.return` (or similar); insert `\n` at current cursor position. This is already partially implemented to distinguish these keys.
- **Copy/Paste Support:**
  - Modern CLI terminals usually handle Ctrl+V/Ctrl+C for paste/copy. For in-app logic, extend `useInput` to handle relevant keys and potentially access clipboard APIs if you want cross-session clipboard. Otherwise, the user's terminal is responsible for supporting native paste.
- **Text Buffer Management:**
  - All logic to insert, delete, and move lines or characters is in the `TextBuffer` class and its handlers inside `multiline-editor.tsx`.

---

## Design References / Notes
- The `multiline-editor.tsx` file contains
  - EventEmitter patches and polyfills to make terminal input work reliably, including with testing stubs.
  - The docs and comments in that file are the most authoritative for how special keys (Shift+Enter, paste) and multi-line entry function.
  - The higher level chat-input component (`terminal-chat-input.tsx`) coordinates entry and submission, and is the main bridge to expand/override input strategies.

---

## Table: Change Targets
| Feature                          | Main Source File                        | How To Extend                    |
|-----------------------------------|-----------------------------------------|----------------------------------|
| Multiline input (Shift+Enter)     | chat/multiline-editor.tsx               | Handle Shift+Enter in useInput   |
| Paste/copy (enhanced, in-CLI)     | chat/multiline-editor.tsx, chat-input   | Add to useInput, clipboard API   |
| Submission (Enter)                | chat/terminal-chat-input.tsx            | Submission handler, on Enter     |

---

[//]: # (SF> 2025-06-09 12:46 | Added doc summarizing CLI text input/multiline/paste-extension in Codex CLI source.)
