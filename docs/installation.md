# Installation & CLI

Skills live in this repo under `skills/`. The `weloin-skills` CLI installs them into `~/.claude/skills` — by **symlink** by default, so pulling this repo (or updating the npm package) updates every installed skill instantly. Works on macOS, Linux, Windows.

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

## Update skills

- **Symlinked (default):** `git pull` in this repo — done. Nothing to re-run.
- **npm-installed:** `npm update -g @weloin/claude-skills` — the postinstall hook re-links everything you had installed.
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
| `--force` | Replace a non-managed dir at the target — backed up to `<name>.bak-<timestamp>` first |
| `--silent` | No output (scripting) |
