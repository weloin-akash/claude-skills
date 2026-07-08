# Strategy Catalog Expansion + Recommendation Matrix for project-setup

**Date:** 2026-07-08
**Status:** Approved design, pending implementation plan
**Scope:** `skills/project-setup/` (references 01, 02, 06, templates) + README

## Problem

Q11 offers 8 development strategies with one loosely-derived recommendation. Gaps: no strategy
for event-driven systems, ML/LLM products (quality measured by evals, not assertions), data-heavy
apps, legacy modernization (ALIGN path has no migration strategy), BDD-style stakeholder-driven
work, deploy-risk-first products, or spike-then-rebuild flows. And the recommendation logic is
implicit ("derived from answers so far") — no explicit project-kind → strategy mapping, so the
choice quality depends on the session model's mood.

## Feature 1 — seven new strategies (Q11, `references/01-interview.md`)

Each with a one-line "pick when" (existing convention) **plus** an explicit `Order:` pipeline —
and the 8 existing strategies gain `Order:` pipelines too, so every strategy is executable by the
planner (05 orders phases from it), not just a label.

| Strategy | Order pipeline | Pick when |
|---|---|---|
| walking-skeleton | thinnest end-to-end slice incl. CI/deploy → flesh out features | new platform / deployment risk dominates; proves the whole pipe day one |
| behavior-first (BDD) | user scenarios as executable specs → implement until scenarios pass | non-technical stakeholders, acceptance-criteria-driven |
| data-first (schema-first) | data model + migrations → queries → API → UI | data-heavy apps, ETL, reporting, analytics |
| event-first | domain events + message contracts → consumers/producers → UI | event-driven, CQRS, async multi-service |
| eval-first | eval harness + quality metrics → baseline → iterate until targets | ML/LLM/agent products — quality measured, not asserted |
| strangler-fig | facade over legacy → replace piecewise → retire legacy | ALIGN path only: modernizing an existing system |
| spike-and-stabilize | throwaway spike → learn → rebuild clean on contract | prototype maturity + high unknowns; spike shortcuts → debt ledger |

`Order:` pipelines for the existing 8 (added, semantics unchanged):

- vertical-slice — feature slice end-to-end → next slice
- integration-test-first — API docs → integration tests as contract → implement → unit tests → suite green unmodified
- server-first — API + domain stable → UI
- frontend-first — UI/UX flows → backend to fit
- contract-first — shared schemas/contracts → parallel implementation against them
- infrastructure-first — platform/deploy/CI → app code
- prototype-first — quick prototype → validate → iterate or rebuild
- inside-out — domain core → adapters → surfaces

## Feature 2 — recommendation matrix (Q11)

Q11's "derives ONE recommendation" becomes matrix-driven. Signals: platform (Q3), maturity (Q4b),
architecture (Q10), data/ML character (Q1/Q8), stakeholders (Q2), ALIGN audit. Matrix (recommend +
runner-up; runner-up + nearest neighbors fill the 3 "best fit" AskUserQuestion slots):

| Project signals | Recommend | Runner-up |
|---|---|---|
| CRUD web app, small/medium | vertical-slice | walking-skeleton |
| Complex API / multi-service | integration-test-first | contract-first |
| Event-driven / async architecture | event-first | integration-test-first |
| ML/LLM/agent product | eval-first | prototype-first |
| Data pipeline / analytics | data-first | inside-out |
| UX-critical consumer app | frontend-first | behavior-first |
| Infra/platform product | walking-skeleton | infrastructure-first |
| Legacy modernization (ALIGN) | strangler-fig | integration-test-first |
| Feasibility unknown / prototype maturity | spike-and-stabilize | prototype-first |

Multiple rows match → most specific signal wins (ML beats CRUD; ALIGN beats all for existing
code). No row matches → vertical-slice.

### Context-aware presentation (how the options are shown)

Never a flat menu. At Q11 time the skill already holds Rounds A+B answers (identity, scale,
maturity, platform, deploy target, features, journey, integrations, constraints), Q10/10b,
absorbed free-text, and — on ALIGN — the full audit. Presentation rules:

1. **Candidates** = matrix recommendation + 3 nearest fits (runner-up + neighbors), ranked;
   remainder via Other. (Existing AskUserQuestion cap convention.)
2. **Maturity re-rank**: prototype → spike-and-stabilize / prototype-first boosted into the
   shown set; production → integration-test-first / walking-skeleton boosted. Maturity is the
   project's *future* axis — a prototype heading to `promote` gets strategies that keep debt
   visible, a production project gets strategies that front-load rigor.
3. **Contextualized copy**: each shown option's one-liner is rewritten in the project's own
   nouns — never generic. E.g. for an LLM support-bot: "eval-first — answer-quality gets a
   measurable bar before you add channels"; for a shop CRUD app: "vertical-slice — checkout
   ships end-to-end before catalog grows". Generic "pick when" lines stay in the reference file;
   the *rendered question* uses project terms.
4. **Justify the recommendation**: one line naming the signals that selected it ("multi-service
   + payments integration → integration-test-first").

## Feature 3 — execution rules for the new strategies (`references/06-execution.md`)

Only the three with hard runtime rules get entries (rest need no execution-time enforcement),
compact table next to the existing integration-test-first section:

| Strategy | Execution rule |
|---|---|
| eval-first | baseline recorded at harness commit; new results ≥ baseline or written justification — `compare-results` gate when gating on, orchestrator check at plan completion when off |
| strangler-fig | facade contract tests immutable (same protocol as integration-test-first); legacy code touched only to delete behind the facade |
| spike-and-stabilize | spike branch never merges; rebuild tasks cite spike learnings; every spike shortcut carried into rebuild → `40-debt.md` row |

event-first reuses the integration-test-first immutability protocol with event schemas as the
contract artifact — one line stating that, no new machinery.

## Feature 4 — touchpoints

- `references/02-align.md` — shortened-interview strategy question gains `strangler-fig` option
  (ALIGN-only home).
- `references/templates.md` — STATE.md `strategy` comment enumeration extended with the 7 new ids.
- `README.md` — strategy subcommand row mentions the expanded catalog + matrix.
- `references/05-planning.md` — no change needed: "Order per `strategy`" already generic; 01's
  `Order:` pipelines feed it.

## Out of scope

- No new gates, agents, or templates beyond the STATE.md comment.
- No composite/custom strategy builder — `custom` already exists.
- SKILL.md untouched (Q11 detail lives in 01; subcommand `strategy` row already points there).

## Testing the skill change

- Dry-run Q11 for an LLM-agent product: eval-first recommended, prototype-first among fits.
- Dry-run ALIGN on legacy monolith: strangler-fig recommended; strangler-fig absent from INIT-path
  recommendations.
- Dry-run event-driven multi-service: event-first recommended, integration-test-first runner-up.
- No signals match → vertical-slice fallback.
