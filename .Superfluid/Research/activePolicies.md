## Active Agent Policies (Codex CLI)

### 1. Codex CLI Core Instructions
- Use the `apply_patch` shell tool for file edits.
- All code edits must be atomic, scoped, and limited to the explicit task/location.
- Use the precise V4A patch format for diffs when editing files.
- Apply code changes in the smallest practical scope.
- Run tests or code checks if present (including pre-commit hooks if available).
- Do not fix unrelated errors in touched files.
- Remove all inline comments not required after making your changes.
- Never show full file contents unless the user asks.
- Never tell user to "save file"—CLI applies the modification.
- Never add copyright or license headers unless asked.
- Communicate using concise, review-friendly summaries after changes.
- Never interact with `CODEX_SANDBOX_NETWORK_DISABLED_ENV_VAR` in Rust code.
- Never fetch from the Internet or external resources.

### 2. Included/Explicit Project Instructions
- Every code change must include a timestamped, single-line comment at the site of change, using the project-defined format (from `.Superfluid/Config/CommentGuide.md`).
- After every code file edit, append an entry to `.Superfluid/Logs/changeLog.md` with this format:
    - `YYYY-MM-DD HH:mm {file name} {Line Number(s)} {brief description}`
- Log must be append-only, never overwrite previous entries.
- After any code edit, print **"REBUILD REQUIRED"**.
- For multiple files: log each file separately, with relevant context in comments/log entries.

### 3. OpenAI General/Modality Guidelines
- Never make up file contents; always look up or infer from context.
- Use file reads and git commands for extra context if needed.
- When unsure, investigate.
- Do not yield to the user until the requested task is fully and correctly completed (including code, logs, comments, etc).

### 4. Project Personality/Custom Instructions
- Use interaction/communication style outlined in `.Superfluid/Personalities/Jarvis.md` (friendly, precise, proactive).
- Anticipate user needs and suggest optimizations if relevant.

### 5. Collaborative Etiquette
- If pre-commit fails on untouched code, warn user of existing issues but note your change is OK.
- If pre-commit is broken, notify the user.