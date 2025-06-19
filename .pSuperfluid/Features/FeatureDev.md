# Feature Development Workflow

This document defines the **standard operating procedure (SOP)** for turning a high-level feature design into an implemented, tested, and documented deliverable inside _SuperfluidACE-CodexC_.

The goal is to keep every feature change predictable, reviewable, and fully traceable via the `.pSuperfluid` metadata hierarchy.

> **Tooling Shortcut**  
> Run `python .pSuperfluid/Scripts/python/init_feature.py <path-to-design>` to generate the boiler-plate development plan shown below automatically. The helper script will:  
> • Pick the next incremental number,  
> • Slugify the title,  
> • Stamp today’s date, and  
> • Place the new file into `B_Development/` ready for editing.

---

## Directory Summary

```
.pSuperfluid/Features
  ├── A_Design        # User-authored conceptual specs (source of truth)
  ├── B_Development   # Agent-authored implementation plans & execution logs
  └── FeatureDev.md   # ← this SOP
```

---

## End-to-End Flow

1. **User supplies a design file**  
   • Location: `.pSuperfluid/Features/A_Design/<name>.md`  
   • Content: vision, goals, acceptance criteria – free-form.

2. **Agent initialises development**  
   On receiving the user’s request to implement the feature:

   1. _Read_ the provided design file.
   2. **Investigate the codebase** – locate relevant files, identify constraints, and gather context that could influence scoping or approach. Capture key findings.
   3. _Copy & rename_ the design file into `B_Development/NNN_<slug>.md`, where `NNN` is the next incremental number (zero-padded) and `<slug>` is a kebab-case summary.
   4. _Transform_ the copied file into a **Development Plan** using the template below (keep original design context at the top if helpful). Include investigation notes.
   5. _Present_ the plan to the user for confirmation / edits.

3. **Implementation Phase**  
   • Follow the approved Execution Steps within the development document.  
   • For every code change obey project policies (inline timestamps, central changelog).  
   • Update the _Execution Report_ section of the feature file as work progresses.

4. **Completion & Handover**  
   • Mark status as **Complete** in the Execution Report.  
   • Summarise any follow-up actions or downstream tickets.

---

## Development Plan Template

Paste the following scaffold into `B_Development/NNN_<slug>.md` after copying the design file.

```markdown
# Feature NNN – <Human-Readable Title>

_Design origin: A_Design/<file>.md (copied on YYYY-MM-DD)_

## Goal

<one-sentence objective>

## Requirements / Acceptance Criteria

- Bullet list …

## Execution Steps

Use a table to track progress **per step**. Initialise _Status_ to “Not Started”
and _Files_ to “None”. Update them as work progresses.

| #   | Description                            | Status      | Files |
| --- | -------------------------------------- | ----------- | ----- |
| 0   | Investigate codebase & record findings | Not Started | None  |
| 1   | <step>                                 | Not Started | None  |
| 2   | <step>                                 | Not Started | None  |

## Potential Pitfalls

- Bullet list …

## Timeline Estimate

| Task     | ETA |
| -------- | --- |
| Planning | X   |
| Coding   | X   |
| Tests    | X   |
| Docs     | X   |

---

## Execution Report

_Status: In-Progress / Complete / Blocked_

| Date       | Note         |
| ---------- | ------------ |
| YYYY-MM-DD | Created plan |

### Outstanding Actions

1. …

---

## Context for Future Sessions

<Anything a cold-start agent needs to resume work>

### Reporting Expectations

Add a short subsection _after_ the Execution Report whenever a milestone is
completed. It should:

1. Summarise what was implemented.
2. List remaining work or open questions.
3. End with a direct prompt asking the user for confirmation or guidance on
   next steps.
```

---

## Numbering Convention

- Start at `001_…` and increment.
- Keep numbers unique across **B_Development**.

---

## Quick-Reference Cheat-Sheet (for the Agent)

```
User: “I have a new feature – see A_Design/MyIdea.md”

You:
1. Read A_Design/MyIdea.md
2. Derive slug → my-idea
3. Investigate codebase; jot findings
4. Copy → B_Development/00X_my-idea.md
5. Insert Development Plan Template & fill sections (include investigation notes)
6. Show plan to user; await approval
7. Implement; update Execution Report; log changes
```

---

Following this SOP ensures feature work is discoverable, reviewable, and restart-safe across sessions.
