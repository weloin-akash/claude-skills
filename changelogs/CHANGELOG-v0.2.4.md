# Release v0.2.4

**Release Date:** July 10, 2026
**Previous Version:** v0.2.3

---

## Features — project-setup

- **Commit strategy configuration (Q16b)**
  - New interview question sets a three-part commit strategy: **style** (conventional / gitmoji / free / custom), **detail** (body-when-why / always-detailed / minimal / squash-per-task), **signature** (none / co-author / custom)
  - Recorded to STATE.md `commit_strategy: <style>/<detail>/<signature>`, written into CLAUDE.md `## Git`
  - `signature` defers to a stricter global/project CLAUDE.md rule; never fabricated

- **Worktree policy + per-change isolation**
  - New interview question (Q14b) sets a project-level `worktrees` policy: `per-phase` / `per-feature` / `ask` / `none`
  - Execution (06) resolves isolation per substantial change from the policy; `ask` prompts current branch / new branch / worktree each time
  - Macro-plan ask (05) and rule 5 defer to the policy instead of blind-asking

- **Scan-first `scale` subcommand**
  - No longer a bare field flip: scans architecture + deploy readiness, reports current scale and env matrix (local / staging / production), asks a target scale, then suggests gap-closing actions to reach it
  - ALIGN audit (02) now detects deploy envs (Helm / K8s / deploy.sh / CI / per-env config)

- **Every STATE.md config field re-settable post-setup**
  - New `commits`, `worktrees`, `gitflow`, `scale`, `repo` subcommands; governing principle: a set-up project is never frozen — changes apply going forward, never retroactively restructure existing work

## Chore

- Changelog files relocated to `changelogs/`

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
