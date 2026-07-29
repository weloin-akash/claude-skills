---
description: Save a resumable handoff of this session into the project, so a completely different session can pick the work up.
argument-hint: [anything extra to record — focus, warnings, what to do next]
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git branch:*), Bash(git diff:*), Bash(git worktree list:*), Bash(git add:*), Bash(git commit:*), Bash(ls:*), Bash(test:*), Read, Write, Edit, Glob, Grep, TaskList, TaskGet
---

## Context

- Branch: !`git branch --show-current 2>/dev/null || echo "(not a git repo)"`
- Status: !`git status --porcelain 2>/dev/null | head -40`
- Recent commits: !`git log --oneline -15 2>/dev/null`
- Worktrees: !`git worktree list 2>/dev/null`
- Owner's extra instructions for this save: **$ARGUMENTS**

## Your task

Write a handoff document into **this project** that lets a different session — new context, no memory of this conversation, possibly a different machine — resume the work without asking the owner to re-explain anything.

### The rule that governs everything below

**Assume the reader knows nothing.** They cannot see this conversation. Every decision made here, every dead end ruled out, every "we agreed X" is lost unless you write it down. A handoff that says "continue the refactor" is a failed handoff. One that says "continue at step 4 of `plans/foo.md`; steps 1–3 are merged as `abc1234`; the owner rejected the adapter approach because it duplicated validation" is a good one.

### 1. Find where this project keeps its state

Look, in order, for a resume header or progress board this project already maintains — `docs/project/STATE.md`, `docs/progress/`, `PROGRESS.md`, `STATUS.md`, `CLAUDE.md`, `docs/superpowers/plans/`, a task tracker. **If the project has one, the handoff points at it and does not duplicate it.** Duplicated state goes stale and then lies.

If the project has a documented convention for where session/progress state lives, follow that convention instead of the default path below.

### 2. Write the handoff

Default path: **`docs/project/SESSION-HANDOFF.md`**. If `docs/project/` does not exist, use `docs/SESSION-HANDOFF.md`; if there is no `docs/`, use `.claude/SESSION-HANDOFF.md`. Create the directory if needed.

If a handoff already exists, **replace it** — this is a snapshot of now, not a log. Anything from the old one still true and still load-bearing gets carried forward.

Structure:

```markdown
# Session handoff — <YYYY-MM-DD HH:MM local>

**Resume with:** `/weloin:resume`

## One-line state
<What is happening, in a sentence a stranger understands.>

## Where the truth lives
<Links to the plan / board / spec / STATE.md that own the detail. The handoff is a pointer, not a copy.>

## What was just done
<The last few units of work, with commit shas. Merged? Pushed? Verified how?>

## Exactly where to pick up
<The single next action, as specifically as you can write it: file, task number, command.
If it is "waiting on the owner", say what the question is.>

## Decisions made this session (do not re-litigate)
<Each decision + the reason. Especially anything the owner chose between options —
a fresh session will otherwise re-ask and look like it wasn't listening.>

## Deliberately not done
<Things ruled out, deferred, or accepted as limitations, with the reason.
This is what stops the next session "helpfully" building something that was rejected.>

## In flight / unfinished
<Uncommitted files, open branches, worktrees, background jobs, half-written code.
Name paths. If the tree is clean, say "tree clean" — that is information too.>

## Environment state
<Anything running that matters: dev servers, containers, seeded data, test accounts +
how to log in, ports. What must be restarted or re-seeded before the work makes sense.>

## Traps
<Anything that wasted time this session and would waste it again: flaky steps,
misleading errors, a rebuild that is required, a port that is not what you'd guess.>

## Open questions for the owner
<Unresolved things. Empty is fine — say "none".>

## Owner's notes for this save
<Verbatim from $ARGUMENTS, if any. If they gave instructions, they outrank your summary —
put them near the top of your reading order when resuming.>
```

Fill every section from what actually happened in this session plus the git context above. Omit a section only if it is genuinely empty, and say so rather than deleting it silently.

### 3. Handle the owner's extra instructions

If `$ARGUMENTS` is non-empty, treat it as the highest-signal input to this save. It may:
- redirect focus ("save, but we're abandoning the caching branch")
- add context only the owner knows ("pausing because the API partner is down until Tuesday")
- instruct what the next session should do first

Record it verbatim **and** reflect it in the other sections — if they say the branch is abandoned, "Exactly where to pick up" must not tell the next session to continue it.

### 4. Update the project's own state file

If the project maintains a resume header (e.g. `docs/project/STATE.md`), update its "next" pointer so it agrees with the handoff. Two files disagreeing about what comes next is worse than one.

### 5. Commit — the handoff only

```bash
git add <handoff path> [<state file if updated>]
git commit -m "chore(session): save handoff"
```

**Never** `git add -A` or `git add .` — uncommitted work in the tree belongs to the owner, not to this command. If the tree has uncommitted changes, list them in "In flight" and leave them exactly as they are.

If this is not a git repository, write the file anyway and say it is not committed.

### 6. Report back, briefly

Tell the owner:
- where the handoff was written
- the one-line state you recorded
- the single next action a fresh session will be told to take
- anything you could **not** capture and they should keep in their head

Do not print the whole handoff back at them — they can read the file.
