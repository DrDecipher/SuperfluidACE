# Reference: Menu, Confirmation, and Model Selector Implementation

---

## 1. Warning/Confirmation Menu Implementation

### Core Location(s):
- **Hook:** `codex-cli/src/hooks/use-confirmation.ts`  
  - Provides a React hook for confirmation workflows. Manages a queue of confirmation prompts with `requestConfirmation` and stateful rendering of a single prompt at a time.
- **UI Component (Confirmation):** `codex-cli/src/components/chat/terminal-chat-command-review.tsx`  
  - Handles visual review/confirmation menu for command approval. Users can choose options like Yes, Always, No, Explanation via keybindings (`y`, `a`, `n`, `x`, etc.), Esc for close, and so on.
  - Contains logic to allow/disallow always-approve for certain commands (e.g., disables for `apply_patch`).
  - Implements multi-mode menu: Shows selection list, switches to input for feedback, or to display an AI-generated explanation/consequence.
  - Uses Ink's `<Select>`, `<TextInput>`, and supports keyboard navigation. 

### User Experience:
- Confirmation prompts render as overlays inside the chat flow.
- Navigation by keyboard (y/a/n/x/e/s/esc), sometimes text feedback.
- Option to switch auto-approval mode.

## 2. "Version Selector" (/model command overlay)

### Core Location(s):
- **Component:** `codex-cli/src/components/model-overlay.tsx`  
  - Implements UI for switching LLM model **and** provider (version selector for /model command).
  - Uses a Typeahead-style overlay (`typeahead-overlay.tsx`).
  - State allows toggling between provider and model pick list (Tab key).
  - Fetches models dynamically based on selected provider (see `model-utils.ts`).
  - If a chat session has received a response, overlays a warning that model switching is not allowed unless a new chat is started.
- **Component:** `codex-cli/src/components/typeahead-overlay.tsx`
  - Generic search/filter-select menu with configurable input, uses internal list filtering, keyboard navigation, and selection by Enter. Called by model selector, approval mode, and other overlays.
- **Supporting:** `codex-cli/src/components/select-input/select-input.tsx`

### User Experience:
- Starts in "model pick" mode with a filterable list; Tab switches to provider pick mode.
- Model list dynamically updates when a provider is picked.
- Enter to confirm selection, Esc to back/cancel. Instructions and current selection shown in overlay footer.
- If not allowed (active chat), warning-only UI with dismissal guidance.

---

## Summary Table
| Feature           | Source Files                                                     | Core UX Modalities                                        |
|-------------------|------------------------------------------------------------------|-----------------------------------------------------------|
| Confirmation Menu | hooks/use-confirmation.ts, chat/terminal-chat-command-review.tsx | Single overlay, keyboard, dynamic explanation/feedback     |
| Model Selector    | model-overlay.tsx, typeahead-overlay.tsx, select-input/*         | Typeahead filter, provider/model mode, keyboard, messages  |

---

[//]: # (SF> 2025-06-09 12:39 | Added documentation of warning/confirmation and model selector menus as found in Codex CLI src. Review code for further detail or updates.)
