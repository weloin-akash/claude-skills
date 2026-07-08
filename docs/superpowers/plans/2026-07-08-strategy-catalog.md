# Strategy Catalog Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand Q11 to 15 strategies with Order pipelines, a project-kind→strategy recommendation matrix, context-aware presentation rules, and execution rules for the strategies that need them.

**Architecture:** Documentation edits to 4 files in `skills/project-setup/` + README. Exact old→new per task; verification = grep anchors.

**Tech Stack:** Markdown skill files, git.

**Spec:** `docs/superpowers/specs/2026-07-08-strategy-catalog-design.md`.

## Global Constraints

- Detailed-compressed style; match surrounding density.
- Exact strategy ids: `vertical-slice`, `integration-test-first`, `server-first`, `frontend-first`, `contract-first`, `infrastructure-first`, `prototype-first`, `inside-out`, `walking-skeleton`, `behavior-first`, `data-first`, `event-first`, `eval-first`, `strangler-fig`, `spike-and-stabilize`, `custom`.
- `strangler-fig` is ALIGN-only in recommendations; `event-first` reuses integration-test-first immutability with event schemas as contract.
- No AI attribution in commits. After all tasks: patch release 0.2.2 + push (user standing instruction).

---

### Task 1: Q11 rewrite (`references/01-interview.md`)

**Files:**
- Modify: `skills/project-setup/references/01-interview.md`

**Interfaces:**
- Produces: 15 strategy ids + matrix — Tasks 2–5 use verbatim.

- [ ] **Step 1: Replace the whole Q11 block** (from `11. Development strategy` through the `Record in STATE.md` line) with the catalog + presentation rules + matrix exactly as specified in spec Features 1–2 (see spec; the implementing edit inlines the full new block).

- [ ] **Step 2: Verify**

Run: `grep -c "walking-skeleton\|behavior-first\|data-first\|event-first\|eval-first\|strangler-fig\|spike-and-stabilize" skills/project-setup/references/01-interview.md`
Expected: ≥ 14 (each new id appears in catalog + matrix). Q10b/Q12 untouched.

- [ ] **Step 3: Commit**

```bash
git add skills/project-setup/references/01-interview.md
git commit -m "feat(project-setup): 15-strategy catalog + recommendation matrix + context-aware Q11"
```

---

### Task 2: ALIGN strategy question (`references/02-align.md`)

- [ ] **Step 1: Extend shortened-interview Q5**

Old:

```markdown
5. Strategy going forward: keep-current / vertical-slice / server-first / frontend-first / other.
```

New:

```markdown
5. Strategy going forward: keep-current / strangler-fig (modernizing legacy piecewise behind a facade) / vertical-slice / server-first / frontend-first / other — full catalog + recommendation matrix in 01 §Q11 (ALIGN row recommends strangler-fig when modernization is the goal); presentation contextualized to the audit.
```

- [ ] **Step 2: Verify + commit**

Run: `grep -n "strangler-fig" skills/project-setup/references/02-align.md` → 1 hit.

```bash
git add skills/project-setup/references/02-align.md
git commit -m "feat(project-setup): strangler-fig option on ALIGN path"
```

---

### Task 3: Execution rules (`references/06-execution.md`)

- [ ] **Step 1: Add strategy-rules table after the integration-test-first section** (before `## Plan completion`)

Old:

```markdown
- Gating on → regression gate proves immutability (diff vs contract commit; weakened assertion = FAIL). Gating off → orchestrator enforces same check at plan completion; violation = blocker, escalate.

## Plan completion
```

New:

```markdown
- Gating on → regression gate proves immutability (diff vs contract commit; weakened assertion = FAIL). Gating off → orchestrator enforces same check at plan completion; violation = blocker, escalate.

## Strategy rules: eval-first / strangler-fig / spike-and-stabilize / event-first

| Strategy | Execution rule |
|---|---|
| eval-first | baseline recorded at harness commit; new results ≥ baseline or written justification — `compare-results` gate when gating on, orchestrator check at plan completion when off |
| strangler-fig | facade contract tests immutable (integration-test-first protocol); legacy code touched only to delete behind the facade |
| spike-and-stabilize | spike branch never merges; rebuild tasks cite spike learnings; every spike shortcut carried into rebuild → `40-debt.md` row |
| event-first | integration-test-first protocol with event schemas as the contract artifact |

## Plan completion
```

- [ ] **Step 2: Verify + commit**

Run: `grep -n "Strategy rules\|eval-first" skills/project-setup/references/06-execution.md` → table present between strategy section and Plan completion.

```bash
git add skills/project-setup/references/06-execution.md
git commit -m "feat(project-setup): execution rules for eval-first/strangler-fig/spike/event-first"
```

---

### Task 4: STATE.md enumeration (`references/templates.md`)

- [ ] **Step 1: Extend strategy comment**

Old:

```markdown
strategy: TBD             # vertical-slice|integration-test-first|server-first|frontend-first|contract-first|infrastructure-first|prototype-first|inside-out|custom
```

New:

```markdown
strategy: TBD             # vertical-slice|integration-test-first|server-first|frontend-first|contract-first|infrastructure-first|prototype-first|inside-out|walking-skeleton|behavior-first|data-first|event-first|eval-first|strangler-fig|spike-and-stabilize|custom
```

- [ ] **Step 2: Verify + commit**

Run: `grep -n "spike-and-stabilize" skills/project-setup/references/templates.md` → 1 hit in STATE.md template.

```bash
git add skills/project-setup/references/templates.md
git commit -m "feat(project-setup): strategy enumeration extended in STATE.md template"
```

---

### Task 5: README

- [ ] **Step 1: Update strategy subcommand row**

Old:

```markdown
| `/weloin:project-setup strategy` | Re-choose development strategy (incl. `integration-test-first` contract-by-test) |
```

New:

```markdown
| `/weloin:project-setup strategy` | Re-choose development strategy — 15-strategy catalog (incl. `integration-test-first`, `eval-first`, `strangler-fig`) with a project-kind recommendation matrix, presented in your project's own terms |
```

- [ ] **Step 2: Verify + commit**

Run: `grep -n "15-strategy" README.md` → 1 hit.

```bash
git add README.md
git commit -m "docs: expanded strategy catalog in README"
```
