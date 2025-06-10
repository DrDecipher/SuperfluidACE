# Investigation: Supporting a Network-Whitelisted "full-boat" Mode (Extending full-auto)

## Purpose
Describe in detail which files and code paths would need to be modified in order to:
- Duplicate "full-auto" approval mode as a new "full-boat" mode
- In "full-boat", *allow network access but only for a specific whitelist of domains* (e.g., github.com)
- Ensure consistent behavior throughout UI and agent logic

---

## Where "full-auto" Is Defined/Handled

### 1. Approval Mode/Policy Definitions:
- **`codex-cli/src/utils/auto-approval-mode.ts`**: Enum `AutoApprovalMode` — add 'FULL_BOAT'/'full-boat' here as a new mode.
- **`codex-cli/src/approvals.ts`**:
    - Type `ApprovalPolicy` — add 'full-boat'
    - Logic in `canAutoApprove()` and downstream helpers — Where policy is checked for 'full-auto', must add branches for 'full-boat' with appropriate logic.
    - `canAutoApproveApplyPatch()`, any `policy === "full-auto"` logic

### 2. Mode Selection/Passing in CLI:
- **`codex-cli/src/cli.tsx`**:
    - CLI argument parsing: Add 'full-boat' to `--approval-mode` options and help (`-a`, etc)
    - Remove special-case treatment of just 'full-auto' as a string in any argument or flag combinator logic
    - Command descriptions/documentation/usage help
    - Pass down the mode string, handling equivalence in logic across the codebase

### 3. UI/UX — Overlay and Display
- **`codex-cli/src/components/approval-mode-overlay.tsx`**:
    - Add 'full-boat' to choices exposed to the user and label accordingly (explanation text/UI menu, onboarding blurb)
    - Any overlays that reference "full-auto" (labels, color, summary) must branch for the new mode as well
- **`codex-cli/src/components/model-overlay.tsx`**, **`codex-cli/src/components/onboarding/onboarding-approval-mode.tsx`**
    - Documents onboarding or overlays: update displayed descriptions to mention/describe "full-boat" and what makes it unique

### 4. Sandbox / System Enforcement
- **`codex-cli/src/utils/agent/exec.ts`** & **`codex-cli/src/utils/agent/handle-exec-command.ts`**:
    - Where sandbox/network isolation is enforced for 'full-auto' mode, extend so that:
        - In 'full-auto': network disabled
        - In 'full-boat': sandbox still enabled for file safety, BUT, network is only whitelisted to explicit domains in config/list (e.g. github.com)
    - If logic for network blocking is currently environmental (e.g. `CODEX_SANDBOX_NETWORK_DISABLED`), refactor or extend it with a whitelist override check for 'full-boat'.
    - Consider new env var or policy passed to sandbox machinery to enforce the whitelist.
    - Update/readme/code comments about new policy.

### 5. Config/Persistence
- **`codex-cli/src/utils/config.ts`**: If there's a global or per-session config for network/block/whitelist, add the whitelist config/consumption here.
    - Allow users (and you) to specify/override allowed sites for 'full-boat' mode.
    - Could be passed down from CLI or config file.

---

## Related/Impacted Areas
- **Tests** for all of the above modes (unit/integration)
- **Docs/Help overlays** that list all available approval modes for discovery
- **Docs (REAME, CLI help)** will need update

---

## External/Sandbox Enforcement
- Codex uses native sandboxing (Landlock, seatbelt): Modifications **may be needed** in those exec wrapper/logics if actual network whitelisting needs sandbox enforcement vs. policy-only (i.e., if network syscalls are blocked by sandbox, will need to selectively allow for whitelisted sites in full-boat).
- Location: `codex-cli/src/utils/agent/sandbox/*`
- Alternately, enforce whitelist at the agent/exec layer, not purely at system (easier for MVP, but less robust security—see requirements).

---

## Summary Table
| Area         | Main Files                                                     | What to Add/Change                                     |
|--------------|---------------------------------------------------------------|--------------------------------------------------------|
| Mode enum    | utils/auto-approval-mode.ts, approvals.ts                     | Add new mode & branch logic (approval, strings, type)  |
| CLI args     | cli.tsx                                                       | Argument parsing, usage help, docs                     |
| UI overlays  | components/approval-mode-overlay.tsx, model-overlay.tsx, onboarding-approval-mode.tsx | Mode selection, summary text, onboarding UI             |
| Enforcement  | agent/exec.ts, agent/handle-exec-command.ts, sandbox/*        | Whitelist network only (github.com etc), not full block|
| Config       | utils/config.ts                                               | Whitelist config, session/state handle                 |
| Docs/tests   | README, help overlays, test files                             | Coverage for mode/help                                 |

---

[//]: # (SF> 2025-06-09 15:57 | Outlined all source paths and changes to extend full-auto into a whitelisted-network full-boat mode in Codex CLI.)
