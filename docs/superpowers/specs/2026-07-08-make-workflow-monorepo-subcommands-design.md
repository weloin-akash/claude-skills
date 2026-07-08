# Make Workflow, Repo Structure, and Subcommand Router for project-setup

**Date:** 2026-07-08
**Status:** Approved design, pending implementation plan
**Scope:** `skills/project-setup/` (SKILL.md + references 01, 05, templates)
**Builds on:** `2026-07-08-gated-development-design.md` (gates, integration-test-first — already shipped)

## Problem

Three gaps in the project-setup skill:

1. The interview asks only "local infra: compose/native/devcontainers" — it never captures how the
   user actually drives local + deployed environments. The user's standard is a Make-based
   canonical interface (`make <env|surface> <action> [args]` — `make local up`, `make staging
   deploy`, `make app run ios`, `make local nuke`, `make setup`), which `weloin:deploy-setup`
   already implements. project-setup should ask early, record the convention, and delegate the
   build to deploy-setup at the right time — never duplicate its logic.
2. Repo structure (monorepo vs single-app repo) is only implied by one Q10 architecture option;
   it deserves its own recorded choice since it drives directory layout, builder scoping, and
   plan paths.
3. The skill is all-or-nothing: no way to run one focused part. `/weloin:project-setup deploy`
   should do only the deploy/make-workflow part, `gates` only gating, `autonomy` only autonomy —
   via the skill's ARGUMENTS, one router table, no extra top-level skills.

## Feature 1 — Local + deployed workflow question (Q17 rework, Round D)

Replace Q17 in `references/01-interview.md`:

- Ask: Make-based workflow wanted? Canonical convention preset:
  `make <env|surface> <action> [args]` (examples: `make local up`, `make local nuke`,
  `make staging deploy`, `make app run ios`, `make setup`).
- Scope choice mirrors deploy-setup's own scopes: **A** local-only (Makefile + compose + scripts)
  / **B** deploy-only (Helm + CI + deploy.sh) / **C** both / **none**.
- Local infra sub-choice retained (docker compose / native / devcontainers / suggest) — feeds
  deploy-setup later.
- Recorded in STATE.md `make_workflow: none|A|B|C`. CLAUDE.md gains a `## Commands` section:
  the convention line + project-specific examples; rule: env/lifecycle ops go through make
  targets — docs never instruct raw docker/kubectl/helm when a target exists.

**Build timing (decided):** ask early, build at infra/deploy phase. `references/05-planning.md`
already invokes `weloin:deploy-setup` for the infra phase; it now passes the recorded scope +
local-infra answer so deploy-setup scans real code and skips re-asking. deploy-setup missing →
existing 05 fallback (minimal Makefile + compose + single CI workflow).

## Feature 2 — Repo structure question (Q10b, Round C)

New Q10b in `references/01-interview.md`, after architecture Q10:

- Options: **single-app repo** / **monorepo** (`apps/` + `packages/`; valid even for a single app
  with shared libs) / **polyrepo** (recorded as a note; setup covers the current repo only).
- Recommendation derived from Q10: multi-service or monorepo-multi-service → monorepo; monolith →
  single-app unless shared libs planned.
- Recorded in STATE.md `repo_structure: single|monorepo|polyrepo`.
- Downstream (no file changes needed beyond recording — consumers already read STATE.md):
  architecture doc layout (03), builder-per-boundary scoping maps to `apps/*` (04), plan paths (05).

## Feature 3 — Subcommand router (`SKILL.md`)

`/weloin:project-setup <subcommand>` — ARGUMENTS routing, checked BEFORE the state-detection
routing. No args → existing phase-machine behavior unchanged.

| Subcommand | Loads | Focused action |
|---|---|---|
| `deploy` | 05 | Read STATE.md `make_workflow`; unset → ask scope A/B/C + local infra; invoke `weloin:deploy-setup` with scope (fallback per 05); record result |
| `gates` (alias `tests`) | 01 §Q15b + 04 + 06 | Show current `gates`; re-derive candidates, multi-select; update STATE.md; medium+ → create/update gatekeeper agents (update-aware, 04 §2); offer immediate gate run on current diff → gate report |
| `autonomy` | — (SKILL.md rule 4) | Show current `autonomy_default` + per-phase override; ask new; update STATE.md (and progress header if mid-phase) |
| `strategy` | 01 §Q11 | Re-ask strategy with recommendation; update STATE.md + CLAUDE.md; `integration-test-first` → copy rule block per templates |
| `agents` | 04 | Update-aware roster review (existing 04 §2 flow) |
| `plan` | 05 | Plan next phase now (macro-plan ask included) |
| `status` | — | Read STATE.md + current progress + `git log --oneline -5`; compressed report; zero writes |

Subcommand-mode rules:

- Read STATE.md first. Missing STATE.md → say so, offer full INIT/ALIGN; never fabricate state
  (`status` on a bare repo just reports "no project state").
- Ask only what's missing; defaults = current STATE.md values.
- All existing global rules hold (update-aware, same-commit STATE.md updates, user gates).
- Unknown subcommand → print the table, take no action.

## Independence

Each feature stands alone. Subcommands reuse existing reference flows — no logic is duplicated
into SKILL.md; the table only routes.

## Files touched (implementation surface)

- `skills/project-setup/SKILL.md` — subcommand router table (new section after Routing);
  SSOT fields list gains `repo_structure`, `make_workflow`.
- `skills/project-setup/references/01-interview.md` — Q10b; Q17 rework.
- `skills/project-setup/references/05-planning.md` — infra phase passes recorded scope/answers
  to deploy-setup.
- `skills/project-setup/references/templates.md` — STATE.md fields; CLAUDE.md `## Commands`
  section.

## Out of scope

- No changes to `weloin:deploy-setup` itself.
- No polyrepo orchestration (recording only).
- No new top-level skills — single-skill + args was chosen explicitly.

## Testing the skill change

- Dry-run interview: web app, multi-service → Q10b recommends monorepo; Q17 offers A/B/C/none;
  STATE.md carries both fields; CLAUDE.md shows `## Commands`.
- Dry-run `/weloin:project-setup deploy` on a project with `make_workflow: C` → goes straight to
  deploy-setup invocation, asks nothing already answered.
- Dry-run `/weloin:project-setup gates` on MANUAL project → still works (subcommand = explicit
  opt-in overrides the Q15b autonomy condition; note this in the router row).
- Dry-run `/weloin:project-setup status` on repo without STATE.md → reports no state, no writes.
