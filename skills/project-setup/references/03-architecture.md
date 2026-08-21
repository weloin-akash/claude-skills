# Phase 2: Architecture & Spec

## 1. Propose approaches

Present 2–3 architecture approaches, compressed: one table (approach / stack / trade-offs / when-right) + one-line recommendation with reason. User picks via AskUserQuestion. Big irreversible choices (DB engine, hosting model, auth strategy) get their own option sets if contested.

## 2. Design sections

Present design compressed, section by section, ONE approval check per message-group (not per paragraph). Sections — include only what applies, scaled by `scale` + `maturity` (rule 2b): prototype → skip Security, Risks, NFR; mvp → boundaries mandatory (isolation test below = hard gate); production → all + observability:
- System overview + boundaries (modules/services, one responsibility each, interfaces between)
- Data model (entities, keys, relations; schema sketch)
- API / interface design (contracts, auth, versioning if large)
- Key algorithms / non-trivial business logic
- Infra + local dev (docker compose? env vars? seed data?)
- Security & access control (authn/authz model; tenant isolation if multi-tenant)
- Risks + mitigations
- Phasing: MVP → v2 → v3
- `large` only: NFR budget (latency/throughput/SLO), observability, deployment topology

**Design-for-isolation test per unit:** can you state what it does, how it's used, what it depends on — without reading internals? No → redraw boundary.

**Boundary = published contract (SKILL.md rule 12):** every interface between units gets contract-level definition in the design — operations/fields + types, error semantics the consumer must handle, optionality + forward-compat rule (unknown field/variant degrades, never hard-fails), capability flags an implementation declares. Feature/UI code branches on capability flags, never platform checks. `medium+` & `mvp+`: each boundary becomes a doc in `docs/project/contracts/` (templates.md) with a generator or drift test — the drift test joins the quality gate; a hand-maintained contract doc rots.

**Debt-aware design (prototype/mvp):** consciously deferred concerns surfaced during design (auth stub, no rate limiting, drop-and-recreate DB) → name them in the design; each becomes a `40-debt.md` row when built (06).

**UI:** if project has UI and user gave references, capture direction here (reference → what to take from it). No references yet → block UI-related sections until provided.

**Data contract:** `docs/project/15-data-contract.md` exists → API/interface + data-model sections MUST conform to it — endpoints, shapes, parsing needs come FROM the contract; deviations get an ADR. UI direction = the prototype itself (references already captured in 1b).

## 3. Write docs

Per templates.md, detailed-compressed:
- `docs/project/20-architecture.md` (ALIGN path: `## Current` + `## Target`)
- `docs/project/30-decisions.md` — ADR log, one-liners: `ADR-N | decision | context→consequence | date`. `small` scale: ADRs inline in architecture doc.
- `large` only: `21-nfr.md`, `22-deployment.md` — freeform, no template block (structure from `weloin:deploy-setup` if installed — invoke it during Phase 4/5 for actual setup; here only record the chosen strategy).
- Client-facing deliverable wanted? → invoke `weloin:create-requirements` (installed) or decline politely with what the internal docs already cover (fallback: internal docs are the spec).

## 4. Self-review, then user gate

Self-review inline (fix, don't re-loop): placeholders/TBDs? contradictions between sections? ambiguous requirements (two readings → pick one, make explicit)? scope too big for one plan-cycle (→ decompose)?
`medium+`: additionally dispatch one reviewer subagent over the spec (gaps, technical errors); fix findings; max 2 iterations.

Then: "Spec written to `docs/project/20-architecture.md`. Review before I design the agent roster?" Wait. Changes → apply → re-check.

## 5. Transition

STATE.md: `phase: 3-agents`, `next: propose agent roster`. Commit: `docs: architecture spec and ADRs`.
