# PowerShell Syntax & Script-Writing Learnings

_Last updated: 2025-06-20_

This document collects **bite-sized lessons** we discover while writing or
debugging PowerShell scripts in the SuperfluidACE projects.  Use it as a quick
reference before touching `.ps1` files to avoid repeating historical mistakes.

---

## How to use & extend this guide

1. **Read before you code**:  The agent (and human contributors) should skim
   this file whenever they are about to modify or create PowerShell code.
2. **Append-only**:  Add new lessons **at the end** of the *Learnings* list in
   the same format.  Never delete existing entries—this is a living history.
3. **No duplicates**:  Search (Ctrl/⌘-F) the file for similar wording before
   adding a new item.  If the learning already exists, do not add it again.
4. **Formatting**:  Follow the template shown below so future parsing / skims
   are uniform.

### Template for new entries

```markdown
### YYYY-MM-DD – <one-line title>

**Problem**   : <brief description of the issue encountered>

**Symptoms**  : <error messages / behaviour>

**Root cause**: <why it happened>

**Fix**       : <how we solved/avoided it>

```  
*(blank line above and below the block)*

---

## Learnings

### 2025-06-20 – Logical `-and` requires parentheses around commands

**Problem**   : Using `if (Test-Path $a -and ...)` made PowerShell complain
`A parameter cannot be found that matches parameter name 'and'`.

**Symptoms**  : Script aborted at the conditional, treating `-and` as a
parameter to `Test-Path` instead of a boolean operator.

**Root cause**: In PowerShell, **operators have lower precedence than
`Test-Path` parameters**.  Wrapping each command in parentheses forces the
parser to evaluate them separately.

**Fix**       : Write `if ((Test-Path $a) -and -not (Test-Path $b)) { ... }`.

---

### 2025-06-20 – Prefer `;` over `&&` when chaining commands

**Problem**   : Inside `wsl bash -lic "..."` strings, using `&&` caused
PowerShell lexical errors or mis-parsing.

**Symptoms**  : Unexpected token `&&` in expression or command.

**Root cause**: `&&` is itself a PowerShell operator; unescaped occurrences in
double-quoted strings are parsed before the string reaches WSL.

**Fix**       : Use the POSIX `;` command separator instead (or escape `&&`
with ``` ````), e.g. `wsl bash -lic "cmd1 ; cmd2"`.

---

### 2025-06-20 – Quote `$` variables inside strings passed to WSL

**Problem**   : `$HOME` and other `$…` tokens expanded prematurely in
PowerShell, giving wrong paths in the WSL command.

**Symptoms**  : WSL saw an empty string or Windows-style path instead of the
intended Linux value.

**Root cause**: PowerShell expands `$variables` inside *double-quoted* strings
before execution.

**Fix**       : Either use **single quotes** `'...'` (no interpolation) or
escape the dollar sign `` `$ ``.

---

### 2025-06-20 – Use `-NoExit` when relaunching elevated scripts for visibility

**Problem**   : Elevating with `Start-Process -Verb RunAs` closed the new admin
window immediately after the script finished, hiding build logs.

**Symptoms**  : Users reported “fast exit, no log”.

**Root cause**: Default PowerShell console exits after script completes.

**Fix**       : Include `-NoExit` in the `Start-Process` argument list so the
window stays open.

---

### 2025-06-20 – Delegate Linux-only tasks to a Bash helper script

**Problem**   : Embedding long `wsl bash -lic` strings inside PowerShell was
error-prone and hard to maintain.

**Symptoms**  : Complex quoting, variable-expansion bugs, and readability
issues.

**Root cause**: Mixing two shells in one file introduces heavy quoting/escaping
overhead.

**Fix**       : Move WSL logic to `scripts/rebuild-fluid-wsl.sh` and call it
with a single `wsl bash -ic` invocation.

---

## Agent commitment

The AI assistant will:

1. **Consult this file** before modifying any `.ps1` script.
2. **Search for existing lessons** when encountering an issue to avoid
   duplicate entries.
3. **Append new learnings** using the template above _only_ when the concept is
   not already present.

This ensures continuous improvement without bloat or repetition.
