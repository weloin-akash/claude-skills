# Make Workflow + Repo Structure + Subcommand Router Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Q10b (repo structure) + Q17 rework (make workflow) to the interview, record both in STATE.md/CLAUDE.md templates, pass recorded scope to deploy-setup at infra phase, and add a subcommand router table to SKILL.md.

**Architecture:** Documentation edits to 4 files in `skills/project-setup/`. Exact old→new content per task; verification = grep anchors.

**Tech Stack:** Markdown skill files, git.

**Spec:** `docs/superpowers/specs/2026-07-08-make-workflow-monorepo-subcommands-design.md`.

## Global Constraints

- Detailed-compressed style; match surrounding density.
- Exact vocabulary everywhere: STATE.md fields `repo_structure` (`single|monorepo|polyrepo`) and `make_workflow` (`none|A|B|C`); question ids `10b`, `17` (reworked in place, no renumbering of 16/18); convention string `make <env|surface> <action> [args]`; subcommands `deploy`, `gates` (alias `tests`), `autonomy`, `strategy`, `agents`, `plan`, `status`.
- No AI attribution in commits.
- Push after all tasks (user standing instruction).

---

### Task 1: Interview — Q10b + Q17 rework (`references/01-interview.md`)

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Produces: field names `repo_structure`, `make_workflow` + scope ids A/B/C — Tasks 2–4 use verbatim.

- [ ] **Step 1: Insert Q10b after Q10**

Old:

```markdown
10. Architecture: monolith / modular monolith / multi-service / microservices / monorepo multi-service / suggest.
```

New:

```markdown
10. Architecture: monolith / modular monolith / multi-service / microservices / monorepo multi-service / suggest.
10b. Repo structure — recommend from Q10 (multi-service → monorepo; monolith → single-app unless shared libs planned):
    - **single-app repo** — one app, flat layout.
    - **monorepo** — `apps/` + `packages/`; valid even for single app + shared libs.
    - **polyrepo** — recorded as note only; this setup covers the current repo.
    → STATE.md `repo_structure: single|monorepo|polyrepo`. Drives architecture layout (03), builder-per-boundary scoping to `apps/*` (04), plan paths (05).
```

- [ ] **Step 2: Rework Q17**

Old:

```markdown
17. Local infra: docker compose / native / devcontainers / suggest.
```

New:

```markdown
17. Local + deployed workflow — Make-based canonical interface wanted? Convention: `make <env|surface> <action> [args]` (`make local up`, `make local nuke`, `make staging deploy`, `make app run ios`, `make setup`). Scope (mirrors `weloin:deploy-setup`): **A** local-only (Makefile + compose + scripts) / **B** deploy-only (Helm + CI + deploy.sh) / **C** both / **none**. Sub-choice: local infra = docker compose / native / devcontainers / suggest.
    → STATE.md `make_workflow: none|A|B|C` + local-infra note. CLAUDE.md gains `## Commands` section (templates.md); rule: env/lifecycle ops via make targets — docs never instruct raw docker/kubectl/helm when a target exists. Built at infra/deploy phase via `weloin:deploy-setup` (05) — asked now, never built now.
```

- [ ] **Step 3: Verify**

Run: `grep -n "10b\.\|make_workflow\|repo_structure" skills/project-setup/references/01-interview.md`
Expected: Q10b between Q10 and Q11; Q17 contains `make_workflow: none|A|B|C`; Q16/Q18 untouched (`grep -n "^16\.\|^18\." …` → 2 hits).

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): Q10b repo structure + Q17 make-workflow rework"
```

---

### Task 2: Templates — STATE.md fields + CLAUDE.md Commands (`references/templates.md`)

**Files:**
- Modify: `skills/project-setup/references/templates.md`

**Interfaces:**
- Consumes: field names from Task 1.
- Produces: CLAUDE.md `## Commands` section referenced by Task 1's Q17 text.

- [ ] **Step 1: Add fields to STATE.md template**

Old:

```markdown
scale: TBD                # small|medium|large
gates: []                 # subset of [regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget]; [] = gating off
```

New:

```markdown
scale: TBD                # small|medium|large
repo_structure: TBD       # single|monorepo|polyrepo
make_workflow: TBD        # none|A(local-only)|B(deploy-only)|C(both) — built at infra phase via weloin:deploy-setup
gates: []                 # subset of [regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget]; [] = gating off
```

- [ ] **Step 2: Add Commands section to CLAUDE.md template (after Development Strategy block, before ## Rules)**

Old:

```markdown
- Change protocol: functionality/structure change ⇒ update integration tests FIRST, commit, run suite; failure list = work list; fix until green.

## Rules
```

New:

```markdown
- Change protocol: functionality/structure change ⇒ update integration tests FIRST, commit, run suite; failure list = work list; fix until green.

## Commands   <!-- make_workflow != none only -->
Convention: `make <env|surface> <action> [args]`. Examples: `make local up` (bootstrap stack), `make local nuke` (fresh start), `make <env> deploy`, `make setup`. Full surface: `make help`. Env/lifecycle ops go through make targets — never raw docker/kubectl/helm when a target exists.

## Rules
```

- [ ] **Step 3: Verify**

Run: `grep -n "repo_structure\|make_workflow\|## Commands" skills/project-setup/references/templates.md`
Expected: 2 STATE.md fields + `## Commands` section present.

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): repo_structure + make_workflow fields, CLAUDE.md Commands section"
```

---

### Task 3: Planning — pass scope to deploy-setup (`references/05-planning.md`)

**Files:**
- Modify: `skills/project-setup/references/05-planning.md`

**Interfaces:**
- Consumes: `make_workflow` scopes from Task 1.

- [ ] **Step 1: Rework infra/deploy line**

Old:

```markdown
Infra/deploy phase → invoke `weloin:deploy-setup` (installed) for Make/compose/Helm/CI setup; fallback: minimal Makefile + compose + single CI workflow, documented in plan.
```

New:

```markdown
Infra/deploy phase → STATE.md `make_workflow` != none → invoke `weloin:deploy-setup` (installed) passing recorded scope (A local-only / B deploy-only / C both) + local-infra answer so it skips re-asking; it scans real code at this point — that's why the build waits until here. Fallback (not installed): minimal Makefile + compose + single CI workflow honoring `make <env|surface> <action> [args]`, documented in plan. `make_workflow: none` → skip.
```

- [ ] **Step 2: Verify**

Run: `grep -n "make_workflow" skills/project-setup/references/05-planning.md`
Expected: 2+ mentions in the reworked line.

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/05-planning.md
git commit -m "feat(project-setup): infra phase passes make_workflow scope to deploy-setup"
```

---

### Task 4: Router — subcommands + fields (`SKILL.md`)

**Files:**
- Modify: `skills/project-setup/SKILL.md`

**Interfaces:**
- Consumes: everything above.

- [ ] **Step 1: Add fields to SSOT list**

Old:

```markdown
Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

New:

```markdown
Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`.
```

- [ ] **Step 2: Add subcommand section after the Routing section**

Insert after the routing table's closing paragraph (the line ending `Never pre-read others.`), before `**AskUserQuestion unavailable**`:

```markdown
## Subcommands (ARGUMENTS routing — checked BEFORE state detection)

Skill invoked with arguments (`/weloin:project-setup <subcommand> [free-text context]`) → focused flow, not the phase machine. First word routes (tolerant match: `deploy`/`deployment`, `gates`/`tests`, plural/singular); the remainder is user context — absorb it like interview answers (adaptive-skip: whatever it answers, don't re-ask; e.g. `deploy use kubernetes, single node, ghcr images` pre-answers deploy-setup questions). Read STATE.md first; missing → say so, offer full INIT/ALIGN, never fabricate state (`status` just reports "no project state"). Ask only what's still missing (defaults = STATE.md values); all Global Rules hold (update-aware, same-commit STATE.md updates, user gates). Unknown subcommand → print this table, take no action.

| Subcommand | Loads | Action |
|---|---|---|
| `deploy` | 05 | `make_workflow` unset → ask scope A/B/C + local infra; invoke `weloin:deploy-setup` with scope (fallback per 05); record |
| `gates` (alias `tests`) | 01 §Q15b + 04 + 06 | Show current `gates`; re-derive candidates, multi-select; update STATE.md; medium+ → create/update gatekeeper agents (04 §2); offer immediate gate run on current diff → gate report. Explicit invocation = opt-in — Q15b's AUTO/GUIDED condition does NOT apply here |
| `autonomy` | — (rule 4) | Show `autonomy_default` + per-phase override; ask new; update STATE.md (+ progress header if mid-phase) |
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates) |
| `agents` | 04 | Update-aware roster review (04 §2) |
| `plan` | 05 | Plan next phase now (macro-plan ask included) |
| `status` | — | STATE.md + progress + `git log --oneline -5` → compressed report; zero writes |
| `help` | — | Print this table + one line: no args = full phase machine (INIT/ALIGN/RESUME); zero writes |
```

- [ ] **Step 3: Verify**

Run: `grep -n "Subcommands\|repo_structure\|make_workflow" skills/project-setup/SKILL.md`
Expected: fields line updated; subcommand section present with 8 rows (incl. `help`).

- [ ] **Step 4: Commit**

```bash
git add skills/project-setup/SKILL.md
git commit -m "feat(project-setup): subcommand router + repo_structure/make_workflow fields"
```

---

### Task 5: README documentation (`README.md`)

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add subcommand + feature docs after the usage line**

Old (line 64):

```markdown
Then in any Claude Code session: `/weloin:project-setup` (or just say "set up a new project").
```

New:

```markdown
Then in any Claude Code session: `/weloin:project-setup` (or just say "set up a new project").

### project-setup subcommands

Focused entry points — skip the phase machine, do one thing:

| Command | Does |
|---|---|
| `/weloin:project-setup deploy` | Make-based local/deploy workflow only (scope A local-only / B deploy-only / C both) via `weloin:deploy-setup` |
| `/weloin:project-setup gates` (or `tests`) | Configure/adjust quality gates; create gatekeeper agents (medium+); optionally run gates on current diff |
| `/weloin:project-setup autonomy` | Change AUTO/GUIDED/MANUAL default or per-phase override |
| `/weloin:project-setup strategy` | Re-choose development strategy (incl. `integration-test-first` contract-by-test) |
| `/weloin:project-setup agents` | Review/update agent roster |
| `/weloin:project-setup plan` | Plan the next phase now |
| `/weloin:project-setup status` | Compressed project state report (read-only) |
| `/weloin:project-setup help` | This table |

Notable opt-in features (asked during the interview, all recorded in `docs/project/STATE.md`):

- **Gated development** — quality gates (regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget) that work must pass before it counts as done; verdicts PASS / DONE_WITH_CONCERNS / FAIL with evidence reports under `docs/project/gates/`. Small projects: inline checklist; medium+: dedicated read-only gatekeeper agents.
- **integration-test-first strategy** — integration tests written first and committed as an immutable contract; implementation must make them pass unmodified; changes update tests first so breakage enumerates every dependent.
- **Make workflow** — canonical `make <env|surface> <action> [args]` interface (`make local up`, `make staging deploy`, `make local nuke`), built at the infra phase by `weloin:deploy-setup`.
- **Repo structure** — explicit single-app / monorepo (`apps/` + `packages/`) / polyrepo choice driving layout and agent scoping.
```

- [ ] **Step 2: Verify**

Run: `grep -n "project-setup subcommands\|integration-test-first\|Gated development" README.md`
Expected: all three anchors present.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: project-setup subcommands and opt-in features in README"
```

---

### Task 6: Dry-run validation + push

- [ ] **Step 1: Scenario walks (read-only)**

1. Multi-service web app interview → Q10b recommends monorepo; Q17 offers A/B/C/none; STATE.md template carries both fields; CLAUDE.md template shows `## Commands`.
2. `/weloin:project-setup deploy` with `make_workflow: C` → router row goes straight to deploy-setup, asks nothing answered.
3. `/weloin:project-setup gates` on MANUAL project → router row explicitly overrides Q15b condition.
4. `/weloin:project-setup status` without STATE.md → reports no state, zero writes.
Any gap → fix owning file, amend that task's commit.

- [ ] **Step 2: Cross-file consistency**

Run: `grep -rn "make_workflow\|repo_structure" skills/project-setup/ | wc -l` → expect ≥ 8 across 4 files; spot-check spelling identical.

- [ ] **Step 3: Push**

```bash
git push
```
