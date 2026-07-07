# Phase 0–1: Init + Discovery Interview

## 0. Init (fresh directory only)

1. `git init` if not a repo.
2. Create `.gitignore` (see templates.md → gitignore; generic — extend with stack-specific entries after Round C stack choice).
3. Create `docs/project/STATE.md` from template: `phase: 1-discovery`, everything else `TBD`.
4. Commit: `chore: initialize project scaffold`.

## 1. Interview

**Method:** batched `AskUserQuestion` rounds (≤4 related questions per call), NOT one-at-a-time. Open-ended items (project description, features, journey) asked as plain messages. Adaptive rules:
- User already answered something (in brief or earlier round) → skip it.
- Long detailed answer → absorb everything it covers, prune later rounds.
- Short answers fine; don't push for elaboration unless ambiguous.
- After Round A, set `scale` in STATE.md — it prunes the remaining rounds per the SKILL.md rigor table.

### Round A — Identity & scale (always)
1. What is this? 2–3 sentences: problem, solution. (open)
2. Target user: technical / semi-technical / non-technical / mixed.
3. Platform: web app / website / mobile / desktop / cross-platform / CLI / library / browser ext / other.
4. Scale: personal-small / team-medium / large userbase. ← sets `scale`
5. Deployment target: local / VPS / K8s / serverless / stores / n-a.

### Round B — Functionality (always)
6. 3–5 core features, priority order. (open)
7. Main user journey: start → actions → outcome. (open)
8. External integrations: APIs, DB, auth providers, payments, messaging, storage.
9. Hard constraints: required stack, existing infra, compliance (GDPR/HIPAA/SOC2/PCI), offline, perf, budget.

### Round C — Stack & strategy (always; batched choices)
10. Architecture: monolith / modular monolith / multi-service / microservices / monorepo multi-service / suggest.
11. Development strategy: **vertical-slice** / server-first / frontend-first / contract-first / infrastructure-first / prototype-first / inside-out / other. Record in STATE.md `strategy` + CLAUDE.md.
12. Stack preferences, or "suggest" (recommend from requirements; justify in one line each).
13. Testing: unit / unit+integration / full TDD / +e2e / suggest.

### Round D — Workflow (medium+; small: only 14, 15)
14. Gitflow (feature branches + develop/main) or trunk-based? → STATE.md `gitflow`.
15. Autonomy default: AUTO / GUIDED / MANUAL → STATE.md `autonomy_default`.
16. CI/CD preference; commit style (conventional/free); lint/format tools.
17. Local infra: docker compose / native / devcontainers / suggest.
18. Security auditing agent wanted? (report-only scanner; categories scoped to stack) — medium+ only, auto-include for large.

### Round E — Scope (always)
19. MVP: absolute minimum to launch/demo/validate. (open)
20. Deferred: nice-to-haves that wait. (open)
21. Deadlines / external commitments?
22. Anything else: team size, code to port, domain knowledge.

### Large-scale extras (Round F, `scale: large` only)
23. NFR targets: latency, throughput, availability SLO, data volume.
24. Multi-tenancy? Data residency? Audit logging?
25. Expected team/agent parallelism; release cadence.

**UI rule:** project has UI → request design references (screenshots, URLs, app names) BEFORE any UI design work, at latest by Phase 2. No references → offer `frontend-design` skill direction later; note in STATE.md.

## Outputs

Write per templates.md, detailed-compressed style:
- `docs/project/00-brief.md` — what/who/why, scale, platform, constraints.
- `docs/project/10-requirements.md` — features (prioritized), journeys, integrations, NFRs, MVP vs deferred.
- `small` scale: merge both into `00-brief.md`.
- Update STATE.md: `phase: 2-architecture`, `next: propose architecture approaches`.
- Thin `CLAUDE.md` (templates.md) if absent.
- Commit: `docs: discovery brief and requirements`.

**Synthesis gate:** before writing docs, present ≤10-line summary (name, users, platform, stack lean, strategy, MVP, deferred). "Accurate? Missing anything?" Fix, then write.

**Decompose check:** if project = multiple independent subsystems, say so; recommend per-subsystem spec→plan→execute cycles; agree order with user; STATE.md tracks current subsystem.
