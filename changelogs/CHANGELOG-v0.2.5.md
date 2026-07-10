# Release v0.2.5

**Release Date:** July 10, 2026
**Previous Version:** v0.2.4

---

## Documentation

- **README slimmed to outcome + execution flow**
  - README now focuses on what the skill delivers and what to expect: `weloin:project-setup` value ("What you get" / "Why it holds up"), a quick-install block, and the per-feature/fix execution mermaid embedded inline
  - Install detail, CLI reference, subcommand reference, and contributor docs moved into `docs/` and linked from the README

- **New docs pages**
  - `docs/installation.md` — CLI install, update, uninstall, command/flag reference
  - `docs/project-setup.md` — subcommand reference (redesigned: prefix stated once, short tokens, split into *Re-set configuration* / *Run an action*) + opt-in features
  - `docs/development.md` — how installs work, adding a skill, troubleshooting
  - `docs/execution-flow.md` — per-feature execution walk-through with human ↔ Claude gates

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
