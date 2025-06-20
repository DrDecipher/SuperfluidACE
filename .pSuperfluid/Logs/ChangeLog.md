2025-06-20T00:25Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 77-110 | Switch to pnpm by default; preserve lockfile; fix WSL path; adds pm detection.
2025-06-20T00:40Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 86-130 | Replace Unicode chars with ASCII; use ';' instead of '&&' to avoid PowerShell parser errors.
2025-06-20T00:50Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 86-140 | Remove --frozen-lockfile; simplified path conversion; fixed parsing errors.
2025-06-20T01:00Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 120-132 | Run 'pnpm setup -y' in WSL before linking to create global bin dir.
2025-06-20T02:10Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 120-160 | Remove failing 'pnpm setup'; create PNPM_HOME dir manually; attempt pnpm link then fallback to npm if needed.
2025-06-20T03:30Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : * | Re-created script after accidental deletion; simplified quoting, added robust error checks, correct exit codes.
2025-06-20T03:45Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 70-90 | Replace && with ';'; escape $HOME; fix Unicode dash in warning.
2025-06-20T04:05Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 80-85 | Use 'export PNPM_HOME=`$HOME...' and semicolons (no PowerShell var expansion).
2025-06-20T04:40Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 55-70,115 | Require pnpm; auto-create src/version.js to satisfy esbuild; ensure pnpm-only workflow.
2025-06-19T00:05Z | codex-cli/src/utils/config.ts : loadProjectDoc() | Added recursive `#include` expansion logic; imported helper and updated truncation handling.
2025-06-19T00:12Z | AGENTS.md : Reporting Expectations section | Added rule requiring a summary report to the user after each feature/bug-fix with next-steps guidance.
2025-06-19T00:20Z | codex-cli/tests/include.test.ts | Added Vitest unit tests for recursive `#include` expansion including circular include guard.
2025-06-19T00:21Z | AGENTS.md : Documentation | Added section describing `#include` support in project docs.
2025-06-19T00:25Z | .pSuperfluid/Learnings/2025-06-19-sandbox-limitations-and-code-bugs.md | Documented Vitest/esbuild sandbox limitation and pre-existing TypeScript errors with proposed mitigations.
2025-06-19T00:28Z | .pSuperfluid/Features/B_Development/001_promptInclude.md | Archived original implementation plan with execution report & future-session context.
2025-06-19T00:31Z | .pSuperfluid/Features/FeatureDev.md & AGENTS.md | Added standard feature-development SOP and agent guidelines.
2025-06-19T00:40Z | .pSuperfluid/Scripts/python/init_feature.py : all | Added automation script to initialise development plans from design docs.
2025-06-19T00:41Z | .pSuperfluid/Features/FeatureDev.md : Tooling Shortcut | Documented new init_feature helper script.
2025-06-19T00:55Z | .pSuperfluid/Scripts/python/init_feature.py : next_number() | Scan C_Implimented directory when computing next feature number.
2025-06-19T00:56Z | .pSuperfluid/Features/A_Design/init_feature_script.md : all | Added user-level design document for helper-script feature.
2025-06-19T00:57Z | .pSuperfluid/Features/B_Development/002_init-feature-script.md : all | Populated development plan, execution report, and outstanding task.
2025-06-19T01:02Z | .pSuperfluid/Features/B_Development/002_init-feature-script.md : Execution Steps | Added Status & Files tracking table; integrated Reporting Expectations as step 7.
2025-06-19T01:03Z | .pSuperfluid/Features/FeatureDev.md : Execution Steps Template | Added Status & Files columns to table.
2025-06-19T01:03Z | .pSuperfluid/Scripts/python/init_feature.py : TEMPLATE | Embedded new table with Status & Files placeholders.
2025-06-19T01:05Z | AGENTS.md : add Reporting Expectations quick-ref | Added guidelines snippet for milestone reporting.
2025-06-19T01:08Z | .pSuperfluid/Features/FeatureDev.md & init_feature.py | Added pre-plan investigation step and updated templates.
2025-06-19T01:08Z | .pSuperfluid/Features/B_Development/002_init-feature-script.md : Execution Steps | Added row for codebase investigation.
2025-06-19T01:10Z | .pSuperfluid/Features/sessionResume.md : all | Added copy-paste cheat-sheet for resuming an in-progress feature.
2025-06-19T01:12Z | AGENTS.md : Milestone-Push Git Policy | Added policy for deferring pushes until user-approved milestones.
2025-06-19T01:14Z | .pSuperfluid/Features/sessionResume.md : Intro & context | Added narrative hand-off section and clarified flow.
2025-06-19T01:18Z | AGENTS.md : Session Save Requests | Documented procedure referencing sessionSave.md.
2025-06-19T23:13Z | .pSuperfluid/Features/B_Development/002_init-feature-script.md : add Reporting Expectations | Finished step 7 – added Reporting Expectations section & updated execution table.
2025-06-19T23:15Z | .pSuperfluid/Features/C_Implimented/002_init-feature-script.md : moved file | Feature 002 marked implemented, moved from B_Development to C_Implimented.
2025-06-19T23:20Z | .pSuperfluid/Features/B_Development/003_home-end-keys.md : created | Initial development plan copied from design file.
2025-06-19T23:30Z | codex-cli/src/text-buffer.ts : handleInput | Added Shift+Home/End selection logic and cleared selection on unmodified Home/End.
2025-06-19T23:31Z | codex-cli/tests/home-end.test.ts : all | Added unit tests for Home/End navigation and selection.
2025-06-19T23:31Z | docs/keybindings.md : new | Documented Home/End keyboard shortcuts.
2025-06-19T23:45Z | multiline-editor.tsx & text-buffer.ts : Home/End fallback | Added explicit CSI sequence handling for Home/End + Shift variants.
2025-06-19T23:59Z | .pSuperfluid/Features/sessionResume.md : overwrite | Saved session state for Feature 003.
2025-06-20T00:00Z | .pSuperfluid/Features/sessionResume.md : overwrite | Saved session state (no code changes, policy review).
2025-06-20T05:15Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 20-30 | Added -NoExit flag when relaunching with admin to keep window open and preserve logs.
2025-06-20T05:42Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 100-140 | Replace inline WSL commands with call to new scripts/rebuild-fluid-wsl.sh.
2025-06-20T05:40Z | codex-cli/scripts/rebuild-fluid-wsl.sh : * | New helper script executed inside WSL to perform global link (pnpm -> npm fallback).
2025-06-20T05:50Z | codex-cli/scripts/rebuild-fluid-wsl.sh : global dir handling | Use repo-local .wsl-global to avoid permission issues; export PNPM_HOME & NPM_CONFIG_PREFIX.
2025-06-20T06:00Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 72 | Parenthesise Test-Path expression to correctly use '-and' operator and fix PowerShell parsing error.
2025-06-20T06:05Z | .pSuperfluid/Logs/Learnings/Powershell.md : * | Created living guide of PowerShell syntax pitfalls & guidelines.
2025-06-20T06:10Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : join-path misuse | Corrected Join-Path usage that caused parameter error for 'rebuild-fluid-wsl.sh'.
2025-06-20T06:20Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : wsl invocation | Replaced '-lic' combo with '-c' to fix PowerShell positional parameter error.
2025-06-20T06:40Z | codex-cli/RebuildFluid.ps1 : * | Added self-contained rebuild script that uses its own directory as repo root.
2025-06-20T07:05Z | codex-cli/RebuildFluid.ps1 : pause | Added -NoPause switch (default off) to keep window open unless explicitly disabled.
2025-06-20T07:20Z | codex-cli/scripts/rebuild-fluid-wsl.sh : PATH | Export PNPM_HOME in PATH to satisfy pnpm global link requirement.
2025-06-20T08:10Z | codex-cli/Rebuild_Fluid.ps1 : * | Wrapper now delegates to canonical .pSuperfluid rebuild script; adds build + fallback logic to fix missing dependency tree.
2025-06-20T08:25Z | .pSuperfluid/Scripts/powershell/RebuildFluid.ps1 : 114-116 | Simplified Windows→WSL path conversion to eliminate `$matches` leaking into bash command causing syntax error.
2025-06-20T08:40Z | codex-cli/scripts/rebuild-fluid-wsl.sh : pnpm gating | Skip pnpm when Node <16 or semver unavailable; avoid corepack parse errors.
2025-06-20T09:05Z | codex-cli/scripts/rebuild-fluid-wsl.sh : PATH fix | Ensure Linux Node in /usr/bin takes precedence over /mnt/c/... to pick up correct Node 22 reported by user.
2025-06-20T09:30Z | codex-cli/Rebuild_Fluid.ps1 : recreated | Wrapper delegates to canonical script and pauses output unless -NoPause given.
