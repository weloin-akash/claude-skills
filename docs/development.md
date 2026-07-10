# Development

## How it works

- **Symlinks:** `~/.claude/skills/<name>` → `<this package>/skills/<dir>`. On Windows, directory junctions are used (no admin rights needed). If symlinking fails, it falls back to copy automatically.
- **Names:** repo dirs are plain (`project-setup`); the installed name comes from `SKILL.md` frontmatter (`name: weloin:project-setup`). Windows forbids `:` in paths, so there it installs as `weloin-project-setup`.
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
