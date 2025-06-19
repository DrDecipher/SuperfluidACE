# Session Save Procedure (template)

Use this document as a checklist **when the user says “save the session”**.

Objective: capture the current working context in
`sessionResume.md` so that a future agent (or future you) can seamlessly pick
up where the work left off.

---

## 1 Gather the Facts

1. Identify the **active feature** (e.g. Feature 002 – Init-Feature Script).
2. Note the **Execution-Steps table** state: which row is _In Progress_ or the
   next to start.
3. Summarise what has been completed this session (1-3 bullet points).
4. List any **open questions** or blockers.
5. Record policy reminders (e.g. Milestone-Push, CommentPolicy).

---

## 2 Overwrite `.pSuperfluid/Features/sessionResume.md`

### Mandatory sections

1. **Narrative Context**  
   • High-level description of feature goals and progress.  
   • What remains to be done.

2. **Copy-and-Paste Cheat-Sheet**  
   Exact shell commands the next agent can run to resume work.

3. **Error-handling Guidance**  
   Steps to take if the next agent encounters an unexpected situation.

### Formatting rules

• Use Markdown headings (`##` level) exactly like sessionResume.md.  
• Keep line width ≤ 100 chars.  
• Use back-ticked code blocks for shell snippets.

---

## 3 Update ChangeLog (local commit only)

Append an entry to `.pSuperfluid/Logs/ChangeLog.md`:

```
YYYY-MM-DDTHH:MMZ | .pSuperfluid/Features/sessionResume.md : overwrite | Saved session state
```

Do **not** push unless this save coincides with a milestone and the user gives
explicit approval.

---

## 4 Example Commit Message

```
docs: save session state for feature 002 (Reporting Expectations in progress)
```

---

Keep this template up to date if the feature-development SOP evolves.
