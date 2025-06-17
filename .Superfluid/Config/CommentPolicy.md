# Rules

1. When modifying any code file, append a timestamped inline comment at each change location using the `SF> {Date/Time}` format; preserve existing comments to maintain history.
2. Only apply this `SF>` inline comment style when making changes to code files (e.g., `.ts`, `.js`, `.rs`); documentation files (e.g., `.md`, `.yaml`) should not receive these inline comments.


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

When adding notes or comments during code modifications, always append new entries rather than replacing or removing existing ones. This preserves a chronological log of changes and the rationale behind them.

Use the `SF>` prefix followed by a timestamp and description. Example in TypeScript:
```ts
// SF> 2025-06-08T09:13 | Initial implementation of session selector.
// SF> 2025-06-09T14:27 | Enhanced menu labels with created/resumed info.
```

Apply the same pattern in other languages using their respective comment syntax as outlined above.
