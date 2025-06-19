# Feature 002 – Init Feature Script

_Design origin: .pSuperfluid/Features/A_Design/init_feature_script.md (copied on 2025-06-19)_  
_Implemented: 2025-06-19, moved to `C_Implimented` on 2025-06-19_

## Goal

Automate creation of compliant feature-development plan files to save time and
eliminate manual numbering/sluggification errors.

## Requirements / Acceptance Criteria

- CLI one-liner generates a Markdown file in `B_Development/` using the global
  template defined in `FeatureDev.md`.
- The feature number must be the next unused integer when considering **both**
  `B_Development` and `C_Implimented`.
- Works with any design file inside `A_Design`, regardless of its filename
  (no numbered prefix required).
- No external runtime dependencies besides Python ≥ 3.6.
- Prints the relative path of the new file on success.

## Execution Steps

| #   | Description                                                                                                                                                         | Status   | Files                                                          |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------- |
| 0   | Investigate codebase & record findings                                                                                                                              | Complete | (context exploration – no modifications)                       |
| 1   | Draft high-level design (`A_Design/init_feature_script.md`).                                                                                                        | Complete | .pSuperfluid/Features/A_Design/init_feature_script.md          |
| 2   | Implement `init_feature.py` helper script.                                                                                                                          | Complete | .pSuperfluid/Scripts/python/init_feature.py                    |
| 3   | Update `FeatureDev.md` with “Tooling Shortcut” docs.                                                                                                                | Complete | .pSuperfluid/Features/FeatureDev.md                            |
| 4   | Extend script to scan both development and implemented directories.                                                                                                 | Complete | .pSuperfluid/Scripts/python/init_feature.py                    |
| 5   | Log changes in central `ChangeLog.md`.                                                                                                                              | Complete | .pSuperfluid/Logs/ChangeLog.md                                 |
| 6   | Commit & push.                                                                                                                                                      | Complete | (commit 422f27d)                                               |
| 7   | Add **Reporting Expectations** subsection that summarises work done, lists remaining actions (if any), and explicitly prompts the user for confirmation/next steps. | Complete | .pSuperfluid/Features/C_Implimented/002_init-feature-script.md |

## Potential Pitfalls

- Future changes to folder names could break path calculation.
- Duplicate feature numbers if script or user bypasses validation.

## Timeline Estimate

| Task     | ETA                |
| -------- | ------------------ |
| Planning | complete           |
| Coding   | complete           |
| Tests    | manual smoke check |
| Docs     | complete           |

---

## Execution Report

_Status: Complete – Implemented_

| Date       | Note                                 |
| ---------- | ------------------------------------ |
| 2025-06-19 | Created plan                         |
| 2025-06-19 | Implemented script, docs & changelog |
| 2025-06-19 | Moved to `C_Implimented` directory   |

### Outstanding Actions

_None – all execution steps complete._

---

### Reporting Expectations

The automation script `init_feature.py` is now fully implemented and documented.

• Generated feature plan templates via a single CLI call (`python .pSuperfluid/Scripts/python/init_feature.py <design-file>`).  
• Calculates the next available feature number across both _B_Development_ and _C_Implimented_ directories.  
• Updates the boiler-plate sections—Goal, Requirements, Execution Steps—with correct numbering and placeholders.  
• Documentation in `FeatureDev.md` now references the shortcut, and a central ChangeLog trail exists for every change.

Remaining work: **None** – Feature 002 meets all acceptance criteria.

Feature closed.

---

## Context for Future Sessions

This feature is fully implemented; future sessions should ensure any changes
to folder structures or design templates continue to work with
`init_feature.py`. If major redesigns occur, open a new feature plan.
