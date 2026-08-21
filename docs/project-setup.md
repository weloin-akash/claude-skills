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
| `promote` *(`maturity`)* | Upgrade maturity one level (concept→prototype→mvp→production): re-asks skipped questions, builds hardening plan from the debt ledger |

### Run an action

| Subcommand | Does |
|---|---|
| `agents` | Review / update the agent roster |
| `align` *(`realign`)* | On-demand alignment pass for an adopted project: boundary map (languages × platforms × toolchains) → roster / gates / board / CLAUDE.md deltas, each user-approved. Use after adding a platform or language |
| `plan` | Plan the next phase now |
| `status` | Compressed project-state report (read-only) |
| `help` | Print the subcommand table |

## Notable opt-in features

Asked during the interview, all recorded in `docs/project/STATE.md`:

- **Gated development** — quality gates (regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget) work must pass before it counts as done; verdicts PASS / DONE_WITH_CONCERNS / FAIL with evidence reports under `docs/project/gates/`. Small projects: inline checklist; medium+: read-only gatekeeper agents.
- **integration-test-first strategy** — integration tests written first, committed as an immutable contract; implementation makes them pass unmodified; changes update tests first so breakage enumerates every dependent.
- **UI-first flow** — `ui-complete-first` strategy: the whole app clickable with fixture data before any backend exists; fidelity paths (wireframe→hi-fi→wire / wireframe→wire→hi-fi-polish / hi-fi-direct); phase exit derives `docs/project/15-data-contract.md` that the backend must conform to. `maturity: concept` = wireframe-only viability check — tech stack and backend decided only after the concept proves out.
- **Make workflow** — canonical `make <env|surface> <action> [args]` interface (`make local up`, `make staging deploy`, `make local nuke`), built at the infra phase by `weloin:deploy-setup`.
- **Repo structure** — explicit single-app / monorepo (`apps/` + `packages/`) / polyrepo choice driving layout and agent scoping.

## Always-on disciplines (not opt-in)

- **Code shape** — small single-responsibility files (~800-line soft cap); test code in per-module `tests/` subfolders, never inline or sibling to production sources.
- **Layer contracts** — every cross-boundary interface (API, FFI/bridge, schema, event, UI-data port) is a published contract; consumers work against the contract, never the implementation below; a contract change is its own commit, landed first, consumers after. At medium+ scale & mvp+ maturity each boundary gets a doc under `docs/project/contracts/` that is generated or drift-tested — hand-maintained contract docs rot.
- **Mechanism enforcement** — a binding rule ships a check that can go red; with gates on, `docs/project/50-enforcement.md` tracks each gate BUILT vs OWED. New gates land freeze-and-ratchet: existing violations become an exception list that may only shrink, and the gate lands before the fixes it protects. Warnings are defects at mvp+; suppressions (`@ts-ignore`, `#[allow]`, …) never silence a boundary violation.
- **Living roster** — agents are derived from detected tech boundaries (language × platform × toolchain), re-checked at every plan completion/phase transition/adoption; a project growing from single-platform to cross-platform triggers a proposed roster delta (build/edit/retire + CLAUDE.md/gate updates). Every agent-file and CLAUDE.md change is user-approved as a concrete diff before the write, in every autonomy mode. Wave gates must cover every stack touched — missing toolchain = FAIL, CI that never builds a platform = drift finding.
- **Blink live board** — `npm i -g @weloin/blink@latest` + `blink init .` at project init (offered; declining falls back to progress files alone). `.blink/` holds LIVE tasks/decisions/risks written before the work, statuses move with it, `blink validate` after every write; `docs/project/` stays config SSOT + history. project-setup drives (phases/plans/waves), Blink records — only `blink:tracking`/`blink:setup` are delegated.
- **Style + utility kit (default ON, declined at roster approval)** — `caveman` (terse prose, all substance kept) and `ponytail` (laziest solution that works, corner-cuts marked + debt-tracked) installed as project skills and baked inline into every agent def; cavecrew utility agents (`cavecrew-investigator` code locator, `cavecrew-builder` surgical 1–2 file edits, `cavecrew-reviewer` small-diff review) installed into `.claude/agents/` with their routing rules declared in the orchestrator def and CLAUDE.md.
