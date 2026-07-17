# UI-First Flow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `ui-complete-first` strategy (replacing `frontend-first`), chronological Q11b/Q11c follow-ups, `maturity: concept` two-stage interview, and new phase `1b-ux-prototype` (references/07-ux-prototype.md) to `skills/project-setup`.

**Architecture:** Markdown-only change to the skill's router (SKILL.md) + reference files. Spec: `docs/superpowers/specs/2026-07-17-ui-first-flow-design.md`. No code, no tests — verification = grep consistency checks per task.

**Tech Stack:** Markdown, detailed-compressed doc style (SKILL.md rule 1).

## Global Constraints

- Doc style: detailed-compressed — dense bullets/tables, telegraphic, zero filler (SKILL.md rule 1).
- Field values verbatim from spec: `fidelity_path: wf-hifi-wire|wf-wire-hifi|hifi-direct|n-a`; maturity enum gains `concept`; new phase id `1b-ux-prototype`; new file `references/07-ux-prototype.md`; deliverable `docs/project/15-data-contract.md`.
- `frontend-first` REPLACED by `ui-complete-first` everywhere in the skill (catalog, matrix, enums, 02-align mention). Existing projects unaffected (rule 6).
- Commits: conventional style, NO AI attribution (global CLAUDE.md).
- All file paths relative to repo root `/Users/sukanta/Projects/Development/weloin/weloin-skills`.

---

### Task 1: Interview changes (01-interview.md)

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Produces: Q4b `concept` option + pruning rule; Q11 `ui-complete-first` catalog entry + matrix row; Q11b (`fidelity_path`) + Q11c (design refs); Outputs section routing to `1b-ux-prototype`. Later tasks reference "01 §Q11b", "01 §Q4b concept", "07 §6 stage-2".

- [ ] **Step 1: Add concept pruning to the adaptive rules line**

In the `## 1. Interview` adaptive rules bullet starting `- After Round A, also set \`maturity\``, insert before **prototype**:

```
**concept**: two-stage interview — ask ONLY Rounds A+B; skip Rounds C–F entirely (stack, testing, workflow, scope detail, NFRs — decided only after viability); stage-2 (the skipped rounds) runs at the viability gate (07 §6).
```

- [ ] **Step 2: Add `concept` as first Q4b option**

After line `4b. Maturity — how production-ready from day one? ...`, add as first option (before **prototype**):

```
    - **concept** — validate the idea as an end-to-end wireframe before committing to anything; no data, no backend, no tech stack.
```

- [ ] **Step 3: Replace `frontend-first` catalog entry with `ui-complete-first`**

Replace:
```
    - **frontend-first** — UI/UX flows → backend to fit — UX drives the domain model.
```
with:
```
    - **ui-complete-first** — entire app clickable with fixture data → iterate until user approves → derive data contract → backend built to conform — user must SEE the product before committing backend; UX drives the domain model.
```

- [ ] **Step 4: Update matrix row**

Replace `| UX-critical consumer app | frontend-first | behavior-first |` with `| UX-critical consumer app | ui-complete-first | behavior-first |`.

- [ ] **Step 5: Add Q11b/Q11c after Q11's record-in-STATE.md line**

Insert after the line `Record in STATE.md \`strategy\` + CLAUDE.md. ...`:

```
11b. **Fidelity path** — ONLY when Q11 = `ui-complete-first`; asked immediately after Q11 (chronological — the answer decides whether 11c fires). → STATE.md `fidelity_path` (`n-a` for every other strategy).
    - `wf-hifi-wire` — b/w wireframe all pages → hi-fi design → wire backend — design must be final before backend effort.
    - `wf-wire-hifi` — wireframe → wire real backend → hi-fi as polish phase — functionally complete app early; polish last.
    - `hifi-direct` — skip wireframe, straight to hi-fi → wire — simpler app, design direction already clear.
11c. **Design references** — ONLY when 11b reaches hi-fi before wiring (`wf-hifi-wire`, `hifi-direct`): request references NOW (screenshots/URLs/app names — UI rule below). `wf-wire-hifi` → request deferred to the polish phase (05 §1).
```

- [ ] **Step 6: Update Outputs section**

(a) Replace the STATE.md update bullet:
```
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `maturity` (Q4b), `gates` (Q15b answer; `[]` if skipped/none), `orchestration` (Q15c; `session` if skipped).
```
with:
```
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches` — BUT `strategy: ui-complete-first` OR `maturity: concept` → `phase: 1b-ux-prototype`, `next: page inventory from journey (07)`. Also record: `strategy`, `fidelity_path` (Q11b; `n-a` otherwise), `maturity` (Q4b), `gates` (Q15b answer; `[]` if skipped/none), `orchestration` (Q15c; `session` if skipped).
```
(b) Add a new bullet after it:
```
- `maturity: concept` (stage-1): write merged `00-brief.md` only (Rounds A+B content); STATE.md `strategy: TBD`, `fidelity_path: n-a`; no debt ledger; thin CLAUDE.md still created.
```
(c) Extend the **UI rule** footer line — append:
```
`ui-complete-first`: Q11b/Q11c govern reference timing per `fidelity_path`.
```

- [ ] **Step 7: Verify + commit**

Run: `grep -n "frontend-first" skills/project-setup/references/01-interview.md` → expect NO matches. `grep -c "11b\.\|11c\." skills/project-setup/references/01-interview.md` → ≥2.
```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): ui-complete-first strategy, fidelity-path Q11b/Q11c, concept maturity (interview)"
```

---

### Task 2: New phase reference (07-ux-prototype.md)

**Files:**
- Create: `skills/project-setup/references/07-ux-prototype.md`

**Interfaces:**
- Consumes: Q11b `fidelity_path` values, Q4b `concept` (Task 1).
- Produces: phase `1b-ux-prototype` behavior; `07 §3` iteration loop, `07 §5` contract derivation, `07 §6` viability gate — referenced by SKILL.md (Task 3) and 03/05 (Task 4).

- [ ] **Step 1: Create the file with this exact content**

````markdown
# Phase 1b: UX Prototype

Entered from discovery when `strategy: ui-complete-first` OR `maturity: concept`. Goal: user SEES the whole application start-to-end before any backend exists — iteration is cheap here, expensive after wiring. Concept mode (`maturity: concept`): output is a viability verdict, not a contract.

## 1. Page inventory

Derive screen list from journey + features (Round B answers): per screen one line — purpose, data shown, actions. Present as table; user confirms/edits (gate). Record in progress notes.

## 2. Scaffold + build

- **Normal mode:** chosen frontend stack (Q12). All pages routed + clickable; b/w unstyled components (`fidelity_path: hifi-direct` → styled from the start per Q11c references). Mock data = fixture files under one dir (`fixtures/`), ONE fixture per future endpoint, shaped exactly as the API response the UI wants, named like the endpoint. Fixtures = the future contract.
- **Concept mode:** plain static HTML/CSS clickthrough — no framework, no fixtures, throwaway acceptable; viability IS the output.
- Commit: `proto: scaffold + page skeletons`.

## 3. Iteration loop

Dev server up (or open HTML) → user reviews in browser → change requests → apply → repeat until user declares it right. USER-GATED per round regardless of `autonomy_default` — visual judgment cannot be automated. Rules:
- One commit per round: `proto: <what changed>`.
- UI change alters shown data ⇒ fixture updated in the SAME commit — fixtures never lag the UI.
- Scope guard: no backend, no real API calls, no auth flows — anything needing a server = fixture + note.

## 4. Hi-fi pass (per `fidelity_path`)

- `wf-hifi-wire` — runs HERE after wireframe approval. Design references required (01 UI rule); none → block, request.
- `hifi-direct` — already merged into §2.
- `wf-wire-hifi` — NOT here; becomes a polish phase in the Phase-4 breakdown (05 §1).

Delegate: `frontend-design` installed → invoke it; else inline styling pass. Iteration loop (§3) applies to hi-fi rounds too.

## 5. Exit — normal mode: derive data contract

Walk EVERY screen → write `docs/project/15-data-contract.md` (templates.md), detailed-compressed: data shown, fixture shape (field:type + fixture path), implied endpoints (`VERB /path → fixture`), actions→mutations, parsing/transform needs (display format vs storage shape). User approves (gate). Fixtures stay the machine-readable truth; the doc is the compressed index — divergence = bug.

## 6. Exit — concept mode: viability gate

Ask: is the concept viable?
- **Viable** → stage-2 interview: re-ask Q4b (concept option removed — pick prototype/mvp/production) + resume Rounds C–F, absorbing prototype learnings (adaptive-skip: screens/journey/features proven — don't re-ask); Q11 asked normally (wireframe exists → matrix may lean `ui-complete-first` + `hifi-direct`). HTML clickthrough kept as REFERENCE only — the real stack builds fresh; note in STATE.md. Then continue at `2-architecture` (or §5 if `ui-complete-first` re-chosen with fixtures still to build).
- **Not viable** → park: STATE.md `next: parked — concept not viable (<date>, <one-line reason>)`; `phase` stays `1b-ux-prototype`. Re-running the skill reports the parked state; offer revive (re-enter §3) or re-init.

## 7. Transition

STATE.md: `phase: 2-architecture`, `next: propose architecture approaches (consume 15-data-contract.md)`. Commit: `docs: data contract from UI prototype`.
````

- [ ] **Step 2: Commit**

```bash
git add skills/project-setup/references/07-ux-prototype.md
git commit -m "feat(project-setup): 1b-ux-prototype phase reference (build loop, hi-fi paths, data contract, viability gate)"
```

---

### Task 3: Router updates (SKILL.md)

**Files:**
- Modify: `skills/project-setup/SKILL.md`

**Interfaces:**
- Consumes: phase id `1b-ux-prototype` → file 07 (Task 2); `fidelity_path` field (Task 1).

- [ ] **Step 1: Phase → reference map (line ~23)** — insert after `(ALIGN path: →02; it writes \`2-architecture\` directly on completion)`:

```
`1b-ux-prototype`→07,
```
(so the map reads `…→01 (ALIGN path: →02…), `1b-ux-prototype`→07, `2-architecture`→03, …`)

- [ ] **Step 2: `strategy` subcommand row** — replace

```
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates) |
```
with:
```
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates); `ui-complete-first` → also re-ask Q11b/Q11c (`fidelity_path`, design refs) |
```

- [ ] **Step 3: `promote` subcommand row** — replace `upgrade one level (prototype→mvp→production):` with `upgrade one level (concept→prototype→mvp→production; concept→prototype = viability-gate path 07 §6 — stage-2 interview, no hardening plan):`

- [ ] **Step 4: SSOT field list** — in the `## SSOT: docs/project/` fields sentence: change `` `maturity` (prototype|mvp|production) `` to `` `maturity` (concept|prototype|mvp|production) `` and insert after the `strategy` field: `` `fidelity_path` (wf-hifi-wire|wf-wire-hifi|hifi-direct|n-a — ui-complete-first only), ``

- [ ] **Step 5: Rule 2b — add `concept` column** (first data column) to the maturity table:

```
   | | concept | prototype | mvp | production |
   |---|---|---|---|---|
   | Tests | n/a (nothing built) | smoke only | core paths | full per Q13 |
   | Gates (Q15b) | skipped silently | skipped silently | offered, optional | offered, universals recommended |
   | Arch sections (03) | n/a (phase not reached) | skip security/risks/NFR | boundaries mandatory (isolation test) | all + observability |
   | Config/secrets | n/a | hardcode OK | `.env` | secrets manager from start |
   | DB | n/a | drop-and-recreate OK | migrations from first schema | migrations + versioning |
   | Debt ledger `40-debt.md` | not created | required | required | n/a |
   | DoD (06) | clickthrough demonstrates journey end-to-end (07 §6) | runs, demo path works; reviewer at plan-end only | task tests pass + reviewer per loop | full loop + gates |
```

- [ ] **Step 6: Rule 3 delegation table** — add row:

```
   | UI prototype hi-fi pass | `frontend-design` | 07 |
```

- [ ] **Step 7: Phase Sequence** — replace `` `1-discovery` (interview → brief, requirements) → `2-architecture` `` with `` `1-discovery` (interview → brief, requirements) → `1b-ux-prototype` (ONLY when `strategy: ui-complete-first` or `maturity: concept`; clickable prototype → data contract / viability) → `2-architecture` ``

- [ ] **Step 8: Red Flags** — append two bullets:

```
- Writing backend code while a `1b-ux-prototype` phase is unapproved
- Fixture drifting from what a screen displays — same-commit rule (07 §3)
```

- [ ] **Step 9: Verify + commit**

Run: `grep -c "1b-ux-prototype" skills/project-setup/SKILL.md` → ≥4. `grep -n "fidelity_path" skills/project-setup/SKILL.md` → ≥2 matches.
```bash
git add skills/project-setup/SKILL.md
git commit -m "feat(project-setup): route 1b-ux-prototype phase, concept maturity column, fidelity_path SSOT field"
```

---

### Task 4: Downstream references (02-align, 03-architecture, 05-planning)

**Files:**
- Modify: `skills/project-setup/references/02-align.md` (one word)
- Modify: `skills/project-setup/references/03-architecture.md`
- Modify: `skills/project-setup/references/05-planning.md`

- [ ] **Step 1: 02-align.md** — in the strategy line (§ item 5), replace `frontend-first` with `ui-complete-first`.

- [ ] **Step 2: 03-architecture.md §2** — after the existing `**UI:**` paragraph, add:

```
**Data contract:** `docs/project/15-data-contract.md` exists → API/interface + data-model sections MUST conform to it — endpoints, shapes, parsing needs come FROM the contract; deviations get an ADR. UI direction = the prototype itself (references already captured in 1b).
```

- [ ] **Step 3: 05-planning.md §1** — after the sentence `Order per \`strategy\` (vertical-slice → …; etc.).`, add:

```
`ui-complete-first` → backend phases sequenced per `15-data-contract.md`; wiring tasks replace fixture with live endpoint screen-by-screen (unwired screens keep fixtures — every phase still yields working software); `fidelity_path: wf-wire-hifi` → append a hi-fi polish phase to the breakdown (design references requested at its start).
```

- [ ] **Step 4: Verify + commit**

Run: `grep -rn "frontend-first" skills/project-setup/` → expect NO matches (templates fixed in Task 5 — at this point one match in templates.md remains; confirm it is the only one).
```bash
git add skills/project-setup/references/02-align.md skills/project-setup/references/03-architecture.md skills/project-setup/references/05-planning.md
git commit -m "feat(project-setup): data-contract conformance (03), ui-complete-first plan ordering + polish phase (05), align catalog rename (02)"
```

---

### Task 5: Templates (templates.md)

**Files:**
- Modify: `skills/project-setup/references/templates.md`

- [ ] **Step 1: STATE.md skeleton** — three edits:

(a) phase enum comment: `# 0-init|1-discovery|1b-ux-prototype|2-architecture|3-agents|4-planning|5-execution`
(b) strategy enum comment: replace `frontend-first` with `ui-complete-first`.
(c) after the `strategy:` line add:
```
fidelity_path: TBD        # wf-hifi-wire|wf-wire-hifi|hifi-direct|n-a — ui-complete-first only (Q11b)
```
(d) maturity comment: `# concept|prototype|mvp|production — quality bar, overrides per SKILL.md rule 2b`

- [ ] **Step 2: Add 15-data-contract template** — new section after `## 10-requirements.md`:

````markdown
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
````

- [ ] **Step 3: Verify + commit**

Run: `grep -rn "frontend-first" skills/project-setup/` → NO matches anywhere. `grep -n "fidelity_path\|15-data-contract" skills/project-setup/references/templates.md` → ≥2.
```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): fidelity_path field + 15-data-contract template"
```

---

### Task 6: User-facing docs (docs/project-setup.md)

**Files:**
- Modify: `docs/project-setup.md`

- [ ] **Step 1:** `promote` row: replace `(prototype→mvp→production)` with `(concept→prototype→mvp→production)`.

- [ ] **Step 2:** Add bullet to `## Notable opt-in features`:

```
- **UI-first flow** — `ui-complete-first` strategy: the whole app clickable with fixture data before any backend exists; fidelity paths (wireframe→hi-fi→wire / wireframe→wire→hi-fi-polish / hi-fi-direct); phase exit derives `docs/project/15-data-contract.md` that the backend must conform to. `maturity: concept` = wireframe-only viability check — tech stack and backend decided only after the concept proves out.
```

- [ ] **Step 3: Commit**

```bash
git add docs/project-setup.md
git commit -m "docs: project-setup README — ui-first flow, concept maturity"
```

---

### Task 7: Release v0.2.7

**Files:**
- Modify: `package.json` (version `0.2.6` → `0.2.7`)
- Create: `changelogs/CHANGELOG-v0.2.7.md`

- [ ] **Step 1: Bump version** — `package.json` `"version": "0.2.7"`.

- [ ] **Step 2: Write changelog** (`changelogs/CHANGELOG-v0.2.7.md`):

```markdown
# v0.2.7

## Features

- **project-setup: UI-first development flow** — see the whole application before building the backend.
  - New strategy `ui-complete-first` (replaces `frontend-first`): entire app clickable with fixture data → iterate until approved → derive `docs/project/15-data-contract.md` → backend built to conform.
  - Chronological follow-ups Q11b/Q11c: `fidelity_path` (`wf-hifi-wire` / `wf-wire-hifi` — functionally complete before hi-fi polish / `hifi-direct` — skip wireframe when simple) + design-reference timing.
  - New maturity `concept`: two-stage interview — wireframe-only viability check (plain HTML clickthrough, no stack/data/backend); viable → resume remaining interview rounds; not viable → project parks.
  - New phase `1b-ux-prototype` (references/07-ux-prototype.md): page inventory → build with fixtures (fixtures = future contract, same-commit drift rule) → user-gated iteration loop → hi-fi pass per fidelity path (delegates `frontend-design` if installed) → data contract / viability gate.
  - Downstream: architecture (03) must conform to the data contract (deviations → ADR); planning (05) wires fixtures screen-by-screen and appends a polish phase for `wf-wire-hifi`; `promote` handles concept→prototype.

Spec: `docs/superpowers/specs/2026-07-17-ui-first-flow-design.md`.
```

- [ ] **Step 3: Commit, tag, push** (release-flow: changelog → tag → push)

```bash
git add package.json changelogs/CHANGELOG-v0.2.7.md
git commit -m "chore: bump version to 0.2.7, changelog for v0.2.7"
git tag v0.2.7
git push && git push --tags
```
