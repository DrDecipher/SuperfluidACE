# Feature Plan: True Session Save and Rehydrate for Codex CLI

---

## Investigation Summary

### Existing Mechanisms
- Codex CLI stores session state in `.codex/sessions/` as JSON files (see `sessions-overlay.tsx`, `save-rollout.ts`, etc).
- Currently the save/restore logic is shallow: mainly saves the chat transcript (items) and some high-level metadata.
- On startup, users are not prompted to resume an old session — new ones always begin or must be manually loaded.
- Session ID and some config (instructions, etc) handled in `utils/session.ts`.
- Some context and state-like command histories are saved in `utils/storage/command-history.ts` and related utilities.

### Opportunities for Improvement
- To fully "rehydrate" a session, all **true context** — not just user messages, but:
    - Model selection, provider, approval modes, overlays in effect
    - Command history, overlays state (approval/model), possibly partial diffs
    - Any in-progress completion state, not-yet-approved commands, or tool calls in the live session
    - Agent/AI state that would affect the next response flow (if possible/persistable)
- Allow user on launch to "Resume last session" or "Start new" (interactive prompt on CLI open)

---

## Planned High-Fidelity Save/Restore

### Save Session (on exit or explicit command)
- Deep serialize and persist:
    - Chat transcript `items` (full ResponseItem array)
    - Current model, provider, approval mode
    - sessionId, timestamp, version, instructions (already captured)
    - Command history array (and draft input if desired)
    - Any overlays in progress (type, context)
    - Last confirmed/unconfirmed tool calls or agent states
    - (optionally): Custom UI state e.g. scroll or cursor position
- Store in JSON file `~/.codex/sessions/session-<timestamp or hash>.json`.
    - Include a full context/data structure, not just messages.
    - Schema: `{ session: { ... }, items: [...], model: '...', provider: '...', approvalMode: '...', history: [...], overlays: {...} }`

### Load/Rehydrate Session (at launch or resume)
- On CLI start, prompt user:
    - "Resume previous session? (resume/start new)"
    - If resume, load last/selected session from `.codex/sessions` and inject **all** saved context into app state after boot.
    - Re-populate all necessary state objects (model, provider, approval mode, transcript, history arrays, overlays, etc). Restore UI overlays if needed.
- If "start new", reset all such state and start clean session (but keep old session files).

---

## Implementation Steps: Full Detail and Safe Incremental Plan

### 1. Expand Session Serialization (Save)
- Identify all relevant session state to persist:
    - Chat transcript: All `items` (already in place)
    - Model, provider, approval mode: Enhance save to serialize current values, pulling from `utils/session.ts`, overlay/selection state
    - UI overlays: For each overlay component (approval, model, diff, help, history, session), capture:
        - Is it currently open?
        - What value/state is active (e.g. which model, which overlay mode, what view/page, etc)?
        - Any in-progress or selected/completed item?
    - Command history: Pull from `utils/storage/command-history.ts`; save the full command array and current index
    - Input draft: Save current buffer from chat input (prompt in progress)
    - Active tool calls/agent-loop: If an approval is pending (e.g. confirmation prompt up), save needed context for accurate resume
    - (Optional/future): Scroll/cursor positions in history/messages
- Update or replace `save-rollout.ts` to invoke deep save at exit, and expose an explicit `:save-session` command
- Write new or update JSON schema for session; add versioning in the file for future migration
- **TEST:** Save session, re-load file, verify all required fields are present, no exceptions on partial/in-progress state

### 2. Loader/Startup: Add Resume/New Logic
- On CLI boot (preferably in `app.tsx` or the outer shell), scan for latest `.codex/sessions/*.json`
- If one is found, detect its schema version
- Prompt user: “Resume last session or start new?”
- If resume: Load session, parse fields, inject into app state/context providers for all of:
    - Transcript/messages, overlays, model/provider, approval, command history/index, input draft, in-progress overlay states
- If start new: continue with empty state (auto-clear all state modules/providers)
- **TEST:** After resume, verify UI resumes overlays, input, approval, etc—able to continue working seamlessly

### 3. Deep Integration: State Injection 
- Refactor each main component to optionally accept external (rehydrated) state:
    - Chat input: accept draft prompt/history
    - Overlay components: new props/state to indicate if/how they should restore
    - Model/approval mode: accept initial state from loader/provider
    - Command approval: if in confirmation flow, restore prompt and pending command
    - Each overlay’s “isOpen/defaults” to be hydrated
- Ensure state providers/contexts can be “seeded” (or replaced on hot load)
- **TEST:** Simulate partial/incomplete/in-progress session and restore fully, recover cursor, modal, etc

### 4. Quality & Safety: Testing All Paths
- Add test CLI commands (`:save-session`, `:resume-session`, etc) to test mid-flow
- Unit test: session with multiple overlays, history, confirm in progress, then power-off/exit, then resume
- Test edge cases: corrupted session, missing overlay fields, unknown future state (ignore/migrate), rejected resumes
- Document fallback/migration in overlay/state logic; keep file versioned for forward compatibility

---

## Further Options & Future Extensions

**What is a UI Overlay?**
A UI “overlay” (Codex CLI: overlay) is any temporary/modal UI—model picker, approval, help, diff, session picker, etc.—which appears above the main app, interrupts normal workflow, and usually requires user action to dismiss or continue. See: `model-overlay.tsx`, `approval-mode-overlay.tsx`, `help-overlay.tsx`, `history-overlay.tsx`, `diff-overlay.tsx`, `sessions-overlay.tsx`.

### Potential Options for Full-featured Session Restore (Future)
- Option to save/restore window size or layout
- Restore scroll/cursor positions in transcripts or overlays
- Offer “autosave” after every agent action, not just on exit
- Option to resume a session as a “fork” (branching for exploration/testing)
- Select overlay(s) or UI state elements to skip on restore (manual override)
- User preferences in session files
- Ability to export/import sessions for cross-machine pause/resume

---

[//]: # (SF> 2025-06-09 13:03 | Expanded plan with detailed, incremental, testable steps for robust session save/rehydrate including overlay explanation and future options section.)
