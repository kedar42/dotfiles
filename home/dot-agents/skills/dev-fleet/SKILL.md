---
name: dev-fleet
description: Use when starting to implement or build a feature — "implement PROJ-123", "start on this feature", "let's build this with agents", "fan out and develop X", "use subagents to build …". FIRST judges whether the work actually warrants a fleet — anything in one repo without independent slices is done inline, no agents; multi-repo or genuinely parallel work gets a fleet sized to the change with two gates (plan, pre-commit). Never self-runs past a gate.
---

# Dev fleet

Compose and run a subagent fleet to build a feature the way I work. This is a **toolbox + judgment**, not a fixed pipeline — most of the skill is picking the *right* shape, and the right shape is usually **no fleet**.

## Step 0 — is this even fleet-worthy?
**Default answer: no.** A change in one repo, even multi-file, is implemented **inline in the primary thread** — no fan-out, no gates, no ceremony. The broad trigger is deliberate: this skill fires on any "implement/start work" phrasing precisely so it can make THIS call.

A fleet is warranted only when the work has **3+ independent slices** that can run concurrently (per repo in a multi-repo change, per module with a written plan) or is **ambiguous enough** to need a read-only investigation before anyone edits. When it is, propose the shape in a sentence or two ("cross-repo → one implementer per repo, then one batched verify" / "ambiguous → investigator first") and **wait for my go**.

**For a non-trivial or ambiguous feature, plan before editing.** Research read-only, then present the implementation plan AND the proposed fleet together in one message — that approval is **gate 1**. Skip the plan for small/obvious changes.

## The toolbox

**Fan-out axes** (pick per work):
- multi-repo feature → one `scoped_implementer` per repo/service
- single-repo feature with a plan and genuinely independent modules → one per module (rare; usually inline instead)
- hardening/review of an existing diff → `$review`, not this skill

**Stages** (compose only what fits; each names its agent):
- plan / design (write or read a plan doc)
- implement wave (`scoped_implementer`) — each dispatch carries the plan section, decisions, and file list verbatim; spawned agents cannot see this thread
- contextual safety check (`standards_reviewer`) — only if the diff touched persistence/repository/controller/frontend or a migration/schema/model; NOT a full review
- simplification pass — after the implement wave, re-read the diff for reuse and abstraction: anything that duplicates an existing helper, adds a branch where an existing path could be extended, or bypasses the layer that owns the behaviour gets folded back in. Inline, or one `lens_reviewer` with the `smells/YAGNI/dead-code` + `reuse-and-abstraction` lenses if the diff is large. The goal is a smaller diff, not more code.
- investigate-before-fix (`investigator`) for an ambiguous finding
- comment-density audit (`comment_auditor`) — only if the wave added many comments
- multi-round: split into major parts, run a mini-fleet per part, then an integration pass

**Agents** (`~/.codex/agents/`; each file pins its own model, effort, and sandbox — don't re-state its constraints in the dispatch):
`scoped_implementer` · `lens_reviewer` · `standards_reviewer` · `adversarial_verifier` · `fix_verifier` · `comment_auditor` · `investigator`. For a plain "where is X" lookup use the built-in `explorer`.

**No verification during development.** `adversarial_verifier` and `fix_verifier` belong to `$review`, run once when the change is complete. Development-time findings come only from the simplification pass, and they are resolved by refactoring into existing structure, never by adding a guard or a patch next to the code.

## How to size (guidance, not rules)
- **One repo** → inline. No agents.
- **Multi-repo** → one implementer per repo (one wave) → simplification pass → done; `$review` at the end.
- **Ambiguous / exploratory** → `investigator` or `explorer` first, then decide.
- **Cap a wave at ~5 agents.** More means the slices are too thin — merge them.
- Freely **drop** a stage that doesn't apply; the point is the minimal fleet that fits.

## Invariants (never drop these, whatever the shape)
- **Dispatch rules live here, not in AGENTS.md.** Always spawn a named custom agent, never the generic `default`; `adversarial_verifier` and `fix_verifier` are `$review`-only. Batch findings per wave, never one agent per item; cap a wave at ~5 agents; serial only on a real dependency, otherwise one concurrent wave.
- **Two gates, not one per phase:** gate 1 = plan + fleet shape approved; gate 2 = before I commit, you present the diff summary and the simplification pass result. Between them the fleet runs through — implement → simplify — without stopping to ask.
- **No adversarial verification, no fix loops, during development.** Those run once in `$review` when the change is complete.
- **Refactor to reuse, never patch.** If existing code fits 80% of a need, extend or refactor it; a parallel one-off, a stacked conditional, or logic placed outside the abstraction that owns it is a defect in the wave, not a follow-up.
- **Decompose before dispatch; parallelize independent slices** as one concurrent wave; serial only on a genuine dependency. Never re-delegate a whole assignment to a single child.
- Every slice is **scope-fenced** with an explicit "other agents own X — do not touch it".
- **Agents never touch git** — they leave the tree dirty; I commit. (Read-only agents are sandboxed; `scoped_implementer` holds "no git" by instruction.)
- Every dispatched agent reads the repo's AGENTS.md / CLAUDE.md and matches a cited sibling before writing. **Paste the relevant plan section and file list into the dispatch** so the agent doesn't rediscover them.
