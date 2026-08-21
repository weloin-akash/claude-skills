# v0.4.0

Conventions proven in the air-transfer project (Jul–Aug 2026) folded back into `project-setup` so every new project starts with them.

## project-setup

- **Global rule 11 — code shape**: small single-responsibility files (~800-line soft cap, boy-scout split); test code in per-module `tests/` subfolders (or the stack's mirror convention) — never inline test blocks or sibling test files next to production sources.
- **Global rule 12 — layer contracts + mechanism enforcement**: every cross-boundary interface is a published contract; consumers work against the contract, never the implementation below; a contract change is its own commit, landed first, consumers after (never one wave). Feature/UI code asks capabilities, never platforms. `medium+` & `mvp+`: per-boundary contract docs under `docs/project/contracts/`, generated or drift-tested — hand-maintained contract docs rot. Binding rules ship gates that can go red; `docs/project/50-enforcement.md` ledger tracks BUILT vs OWED; new gates land freeze-and-ratchet (exception list only shrinks) and before the fixes they protect. Never suppress a warning or purity/contract violation (`#[allow]`, `@ts-ignore`, `//nolint`, …).
- **Maturity table**: new `Warnings` row (zero at mvp+, a warning is a defect) and `Contract docs` row.
- **Gate evidence hygiene (06 §5b)**: gate output captured to a file and grepped — never a verdict through a pipe/`tail`; missing toolchain = FAIL, not skip; a gate that didn't cover the changed boundary isn't green for it; CI's exact invocation; feature-flagged builds run both ways. Gate report template gains an `evidence:` file-path field.
- **Contract-first parallel dispatch (06 §Dispatch)**: shared-contract change lands alone — own commit, gated — before consumer workstreams dispatch; only a real dependency edge forces sequencing.
- **Plans + progress**: plan header names contracts touched (`none` explicit); contract-delta tasks sequenced first; progress files record contract deltas; reviewer runs a fixed boundary checklist (layer purity, contract-doc drift, no new suppressions) at every plan boundary.
- **Style kit shipped and ON by default** (declined at roster approval): `caveman` (terse prose, all substance kept) + `ponytail` (laziest solution that works, `ponytail:` corner-cut marks + debt rows) install as project skills, get a CLAUDE.md `## Style` block, and are baked inline into every generated agent def. Sources in `skills/project-setup/assets/style-skills/`.
- **Cavecrew utility agents installed + use declared**: `cavecrew-investigator` (code locator, file:line tables), `cavecrew-builder` (surgical 1–2 file edits, refuses 3+), `cavecrew-reviewer` (small-diff review) copied into `.claude/agents/`; routing rules declared in the orchestrator def, CLAUDE.md, and the 06 task loop. Sources in `skills/project-setup/assets/agents/`.
- New templates: contract doc, `50-enforcement.md` gates ledger, CLAUDE.md `## Style` block + expanded `## Rules`/`## Agents`.
- New red flags: contract+consumers in one wave; adding a suppression; adding a freeze-list exception to pass; accepting "gates green" without captured evidence covering the changed boundary.

## Blink integration

- Project tracking via [`@weloin/blink`](https://www.npmjs.com/package/@weloin/blink) wired into the flow: 0-init/ALIGN installs (`npm i -g @weloin/blink@latest`) + `blink init .` (offered, declinable — fallback stays progress-files-only); phase breakdown mirrors to a milestone + `backlog` tasks; the task loop moves `.blink/tasks/` statuses and writes `.blink/decisions/` in the same commit as the work; `blink validate` after every write. Scope split: Blink = live state, `docs/project/` = config SSOT + history. project-setup remains the driver — only `blink:tracking`/`blink:setup` are delegated, never `blink:project`/`blink:execute`. New CLAUDE.md template block `## Project tracking (Blink)`.

## Living roster + alignment

- **Rule 13 — roster tracks boundaries**: the agent roster is re-derived from detected tech boundaries (language × platform × toolchain) at every plan completion, phase transition, and adoption — never frozen at setup by project type. Going single-platform → cross-platform triggers a roster delta (build/edit/retire agents + CLAUDE.md/contract/gate updates). A wave's gates must cover every stack it touched; CI that never builds one of the project's platforms is a drift finding.
- **Rule 9 hardened — agent definitions always user-gated**: any create/edit/retire of `.claude/agents/*.md`, from any trigger, requires explicit user approval via the update-aware diff BEFORE the write, in every autonomy mode (AUTO never waives it). Applies to agent files and roster shape only — normal code/doc edits follow the autonomy mode.
- **Rule 14 — agent-board sync**: `.blink/` is agent-consumed state, not a display: resume reads the board (`blocked_by`/`paused_reason` gate dispatch), drift reconciles to git truth via `blink:sync`/fallback, statuses move in the same commit as the work.
- **ALIGN gains an initial-alignment pass (02 §5)**: on every existing-project adoption — roster vs boundary map, gates vs stacks (missing toolchain / CI-never-builds reported), board vs git reality — each delta user-approved before applying.

## New skills + plugins vendored

- `caveman` family skills: `caveman`, `caveman-commit`, `caveman-compress`, `caveman-help`, `caveman-review`, `caveman-stats`, `cavecrew`.
- `ponytail` family skills: `ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, `ponytail-review`.
- **Full plugins vendored** under `plugins/caveman` + `plugins/ponytail` (hooks, commands, agents, MCP — everything needed to run the modes always-on) with a root `.claude-plugin/marketplace.json`, so new AND existing projects can `claude plugin marketplace add` this repo and install both. project-setup's install step prefers the plugins (session hooks) and falls back to project-skill copies where plugin install isn't possible.

## Install

```bash
npx @weloin/claude-skills@latest --all
```
