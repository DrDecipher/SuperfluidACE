<!-- SF> 2025-06-11 10:45 | Created Feature_Template.md as a reusable feature development template -->
# Feature Development Template

Use this template to bootstrap and standardize new feature development within `.Superfluid/Features/<FeatureName>/`.
Copy this file into a new folder named after the feature, and save it as `Feature_Template.md` inside that folder.

---

## 1. Feature Folder Setup
- Create directory: `.Superfluid/Features/<FeatureName>/`
  - `Feature_Template.md` → `<FeatureName>_Plan.md`
  - `Feature_Template.md` → `<FeatureName>_Log.md` (feature change log)
  - `Feature_Template.md` → `<FeatureName>_Learn.md` (learning log)
  - `Feature_Template.md` → `<FeatureName>_Context.md` (session context)


### Context File Add-on <!-- SF> 2025-06-13 16:40 | Added guidance to embed conversation logs when saving context -->
Each time a session is paused, append a context entry **plus** a collapsible block containing the **full chat transcript for that session**.  See **Session Save Workflow** in `AGENTS.md` for exact formatting and size-management tips.

## 2. Plan Document (`<FeatureName>_Plan.md`)
1. **Purpose:** Describe feature goal and motivation.
2. **Preliminary Research & Constraints:** List sandbox, environment, or codebase constraints.
3. **Investigation Section (Step 0):** Record initial experiments or diagnostics.
   - **Status:** Not Started / In Progress / Complete
   - **Files Changed:** N/A or list initial investigation files.
   - **Validation:** How to verify research results (e.g., commands to run).
4. **Step-by-Step Implementation Plan:** Numbered steps starting at 1.
   - For each step:
     - **Status:** Not Started / In Progress / Complete
     - **Files Changed:** List of code or doc paths.
     - **Validation:** Detailed test or check to confirm step completion (agent or user).
5. **Edge Cases & Limitations:** Note any known pitfalls or environment-specific behaviors.

## 3. Feature Change Log (`<FeatureName>_Log.md`)
Use this file to record **feature-specific** change entries (code, docs, configuration) for the feature in development.
If you are not working inside a feature folder, record change entries in the global log at `.Superfluid/Logs/ChangeLog.md`.
Append entries in chronological order:
```
YYYY-MM-DD HH:mm [<FilePath>] <Brief description of change and rationale>
```
Examples:
- `2025-06-11 10:00 [FullBoatWebMode_Plan.md] Added Files Changed and Validation fields under each step.`
- `2025-06-11 10:15 [FullBoatWebMode_Learn.md] Created learning log template.`

## 4. Learning Log (`<FeatureName>_Learn.md`)
Document bugs, resolution attempts, and lessons:
```
### Date: YYYY-MM-DD HH:mm
**Bug/Issue:**
**Files Affected:**
**Attempts to Resolve:**
- Attempt 1: ...
- Attempt 2: ...
**Resolution & Learning:**
**Language/Paradigm Notes:**
**Prevention Tips:**
```

## 5. ChangeLog Entry
- Update `.Superfluid/Logs/ChangeLog.md` after creating or modifying plan/log/learn files.
- Use format:
  `YYYY-MM-DD HH:mm <path> <lines> <brief summary>`

## 6. Review & Commit
- Commit changes with clear message (e.g., `feat: init <FeatureName> feature scaffolding`).
- Run lint, typecheck, tests before pushing.
- After implementing and validating each plan step, obtain user confirmation before pushing commits to the remote repository.

---

**Notes:**
- Follow the comment style in `.Superfluid/Config/CommentGuide.md` for all SF> entries.
- Ensure compliance with AGENTS.md directives (e.g., do not modify Rust sandbox vars if restricted).
```
SF> YYYY-MM-DD HH:mm | Action description with rationale
```