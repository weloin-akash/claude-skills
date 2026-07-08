---
name: weloin:project-setup
description: Use when starting a new software project, initializing a project directory, aligning an existing codebase to structured agent-driven development, or resuming a project that has docs/project/STATE.md. Triggers - "set up project", "initialize project", "start new project", "align this project", "adopt this project", "continue the project", or any request for project requirements/architecture/plan setup.
---

# Project Setup — Phase-Machine for Agent-Driven Development

Initializes or aligns a project and maintains a single source of truth (`docs/project/`) so ANY future session can resume exactly where the last one stopped. The skill does not build the whole project itself — it builds the state, docs, agents, and plans that let development proceed phase by phase.

**This file is a router.** Detect state → load ONE reference file → follow it. Do not read all references upfront.

## Routing

Run: `cat docs/project/STATE.md 2>/dev/null; ls -a; git status 2>/dev/null | head -3`

| State detected | Route |
|---|---|
| No `STATE.md`, empty/near-empty dir | INIT → read `references/01-interview.md` |
| No `STATE.md`, existing code/git history | ALIGN → read `references/02-align.md` |
| `STATE.md` exists | RESUME → read reference file for the recorded `phase`; execute its `next:` action |
| `STATE.md` exists, user asks to re-initialize | Confirm destructive intent, then INIT |

Phase → reference map: `0-init`/`1-discovery`→01 (ALIGN path: →02; it writes `2-architecture` directly on completion), `2-architecture`→03, `3-agents`→04, `4-planning`→05, `5-execution`→06. All file/doc skeletons live in `references/templates.md` — load it whenever a phase creates files. "Load ONE reference" = one per phase; a phase transition legitimately loads the next routed file. Never pre-read others.

**AskUserQuestion unavailable** (any phase): ask the same batch as numbered plain-text questions in one message; same adaptive-skip rules apply.

## SSOT: docs/project/

`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `worktrees`, `scale` (small|medium|large), `gates` (subset of gate ids; `[]` = off), `next`, `updated`. Every phase transition and every completed task updates `STATE.md` (`phase`/`next`/`updated`) **in the same commit** as the work. `CLAUDE.md` stays thin: index → SSOT docs + hard rules only. Never duplicate content between STATE.md, progress files, agent memory — each fact lives in exactly one place; others point to it.

## Global Rules (apply in every phase)

1. **Doc style — detailed-compressed.** Every generated doc: dense bullets/tables, telegraphic sentences, zero filler, zero meaning loss. No prose padding. This rule is inherited by all agents this skill creates.
2. **Scale-adaptive rigor.** `scale` in STATE.md controls ceremony, never fundamentals (SSOT, boundaries, tests, reusability always hold):

   | | small | medium | large |
   |---|---|---|---|
   | Interview | ~8 Q | ~15 Q | ~20 Q + NFRs (perf, SLO, compliance) |
   | Docs | brief+requirements merged; ADRs inline | full tree | full tree + NFR + deployment doc |
   | Agents | builder + reviewer | 3–5 roster | full roster + security + devops |
   | Review gates | reviewer per phase | per plan | per plan + cross-agent conformance |
   | Quality gates (if `gates` opted, Q15b) | orchestrator inline checklist | gatekeeper agents | gatekeeper agents |

3. **Hybrid delegation.** Before doing a job inline, check if the listed skill is installed (appears in available-skills). Installed → invoke it. Missing → use the built-in fallback in the reference file. Never duplicate a delegated skill's logic.

   | Job | Delegate to | Fallback in |
   |---|---|---|
   | Client-facing requirements deliverable | `weloin:create-requirements` | 03 |
   | Implementation plan format | `superpowers:writing-plans` | 05 |
   | Plan execution discipline | `superpowers:executing-plans` / `superpowers:subagent-driven-development` | 06 |
   | Local dev + deployment pipeline | `weloin:deploy-setup` | 05 |
   | Worktree creation | `superpowers:using-git-worktrees` | 05 |

4. **Autonomy modes.** `AUTO` = execute all tasks, commit per task, report at end. `GUIDED` = pause at task-group boundaries. `MANUAL` = present each task, user approves. Default set in interview Round D, lives in STATE.md; **each execution-phase kickoff (macro-plan ask, rule 5) re-asks with the default preselected**. An explicit user instruction in the initiating message ("full auto", "check everything with me") counts as the answer — don't re-ask. Reviewer runs regardless of mode.
5. **Ask-at-macro-plan.** Every time a phase/macro plan is created, ask (defaults = last recorded answers): worktree isolation? gitflow branch? autonomy mode for this phase? Record answers in STATE.md.
6. **Respect what exists** (ALIGN path, and always after init): never restructure, rename, rewrite, or reconfigure existing work unless the user explicitly asks. Overlay, don't impose.
7. **Progress is law.** Task done ⇒ progress file checkbox + STATE.md `next:` updated ⇒ same commit. No exceptions, no batching updates "later".
8. **Idempotent.** Re-running the skill never redoes finished work — routing table resumes.
9. **User gates.** Written spec, agent roster, phase breakdown, each plan: user approves before proceeding (in AUTO mode, gates still apply to these artifacts — autonomy covers task execution only).
10. **Git.** Follow user's global/project commit rules. AI attribution in commits: default none; only include if project CLAUDE.md explicitly says so.

## Phase Sequence

`0-init` (git init + scaffold) → `1-discovery` (interview → brief, requirements) → `2-architecture` (approaches → spec + ADRs) → `3-agents` (roster + model tags, update-aware) → `4-planning` (phase breakdown → plans + progress scaffold) → `5-execution` (task loops per autonomy mode). Phases 4↔5 cycle per plan until project done.

## Red Flags — STOP if you catch yourself

- Writing code before spec approved
- Creating plans before agents exist
- Marking a task done without updating progress + STATE.md in that commit
- Reading all reference files "for context" — load only the routed one
- Restructuring an adopted project's existing layout
- Skipping the interview because the project "is simple" — run it at `small` scale instead
