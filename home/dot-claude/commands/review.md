---
description: Review a PR/diff the way I do — parallel lens finders, adversarial per-finding verification, ranked verdict-first output. Manual only.
argument-hint: "<PR-url | branch | path> [post]"
allowed-tools: Bash(gh *), Bash(git *), Read, Grep, Glob, Task, Skill
---

Run my PR-review fleet against: $ARGUMENTS

This is my own Find→Verify→Sweep→Synthesize fleet using my reviewer agent types — the shape I've always run by hand. (It does NOT call the built-in `code-review` plugin, which is a different, self-triggering bot; this one is manual and supersedes it for my reviews.)

1. **Target + diff.** Resolve the target. For a PR use `gh pr diff <url>` (never a local `git diff`) and `gh pr view` for context; find the Jira ticket if there is one.
2. **Find** — dispatch `lens-reviewer` agents (sonnet) in parallel, one per fixed lens: **ticket-alignment/scope**, **smells / YAGNI / dead-code**, **codebase-consistency**, **correctness**. For a multi-repo PR add a cross-repo "is the backend change actually used by the frontend" reviewer.
3. **Verify** — one `adversarial-verifier` (opus) per finding; drop REFUTED and unreachable / not-worth-fixing; keep CONFIRMED/PLAUSIBLE with `file:line` evidence, separating PR-introduced from pre-existing.
4. **Sweep** — one fresh `lens-reviewer` (sonnet) for what the first pass missed.
5. **Synthesize** — rank correctness above cleanup, cap the list, and give me a **verdict-first prose read** of the 1–2 findings that actually change the merge decision (cause→effect), NO fix snippets in the report.
6. **If `post` was passed** — build the GitHub Reviews API payload (severity-graded body + inline `comments[]` with `path`/`line`/`side`) and submit via `gh api repos/<org>/<repo>/pulls/<n>/reviews --input <file>`. Otherwise just give me the list.

Manual only — I invoke this deliberately; it never runs on its own.
