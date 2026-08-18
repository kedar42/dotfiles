---
name: dev-fleet
description: Use when starting to implement or build a feature — "implement PROJ-123", "start on this feature", "let's build this with agents", "fan out and develop X", "use subagents to build …". FIRST judges whether the work actually warrants a fleet — small / single-file changes just proceed normally (no ceremony, no gates); larger / multi-repo / ambiguous ones get a fleet sized to the change, gated at every phase. Never self-runs past a gate.
---

# Dev fleet

Compose and run a subagent fleet to build a feature the way I work. This is a **toolbox + judgment**, not a fixed pipeline — most of the skill is picking the *right* shape for this particular change. Auto-start the sizing, but **STOP at every gate**; I advance, never you.

## Step 0 — is this even fleet-worthy? then size it up
**First decide whether a fleet is warranted at all.** If it's a small, single-file, low-risk change, say so and just implement it normally — no fan-out, no gates, no ceremony (a lone `scoped-implementer`, or just do it inline). The broad trigger is deliberate: this skill fires on any "implement/start work" phrasing precisely so it can make THIS call — most of the time for a small change the answer is "not a fleet." Only stand up the fleet when size / risk / cross-repo / ambiguity actually warrants it.

When it IS fleet-worthy, judge the change and propose a tailored plan:
- How big / risky / cross-cutting is it? One file, one repo, or many?
- Is it well-specified (a plan/ticket exists) or exploratory/ambiguous?
- Which **stages** does it actually need — and which to skip?
- Which **agents**, how many, split on which axis?
- Does it want a single pass, or **multi-round** (split into N parts, run a mini-fleet per part, then integrate)?

Present that proposed fleet in a sentence or two ("small local change → one implementer + one adversarial-verify, skipping re-review/audit" / "cross-repo → per-repo implementers, then verify + re-review + sweep") and **wait for my go**. Adapt to my adjustments.

**Do Step 0 in plan mode when the feature is non-trivial or ambiguous.** Enter plan mode (`EnterPlanMode`), research read-only, and present the implementation plan AND the proposed fleet together via `ExitPlanMode` — that approval is the first gate. Skip plan mode for small/obvious changes where sizing it up is a sentence. (Native Claude Code plan mode; in OpenCode use its read-only `plan` agent as the equivalent. This is judgment-gated on purpose — don't force plan mode on trivial work.)

## The toolbox

**Fan-out axes** (pick per work):
- multi-repo feature → one `scoped-implementer` per repo/service
- single-repo feature with a plan → one per file/module
- hardening/review of an existing diff → one `lens-reviewer` per lens (not per file)

**Stages** (compose only what fits — order and inclusion vary; each names its agent):
- plan / design (write or read a plan doc)
- implement wave (`scoped-implementer`)
- apply fixes (`scoped-implementer`; bundle ~2 related findings per agent) → confirm each landed (`fix-verifier`)
- contextual safety check (`lens-reviewer`, sonnet) — see below; NOT a full review
- adversarial verify (`adversarial-verifier`, opus)
- re-review (`lens-reviewer`; re-run the lens split; only new issues / regressions)
- comment-density audit (`comment-auditor`)
- simplification / duplication hunt (`lens-reviewer`)
- investigate-before-fix (`investigator`) for ambiguous findings
- sweep (`lens-reviewer`, a fresh finder for what the passes missed)
- multi-round: split into major parts, run a mini-fleet per part, then an integration pass

**Agents** (each carries its own constraints — don't re-state them; `~/.claude/agents/`):
`scoped-implementer` · `lens-reviewer` · `adversarial-verifier` · `fix-verifier` · `comment-auditor` · `investigator`.

**Verify vs investigate:** `adversarial-verifier` renders a verdict on a *specific claim* (CONFIRMED/PLAUSIBLE/REFUTED). Route a surviving **PLAUSIBLE** (or any finding whose fix is unobvious) to `investigator`, which decides worth-fixing and returns a safe minimal plan or "don't bother". `fix-verifier` runs *after* a fix to confirm it landed. Don't run all three on everything — verify to triage, investigate only the uncertain, fix-verify only what you changed.

**Contextual safety check — NOT a full review.** After implementing, look at the diff's touched paths and run ONLY the `safety`-tier lenses from `lens-reviewer`'s catalog whose trigger fired: `layer-boundary` (a data/persistence layer, repository, controller, or frontend file changed) and `db-change-validation` (a migration/schema/model changed). If none fired, skip it entirely. This is a targeted architectural/data gate to catch expensive-to-unwind mistakes early — deliberately NOT the full lens sweep. The full sweep (all lenses, both tiers) is `/review`, run separately when you actually want a PR review.

## How to size (guidance, not rules)
- **Small / local / low-risk** → implement (1–2) + one adversarial-verify; skip re-review, audit, sweep.
- **Large / cross-cutting / multi-repo** → per-repo or per-lens fan-out → fixes → verify → re-review → sweep; add a comment audit if it added many comments.
- **Ambiguous / exploratory** → investigate (or a design pass) FIRST, before any implementer.
- **Deeply nested** → multi-round: split, mini-fleet each part, integrate.
- Freely **drop** a stage/agent that doesn't apply and **add** one that does — the point is the minimal fleet that fits, not the full one.

## Invariants (never drop these, whatever the shape)
- Every slice is **scope-fenced** with an explicit "other agents own X — do not touch it", plus a cross-cutting sweep for what the split misses.
- **Human gate between phases** — I inspect and advance; the fleet never self-chains.
- **Adversarial-verify before trusting** any non-trivial batch of findings (default REFUTED without proof).
- **Explicit model per agent, set at dispatch** — sonnet is the workhorse, opus for verification/hard judgment; never leave a subagent on the default. (The agent files deliberately don't pin a model, so the same file works in Claude and OpenCode — which means YOU must set it on every dispatch.)
- **Agents never touch git** — they leave the tree dirty; I commit. (The read-only agents block Write/Edit at the tool level, but not the shell — so "no git" holds by instruction, not enforcement; don't rely on the tool block to stop a `git`/`rm` via Bash.)
- Every dispatched agent reads the repo's CLAUDE.md / AGENTS.md and matches a cited sibling before writing.
