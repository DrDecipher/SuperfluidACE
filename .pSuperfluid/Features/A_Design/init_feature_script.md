# Helper Script for Rapid Feature Plan Bootstrapping

## Vision

Automate the repetitive clerical steps of creating a feature-development plan:

1. Pick next sequential feature number (avoid collisions with completed ones).
2. Copy the standard Development-Plan template.
3. Embed traceability metadata (source design path, date).
4. Generate a slugged filename inside `B_Development/` ready for editing.

## Motivation

Manually renaming & numbering files is error-prone.  A small, dependency-free
Python helper will save time, enforce the SOP, and guarantee naming
consistency across sessions.

## Success Criteria

* Running a one-liner produces a correctly-named Markdown file that passes
  project policies.
* No external dependencies other than Python ≥ 3.6.
* Script must derive the next number even if earlier features are already in
  `C_Implimented/`.

## Out of Scope

• Editing the generated plan content – that remains human/agent work.
• Integrating the script into pre-commit hooks.

---

_EOF_
