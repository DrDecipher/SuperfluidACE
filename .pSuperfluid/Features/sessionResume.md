# How to Resume an In-Progress Feature Development Session

This cheat-sheet shows **exact commands** you can copy-and-paste at the start
of a fresh Codex session to pick up where you left off.  The example uses
**Feature 002 – Init-Feature Script**, but the pattern is identical for any
feature.

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
#    • Summarise feature status and next steps for the user.
#    • … (copy style from Feature 001)
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
