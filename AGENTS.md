
# =============================================
# Feature Session Tracking & Agent Workflow
# =============================================

ActiveFeature: FullBoatWebMode

## Feature Restoration Workflow


Upon agent startup:
  1. Read the ActiveFeature directive above.
  2. If set, load the following feature files for that feature name:
      - <FeatureName>_Context.md
      - <FeatureName>_Plan.md
      - <FeatureName>_Log.md
      - <FeatureName>_Learn.md (if exists)
  3. Prompt the user with these options (by number):
      1. Start NEW feature – follow `.Superfluid/Features/Build_Template.md` procedure to scaffold a new feature
      2. Switch to another tracked feature
      3. Review loaded feature data (plan/context/log/learn)
      4. Continue working on this feature (go to next step/plan)
      <!-- SF> 2025-06-13 16:05 | Added menu item 5 'Just Code' for users who want a clean coding session without changing active feature (renumbered) -->
      5. Just Code (clean session – do not load or modify any feature context)
  4. Wait for user to select one of these options (do NOT proceed to implementation unless explicitly told by the user).
      <!-- SF> 2025-06-13 16:05 | Updated special-case numbering for 'Just Code' (option 5) and documented behavior -->
     - **Special case:** If the user enters `5` (“Just Code”), simply reply **“Clean Session Started”** and continue with normal assistant behavior without altering `ActiveFeature` or loading any feature files.

## Session Save Workflow <!-- SF> 2025-06-13 16:40 | Added guidance for richer context saving including conversation log -->

When the user indicates they want to **save / pause the session** (e.g., “save session”, “end for now”, or similar):

1. Append a new entry to `<FeatureName>_Context.md` (or a generic `Session_Context.md` if no `ActiveFeature`). Each entry must include:
   - **Timestamp** in `YYYY-MM-DD HH:mm` format.
   - **Current Step** (if working from a feature plan) or a short description of current task.
   - **Notes** summarising what was accomplished or observed in this session.
   - **Next Actions** list for the following session.
   - **Branch/Commit** hash (if applicable).

2. **Conversation History (FULL)**: Immediately after the standard fields, insert a collapsible `<details>` block that captures the **entire chat transcript from the current session**.  This ensures the next session can restore every nuance of the dialogue, code decisions, and rationale.

```
<details>
<summary>Conversation Log 2025-06-13 16:40</summary>

```text
User: …
Assistant: …
… (entire conversation or middle trimmed if exceedingly long)
```

</details>
```

   *If the transcript is extremely long (≈300+ lines), it is acceptable to collapse or summarise the **middle** portion only, but never remove the beginning or the most-recent exchanges.*

3. Confirm the entry has been written and then tell the user “Session saved.”

4. Do **not** modify `ActiveFeature`—the intent is to resume later with identical context.

---

# ========== Other Environment and Coding Docs Follow =============

# Session Environment
- Host OS: Windows 10/11 via WSL2.
- Shell: Powershell launching into WSL.
- All changes must remain compatible with native Linux environments; avoid breaking Linux workflows.

# Rust/codex-rs

In the codex-rs folder where the rust code lives:

- Never add or modify any code related to `CODEX_SANDBOX_NETWORK_DISABLED_ENV_VAR`. You operate in a sandbox where `CODEX_SANDBOX_NETWORK_DISABLED=1` will be set whenever you use the `shell` tool. Any existing code that uses `CODEX_SANDBOX_NETWORK_DISABLED_ENV_VAR` was authored with this fact in mind. It is often used to early exit out of tests that the author knew you would not be able to run given your sandbox limitations.

# Comment Style Guide

This file outlines how comments should be formatted across different languages used in this project. Fill in the examples below with your preferred style and conventions.

## TypeScript / JavaScript
### Single-line
```js
// SF> {Date/Time} | {Description of what was added or changed}
```

# Instructions

**Print “REBUILD REQUIRED” Only When Necessary (SF> 2025-06-09 12:50 | Formatting aligned to user expectation):**

- If you modify source code (e.g., `.ts`, `.tsx`, `.rs` files, or implementation/logic):
    - **Print:** `REBUILD REQUIRED - !Code Updated!`
- If you only change documentation, markdown (`.md`), logs, changelogs, or resource/reference files:
    - **Print:** `(No REBUILD REQUIRED — documentation change only.)`

| Change Type                     | What to Print                                                           |
|---------------------------------|-------------------------------------------------------------------------|
| Code (e.g. .ts, .tsx, .rs, etc) | REBUILD REQUIRED                                                        |
| Docs/logs (.md, changelog, etc) | (No REBUILD REQUIRED — documentation change only.)                      |



From now on, for every code file you modify (no matter how small the change), you must:

    Goal 1:I actually like how you a

        * Add a timestamped inline comment at the site of each change, using the format and comment style defined in
.Superfluid/Config/CommentGuide.md`.
            * This comment must describe what was changed and why (one or two sentences).

            * If modifying or adding multiple blocks in the same file, ensure each is annotated at the edit location.

    Goal 2:

        * For every code file you touch, immediately append an entry to `.Superfluid/Logs/changeLog.md`, using the format:
YYYY-MM-DD HH:mm {file name} {Line Number(s)} {brief description of changes}


            * Log the filename, the specific lines changed or added, and a summary of your modification.
i d not think yo 
            * Always append, do not overwrite previous entries.

    Notes:

        * These practices must be followed for all file types and all codebase modifications.
        * Failure to do so is an implementation error and requires correction.

    Repeat these practices for every change unless specifically instructed otherwise.

    If your patch alters more than one file, add a change log entry for each file.

# Project Agent Instructions
#include .Superfluid/Personalities/Jarvis.md
#include .Superfluid/Config/CommentGuide.md