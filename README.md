# @weloin/claude-skills

Weloin's [Claude Code](https://claude.com/claude-code) skills library with a cross-platform installer.

Skills live in this repo under `skills/`. The `weloin-skills` CLI installs them into `~/.claude/skills` — by **symlink** by default, so pulling this repo (or updating the npm package) updates every installed skill instantly. Works on macOS, Linux, and Windows.

## Skills in this library

| Skill | What it does |
|---|---|
| `weloin:project-setup` | Phase-machine for agent-driven development: interviews you, writes brief/requirements/architecture/ADRs, creates a custom agent roster with model tags, breaks work into phased plans, executes with AUTO/GUIDED/MANUAL autonomy, and keeps everything resumable via a `docs/project/STATE.md` SSOT. Maturity axis (prototype/mvp/production) sets the quality bar independent of scale — prototypes skip ceremony but log shortcuts to a debt ledger; `promote` upgrades later. Works on fresh dirs and aligns existing codebases. |

Run `weloin-skills list` for the live catalog with install states.

## Prerequisites

- Node.js ≥ 18 (`node -v`)
- Claude Code installed (skills land in `~/.claude/skills`)

## Install the CLI

**From npm (once published):**

```bash
npm install -g @weloin/claude-skills
```

**From this repo (development / latest):**

```bash
git clone git@github.com:WELOIN/claude-skills.git
cd claude-skills
npm install
npm link          # or: npm install -g .
```

Both give you the `weloin-skills` command globally.

## Install skills

### Interactive (recommended)

```bash
weloin-skills
```

Opens a checkbox picker: ↑/↓ move, **space** toggle, **a** select all, **enter** confirm. Each skill shows a one-line explainer (read from its `SKILL.md` frontmatter). Already-installed skills come preselected — confirming refreshes them, unchecking does NOT uninstall (use `uninstall` for that).

### Non-interactive

```bash
weloin-skills --all                          # everything
weloin-skills --skills=project-setup         # named ("weloin:" prefix optional)
weloin-skills --skills=project-setup --copy  # snapshot copy instead of symlink
```

### Verify

```bash
weloin-skills list
# weloin:project-setup  ✔ linked   Use when starting a new software project...
```

Then in any Claude Code session: `/weloin:project-setup` (or just say "set up a new project").

### project-setup subcommands

Focused entry points — skip the phase machine, do one thing. Anything after the subcommand is free-text context the skill absorbs (e.g. `/weloin:project-setup deploy use kubernetes, single node, ghcr images` — those answers won't be re-asked):

| Command | Does |
|---|---|
| `/weloin:project-setup deploy` | Make-based local/deploy workflow only (scope A local-only / B deploy-only / C both) via `weloin:deploy-setup` |
| `/weloin:project-setup gates` (or `tests`) | Configure/adjust quality gates; create gatekeeper agents (medium+); optionally run gates on current diff |
| `/weloin:project-setup autonomy` | Change AUTO/GUIDED/MANUAL default or per-phase override |
| `/weloin:project-setup strategy` | Re-choose development strategy (incl. `integration-test-first` contract-by-test) |
| `/weloin:project-setup promote` (or `maturity`) | Upgrade project maturity one level (prototype→mvp→production): re-asks skipped questions, builds hardening plan from the debt ledger |
| `/weloin:project-setup agents` | Review/update agent roster |
| `/weloin:project-setup plan` | Plan the next phase now |
| `/weloin:project-setup status` | Compressed project state report (read-only) |
| `/weloin:project-setup help` | This table |

Notable opt-in features (asked during the interview, all recorded in `docs/project/STATE.md`):

- **Gated development** — quality gates (regression, goal-alignment, compare-results, contract-compat, security-privacy, perf-budget) that work must pass before it counts as done; verdicts PASS / DONE_WITH_CONCERNS / FAIL with evidence reports under `docs/project/gates/`. Small projects: inline checklist; medium+: dedicated read-only gatekeeper agents.
- **integration-test-first strategy** — integration tests written first and committed as an immutable contract; implementation must make them pass unmodified; changes update tests first so breakage enumerates every dependent.
- **Make workflow** — canonical `make <env|surface> <action> [args]` interface (`make local up`, `make staging deploy`, `make local nuke`), built at the infra phase by `weloin:deploy-setup`.
- **Repo structure** — explicit single-app / monorepo (`apps/` + `packages/`) / polyrepo choice driving layout and agent scoping.

## Update skills

- **Symlinked (default):** `git pull` in this repo — done. Nothing to re-run.
- **npm-installed:** `npm update -g @weloin/claude-skills` — the postinstall hook re-links everything you had installed (from the manifest).
- **Copied (`--copy`):** re-run `weloin-skills --skills=<name> --copy` or `weloin-skills sync`.

## Uninstall

```bash
weloin-skills uninstall --skills=project-setup
weloin-skills uninstall --all        # everything managed by this tool
```

Only removes installs this tool created — never touches skills you made yourself.

## Command reference

| Command | Does |
|---|---|
| `weloin-skills` | Interactive checkbox picker |
| `weloin-skills --all` | Install every skill |
| `weloin-skills --skills=a,b,c` | Install named skills |
| `weloin-skills list` | Catalog: name, state (`✔ linked` / `✔ copied` / `⚠ foreign` / `·` none), explainer |
| `weloin-skills uninstall --all\|--skills=...` | Remove managed installs |
| `weloin-skills sync` | Re-link everything in the manifest (runs automatically on npm postinstall) |

| Flag | Does |
|---|---|
| `--copy` | Copy instead of symlink (stable snapshot; won't auto-update) |
| `--force` | Replace a non-managed dir at the target — it's backed up to `<name>.bak-<timestamp>` first |
| `--silent` | No output (scripting) |

## How it works

- **Symlinks:** `~/.claude/skills/<name>` → `<this package>/skills/<dir>`. On Windows, directory junctions are used (no admin rights needed). If symlinking fails, it falls back to copy automatically.
- **Names:** repo dirs are plain (`project-setup`); the installed name comes from SKILL.md frontmatter (`name: weloin:project-setup`). Windows forbids `:` in paths, so there it installs as `weloin-project-setup`.
- **Manifest:** `~/.claude/weloin-skills.json` records what this tool manages and in which mode. `sync` rebuilds from it.
- **Safety:** a target dir not created by this tool is treated as *foreign* — skipped with a warning unless you pass `--force` (which backs it up first).

## Adding a new skill to the library

1. `mkdir skills/<plain-name>` — letters/numbers/hyphens only (no colons — cross-platform).
2. Write `skills/<plain-name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: weloin:<plain-name>
   description: Use when <triggering conditions>. Single line — the list explainer is parsed from it.
   ---
   ```
3. Add any supporting files (`references/`, scripts) beside it.
4. `weloin-skills` → select it. Symlinked skills need no reinstall after edits.

## Troubleshooting

- **`No TTY — use --all or --skills=...`** — the picker needs an interactive terminal; in scripts/CI use the flags.
- **`skip <name> — existing non-managed dir`** — you already have a skill with that name in `~/.claude/skills`. Re-run with `--force` to replace it (a backup is made).
- **Skill not showing in Claude Code** — start a new session; skills are scanned at session start. Check `weloin-skills list` says `✔ linked`.
- **Testing without touching your real setup** — env overrides: `WELOIN_SKILLS_TARGET=/tmp/x/skills WELOIN_SKILLS_MANIFEST=/tmp/x/manifest.json weloin-skills ...`
- **Mouse doesn't work in the picker** — keyboard only (space/enter). Lightweight Node TUIs don't support mouse.

## License

MIT © Weloin
