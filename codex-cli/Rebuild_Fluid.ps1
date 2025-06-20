# 2025-06-20T09:30Z AI: Created wrapper script to delegate to canonical rebuild &
# optionally pause to keep window open.
# -----------------------------------------------------------------------------
# Rebuild_Fluid.ps1 – convenience wrapper for rebuilding Codex CLI
# -----------------------------------------------------------------------------
# Location: codex-cli/Rebuild_Fluid.ps1
# Delegates to the canonical script under .pSuperfluid so we keep only one
# implementation.  Adds an optional -NoPause switch so users can suppress the
# final "Press Enter" prompt when launching from an existing console.
# -----------------------------------------------------------------------------

param(
    [switch]$NoPause,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$RemainingArgs
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path   # .../codex-cli
$repoRoot   = Split-Path $scriptRoot                            # repo root

$master = Join-Path $repoRoot '.pSuperfluid\Scripts\powershell\RebuildFluid.ps1'

if (Test-Path $master) {
    $fwd = @('-Path',"`"$scriptRoot`"")
    if ($NoPause) { $fwd += '-NoPause' }
    $fwd += $RemainingArgs
    & powershell -NoProfile -ExecutionPolicy Bypass -File $master @fwd
    exit $LASTEXITCODE
}

# ---------------------------------------------------------------------------
# Fallback: minimal rebuild directly in this folder (if canonical script gone)
# ---------------------------------------------------------------------------

Push-Location $scriptRoot
try {
    if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
        Write-Error 'pnpm not found; please install pnpm or restore canonical script.'
        exit 1
    }

    pnpm install --filter ./
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    pnpm run build
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    $drive=$scriptRoot.Substring(0,1).ToLower(); $rest=$scriptRoot.Substring(2) -replace '\\','/'
    $wslPath="/mnt/$drive$rest"
    wsl bash -lc "bash ./scripts/rebuild-fluid-wsl.sh '$wslPath'"
}
finally {
    Pop-Location
    if (-not $NoPause) { Read-Host 'Press Enter to exit' }
}
