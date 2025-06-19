# Rust/codex-rs

In the codex-rs folder where the rust code lives:

- Never add or modify any code related to `CODEX_SANDBOX_NETWORK_DISABLED_ENV_VAR`. You operate in a sandbox where `CODEX_SANDBOX_NETWORK_DISABLED=1` will be set whenever you use the `shell` tool. Any existing code that uses `CODEX_SANDBOX_NETWORK_DISABLED_ENV_VAR` was authored with this fact in mind. It is often used to early exit out of tests that the author knew you would not be able to run given your sandbox limitations.

---

## Reporting Expectations (Quick-ref)

Whenever a feature reaches a logical milestone, the agent **must** append a
brief **“Reporting Expectations”** subsection to the feature’s
Development-Plan file that:

1. Summarises what changed.
2. Lists remaining work / follow-ups.
3. Prompts the user for confirmation or next action.

See Feature 001 and Feature 002 for concrete examples.

---

## Milestone-Push Git Policy

Local checkpoints are valuable, but **pushes to the remote repository should
only occur at user-approved milestones**.

1. Make unlimited local commits as you work. Prefix the subject with
   `WIP:` and feel free to use `--no-verify` while code or docs are
   incomplete.
2. A _milestone_ is reached when:
   • The relevant row in the feature’s Execution-Steps table moves from _In
   Progress_ → _Complete_.
   • Lint / tests / build succeed locally.
   • The user explicitly authorises pushing.
3. Before pushing, optionally squash or reword your WIP commits so the final
   history is concise and remove the `WIP:` prefix.
4. After approval:

```bash
git push --set-upstream origin <branch>   # first push
# or simply git push on subsequent pushes
```

This keeps the remote history clean while retaining detailed local history for
easy rollback.

---

## Session Save Requests

When the **user explicitly asks to “save the session”**, overwrite
`.pSuperfluid/Features/sessionResume.md` following the checklist in
`.pSuperfluid/Features/sessionSave.md`.

• Include Narrative Context, Cheat-Sheet, and Error-handling guidance.  
• Append a ChangeLog entry.  
• Commit locally, but **do not push** unless the save aligns with an approved
milestone.
