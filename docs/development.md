# Development

## How it works

- **Symlinks:** `~/.claude/skills/<name>` → `<this package>/skills/<dir>`, and `~/.claude/commands/<namespace>` → `<this package>/commands/<namespace>`. On Windows, directory junctions are used (no admin rights needed). If symlinking fails, it falls back to copy automatically.
- **Names:** repo dirs are plain (`project-setup`); the installed name comes from `SKILL.md` frontmatter (`name: weloin:project-setup`). Windows forbids `:` in paths, so there it installs as `weloin-project-setup`. Commands have no frontmatter name — the *directory* is the namespace and the *filename* is the command, so `commands/weloin/save.md` is `/weloin:save` on every platform.
- **Opt-in vs all-or-nothing:** skills are selected one by one and recorded in the manifest. Command namespaces are not selectable — the whole `commands/` tree is linked on every install and every `sync` (including the postinstall on a fresh machine with no skills chosen yet).
- **Manifest:** `~/.claude/weloin-skills.json` records what this tool manages and in which mode — skills under `installed`, command namespaces under `commands`. `sync` rebuilds from it.
- **Safety:** a target dir not created by this tool is treated as *foreign* — skipped with a warning unless you pass `--force` (which backs it up first). Applies to command namespaces identically.

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

## Adding a new slash command

1. Drop `commands/<namespace>/<command>.md` — that's it. `commands/weloin/save.md` becomes `/weloin:save`.
   New namespaces work too (a new directory is a new namespace, linked automatically).
2. Frontmatter is optional but wanted:
   ```yaml
   ---
   description: One line, imperative — what running this does. Shown in the `/` menu.
   argument-hint: [what the free text after the command name is for]
   allowed-tools: Bash(git status:*), Read, Write, Edit, Glob, Grep
   ---
   ```
   `allowed-tools` narrows the command to what it actually needs — see `commands/weloin/save.md`,
   which can run git and write files but cannot push.
3. Body is a prompt injected verbatim on invocation. `$ARGUMENTS` (or `$1`, `$2`…) interpolates the
   free text the user typed after the command name.
4. No install step. A symlinked namespace picks the file up on the next Claude Code session start;
   on a copy install, re-run `weloin-skills sync`.

## Skill or command?

They are the **same mechanism**. Claude Code merged custom commands into skills — [the docs are
explicit](https://code.claude.com/docs/en/skills): "A file at `.claude/commands/deploy.md` and a skill
at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way." Either one can be
typed by the user or invoked by the model from its `description`, take `$ARGUMENTS`, run an
`AskUserQuestion` interview, write files, and be called by another skill through the `Skill` tool.

So the choice is **file layout**, not capability:

| | `commands/<ns>/<cmd>.md` | `skills/<name>/SKILL.md` |
|---|---|---|
| Ships | One file | A directory — `references/`, templates, scripts |
| Naming | Directory is the namespace | Frontmatter `name:` |
| Install | All-or-nothing per namespace | Opt-in per skill |

Use `commands/` while the whole instruction fits in one file. Move to `skills/` the moment it wants a
second file. Converting between them changes nothing about how or when it loads.

## Keeping invocation cost down

Only `description` text is resident at session start — bodies are not. The cost that bites comes
**after** invocation: the rendered body enters the conversation as one message and stays there for the
rest of the session.

- **Keep descriptions tight.** Every skill and command pays its description in every session, invoked
  or not. Trigger phrases, not a feature table. A 1,000-character description is overhead ~99% of the
  time.
- **Route, don't dump.** A 137 KB monolith costs ~35k tokens the instant it fires, most of it
  irrelevant to the branch actually taken — and it never leaves. Split into a short router plus
  `references/`, loaded one per phase. `skills/project-setup/` is the reference implementation.
- **Delegate heavy one-shot jobs.** A generator that scans, interviews, writes files and commits can
  run in a subagent: its instructions and its file reads never enter the main session, only the
  summary comes back.

## Troubleshooting

- **`No TTY — use --all or --skills=...`** — the picker needs an interactive terminal; in scripts/CI use the flags.
- **`skip <name> — existing non-managed dir`** — you already have a skill with that name in `~/.claude/skills`. Re-run with `--force` to replace it (a backup is made).
- **Skill not showing in Claude Code** — start a new session; skills are scanned at session start. Check `weloin-skills list` says `✔ linked`.
- **Command not showing in the `/` menu** — same cause: session start scans it. `list` covers skills only, so verify with `ls -l ~/.claude/commands/<namespace>/`.
- **`skip /<namespace>:* — existing non-managed dir`** — you already have `~/.claude/commands/<namespace>/` from somewhere else. `--force` replaces it after a backup.
- **Testing without touching your real setup** — env overrides: `WELOIN_SKILLS_TARGET=/tmp/x/skills WELOIN_COMMANDS_TARGET=/tmp/x/commands WELOIN_SKILLS_MANIFEST=/tmp/x/manifest.json weloin-skills ...`
- **Mouse doesn't work in the picker** — keyboard only (space/enter). Lightweight Node TUIs don't support mouse.
