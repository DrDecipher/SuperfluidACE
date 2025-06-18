# Rules

1. When modifying any code file, append a timestamped inline comment at each change location using the `SF> {Date/Time}` format; preserve existing comments to maintain history.
2. Only apply this `SF>` inline comment style when making changes to code files (e.g., `.ts`, `.js`, `.rs`); documentation files (e.g., `.md`, `.yaml`) should not receive these inline comments.
3. Log every change to any file—code, documentation, or configuration—in `.Superfluid/Logs/ChangeLog.md`, including the filename, affected line numbers (where applicable), and a concise description of the change.


# Comment Style Guide

This file outlines how comments should be formatted across different languages used in this project. Fill in the examples below with your preferred style and conventions.

## TypeScript / JavaScript
### Single-line
```js
// SF> {Date/Time} | {Description of what was added or changed}
```

### Block
```js
/* SF>
 * {Date/Time} Description of what was added or changed
 * Describe intent, rationale, or important notes.
 */
```

## Rust
### Single-line
```rust
// SF> {Date/Time} | {Description of what was added or changed}
```

### Block
```rust
/* SF>
 * {Date/Time} Description of what was added or changed
 * Describe intent, rationale, or important notes.
 */
```
I 
## YAML
```yaml
# SF> {Date/Time} | {Description of what was added or changed}
```

## TOML
```toml
#  {Date/Time} | {Description of what was added or changed}
```

## C++
### Single-line
```cpp
// SF> {Date/Time} | {Description of what was added or changed}
```

### Block
```cpp
/* SF>
 * {Date/Time} Description of what was added or changed
 * Describe intent, rationale, or important notes.
 */
```
## Change Logging

When modifying any file—code, documentation, configuration, or otherwise—always append a new entry to `.Superfluid/Logs/ChangeLog.md` rather than replacing or removing existing entries. Each entry should include:
- Filename (with relative path)
- Line number(s) changed (for code files)
- A brief, concise description of the change

Entries should be chronological to preserve the history and rationale of changes. For inline code comments, continue using the `SF>` prefix with timestamp as specified in the Rules above.
