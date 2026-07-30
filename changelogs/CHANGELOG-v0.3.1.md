# v0.3.1

## Features

- **Slash commands ship in the package** — the library is now skills *and* slash commands. A command namespace is all-or-nothing (unlike skills, which stay opt-in per skill): every install and every `sync` links `commands/<namespace>/` into `~/.claude/commands/<namespace>/`, and `uninstall --all` removes it. The directory name *is* the namespace — `commands/weloin/save.md` becomes `/weloin:save`.
  - Installer: `linkCommands()` / `unlinkCommands()` in `bin/cli.mjs`, same safety rules as skills — our own link is replaced, a foreign directory is left alone unless `--force` (backed up first), copy fallback where symlinks are not permitted. Mode is recorded per namespace in the manifest.
  - `commands` added to the published `files` list.

- **`/weloin:save`** — writes a resumable handoff into the current project (`docs/project/SESSION-HANDOFF.md`, falling back to `docs/` then `.claude/`): one-line state, where the truth lives, what was just done with shas, the single next action, decisions made (do not re-litigate), deliberately-not-done, in-flight/uncommitted work, environment state, traps, open questions. Points at an existing state file (`docs/project/STATE.md`, `PROGRESS.md`, …) rather than duplicating it, and updates its "next" pointer so the two agree. Commits the handoff only — never `git add -A`.

- **`/weloin:resume`** — reads the handoff, verifies it against git (commits landed since the save, branch, moved files), gives a fifteen-second gist, and asks before touching anything.

Both commands take free-text notes that outrank the saved plan: `/weloin:save we're abandoning the caching branch, pick up the migration instead`. The pair assumes the resume happens in a completely different session — new context, possibly a different machine — so anything not written to the file is lost.

## Documentation

- README: retitled to "skills **and slash commands** library", new *Slash commands* section with the namespace rule and a command table.

## Install

```bash
npx @weloin/claude-skills@latest --all
```
