# Phase 5: Execution

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

Trigger: a substantial change begins — new phase/feature/fix or a user request touching many files / core surfaces (trivial one-liners exempt). Resolve isolation from policy, don't re-ask what it decides:
- `per-feature` → auto-create worktree for this change (delegate `superpowers:using-git-worktrees`, else `git worktree add ../<proj>-<slug> <branch>`).
- `ask` (depends) → one AskUserQuestion: **current branch** / **new branch** (`feat/<slug>`) / **worktree** (`feat/<slug>` in `../<proj>-<slug>`). Record choice in progress file header.
- `per-phase` → already resolved at macro-plan; no per-change ask.
- `none` → current checkout.
Worktree used → clean up after merge (06 §merge).

## Task loop (all modes)

Per task:
1. Dispatch builder subagent (or inline for trivial task): full task text + spec § + CLAUDE.md rules.
2. Builder questions → answer, re-dispatch. 3 failures on same task → stop, escalate to user.
3. Done → verify per `maturity` DoD (rule 2b): prototype → commit exists, runs, demo path works; mvp → + task's tests pass; production → + full loop incl. gates (5b).
4. Review: complex/shared-interface task → reviewer subagent now; simple task → defer to plan-end review. `maturity: prototype` → always defer to plan-end (reviewer still runs — cadence compresses, never disappears).
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** `maturity` prototype|mvp + conscious shortcut taken (builder report "shortcuts taken", or orchestrator observes) → DEBT row in `docs/project/40-debt.md`, same commit. Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
5b. Quality gates (STATE.md `gates` non-empty; runs at task-GROUP boundary — plan's natural sections — not per micro-task): after reviewer, before group counts done. small → orchestrator runs each selected gate's checklist inline; medium+ → dispatch gatekeeper agents (04). Write `docs/project/gates/<task-group>-gate.md` (templates.md). Per-gate verdicts:
   - PASS → continue.
   - FAIL → group NOT done; fix loop; failures count toward the 3-failure escalation rule (step 2).
   - DONE_WITH_CONCERNS → continue; concern → gate report + STATE.md `## Concerns`; batch-surface at next GUIDED boundary or AUTO session end. Never silently dropped.
6. Mode gate:
   - AUTO → next task.
   - GUIDED → pause at task-group boundary (plan's natural sections): compressed report (done / tests / interfaces touched / gate verdicts + concerns / next group), wait for go.
   - MANUAL → present next task before executing, wait for approval.

## Strategy: integration-test-first (STATE.md `strategy`)

- Builder dispatch text includes: integration tests IMMUTABLE — never edit to make pass; failing integration test = implementation wrong.
- Functionality/structure change requested → update integration tests FIRST, commit, run suite; resulting failure list = work list; fix until green. Only this protocol may touch integration tests.
- Gating on → regression gate proves immutability (diff vs contract commit; weakened assertion = FAIL). Gating off → orchestrator enforces same check at plan completion; violation = blocker, escalate.

## Strategy rules: eval-first / strangler-fig / spike-and-stabilize / event-first

| Strategy | Execution rule |
|---|---|
| eval-first | baseline recorded at harness commit; new results ≥ baseline or written justification — `compare-results` gate when gating on, orchestrator check at plan completion when off |
| strangler-fig | facade contract tests immutable (integration-test-first protocol); legacy code touched only to delete behind the facade |
| spike-and-stabilize | spike branch never merges; rebuild tasks cite spike learnings; every spike shortcut carried into rebuild → `40-debt.md` row |
| event-first | integration-test-first protocol with event schemas as the contract artifact |

## Plan completion

1. Full test suite; record results table in progress file.
2. Reviewer: spec conformance + (`medium+`) cross-agent conformance (contracts consistent, conventions uniform, no scope drift). Findings → fix loop.
3. Security agent scan if roster has one (standard profile).
4. Progress: phase status `complete` + date; README table updated.
5. STATE.md: `phase: 4-planning`, `next: plan phase N+1 <name>` (or `project complete`).
6. Merge per gitflow answer: gitflow → PR/merge feat branch to develop (invoke `superpowers:finishing-a-development-branch` if installed); worktree used → clean up after merge.
7. Compressed completion report to user: shipped / test results / review findings resolved / gate verdicts + open concerns (STATE.md `## Concerns`; resolved ones cleared) / deviations from spec (also logged in progress notes) / next phase.

## Resume (any session, phase 5)

1. Read STATE.md `next` + current progress file.
2. `git log --oneline -5` — verify progress file matches reality; mismatch → reconcile progress file to git truth FIRST, commit, then continue. Reality broken (no git repo, referenced code missing, branch gone) → STOP, surface findings to user before executing anything.
3. Re-confirm autonomy only if user initiates with different intent; explicit intent in their message IS the confirmation ("hurry, full auto" → AUTO for this run) — pauses/reporting compress, but reviewer, tests, progress+STATE updates never do.

## Deviations

Task can't proceed as planned (spec gap, wrong assumption) → stop task; log in progress notes; small deviation → decide, record ADR one-liner in 30-decisions.md; spec-level change → back to user with compressed options. Never silently diverge from spec.
