## ⚙️ Development Plan: Context Capture & Session Persistence in Codex CLI

### 🎯 Goal

- **What**: Build foundational support for **capturing, storing, and reusing rich context data** in Codex CLI.
- **Why**: This enables future features like session **resumption** and **model switching** without losing relevant history or state, replicating Cursor’s seamless user experience :contentReference[oaicite:1]{index=1}.

---

### 🧩 Core Components

#### 1. Context Capture

- Capture **live, automated recording** of:
  - CLI chat history (user + assistant messages, roles, timestamps)
  - Editor/file state: open files, cursors, recent edits, IDE state
  - Linter/build/test outputs, errors, system metadata
  - Configuration/rules (`.codexrules`), project context :contentReference[oaicite:2]{index=2}
- **Capture method**:
  - Always-on, triggered by every user or CLI event
  - No explicit user prompt needed—fully automatic
  - Optional controls to annotate or suppress sensitive data (e.g. `.env` files)

#### 2. Context Schema & Storage

- Define a **JSON schema** combining:
  ```json
  {
    session_id: string,
    timestamp: string,
    messages: [...],
    editor_state: {...},
    errors: [...],
    rules: [...],
    metadata: {...}
  }
  Session store: map session IDs → context objects
  ```

Options: in-memory, disk, or lightweight DB

Include TTL, size quotas, archival support

Plan for schema versioning and future migrations

🛠 Implementation Checklist
Task Description
Design context schema Capture chat, file, error, and config state
Hook capture logic Trigger capture after each prompt or CLI command
Store session data Assign session IDs; store context snapshots
Expose session API Allow retrieval, listing, and clearing sessions
Capture config/rules Auto‑include .codexrules or project metadata
Implement data trimming Limit payload size; prune old entries
Privacy controls Mask or exclude sensitive data
Testing suite Validate context consistency and performance
Documentation Clarify capture behavior and privacy settings

🔍 Investigation: Architecture & Data Flow
Capture hook points: integrate within REPL loop? CLI command handlers?

Editor state definition: snapshot files vs. track cursor via line numbers?

Payload size limits: align with LLM context-window and memory/performance budgets

Sensitive data handling: mask secrets; support .codexignore

Storage backend decision: in-memory vs persistent vs DB; recovery after restart

Schema versioning strategy: support evolution and backward compatibility

User control options: suppression, annotation, sensitive path filtering

Performance trade-offs: full snapshots vs incremental diffs

🧠 Data Capture Workflow
User performs CLI action or enters a prompt

Capture hook fires, gathering:

Latest user/assistant message

Current open files + cursor positions

Recent errors/linter results

Current config/rules loaded

Append data to session context structure

Persist session context via configured backend

Send context payload to LLM backend when generating response

✅ All data is automatically captured, not triggered by user prompt—enabling seamless state reconstruction.

📌 Summary
Build the core infrastructure to ingest and persist context now.

These foundations support session resumption, model switching, and more.

Focus on:

What data to capture

When to capture it (automatically)

Where in the architecture to integrate

How to store and version it

Performance implications

Embedding these core capabilities prepares Codex CLI for powerful future features and gives your model complete execution context to work from.
