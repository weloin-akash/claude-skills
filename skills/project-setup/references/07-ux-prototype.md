# Phase 1b: UX Prototype

Entered from discovery when `strategy: ui-complete-first` OR `maturity: concept`. Goal: user SEES the whole application start-to-end before any backend exists — iteration is cheap here, expensive after wiring. Concept mode (`maturity: concept`): output is a viability verdict, not a contract.

## 1. Page inventory

Derive screen list from journey + features (Round B answers): per screen one line — purpose, data shown, actions. Present as table; user confirms/edits (gate). Record in progress notes.

## 2. Scaffold + build

- **Normal mode:** chosen frontend stack (Q12). All pages routed + clickable; b/w unstyled components (`fidelity_path: hifi-direct` → styled from the start per Q11c references). Mock data = fixture files under one dir (`fixtures/`), ONE fixture per future endpoint, shaped exactly as the API response the UI wants, named like the endpoint. Fixtures = the future contract.
- **Concept mode:** plain static HTML/CSS clickthrough — no framework, no fixtures, throwaway acceptable; viability IS the output.
- Commit: `proto: scaffold + page skeletons`.

## 3. Iteration loop

Dev server up (or open HTML) → user reviews in browser → change requests → apply → repeat until user declares it right. USER-GATED per round regardless of `autonomy_default` — visual judgment cannot be automated. Rules:
- One commit per round: `proto: <what changed>`.
- UI change alters shown data ⇒ fixture updated in the SAME commit — fixtures never lag the UI.
- Scope guard: no backend, no real API calls, no auth flows — anything needing a server = fixture + note.

## 4. Hi-fi pass (per `fidelity_path`)

- `wf-hifi-wire` — runs HERE after wireframe approval. Design references required (01 UI rule); none → block, request.
- `hifi-direct` — already merged into §2.
- `wf-wire-hifi` — NOT here; becomes a polish phase in the Phase-4 breakdown (05 §1).

Delegate: `frontend-design` installed → invoke it; else inline styling pass. Iteration loop (§3) applies to hi-fi rounds too.

## 5. Exit — normal mode: derive data contract

Walk EVERY screen → write `docs/project/15-data-contract.md` (templates.md), detailed-compressed: data shown, fixture shape (field:type + fixture path), implied endpoints (`VERB /path → fixture`), actions→mutations, parsing/transform needs (display format vs storage shape). User approves (gate). Fixtures stay the machine-readable truth; the doc is the compressed index — divergence = bug.

## 6. Exit — concept mode: viability gate

Ask: is the concept viable?
- **Viable** → stage-2 interview: re-ask Q4b (concept option removed — pick prototype/mvp/production) + resume Rounds C–F, absorbing prototype learnings (adaptive-skip: screens/journey/features proven — don't re-ask); Q11 asked normally (wireframe exists → matrix may lean `ui-complete-first` + `hifi-direct`). HTML clickthrough kept as REFERENCE only — the real stack builds fresh; note in STATE.md. Then continue at `2-architecture` (or §5 if `ui-complete-first` re-chosen with fixtures still to build).
- **Not viable** → park: STATE.md `next: parked — concept not viable (<date>, <one-line reason>)`; `phase` stays `1b-ux-prototype`. Re-running the skill reports the parked state; offer revive (re-enter §3) or re-init.

## 7. Transition

STATE.md: `phase: 2-architecture`, `next: propose architecture approaches (consume 15-data-contract.md)`. Commit: `docs: data contract from UI prototype`.
