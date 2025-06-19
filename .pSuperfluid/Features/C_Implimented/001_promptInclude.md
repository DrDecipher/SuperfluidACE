# Feature 001 – Recursive `#include` Expansion in Project Docs

*File originally drafted as **ModelScratch.md** during session 2025-06-19; moved here for long-term reference.*

---

## Goal

Replicate the **C-style `#include` expansion** for Markdown project docs (e.g. `AGENTS.md`) that exists in *CodexNative* inside *CodexC*.

When CodexC loads a documentation file via `loadProjectDoc()` it should:

1. Detect lines that match `#include <path>` (angle-brackets optional, case-insensitive).
2. Recursively inline the referenced file’s contents, wrapped in HTML comment sentinels:

   ```html
   <!-- begin include: path/to/file.md -->
   …file contents…
   <!-- end include: path/to/file.md -->
   ```

3. Prevent infinite loops by tracking already-included absolute paths.


## Source Implementation

Reference file in CodexNative:  
`codex-cli/src/utils/config.ts` → `loadProjectDoc()` + helper `resolveIncludes()`


## Delta Analysis (Native → C)

• Config utility is mostly shared; CodexC lacked `resolveIncludes()`.  
• CodexC’s loader did a simple read-and-truncate.


## Execution Steps (original plan)

1. **Port helper** `resolveIncludes()` to CodexC.
2. Wire it into `loadProjectDoc()` with `Set` loop guard.
3. Confirm necessary imports (`resolvePath`, `dirname`, FS) are present.
4. Add unit tests (Vitest) – basic include and circular include.
5. Update docs (AGENTS.md) to mention the feature.
6. Log changes per Superfluid policies.
7. Build / test.


## Potential Pitfalls

• Circular loops – mitigated by `seen` `Set`.  
• Byte-limit truncation – perform before expansion to match Native behaviour.


---

## Execution Report (2025-06-19)

Status: **Partially Complete**

| Step | Result |
|------|--------|
| 1-3  | ✅  Ported `resolveIncludes` into `codex-cli/src/utils/config.ts` with timestamped comments. |
| 4    | ✅  Added `codex-cli/tests/include.test.ts` (basic + circular). Tests rely on Vitest. |
| 5    | ✅  Added `#include` doc blurb to AGENTS.md. |
| 6    | ✅  Changelog entries created; inline comments added. |
| 7    | ⚠️  Vitest fails to start *inside the sandbox* (esbuild `EPERM`). Tests pass when executed outside the sandbox via manual loader. |


### Outstanding Actions

1. Investigate Vitest/esbuild spawn failure in sandbox (see Learning file `2025-06-19-sandbox-limitations-and-code-bugs.md`).
2. Decide whether to introduce a lightweight test runner that works under Codex sandbox constraints.
3. Upstream TypeScript errors remain; treat separately.


### Context for Future Sessions

• Recursive `#include` is now live in `codex-cli/src/utils/config.ts` – ensure any future refactor preserves that logic.  
• Automated tests exist but may be skipped in sandbox; they should run on full CI.  
• Learning notes under `.pSuperfluid/Learnings/` capture sandbox limitations & compile-time issues.  
• Be mindful of timestamped inline comments & central changelog policy when editing the file.
