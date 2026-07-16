# Orchestration Mode — Design

Date: 2026-07-16
Status: approved
Scope: `skills/project-setup` — new re-settable config axis controlling WHO runs the execution task loop.

## Problem

Orchestration is never asked. Scale silently decides: `medium`/`large` roster auto-includes an orchestrator agent (04 §1), `small` leaves the session orchestrating inline. Users cannot choose (a) main session as orchestrator with no separate agent, or (b) session spawning orchestrator agent(s) — including N parallel orchestrators for distinct workstreams, each managing registered subagents in its own worktree. The choice must also be re-settable anytime via subcommand, like every other STATE.md config field.

## Decision

One compound STATE.md field (pattern precedent: `commit_strategy`):

```
orchestration: session | agent/per-plan | agent/default-agent
```

| Value | Meaning |
|---|---|
| `session` | Main session IS the orchestrator. Dispatches builders/reviewer/gatekeepers directly. No orchestrator agent file. 04 §4 orchestrator must-haves bind to session behavior. |
| `agent/per-plan` | Session spawns ONE orchestrator agent per macro-plan; orchestrator runs the full 06 task loop and reports compressed. Session = thin coordinator. Independent workstreams → N orchestrators in parallel. |
| `agent/default-agent` | `.claude/settings.json {"agent": "orchestrator"}` — every session boots as the orchestrator; session and orchestrator merge. No parallel fan-out (the session is the single orchestrator). |

Rejected alternatives: two separate fields (`orchestration` + routing — more STATE.md surface, no benefit); folding into `autonomy`/`worktrees` (wrong axis — orchestration = who runs the loop; autonomy = how much pausing; worktrees = where).

## Changes by file

### 1. `references/templates.md`

- STATE.md template: new header line
  `orchestration: TBD  # session|agent/per-plan|agent/default-agent — who runs the execution loop; agent/per-plan enables parallel orchestrators`
- CLAUDE.md template `## Agents` section gains mode line:
  `Orchestration: <session | agent/per-plan | agent/default-agent>` (replaces ad-hoc `Default: <orchestrator or n/a>` semantics; `Default:` line kept, reads `orchestrator` only under `agent/default-agent`).

### 2. `references/01-interview.md` — new Q15c (Round D, after Q15b)

- **Q15c. Orchestration mode** — session / agent/per-plan / agent/default-agent → STATE.md `orchestration`.
  - Recommendation: `scale: small` → `session`; medium+ → `agent/per-plan`.
  - `maturity: prototype` → skip silently, default `session` noted (adaptive-skip list in §1 gains Q15c).
  - `scale: small` → skip silently, default `session` (Round D small-scope note "small: only 14, 15" unchanged — orchestrator agent never exists at small).
  - Option copy contextualized per Q11 rule (project's own nouns).
- Outputs section: STATE.md update list gains `orchestration`.

### 3. `references/04-agents.md`

- §1 roster table: orchestrator row conditional — created only when `orchestration: agent/*`. `session` mode at medium/large → roster minus orchestrator; note: "04 §4 Orchestrator must-haves apply to the main session".
- §5 settings.json: default-agent ask fires ONLY for `agent/default-agent` (write after user yes, as today). `agent/per-plan` / `session` → never offered; existing `{"agent":"orchestrator"}` present when mode ≠ default-agent → ask to remove (rule 6 — never silent).

### 4. `references/05-planning.md`

- §2 macro-plan ask gains item 4 — parallelism check: phase breakdown contains independent (no `Depends on` edges between them) workstreams AND `orchestration: agent/per-plan` → offer parallel dispatch, one orchestrator per workstream. Accepted → record workstream→orchestrator map in each progress file header.

### 5. `references/06-execution.md` — new §Dispatch (before Task loop)

- `session` → session runs the task loop directly (current text unchanged).
- `agent/default-agent` → session booted as orchestrator; loop as written.
- `agent/per-plan` → spawn orchestrator agent: plan path + spec §refs + CLAUDE.md rules; orchestrator runs full loop, commits progress per task (rule 7 holds inside its scope); compressed report back to session.
- **Parallel dispatch (2+ orchestrators concurrent):**
  - Worktree per orchestrator MANDATORY — overrides `worktrees: none` for this dispatch. Each orchestrator: own branch, own worktree, own progress file.
  - **STATE.md single-writer rule:** parallel orchestrators update ONLY their own progress file; STATE.md owned by the session — `next:` lists active workstreams; session reconciles STATE.md at fan-in (merge, per gitflow answer). Amends rule 7 for the parallel case only; single-orchestrator and session modes keep same-commit STATE.md updates unchanged.
  - Fan-in: session merges per gitflow, cleans worktrees (existing §merge rule), updates STATE.md + progress README in one commit.
  - Escalation: 3-failure rule (loop step 2) escalates orchestrator→session→user; agent-conflict rule (04 §4) unchanged — orchestrators never resolve cross-workstream conflicts silently.

### 6. `SKILL.md`

- SSOT field list gains `orchestration`.
- Subcommand table, new row:

  | `orchestration` (alias `orchestrator`) | 01 §Q15c + 04 | Show current; re-ask 3 options (default = current); update STATE.md + CLAUDE.md `## Agents`; →`agent/*` = create/update orchestrator agent via 04 §2 update-aware; →`session` = retire-ask orchestrator file (04 §2 retire rule — default keep file, mark deprecated); default-agent↔per-plan = settings.json add/remove ask; applies next macro-plan (rule 6 — never restructures running work) |

## Interactions

- **worktrees policy (Q14b):** single orchestrator / session mode → policy applies as today. Parallel dispatch → mandatory per-orchestrator worktree overrides policy for that dispatch only; policy value itself untouched.
- **autonomy:** orthogonal. Orchestrator agent inherits the phase's autonomy mode via plan/progress header; GUIDED pauses surface through the session in per-plan mode.
- **gates:** unchanged. Small + session → inline checklist (as today); medium+ → gatekeeper agents dispatched by whichever orchestrator (session or agent) runs the loop.
- **scale:** still shapes the roster size and recommendation; no longer hard-decides orchestrator existence.
- **Migration:** existing projects lack the field → treated as unset; `orchestration` subcommand or next 04 visit asks and records. Never auto-derive from roster silently.

## Out of scope

- Cross-orchestrator shared-interface locking (escalation rule covers it).
- Changing subagent tool tables, gate definitions, strategy catalog.
- `cmux`/team-skill integration (separate skills own that).

## Errata (post-review, 2026-07-16)

- §5 dispatch payload: parallel orchestrators' dispatch text must explicitly include the single-writer override (supersedes CLAUDE.md same-commit STATE.md rule for that dispatch) — payload list alone let CLAUDE.md rules reintroduce STATE.md writes.
- Small scale + `agent/*` (via subcommand): orchestrator agent gets added to the small roster; 01's "never exists at small" softened to "not by default".
- SKILL.md rule 7 gains explicit carve-out pointer to 06 §Dispatch.
- Parallel dispatch requires per-workstream phase plans + progress files written before dispatching.
