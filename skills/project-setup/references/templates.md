# Templates

All docs: detailed-compressed style — dense bullets/tables, no filler, no meaning loss.

## STATE.md → `docs/project/STATE.md`

```markdown
# Project State
phase: 1-discovery        # 0-init|1-discovery|1b-ux-prototype|2-architecture|3-agents|4-planning|5-execution
autonomy_default: GUIDED  # AUTO|GUIDED|MANUAL
strategy: TBD             # vertical-slice|integration-test-first|server-first|ui-complete-first|contract-first|infrastructure-first|prototype-first|inside-out|walking-skeleton|behavior-first|data-first|event-first|eval-first|strangler-fig|spike-and-stabilize|custom
fidelity_path: TBD        # wf-hifi-wire|wf-wire-hifi|hifi-direct|n-a — ui-complete-first only (Q11b)
gitflow: TBD              # true|false|custom
commit_strategy: TBD      # <style>/<detail>/<signature> — style: conventional|gitmoji|free|custom; detail: body-when-why|always-detailed|minimal|squash-per-task; signature: none|co-author|custom
worktrees: TBD            # per-phase|per-feature|ask|none — ask = prompt (current branch/new branch/worktree) at each substantial change
orchestration: TBD        # session|agent/per-plan|agent/default-agent — who runs the execution loop (06 §Dispatch); agent/per-plan enables parallel orchestrators
scale: TBD                # small|medium|large
maturity: TBD             # concept|prototype|mvp|production — quality bar, overrides per SKILL.md rule 2b
repo_structure: TBD       # single|monorepo|polyrepo
make_workflow: TBD        # none|A(local-only)|B(deploy-only)|C(both) — built at infra phase via weloin:deploy-setup
gates: []                 # subset of [regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget]; [] = gating off
next: run discovery interview
updated: YYYY-MM-DD

## Notes
- <session-relevant context that fits nowhere else; keep ≤10 lines>

## Concerns   <!-- gated dev only; DONE_WITH_CONCERNS entries; batch-surfaced at next boundary/session end; clear when resolved -->
- YYYY-MM-DD <gate> <task-group>: <one-line concern> → docs/project/gates/<task-group>-gate.md
```

## 00-brief.md

```markdown
# <Project> — Brief
- **What:** <1–2 lines>
- **Problem:** <why exists>
- **Users:** <who, technical level>
- **Platform:** <web/mobile/desktop/cli/...> | **Deploy:** <target>
- **Scale:** <small|medium|large> — <expected users>
- **Constraints:** <stack mandates, compliance, perf, budget>
- **Deadlines:** <dates or none>
## Current State   <!-- ALIGN path only -->
- <what exists and works, one line per area>
```

## 10-requirements.md

```markdown
# <Project> — Requirements
## Features (priority order)
| # | Feature | Notes | MVP |
|---|---|---|---|
## User journeys
- <journey>: start → steps → outcome
## Integrations
- <service>: <purpose, auth method>
## NFRs                <!-- scale: large -->
- latency/throughput/SLO/data targets
## Deferred
- <post-MVP items>
```

## 15-data-contract.md (ui-complete-first exit, 07 §5)

```markdown
# <Project> — Data Contract (derived from UI prototype)
## Screens
| Screen | Data shown | Fixture | Endpoints implied | Mutations (actions) | Parsing/transform |
|---|---|---|---|---|---|
| <name> | <fields user sees> | `fixtures/<file>.json` | `GET /api/…` | `POST /api/…` ← <user action> | <display format vs storage shape> |
## Endpoint index
- `VERB /path` — consumed by: <screens> — shape: `fixtures/<file>.json`
```

Fixtures = machine-readable truth; this doc = compressed index. Divergence = bug. Architecture (03) conforms to this; deviations → ADR.

## 20-architecture.md

```markdown
# <Project> — Architecture
## Overview
- <shape: monolith/services>; diagram or boundary list: <unit> — <single responsibility> — <interface>
## Current / ## Target   <!-- ALIGN path: split -->
## Data model
- <entity>: <fields sketch, relations>
## Interfaces
- <API/contract>: <auth, shape>
## Infra & local dev
- <compose/native; env; seed>
## Security
- authn/authz model; <tenant isolation if multi-tenant>
## Risks
- <risk> → <mitigation>
## Phasing
- MVP: … | v2: … | v3: …
```

## 30-decisions.md

```markdown
# ADR Log
| # | Decision | Context → Consequence | Date |
|---|---|---|---|
| 1 | <choice> | <why → what it costs/buys> | YYYY-MM-DD |
```

## 40-debt.md (maturity: prototype|mvp only) → `docs/project/40-debt.md`

```markdown
# Debt Ledger
| # | Shortcut taken | Production needs | Date | Status |
|---|---|---|---|---|
| 1 | <conscious shortcut, e.g. auth stubbed> | <what hardening requires> | YYYY-MM-DD | open |
```

Every conscious shortcut = row, same commit as the work. Rows never deleted; resolved → `resolved (<commit/plan ref>)`. `promote` sources its hardening plan from open rows.

## Contract doc (rule 12; medium+ & mvp+) → `docs/project/contracts/<boundary>.md`

```markdown
# Contract — <boundary>   <!-- e.g. ui-data-port, http-api, ffi-bridge, events -->
source: <type/schema files the doc derives from>   drift-check: <generator or test cmd that goes red on drift>   owner: <agent>

| Operation / field | In | Out | Errors (consumer must handle) | Optional? |
|---|---|---|---|---|

Capabilities: `<flag>` — <meaning>. Consumers branch on flags, never platform checks.
Forward-compat: unknown field/variant degrades gracefully, never hard-fails.
Change rule: contract commit lands first, alone; consumers fan out after (rule 12).
```

One doc per boundary — the ONLY thing an agent needs to read to work in the layer above. Contract answers missing → fix the contract in the same wave, never reach through it.

## 50-enforcement.md (gates non-empty) → `docs/project/50-enforcement.md`

```markdown
# Enforcement — gates ledger
| Rule | Gate (exact command) | Status | Exceptions (freeze-and-ratchet — list only shrinks) |
|---|---|---|---|
| <binding rule> | <CI's exact invocation; variant/feature builds BOTH ways> | BUILT \| OWED (<owner, trigger>) | <file:line rows frozen at adoption; or —> |
```

BUILT = can go red today; OWED = rule stated, gate pending. Never assume a gate exists — check here. Never add an exception row to make work pass; each fix deletes its own row. Enforcement lands BEFORE the structural fixes it protects.

## CLAUDE.md (thin; MERGE if exists — never overwrite)

```markdown
<!-- project-setup: v<version: from SKILL.md frontmatter> — upgrade baseline stamp; `upgrade` + the RESUME staleness probe diff against this -->
# <Project>
<one-line description>

## SSOT
State: `docs/project/STATE.md` — read FIRST every session (session/orchestrator seat; builders receive state in dispatch text). Spec: `docs/project/20-architecture.md`. Progress: `docs/project/progress/`. All work conforms to spec; deviations get logged (progress notes + ADR).

## Development Strategy
<strategy>: <one line what it means for build order>
<!-- integration-test-first only — include these rules verbatim: -->
- Per feature: API docs → integration tests committed as contract (`test: integration contract for <feature>`) → implement → unit tests (if enabled) → integration suite green UNMODIFIED.
- Integration tests are IMMUTABLE during implementation — never edit to make pass.
- Change protocol: functionality/structure change ⇒ update integration tests FIRST, commit, run suite; failure list = work list; fix until green.

## Commands   <!-- make_workflow != none only -->
Convention: `make <env|surface> <action> [args]`. Examples: `make local up` (bootstrap stack), `make local nuke` (fresh start), `make <env> deploy`, `make setup`. Full surface: `make help`. Env/lifecycle ops go through make targets — never raw docker/kubectl/helm when a target exists.

## Rules
- Doc style: detailed-compressed (dense, complete, no filler)
- <testing requirement>
- Code shape: small single-responsibility files (~800-line soft cap, boy-scout split); tests in per-module `tests/` subfolders (or stack mirror convention) — never inline/sibling test files
- Comments: WHY only, never WHAT — default zero (delete test: comment must add info the code lacks). Narration, signature restating, banners, commented-out code, changelog comments = defects; allowed: rationale/spec refs, safety invariants, `ponytail:` markers, one-line API docs, TODO+debt row
- Task done ⇒ progress + STATE.md updated in same commit
- Conscious shortcut ⇒ row in `docs/project/40-debt.md`, same commit   <!-- maturity: prototype|mvp only -->
- Agent conflicts (scope/conventions/interfaces) → escalate to user, never silent
- Roster/CLAUDE.md/memory drift: orchestrator detects proactively (new stack, out-of-scope failures, uncovered gates, repeated corrections) and proposes the concrete diff; user approves before any write — never wait for the user to notice
- Builders report shared-interface changes + contract deltas in task output
- Contracts: work against the boundary contract (`docs/project/contracts/`), never the layer below; contract change = own commit, landed first   <!-- medium+ -->
- Zero warnings; never suppress a warning or purity/contract violation to compile   <!-- mvp+ -->
- Capabilities, never platforms: feature/UI code branches on declared capability flags, not OS/vendor checks

## Style (always on)   <!-- style skills accepted at roster approval (04 §Style skills) -->
Two project skills define how everyone writes and codes — ENABLED BY DEFAULT for every agent and session; invoke via Skill tool only for the full text:
- **`caveman`** (plugin, or project skill `.claude/skills/caveman/SKILL.md` — per install tier, 04 §Style skills) — terse prose for reports/reviews/audits/plans/progress. Drop filler, keep ALL substance (file:line refs, real numbers, verbatim errors). NORMAL prose in code, comments, commit messages, security warnings, order-critical sequences.
- **`ponytail`** (plugin, or project skill `.claude/skills/ponytail/SKILL.md` — per install tier) — laziest solution that works: reuse ladder, no unrequested abstractions, deletion over addition; mark corner-cuts with a `ponytail:` comment naming ceiling + upgrade path (+ `40-debt.md` row when a real shortcut); comments WHY-only, never WHAT (skill §Comments — narration/banners/commented-out code are defects). Never simplify away trust-boundary validation, error handling, security, spec requirements, or tests.
Agent defs carry the same rules inline (zero invocation cost); the skills are the canonical long form — change both together.

## Agents
Orchestration: <session | agent/per-plan | agent/default-agent>. Default: <orchestrator — agent/default-agent mode only | n/a>. Roster: <name — scope> per line.
Utility (cavecrew, compressed output): `cavecrew-investigator` — locate code (file:line) before builder dispatch; `cavecrew-builder` — surgical 1–2 file edits (refuses 3+); `cavecrew-reviewer` — small-diff reviews between plan boundaries.

## Git
- Branches: <pattern> | Commits: <style> (`commit_strategy` style)
- Detailing: <detail> — <one-line what it means for body/granularity>
- AI attribution in commits: <none | co-author | custom> (`commit_strategy` signature; defers to stricter global/project rule)

## Project tracking (Blink) — not optional   <!-- only when .blink/ wired (rule 7) -->
Live plan lives in `.blink/`, one file per entity, written BEFORE the work — write when you plan, start, finish, block or drop work, and when a real technical choice gets made.
- Tasks: `backlog` → `planned` → `in_progress` → `done`; exits `dropped`, `blocked` (needs `blocked_by`), `paused` (needs `paused_reason`). Never delete a file.
- A real choice becomes a file in `.blink/decisions/`. Run `blink validate` after every write; `0` = clean.
- Scope: Blink = LIVE state only; `docs/project/` (STATE.md, progress, plans) stays config SSOT + history — never duplicated.
Full contract: the `blink:tracking` skill; fields: `.blink/SCHEMA.md` — read both before your first write.
```

## progress/README.md

```markdown
# Progress
| Phase | Name | Status | Branch | Autonomy | Completed |
|---|---|---|---|---|---|
| 1 | <name> | not-started/in-progress/complete | feat/… | AUTO/GUIDED/MANUAL | — |
Task detail → phase files.
```

## progress/phase-N-name.md

```markdown
# Phase N: <Name>
status: not-started | in-progress | complete
branch: feat/phase-N-<name>   worktree: <path|none>   autonomy: <mode>
contracts: <touched contracts from plan header | none>
workstream: <name → orchestrator | n/a>   <!-- parallel dispatch only (05 §2.4) -->
started: — completed: —

## Tasks
- [ ] N.1 <desc> — files: `path` — spec: §ref
- [x] N.2 <desc> — files: `path` — spec: §ref *(YYYY-MM-DD)*

## Tests
| Date | Pass | Fail | Skip | Notes |
|---|---|---|---|---|

## Review
- [ ] Spec conformance
- [ ] Cross-agent conformance   <!-- medium+ -->
- [ ] Layer purity + contract docs match shipped deltas   <!-- medium+ & mvp+ -->

## Notes
- <blockers, decisions, deviations, contract deltas (which contract, what changed)>
```

## Gate report → `docs/project/gates/<task-group>-gate.md` (gated dev only)

```markdown
# Gate Report — <task-group>
base: <commit sha at group start>   date: YYYY-MM-DD   overall: PASS | DONE_WITH_CONCERNS | FAIL
evidence: <captured output file path(s) — a verdict without its capture file is invalid (06 §5b)>

| Gate | Verdict | Evidence |
|---|---|---|
| regression | PASS | <N passed / 0 failed; assertion-drift diff summary> |
| goal-alignment | PASS | <spec §refs served; scope-drift check result> |
| <other selected gates> | … | <numbers/diffs — evidence, never bare verdicts> |

## Concerns   <!-- only if any; mirror one-liner into STATE.md ## Concerns -->
- <concern>: <why not blocking (pre-existing / out of scope)> → <follow-up owner or task>
```

Overall verdict = worst of per-gate verdicts (FAIL > DONE_WITH_CONCERNS > PASS). `strategy: integration-test-first` → regression gate row MUST include integration-test immutability proof: diff integration tests vs contract commit; any weakened/removed assertion by an implementation commit = FAIL.

## Agent file → `.claude/agents/<name>.md`

```markdown
---
name: <kebab-name>
description: Use when <specific trigger for this project — third person>
tools: <per role table in 04-agents.md>
model: opus | sonnet | inherit
memory: project
# orchestrator def only: + the SessionStart STATE.md hooks block (04 §5)
---
You are the <role> for <project>.

## Scope
- Owns: <dirs/files>. Does not touch: <other agents' dirs>.

## References (read at task start)
- `CLAUDE.md`, spec §<sections for this domain>   <!-- orchestrator def only: + docs/project/STATE.md — builders get state via dispatch text (04 §4) -->

## Conventions
- <stack standards, testing requirement, doc style: detailed-compressed>
- Code shape rule 11; contracts rule 12 (work against `docs/project/contracts/`, never the layer below; no suppressions)   <!-- + inline style-skill rules (04 §Style skills) if installed -->

## Reporting
- What built/changed, tests run+results, **shared interfaces touched** (APIs/types/schemas) + **contract deltas**, shortcuts taken (debt candidates; prototype/mvp), deviations.
```

## .gitignore (init path)

```
.claude/agent-memory-local/
.DS_Store
.vscode/
.idea/
.env
.env.local
.env.*.local
node_modules/
vendor/
__pycache__/
dist/
build/
bin/
```
