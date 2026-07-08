# Release v0.2.2

**Release Date:** July 8, 2026
**Previous Version:** v0.2.1

---

## New Features

- **15-strategy development catalog** (`weloin:project-setup` Q11)
  - Seven new strategies: `walking-skeleton` (thinnest end-to-end slice incl. CI/deploy first), `behavior-first` (BDD executable scenarios), `data-first` (schema/migrations first), `event-first` (domain events + message contracts as the immutable contract), `eval-first` (eval harness + measurable quality bar for ML/LLM/agent products), `strangler-fig` (piecewise legacy modernization, ALIGN path), `spike-and-stabilize` (throwaway spike, rebuild clean, shortcuts to the debt ledger)
  - Every strategy — old and new — now carries an explicit `Order:` pipeline so the planner derives phase ordering from it directly

- **Project-kind recommendation matrix**
  - Explicit signals → recommendation + runner-up mapping (CRUD app, complex API, event-driven, ML/LLM, data pipeline, UX-critical, infra product, legacy modernization, feasibility-unknown)
  - Most specific signal wins; no match falls back to vertical-slice

- **Context-aware presentation**
  - Q11 options are never a flat menu: matrix picks the shown candidates, maturity re-ranks them (prototype boosts spike/prototype strategies, production boosts contract/skeleton rigor), each rendered option is phrased in the project's own nouns, and the recommendation names the signals that selected it

- **Execution rules for the new strategies**
  - eval-first: baseline recorded at harness commit, results never regress without written justification (pairs with the `compare-results` gate)
  - strangler-fig: facade contract tests immutable; legacy touched only to delete
  - spike-and-stabilize: spike branches never merge; rebuild cites spike learnings; spike shortcuts land in `40-debt.md`
  - event-first: integration-test-first immutability protocol with event schemas as the contract

## Documentation

- README strategy subcommand row reflects the expanded catalog
- Design spec and implementation plan under `docs/superpowers/`

---

**Installation:**
```bash
npm install -g @weloin/claude-skills
weloin-skills --skills=project-setup
```
