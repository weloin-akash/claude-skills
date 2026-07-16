# v0.2.6

## Features

- **project-setup: orchestration mode** — new STATE.md field `orchestration: session | agent/per-plan | agent/default-agent` controlling who runs the execution task loop.
  - `session`: main session orchestrates directly; no orchestrator agent file (04 must-haves bind to session).
  - `agent/per-plan`: one orchestrator agent spawned per macro-plan; independent workstreams → N parallel orchestrators, mandatory worktree each, STATE.md single-writer (session reconciles at fan-in).
  - `agent/default-agent`: `.claude/settings.json` boots every session as the orchestrator; settings.json ask now gated on this mode.
  - Interview Q15c (Round D; small scale + prototype maturity default `session` silently); re-settable anytime via `orchestration` subcommand (alias `orchestrator`); parallel-dispatch offer added to macro-plan ask (05 §2); new 06 §Dispatch.

  - Review fixes: parallel-dispatch briefing includes single-writer override; small scale can add orchestrator via subcommand; rule 7 carve-out pointer; per-workstream plans required before parallel dispatch.

Spec: `docs/superpowers/specs/2026-07-16-orchestration-mode-design.md`.
