<!-- SF> 2025-06-10 17:30 | Created GitHub_Setup_Codex.md explaining SSH-based GitHub setup and challenges -->
# GitHub Setup for Codex CLI

## Successful Setup Steps

1. Generate SSH keypair for Codex agent
   ```shell
   ssh-keygen -t ed25519 -f ~/.ssh/id_codex -N "" -C "codex-agent"
   ```
2. Start the SSH agent and add the key
   ```shell
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_codex
   ```
3. Configure SSH for GitHub
   ```shell
   cat >> ~/.ssh/config << 'EOF'
   Host github.com
     HostName github.com
     IdentityFile ~/.ssh/id_codex
     IdentitiesOnly yes
     StrictHostKeyChecking no
   EOF
   chmod 600 ~/.ssh/config
   ```
4. Add the public key (`~/.ssh/id_codex.pub`) to GitHub
   - Navigate to **Settings → SSH and GPG keys → New SSH key**
   - Paste the contents of `~/.ssh/id_codex.pub` and save.
5. Update the Git remote to use SSH
   ```shell
   git remote set-url origin git@github.com:<YourOrg>/<YourRepo>.git
   ```
6. Verify SSH access to GitHub
   ```shell
   ssh -T git@github.com
   ```
7. Commit and push changes via SSH
   ```shell
   git add .
   git commit -m "<Your commit message>"
   git push origin <branch>
   ```

## What Did Not Work & Challenges

- HTTPS password authentication was removed by GitHub in 2021; attempts to push over HTTPS failed with authentication errors.
- Initial DNS resolution failures in WSL (`Could not resolve host: github.com`) required verifying network and SSH configuration.
- The default Husky pre-commit hook (`pnpm lint-staged`) did not run reliably on Windows/WSL; replaced with a portable shell script.
- `pnpm` was not available in hooks until running `corepack enable`, causing lint/typecheck failures.

By following these SSH configuration steps and using the repaired Husky script, commits and pushes work seamlessly across Windows (WSL) and Linux environments.