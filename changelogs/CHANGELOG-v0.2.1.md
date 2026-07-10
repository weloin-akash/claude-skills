# Release v0.2.1

**Release Date:** July 8, 2026
**Previous Version:** v0.2.0

---

## New Features

- **Maturity axis** (`weloin:project-setup`) — quality intent orthogonal to `scale`
  - New STATE.md field `maturity: prototype|mvp|production`, asked as interview question 4b right after scale
  - Override rule 2b: scale sets the ceremony baseline, maturity overrides the quality bar (tests, gates, security sections, config/secrets, DB migration discipline, definition of done)
  - Prototype dramatically shortens the interview (testing, gitflow, gates, CI/CD, make-workflow, and security questions skipped with recorded defaults); production preselects universal gates and auto-includes the security agent at medium+ scale
  - Architecture sections, execution-loop definition of done, and reviewer cadence all scale by maturity

- **Debt ledger** (`docs/project/40-debt.md`)
  - At prototype/mvp maturity, every consciously taken shortcut (stubbed auth, hardcoded config, drop-and-recreate DB, …) gets a row — shortcut, what production needs, date, status — in the same commit as the work
  - Builders report "shortcuts taken" as debt candidates; rows are never deleted, only marked resolved
  - The mechanical guarantee behind "start minimal but extendable"

- **`promote` subcommand** (alias `maturity`)
  - Upgrades maturity one level (prototype→mvp→production): re-asks the questions the old level skipped, then generates a hardening plan sourced from open debt-ledger rows plus the new level's requirements
  - Downgrade is a field edit with a note — no plan

- **ALIGN maturity inference**
  - The adopt-existing-project audit now collects maturity signals (tests, CI, migrations, secrets handling) and proposes an inferred maturity with evidence; the user confirms or overrides

## Documentation

- README: maturity axis in the skill description and `promote` in the subcommand table
- Design spec and implementation plan under `docs/superpowers/`

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
