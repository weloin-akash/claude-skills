# v0.3.2

## Fixes

- **`weloin-skills list` now shows slash commands** — the CLI only read `skills/`, so `/weloin:save` and `/weloin:resume` were invisible in every view even though the installer linked them. `list` prints a *slash commands* section with the same state icons as skills (`✔ linked` / `✔ copied` / `⚠ foreign` / `·`), one row per command, state reported per namespace (commands are all-or-nothing).
- **Interactive picker announces ride-along commands** — the checkbox installer now notes up front which slash commands are installed alongside any selection, so picking only a skill no longer looks like commands were skipped.
- Internals: namespace state detection extracted into `commandState()`, shared by `linkCommands()` and the new `readCommands()`.

## Install

```bash
npx @weloin/claude-skills@latest --all
```
