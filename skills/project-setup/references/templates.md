# Templates

All docs: detailed-compressed style — dense bullets/tables, no filler, no meaning loss.

## STATE.md → `docs/project/STATE.md`

```markdown
# Project State
phase: 1-discovery        # 0-init|1-discovery|2-architecture|3-agents|4-planning|5-execution
autonomy_default: GUIDED  # AUTO|GUIDED|MANUAL
strategy: TBD             # vertical-slice|integration-test-first|server-first|frontend-first|contract-first|infrastructure-first|prototype-first|inside-out|walking-skeleton|behavior-first|data-first|event-first|eval-first|strangler-fig|spike-and-stabilize|custom
gitflow: TBD              # true|false|custom
commit_strategy: TBD      # <style>/<detail>/<signature> — style: conventional|gitmoji|free|custom; detail: body-when-why|always-detailed|minimal|squash-per-task; signature: none|co-author|custom
worktrees: TBD            # per-phase|per-feature|ask|none — ask = prompt (current branch/new branch/worktree) at each substantial change
orchestration: TBD        # session|agent/per-plan|agent/default-agent — who runs the execution loop (06 §Dispatch); agent/per-plan enables parallel orchestrators
scale: TBD                # small|medium|large
maturity: TBD             # prototype|mvp|production — quality bar, overrides per SKILL.md rule 2b
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

## CLAUDE.md (thin; MERGE if exists — never overwrite)

```markdown
# <Project>
<one-line description>

## SSOT
State: `docs/project/STATE.md` — read FIRST every session. Spec: `docs/project/20-architecture.md`. Progress: `docs/project/progress/`. All work conforms to spec; deviations get logged (progress notes + ADR).

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
- Task done ⇒ progress + STATE.md updated in same commit
- Conscious shortcut ⇒ row in `docs/project/40-debt.md`, same commit   <!-- maturity: prototype|mvp only -->
- Agent conflicts (scope/conventions/interfaces) → escalate to user, never silent
- Builders report shared-interface changes in task output

## Agents
Orchestration: <session | agent/per-plan | agent/default-agent>. Default: <orchestrator — agent/default-agent mode only | n/a>. Roster: <name — scope> per line.

## Git
- Branches: <pattern> | Commits: <style> (`commit_strategy` style)
- Detailing: <detail> — <one-line what it means for body/granularity>
- AI attribution in commits: <none | co-author | custom> (`commit_strategy` signature; defers to stricter global/project rule)
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

## Notes
- <blockers, decisions, deviations>
```

## Gate report → `docs/project/gates/<task-group>-gate.md` (gated dev only)

```markdown
# Gate Report — <task-group>
base: <commit sha at group start>   date: YYYY-MM-DD   overall: PASS | DONE_WITH_CONCERNS | FAIL

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
---
You are the <role> for <project>.

## Scope
- Owns: <dirs/files>. Does not touch: <other agents' dirs>.

## References (read at task start)
- `docs/project/STATE.md`, `CLAUDE.md`, spec §<sections for this domain>

## Conventions
- <stack standards, testing requirement, doc style: detailed-compressed>

## Reporting
- What built/changed, tests run+results, **shared interfaces touched** (APIs/types/schemas), shortcuts taken (debt candidates; prototype/mvp), deviations.
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
