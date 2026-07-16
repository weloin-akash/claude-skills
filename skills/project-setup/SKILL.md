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

## Subcommands (ARGUMENTS routing — checked BEFORE state detection)

Skill invoked with arguments (`/weloin:project-setup <subcommand> [free-text context]`) → focused flow, not the phase machine. First word routes (tolerant match: `deploy`/`deployment`, `gates`/`tests`, plural/singular); the remainder is user context — absorb it like interview answers (adaptive-skip: whatever it answers, don't re-ask; e.g. `deploy use kubernetes, single node, ghcr images` pre-answers deploy-setup questions). Read STATE.md first; missing → say so, offer full INIT/ALIGN, never fabricate state (`status` just reports "no project state"). Ask only what's still missing (defaults = STATE.md values); all Global Rules hold (update-aware, same-commit STATE.md updates, user gates).

**Every STATE.md config field is re-settable anytime** — a project already set up is never frozen. Each field below has a subcommand that shows the current value, re-asks (default = current), updates STATE.md (+ CLAUDE.md where the field surfaces) in one commit, and applies **going forward** — changes never retroactively restructure existing work (rule 6); when a new value would benefit already-built work, say so and offer it as opt-in, never auto-apply. Unknown subcommand → print this table, take no action.

| Subcommand | Loads | Action |
|---|---|---|
| `deploy` | 05 | `make_workflow` unset → ask scope A/B/C + local infra; invoke `weloin:deploy-setup` with scope (fallback per 05); record |
| `gates` (alias `tests`) | 01 §Q15b + 04 + 06 | Show current `gates`; re-derive candidates, multi-select; update STATE.md; medium+ → create/update gatekeeper agents (04 §2); offer immediate gate run on current diff → gate report. Explicit invocation = opt-in — Q15b's AUTO/GUIDED condition does NOT apply here |
| `autonomy` | — (rule 4) | Show `autonomy_default` + per-phase override; ask new; update STATE.md (+ progress header if mid-phase) |
| `strategy` | 01 §Q11 | Re-ask with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block (templates) |
| `commits` | 01 §Q16b | Re-ask 3 sub-choices (style/detail/signature) with recommendations; update STATE.md `commit_strategy` + CLAUDE.md `## Git`; `signature` defers to stricter global/project rule |
| `worktrees` | 01 §Q14b | Show current `worktrees` policy; re-ask (per-phase/per-feature/ask/none); update STATE.md; takes effect next macro-plan / substantial change |
| `orchestration` (alias `orchestrator`) | 01 §Q15c + 04 | Show current `orchestration`; re-ask 3 options (default = current); update STATE.md + CLAUDE.md `## Agents`; →`agent/*` = create/update orchestrator agent (04 §2 update-aware); →`session` = retire-ask orchestrator file (04 §2 — default keep, mark deprecated); default-agent↔per-plan = settings.json add/remove ask (04 §5); applies next macro-plan |
| `gitflow` (alias `branching`) | 01 §Q14 | Show current `gitflow`; re-ask (gitflow/trunk/custom); update STATE.md + CLAUDE.md `## Git` branches; applies next macro-plan / substantial change |
| `scale` | 02 §1 + rule 2 + 05 | Scan-first, never a bare field flip. (1) **Scan** architecture (`20-architecture.md` if present, else audit repo per 02 §1) + deploy readiness — detect which envs exist: local (`make_workflow`/compose), staging, production (Helm/CI/K8s manifests, `deploy.sh`, env configs). (2) **Report** current `scale`, detected effective-scale signals (services, integrations, NFR presence), and env matrix (local/staging/prod: present / partial / absent). (3) Ask **target scale** (small/medium/large — the destination). (4) **Suggest** gap-closing actions derived from the scan to reach target: added rigor (rule 2 table — interview NFRs, agent roster tier, review gates), NFR/deployment doc, gatekeeper agents (`gates`), deploy scope to stand up missing staging/prod (`deploy` → `weloin:deploy-setup`). Present as a checklist, user picks. (5) Update STATE.md `scale` + record target/gap note in STATE.md `## Notes` if gaps deferred; each accepted gap dispatches its own subcommand. Going-forward, opt-in — existing docs/agents untouched unless user accepts re-derive (rule 6) |
| `repo` (alias `structure`) | 01 §Q10b | Show current `repo_structure`; re-ask (single/monorepo/polyrepo); update STATE.md; layout migration is opt-in (rule 6) — flag impact, never auto-restructure |
| `promote` (alias `maturity`) | 01 §Q4b + 05 | Show current `maturity`; upgrade one level (prototype→mvp→production): read `40-debt.md` (missing at prototype/mvp → warn, offer reconstruction scan); re-ask questions old level skipped (01 pruning rule); hardening plan via 05 §Hardening; user approves; STATE.md `maturity` + CLAUDE.md updated same commit. Downgrade = field edit + STATE.md note, no plan |
| `agents` | 04 | Update-aware roster review (04 §2) |
| `plan` | 05 | Plan next phase now (macro-plan ask included) |
| `status` | — | STATE.md + progress + `git log --oneline -5` → compressed report; zero writes |
| `help` | — | Print this table + one line: no args = full phase machine (INIT/ALIGN/RESUME); zero writes |

**AskUserQuestion unavailable** (any phase): ask the same batch as numbered plain-text questions in one message; same adaptive-skip rules apply.

## SSOT: docs/project/

`STATE.md` header is machine-readable (see templates). Fields: `phase`, `autonomy_default` (AUTO|GUIDED|MANUAL), `strategy`, `gitflow`, `commit_strategy` (`<style>/<detail>/<signature>`), `worktrees`, `orchestration` (session|agent/per-plan|agent/default-agent), `scale` (small|medium|large), `maturity` (prototype|mvp|production), `repo_structure` (single|monorepo|polyrepo), `make_workflow` (none|A|B|C), `gates` (subset of gate ids; `[]` = off), `next`, `updated`. Every phase transition and every completed task updates `STATE.md` (`phase`/`next`/`updated`) **in the same commit** as the work. `CLAUDE.md` stays thin: index → SSOT docs + hard rules only. Never duplicate content between STATE.md, progress files, agent memory — each fact lives in exactly one place; others point to it.

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

2b. **Maturity overrides.** `maturity` in STATE.md = quality intent, orthogonal to `scale`: scale sets ceremony baseline (rule 2), maturity overrides quality bar. Conflict → maturity wins on quality items (tests, gates, security, config/DB discipline), scale wins on ceremony items (doc tree, roster size, interview length).

   | | prototype | mvp | production |
   |---|---|---|---|
   | Tests | smoke only | core paths | full per Q13 |
   | Gates (Q15b) | skipped silently | offered, optional | offered, universals recommended |
   | Arch sections (03) | skip security/risks/NFR | boundaries mandatory (isolation test) | all + observability |
   | Config/secrets | hardcode OK | `.env` | secrets manager from start |
   | DB | drop-and-recreate OK | migrations from first schema | migrations + versioning |
   | Debt ledger `40-debt.md` | required | required | n/a |
   | DoD (06) | runs, demo path works; reviewer at plan-end only | task tests pass + reviewer per loop | full loop + gates |

3. **Hybrid delegation.** Before doing a job inline, check if the listed skill is installed (appears in available-skills). Installed → invoke it. Missing → use the built-in fallback in the reference file. Never duplicate a delegated skill's logic.

   | Job | Delegate to | Fallback in |
   |---|---|---|
   | Client-facing requirements deliverable | `weloin:create-requirements` | 03 |
   | Implementation plan format | `superpowers:writing-plans` | 05 |
   | Plan execution discipline | `superpowers:executing-plans` / `superpowers:subagent-driven-development` | 06 |
   | Local dev + deployment pipeline | `weloin:deploy-setup` | 05 |
   | Worktree creation | `superpowers:using-git-worktrees` | 05 |

4. **Autonomy modes.** `AUTO` = execute all tasks, commit per task, report at end. `GUIDED` = pause at task-group boundaries. `MANUAL` = present each task, user approves. Default set in interview Round D, lives in STATE.md; **each execution-phase kickoff (macro-plan ask, rule 5) re-asks with the default preselected**. An explicit user instruction in the initiating message ("full auto", "check everything with me") counts as the answer — don't re-ask. Reviewer runs regardless of mode.
5. **Ask-at-macro-plan.** Every time a phase/macro plan is created, ask (defaults = last recorded answers): gitflow branch? autonomy mode for this phase? Worktree is driven by the `worktrees` policy (set Q14b), not re-asked when the policy decides it: `per-phase` auto-isolates here; `per-feature`/`ask` defer to execution (06 §Isolation, per substantial change); `none` = current checkout. Record answers in STATE.md.
6. **Respect what exists** (ALIGN path, and always after init): never restructure, rename, rewrite, or reconfigure existing work unless the user explicitly asks. Overlay, don't impose.
7. **Progress is law.** Task done ⇒ progress file checkbox + STATE.md `next:` updated ⇒ same commit. No exceptions, no batching updates "later".
8. **Idempotent.** Re-running the skill never redoes finished work — routing table resumes.
9. **User gates.** Written spec, agent roster, phase breakdown, each plan: user approves before proceeding (in AUTO mode, gates still apply to these artifacts — autonomy covers task execution only).
10. **Git.** Follow STATE.md `commit_strategy` (style/detail/signature, set Q16b, re-ask via `commits`) and user's global/project commit rules. AI attribution in commits: default none; only include if `commit_strategy` signature ≠ none AND no stricter global/project CLAUDE.md rule forbids it.

## Phase Sequence

`0-init` (git init + scaffold) → `1-discovery` (interview → brief, requirements) → `2-architecture` (approaches → spec + ADRs) → `3-agents` (roster + model tags, update-aware) → `4-planning` (phase breakdown → plans + progress scaffold) → `5-execution` (task loops per autonomy mode). Phases 4↔5 cycle per plan until project done.

## Red Flags — STOP if you catch yourself

- Writing code before spec approved
- Creating plans before agents exist
- Marking a task done without updating progress + STATE.md in that commit
- Reading all reference files "for context" — load only the routed one
- Restructuring an adopted project's existing layout
- Skipping the interview because the project "is simple" — run it at `small` scale instead
- Conscious shortcut at prototype/mvp maturity without a DEBT row in the same commit
- Hardening or promoting maturity without consulting `docs/project/40-debt.md`
