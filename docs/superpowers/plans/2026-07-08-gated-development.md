# Gated Development + Integration-Test-First Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add two opt-in features to the `weloin:project-setup` skill: a gated-development interview question with scale-dependent enforcement, and an `integration-test-first` development strategy with contract-by-test rules.

**Architecture:** Pure documentation edits to `skills/project-setup/` (SKILL.md router + 5 reference files). No code. Each task edits one file with exact content given below; verification = grep for inserted anchors + consistency reads.

**Tech Stack:** Markdown skill files, git.

**Spec:** `docs/superpowers/specs/2026-07-08-gated-development-design.md` — read it before starting.

## Global Constraints

- Doc style is **detailed-compressed** (dense bullets/tables, telegraphic, zero filler) — all inserted text must match the surrounding style. Do not pad.
- Exact vocabulary, used identically everywhere: strategy id `integration-test-first`; gate ids `regression`, `goal-alignment`, `compare-results`, `contract-compat`, `security-privacy`, `perf-budget`; verdicts `PASS` / `DONE_WITH_CONCERNS` / `FAIL`; STATE.md fields `gates:` and `## Concerns`; report path `docs/project/gates/<task-group>-gate.md`; agent role `gatekeeper`.
- Gate question id is **15b** (Round D, after autonomy Q15); shown only when autonomy = AUTO or GUIDED.
- Enforcement is scale-dependent: `small` → orchestrator inline checklist; `medium`/`large` → read-only gatekeeper agents.
- No AI attribution in commits (user global rule).
- Never renumber existing interview questions — 15b slots in without shifting 16–18.

---

### Task 1: Interview — Q11 rework + Q15b gate question (`references/01-interview.md`)

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Consumes: nothing (first task).
- Produces: question **15b** semantics, gate ids list, `STATE.md gates:` recording rule, `strategy: integration-test-first` id — Tasks 2–6 reference these exactly.

- [ ] **Step 1: Replace Q11 (strategy) with easy-choice version**

Old (line 33):

```markdown
11. Development strategy: **vertical-slice** / server-first / frontend-first / contract-first / infrastructure-first / prototype-first / inside-out / other. Record in STATE.md `strategy` + CLAUDE.md.
```

New:

```markdown
11. Development strategy — make choosing easy: every option carries a one-line "pick when", and the skill derives ONE recommendation from answers so far (API complexity, architecture, scale) and lists it first labeled "(Recommended)". AskUserQuestion caps at 4 options → show recommendation + 3 best fits; remaining reachable via Other.
    - **vertical-slice** — pick when features ship as independent end-to-end slices (default for most apps).
    - **integration-test-first** (contract-by-test) — pick for complex API / multi-service / medium+ scale. Order per feature: API docs → integration tests committed as contract → implement → unit tests (per Q13) → suite green UNMODIFIED. Tests conform code to concept, never reverse. RECOMMEND when project has complex API surface, multi-service architecture, or medium+ scale.
    - **server-first** — pick when API must stabilize before UI.
    - **frontend-first** — pick when UX drives the domain model.
    - **contract-first** — pick when multiple teams/agents build against shared schemas.
    - **infrastructure-first** — pick when platform/deploy risk dominates.
    - **prototype-first** — pick when core feasibility unknown.
    - **inside-out** — pick when the domain core is the hard part.
    Record in STATE.md `strategy` + CLAUDE.md. `integration-test-first` chosen → also copy its rule block into CLAUDE.md (templates.md → CLAUDE.md, Development Strategy section).
```

- [ ] **Step 2: Insert Q15b after Q15 in Round D**

Old (lines 38–39):

```markdown
14. Gitflow (feature branches + develop/main) or trunk-based? → STATE.md `gitflow`.
15. Autonomy default: AUTO / GUIDED / MANUAL → STATE.md `autonomy_default`.
```

New:

```markdown
14. Gitflow (feature branches + develop/main) or trunk-based? → STATE.md `gitflow`.
15. Autonomy default: AUTO / GUIDED / MANUAL → STATE.md `autonomy_default`.
15b. **Gated development** — only if Q15 = AUTO or GUIDED (MANUAL → skip silently; human already reviews all). Multi-select; derive 3–5 candidates from answers so far — the two universal gates always offered, conditional ones only when their trigger holds:
    - `regression` (universal): full suite green + zero golden/assertion drift, per-task-group proof.
    - `goal-alignment` (universal): work verifiably serves brief/MVP/strategy; blocks scope drift.
    - `compare-results` (measurable baseline exists — perf numbers, eval scores, benchmarks): new result ≥ baseline or written justification.
    - `contract-compat` (multi-service / API surface): schema/API changes compat-reviewed; version bumps + migration notes.
    - `security-privacy` (compliance answered or sensitive data): threat-model conformance, data-handling checks.
    - `perf-budget` (NFR targets or stated perf constraint): budget benches on touched paths.
    → STATE.md `gates: [...]`. Empty selection → gating off, zero downstream footprint. Enforcement is scale-dependent (see 04/06): small → orchestrator inline checklist; medium+ → read-only gatekeeper agents.
```

- [ ] **Step 3: Record gates in Outputs section**

Old (line 63):

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`.
```

New:

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `gates` (Q15b answer; `[]` if skipped/none).
```

- [ ] **Step 4: Verify**

Run: `grep -n "15b\|integration-test-first\|gates:" skills/project-setup/references/01-interview.md`
Expected: Q11 block contains `integration-test-first`; `15b.` present between Q15 and Q16; Outputs line mentions `gates`.
Also confirm Q16–18 numbering unchanged: `grep -n "^16\.\|^17\.\|^18\." skills/project-setup/references/01-interview.md` → 3 hits.

- [ ] **Step 5: Commit**

```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): Q11 strategy easy-choice + integration-test-first, Q15b gated development"
```

---

### Task 2: Templates — STATE.md fields, gate report, CLAUDE.md strategy rules (`references/templates.md`)

**Files:**
- Modify: `skills/project-setup/references/templates.md`

**Interfaces:**
- Consumes: gate ids, verdicts, `15b` semantics from Task 1.
- Produces: STATE.md `gates:` field + `## Concerns` section, gate report template at `docs/project/gates/<task-group>-gate.md`, CLAUDE.md integration-test-first rule block — Tasks 3–6 reference these paths/fields verbatim.

- [ ] **Step 1: Extend STATE.md template**

Old (lines 11–16):

```markdown
strategy: TBD             # vertical-slice|server-first|frontend-first|contract-first|infrastructure-first|prototype-first|inside-out|custom
gitflow: TBD              # true|false|custom
worktrees: TBD            # per-phase|per-feature|none
scale: TBD                # small|medium|large
next: run discovery interview
updated: YYYY-MM-DD
```

New:

```markdown
strategy: TBD             # vertical-slice|integration-test-first|server-first|frontend-first|contract-first|infrastructure-first|prototype-first|inside-out|custom
gitflow: TBD              # true|false|custom
worktrees: TBD            # per-phase|per-feature|none
scale: TBD                # small|medium|large
gates: []                 # subset of [regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget]; [] = gating off
next: run discovery interview
updated: YYYY-MM-DD
```

- [ ] **Step 2: Add Concerns section to STATE.md template**

Old (lines 18–19):

```markdown
## Notes
- <session-relevant context that fits nowhere else; keep ≤10 lines>
```

New:

```markdown
## Notes
- <session-relevant context that fits nowhere else; keep ≤10 lines>

## Concerns   <!-- gated dev only; DONE_WITH_CONCERNS entries; batch-surfaced at next boundary/session end; clear when resolved -->
- YYYY-MM-DD <gate> <task-group>: <one-line concern> → docs/project/gates/<task-group>-gate.md
```

- [ ] **Step 3: Add gate report template (new section after progress/phase-N-name.md, before Agent file section)**

Insert before the `## Agent file → .claude/agents/<name>.md` heading:

````markdown
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
````

- [ ] **Step 4: Add integration-test-first rule block to CLAUDE.md template**

Old (lines 93–94):

```markdown
## Development Strategy
<strategy>: <one line what it means for build order>
```

New:

```markdown
## Development Strategy
<strategy>: <one line what it means for build order>
<!-- integration-test-first only — include these rules verbatim: -->
- Per feature: API docs → integration tests committed as contract (`test: integration contract for <feature>`) → implement → unit tests (if enabled) → integration suite green UNMODIFIED.
- Integration tests are IMMUTABLE during implementation — never edit to make pass.
- Change protocol: functionality/structure change ⇒ update integration tests FIRST, commit, run suite; failure list = work list; fix until green.
```

- [ ] **Step 5: Verify**

Run: `grep -n "gates:\|## Concerns\|Gate report\|IMMUTABLE" skills/project-setup/references/templates.md`
Expected: all four anchors present; gate ids in `gates:` comment match Task 1 list exactly.

- [ ] **Step 6: Commit**

```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): templates for gates field, concerns, gate report, contract-by-test rules"
```

---

### Task 3: Agents — gatekeeper role (`references/04-agents.md`)

**Files:**
- Modify: `skills/project-setup/references/04-agents.md`

**Interfaces:**
- Consumes: gate ids + scale-dependent enforcement from Tasks 1–2.
- Produces: `gatekeeper` role name + tool surface — Task 5 (execution dispatch) and Task 6 (rigor table) reference it.

- [ ] **Step 1: Extend roster table for gated projects**

Old (lines 7–11, the scale/Roster table):

```markdown
| scale | Roster |
|---|---|
| small | builder (implements+tests), reviewer |
| medium | orchestrator, 1 builder per boundary (max 3), tester, reviewer |
| large | orchestrator, builders per boundary, tester, reviewer, security (report-only), devops |
```

New:

```markdown
| scale | Roster |
|---|---|
| small | builder (implements+tests), reviewer |
| medium | orchestrator, 1 builder per boundary (max 3), tester, reviewer |
| large | orchestrator, builders per boundary, tester, reviewer, security (report-only), devops |

Gated dev (STATE.md `gates` non-empty): `small` adds NO agents — orchestrator runs the gate checklist inline (06). `medium`/`large` add one read-only **gatekeeper** agent per selected gate (`.claude/agents/<gate>-gate.md`, e.g. `regression-gate`); builders-vs-gatekeepers split — builders never grade own homework.
```

- [ ] **Step 2: Add gatekeeper row to the Role/Tools table**

Old (lines 47–49):

```markdown
| reviewer | Read, Glob, Grep, Bash (read-only cmds only — state in instructions; NO Edit/Write) |
| security | Read, Bash, Glob, Grep, Write (reports only) |
| devops | Read, Edit, Write, Bash, Glob, Grep |
```

New:

```markdown
| reviewer | Read, Glob, Grep, Bash (read-only cmds only — state in instructions; NO Edit/Write) |
| security | Read, Bash, Glob, Grep, Write (reports only) |
| devops | Read, Edit, Write, Bash, Glob, Grep |
| gatekeeper | Read, Glob, Grep, Bash (test/bench runs only — state in instructions), Write (gate reports only; NO source edits) |
```

- [ ] **Step 3: Add gatekeeper must-haves (Section 4, after the Security paragraph)**

Insert after the `**Security (if opted in):**` paragraph:

```markdown
**Gatekeeper (gated dev, medium+):** one agent per selected gate; verifies only, never fixes. Runs its gate's checks (per gate definition in 01 Q15b) against the task-group diff; writes its row + evidence into `docs/project/gates/<task-group>-gate.md` (templates.md); verdict PASS / DONE_WITH_CONCERNS / FAIL — evidence mandatory (test counts, diffs, bench numbers), bare verdicts invalid. Path-triggered where scoping is clear (e.g. contract dirs → `contract-compat-gate`); otherwise orchestrator dispatches at task-group boundary, after reviewer, before group counts done. `strategy: integration-test-first` → `regression-gate` also proves integration-test immutability (diff vs contract commit; weakened assertion = FAIL). Model tag: `sonnet`.
```

- [ ] **Step 4: Verify**

Run: `grep -n "gatekeeper\|Gated dev" skills/project-setup/references/04-agents.md`
Expected: roster note, tools row, must-haves paragraph all present; report path matches Task 2 exactly (`docs/project/gates/<task-group>-gate.md`).

- [ ] **Step 5: Commit**

```bash
git add skills/project-setup/references/04-agents.md
git commit -m "feat(project-setup): gatekeeper agent role for gated development"
```

---

### Task 4: Planning — contract-by-test task ordering (`references/05-planning.md`)

**Files:**
- Modify: `skills/project-setup/references/05-planning.md`

**Interfaces:**
- Consumes: `integration-test-first` semantics from Task 1, contract commit message format from Task 2.
- Produces: plan-level ordering rule — Task 5's execution loop assumes plans already sequence tasks this way.

- [ ] **Step 1: Add strategy ordering to Section 3 (Write the plan)**

Old (lines 28–30):

```markdown
- Bite-sized tasks (2–10 min each): exact paths, exact commands, complete code (not "add validation"), TDD order (test → fail → implement → pass), 1 commit per task.

Infra/deploy phase → invoke `weloin:deploy-setup` (installed) for Make/compose/Helm/CI setup; fallback: minimal Makefile + compose + single CI workflow, documented in plan.
```

New:

```markdown
- Bite-sized tasks (2–10 min each): exact paths, exact commands, complete code (not "add validation"), TDD order (test → fail → implement → pass), 1 commit per task.
- `strategy: integration-test-first` → per feature the plan MUST sequence: (a) API docs/contract task; (b) integration-tests task, committed `test: integration contract for <feature>`; (c) implementation task(s); (d) unit-tests task (if Q13 enabled); (e) verification task: integration suite green + `git diff <contract-commit>..HEAD -- <integration test paths>` shows zero assertion changes. Plan header records contract-commit placeholder for (e).

Infra/deploy phase → invoke `weloin:deploy-setup` (installed) for Make/compose/Helm/CI setup; fallback: minimal Makefile + compose + single CI workflow, documented in plan.
```

- [ ] **Step 2: Verify**

Run: `grep -n "integration-test-first\|integration contract" skills/project-setup/references/05-planning.md`
Expected: both anchors present; commit message format matches Task 2's CLAUDE.md block (`test: integration contract for <feature>`).

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/05-planning.md
git commit -m "feat(project-setup): integration-test-first task ordering in plans"
```

---

### Task 5: Execution — gate step, verdicts, change protocol (`references/06-execution.md`)

**Files:**
- Modify: `skills/project-setup/references/06-execution.md`

**Interfaces:**
- Consumes: gate report template + `## Concerns` (Task 2), gatekeeper dispatch (Task 3), plan ordering (Task 4).
- Produces: runtime contract for gates — nothing downstream consumes it (terminal reference file).

- [ ] **Step 1: Insert gate step into task loop (between step 5 progress-update and step 6 mode-gate)**

Old (lines 12–16):

```markdown
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
6. Mode gate:
   - AUTO → next task.
   - GUIDED → pause at task-group boundary (plan's natural sections): compressed report (done / tests / interfaces touched / next group), wait for go.
   - MANUAL → present next task before executing, wait for approval.
```

New:

```markdown
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
5b. Quality gates (STATE.md `gates` non-empty; runs at task-GROUP boundary — plan's natural sections — not per micro-task): after reviewer, before group counts done. small → orchestrator runs each selected gate's checklist inline; medium+ → dispatch gatekeeper agents (04). Write `docs/project/gates/<task-group>-gate.md` (templates.md). Per-gate verdicts:
   - PASS → continue.
   - FAIL → group NOT done; fix loop; failures count toward the 3-failure escalation rule (step 2).
   - DONE_WITH_CONCERNS → continue; concern → gate report + STATE.md `## Concerns`; batch-surface at next GUIDED boundary or AUTO session end. Never silently dropped.
6. Mode gate:
   - AUTO → next task.
   - GUIDED → pause at task-group boundary (plan's natural sections): compressed report (done / tests / interfaces touched / gate verdicts + concerns / next group), wait for go.
   - MANUAL → present next task before executing, wait for approval.
```

- [ ] **Step 2: Add integration-test-first section (after the Task loop section, before Plan completion)**

Insert:

```markdown
## Strategy: integration-test-first (STATE.md `strategy`)

- Builder dispatch text includes: integration tests IMMUTABLE — never edit to make pass; failing integration test = implementation wrong.
- Functionality/structure change requested → update integration tests FIRST, commit, run suite; resulting failure list = work list; fix until green. Only this protocol may touch integration tests.
- Gating on → regression gate proves immutability (diff vs contract commit; weakened assertion = FAIL). Gating off → orchestrator enforces same check at plan completion; violation = blocker, escalate.
```

- [ ] **Step 3: Surface concerns at plan completion**

Old (line 26):

```markdown
7. Compressed completion report to user: shipped / test results / review findings resolved / deviations from spec (also logged in progress notes) / next phase.
```

New:

```markdown
7. Compressed completion report to user: shipped / test results / review findings resolved / gate verdicts + open concerns (STATE.md `## Concerns`; resolved ones cleared) / deviations from spec (also logged in progress notes) / next phase.
```

- [ ] **Step 4: Verify**

Run: `grep -n "5b\.\|IMMUTABLE\|DONE_WITH_CONCERNS\|gates" skills/project-setup/references/06-execution.md`
Expected: step 5b present between steps 5 and 6; strategy section present; verdicts match Task 2 spelling; report path matches Task 2.

- [ ] **Step 5: Commit**

```bash
git add skills/project-setup/references/06-execution.md
git commit -m "feat(project-setup): gate step in execution loop + integration-test-first protocol"
```

---

### Task 6: Router — SKILL.md fields + rigor table (`SKILL.md`)

**Files:**
- Modify: `skills/project-setup/SKILL.md`

**Interfaces:**
- Consumes: `gates` field (Task 2), scale-dependent enforcement (Tasks 3/5).
- Produces: nothing (router surface only).

- [ ] **Step 1: Add `gates` to SSOT field list**

Old (line 29, within the SSOT paragraph):

```markdown
`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `next`, `updated`.
```

New:

```markdown
`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

- [ ] **Step 2: Add gated-dev row to rigor table**

Old (lines 36–41):

```markdown
   | | small | medium | large |
   |---|---|---|---|
   | Interview | ~8 Q | ~15 Q | ~20 Q + NFRs (perf, SLO, compliance) |
   | Docs | brief+requirements merged; ADRs inline | full tree | full tree + NFR + deployment doc |
   | Agents | builder + reviewer | 3–5 roster | full roster + security + devops |
   | Review gates | reviewer per phase | per plan | per plan + cross-agent conformance |
```

New:

```markdown
   | | small | medium | large |
   |---|---|---|---|
   | Interview | ~8 Q | ~15 Q | ~20 Q + NFRs (perf, SLO, compliance) |
   | Docs | brief+requirements merged; ADRs inline | full tree | full tree + NFR + deployment doc |
   | Agents | builder + reviewer | 3–5 roster | full roster + security + devops |
   | Review gates | reviewer per phase | per plan | per plan + cross-agent conformance |
   | Quality gates (if `gates` opted, Q15b) | orchestrator inline checklist | gatekeeper agents | gatekeeper agents |
```

- [ ] **Step 3: Verify cross-file consistency (final check, all 6 files)**

Run:
```bash
grep -rn "integration-test-first" skills/project-setup/ | wc -l
grep -rn "docs/project/gates/<task-group>-gate.md" skills/project-setup/ | wc -l
grep -rn "DONE_WITH_CONCERNS" skills/project-setup/ | wc -l
```
Expected: first ≥ 5 (files 01, 05, 06, templates, and SKILL.md only if quoted); second ≥ 3 (templates, 04, 06); third ≥ 2 (templates, 06). Then read each changed hunk once — confirm gate ids (`regression`, `goal-alignment`, `compare-results`, `contract-compat`, `security-privacy`, `perf-budget`) spelled identically in 01, templates, and nowhere else spelled differently.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/SKILL.md
git commit -m "feat(project-setup): gates field + quality-gates rigor row in router"
```

---

### Task 7: Dry-run validation (no file changes)

**Files:**
- Read-only: all six changed files.

**Interfaces:**
- Consumes: everything above.
- Produces: pass/fail verdict on the two spec scenarios.

- [ ] **Step 1: Walk scenario A — small project, MANUAL autonomy**

Read `01-interview.md` Round C/D as if interviewing: confirm Q15b's own condition text mandates silent skip under MANUAL; confirm `templates.md` STATE.md renders `gates: []`; confirm `06-execution.md` step 5b self-disables on empty `gates` ("`gates` non-empty" guard). Any scenario step where a file forces gate artifacts on this project = defect → fix in the owning file, amend that task's commit.

- [ ] **Step 2: Walk scenario B — medium multi-service API, AUTO autonomy**

Confirm: Q11 text marks `integration-test-first` as the recommendation for exactly this shape; Q15b offers `contract-compat` + both universals; `04-agents.md` yields one gatekeeper per selected gate at medium; `05-planning.md` forces (a)–(e) ordering; `06-execution.md` 5b produces the report and routes DONE_WITH_CONCERNS to STATE.md `## Concerns`. Any gap = defect → fix in owning file.

- [ ] **Step 3: Report**

Both scenarios clean → done. Report to user: files changed, commits, scenario results.
