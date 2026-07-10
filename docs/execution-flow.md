# project-setup — Per-Feature / Per-Fix Execution Flow

How a single substantial change runs after the project is set up. 🧑 = human decides · 🤖 = Claude acts. Config fields (`worktrees`, `autonomy`, `gitflow`, `commit_strategy`) steer the branches automatically.

```mermaid
flowchart TD
    Start([🧑 Request: feature or fix]) --> Trivial{🤖 Substantial change?}
    Trivial -->|no, one-liner| CurCheckout[🤖 Work on current checkout]
    Trivial -->|yes| Policy{🤖 worktrees policy?}

    Policy -->|per-feature| MkWT[🤖 Auto-create worktree + branch]
    Policy -->|per-phase| Resolved[🤖 Already isolated at macro-plan]
    Policy -->|none| CurCheckout
    Policy -->|ask| AskIso[🧑 Choose: current branch / new branch / worktree]
    AskIso --> MkWT

    MkWT --> Plan
    Resolved --> Plan
    CurCheckout --> Plan

    Plan[🤖 Write plan: goal, files, tasks, DoD] --> MacroAsk[🧑 Macro-plan ask: gitflow branch? autonomy mode?]
    MacroAsk --> Gate1{🧑 Approve plan?}
    Gate1 -->|revise| Plan
    Gate1 -->|approve| Loop

    subgraph Loop [Task loop — per task]
        direction TB
        Dispatch[🤖 Dispatch builder subagent: task + spec + rules] --> Verify[🤖 Verify vs maturity DoD]
        Verify --> Review[🤖 Reviewer subagent: shared-interface / complex]
        Review --> Gates{🤖 Quality gates at group boundary?}
        Gates -->|FAIL| Fix[🤖 Fix loop] --> Dispatch
        Gates -->|PASS / CONCERNS| Commit[🤖 Commit per commit_strategy + progress + STATE.md same commit]
    end

    Commit --> Mode{🧑🤖 Autonomy mode?}
    Mode -->|AUTO| More
    Mode -->|GUIDED, group done| PauseG[🧑 Review compressed report → go]
    Mode -->|MANUAL| PauseM[🧑 Approve next task]
    PauseG --> More
    PauseM --> More

    More{🤖 More tasks?} -->|yes| Dispatch
    More -->|no| Merge[🤖 Merge per gitflow + clean up worktree]
    Merge --> Done([🤖 Update STATE.md next: → resume-ready])
```

## Reading the flow

- **Human gates (🧑):** isolation choice when policy = `ask`, the macro-plan ask, plan approval, and the autonomy pause points (GUIDED at group boundaries, MANUAL per task). AUTO removes the per-task pauses but plan approval and artifact gates still hold.
- **Claude acts (🤖):** everything else — isolation setup, planning, the builder/reviewer/gatekeeper subagents, commits, merge, and the STATE.md update that makes the next session resume-ready.
- **Config steers, doesn't re-ask:** `worktrees` picks the isolation branch, `gitflow` the branch model, `commit_strategy` the commit shape, `autonomy` the pause cadence — all set once, applied every change.
- **Invariant:** every task's progress checkbox + `STATE.md next:` land in the *same commit* as the work — that's the resume guarantee.
