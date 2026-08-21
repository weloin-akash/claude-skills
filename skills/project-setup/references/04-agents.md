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

Builder split rule: 1 per tech boundary (frontend/backend/service-per-language); same-language monorepo → split by domain, max 2. Boundary = language × platform × toolchain (rule 13) — a cross-platform client (Android/iOS/desktop shell) is one builder with per-platform glue in scope UNTIL a platform grows its own build+native surface, then it's a new boundary.

**Roster re-derivation (rule 13 trigger — plan completion, phase transition, ALIGN):** the boundary-drift check found a new/dead boundary → re-enter THIS phase's §2 update-aware flow scoped to the delta: propose build/edit/retire + the CLAUDE.md `## Agents`, contract-doc, and gate-command updates the changed stack needs; user approves; apply + commit before the next plan dispatches. Never patch an agent's scope silently mid-wave.

**Model tags** (user adjusts): orchestrator + architecturally-complex builders → `opus`; mechanical builders, tester, reviewer, security → `sonnet`; `inherit` acceptable default when user has no preference.

Present roster as table: name / role / scope (dirs) / tools / model. AskUserQuestion: approve / adjust models / add / remove.

## 2. Update-aware creation

`.claude/agents/*.md` already exist →
1. Read existing frontmatter + scope of each.
2. Diff vs desired roster → table: keep-as-is / update (what changes) / add / retire.
3. User approves diff. Update = edit in place preserving user's manual customizations (anything not conflicting with new scope). Retire = ask before delete; default: leave file, note deprecated in its description.
Never blind-overwrite an existing agent file.

**This flow gates EVERY agent-file change, from any trigger** — phase-3 roster design, `agents` subcommand, boundary-drift delta (rule 13), initial alignment (02 §5), or an incidental "the agent def needs a tweak" mid-execution. Rule 9: user approval BEFORE the write, in every autonomy mode — AUTO never waives it. Normal code/doc edits are untouched by this gate.

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

**Style skills (default ON — part of the roster approval, user may decline):** two style disciplines ship with this skill and get installed as project skills in every project:
- `caveman` — terse prose for reports/reviews/plans/progress (all substance kept: file:line refs, real numbers, verbatim errors; NORMAL prose in code/comments/commits/security warnings).
- `ponytail` — laziest solution that works (reuse ladder, no unrequested abstractions, deletion over addition; `ponytail:` comment marks a deliberate corner-cut naming ceiling + upgrade path, + `40-debt.md` row when it's a real shortcut; never simplify trust-boundary validation, error handling, security, spec requirements, tests).

Install — two tiers, pick the highest available:
1. **Plugins (preferred — hooks make the modes always-on, no invocation needed):** `caveman` + `ponytail` plugins already active (their `SessionStart` hooks announce `CAVEMAN MODE ACTIVE` / `PONYTAIL MODE ACTIVE`) → nothing to install. Not active → they ship with this skill's repo (`plugins/caveman`, `plugins/ponytail` + root `.claude-plugin/marketplace.json`): offer `claude plugin marketplace add <repo>` + install both; user declines plugin install → tier 2.
2. **Project-skill copies (fallback, always works):** copy `assets/style-skills/caveman.md` → `.claude/skills/caveman/SKILL.md` and `assets/style-skills/ponytail.md` → `.claude/skills/ponytail/SKILL.md`.
Either tier: add the CLAUDE.md `## Style` block (templates.md) + bake each discipline's compressed rules INLINE into every generated agent def (zero invocation cost per dispatch, and holds even where hooks don't fire — subagents). Skills/plugins stay the canonical long form — change both together; never re-state the rules in dispatch prompts.

**Utility agents — cavecrew (installed with the style skills, same approval):** copy `assets/agents/cavecrew-{investigator,builder,reviewer}.md` → `.claude/agents/`. Compressed-output delegation trio — main context eats ~60% fewer tokens than vanilla dispatches. DECLARED USE (bake into orchestrator def + CLAUDE.md `## Agents`):
- `cavecrew-investigator` — read-only code locator ("where is X defined", "what calls Y", directory maps) → file:line table. Use BEFORE dispatching a builder when the work-site is unknown; never for fix suggestions.
- `cavecrew-builder` — surgical 1–2 file edits (typos, single-function rewrites, mechanical renames). Hard-refuses 3+ file scope — that refusal is the router back to a full builder. Not for new features or cross-file refactors.
- `cavecrew-reviewer` — diff/branch/file review, one severity-tagged line per finding. Use for small-diff reviews between plan-boundary reviews; the roster reviewer still owns plan-boundary conformance (§4).
Existing agent names collide → update-aware diff (§2), never blind-overwrite.

## 4. Role-specific must-haves

**Orchestrator:** lists all agents it delegates to; retry rule (3 failures on a task → escalate to user); session start = read STATE.md + progress + git log; **alignment enforcement**: verify delegated work conforms to `strategy` and doesn't break other agents' assumptions; agent-conflict (scope overlap, contradictory conventions, incompatible shared interfaces) → escalate to user, never resolve silently; at plan boundaries dispatch reviewer for cross-agent conformance; **contract-first sequencing** (rule 12): a shared-contract change lands alone — own commit, gated — before consumer work fans out; **gate evidence**: never accept an agent-reported "gates green" without the captured output file, and never where the gate did not cover the boundary that changed — a gate that could not run (missing toolchain) is a FAIL, not a skip.

**Builders:** read CLAUDE.md + STATE.md before work; **work against the layer contract, never the implementation below it** — contract gap → fix the contract in the same change, don't reach through (rule 12); never add a suppression to silence a warning or purity/contract violation; report format includes "shared interfaces touched" (APIs, types, schemas) + **contract deltas** so orchestrator verifies alignment, and at prototype/mvp maturity "shortcuts taken" (debt candidates — orchestrator records rows in `docs/project/40-debt.md`, 06 task loop); follow `strategy`, doc-style, and code-shape (rule 11) rules.

**Reviewer:** checklist derived from spec; cross-agent conformance at plan boundaries (contracts match, conventions uniform, no scope drift); `medium+` & `mvp+`: fixed boundary checklist — layer purity (no feature code reaching below its contract; no platform checks where a capability flag belongs), contract docs updated with the deltas the wave shipped, no new suppressions — runs at EVERY plan boundary, not only when asked; findings → orchestrator with file:line.

**Security (if opted in):** report-only — never fixes code. Categories scoped to actual stack (deps audit if package manager; auth review if authn; tenant isolation CRITICAL if multi-tenant; API input validation if APIs; container scan if Docker; SAST always; client-side if frontend). Reports → `docs/project/security/audit-YYYY-MM-DD.md`, findings = severity/location/impact/evidence/remediation/owning-agent. Profiles: quick / standard / deep.

**Gatekeeper (gated dev, medium+):** one agent per selected gate; verifies only, never fixes. Runs its gate's checks (per gate definition in 01 Q15b) against the task-group diff; writes its row + evidence into `docs/project/gates/<task-group>-gate.md` (templates.md); verdict PASS / DONE_WITH_CONCERNS / FAIL — evidence mandatory (test counts, diffs, bench numbers), bare verdicts invalid. Path-triggered where scoping is clear (e.g. contract dirs → `contract-compat-gate`); otherwise orchestrator dispatches at task-group boundary, after reviewer, before group counts done. `strategy: integration-test-first` → `regression-gate` also proves integration-test immutability (diff vs contract commit; weakened assertion = FAIL). Model tag: `sonnet`.

## 5. CLAUDE.md + settings

- Create/merge thin `CLAUDE.md` per templates.md (index → SSOT, strategy, agent workflow, alignment rules, git rules).
- `.claude/settings.json` default-agent (`{"agent": "orchestrator"}`): ONLY when `orchestration: agent/default-agent` — ASK first (side effect on every session), write only on yes. Other modes → never offer; file already sets `"agent": "orchestrator"` while mode ≠ default-agent → ask to remove (rule 6 — never silent).

## 6. Transition

STATE.md: `phase: 4-planning`, `next: break spec into phase plans`. Commit: `chore: agent roster and project conventions`.
