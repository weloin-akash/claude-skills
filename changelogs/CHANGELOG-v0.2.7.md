# v0.2.7

## Features

- **project-setup: UI-first development flow** — see the whole application before building the backend.
  - New strategy `ui-complete-first` (replaces `frontend-first`): entire app clickable with fixture data → iterate until approved → derive `docs/project/15-data-contract.md` → backend built to conform.
  - Chronological follow-ups Q11b/Q11c: `fidelity_path` (`wf-hifi-wire` / `wf-wire-hifi` — functionally complete before hi-fi polish / `hifi-direct` — skip wireframe when simple) + design-reference timing.
  - New maturity `concept`: two-stage interview — wireframe-only viability check (plain HTML clickthrough, no stack/data/backend); viable → resume remaining interview rounds; not viable → project parks.
  - New phase `1b-ux-prototype` (references/07-ux-prototype.md): page inventory → build with fixtures (fixtures = future contract, same-commit drift rule) → user-gated iteration loop → hi-fi pass per fidelity path (delegates `frontend-design` if installed) → data contract / viability gate.
  - Downstream: architecture (03) must conform to the data contract (deviations → ADR); planning (05) wires fixtures screen-by-screen and appends a polish phase for `wf-wire-hifi`; `promote` handles concept→prototype.

Spec: `docs/superpowers/specs/2026-07-17-ui-first-flow-design.md`.
