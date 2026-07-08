# Maturity Axis (prototype/mvp/production) + Debt Ledger + Promote for project-setup

**Date:** 2026-07-08
**Status:** Approved design, pending implementation plan
**Scope:** `skills/project-setup/` (SKILL.md + references 01, 02, 03, 04, 05, 06, templates)

## Problem

The skill has one rigor axis: `scale` (small/medium/large), which controls ceremony size —
interview length, doc tree, agent roster. It has no axis for *quality intent*: is this a
throwaway prototype, a minimal-but-extendable MVP, or production-hardened from day one? The two
are orthogonal — a small personal tool can be production-day-one (a backup CLI), a large-scale
project can start as a feasibility spike. `prototype-first` exists as a *strategy* but that is
build *order*, not lifecycle intent.

Without the axis, every project pays full quality ceremony (gates offered, security sections,
full testing question) even when the user just wants to validate an idea fast — and conversely
nothing records the shortcuts taken, so "we'll harden it later" is hope, not a plan.

## Design: override layer, not a matrix

`scale` keeps driving the existing rigor table unchanged (ceremony baseline). `maturity` applies
modifiers on top of it (quality bar). Chosen over a full scale×maturity 3×3 matrix (9 cells to
maintain, doc bloat) and over folding maturity into scale (loses the "large prototype" /
"small production tool" cases — the exact gap being fixed).

**Conflict rule (one-liner for SKILL.md Global Rules):** scale sets the ceremony baseline;
maturity overrides the quality bar. Conflict → maturity wins on quality items (tests, gates,
security, config/DB discipline), scale wins on ceremony items (doc tree, roster size, interview
length).

## Feature 1 — `maturity` STATE.md field + interview question

### STATE.md (`references/templates.md`, SKILL.md SSOT section)

New field: `maturity: prototype|mvp|production` (default `TBD`).

- **prototype** — validate the idea; throwaway acceptable; speed over rigor.
- **mvp** — ship minimal but extendable; boundaries enforced, shortcuts recorded for later
  hardening. (The "start minimal, keep it upgradeable" mode.)
- **production** — hardened from day one.

### Interview change (`references/01-interview.md`)

New question **4b** in Round A, immediately after scale Q4: "How production-ready from day
one?" — three options above, each with a one-line "pick when". Placed in Round A because, like
`scale`, it prunes everything downstream.

Downstream pruning:

| maturity | Effect on remaining interview |
|---|---|
| prototype | Skip Q13 (testing → smoke only, noted), Q14 (gitflow → trunk, noted), Q15b (gates — silently), Q16 (CI/CD), Q17 (make_workflow → none), Q18 (security agent), Round F. Q15 autonomy still asked — execution loop needs it. |
| mvp | All questions asked; gates optional (no recommendation push); make_workflow default A. |
| production | Gates auto-offered with universal gates preselected/recommended; make_workflow leans C; security agent auto-included at medium+ (Q18 becomes confirm, not ask). |

### Maturity override table (SKILL.md, new Global Rule next to the rigor table)

| | prototype | mvp | production |
|---|---|---|---|
| Tests | smoke only | core paths | full per Q13 |
| Gates (Q15b) | skipped silently | offered, optional | offered, universals recommended |
| Architecture sections (03) | skip security/risks/NFR | boundaries mandatory (design-for-isolation test) | all sections + observability |
| Config / secrets | hardcode OK | `.env` | secrets manager from start |
| DB | drop-and-recreate OK | migrations from first schema | migrations + versioning |
| Debt ledger | required | required | n/a |
| Definition of done (06) | runs, demo path works; reviewer at plan-end only | task tests pass + reviewer per loop | full loop + gates |

### Gates coupling (composes with, does not replace, the gated-development design)

Q15b trigger becomes: `autonomy ∈ {AUTO, GUIDED}` **and** `maturity ≠ prototype`. Production
additionally preselects the two universal gates as recommended. The `/project-setup gates`
subcommand remains an explicit opt-in override — invoking it works even at prototype maturity
(explicit ask beats the default skip).

## Feature 2 — Debt ledger

New doc: `docs/project/40-debt.md`, ADR-log style (template in templates.md):

```markdown
# Debt Ledger
| # | Shortcut taken | Production needs | Date | Status |
|---|---|---|---|---|
| 1 | auth stubbed (hardcoded token) | real authn + session handling | YYYY-MM-DD | open |
```

Rules:

- Written at **prototype and mvp** maturity only; production projects don't create it.
- Every *consciously skipped* thing gets a row: stubbed auth, no rate limiting, hardcoded
  config, missing error handling, drop-and-recreate DB. Not optional — this is the mechanical
  guarantee behind "extendable".
- Builders' reporting format (04 §Reporting, templates agent skeleton) gains a line: "shortcuts
  taken (debt candidates)". Orchestrator (or inline loop at small scale) records them into the
  ledger — same-commit discipline as progress updates.
- `Status: open|resolved`; resolved rows are kept (history), marked with resolving commit/plan.
- CLAUDE.md Rules section gains one line at prototype/mvp: "Conscious shortcut ⇒ row in
  `docs/project/40-debt.md`, same commit."

## Feature 3 — `promote` subcommand

New row in the SKILL.md subcommand table:

| Subcommand | Loads | Action |
|---|---|---|
| `promote` (alias `maturity`) | 01 §4b + 05 | Show current maturity; upgrade one level per invocation (prototype→mvp→production). Flow below. Downgrade = field edit + STATE.md note only, no plan. |

Upgrade flow:

1. Read STATE.md + `40-debt.md`. No debt file at prototype/mvp → warn (ledger was mandatory),
   offer to reconstruct from a quick codebase scan.
2. Re-ask the interview questions that the *old* maturity level skipped (per the pruning table:
   e.g. prototype→mvp re-asks Q13/Q14/Q16/Q17; mvp→production re-asks Q15b with universals
   recommended, Q18, secrets/migrations stance).
3. Generate a **hardening plan** via 05 (normal phase-plan machinery, macro-plan ask included):
   tasks sourced from open DEBT rows + new-level requirements from the override table (e.g.
   "introduce migrations", "move secrets out of code"). User approves plan (standard gate).
4. Update STATE.md `maturity` + CLAUDE.md (rules line, gates if newly selected) — same commit as
   the plan doc. DEBT rows resolve as hardening tasks complete (same-commit rule).

Free-text context after the subcommand is absorbed like interview answers (existing subcommand
convention).

## Feature 4 — ALIGN path inference (`references/02-align.md`)

Audit step gains maturity signals: tests present + passing? CI configured? DB migrations dir?
secrets handling (`.env` committed? hardcoded keys?)? error-handling depth (spot-check).
Shortened interview proposes an inferred maturity with one-line evidence ("no tests, secrets in
code → looks like prototype — agree?"); user confirms or overrides. Existing hard rules hold:
inference never triggers restructuring; it only sets the field and the go-forward bar.

## Files touched (implementation surface)

- `skills/project-setup/SKILL.md` — SSOT field list, maturity override table + conflict rule
  (Global Rules), `promote` subcommand row, red-flag addition ("hardening work without consulting
  the debt ledger").
- `references/01-interview.md` — Q4b, pruning rules, Q15b trigger update, outputs (STATE.md
  field, 40-debt.md creation at prototype/mvp).
- `references/02-align.md` — audit signals + inference question.
- `references/03-architecture.md` — section skips per maturity; debt-aware design note.
- `references/04-agents.md` — builder reporting line (shortcuts); no roster changes (scale still
  owns roster).
- `references/05-planning.md` — hardening-plan variant (promote), DoD note in plan header.
- `references/06-execution.md` — per-maturity DoD in task loop, gate-skip at prototype, debt
  recording step (same-commit).
- `references/templates.md` — STATE.md `maturity` field, `40-debt.md` template, CLAUDE.md rules
  line, agent skeleton reporting line.
- `README.md` — document the new field/subcommand (matches existing convention of documenting
  subcommands).

## Out of scope

- No changes to other skills (deploy-setup consumes `make_workflow` as before; maturity only
  influences *which scope is suggested*, asked in project-setup's own interview).
- No automatic maturity detection outside the ALIGN audit.
- No multi-level jump in `promote` (run it twice for prototype→production).
- No CI enforcement of the debt ledger.

## Testing the skill change

- Dry-run interview, small prototype project: Q4b appears; Q13/14/16/17/18 + Q15b skipped; STATE.md
  carries `maturity: prototype`, `gates: []`, `make_workflow: none`; `40-debt.md` created.
- Dry-run, small production CLI: full quality questions despite `scale: small` — proves axis
  orthogonality.
- Dry-run, large prototype: ceremony from `scale: large` (roster, doc tree) but gates/security
  skipped — proves override direction.
- Dry-run `promote` on the prototype project: skipped questions re-asked, hardening plan
  generated from debt rows, STATE.md updated same commit.
- Dry-run ALIGN on a repo with tests+CI+migrations: inference proposes `production` with evidence.
