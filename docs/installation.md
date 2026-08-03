# Installation & CLI

Skills live in this repo under `skills/`, slash commands under `commands/`. The `weloin-skills` CLI installs them into `~/.claude/skills` and `~/.claude/commands` — by **symlink** by default, so pulling this repo (or updating the npm package) updates everything installed instantly. Works on macOS, Linux, Windows.

Skills are **opt-in per skill**. Commands are **not** — a namespace is all-or-nothing, and every install ships it. See [Slash commands](#slash-commands).

## Prerequisites

- Node.js ≥ 18 (`node -v`)
- Claude Code installed (skills land in `~/.claude/skills`, commands in `~/.claude/commands`)

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

Opens a checkbox picker: ↑/↓ move, **space** toggle, **a** select all, **enter** confirm. Each skill shows a one-line explainer (from its `SKILL.md` frontmatter). Already-installed skills come preselected — confirming refreshes them; unchecking does NOT uninstall (use `uninstall`).

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

Then in any Claude Code session: `/weloin:project-setup`.

`list` covers skills only. To verify commands, check the target directly:

```bash
ls -l ~/.claude/commands/weloin/    # save.md  resume.md
```

## Slash commands

Everything under `commands/<namespace>/` is linked into `~/.claude/commands/<namespace>/` on **every**
install and every `sync` — including the npm postinstall, even when no skills are selected. The
directory name *is* the namespace, and each `.md` is one command: `commands/weloin/save.md` →
`/weloin:save`.

There is no picker and no `--skills=` equivalent. A namespace goes in whole or not at all.

| Command | Does |
|---|---|
| `/weloin:save [notes]` | Writes a resumable handoff into the current project, commits that file only |
| `/weloin:resume [notes]` | Reads the handoff, verifies it against git, asks before acting |

Same safety rules as skills: a link this tool made is refreshed, a **foreign** directory already at
`~/.claude/commands/<namespace>/` is skipped with a warning unless you pass `--force` (which backs it
up to `<namespace>.bak-<timestamp>` first). `--copy` applies to commands too, and where symlinks are
not permitted the CLI falls back to copy on its own.

New commands appear on the next Claude Code session start — with a symlinked install, `git pull` is
the whole update.

## Update skills

- **Symlinked (default):** `git pull` in this repo — done. Nothing to re-run.
- **npm-installed:** `npm update -g @weloin/claude-skills` — the postinstall hook re-links everything you had installed.
- **Copied (`--copy`):** re-run `weloin-skills --skills=<name> --copy` or `weloin-skills sync`.

## Uninstall

```bash
weloin-skills uninstall --skills=project-setup   # skills only — commands stay
weloin-skills uninstall --all                    # skills AND every command namespace
```

Command namespaces come off with `--all` only; `--skills=` never touches them, since they were never
selected per-skill in the first place.

Only removes installs this tool created — never touches skills or commands you made yourself.

## Command reference

| Command | Does |
|---|---|
| `weloin-skills` | Interactive checkbox picker (+ links command namespaces) |
| `weloin-skills --all` | Install every skill (+ links command namespaces) |
| `weloin-skills --skills=a,b,c` | Install named skills (+ links command namespaces) |
| `weloin-skills list` | Catalog: name, state (`✔ linked` / `✔ copied` / `⚠ foreign` / `·` none), explainer. Skills only |
| `weloin-skills uninstall --skills=...` | Remove those skills; commands untouched |
| `weloin-skills uninstall --all` | Remove every managed skill **and** every command namespace |
| `weloin-skills sync` | Re-link everything in the manifest, plus all command namespaces (runs automatically on npm postinstall) |

| Flag | Does |
|---|---|
| `--copy` | Copy instead of symlink (stable snapshot; won't auto-update) |
| `--force` | Replace a non-managed dir at the target — backed up to `<name>.bak-<timestamp>` first |
| `--silent` | No output (scripting) |
