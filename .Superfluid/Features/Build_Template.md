I look very goodoe last thin<!-- SF> 2025-06-13 15:45 | Added Build_Template.md as interactive procedure for scaffolding new feature folders -->
# Build-Template – Guided New Feature Scaffolding Procedure

This document defines the **interactive procedure** the agent must follow whenever the user selects **“Start NEW feature”** at session start-up.

The goal is to translate the user’s ideas into a fully-scaffolded feature folder that contains everything required to begin development:

* `.Superfluid/Features/<FeatureName>/<FeatureName>_Context.md`
* `.Superfluid/Features/<FeatureName>/<FeatureName>_Plan.md`
* `.Superfluid/Features/<FeatureName>/<FeatureName>_Log.md`
* `.Superfluid/Features/<FeatureName>/<FeatureName>_Learn.md`

The procedure intentionally mirrors and automates the manual steps described in `Feature_Template.md`.

---

## 0. High-Level Flow (Agent Perspective)

1. Prompt the user with the **Questionnaire** (Section 1) and record the answers.
2. Derive sensible defaults or ask follow-up questions if information is missing or unclear.
3. Create the feature folder and populate the four template files, merging the user’s answers into the relevant sections.
4. Append an entry to `.Superfluid/Logs/ChangeLog.md` summarising the scaffolding action.
5. Present the generated plan back to the user for confirmation. If the user requests edits, loop back and patch as needed.
6. Once approved, mark the new feature as the active feature by updating **ActiveFeature** directive (if project policy still requires it).

At the end of this flow the workspace is ready for Step 0 / Step 1 implementation work.

---

## 1. New Feature Questionnaire

Ask the following questions **in order**. The agent should wait for the user’s response after each question (unless marked *optional*). Feel free to paraphrase for clarity.

1. **Feature name** – A short PascalCase or snake_case identifier (e.g. `FullBoatWebMode`).
2. **One-sentence description** – Elevator pitch for the feature.
3. **Detailed purpose & motivation** – Why is this feature needed? What problem does it solve?
4. **Desired deliverables / acceptance criteria** – How will we know the feature is done? (e.g. new CLI flag, passing tests, docs updated)
5. **Known constraints or dependencies** – Runtime environment, sandbox rules, libraries, external services.
6. **High-level implementation steps** – Rough bullet list; these will seed the Step-by-Step plan.
7. **Expected edge cases & limitations** *(optional)* – Anything we already foresee as tricky.

If the user types `skip` for any optional question, leave the corresponding section blank and add a TODO marker in the generated document.

---

## 2. File Generation Rules

The agent must create the following files **using the current timestamp in all SF> comments**:

### 2.1 <FeatureName>_Context.md
Copy the context template from `Feature_Template.md` (Section 1) verbatim.

### 2.2 <FeatureName>_Plan.md
Populate the **Purpose** section with answers 2 and 3.
Insert answers 4, 5, and 6 into **Preliminary Research & Constraints** and **Step-by-Step Implementation Plan**.
Leave implementation steps as a numbered list starting at 0 (**Investigation**) followed by the bullets given in answer 6.
Any answer left blank → add `<!-- TODO: Provide details -->` so gaps are obvious.

### 2.3 <FeatureName>_Log.md
Copy the example from the template and leave empty for now (except header and creation entry).

### 2.4 <FeatureName>_Learn.md
Copy template structure; no user data required at creation time.

---

## 3. Validation Checklist (Agent Self-review)

Before presenting the result to the user, the agent must verify:

* All four files exist in `.Superfluid/Features/<FeatureName>/`.
* Each file starts with an `SF>` creation comment with the correct timestamp.
* `<FeatureName>_Plan.md` contains user-supplied answers in the correct sections.
* `.Superfluid/Logs/ChangeLog.md` has an appended entry recording file creation.
* *Optional:* `AGENTS.md` ActiveFeature directive updated (if policy remains).

If any item fails, fix it automatically or, if uncertain, re-prompt the user.

---

## 4. Post-creation Prompt

After successful scaffolding the agent should say:

> “Scaffolding for **<FeatureName>** is complete. Review the generated plan below. Let me know if you’d like any tweaks before we start implementation.”

Then display a **concise** summary of the plan (first paragraph, list of steps) rather than dumping full file contents, unless the user asks for details.

---

## 5. Maintenance

If the user later decides the procedure is unclear or needs adjustments, update this `Build_Template.md` using the same change-log and comment rules defined in project policy.
