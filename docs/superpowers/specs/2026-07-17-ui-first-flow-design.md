# UI-First Development Flow (ui-complete-first + 1b-ux-prototype + concept maturity) for project-setup

**Date:** 2026-07-17
**Status:** Approved design, pending implementation plan
**Scope:** `skills/project-setup/` (SKILL.md + references 01, 03, 05, templates + NEW 07-ux-prototype.md)

## Problem

Backend implementation today starts from a written spec the user has never *seen*. For many
projects the user cannot judge "is this what I wanted" until the whole application is visible
start-to-end — which screens exist, what data each shows, how pages connect. Building backend
first means discovering misfit late: API shape, data shape, parsing/transform needs all get
reworked once the UI reveals what is actually needed.

Three user workflows the skill cannot express:

1. **UI-complete-first** — full app clickable with mock data, iterate until "perfect", derive
   API/data/parsing needs from it, THEN build backend to conform.
2. **Fidelity ordering** — some want wireframe → hi-fi design → implement; others want
   wireframe → implement → hi-fi as final polish (app functionally complete before any hi-fi);
   simpler apps skip wireframe and go straight to hi-fi.
3. **Concept viability** — end-to-end wireframe only, NO data, NO backend, NO tech stack.
   Stack/backend decisions deferred until the concept is proven viable.

Existing `frontend-first` strategy ("UI/UX flows → backend to fit") gestures at this but has no
phase machinery, no fidelity paths, no contract derivation, no concept mode.

## Design decisions (settled in brainstorming)

| Decision | Choice |
|---|---|
| Placement | Strategy + inserted phase: new Q11 strategy choices insert phase `1b-ux-prototype` between discovery and architecture |
| Concept-mode interview | Two-stage: concept detected in Round A → only identity+features+journey asked → wireframe phase → viability gate → resume remaining rounds |
| Prototype artifact | Real frontend code with fixture data (concept mode: plain static HTML, throwaway OK) |
| Phase deliverable | Derived `docs/project/15-data-contract.md`; fixtures stay machine-readable truth |
| frontend-first | REPLACED by ui-complete-first (catalog + matrix). Existing projects with `strategy: frontend-first` unaffected (rule 6, going-forward only) |

## Feature 1 — `ui-complete-first` strategy (references/01-interview.md §Q11)

Catalog entry (replaces `frontend-first`):

- **ui-complete-first** — entire app clickable with fixture data → iterate until user approves →
  derive data contract → backend built to conform — user must SEE the product before committing
  backend; UX drives the domain model.

Matrix: `UX-critical consumer app` row → recommend `ui-complete-first`, runner-up `behavior-first`.
All contextualized-copy rules (Q11 a–d) apply unchanged.

## Feature 2 — Chronological follow-up questions Q11b/Q11c

Asked ONLY when `ui-complete-first` is chosen, immediately after Q11 (one question leads into the
next — never batched with unrelated rounds):

**Q11b — fidelity path** → STATE.md `fidelity_path`:

| Value | Pipeline | Pick when |
|---|---|---|
| `wf-hifi-wire` | b/w wireframe all pages → hi-fi design → wire backend | design must be final before backend effort |
| `wf-wire-hifi` | wireframe → wire real backend → hi-fi as polish phase | want functionally complete app early; polish last |
| `hifi-direct` | skip wireframe, straight to hi-fi → wire | simpler app, design direction already clear |

**Q11c — design references** — asked only if path reaches hi-fi before wiring (`wf-hifi-wire`,
`hifi-direct`): request references NOW (screenshots/URLs/app names — existing UI rule, 01 footer).
`wf-wire-hifi` → reference request deferred to the polish phase.

Re-settable: existing `strategy` subcommand re-asks Q11b/Q11c when the (re-)chosen strategy is
`ui-complete-first`. No new subcommand.

## Feature 3 — `maturity: concept` (references/01-interview.md §Q4b)

Q4b gains a FIRST option:

- **concept** — validate the idea as an end-to-end wireframe before committing to anything; no
  data, no backend, no tech stack.

Pruning (extends the Q4b adaptive rules): `concept` → ask only Rounds A+B (identity, features,
journey); skip Rounds C–F entirely (stack, testing, workflow, scope detail, NFRs). Round E scope
questions fold into the viability question itself. STATE.md after stage-1 interview:
`strategy: TBD`, `fidelity_path: n/a`, `phase: 1b-ux-prototype`, `maturity: concept`.

**Viability gate** (end of prototype phase, replaces contract derivation):

- Viable → re-ask Q4b (concept option removed) + resume Rounds C–F with prototype learnings
  absorbed (adaptive-skip: screens/journey/features already proven — don't re-ask); Q11 asked
  normally (matrix may now recommend ui-complete-first with `hifi-direct` since wireframe exists);
  then normal phase sequence continues at `2-architecture`.
- Not viable → project parks: STATE.md `phase: 1b-ux-prototype`, `next: parked — concept not
  viable (<date>, <one-line reason>)`. Re-running the skill reports the parked state, offers
  revive (re-enter iteration loop) or re-init.

`promote` subcommand: concept→prototype = run the viability-gate "viable" path (stage-2 interview),
not a hardening plan.

Maturity override table (SKILL.md rule 2b) gains a `concept` column: everything skipped/n-a —
tests none, gates skipped silently, arch sections n/a (phase not reached), config n/a, DB n/a,
debt ledger not created, DoD = clickthrough demonstrates journey end-to-end.

## Feature 4 — Phase `1b-ux-prototype` (NEW references/07-ux-prototype.md)

Existing reference files keep their numbers (rule 6 analog for the skill's own layout); new file
takes next free number. SKILL.md phase→reference map gains `1b-ux-prototype`→07.

Phase entered from discovery when `strategy: ui-complete-first` OR `maturity: concept`. Content:

1. **Page inventory** — derive screen list from journey + features (Round B answers): per screen
   one line — purpose, data shown, actions. User confirms/edits (gate).
2. **Scaffold + build**:
   - Normal mode: chosen frontend stack (Q12; stack question still asked in Round C — only
     backend/API work is deferred, the frontend stack is needed here). All pages routed and
     clickable, b/w unstyled components (`hifi-direct` → styled per references from the start).
     Mock data in fixture files under one directory (e.g. `fixtures/`), one fixture per future
     endpoint, shaped like the API response the UI wants. Fixtures = future contract.
   - Concept mode: plain static HTML/CSS clickthrough, no framework, no fixtures — throwaway
     acceptable; viability IS the output.
3. **Iteration loop** — dev server up (or open HTML) → user reviews in browser → change requests
   → apply → repeat until user declares it right. USER-GATED per round regardless of
   `autonomy_default` (visual judgment cannot be automated). Each round = one commit
   (`proto: <what changed>`). UI changes that change shown data MUST update fixtures in the same
   commit — fixtures never lag the UI.
4. **Hi-fi pass** — per `fidelity_path`: `wf-hifi-wire` → runs here after wireframe approval
   (design references required — block per existing UI rule); `hifi-direct` → merged into step 2;
   `wf-wire-hifi` → NOT here, becomes a polish phase in the Phase-4 breakdown (05). Delegate to
   `frontend-design` skill if installed (new rule 3 row), else inline styling pass.
5. **Exit, normal mode** — derive `docs/project/15-data-contract.md` (template in templates.md),
   walking every screen: data shown, fixture shape (field:type, source fixture path), implied
   endpoints (`VERB /path → fixture`), actions→mutations, parsing/transform needs (display
   format vs storage shape). Detailed-compressed. User approves (gate).
6. **Exit, concept mode** — viability gate (Feature 3).
7. **Transition** — STATE.md: `phase: 2-architecture`, `next: propose architecture approaches
   (consume 15-data-contract.md)`. Commit: `docs: data contract from UI prototype`.

## Feature 5 — Downstream integration

**SKILL.md**
- Routing map: `1b-ux-prototype`→07.
- Phase Sequence line: `1-discovery` → (`1b-ux-prototype` when strategy/maturity demands) →
  `2-architecture`.
- SSOT fields: add `fidelity_path` (`wf-hifi-wire|wf-wire-hifi|hifi-direct|n-a`); `maturity` enum
  gains `concept`.
- Rule 2b table: `concept` column (Feature 3).
- Rule 3 delegation table: new row — UI prototype hi-fi pass → `frontend-design` → fallback in 07.
- Red flags: add "Writing backend code while phase 1b prototype unapproved" and "Letting fixtures
  drift from what screens display".

**references/03-architecture.md**
- §2: when `15-data-contract.md` exists, API/interface design MUST conform to it — endpoints,
  shapes, parsing needs come FROM the contract; deviations get an ADR. UI section: direction =
  the prototype itself (references already captured or prototype is the reference).

**references/05-planning.md**
- §1 strategy ordering: `ui-complete-first` → backend phases sequenced per data contract;
  wiring tasks = replace fixture with live endpoint per screen, screen by screen (each phase
  still yields working software — screens fall back to fixtures until wired).
- `fidelity_path: wf-wire-hifi` → hi-fi polish phase appended to the breakdown (design
  references requested at that phase start).

**references/templates.md**
- STATE.md skeleton: `fidelity_path` field.
- NEW `15-data-contract.md` skeleton: per-screen table (screen | data shown | fixture | endpoints
  implied | mutations | parsing notes) + endpoint index.

**Out of scope:** 02-align (ALIGN path unchanged — existing code means backend exists; strategy
matrix already handles it), 04-agents (roster derives from strategy as today; no new agent type),
06-execution (fixture-swap tasks are ordinary tasks).

## Risks

- Fixture drift during long iteration loops → mitigated by same-commit fixture rule (step 3) +
  red flag.
- Concept-mode HTML accidentally treated as the real frontend later → 07 exit says explicitly:
  viable → stage-2 interview picks the real stack; HTML kept only as reference, noted in STATE.md.
- Q11 option-window pressure (AskUserQuestion 4-slot cap) → unchanged: replace not add, catalog
  count stays constant.
