# Development Plan: Add "full-boat" Mode (Network Whitelist) to Codex CLI

**Purpose:**
Implement a new "full-boat" approval mode duplicating "full-auto" but allowing only whitelisted network access (e.g., github.com), with full surfacing in UI/CLI/config, enforcement, and robust test protocol.

### Preliminary Research & Constraints
- Full-auto runs under macOS Seatbelt or Linux Landlock (or equivalent) which disables all outbound network (DNS resolution, TCP/UDP sockets, ICMP). It is by design and not a bug.
- WSL stub resolver can exhibit DNS/ICMP failures independent of sandbox policy; SSH handshakes have succeeded in auto-edit mode but not under full-auto network policies.
- Rust `codex-rs` binary uses `CODEX_SANDBOX_NETWORK_DISABLED` env var and cannot be modified due to AGENTS.md directive. All whitelist logic must live in the CLI/TypeScript agent layer.
- To allow selective network in full-boat, we will bypass the OS sandbox (SandboxType.NONE) for network calls and implement host/domain checks in the CLI before command execution.


## 0. Investigation: Network Behavior under Full-Auto
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; now tracked in FullBoatWebMode_Status.md -->
Validation: Agent to run DNS, SSH, and HTTP tests (e.g., `ping`, `ssh -T`, `curl`) in both auto-edit and full-auto modes and log results.
To diagnose DNS/resolution issues observed in full-auto mode, we tested the following:
-- SSH connectivity: `ssh -T git@github.com -oStrictHostKeyChecking=no` → succeeded previously, authenticated as `git` (exit status 1).
-- Git push over SSH: `git push origin CodexNative` → succeeded previously under auto-edit mode.
-- ICMP ping: `ping -c1 github.com` → exited 2 (OS/firewall may block ICMP in WSL).
-- DNS resolution via HTTP client: `curl -I https://github.com` → exit 6 (could not resolve host).

**Conclusion:** Observed DNS and ICMP failures are due to environmental (WSL stub resolver OS/firewall) issues, not agent sandbox. SSH-based tests have proven connectivity. For `full-boat`, rely on SSH handshake or HTTP checks over HTTPS (which use OS resolver) and provide fallback for DNS anomalies.  


---

## Step-by-Step Implementation Plan

### 1. Add Mode to Enums and Type Definitions
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to add ENUM and policy changes, then run `pnpm typecheck` and `pnpm test` to confirm compilation and existing tests pass.
- Extend `AutoApprovalMode` in `utils/auto-approval-mode.ts`: add `FULL_BOAT = "full-boat"`.
- Update `ApprovalPolicy` in `approvals.ts` to allow 'full-boat' everywhere.
- In all relevant places (type unions, switches), add 'full-boat' option; ensure no missing branch errors.

### 2. Update CLI Arguments and Mode Handling
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to execute `codex --help` and verify `full-boat` appears in `--approval-mode` options.
- In `cli.tsx`:
    - Add 'full-boat' to `--approval-mode` valid argument values and help text.
    - Amend CLI flags and config reading so 'full-boat' is routed correctly into agent logic, just like 'full-auto'.

### 3. UI/UX and User Guidance
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: User to manually verify interactive UI or onboarding overlay includes 'full-boat' option with correct description.
- Update `components/approval-mode-overlay.tsx`, `onboarding/onboarding-approval-mode.tsx`, and related overlays/menus:
    - Add 'full-boat' as an approval mode option to selectors.
    - Describe distinguishing features and rationale ("allows only approved network sites (e.g., github.com)").
    - Update related UI labels, tooltips, and onboarding info as required.
    - Colors/symbols: If needed, assign 'full-boat' a distinct style for clarity.

### 4. Network Whitelist Enforcement
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to test network calls under full-boat mode: `curl https://github.com` should succeed; `curl https://example.com` should fail with clear error.
In the CLI agent (TypeScript) layer, bypass OS sandbox for network calls and implement whitelist enforcement:
- **Bypass sandbox**: in `handle-exec-command.ts`’s `getSandbox(runInSandbox)` detect `full-boat` mode and return `SandboxType.NONE` so network syscalls are allowed by the OS.
- **Pre-flight whitelist check**: in `exec()` (or wrapper) inspect command arguments for network operations:
    - Parse URLs (e.g. in `curl`, `wget`, `git clone/push` remote URLs, `ssh`, `npm install`) to extract hostnames.
    - Compare hostnames against a config-driven whitelist (default `['github.com']`).
    - On any non-whitelisted host, abort execution and surface a clear error or warning to the user.
- **Whitelist configuration**: allow end-users to extend domains via CLI flag or config file (see Step 5).
- **Fallback for DNS anomalies**: if DNS resolution fails (e.g. WSL stub resolver), allow explicit SSH handshake success or cached resolution as a permit for `github.com`.

### 5. Config: Whitelist Specification
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to update config file to include a new domain, then perform a network call to that domain in full-boat mode to verify whitelist extension.
  - Add config file/CLI arg/context to allow end users to specify/extend network whitelist for full-boat (default: [`github.com`, `api.openai.com`])
    - Ensure config is read into session and accessible to enforcement layer.

### 6. Documentation, Help, and Discovery
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to run `codex --help`, review README and AGENTS.md updates; user to review written documentation for clarity.
- Update all overlays/menus/help interfaces that describe available approval modes to mention full-boat and how it differs from full-auto.
- Document CLI options and config variables in usage and README.

### 7. Test and Validate
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent to create and run unit/integration tests (`pnpm test`) covering full-boat behaviors; ensure all new tests pass.
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
<!-- SF> 2025-06-17T14:15 | Removed Status and Files Changed fields; tracking moved to Status document -->
Validation: Agent and user to review code comments and configuration schema to ensure extensibility and backward compatibility.
- All new branches/features have clear code comments for how whitelist and enforcement interact
- Code/logic for whitelist is reusable if new approval/network modes are added
- All config and session files are forward/backward compatible for rolling upgrades
### Edge Cases & Limitations
- **Heuristic parsing:** detecting network operations by parsing CLI arguments may miss custom binaries or low-level socket calls.
- **IP address usage:** commands targeting raw IPs will bypass host-based whitelist; consider extending config to allow IP ranges.
- **Subdomain patterns:** explicit rules needed for common variants (`api.github.com`, `raw.githubusercontent.com`).
- **HTTPS vs SSH:** SSH endpoints rely on key-based auth; HTTP clients may still require DNS resolution which can vary in WSL stub environments.
- **OS sandbox conflicts:** bypassing Seatbelt/Landlock means losing filesystem confinement; we must trust CLI enforcement fully.
- **Rust binary limitations:** cannot relax `CODEX_SANDBOX_NETWORK_DISABLED` in `codex-rs`; full-boat logic only applies to CLI-run tools, not the Rust host process.

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
