---
name: review
description: Review a PR/diff the way I do — parallel lens finders, batched adversarial verification, ranked verdict-first output. Explicit only — invoke as `$review <PR-url | branch | path> [post] [sweep]`.
---

# Review fleet

Run my PR-review fleet against the target named after `$review`. Flags: `post` submits the review to GitHub; `sweep` adds a second find pass.

This is my own Find→Verify→Synthesize fleet using my custom agents in `~/.codex/agents/`. It does NOT use the built-in `/review` or `$review-agent`; this one supersedes them for my reviews.

1. **Target + diff.** Resolve the target. For a PR use `gh pr diff <url>` (never a local `git diff`) and `gh pr view` for context; find the Jira ticket if there is one. **Size it:** a diff under ~150 changed lines gets ONE `lens_reviewer` carrying all lenses, not a fan-out.
2. **Find** — for larger diffs spawn in parallel: one `lens_reviewer` per quality lens (**ticket-alignment**, **smells/YAGNI/dead-code**, **reuse-and-abstraction**, **codebase-consistency**, **correctness**, **ai-generation-tell**), PLUS — only when the change is structural (persistence/data-layer, repository, controller, or frontend files, or a migration/schema/model changed) — one `standards_reviewer`. For a multi-repo PR add a cross-repo "is the backend change actually used by the frontend" `lens_reviewer`. Paste the diff into each dispatch so reviewers don't re-fetch it.
3. **Verify** — group findings by file (or by lens if few files) and spawn one `adversarial_verifier` **per group, max 4 verifiers**; drop REFUTED and unreachable / not-worth-fixing; keep CONFIRMED/PLAUSIBLE with `file:line` evidence, separating PR-introduced from pre-existing. Skip verification entirely when the find pass returned ≤2 findings — verify those inline.
4. **Sweep** — only if `sweep` was passed: one fresh `lens_reviewer` for what the first pass missed.
5. **Synthesize** — rank correctness above cleanup, cap the list, and give me a **verdict-first prose read** of the 1–2 findings that actually change the merge decision (cause→effect), NO fix snippets in the report.
6. **If `post` was passed** — build the GitHub Reviews API payload (severity-graded body + inline `comments[]` with `path`/`line`/`side`) and submit via `gh api repos/<org>/<repo>/pulls/<n>/reviews --input <file>`. Otherwise just give me the list.

Explicit only — I invoke this deliberately; it never runs on its own.
