# 2025-06-20T03:30Z AI: Re-created after accidental deletion.
# Robust rebuild + global link script for Codex CLI.

param(
    [string]$Path,
    [switch]$NoPause
)

# 2025-06-20T04:20Z AI: Ensure the canonical script file under C:\_SuperfluidACE\scripts is always kept in
# sync. When this copy (inside the repo) is executed directly it self-copies to the external location so the
# right-click context-menu continues to work without manual copying.

$externalScript = 'C:\_SuperfluidACE\scripts\RebuildFluid.ps1'
try {
    if ($PSCommandPath -ne $externalScript) {
        if (-not (Test-Path (Split-Path $externalScript))) {
            New-Item -ItemType Directory -Force -Path (Split-Path $externalScript) | Out-Null
        }
        Copy-Item -Path $PSCommandPath -Destination $externalScript -Force
    }
} catch {
    Write-Warning "Unable to sync script to ${externalScript}: $_"
}

$ErrorActionPreference = 'Stop'

function ThrowIfFailed($step) {
    if ($LASTEXITCODE -ne 0) {
        throw "$step failed with exit code $LASTEXITCODE"
    }
}

# Elevate to admin if not already
$current = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($current)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'Restarting with elevated privileges...'
    # 2025-06-20T05:15Z AI: Preserve output in the elevated console by including -NoExit so users can
    # read any errors instead of the window closing immediately.  // 2025-06-20T05:15Z AI: keep window open
    $args = @('-NoExit','-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"")
    if ($Path) { $args += @('-Path',"`"$Path`"") }
    if ($NoPause) { $args += '-NoPause' }
    Start-Process powershell.exe -Verb RunAs -ArgumentList $args
    exit
}

if (-not $Path) {
    $Path = Get-Location
}

if (-not (Test-Path $Path)) {
    throw "Path $Path not found"
}

Push-Location $Path
try {
    Write-Host "Rebuilding Codex CLI in '$Path'..."

    if (Test-Path node_modules) {
        Remove-Item node_modules -Recurse -Force
    }
    if (Test-Path dist) { Remove-Item dist -Recurse -Force }
    if (Test-Path package-lock.json) { Remove-Item package-lock.json -Force }

    # ------------------------------------------------------------------
    # 2025-06-20T04:40Z AI: Ensure src/version.js exists so esbuild can resolve
    # imports that explicitly specify the .js extension. We simply copy the
    # TypeScript source so the symbol is available; esbuild will bundle the
    # correct code during build.
    # ------------------------------------------------------------------

    $versionTs = Join-Path $Path 'src\version.ts'
    $versionJs = Join-Path $Path 'src\version.js'
    # 2025-06-20T06:00Z AI: Wrap Test-Path call in parentheses so '-and' is treated as a logical operator
    # rather than a parameter to Test-Path, fixing "parameter cannot be found that matches 'and'" error.
    if ((Test-Path $versionTs) -and -not (Test-Path $versionJs)) {
        Copy-Item $versionTs $versionJs -Force
        Write-Host 'Created src\version.js (copied from version.ts)'
    }

    # 2025-06-20T04:35Z AI: Require pnpm – npm causes incorrect hoisting.
    if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
        Write-Error 'pnpm is required but was not found in PATH. Install pnpm (e.g. corepack enable && corepack prepare pnpm@latest --activate) and retry.'
        exit 1
    }

    $usingPnpm = $true
    Write-Host 'Using pnpm for install/build...'

    if ($usingPnpm) {
        pnpm install --filter ./
        ThrowIfFailed 'pnpm install'
    } else {
        npm install
        ThrowIfFailed 'npm install'
    }

    if ($usingPnpm) {
        pnpm run build
    } else {
        npm run build --loglevel info
    }
    ThrowIfFailed 'build'

    # Link on Windows host
    if ($usingPnpm) {
        pnpm link --global
    } else {
        npm link
    }
    ThrowIfFailed 'Windows global link'

    # Prepare WSL path (e.g. C:\path -> /mnt/c/path)
    # 2025-06-20T08:25Z AI: Replace previous regex-scriptblock approach which
    # exposed `$matches` inside the generated Bash command (causing `command
    # substitution: line 2: syntax error` in WSL) with a straightforward
    # substring method.
    $drive = $Path.Substring(0,1).ToLower()   # 'c'
    $rest  = $Path.Substring(2) -replace '\\','/' # '/_SuperfluidACE/...'
    $wslPath = "/mnt/$drive$rest"

    # 2025-06-20T05:42Z AI: Delegate all Linux-side work to a dedicated Bash script for clarity.
    $wslScriptPath = "$wslPath/scripts/rebuild-fluid-wsl.sh"

    # Ensure the script exists; guard against missing file when the user copied only the PS1.
    $localWslHelper = Join-Path -Path $Path -ChildPath 'scripts\rebuild-fluid-wsl.sh'
    if (-not (Test-Path $localWslHelper)) {
        Write-Warning "WSL helper script not found at $wslScriptPath (local: $localWslHelper). Skipping Linux global link step."
    } else {
        # 2025-06-20T06:20Z AI: Use explicit wsl.exe invocation and simple '-c' to avoid PowerShell
        # parameter-binding errors related to combined '-lic'.
        $wslCommand = "cd '$wslPath'; bash '$wslScriptPath' '$wslPath'"
        wsl bash -c "$wslCommand"
        ThrowIfFailed 'WSL link script'
    }

    Write-Host 'Rebuild completed successfully.'
}
catch {
    Write-Error $_
    exit 1
}
finally {
    Pop-Location
}

# ---------------------------------------------------------------------------
# Pause before exiting unless -NoPause was provided.  This helps when users
# launch the script via double-click, giving them a chance to read the output.
# ---------------------------------------------------------------------------
if (-not $NoPause) {
    try {
        Read-Host 'Press Enter to exit'
    } catch {
        # Ignore if stdin is not interactive (e.g. running inside a pipeline)
    }
}

