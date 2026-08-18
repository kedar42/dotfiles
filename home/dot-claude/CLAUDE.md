# How I want you to work

**Orchestrate by default; don't implement in the main thread.** For substantive work — multi-file, multi-step, parallelizable, or work that benefits from independent/adversarial review — dispatch scoped subagents (my fleet: `scoped-implementer`, `lens-reviewer`, `standards-reviewer`, `adversarial-verifier`, `fix-verifier`, `comment-auditor`, `investigator`) and keep the main window to composing, gating, and reporting. **Judge first** (like `dev-fleet`'s Step 0): a trivial or purely local change — a line, a rename, a quick read or answer — you just do directly; never fan out a one-liner. When you do dispatch, match the agents to what the task actually needs and set each subagent's model explicitly (sonnet workhorse, opus for verification/hard judgment). Dispatch for genuine value (parallelism, context isolation, independent perspective), not as ceremony.

# Personal coding conventions (apply in every repo)

Follow the repo's own CLAUDE.md / AGENTS.md and match a nearby sibling file first — these are my defaults layered on top.

- **Uphold standards over convenience.** These are large, long-lived codebases — never trade concern-separation/layering or a convention for short-term ease ("simpler now, fix later"); a change that will become unmaintainable later is already a problem now. Validate boundaries actually hold; don't rationalize a shortcut.
- **Comments state non-obvious constraints only.** No narration, no restating what the code does, no change/history notes, no reviewer-justification. If the code already shows it, don't comment it.
- **No facades or rename-wrappers.** Inject/extend the concrete type; put new behavior on the class, not an adapter around it.
- **Delete dead code and impossible branches.** Prefer making a bad state unrepresentable (types) over guarding one that can't occur.
- **No speculative abstraction (YAGNI).** Don't generalize for a caller that doesn't exist; two-off superficial similarity is not duplication.
- **Use the newest non-deprecated API.** Read the SDK / official docs; migrate off `@deprecated` rather than copying deprecated sibling usage.
