<!--
SF> 2025-06-09 13:35 | TEST INSTRUCTIONS for #include feature (AGENTS.md expansion)

To verify #include works and survives session restarts:

1. Edit AGENTS.md in your repo root (or other project doc variant) and add lines like:
   #include .Superfluid/Personalities/Jarvis.md
   #include .Superfluid/Config/CommentGuide.md

2. In the included files (e.g., .Superfluid/Personalities/Jarvis.md), add highly recognizable text like:
   "[INCLUDED SUCCESS: Jarvis Personality v1.23]"

3. Restart your agent/session or run the CLI as normal.

4. Look for the included content—either by viewing the loaded agent/system context, or by output/log inspection.

5. Test recursion:
   - In one included file, add another #include to a third file (A includes B, B includes C).
   - Confirm all content is expanded, but recursion is not infinite (each file included once per chain).

6. For negative testing:
   - Reference a non-existent file (e.g. #include missing.md).
   - Confirm the output contains "<!-- include not found or already included: missing.md -->" as a comment.

7. For circular includes:
   - File A #includes B, File B #includes A.
   - Confirm both files are included, and the loader does not repeat them infinitely.

Result: If test text appears and all expected #include lines are expanded or commented, feature is working.
--
<!-- SF> 2025-06-09 13:28 | Created inclusion plan and session implementation log per SuperfluidACE change tracking. All steps summarized, corrected per AGENTS.md instructions. -->
### Implementation Notes (Step 1: Identify All Project Doc Loads)

- AGENTS.md/codex.md references are minimal in the codebase and mainly abstracted.
- Project Doc discovery/reading is centralized in `codex-cli/src/utils/config.ts`:
  - `discoverProjectDocPath(startDir: string)` for file resolution.
  - `loadProjectDoc(cwd: string, explicitPath?: string)` for loading content.
  - `resolveIncludes` (inline) appears to process includes.
- At CLI/entrypoint (`codex-cli/src/cli.tsx`), config/project doc is loaded using high-level functions, not raw file reads.
- #include logic is likely consistently used **if all usages go through this loader**.

---
## Plan: Robust #include Support for Project Docs (AGENTS.md, codex.md etc)

### Objective
- Ensure AGENTS.md (or project doc alias) is always loaded on agent startup.
- Provide reliable and consistent support for recursive `#include <...>` functionality in all project doc reads, such that included files are expanded in the final delivered context.
- Maintain documentation for stepwise resumability in case of crash/session-loss.

---

### 1. Identify All Project Doc Loads
- Purpose: Find every reference in codebase where AGENTS.md, codex.md, or variants are loaded.
- Actions:
  - Search repo for AGENTS.md, codex.md, .codex.md, CODEX.md in code (string/filename usage, config, etc).
  - Search repo for functions/utilities relating to agent/project startup instructions or context (agent loader, config, bootstrap, CLI startup etc).

### 2. Document the Loading Pathways
- Purpose: For each loading reference, trace "upwards" to see how and where project docs end up in config/context/agent settings.
- Actions:
  - Note what reads the file and what consumers (functions/systems/objects) process it.
  - Understand if it’s read for context, for config, or something else.

### 3. Audit for Direct Reads (Bypass of #include)
- Purpose: Identify if/where project docs are loaded without #include expansion (raw reads or missing resolveIncludes).
- Actions:
  - Find all uses of `readFileSync`, `fs.readFile*`, or similar for project doc files.
  - Mark if they call `resolveIncludes` (or similar) or not.

### 4. Centralize #include Expansion
- Purpose: Make/choose a single loader function (e.g., `loadProjectDocWithIncludes`) as the canonical, tested path for all project doc reads.
- Actions:
  - Inspect/clean/prepare the chosen function (currently `resolveIncludes`) for maximum reliability and reusability.
  - Update documentation in code as needed.

### 5. Plan a Safe Refactor/Replacement
- Purpose: Swap in the new function for all project doc loads, minimize duplication or missed edge cases.
- Actions:
  - List all code locations where loaders should be patched.
  - Ensure every place project docs are loaded uses the new loader.

### 6. Implementation & Test
- Purpose: Carry out patch in stages, verify after each with appropriate test files and logging.
- Actions:
  - Patch code in small increments—commit between stages.
  - Add test cases for (a) simple includes, (b) recursive, (c) error/missing includes, (d) circular includes.
  - Check output or logging to ensure correct expansion.
  - Document any blockers, unexpected complexities, or resolved issues as you proceed.

### Validation & Resumption
- After each successful step, add implementation notes to this file.
- If interrupted, resume with a review of this file’s progress log.

---

**Upon starting a new session, always read this file and resume at the appropriate implementation step.**