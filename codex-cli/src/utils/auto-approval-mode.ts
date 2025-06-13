export enum AutoApprovalMode {
  SUGGEST = "suggest",
  AUTO_EDIT = "auto-edit",
  FULL_AUTO = "full-auto",
  FULL_BOAT = "full-boat", // SF> 2025-06-13 12:10 | Added new enum value representing whitelisted network mode per FullBoatWebMode feature Step 1.
}

export enum FullAutoErrorMode {
  ASK_USER = "ask-user",
  IGNORE_AND_CONTINUE = "ignore-and-continue",
}
