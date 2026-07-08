# Gated Development + Integration-Test-First Strategy for project-setup

**Date:** 2026-07-08
**Status:** Approved design, pending implementation plan
**Scope:** `skills/project-setup/` (SKILL.md + references 01, 04, 05, 06, templates)

## Problem

The project-setup interview captures testing strategy and autonomy, but has no way to opt into
*gated development* — blocking, evidence-producing quality checks that shipped work must pass —
nor a development strategy where integration tests act as an immutable contract. Both exist in
practice (see the weloin-futurelab/reflection project: builders-vs-gatekeepers agents,
path-triggered gates, per-task gate reports with PASS / DONE_WITH_CONCERNS / FAIL verdicts) but
the skill cannot set them up.

Both features are independent, both are user-choiceable, and both should be *recommended* by the
skill based on project complexity rather than offered flatly.

## Feature 1 — Gated development (interview Round D)

### Interview change (`references/01-interview.md`)

New question **15b**, placed immediately after autonomy Q15 in Round D:

- Shown only when `autonomy_default` is AUTO or GUIDED. MANUAL projects skip it — the human
  already reviews everything, so blocking gates add ceremony without value.
- Multi-select. The skill derives 3–5 candidate gates dynamically from answers given so far
  (platform, scale, architecture, compliance, NFRs) instead of showing a fixed menu:

| Gate | Offered when | Checks |
|---|---|---|
| Regression gate | always (universal) | full test suite green; no golden/assertion drift; per-task-group proof |
| Goal-alignment gate | always (universal) | work verifiably serves brief/MVP/strategy; blocks scope drift |
| Compare-results gate | measurable baseline exists (perf numbers, eval scores, benchmarks) | new result ≥ baseline, or written justification |
| Contract-compat gate | multi-service / API-surface projects | schema/API changes reviewed for compatibility, version bumps, migration notes |
| Security/privacy gate | compliance answered (GDPR/HIPAA/SOC2/PCI) or sensitive data handled | threat-model conformance, data-handling checks |
| Perf-budget gate | NFR targets given (Round F) or perf constraint stated | budget benches on touching paths |

- Selection recorded in STATE.md as `gates: [...]`. Empty selection → feature entirely off, zero
  footprint downstream.

### Enforcement (`references/04-agents.md`, `references/06-execution.md`)

Scale-dependent, mirroring the existing rigor table:

- **small** — no new agents. The orchestrator runs the gate checklist inline per task-group and
  writes the gate report itself.
- **medium+** — dedicated read-only gatekeeper agents generated into `.claude/agents/`
  (builders-vs-gatekeepers split). Gatekeeper tool surface: Read/Grep/Glob + Bash restricted to
  test/bench runs; never Edit/Write on source. Path-triggered where sensible (e.g. contract
  changes → contract-compat gate). Orchestrator dispatches gatekeepers after the reviewer step,
  before a task counts as done.

### Execution-loop change (`references/06-execution.md`)

New step after the existing reviewer step and before the mode gate: run selected gates, write a
gate report to `docs/project/gates/<task-group>-gate.md` with per-gate verdicts:

- **PASS** → continue.
- **FAIL** → blocks the task; existing retry rule applies (3 failures → escalate to user).
- **DONE_WITH_CONCERNS** → task proceeds; concern appended to the gate report and to a
  `concerns` list in STATE.md; concerns are batch-surfaced at the next task-group boundary (GUIDED)
  or session end (AUTO). Nothing is silently lost, autonomy is preserved for pre-existing issues
  (e.g. repo-wide formatter drift unrelated to the task).

### Templates (`references/templates.md`)

- Gate report template: task/group id, base ref, per-gate verdict + evidence (test counts, diff
  proofs, bench numbers), concerns section.
- STATE.md template gains `gates:` and `concerns:` fields.

## Feature 2 — Integration-test-first strategy (interview Q11)

### Interview change (`references/01-interview.md`)

- Q11 (development strategy) gains a new option: **integration-test-first** (contract-by-test).
- Q11 is also made easier to choose: every strategy option gets a one-line "pick this when…"
  description, and the skill marks one option as its recommendation derived from answers so far
  (complexity, API surface, architecture, scale). Integration-test-first is the recommendation
  when the project is a complex API / multi-service / medium+ scale.
- Chosen → STATE.md `strategy: integration-test-first` plus a rule block in the generated
  CLAUDE.md.

### Semantics

Per feature/task-group ordering:

1. API docs / contract written (plan phase).
2. Integration tests written first and committed as the contract
   (`test: integration contract for <feature>`).
3. Implementation.
4. Unit tests, if enabled in Q13.
5. Integration suite must pass **unmodified**.

Rules:

- **Immutability:** builder agents are forbidden from editing integration tests during
  implementation. Tests conform code to concept — never the reverse.
- **Change protocol:** any functionality/structure change starts by updating the integration
  tests first and committing; the resulting failures enumerate every dependent — the failure list
  is the work list. Fix until green.

### Gate interplay

- Gating enabled and regression gate selected → the regression gate adds a test-immutability
  proof: diff integration tests against the contract commit; any weakened assertion by an
  implementation commit is an automatic FAIL (modeled on reflection's golden-anchor proof —
  "zero numeric assertion literals changed").
- Gating not enabled → ordering + immutability are still enforced by the orchestrator as a
  strategy rule, but no gate report artifact is produced.

## Independence and combination

- Either feature can be chosen without the other.
- Both are recommended (not forced) based on project complexity; the user can always decline.
- Combined, they give the strongest guarantee: contract-by-test ordering plus a blocking,
  evidence-producing proof that the contract was honored.

## Files touched (implementation surface)

- `skills/project-setup/SKILL.md` — mention both features in the phase overview / rigor table.
- `skills/project-setup/references/01-interview.md` — Q11 rework (descriptions + recommendation),
  new Q15b, STATE.md fields.
- `skills/project-setup/references/04-agents.md` — gatekeeper agent generation (medium+).
- `skills/project-setup/references/05-planning.md` — integration-test-first ordering in plans.
- `skills/project-setup/references/06-execution.md` — gate step, verdict handling, change protocol.
- `skills/project-setup/references/templates.md` — gate report template, STATE.md field additions.

## Out of scope

- No changes to other skills (deploy-setup, team, etc.).
- No retro-fitting of existing projects; features apply at setup/align time.
- No CI wiring — gates run in the agent loop; CI integration can layer on later via deploy-setup.

## Testing the skill change

- Dry-run the interview flow on a hypothetical small project (MANUAL): Q15b must not appear,
  no gate artifacts generated.
- Dry-run on a hypothetical medium multi-service API project (AUTO): Q15b appears with
  contract-compat + universal gates; integration-test-first marked as recommended in Q11;
  generated STATE.md carries `gates:` and `strategy:`; generated agents include read-only
  gatekeepers.
