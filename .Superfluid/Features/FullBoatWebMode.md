# Development Plan: Add "full-boat" Mode (Network Whitelist) to Codex CLI

**Purpose:**
Implement a new "full-boat" approval mode duplicating "full-auto" but allowing only whitelisted network access (e.g., github.com), with full surfacing in UI/CLI/config, enforcement, and robust test protocol.

---

## Step-by-Step Implementation Plan

### 1. Add Mode to Enums and Type Definitions
- Extend `AutoApprovalMode` in `utils/auto-approval-mode.ts`: add `FULL_BOAT = "full-boat"`.
- Update `ApprovalPolicy` in `approvals.ts` to allow 'full-boat' everywhere.
- In all relevant places (type unions, switches), add 'full-boat' option; ensure no missing branch errors.

### 2. Update CLI Arguments and Mode Handling
- In `cli.tsx`:
    - Add 'full-boat' to `--approval-mode` valid argument values and help text.
    - Amend CLI flags and config reading so 'full-boat' is routed correctly into agent logic, just like 'full-auto'.

### 3. UI/UX and User Guidance
- Update `components/approval-mode-overlay.tsx`, `onboarding/onboarding-approval-mode.tsx`, and related overlays/menus:
    - Add 'full-boat' as an approval mode option to selectors.
    - Describe distinguishing features and rationale ("allows only approved network sites (e.g., github.com)").
    - Update related UI labels, tooltips, and onboarding info as required.
    - Colors/symbols: If needed, assign 'full-boat' a distinct style for clarity.

### 4. Network Whitelist Enforcement
- In `agent/exec.ts` and `agent/handle-exec-command.ts`, and under `sandbox/*` if enforcing at native level:
    - Add logic to check the current approval mode: If 'full-boat', sandbox/exec or network policy must allow only the approved domains.
    - Implement/check domain whitelist; block all other outbound network.
        - Recommend starting with a policy/config variable, e.g. `ALLOWED_DOMAINS = ["github.com"]`, which can be extended/configured by the user.
    - Enforce this by:
        - Preferably: system sandbox support for network rules (requires per-OS extension; see Landlock/seatbelt docs)
        - Alternately: pre-flight agent check—resolve requested URLs/hosts before command execution, only allow if whitelisted.
        - Fallback: if unable to enforce, show a warning/reject command with correct user feedback
    - Update handling of `CODEX_SANDBOX_NETWORK_DISABLED` or equivalent env handling/mechanisms.

### 5. Config: Whitelist Specification
- In `utils/config.ts` (and/or CLI options):
    - Add config file/CLI arg/context to allow end users to specify/extend network whitelist for full-boat (default: github.com)
    - Ensure config is read into session and accessible to enforcement layer.

### 6. Documentation, Help, and Discovery
- Update all overlays/menus/help interfaces that describe available approval modes to mention full-boat and how it differs from full-auto.
- Document CLI options and config variables in usage and README.

### 7. Test and Validate
#### a. **Unit Testing**
- Write switch/branch coverage tests in all places that now gate on approval mode (enums, overlays, CLI arger parsers, etc).
- Add tests for domain matching (case, URL, subdomain edge cases).

#### b. **Integration Testing**
- Full CLI run in 'full-boat' mode:
    - Attempt outbound connection to whitelisted domain (e.g. github.com): must succeed
    - Attempt outbound connection to non-whitelisted domain: must fail/block with user-facing error or warning
    - File and command access otherwise behaves as in full-auto
    - User can select/see mode in all overlays/menus, onboarding
- Test: CLI help, overlays, onboarding, and session save/load flows reflect the new mode correctly

#### c. **Security/Edge Case Testing**
- Attempt to bypass network restrictions (e.g., IP address, www.github.com, http/https mix)
- Behavior when whitelist is empty or malformed
- Confirm interactions with all other policies, session, and sandbox config layering

#### d. **User Experience/Manual QA**
- As a user, select full-boat from the overlay: confirm summary and restriction language
- Run typical editing/command flows: ensure approval and file sandboxing as usual, network checked accordingly
- Try to switch between modes, saving/resuming session, to confirm consistent logic

### 8. Maintenance & Future Proofing
- All new branches/features have clear code comments for how whitelist and enforcement interact
- Code/logic for whitelist is reusable if new approval/network modes are added
- All config and session files are forward/backward compatible for rolling upgrades

---

## Expected Behavioral Results
- CLI user can select "full-boat" from any place full-auto is available, by argument/onboarding/overlay
- In full-boat mode, only whitelisted domains (`github.com` by default) are accessible outbound
- All non-whitelisted network attempts block with clear error/warning
- UI and CLI help accurately describe differences between approval modes
- Sessions can be saved and resumed with correct enforcement
- No regression in approval policy, overlay, or sandbox handling for older modes

---

## References
- Also see `.Superfluid/Research/ModeAccess.md` for a list of touched files and code dependencies

---

[//]: # (SF> 2025-06-09 15:59 | Detailed plan for step-wise implementation and testing for 'full-boat' whitelisted network approval mode.)
