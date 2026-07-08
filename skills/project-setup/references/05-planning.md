# Phase 4: Planning

## 1. Phase breakdown

Break spec into phases; each phase yields working, testable software. Order per `strategy` (vertical-slice → one complete feature per phase; server-first → API phases then UI; etc.). Present table:

| Phase | Name | Depends on | Scope | Exit criteria |
|---|---|---|---|---|

ALIGN path: pre-mark already-built work as phase(s) with status `complete`.
User approves breakdown (gate).

## 2. The macro-plan ask (EVERY time a phase plan is created)

One AskUserQuestion batch, defaults = current STATE.md values:
1. Worktree for this phase? (isolated worktree / current checkout) — yes → delegate `superpowers:using-git-worktrees` if installed, else `git worktree add ../<proj>-phase-N feat/phase-N-<name>`.
2. Branch: gitflow (`feat/phase-N-<name>` off develop) / trunk / custom.
3. Autonomy for this phase: AUTO / GUIDED / MANUAL.
Record answers → STATE.md (`worktrees`, `gitflow`, per-phase autonomy noted in progress file header).

## 3. Write the plan

Delegate: `superpowers:writing-plans` installed → invoke it; output to `docs/project/plans/phase-N-<name>.md`.

Fallback format (same path):
- Header: goal, exit criteria, spec refs (§), branch, worktree, autonomy, DoD per `maturity` (rule 2b).
- File map: files created/modified.
- Bite-sized tasks (2–10 min each): exact paths, exact commands, complete code (not "add validation"), TDD order (test → fail → implement → pass), 1 commit per task.
- `strategy: integration-test-first` → per feature the plan MUST sequence: (a) API docs/contract task; (b) integration-tests task, committed `test: integration contract for <feature>`; (c) implementation task(s); (d) unit-tests task (if Q13 enabled); (e) verification task: integration suite green + `git diff <contract-commit>..HEAD -- <integration test paths>` shows zero assertion changes. Plan header records contract-commit placeholder for (e).

Infra/deploy phase → STATE.md `make_workflow` != none → invoke `weloin:deploy-setup` (installed) passing recorded scope (A local-only / B deploy-only / C both) + local-infra answer so it skips re-asking; it scans real code at this point — that's why the build waits until here. Fallback (not installed): minimal Makefile + compose + single CI workflow honoring `make <env|surface> <action> [args]`, documented in plan. `make_workflow: none` → skip.

`medium+`: reviewer subagent checks plan (task completeness, dependency order, spec conformance); fix; max 2 rounds. User approves plan (gate).

## 3b. Hardening plan (`promote` subcommand only)

Plan sourced from: open `docs/project/40-debt.md` rows + new-level requirements from rule 2b delta (prototype→mvp: migrations from first schema, `.env`, core-path tests; mvp→production: secrets manager, full tests, gates setup if newly selected, observability). Normal machinery applies: macro-plan ask, reviewer check (medium+), user gate. Each task resolving a DEBT row marks it `resolved (<ref>)` in the same commit.

## 4. Progress scaffold (first plan only; then per plan)

Per templates.md:
- `docs/project/progress/README.md` — phase table: phase / name / status / branch / completed date.
- `docs/project/progress/phase-N-<name>.md` — task checkboxes (each: files, spec §), test-results table, review status, notes (blockers, deviations).
- `small` scale + ≤2 phases: single `docs/project/progress.md` instead of directory.
- ALIGN path: completed phases pre-checked with note `pre-existing`.

## 5. Transition

STATE.md: `phase: 5-execution`, `next: execute phase N task 1`. Commit: `docs: phase N plan and progress scaffold`. → read 06-execution.md.
