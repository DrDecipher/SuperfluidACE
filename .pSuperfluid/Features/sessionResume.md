# How to Resume an In-Progress Feature Development Session

This file has two parts:

1. **Narrative hand-off** – gives the next agent context so they understand
   what we were doing without trawling through Git history.
2. **Concrete cheat-sheet** – copy/paste commands for the mechanical steps.

The example targets **Feature 002 – Init-Feature Script**, but the pattern
applies to any feature.

---

## 1 Narrative Context

We are extending the _feature-development workflow_ inside SuperfluidACE.

• Feature 001 added recursive `#include` support.  
• Feature 002 created `init_feature.py`, plus Status/Files tracking tables, and
introduced the Milestone-Push Git policy.

In Feature 002 **all steps are complete except Step 7** – adding a
“Reporting Expectations” subsection that:

• Briefly explains what was accomplished so far.  
• Lists any remaining tasks or follow-ups.  
• Ends with a clear question or prompt asking the user how to proceed.

When you (future agent) resume:

1. Open `.pSuperfluid/Features/B_Development/002_init-feature-script.md`.
2. In the Execution-Steps table mark Step 7 Status → _In Progress_ **before**
   editing.
3. Add the missing subsection (copy style from Feature 001).
4. Mark Step 7 _Complete_ and fill the Files column.
5. Append a ChangeLog entry and follow CommentPolicy.
6. **Do not push** until the user approves – see Milestone-Push policy in
   `AGENTS.md`.

If you hit an unexpected error:

• Re-read the project policies in `AGENTS.md` to ensure your next action is compliant.  
• Check `.pSuperfluid/Logs/ChangeLog.md` for recent context.  
• Ask the user for guidance rather than guessing — preserving history is more important than speed.

---

## 2 Copy-and-Paste Cheat-Sheet

---

```bash
# 1. Open the development-plan file in your editor
nvim .pSuperfluid/Features/B_Development/002_init-feature-script.md

# ─────────────────────────────────────────────
# 2. In the Execution-Steps table *first* change
#    Status → "In Progress" on the relevant row
#    (here, row 7 – Reporting Expectations)
# ─────────────────────────────────────────────

# 3. Add the missing subsection inside the plan file
#    ------------------------------------------------
#    ### Reporting Expectations
#    • One-paragraph summary of work completed on Feature 002 so far.
#    • Bullet list of any open questions / remaining actions (should be empty after this addition).
#    • Concluding prompt asking the user to confirm next steps.
#    ------------------------------------------------

# 4. Mark the row as Complete and fill the Files column:
#    Status → "Complete"
#    Files  → .pSuperfluid/Features/B_Development/002_init-feature-script.md

# 5. Save & quit
# :wq  (if using vim)

# 6. Log the change in the central changelog
echo "$(date -u +%Y-%m-%dT%H:%MZ) | .pSuperfluid/Features/B_Development/002_init-feature-script.md : add Reporting Expectations | Finished step 7" >> \
  .pSuperfluid/Logs/ChangeLog.md

# 7. Stage, commit, push
git add .pSuperfluid/Features/B_Development/002_init-feature-script.md \
        .pSuperfluid/Logs/ChangeLog.md
git commit -m "docs(feature 002): add Reporting Expectations section"
git push
```

---

Adapt the path and step number for other features as needed:

1. Replace `002_init-feature-script.md` with the target file.
2. Set the correct step row in the Execution-Steps table.

Following this sequence keeps the **Status/Files** tracking accurate and
ensures the central changelog reflects every change.
