# Release v0.2.3

**Release Date:** July 9, 2026
**Previous Version:** v0.2.2

---

## Documentation

- **Hierarchical skills catalog in README**
  - "Skills in this library" section replaces the single-row table with a hierarchical text layout: a `###` heading per skill, a one-line intro, and nested **What it does** / **Why it's useful** groups
  - `weloin:project-setup` entry now explains the value proposition (durable state across sessions, maturity axis + debt ledger + `promote`, evidence-based quality gates, 15-strategy catalog) alongside the feature list
  - Layout scales: each future skill gets its own `###` block

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
