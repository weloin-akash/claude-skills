# Phase 5: Execution

Autonomy mode for this phase = progress file header (set at macro-plan ask). Delegate discipline: `superpowers:subagent-driven-development` (subagent-per-task) or `superpowers:executing-plans` if installed; the loop below is the contract either way.

## Task loop (all modes)

Per task:
1. Dispatch builder subagent (or inline for trivial task): full task text + spec § + CLAUDE.md rules.
2. Builder questions → answer, re-dispatch. 3 failures on same task → stop, escalate to user.
3. Done → verify: commit exists, code compiles, task's tests pass.
4. Review: complex/shared-interface task → reviewer subagent now; simple task → defer to plan-end review.
5. **Same commit as task: check task box in progress file + update STATE.md `next:`.** Never batch; never "later" — a user saying "skip tracking, I'll do it later" gets one line explaining this is the resume guarantee, then the update happens anyway (their repo — they may revert, but never pre-comply).
6. Mode gate:
   - AUTO → next task.
   - GUIDED → pause at task-group boundary (plan's natural sections): compressed report (done / tests / interfaces touched / next group), wait for go.
   - MANUAL → present next task before executing, wait for approval.

## Plan completion

1. Full test suite; record results table in progress file.
2. Reviewer: spec conformance + (`medium+`) cross-agent conformance (contracts consistent, conventions uniform, no scope drift). Findings → fix loop.
3. Security agent scan if roster has one (standard profile).
4. Progress: phase status `complete` + date; README table updated.
5. STATE.md: `phase: 4-planning`, `next: plan phase N+1 <name>` (or `project complete`).
6. Merge per gitflow answer: gitflow → PR/merge feat branch to develop (invoke `superpowers:finishing-a-development-branch` if installed); worktree used → clean up after merge.
7. Compressed completion report to user: shipped / test results / review findings resolved / deviations from spec (also logged in progress notes) / next phase.

## Resume (any session, phase 5)

1. Read STATE.md `next` + current progress file.
2. `git log --oneline -5` — verify progress file matches reality; mismatch → reconcile progress file to git truth FIRST, commit, then continue. Reality broken (no git repo, referenced code missing, branch gone) → STOP, surface findings to user before executing anything.
3. Re-confirm autonomy only if user initiates with different intent; explicit intent in their message IS the confirmation ("hurry, full auto" → AUTO for this run) — pauses/reporting compress, but reviewer, tests, progress+STATE updates never do.

## Deviations

Task can't proceed as planned (spec gap, wrong assumption) → stop task; log in progress notes; small deviation → decide, record ADR one-liner in 30-decisions.md; spec-level change → back to user with compressed options. Never silently diverge from spec.
