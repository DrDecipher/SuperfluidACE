# Rules

1. Only merge changes into the `main` branch when explicitly instructed by the user; NEVER performwe have a rul merges to production without direct user request.
2. Local edits can be saved freely, but any commit or push to a remote repository must only occur after explicit user approval.
# Git Policy

This document outlines the Git workflow, branching strategy, commit message conventions, pull request process, code review guidelines, and release versioning policy for the SuperfluidACE project.

## Branching Strategy

1. main: Production-ready code. Protected branch; merges require pull requests and code review.
2. develop: Integration branch for completed features and bug fixes. All development branches merge here.
3. Feature branches: Named feature/<feature-name>. Used for developing new features.
4. Bugfix branches: Named bugfix/<issue-number>-<short-description>. Used for fixing bugs.
5. Release branches: Named release/<version>. Used for preparing releases.

## Commit Message Guidelines

- Format: <type>(<scope>): <subject>
- Types:
  - feat: A new feature
  - fix: A bug fix
  - docs: Documentation changes
  - style: Code style changes (formatting, etc.)
  - refactor: Refactoring code without behavior changes
  - test: Adding or fixing tests
  - chore: Maintenance tasks
- Scope: Optional; e.g. (cli), (config)
- Subject: Brief description (<50 characters).
- Body: Explanation of what and why, if necessary.

Example:
```
feat(cli): add --full-boat flag for auto approvals
```

## Pull Request Process

1. Create PR from feature branch into develop.
2. Title: Same format as commit messages.
3. Description: Link issue, describe changes, test instructions.
4. Request reviewers: At least one code reviewer.
5. Ensure all checks pass (lint, tests, CI).

## Code Review Guidelines

- Review for correctness, readability, and test coverage.
- Ensure adherence to coding standards.
- Provide constructive feedback.

## Versioning and Releases

- Follow Semantic Versioning (MAJOR.MINOR.PATCH).
- For releases:
  1. Create release branch release/vX.Y.Z.
  2. Update CHANGELOG.md with release notes.
  3. Merge into main and tag vX.Y.Z.
  4. Merge back into develop.