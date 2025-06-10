# GitHub Setup Guide for Codex Agent Actions

**Purpose:**
These instructions help you configure your environment so the Codex agent can run `git` actions (save, commit, push, and possibly branch, checkout, or pull) on the GitHub repository backing your project.

---

## 1. Git and GitHub Prerequisites
- Ensure `git` is installed and accessible on your system (`git --version`).
- The working directory must be a valid git repository (`git status` should not error).
- You must have push/write access (fork or personal repo OK for personal projects).

## 2. Authentication: Recommended Methods
- **SSH (Preferred):**
    - Generate a new SSH key (if you don’t have one):
      ```sh
      ssh-keygen -t ed25519 -C "your_email@example.com"
      # Follow prompts, then:
      cat ~/.ssh/id_ed25519.pub
      ```
    - Add the public key to your GitHub account (GitHub > Settings > SSH and GPG keys).
    - Test with `ssh -T git@github.com`.
- **HTTPS with Personal Access Token:**
    - Create a new [Personal Access Token](https://github.com/settings/tokens) (repo scope is sufficient).
    - When prompted for password on push, use the token; you may cache it with a credential helper (see below).

## 3. Local Credentials: Passwordless (Optional)
- Configure [Git Credential Manager](https://github.com/GitCredentialManager/git-credential-manager) or cache:
  ```sh
  git config --global credential.helper cache
  # or for more persistent OSX keychain
  git config --global credential.helper osxkeychain
  ```

## 4. Validate Your Setup
- Test a manual `git status`, `git pull`, and `git push` from the repo root.
- If you see auth errors on push, review Steps 2-3 above.

## 5. Agent Usage
- Once the above are set up, you can allow the Codex agent to:
    - Commit staged or all workspace changes
    - Push to your current branch
    - Optionally, create new branches for features/fixes
    - Save/push using provided .bat/.sh scripts, or by direct CLI actions/conversation (describe desired workflow to Codex)
- **Your session permissions persist until you sign out or remove tokens/keys.**

## 6. Troubleshooting
- Make sure you are not in a detached HEAD state (use `git checkout branchname` to fix).
- For submodules, ensure you also have access to those remotes if needed.
- Credential issues are usually solved by clearing and re-adding your token/key as shown above.
- If you use 2FA, HTTPS will require a Personal Access Token.

---

## For Agent Developers (Extending CLI scripts for push/save)
- Reference hooks in scripts like `_save-and-push.bat` or extend with direct CLI calls in shell tool.
- Respect repo commit policy and message standards, if configured by project.

---

[//]: # (SF> 2025-06-09 16:05 | Added GitHub agent setup/user guide for enabling save and push in Codex CLI and scripts.)

---

## Appendix: Windows/PowerShell SSH Key Walkthrough

1. **Open PowerShell** (Start Menu > type `PowerShell`, run as your user).
2. Create your SSH key (replace your email as desired):
   ```powershell
   ssh-keygen -t ed25519 -C "your_email@example.com"
   # When prompted for location, press Enter to accept default (~/.ssh/id_ed25519)
   # (You can set a passphrase or leave blank, press Enter)
   ```
3. Display your new public key to copy for GitHub:
   ```powershell
   # Recommended for Windows PowerShell:
   Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
   # (Using Get-Content is preferred in PowerShell. While 'cat' may work as an alias, it is not always configured on all systems.)
   ```
4. Add this public key on GitHub:
   - Go to GitHub > "Settings" > "SSH and GPG keys" > "New SSH key"
   - Paste in the full key value
5. Test connectivity:
   ```powershell
   ssh -T git@github.com
   # On first attempt, answer 'yes' to trust the github.com host.
   ```
6. You can now commit/push in Git Bash, PowerShell, or Codex CLI environments!

---

[//]: # (SF> 2025-06-09 16:08 | Added SSH key creation walk-through for Windows PowerShell to GitHub_Setup.md.)
