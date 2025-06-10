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
`.Superfluid/Config/CommentGuide.md`.
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