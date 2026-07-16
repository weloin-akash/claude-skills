# Phase 3: Agent Roster (create or update)

## 1. Design roster from architecture

Scale-driven baseline:

| scale | Roster |
|---|---|
| small | builder (implements+tests), reviewer |
| medium | orchestrator, 1 builder per boundary (max 3), tester, reviewer |
| large | orchestrator, builders per boundary, tester, reviewer, security (report-only), devops |

Orchestrator row conditional on STATE.md `orchestration` (01 §Q15c): created only when `agent/*`. `agent/*` at small scale (set via subcommand) → add orchestrator to the small roster. `session` → roster minus orchestrator — the main session performs the orchestrator role (§4 must-haves bind to session behavior). Field absent (pre-field project) → ask Q15c now, record in STATE.md before deriving the roster — never derive silently from the existing roster.

Gated dev (STATE.md `gates` non-empty): `small` adds NO agents — orchestrator runs the gate checklist inline (06). `medium`/`large` add one read-only **gatekeeper** agent per selected gate (`.claude/agents/<gate>-gate.md`, e.g. `regression-gate`); builders-vs-gatekeepers split — builders never grade own homework.

Builder split rule: 1 per tech boundary (frontend/backend/service-per-language); same-language monorepo → split by domain, max 2.

**Model tags** (user adjusts): orchestrator + architecturally-complex builders → `opus`; mechanical builders, tester, reviewer, security → `sonnet`; `inherit` acceptable default when user has no preference.

Present roster as table: name / role / scope (dirs) / tools / model. AskUserQuestion: approve / adjust models / add / remove.

## 2. Update-aware creation

`.claude/agents/*.md` already exist →
1. Read existing frontmatter + scope of each.
2. Diff vs desired roster → table: keep-as-is / update (what changes) / add / retire.
3. User approves diff. Update = edit in place preserving user's manual customizations (anything not conflicting with new scope). Retire = ask before delete; default: leave file, note deprecated in its description.
Never blind-overwrite an existing agent file.

## 3. Agent file format

`.claude/agents/<name>.md` (full skeleton in templates.md):

```markdown
---
name: <kebab-name>
description: <when to use — specific, third person>
tools: <list per role table below>
model: opus | sonnet | inherit
memory: project
---
[Role, project name, scope dirs, spec refs, conventions, reporting format]
```

| Role | Tools |
|---|---|
| orchestrator | Read, Edit, Write, Glob, Grep, Bash, Agent |
| builder | Read, Edit, Write, Bash, Glob, Grep (NO Agent) |
| tester | Read, Edit, Write, Bash, Glob, Grep |
| reviewer | Read, Glob, Grep, Bash (read-only cmds only — state in instructions; NO Edit/Write) |
| security | Read, Bash, Glob, Grep, Write (reports only) |
| devops | Read, Edit, Write, Bash, Glob, Grep |
| gatekeeper | Read, Glob, Grep, Bash (test/bench runs only — state in instructions), Write (gate reports only; NO source edits) |

Memory: native `memory: project` frontmatter — no manual MEMORY.md seeding. Memory holds patterns/decisions/context only; progress lives in `docs/project/progress/` (pointer, never duplicate).

## 4. Role-specific must-haves

**Orchestrator:** lists all agents it delegates to; retry rule (3 failures on a task → escalate to user); session start = read STATE.md + progress + git log; **alignment enforcement**: verify delegated work conforms to `strategy` and doesn't break other agents' assumptions; agent-conflict (scope overlap, contradictory conventions, incompatible shared interfaces) → escalate to user, never resolve silently; at plan boundaries dispatch reviewer for cross-agent conformance.

**Builders:** read CLAUDE.md + STATE.md before work; report format includes "shared interfaces touched" (APIs, types, schemas) so orchestrator verifies alignment, and at prototype/mvp maturity "shortcuts taken" (debt candidates — orchestrator records rows in `docs/project/40-debt.md`, 06 task loop); follow `strategy` and doc-style rules.

**Reviewer:** checklist derived from spec; cross-agent conformance at plan boundaries (contracts match, conventions uniform, no scope drift); findings → orchestrator with file:line.

**Security (if opted in):** report-only — never fixes code. Categories scoped to actual stack (deps audit if package manager; auth review if authn; tenant isolation CRITICAL if multi-tenant; API input validation if APIs; container scan if Docker; SAST always; client-side if frontend). Reports → `docs/project/security/audit-YYYY-MM-DD.md`, findings = severity/location/impact/evidence/remediation/owning-agent. Profiles: quick / standard / deep.

**Gatekeeper (gated dev, medium+):** one agent per selected gate; verifies only, never fixes. Runs its gate's checks (per gate definition in 01 Q15b) against the task-group diff; writes its row + evidence into `docs/project/gates/<task-group>-gate.md` (templates.md); verdict PASS / DONE_WITH_CONCERNS / FAIL — evidence mandatory (test counts, diffs, bench numbers), bare verdicts invalid. Path-triggered where scoping is clear (e.g. contract dirs → `contract-compat-gate`); otherwise orchestrator dispatches at task-group boundary, after reviewer, before group counts done. `strategy: integration-test-first` → `regression-gate` also proves integration-test immutability (diff vs contract commit; weakened assertion = FAIL). Model tag: `sonnet`.

## 5. CLAUDE.md + settings

- Create/merge thin `CLAUDE.md` per templates.md (index → SSOT, strategy, agent workflow, alignment rules, git rules).
- `.claude/settings.json` default-agent (`{"agent": "orchestrator"}`): ONLY when `orchestration: agent/default-agent` — ASK first (side effect on every session), write only on yes. Other modes → never offer; file already sets `"agent": "orchestrator"` while mode ≠ default-agent → ask to remove (rule 6 — never silent).

## 6. Transition

STATE.md: `phase: 4-planning`, `next: break spec into phase plans`. Commit: `chore: agent roster and project conventions`.
