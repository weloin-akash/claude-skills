# Maturity Axis + Debt Ledger + Promote Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `maturity: prototype|mvp|production` quality-intent axis (orthogonal to `scale`) to project-setup — interview question, override rule, debt ledger, `promote` subcommand, ALIGN inference.

**Architecture:** Documentation edits to 8 files in `skills/project-setup/` + README. Exact old→new content per task; verification = grep anchors.

**Tech Stack:** Markdown skill files, git.

**Spec:** `docs/superpowers/specs/2026-07-08-maturity-axis-design.md`.

## Global Constraints

- Detailed-compressed style; match surrounding density.
- Exact vocabulary everywhere: STATE.md field `maturity` (`prototype|mvp|production`); question id `4b`; rule id `2b` (Global Rules — lettered to avoid renumbering rules 3–10, which are referenced by number elsewhere); debt file `docs/project/40-debt.md`; subcommand `promote` (alias `maturity`).
- Gates coupling COMPOSES with existing Q15b trigger (adds `maturity ≠ prototype` condition), never replaces the AUTO/GUIDED condition.
- No AI attribution in commits.
- After all tasks: patch release 0.2.1 (version bump + changelog + tag) and push (user standing instruction).

---

### Task 1: SKILL.md — SSOT field, rule 2b override table, `promote` subcommand, red flag

**Files:**
- Modify: `skills/project-setup/SKILL.md`

**Interfaces:**
- Produces: field `maturity: prototype|mvp|production`, rule id `2b`, file name `40-debt.md`, subcommand `promote` — Tasks 2–9 use verbatim.

- [ ] **Step 1: Add `maturity` to the SSOT field list**

Old:

```markdown
Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

New:

```markdown
Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `maturity` (prototype|mvp|production), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

- [ ] **Step 2: Insert Global Rule 2b after rule 2's rigor table**

Old:

```markdown
   | Quality gates (if `gates` opted, Q15b) | orchestrator inline checklist | gatekeeper agents | gatekeeper agents |

3. **Hybrid delegation.**
```

New:

```markdown
   | Quality gates (if `gates` opted, Q15b) | orchestrator inline checklist | gatekeeper agents | gatekeeper agents |

2b. **Maturity overrides.** `maturity` in STATE.md = quality intent, orthogonal to `scale`: scale sets ceremony baseline (rule 2), maturity overrides quality bar. Conflict → maturity wins on quality items (tests, gates, security, config/DB discipline), scale wins on ceremony items (doc tree, roster size, interview length).

   | | prototype | mvp | production |
   |---|---|---|---|
   | Tests | smoke only | core paths | full per Q13 |
   | Gates (Q15b) | skipped silently | offered, optional | offered, universals recommended |
   | Arch sections (03) | skip security/risks/NFR | boundaries mandatory (isolation test) | all + observability |
   | Config/secrets | hardcode OK | `.env` | secrets manager from start |
   | DB | drop-and-recreate OK | migrations from first schema | migrations + versioning |
   | Debt ledger `40-debt.md` | required | required | n/a |
   | DoD (06) | runs, demo path works; reviewer at plan-end only | task tests pass + reviewer per loop | full loop + gates |

3. **Hybrid delegation.**
```

- [ ] **Step 3: Add `promote` row to the subcommand table (after `strategy` row)**

Old:

```markdown
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates) |
```

New:

```markdown
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates) |
| `promote` (alias `maturity`) | 01 §Q4b + 05 | Show current `maturity`; upgrade one level (prototype→mvp→production): read `40-debt.md` (missing at prototype/mvp → warn, offer reconstruction scan); re-ask questions old level skipped (01 pruning rule); hardening plan via 05 §Hardening; user approves; STATE.md `maturity` + CLAUDE.md updated same commit. Downgrade = field edit + STATE.md note, no plan |
```

- [ ] **Step 4: Add red flag**

Old:

```markdown
- Skipping the interview because the project "is simple" — run it at `small` scale instead
```

New:

```markdown
- Skipping the interview because the project "is simple" — run it at `small` scale instead
- Conscious shortcut at prototype/mvp maturity without a DEBT row in the same commit
- Hardening or promoting maturity without consulting `docs/project/40-debt.md`
```

- [ ] **Step 5: Verify**

Run: `grep -n "maturity\|2b\.\|40-debt\|promote" skills/project-setup/SKILL.md`
Expected: field list contains `maturity` between `scale` and `repo_structure`; rule 2b between rules 2 and 3; `promote` row after `strategy` row; 2 new red flags. Rules 3–10 numbering untouched: `grep -c "^[0-9]\+\. \*\*" skills/project-setup/SKILL.md` → 10.

- [ ] **Step 6: Commit**

```bash
git add skills/project-setup/SKILL.md
git commit -m "feat(project-setup): maturity axis — rule 2b overrides + promote subcommand"
```

---

### Task 2: templates.md — STATE.md field, 40-debt.md template, CLAUDE.md rule, agent reporting line

**Files:**
- Modify: `skills/project-setup/references/templates.md`

**Interfaces:**
- Consumes: field name + `40-debt.md` from Task 1.
- Produces: 40-debt.md skeleton referenced by Tasks 3–5, 8.

- [ ] **Step 1: Add `maturity` to STATE.md template**

Old:

```markdown
scale: TBD                # small|medium|large
repo_structure: TBD       # single|monorepo|polyrepo
```

New:

```markdown
scale: TBD                # small|medium|large
maturity: TBD             # prototype|mvp|production — quality bar, overrides per SKILL.md rule 2b
repo_structure: TBD       # single|monorepo|polyrepo
```

- [ ] **Step 2: Add 40-debt.md template after the 30-decisions.md section**

Old:

```markdown
| 1 | <choice> | <why → what it costs/buys> | YYYY-MM-DD |
```

(the ADR log table's example row — end of `## 30-decisions.md` section)

New (append directly after that row's closing code fence):

````markdown
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
````

(Implementer note: the `Old` block above ends inside the 30-decisions code fence; keep that fence's closing ``` and insert the new `## 40-debt.md` heading + fenced block after it, before `## CLAUDE.md`.)

- [ ] **Step 3: Add debt rule to CLAUDE.md template Rules section**

Old:

```markdown
- Task done ⇒ progress + STATE.md updated in same commit
```

New:

```markdown
- Task done ⇒ progress + STATE.md updated in same commit
- Conscious shortcut ⇒ row in `docs/project/40-debt.md`, same commit   <!-- maturity: prototype|mvp only -->
```

- [ ] **Step 4: Extend agent skeleton Reporting line**

Old:

```markdown
- What built/changed, tests run+results, **shared interfaces touched** (APIs/types/schemas), deviations.
```

New:

```markdown
- What built/changed, tests run+results, **shared interfaces touched** (APIs/types/schemas), shortcuts taken (debt candidates; prototype/mvp), deviations.
```

- [ ] **Step 5: Verify**

Run: `grep -n "maturity\|40-debt\|shortcuts taken\|Conscious shortcut" skills/project-setup/references/templates.md`
Expected: STATE.md field between `scale` and `repo_structure`; `## 40-debt.md` section between 30-decisions and CLAUDE.md sections; CLAUDE.md rule line; reporting line extended.

- [ ] **Step 6: Commit**

```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): STATE.md maturity field + 40-debt.md template"
```

---

### Task 3: 01-interview.md — Q4b, pruning rule, Q15b trigger, outputs

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Consumes: field vocabulary (Task 1), 40-debt.md template (Task 2).
- Produces: question id `4b` + pruning rule referenced by `promote` (Task 1) and 02 (Task 4).

- [ ] **Step 1: Insert Q4b after Q4 (Round A)**

Old:

```markdown
4. Scale: personal-small / team-medium / large userbase. ← sets `scale`
5. Deployment target: local / VPS / K8s / serverless / stores / n-a.
```

New:

```markdown
4. Scale: personal-small / team-medium / large userbase. ← sets `scale`
4b. Maturity — how production-ready from day one? ← sets `maturity`; prunes downstream (adaptive rules below)
    - **prototype** — validate idea; throwaway OK; speed over rigor.
    - **mvp** — ship minimal but extendable; boundaries enforced, shortcuts recorded in debt ledger.
    - **production** — hardened from day one.
5. Deployment target: local / VPS / K8s / serverless / stores / n-a.
```

- [ ] **Step 2: Add maturity pruning to adaptive rules**

Old:

```markdown
- After Round A, set `scale` in STATE.md — it prunes the remaining rounds per the SKILL.md rigor table.
```

New:

```markdown
- After Round A, set `scale` in STATE.md — it prunes the remaining rounds per the SKILL.md rigor table.
- After Round A, also set `maturity` (SKILL.md rule 2b) — **prototype**: skip Q13 (testing = smoke, noted), Q14 (gitflow = trunk, noted), Q15b (silently), Q16, Q17 (`make_workflow: none`), Q18, Round F; Q15 autonomy still asked (execution loop needs it). **mvp**: all asked; gates optional, no recommendation push; make_workflow default A. **production**: Q15b universals preselected as recommended; make_workflow leans C; Q18 becomes confirm (auto-include medium+).
```

- [ ] **Step 3: Extend Q15b trigger with maturity condition**

Old:

```markdown
15b. **Gated development** — only if Q15 = AUTO or GUIDED (MANUAL → skip silently; human already reviews all). Multi-select; derive 3–5 candidates from answers so far — the two universal gates always offered, conditional ones only when their trigger holds:
```

New:

```markdown
15b. **Gated development** — only if Q15 = AUTO or GUIDED AND `maturity` ≠ prototype (MANUAL → skip silently, human already reviews all; prototype → skip silently, `gates` subcommand stays explicit opt-in). `maturity: production` → universal gates preselected as recommended. Multi-select; derive 3–5 candidates from answers so far — the two universal gates always offered, conditional ones only when their trigger holds:
```

- [ ] **Step 4: Outputs — record maturity, create debt ledger**

Old:

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `gates` (Q15b answer; `[]` if skipped/none).
```

New:

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `maturity` (Q4b), `gates` (Q15b answer; `[]` if skipped/none).
- `maturity` prototype|mvp → create empty `docs/project/40-debt.md` (templates.md) + CLAUDE.md debt rule line.
```

- [ ] **Step 5: Verify**

Run: `grep -n "4b\.\|maturity\|40-debt" skills/project-setup/references/01-interview.md`
Expected: Q4b between Q4 and Q5; pruning bullet after scale bullet; Q15b contains `maturity` ≠ prototype; outputs list both new lines. Q5–Q18 numbering untouched: `grep -c "^[0-9]\+\. " skills/project-setup/references/01-interview.md` returns the same count before and after the edit (Q4b uses `4b.` prefix, not a new integer).

- [ ] **Step 6: Commit**

```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): Q4b maturity question + downstream pruning"
```

---

### Task 4: 02-align.md — audit signals + inference question

**Files:**
- Modify: `skills/project-setup/references/02-align.md`

**Interfaces:**
- Consumes: maturity vocabulary (Task 1), 40-debt.md (Task 2).

- [ ] **Step 1: Add maturity signals to the automated audit list**

Old:

```markdown
8. Docs: `docs/`, wikis, existing specs.
```

New:

```markdown
8. Docs: `docs/`, wikis, existing specs.
9. Maturity signals: tests present+passing? CI configured? DB migrations dir? secrets handling (`.env` committed? hardcoded keys?)? error-handling depth (spot-check).
```

- [ ] **Step 2: Add inference question to the shortened interview**

Old:

```markdown
3. Scale (sets `scale` in STATE.md).
```

New:

```markdown
3. Scale (sets `scale` in STATE.md).
3b. Maturity — propose inferred level with one-line evidence ("no tests, secrets in code → prototype — agree?"); user confirms/overrides → STATE.md `maturity`. prototype|mvp → create `docs/project/40-debt.md`. Inference sets the go-forward bar only — never triggers restructuring (hard rules below hold).
```

- [ ] **Step 3: Verify**

Run: `grep -n "Maturity signals\|3b\." skills/project-setup/references/02-align.md`
Expected: audit item 9 + interview 3b present.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/02-align.md
git commit -m "feat(project-setup): ALIGN path infers maturity from audit signals"
```

---

### Task 5: 03-architecture.md — section skips per maturity + debt-aware design

**Files:**
- Modify: `skills/project-setup/references/03-architecture.md`

**Interfaces:**
- Consumes: rule 2b (Task 1), 40-debt.md (Task 2).

- [ ] **Step 1: Scale section list by maturity too**

Old:

```markdown
Present design compressed, section by section, ONE approval check per message-group (not per paragraph). Sections — include only what applies, scaled by `scale`:
```

New:

```markdown
Present design compressed, section by section, ONE approval check per message-group (not per paragraph). Sections — include only what applies, scaled by `scale` + `maturity` (rule 2b): prototype → skip Security, Risks, NFR; mvp → boundaries mandatory (isolation test below = hard gate); production → all + observability:
```

- [ ] **Step 2: Add debt-aware design note after the isolation test**

Old:

```markdown
**Design-for-isolation test per unit:** can you state what it does, how it's used, what it depends on — without reading internals? No → redraw boundary.
```

New:

```markdown
**Design-for-isolation test per unit:** can you state what it does, how it's used, what it depends on — without reading internals? No → redraw boundary.

**Debt-aware design (prototype/mvp):** consciously deferred concerns surfaced during design (auth stub, no rate limiting, drop-and-recreate DB) → name them in the design; each becomes a `40-debt.md` row when built (06).
```

- [ ] **Step 3: Verify**

Run: `grep -n "maturity\|Debt-aware\|40-debt" skills/project-setup/references/03-architecture.md`
Expected: sections line mentions rule 2b skips; debt-aware paragraph after isolation test.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/03-architecture.md
git commit -m "feat(project-setup): architecture sections scale by maturity"
```

---

### Task 6: 04-agents.md — builder reporting includes shortcuts

**Files:**
- Modify: `skills/project-setup/references/04-agents.md`

**Interfaces:**
- Consumes: 40-debt.md (Task 2). No roster changes — `scale` still owns roster.

- [ ] **Step 1: Extend Builders must-have**

Old:

```markdown
**Builders:** read CLAUDE.md + STATE.md before work; report format includes "shared interfaces touched" (APIs, types, schemas) so orchestrator verifies alignment; follow `strategy` and doc-style rules.
```

New:

```markdown
**Builders:** read CLAUDE.md + STATE.md before work; report format includes "shared interfaces touched" (APIs, types, schemas) so orchestrator verifies alignment, and at prototype/mvp maturity "shortcuts taken" (debt candidates — orchestrator records rows in `docs/project/40-debt.md`, 06 task loop); follow `strategy` and doc-style rules.
```

- [ ] **Step 2: Verify**

Run: `grep -n "shortcuts taken" skills/project-setup/references/04-agents.md`
Expected: 1 hit inside the Builders paragraph.

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/04-agents.md
git commit -m "feat(project-setup): builders report shortcuts as debt candidates"
```

---

### Task 7: 05-planning.md — DoD in plan header + hardening-plan variant

**Files:**
- Modify: `skills/project-setup/references/05-planning.md`

**Interfaces:**
- Consumes: rule 2b + `promote` (Task 1), 40-debt.md (Task 2).
- Produces: `§Hardening` section name referenced by Task 1's promote row.

- [ ] **Step 1: Add DoD to fallback plan header**

Old:

```markdown
- Header: goal, exit criteria, spec refs (§), branch, worktree, autonomy.
```

New:

```markdown
- Header: goal, exit criteria, spec refs (§), branch, worktree, autonomy, DoD per `maturity` (rule 2b).
```

- [ ] **Step 2: Add Hardening section before `## 4. Progress scaffold`**

Old:

```markdown
`medium+`: reviewer subagent checks plan (task completeness, dependency order, spec conformance); fix; max 2 rounds. User approves plan (gate).
```

New:

```markdown
`medium+`: reviewer subagent checks plan (task completeness, dependency order, spec conformance); fix; max 2 rounds. User approves plan (gate).

## 3b. Hardening plan (`promote` subcommand only)

Plan sourced from: open `docs/project/40-debt.md` rows + new-level requirements from rule 2b delta (prototype→mvp: migrations from first schema, `.env`, core-path tests; mvp→production: secrets manager, full tests, gates setup if newly selected, observability). Normal machinery applies: macro-plan ask, reviewer check (medium+), user gate. Each task resolving a DEBT row marks it `resolved (<ref>)` in the same commit.
```

- [ ] **Step 3: Verify**

Run: `grep -n "DoD\|Hardening\|40-debt" skills/project-setup/references/05-planning.md`
Expected: header line extended; `## 3b. Hardening plan` section between §3 and §4.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/05-planning.md
git commit -m "feat(project-setup): hardening-plan variant for promote"
```

---

### Task 8: 06-execution.md — per-maturity DoD, reviewer cadence, debt recording

**Files:**
- Modify: `skills/project-setup/references/06-execution.md`

**Interfaces:**
- Consumes: rule 2b (Task 1), 40-debt.md (Task 2), builder reporting line (Task 6).

Note: gate-skip at prototype needs NO edit here — interview pruning yields `gates: []` (already zero-footprint); explicit `gates` subcommand opt-in still works.

- [ ] **Step 1: Per-maturity DoD in verify step**

Old:

```markdown
3. Done → verify: commit exists, code compiles, task's tests pass.
4. Review: complex/shared-interface task → reviewer subagent now; simple task → defer to plan-end review.
```

New:

```markdown
3. Done → verify per `maturity` DoD (rule 2b): prototype → commit exists, runs, demo path works; mvp → + task's tests pass; production → + full loop incl. gates (5b).
4. Review: complex/shared-interface task → reviewer subagent now; simple task → defer to plan-end review. `maturity: prototype` → always defer to plan-end (reviewer still runs — cadence compresses, never disappears).
```

- [ ] **Step 2: Debt recording in the same-commit step**

Old:

```markdown
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
```

New:

```markdown
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** `maturity` prototype|mvp + conscious shortcut taken (builder report "shortcuts taken", or orchestrator observes) → DEBT row in `docs/project/40-debt.md`, same commit. Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
```

- [ ] **Step 3: Verify**

Run: `grep -n "maturity\|DEBT\|40-debt" skills/project-setup/references/06-execution.md`
Expected: step 3 has per-maturity DoD; step 4 prototype cadence; step 5 debt recording.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/06-execution.md
git commit -m "feat(project-setup): per-maturity DoD and debt recording in task loop"
```

---

### Task 9: README.md — promote row + feature mention

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: subcommand vocabulary (Task 1).

- [ ] **Step 1: Add promote row to the subcommand table (after `strategy` row)**

Old:

```markdown
| `/weloin:project-setup strategy` | Re-choose development strategy (incl. `integration-test-first` contract-by-test) |
```

New:

```markdown
| `/weloin:project-setup strategy` | Re-choose development strategy (incl. `integration-test-first` contract-by-test) |
| `/weloin:project-setup promote` (or `maturity`) | Upgrade project maturity one level (prototype→mvp→production): re-asks skipped questions, builds hardening plan from the debt ledger |
```

- [ ] **Step 2: Mention maturity axis in the project-setup feature description**

Old:

```markdown
| `weloin:project-setup` | Phase-machine for agent-driven development: interviews you, writes brief/requirements/architecture/ADRs, creates a custom agent roster with model tags, breaks work into phased plans, executes with AUTO/GUIDED/MANUAL autonomy, and keeps everything resumable via a `docs/project/STATE.md` SSOT. Works on fresh dirs and aligns existing codebases. |
```

New:

```markdown
| `weloin:project-setup` | Phase-machine for agent-driven development: interviews you, writes brief/requirements/architecture/ADRs, creates a custom agent roster with model tags, breaks work into phased plans, executes with AUTO/GUIDED/MANUAL autonomy, and keeps everything resumable via a `docs/project/STATE.md` SSOT. Maturity axis (prototype/mvp/production) sets the quality bar independent of scale — prototypes skip ceremony but log shortcuts to a debt ledger; `promote` upgrades later. Works on fresh dirs and aligns existing codebases. |
```

- [ ] **Step 3: Verify**

Run: `grep -n "promote\|Maturity axis" README.md`
Expected: table row + description mention.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: maturity axis + promote subcommand in README"
```
