# @weloin/claude-skills

Weloin's Claude Code skills library + installer. Skills live in `skills/`; the CLI symlinks them into `~/.claude/skills` so editing a skill here updates it everywhere instantly.

## Install (global)

```bash
npm install -g @weloin/claude-skills   # released
npm install -g .                       # from this repo — or: npm link
weloin-skills                          # interactive picker
```

`npm update`/reinstall re-runs `sync` automatically (postinstall) — previously installed skills re-link themselves.

## Usage

| Command | Does |
|---|---|
| `weloin-skills` | Checkbox picker (↑↓ move, space toggle, `a` all, enter confirm). Already-installed skills preselected. |
| `weloin-skills --all` | Install every skill |
| `weloin-skills --skills=project-setup,foo` | Install named skills (`weloin:` prefix optional) |
| `weloin-skills list` | Table: name, install state, one-line explainer (read from each SKILL.md frontmatter) |
| `weloin-skills uninstall --all` / `--skills=...` | Remove managed installs |
| `weloin-skills sync` | Re-link everything in the manifest |

Flags: `--copy` (copy instead of symlink), `--force` (replace a non-managed dir — backed up to `.bak-<ts>` first), `--silent`.

## Adding a skill

1. `mkdir skills/<plain-name>` (no colons — cross-platform), write `SKILL.md` with frontmatter `name: weloin:<plain-name>` and a single-line `description:`.
2. `weloin-skills` → select it.

The installer installs under the frontmatter `name`. Windows: `:` is illegal in paths → installed as `weloin-<name>` (junction symlinks, no admin needed).

## Notes

- Manifest of managed installs: `~/.claude/weloin-skills.json`. Foreign dirs (not created by this tool) are never touched without `--force`.
- Picker is keyboard-only (mouse-capable Node TUIs require heavy deps; not worth it).
- Env overrides for testing: `WELOIN_SKILLS_TARGET`, `WELOIN_SKILLS_MANIFEST`.
