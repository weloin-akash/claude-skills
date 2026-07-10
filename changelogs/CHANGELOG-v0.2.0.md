# Release v0.2.0

**Release Date:** July 8, 2026
**Previous Version:** none (first tagged release)

---

## New Features

- **Skills library with cross-platform installer CLI** (`@weloin/claude-skills`)
  - `weloin-skills` CLI: interactive and non-interactive (`--skills=...`) installation of Claude Code skills
  - Symlink installs by default (update via `git pull`), `--copy` for snapshot installs
  - `list`, `uninstall`, and update flows; Windows-safe naming (`weloin-project-setup` where `:` is forbidden)

- **weloin:project-setup skill** — phase-machine for agent-driven development
  - Discovery interview → brief/requirements → architecture + ADRs → agent roster with model tags → phased plans → execution with AUTO/GUIDED/MANUAL autonomy
  - Resumable from any session via `docs/project/STATE.md` single source of truth
  - Works on fresh directories and aligns existing codebases

- **Gated development (opt-in)**
  - Interview question 15b (AUTO/GUIDED projects): multi-select quality gates derived from project scope — regression and goal-alignment always offered; compare-results, contract-compat, security-privacy, perf-budget when their triggers hold
  - Scale-dependent enforcement: small projects get an orchestrator-run inline checklist; medium+ get dedicated read-only gatekeeper agents that verify but never fix
  - Gate reports under `docs/project/gates/` with per-gate verdicts (PASS / DONE_WITH_CONCERNS / FAIL) and mandatory evidence; FAIL blocks the task group, concerns are logged to STATE.md and batch-surfaced — never silently dropped

- **integration-test-first development strategy (contract-by-test)**
  - New strategy option, recommended for complex API / multi-service / medium+ projects
  - Per feature: API docs → integration tests committed as an immutable contract → implementation → unit tests → suite must pass unmodified
  - Change protocol: functionality changes update the integration tests first; the resulting failure list enumerates every dependent and becomes the work list
  - When gating is on, the regression gate proves test immutability by diffing against the contract commit — a weakened assertion is an automatic FAIL

- **Make-based workflow question**
  - Interview captures the canonical `make <env|surface> <action> [args]` interface (`make local up`, `make staging deploy`, `make local nuke`, `make setup`) with scope A (local-only) / B (deploy-only) / C (both) / none
  - Recorded early in STATE.md, built at the infra phase by `weloin:deploy-setup` with the recorded scope so nothing is re-asked

- **Repo structure choice**
  - Explicit single-app / monorepo (`apps/` + `packages/`) / polyrepo question with a recommendation derived from the architecture answer; drives layout, builder scoping, and plan paths

- **Subcommand router** — focused entry points without the full phase machine
  - `/weloin:project-setup deploy | gates (tests) | autonomy | strategy | agents | plan | status | help`
  - Free-text context after the subcommand is absorbed like interview answers (e.g. `deploy use kubernetes, single node`) and never re-asked
  - Reads STATE.md first, asks only what's missing, never fabricates state

## Enhancements

- Development-strategy question reworked for easy choice: every option carries a one-line "pick when" and the skill marks one recommendation derived from API complexity, architecture, and scale

## Documentation

- Full README: install, update, uninstall, troubleshooting, skill authoring, subcommand reference, and opt-in feature overview
- Design specs and implementation plans committed under `docs/superpowers/`

## Other Changes

- MIT license
- Package renamed to scoped `@weloin/claude-skills`

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
