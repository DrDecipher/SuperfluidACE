You are an AI agent tasked with analyzing a complex codebase to create comprehensive documentation that will assist in planning and implementing new features. Your goal is to investigate the codebase thoroughly and produce a set of structured, human-readable Markdown files that describe its structure, features, methods, dependencies, and other critical elements. This documentation will enable you (or another agent) to navigate the codebase efficiently, understand its components, and integrate new features with minimal errors.

# Instructions
New files will be saved into a directory in the locaiton of and the same name as this file.

Investigate the Codebase: Analyze the provided codebase to identify and document the elements listed below. Use static analysis tools, code inspection, and any available documentation (e.g., README, comments) to gather accurate information.
Document in Markdown: Create a docs/ directory with Markdown files (.md) for each category. Ensure the documentation is clear, concise, and follows a consistent format. Use tables, lists, or code blocks where appropriate to enhance readability.
Organize Output: Include an index.md file linking to all other documentation files. Place all files in a docs/ directory with a logical structure.
Adhere to Best Practices: Ensure the documentation is version-control-friendly, avoids redundancy, and is easy to update. Use diagrams (e.g., Mermaid) for complex relationships if feasible.
Handle Missing Information: If certain details are unclear or missing, note assumptions or gaps in the documentation and suggest how to resolve them (e.g., consulting developers, checking commit history).
Elements to Investigate and Document
Create one Markdown file per category unless specified otherwise, and include the following details:

1. Codebase Structure and Organization (codebase_structure.md)
Map the directory hierarchy, showing the purpose of each folder (e.g., src/, tests/).
Document file naming conventions (e.g., camelCase, snake_case).
Describe how code is modularized (e.g., by feature, layer) and module interactions.
Identify main entry points (e.g., main.py, index.js).

Example:
# Codebase Structure
- src/
  - controllers/ # Handles HTTP request logic
  - models/ # Defines data schemas