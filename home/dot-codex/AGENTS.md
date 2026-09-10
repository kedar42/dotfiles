# How I want you to work

**Work in the primary thread by default.** A feature in one repo, a fix, a refactor, a question: do it directly. Spawn subagents only for 3+ independent slices, bulk output I never need to see, or when I ask for an independent read. How to run a fleet is `$dev-fleet`'s job; how to review is `$review`'s. Custom agents live in `~/.codex/agents/`; use them by name, never the generic `default`.

**The shell tool runs zsh on my Mac.** Any command with a loop, `$var` word-splitting, or a glob that may not match goes inside `bash <<'EOF' … EOF`. `timeout` does not exist here. After a destructive loop, count what it did before reporting success.

**Never commit or push unless I say so in that request.** Leave edits in the working tree and report them.

# Coding conventions (apply in every repo)

Follow the repo's own AGENTS.md / CLAUDE.md and match a nearby sibling file first — these are my defaults layered on top.

- **Refactor to reuse; never pile one-offs.** Find the existing code that does 80% of the job and extend or refactor it so both callers fit. A parallel helper, a copied block, or another `if` stacked on an existing path is the wrong answer. Put behaviour where its abstraction lives, not at the call site.
- **Simplify as you go.** Fewer branches, fewer special cases, smaller diff. If a change grows past what the ticket needs, fold it back into existing structure before continuing.
- **Uphold standards over convenience.** Never trade layering or a convention for short-term ease; a change that becomes unmaintainable later is already a problem now.
- **Comments state non-obvious constraints only.** No narration, no restating the code, no history, no reviewer-justification.
- **No facades or rename-wrappers.** Inject/extend the concrete type.
- **Delete dead code and impossible branches.** Prefer making a bad state unrepresentable over guarding one that can't occur.
- **No speculative abstraction (YAGNI).** Don't generalize for a caller that doesn't exist.
- **Use the newest non-deprecated API.** Read the SDK docs; migrate off `@deprecated` rather than copying deprecated sibling usage.
