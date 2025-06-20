# 2025-06-20T05:40Z AI: New WSL helper script to handle global linking; invoked by PowerShell wrapper.
#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# rebuild-fluid-wsl.sh
# ----------------------------------------------------------------------------
# Part of "Rebuild Fluid" workflow.
#
# This script is executed *inside* the WSL environment by the Windows
# PowerShell wrapper (RebuildFluid.ps1).  It performs operations that must run
# under Linux – notably, linking the Codex CLI globally via pnpm (preferred)
# with a fallback to npm.
#
# Usage:
#   rebuild-fluid-wsl.sh <repo-path>
#
#   <repo-path>  Path to the Codex CLI repository (already in Linux style,
#                e.g. /mnt/c/_SuperfluidACE/.../codex-cli)
#
# Exit status is non-zero if linking fails.
# ----------------------------------------------------------------------------

set -euo pipefail

# Debug: Show node path and version at script start
echo "[DEBUG] PATH before correction: $PATH"
echo "[DEBUG] node path: $(command -v node || echo 'not found')"
echo "[DEBUG] node version: $(node -v || echo 'node not executable')"

REPO_PATH="${1:-}"
if [[ -z "$REPO_PATH" ]]; then
  echo "Usage: $(basename "$0") <repo-path>" >&2
  exit 1
fi

if [[ ! -d "$REPO_PATH" ]]; then
  echo "Error: path '$REPO_PATH' not found" >&2
  exit 1
fi

echo "[WSL] Rebuild Fluid – linking in $REPO_PATH"

# Ensure pnpm home dir exists so global links are placed on PATH.
# 2025-06-20T05:50Z AI: Use a repo-local directory for global bins to avoid
# permission issues in restricted environments (e.g., CI sandboxes).
GLOBAL_DIR="$REPO_PATH/.wsl-global" # 2025-06-20T05:50Z AI
mkdir -p "$GLOBAL_DIR"

export PNPM_HOME="$GLOBAL_DIR/pnpm"  # Tell pnpm where to place global links // 2025-06-20T09:05Z AI: ensure local pnpm bin dir exists
mkdir -p "$PNPM_HOME"

# 2025-06-20T07:20Z AI: Add PNPM_HOME to PATH so pnpm doesn't error about the
# directory not being in PATH when linking globally.
# 2025-06-20T09:05Z AI: Pre-pend PNPM_HOME and ensure Linux node (/usr/bin) comes before any Windows-mounted
# directories (e.g. /mnt/c/Program Files/nodejs) that sometimes appear first in PATH under WSL and point to an
# outdated Node version.  This guarantees we pick up the distro-installed Node ≥ 16 that the user reports.

export PATH="$PNPM_HOME:/usr/bin:/usr/local/bin:$PATH"

# ---------------------------------------------------------------------------
# Prefer a modern Linux Node interpreter over a Windows-mounted one
# ---------------------------------------------------------------------------
# Some WSL setups automatically add `/mnt/c/Program Files/nodejs` early in PATH
# which can shadow the Linux `node`.  When that version is <16, pnpm fails with
# optional-chaining syntax errors.  Detect this situation and re-export PATH to
# prioritise the Linux binary.
# 2025-06-20T09:05Z AI: Node path correction logic.

node_path=$(command -v node || true)
if [[ "$node_path" == /mnt/c/* ]]; then
  if [[ -x /usr/bin/node ]]; then
    linux_node_major=$(/usr/bin/node -p "process.versions.node.split('.')[0]")
    if (( linux_node_major >= 16 )); then
      echo "[WSL] Detected Windows Node at $node_path (v$(node -p 'process.versions.node')). Switching to Linux Node /usr/bin/node (v$linux_node_major)."
      export PATH="/usr/bin:/usr/local/bin:$PATH"
    fi
  fi
fi

# Ensure npm global prefix is set to a writable directory
export NPM_CONFIG_PREFIX="$GLOBAL_DIR/npm"
mkdir -p "$NPM_CONFIG_PREFIX/bin"

pushd "$REPO_PATH" >/dev/null

# Try pnpm first if available, else npm.  Fall back automatically if pnpm
# fails for any reason (e.g., hoisting issues, package versions).

# Re-compute Node major after PATH fix so we use the intended interpreter.
# Explicitly use /usr/local/bin/node if it exists and is v22+
if [[ -x /usr/local/bin/node ]]; then
  node_major=$(/usr/local/bin/node -p "require('semver').major(process.versions.node)" 2>/dev/null || echo 0)
  export PATH="/usr/local/bin:$PATH" # force it to be first
  hash -r  # clear command hash cache
else
  node_major=$(node -p "require('semver').major(process.versions.node)" 2>/dev/null || echo 0)
fi


if command -v pnpm >/dev/null 2>&1 && (( node_major >= 16 )); then
  echo "[WSL] Using pnpm $(pnpm --version || echo 'unknown')"
  if pnpm link --global; then
    echo "[WSL] pnpm link succeeded"
    popd >/dev/null
    exit 0
  else
    echo "[WSL] pnpm link failed – falling back to npm" >&2
  fi
else
  if (( node_major < 16 )); then
    echo "[WSL] Node version too old for pnpm (detected v${node_major}). Using npm instead." >&2
  else
    echo "[WSL] pnpm not found – using npm" >&2
  fi
fi

if command -v npm >/dev/null 2>&1; then
  npm link
  echo "[WSL] npm link succeeded"
  popd >/dev/null
  exit 0
else
  echo "[WSL] Error: neither pnpm nor npm found in PATH" >&2
  popd >/dev/null
  exit 1
fi
