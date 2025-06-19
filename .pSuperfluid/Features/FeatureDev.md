# Feature Development Workflow

This document defines the **standard operating procedure (SOP)** for turning a high-level feature design into an implemented, tested, and documented deliverable inside *SuperfluidACE-CodexC*.

The goal is to keep every feature change predictable, reviewable, and fully traceable via the `.pSuperfluid` metadata hierarchy.

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
   2. _Copy & rename_ it into `B_Development/NNN_<slug>.md`, where `NNN` is the next incremental number (zero-padded) and `<slug>` is a kebab-case summary.
   3. _Transform_ the copied file into a **Development Plan** using the template below (keep original design context at the top if helpful).
   4. _Present_ the plan to the user for confirmation / edits.

3. **Implementation Phase**  
   • Follow the approved Execution Steps within the development document.  
   • For every code change obey project policies (inline timestamps, central changelog).  
   • Update the *Execution Report* section of the feature file as work progresses.

4. **Completion & Handover**  
   • Mark status as **Complete** in the Execution Report.  
   • Summarise any follow-up actions or downstream tickets.

---

## Development Plan Template

Paste the following scaffold into `B_Development/NNN_<slug>.md` after copying the design file.

```markdown
# Feature NNN – <Human-Readable Title>

*Design origin: A_Design/<file>.md (copied on YYYY-MM-DD)*

## Goal

<one-sentence objective>

## Requirements / Acceptance Criteria

* Bullet list …

## Execution Steps

1. <step>
2. <step>

## Potential Pitfalls

* Bullet list …

## Timeline Estimate

| Task | ETA |
|------|-----|
| Planning | X |
| Coding   | X |
| Tests    | X |
| Docs     | X |

---

## Execution Report

*Status: In-Progress / Complete / Blocked*

| Date | Note |
|------|------|
| YYYY-MM-DD | Created plan |

### Outstanding Actions

1. …

---

## Context for Future Sessions

<Anything a cold-start agent needs to resume work>
```

---

## Numbering Convention

* Start at `001_…` and increment.  
* Keep numbers unique across **B_Development**.

---

## Quick-Reference Cheat-Sheet (for the Agent)

```
User: “I have a new feature – see A_Design/MyIdea.md”

You:
1. Read A_Design/MyIdea.md
2. Derive slug → my-idea
3. Copy → B_Development/00X_my-idea.md
4. Insert Development Plan Template & fill sections
5. Show plan to user; await approval
6. Implement; update Execution Report; log changes
```

---

Following this SOP ensures feature work is discoverable, reviewable, and restart-safe across sessions.
