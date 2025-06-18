# File: RebuildFluid.ps1
# Purpose:
#   Rebuilds the Codex CLI package in the specified folder and links it
#   globally so the `codex` command launches this build in both Windows and WSL.
# Usage:
#   - Called by context menu with -Path parameter.
#   - Or run manually: .\RebuildFluid.ps1 -Path "D:\GitHub\codexCLI\codex-cli"

param(
    [string]$Path
)

# Elevate to administrator if needed
$script      = $PSCommandPath
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restarting with elevated privileges..."
    $args = @(
        "-NoProfile", "-NoExit", "-ExecutionPolicy", "Bypass",
        "-File", "`"$script`""
    )
    if ($Path) { $args += @("-Path", "`"$Path`"") }
    Start-Process -FilePath powershell.exe -Verb RunAs -ArgumentList $args
    exit
}

# Resolve default path if none supplied
if (-not $Path) {
    $scriptFolder = $PSScriptRoot
    $parentFolder = Split-Path $scriptFolder -Parent
    $defaultPath  = Join-Path (Join-Path $parentFolder 'codexCLI') 'codex-cli'

    if (Test-Path $defaultPath) {
        $Path = $defaultPath
    } else {
        $Path = Get-Location
    }
}

if (-not (Test-Path -Path $Path -PathType Container)) {
    Write-Error "Path '$Path' does not exist or is not a directory."
    exit 1
}

# Guard: must be run inside a codex-cli folder
if ((Split-Path -Leaf $Path) -ne 'codex-cli') {
    Write-Warning "Must be run within 'codex-cli' directory."
    exit 1
}

Push-Location $Path
try {
    $ErrorActionPreference = 'Stop'
    Write-Host "Rebuilding Codex CLI in '$Path'..."

    # -- Clean previous artefacts ---------------------------------------
    if (Test-Path ".\node_modules") {
        Write-Host "Removing node_modules..."
        Remove-Item ".\node_modules" -Recurse -Force
    } else {
        Write-Host "node_modules not found, skipping."
    }

    if (Test-Path ".\dist") {
        Write-Host "Removing dist..."
        Remove-Item ".\dist" -Recurse -Force
    } else {
        Write-Host "dist not found, skipping."
    }

    if (Test-Path ".\package-lock.json") {
        Write-Host "Removing package-lock.json..."
        Remove-Item ".\package-lock.json" -Force
    }

    if (Test-Path "..\pnpm-lock.yaml") {
        Write-Host "Removing pnpm-lock.yaml..."
        Remove-Item "..\pnpm-lock.yaml" -Force
    }

    # -- Install dependencies ------------------------------------------
    Write-Host "Installing dependencies..."
    npm install

    # -- Build ----------------------------------------------------------
    Write-Host "Building..."
    npm --loglevel info run build

    # -- Link globally in Windows ---------------------------------------
    Write-Host "Linking global 'codex' shim to this build (Windows)..."
    npm link   # (use `pnpm link` if using pnpm globally)

    # -- Link globally in WSL -------------------------------------------
    Write-Host "Linking global 'codex' shim inside WSL..."
    $wslPath = $Path -replace '^([A-Za-z]):\\', { "/mnt/$($args[0].ToLower())/" } -replace '\\', '/'
    wsl bash -lic "cd '$wslPath' && npm link"

    Write-Host "Rebuild completed successfully."
}
catch {
    Write-Error "Rebuild failed: $_"
    exit 1
}
finally {
    Pop-Location
    if (Test-Path "$Path\package-lock.json") {
        Write-Host "Removing package-lock.json post-build..."
        Remove-Item "$Path\package-lock.json" -Force
    }
}
