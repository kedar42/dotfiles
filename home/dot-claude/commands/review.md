---
description: Review a PR/diff the way I do — parallel lens finders, batched adversarial verification, ranked verdict-first output. Manual only.
argument-hint: "<PR-url | branch | path> [post] [sweep]"
allowed-tools: Bash(gh *), Bash(git *), Read, Grep, Glob, Task, Skill
---

Run my PR-review fleet against: $ARGUMENTS

This is my own Find→Verify→Synthesize fleet using my reviewer agent types. (It does NOT call the built-in `code-review` plugin; this one is manual and supersedes it for my reviews.)

1. **Target + diff.** Resolve the target. For a PR use `gh pr diff <url>` (never a local `git diff`) and `gh pr view` for context; find the Jira ticket if there is one. **Size it:** a diff under ~150 changed lines gets ONE `lens-reviewer` (sonnet) carrying all lenses, not a fan-out.
2. **Find** — for larger diffs dispatch in parallel: one `lens-reviewer` (sonnet) per quality lens (**ticket-alignment**, **smells/YAGNI/dead-code**, **reuse-and-abstraction**, **codebase-consistency**, **correctness**, **ai-generation-tell**), PLUS — only when the change is structural (persistence/data-layer, repository, controller, or frontend files, or a migration/schema/model changed) — one `standards-reviewer` (opus). For a multi-repo PR add a cross-repo "is the backend change actually used by the frontend" reviewer. Paste the diff into each dispatch so reviewers don't re-fetch it.
3. **Verify** — group findings by file (or by lens if few files) and dispatch one `adversarial-verifier` (opus) **per group, max 4 verifiers**; drop REFUTED and unreachable / not-worth-fixing; keep CONFIRMED/PLAUSIBLE with `file:line` evidence, separating PR-introduced from pre-existing. Skip verification entirely when the find pass returned ≤2 findings — verify those inline.
4. **Sweep** — only if `sweep` was passed: one fresh `lens-reviewer` (sonnet) for what the first pass missed.
5. **Synthesize** — rank correctness above cleanup, cap the list, and give me a **verdict-first prose read** of the 1–2 findings that actually change the merge decision (cause→effect), NO fix snippets in the report.
6. **If `post` was passed** — build the GitHub Reviews API payload (severity-graded body + inline `comments[]` with `path`/`line`/`side`) and submit via `gh api repos/<org>/<repo>/pulls/<n>/reviews --input <file>`. Otherwise just give me the list.

Manual only — I invoke this deliberately; it never runs on its own.
