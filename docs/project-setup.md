# `weloin:project-setup`

A phase-machine for agent-driven development. It runs your project through structured phases — first interview → shipped code — with every decision recorded in `docs/project/STATE.md` so any future session resumes exactly where the last stopped.

Start it with `/weloin:project-setup` (or just say "set up a new project"). See the [per-feature execution flow](./execution-flow.md) for what a single change looks like once set up.

## Subcommands

Focused entry points — skip the phase machine, do one thing. **Every command below takes the `/weloin:project-setup ` prefix** (shown once here, omitted in the tables). Free text after a subcommand is context the skill absorbs and won't re-ask — e.g. `deploy use kubernetes, single node, ghcr images`.

### Re-set configuration

A set-up project is never frozen. Each command shows the current value, re-asks, updates `STATE.md` (+ `CLAUDE.md` where it surfaces) in one commit, and applies **going forward** — never restructuring existing work.

| Subcommand | Does |
|---|---|
| `strategy` | Re-choose development strategy — 15-strategy catalog (`integration-test-first`, `eval-first`, `strangler-fig`, …) with a project-kind recommendation matrix |
| `commits` | Commit strategy: style (conventional/gitmoji/free/custom) · detail (body-when-why/always-detailed/minimal/squash) · AI-signature (none/co-author/custom) |
| `worktrees` | Worktree isolation policy: per-phase / per-feature / ask (decide per change) / none |
| `gitflow` *(`branching`)* | Branch model: gitflow / trunk / custom |
| `scale` | Scan-first: audit architecture + deploy envs (local/staging/prod), pick a target scale, get gap-closing suggestions |
| `repo` *(`structure`)* | Repo structure: single / monorepo / polyrepo (migration is opt-in) |
| `autonomy` | AUTO / GUIDED / MANUAL default or per-phase override |
| `gates` *(`tests`)* | Configure quality gates; create gatekeeper agents (medium+); optionally run on current diff |
| `deploy` | Make-based local/deploy workflow (scope A local / B deploy / C both) via `weloin:deploy-setup` |
| `promote` *(`maturity`)* | Upgrade maturity one level (prototype→mvp→production): re-asks skipped questions, builds hardening plan from the debt ledger |

### Run an action

| Subcommand | Does |
|---|---|
| `agents` | Review / update the agent roster |
| `plan` | Plan the next phase now |
| `status` | Compressed project-state report (read-only) |
| `help` | Print the subcommand table |

## Notable opt-in features

Asked during the interview, all recorded in `docs/project/STATE.md`:

- **Gated development** — quality gates (regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget) work must pass before it counts as done; verdicts PASS / DONE_WITH_CONCERNS / FAIL with evidence reports under `docs/project/gates/`. Small projects: inline checklist; medium+: read-only gatekeeper agents.
- **integration-test-first strategy** — integration tests written first, committed as an immutable contract; implementation makes them pass unmodified; changes update tests first so breakage enumerates every dependent.
- **Make workflow** — canonical `make <env|surface> <action> [args]` interface (`make local up`, `make staging deploy`, `make local nuke`), built at the infra phase by `weloin:deploy-setup`.
- **Repo structure** — explicit single-app / monorepo (`apps/` + `packages/`) / polyrepo choice driving layout and agent scoping.
