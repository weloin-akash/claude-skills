# @weloin/claude-skills

Weloin's [Claude Code](https://claude.com/claude-code) skills **and slash commands** library — install with one command, updates via symlink. macOS · Linux · Windows.

---

## `weloin:project-setup`

A phase-machine for agent-driven development. Instead of ad-hoc prompting, it runs your project through structured phases — from first interview to shipped code — with every decision recorded and resumable.

**What you get**

- An interview that produces your brief, requirements, architecture, and ADRs.
- A custom agent roster with model tags matched to each role.
- Phased plans executed at your chosen AUTO / GUIDED / MANUAL autonomy.
- A `docs/project/STATE.md` single source of truth — close a session mid-phase, resume days later without re-explaining anything.
- Works on fresh directories or aligns an existing codebase to the same structure.

**Why it holds up**

- **Durable state.** Agent sessions lose context; this makes project state survive across them.
- **Maturity axis** (prototype → mvp → production) sets the quality bar independent of scale — prototypes skip ceremony but log every shortcut to a debt ledger; `promote` later upgrades by re-asking skipped questions and building a hardening plan from that ledger.
- **Evidence-based gates.** Opt-in quality gates mean work isn't "done" until it passes review with proof — not when the agent says so.
- **Strategy that fits.** A 15-strategy catalog with a project-kind recommendation matrix, not one-size-fits-all.
- **Configurable Git workflow.** Commit strategy (style · detail · AI-signature) and worktree policy (per-phase / per-feature / ask / none) set once, applied automatically.
- **Never frozen.** Every config field has a subcommand to re-set it later; changes apply going forward, never restructuring existing work.

Full subcommand reference & opt-in features → **[docs/project-setup.md](./docs/project-setup.md)**.

### Quick install

```bash
npm install -g @weloin/claude-skills   # then:
weloin-skills                          # pick skills interactively
```

Full install, update, and CLI reference → **[docs/installation.md](./docs/installation.md)**.

### Slash commands

Skills are opt-in one by one. **Slash commands are not** — a namespace is all-or-nothing, so every
install and every `sync` links `commands/<namespace>/` into `~/.claude/commands/<namespace>/`, and
`uninstall --all` removes it. The directory name *is* the namespace: `commands/weloin/save.md`
becomes `/weloin:save`.

| Command | What it does |
|---|---|
| `/weloin:save [notes]` | Writes a resumable handoff into the **current project** — where the work stands, the exact next action, decisions already made, what was deliberately not done, what is in flight, and the traps. Commits that file only, never your uncommitted work. |
| `/weloin:resume [notes]` | Reads the handoff, **verifies it against git** (commits landed since the save, branch, files that moved), gives a fifteen-second gist, and asks before touching anything. |

The pair assumes the resume happens in a **completely different session** — new context, possibly a
different machine. Anything not written to the file is lost, so `/weloin:save` records the reasoning
behind decisions, not just their outcome. Both take free-text notes that outrank the saved plan:
`/weloin:save we're abandoning the caching branch, pick up the migration instead`.

### What execution looks like (per feature / fix)

Once set up, every substantial change runs the same loop — 🧑 = you decide, 🤖 = Claude acts. Config (`worktrees`, `autonomy`, `gitflow`, `commit_strategy`) steers the branches without re-asking.

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
        Dispatch[🤖 Builder subagent: task + spec + rules] --> Verify[🤖 Verify vs maturity DoD]
        Verify --> Review[🤖 Reviewer subagent]
        Review --> Gates{🤖 Quality gates at group boundary?}
        Gates -->|FAIL| Fix[🤖 Fix loop] --> Dispatch
        Gates -->|PASS / CONCERNS| Commit[🤖 Commit per commit_strategy + progress + STATE.md, same commit]
    end

    Commit --> Mode{🧑🤖 Autonomy mode?}
    Mode -->|AUTO| More
    Mode -->|GUIDED, group done| PauseG[🧑 Review report → go]
    Mode -->|MANUAL| PauseM[🧑 Approve next task]
    PauseG --> More
    PauseM --> More

    More{🤖 More tasks?} -->|yes| Dispatch
    More -->|no| Merge[🤖 Merge per gitflow + clean up worktree]
    Merge --> Done([🤖 Update STATE.md next: → resume-ready])
```

Deeper walk-through → **[docs/execution-flow.md](./docs/execution-flow.md)**.

---

## Docs

- **[Installation & CLI](./docs/installation.md)** — install, update, uninstall, command/flag reference
- **[project-setup reference](./docs/project-setup.md)** — subcommands, opt-in features
- **[Execution flow](./docs/execution-flow.md)** — per-feature loop, human ↔ Claude gates
- **[Development](./docs/development.md)** — how installs work, adding a skill, troubleshooting
- **[Changelogs](./changelogs/)**

## License

MIT © Weloin
