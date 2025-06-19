# Feature 002 – Init Feature Script

*Design origin: .pSuperfluid/Features/A_Design/init_feature_script.md (copied on 2025-06-19)*

## Goal

Automate creation of compliant feature-development plan files to save time and
eliminate manual numbering/sluggification errors.

## Requirements / Acceptance Criteria

* CLI one-liner generates a Markdown file in `B_Development/` using the global
  template defined in `FeatureDev.md`.
* The feature number must be the next unused integer when considering **both**
  `B_Development` and `C_Implimented`.
* Works with any design file inside `A_Design`, regardless of its filename
  (no numbered prefix required).
* No external runtime dependencies besides Python ≥ 3.6.
* Prints the relative path of the new file on success.

## Execution Steps

1. Draft high-level design (`A_Design/init_feature_script.md`).
2. Implement `init_feature.py` under `.pSuperfluid/Scripts/python/`.
3. Update `FeatureDev.md` with “Tooling Shortcut” docs.
4. Extend script to scan both development **and** implemented directories.
5. Log changes in central `ChangeLog.md`.
6. Commit & push.

## Potential Pitfalls

* Future changes to folder names could break path calculation.
* Duplicate feature numbers if script or user bypasses validation.

## Timeline Estimate

| Task | ETA |
|------|-----|
| Planning | complete |
| Coding   | complete |
| Tests    | manual smoke check |
| Docs     | complete |

---

## Execution Report

*Status: Complete*

| Date | Note |
|------|------|
| 2025-06-19 | Created plan |
| 2025-06-19 | Implemented script, docs & changelog |

### Outstanding Actions

1. Add **Reporting Expectations** subsection (same pattern used in Feature 001) to `002_init-feature-script.md` so future tasks are summarised for users.

---

## Context for Future Sessions

<Anything a cold-start agent needs to resume work>
