# Orchestration Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a re-settable `orchestration` config axis (session | agent/per-plan | agent/default-agent) to the `weloin:project-setup` skill controlling who runs the execution task loop, including parallel orchestrator dispatch with mandatory per-orchestrator worktrees.

**Architecture:** Pure markdown skill edits — no code. Six files under `skills/project-setup/` gain coordinated text: STATE.md field (templates), interview question Q15c (01), conditional orchestrator roster (04), macro-plan parallelism check (05), new §Dispatch (06), SSOT field + subcommand row (SKILL.md). Spec: `docs/superpowers/specs/2026-07-16-orchestration-mode-design.md`.

**Tech Stack:** Markdown only. Verification = `grep` assertions per edit.

## Global Constraints

- Doc style: detailed-compressed — dense bullets/tables, telegraphic, zero filler (SKILL.md rule 1). Match surrounding density exactly.
- Field grammar everywhere identical: `orchestration: session | agent/per-plan | agent/default-agent` (compound like `commit_strategy`).
- Commits: conventional style, NO AI attribution of any kind (no Co-Authored-By, no "Generated with" — global rule).
- Do not renumber or reword any existing question/section not named below.
- Repo root: `/Users/sukanta/Projects/Development/weloin/weloin-skills`.

---

### Task 1: templates.md — STATE.md field + CLAUDE.md Agents line

**Files:**
- Modify: `skills/project-setup/references/templates.md`

**Interfaces:**
- Produces: STATE.md header line `orchestration:` (consumed by every later task's cross-references); CLAUDE.md `## Agents` orchestration line.

- [ ] **Step 1: Add STATE.md template field**

In the STATE.md template code block, find:

```markdown
worktrees: TBD            # per-phase|per-feature|ask|none — ask = prompt (current branch/new branch/worktree) at each substantial change
```

Insert directly after that line:

```markdown
orchestration: TBD        # session|agent/per-plan|agent/default-agent — who runs the execution loop (06 §Dispatch); agent/per-plan enables parallel orchestrators
```

- [ ] **Step 2: Update CLAUDE.md template `## Agents` section**

Find:

```markdown
## Agents
Default: <orchestrator or n/a>. Roster: <name — scope> per line.
```

Replace with:

```markdown
## Agents
Orchestration: <session | agent/per-plan | agent/default-agent>. Default: <orchestrator — agent/default-agent mode only | n/a>. Roster: <name — scope> per line.
```

- [ ] **Step 3: Verify**

Run: `grep -ic "orchestration" skills/project-setup/references/templates.md`
Expected: `2` (case-insensitive line count: STATE.md field line + CLAUDE.md `Orchestration:` line)

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): orchestration field in STATE.md + CLAUDE.md templates"
```

---

### Task 2: 01-interview.md — Q15c + prototype skip + outputs

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Consumes: `orchestration` field grammar (Task 1).
- Produces: question id `Q15c` (referenced by 04 and SKILL.md subcommand row as `01 §Q15c`).

- [ ] **Step 1: Add Q15c after Q15b**

Find the last line of the Q15b block:

```markdown
    → STATE.md `gates: [...]`. Empty selection → gating off, zero downstream footprint. Enforcement is scale-dependent (see 04/06): small → orchestrator inline checklist; medium+ → read-only gatekeeper agents.
```

Insert directly after it (before `16. CI/CD preference...`):

```markdown
15c. **Orchestration mode** — who runs the execution task loop (06 §Dispatch). → STATE.md `orchestration`. `scale: small` → skip silently, default `session` (orchestrator agent never exists at small). `maturity: prototype` → skip silently, default `session` noted. Option copy contextualized per Q11 rule (project's own nouns).
    - `session` — this session IS the orchestrator; dispatches builders/reviewer/gatekeepers directly; no orchestrator agent file (04 §4 must-haves bind to session). RECOMMEND small.
    - `agent/per-plan` — session spawns one orchestrator agent per macro-plan; orchestrator runs the task loop, reports compressed; independent workstreams → N parallel orchestrators, worktree each (06 §Dispatch). RECOMMEND medium+.
    - `agent/default-agent` — `.claude/settings.json {"agent":"orchestrator"}`; every session boots as the orchestrator; no parallel fan-out.
```

- [ ] **Step 2: Add Q15c to prototype skip list**

Find (in §1 adaptive rules):

```markdown
- After Round A, also set `maturity` (SKILL.md rule 2b) — **prototype**: skip Q13 (testing = smoke, noted), Q14 (gitflow = trunk, noted), Q15b (silently), Q16, Q17 (`make_workflow: none`), Q18, Round F; Q15 autonomy still asked (execution loop needs it). **mvp**: all asked; gates optional, no recommendation push; make_workflow default A. **production**: Q15b universals preselected as recommended; make_workflow leans C; Q18 becomes confirm (auto-include medium+).
```

Replace with:

```markdown
- After Round A, also set `maturity` (SKILL.md rule 2b) — **prototype**: skip Q13 (testing = smoke, noted), Q14 (gitflow = trunk, noted), Q15b (silently), Q15c (orchestration = session, noted), Q16, Q17 (`make_workflow: none`), Q18, Round F; Q15 autonomy still asked (execution loop needs it). **mvp**: all asked; gates optional, no recommendation push; make_workflow default A. **production**: Q15b universals preselected as recommended; make_workflow leans C; Q18 becomes confirm (auto-include medium+).
```

- [ ] **Step 3: Add `orchestration` to Outputs STATE.md update list**

Find:

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `maturity` (Q4b), `gates` (Q15b answer; `[]` if skipped/none).
```

Replace with:

```markdown
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`, `strategy`, `maturity` (Q4b), `gates` (Q15b answer; `[]` if skipped/none), `orchestration` (Q15c; `session` if skipped).
```

- [ ] **Step 4: Verify**

Run: `grep -c "15c" skills/project-setup/references/01-interview.md`
Expected: `3` (question block, prototype skip list, outputs line)

- [ ] **Step 5: Commit**

```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): Q15c orchestration mode in discovery interview"
```

---

### Task 3: 04-agents.md — conditional orchestrator + settings.json gating + migration

**Files:**
- Modify: `skills/project-setup/references/04-agents.md`

**Interfaces:**
- Consumes: `Q15c` (Task 2), field grammar (Task 1).
- Produces: conditional-roster rule referenced by SKILL.md subcommand row (`04 §2 update-aware`, retire rule — both already exist, unchanged).

- [ ] **Step 1: Add conditional-orchestrator rule after roster table**

Find (directly after the scale/roster table in §1):

```markdown
Gated dev (STATE.md `gates` non-empty): `small` adds NO agents — orchestrator runs the gate checklist inline (06). `medium`/`large` add one read-only **gatekeeper** agent per selected gate (`.claude/agents/<gate>-gate.md`, e.g. `regression-gate`); builders-vs-gatekeepers split — builders never grade own homework.
```

Insert directly BEFORE it:

```markdown
Orchestrator row conditional on STATE.md `orchestration` (01 §Q15c): created only when `agent/*`. `session` → roster minus orchestrator — the main session performs the orchestrator role (§4 must-haves bind to session behavior). Field absent (pre-field project) → ask Q15c now, record in STATE.md before deriving the roster — never derive silently from the existing roster.
```

- [ ] **Step 2: Gate the settings.json default-agent ask on mode**

Find (in §5):

```markdown
- `.claude/settings.json` default-agent (`{"agent": "orchestrator"}`): ASK first — side effect on every session; only write if user says yes.
```

Replace with:

```markdown
- `.claude/settings.json` default-agent (`{"agent": "orchestrator"}`): ONLY when `orchestration: agent/default-agent` — ASK first (side effect on every session), write only on yes. Other modes → never offer; file already sets `"agent": "orchestrator"` while mode ≠ default-agent → ask to remove (rule 6 — never silent).
```

- [ ] **Step 3: Verify**

Run: `grep -c "orchestration" skills/project-setup/references/04-agents.md`
Expected: `2`

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/04-agents.md
git commit -m "feat(project-setup): orchestrator roster conditional on orchestration mode"
```

---

### Task 4: 05-planning.md — parallelism check in macro-plan ask

**Files:**
- Modify: `skills/project-setup/references/05-planning.md`

**Interfaces:**
- Consumes: `agent/per-plan` value (Task 1).
- Produces: parallel-dispatch offer consumed by 06 §Dispatch (Task 5) — "offered at macro-plan, 05 §2".

- [ ] **Step 1: Add item 4 to the macro-plan ask**

Find (in §2):

```markdown
3. Autonomy for this phase: AUTO / GUIDED / MANUAL.
Record answers → STATE.md (`worktrees`, `gitflow`, per-phase autonomy noted in progress file header).
```

Replace with:

```markdown
3. Autonomy for this phase: AUTO / GUIDED / MANUAL.
4. Parallel dispatch — only when `orchestration: agent/per-plan` AND the breakdown contains independent workstreams (no `Depends on` edges between them): offer one orchestrator per workstream, concurrent. Accepted → record workstream→orchestrator map in each progress file header; worktree per orchestrator mandatory (06 §Dispatch).
Record answers → STATE.md (`worktrees`, `gitflow`, per-phase autonomy noted in progress file header).
```

- [ ] **Step 2: Verify**

Run: `grep -c "Parallel dispatch" skills/project-setup/references/05-planning.md`
Expected: `1`

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/05-planning.md
git commit -m "feat(project-setup): parallel-dispatch offer in macro-plan ask"
```

---

### Task 5: 06-execution.md — §Dispatch

**Files:**
- Modify: `skills/project-setup/references/06-execution.md`

**Interfaces:**
- Consumes: parallel-dispatch offer (Task 4), field grammar (Task 1).
- Produces: `06 §Dispatch` referenced by Q15c copy (Task 2) and templates comment (Task 1).

- [ ] **Step 1: Insert §Dispatch after the intro paragraph**

Find:

```markdown
Autonomy mode for this phase = progress file header (set at macro-plan ask). Delegate discipline: `superpowers:subagent-driven-development` (subagent-per-task) or `superpowers:executing-plans` if installed; the loop below is the contract either way.

## Isolation per substantial change (STATE.md `worktrees` policy)
```

Replace with:

```markdown
Autonomy mode for this phase = progress file header (set at macro-plan ask). Delegate discipline: `superpowers:subagent-driven-development` (subagent-per-task) or `superpowers:executing-plans` if installed; the loop below is the contract either way.

## Dispatch (STATE.md `orchestration`)

Who runs the task loop:
- `session` → this session runs the loop directly.
- `agent/default-agent` → session already booted as orchestrator; loop as written.
- `agent/per-plan` → spawn one orchestrator agent per macro-plan: dispatch = plan path + spec §refs + CLAUDE.md rules + phase autonomy mode (progress header); orchestrator runs the full loop, commits progress per task (rule 7 holds inside its scope); compressed report back to session. GUIDED pauses surface through the session.

**Parallel dispatch** (2+ orchestrators concurrent; offered at macro-plan, 05 §2):
- Worktree per orchestrator MANDATORY — overrides `worktrees: none` for this dispatch only (policy value untouched). Each orchestrator: own branch, own worktree, own progress file.
- STATE.md single-writer: parallel orchestrators update ONLY their own progress file; STATE.md owned by the session — `next:` lists active workstreams; session reconciles at fan-in. Amends rule 7 for the parallel case only; all other modes keep same-commit STATE.md updates.
- Fan-in: session merges per gitflow answer, cleans worktrees (§Plan completion merge rule), updates STATE.md + progress README in one commit.
- Escalation: 3-failure rule (task loop step 2) escalates orchestrator→session→user; cross-workstream conflicts (scope/conventions/shared interfaces) → session→user, never resolved silently (04 §4).

## Isolation per substantial change (STATE.md `worktrees` policy)
```

- [ ] **Step 2: Verify**

Run: `grep -c "## Dispatch" skills/project-setup/references/06-execution.md`
Expected: `1`

Run: `grep -c "single-writer" skills/project-setup/references/06-execution.md`
Expected: `1`

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/06-execution.md
git commit -m "feat(project-setup): dispatch section — session vs orchestrator agents, parallel rules"
```

---

### Task 6: SKILL.md — SSOT field + subcommand row

**Files:**
- Modify: `skills/project-setup/SKILL.md`

**Interfaces:**
- Consumes: `01 §Q15c` (Task 2), 04 conditional rule (Task 3).
- Produces: user-facing `orchestration` subcommand (alias `orchestrator`).

- [ ] **Step 1: Add field to SSOT list**

Find (in `## SSOT: docs/project/`):

```markdown
`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `commit_strategy` (`<style>/<detail>/<signature>`), `worktrees`, `scale` (small|medium|large), `maturity` (prototype|mvp|production), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

Replace with:

```markdown
`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `commit_strategy` (`<style>/<detail>/<signature>`), `worktrees`, `orchestration` (session|agent/per-plan|agent/default-agent), `scale` (small|medium|large), `maturity` (prototype|mvp|production), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

- [ ] **Step 2: Add subcommand row**

Find (the `worktrees` row in the subcommand table):

```markdown
| `worktrees` | 01 §Q14b | Show current `worktrees` policy; re-ask (per-phase/per-feature/ask/none); update STATE.md; takes effect next macro-plan / substantial change |
```

Insert directly after it:

```markdown
| `orchestration` (alias `orchestrator`) | 01 §Q15c + 04 | Show current `orchestration`; re-ask 3 options (default = current); update STATE.md + CLAUDE.md `## Agents`; →`agent/*` = create/update orchestrator agent (04 §2 update-aware); →`session` = retire-ask orchestrator file (04 §2 — default keep, mark deprecated); default-agent↔per-plan = settings.json add/remove ask (04 §5); applies next macro-plan |
```

- [ ] **Step 3: Verify**

Run: `grep -c "orchestration" skills/project-setup/SKILL.md`
Expected: `2` (line count: SSOT list line + subcommand table row — name and action cells share one line)

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/SKILL.md
git commit -m "feat(project-setup): orchestration SSOT field + re-settable subcommand"
```

---

### Task 7: Version bump + changelog

**Files:**
- Modify: `package.json` (version only)
- Create: `changelogs/CHANGELOG-v0.2.6.md`

**Interfaces:**
- Consumes: all prior tasks' commits (changelog summarizes them).

- [ ] **Step 1: Bump version**

In `package.json`, change `"version": "0.2.5"` → `"version": "0.2.6"` (patch bump — release-flow convention: patch even for features).

- [ ] **Step 2: Write changelog**

Create `changelogs/CHANGELOG-v0.2.6.md`:

```markdown
# v0.2.6

## Features

- **project-setup: orchestration mode** — new STATE.md field `orchestration: session | agent/per-plan | agent/default-agent` controlling who runs the execution task loop.
  - `session`: main session orchestrates directly; no orchestrator agent file (04 must-haves bind to session).
  - `agent/per-plan`: one orchestrator agent spawned per macro-plan; independent workstreams → N parallel orchestrators, mandatory worktree each, STATE.md single-writer (session reconciles at fan-in).
  - `agent/default-agent`: `.claude/settings.json` boots every session as the orchestrator; settings.json ask now gated on this mode.
  - Interview Q15c (Round D; small scale + prototype maturity default `session` silently); re-settable anytime via `orchestration` subcommand (alias `orchestrator`); parallel-dispatch offer added to macro-plan ask (05 §2); new 06 §Dispatch.

Spec: `docs/superpowers/specs/2026-07-16-orchestration-mode-design.md`.
```

- [ ] **Step 3: Verify**

Run: `grep '"version"' package.json`
Expected: `"version": "0.2.6",`

- [ ] **Step 4: Commit**

```bash
git add package.json changelogs/CHANGELOG-v0.2.6.md
git commit -m "chore: bump version to 0.2.6, changelog for v0.2.6"
```

Tag + push: user-driven per release flow (`/tag` skill) — NOT part of this plan.
