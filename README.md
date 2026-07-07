# @weloin/claude-skills

Weloin's [Claude Code](https://claude.com/claude-code) skills library with a cross-platform installer.

Skills live in this repo under `skills/`. The `weloin-skills` CLI installs them into `~/.claude/skills` — by **symlink** by default, so pulling this repo (or updating the npm package) updates every installed skill instantly. Works on macOS, Linux, and Windows.

## Skills in this library

| Skill | What it does |
|---|---|
| `weloin:project-setup` | Phase-machine for agent-driven development: interviews you, writes brief/requirements/architecture/ADRs, creates a custom agent roster with model tags, breaks work into phased plans, executes with AUTO/GUIDED/MANUAL autonomy, and keeps everything resumable via a `docs/project/STATE.md` SSOT. Works on fresh dirs and aligns existing codebases. |

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
