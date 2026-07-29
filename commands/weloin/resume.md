---
description: Resume work saved by /weloin:save — read the handoff, give the owner a gist, and confirm before doing anything.
argument-hint: [anything that changed since the save, or what to do differently]
allowed-tools: Bash(git status:*), Bash(git log:*), Bash(git branch:*), Bash(git worktree list:*), Bash(ls:*), Bash(test:*), Bash(find:*), Read, Glob, Grep, TaskList, TaskCreate, TaskUpdate, AskUserQuestion
---

## Context

- Branch: !`git branch --show-current 2>/dev/null || echo "(not a git repo)"`
- Status: !`git status --porcelain 2>/dev/null | head -40`
- Recent commits: !`git log --oneline -15 2>/dev/null`
- Handoff files present: !`ls -1 docs/project/SESSION-HANDOFF.md docs/SESSION-HANDOFF.md .claude/SESSION-HANDOFF.md 2>/dev/null || echo "none at the default paths"`
- Owner's notes for this resume: **$ARGUMENTS**

## Your task

Pick up work that a previous session saved. You have **no memory of that session** — everything you know comes from files. Read first, summarise second, act only after the owner confirms.

### 1. Find and read the handoff

Read the handoff at whichever default path exists (`docs/project/SESSION-HANDOFF.md`, `docs/SESSION-HANDOFF.md`, `.claude/SESSION-HANDOFF.md`). If none is there, search the project for one — a project may keep it elsewhere by convention.

Then read what it points at: the plan, the progress board, the resume header (`docs/project/STATE.md` or equivalent), the spec. **The handoff is a pointer; the linked documents are the truth.** If they disagree, trust the linked documents and the git log over the handoff, and say so.

**If there is no handoff at all:** say that plainly. Do not invent one. Offer to reconstruct a picture from the progress board, the resume header and `git log`, and ask whether to proceed on that basis.

### 2. Verify the handoff is still true

A handoff is a snapshot and the world moved on. Before summarising, check:

- **Does the git log match?** Commits landed after the save mean someone else worked, or the owner did. Say what changed.
- **Is the branch the one the handoff expects?**
- **Do the uncommitted files it listed still exist, and are they still uncommitted?**
- **Does the "next action" still make sense** — is the file still there, is the task still open, did someone already do it?

Anything the handoff claims that you cannot verify, or that is now wrong, goes in the gist as a correction. **A stale handoff quietly followed is worse than no handoff.**

### 3. Give the owner a gist — short

Lead with what they need to re-enter the work, not with process:

- **Where we were** — one or two lines.
- **What was just finished**, and whether it is merged and verified.
- **The exact next action** the previous session left.
- **Decisions already made** that you will not re-open — list them tersely; this is how the owner knows you actually read it.
- **Anything that changed since the save**, or that you could not verify.
- **Open questions** the previous session left for them.

Keep it to something they can read in fifteen seconds. Detail lives in the files; do not paste the handoff back at them.

### 4. Take the owner's notes into account

If `$ARGUMENTS` is non-empty, it outranks the handoff — it is newer. It may cancel the planned next step, redirect the work, or add information ("the API partner is back", "skip the migration, we're dropping that table"). Reflect it in the gist: say plainly which part of the saved plan it overrides.

### 5. Confirm before acting

**Ask before doing any work.** Use AskUserQuestion with the resume options that actually fit — typically: continue with the saved next action · do something else first · just re-explain the state and wait. Include an option for anything the owner's notes imply.

Do not start editing, running, or dispatching anything until they answer. The whole point of a resume gate is that the owner gets to redirect before effort is spent.

### 6. Once they confirm

- Rebuild any task list the work needs, so progress is trackable again.
- Restore the environment the handoff describes *only if needed for the next action* — do not rebuild containers or re-seed data speculatively.
- Re-read the specific plan or spec section you are about to execute. Do not work from the handoff's summary of it.
- Then start, at the exact point agreed.
