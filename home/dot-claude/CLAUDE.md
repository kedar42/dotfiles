# Personal coding conventions (apply in every repo)

Follow the repo's own CLAUDE.md / AGENTS.md and match a nearby sibling file first — these are my defaults layered on top.

- **Comments state non-obvious constraints only.** No narration, no restating what the code does, no change/history notes, no reviewer-justification. If the code already shows it, don't comment it.
- **No facades or rename-wrappers.** Inject/extend the concrete type; put new behavior on the class, not an adapter around it.
- **Delete dead code and impossible branches.** Prefer making a bad state unrepresentable (types) over guarding one that can't occur.
- **No speculative abstraction (YAGNI).** Don't generalize for a caller that doesn't exist; two-off superficial similarity is not duplication.
- **Use the newest non-deprecated API.** Read the SDK / official docs; migrate off `@deprecated` rather than copying deprecated sibling usage.
