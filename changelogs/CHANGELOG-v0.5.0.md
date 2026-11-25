# v0.5.0

What four more months of the air-transfer project (Sep–Nov 2026) taught, folded back into `project-setup`. The theme: most of the cost was not building features, it was fixes that broke a neighbouring path, checks that reported green without checking, and state that outgrew its container. Each lesson lands as a rule plus a mechanism, so a new or adopted project starts with it.

## project-setup

- **Rule 15 — regression closure.** A fix is done only when it closes the paths it touches. The fix report carries a `## Working paths` table (`path | old | new | pin` — every caller, concurrent caller and mirror role, accidental properties included) and a `## Self-pass`; every fix diff gets a pre-merge small-diff review asking one fixed question, "what did this remove that another path relied on?". No table or no self-pass ⇒ rejected unmerged; a named new bug goes back to the same agent. CLAUDE.md gains a `## Working paths (must not break)` block that every fix brief names.
- **Rule 16 — fix loop.** Evidence before code. A fix brief is a diff spec, not a goal; an empty spec or an "or" in it is not dispatched; the applying agent reports `spec-wrong` instead of improvising. Rounds ≥2 only delete or shrink the mechanism a round added, never the behaviour. A third red round stops coding and diagnoses the single violated invariant; a fourth goes to the user.
- **New reference `08-fix-loop.md`** — the whole fix procedure: evidence, brief, report contract, pre-merge review, rounds, merge + close, and the four-step mutation ladder.
- **New asset `fix-brief.sh`** (→ `scripts/fix-brief.sh`) — generates the brief skeleton from the touched files: harvests the MUST-HOLD comment lines of those files and their direct callers, lists callers and the tests that reference the touched symbols, pulls proof commands from `gates.list`. Portable bash (3.2+), no dependencies.
- **Rule 17 — proof discipline.** A test is a pin only after a mutation turned it red, otherwise "executed, mutations unproven" with no acceptance credit. A red test is never fixed by editing the test. Green is read from the passed count, not the exit code. An agent's "done" is verified by diff. Heavy suites and the lint matrix run once per plan, never per task or from parallel agents.
- **Rule 18 — one fact, one owner.** In code: a runtime truth has one owning module; a fix adds a phase to it, never a sibling flag. In bookkeeping: the session is the only allocator of ids (debt, migrations, tasks) and the only writer of STATE.md, progress, the debt ledger, the board and its own memory.
- **Rule 19 — a lesson learned twice becomes a mechanism.** A repeated correction turns into a script, gate, hook or brief line, not another memory entry. Memory is a lean index. Rules that contradict a session default (commit attribution) are restated in every dispatch brief.
- **Rule 20 — user-gated actions + standing holds.** Push, tag, release, deploy, production writes, installing on the user's devices and anything that deletes need the user's word for that action in every autonomy mode. Holds are written to STATE.md `## Holds` and stand until released.
- **New reference `09-release-ops.md`** — push (know what a push or a tag triggers; never push workflow changes mid-release), release (version bump first; artifact before link; verify by checksum, not by a green tick), deploy (diff against what production runs; list migrations before the go), secrets, destructive ops (classify, save patches, kill by PID), client builds, and "second time = runbook".
- **STATE.md is a bounded header.** One line per field, under 6 KB. The orchestrator's session hook now truncates at the budget and says so — an oversized state file silently stops being injected at session start. New `## Holds` section.
- **Execution loop (06).** Every dispatch brief carries the do-not-edit list, overrides, per-task proof commands and required report sections. Work is accepted by diff. Gate list follows the files touched and the stacks that read them. Plan completion = one full gate → one fix agent → re-gate the red legs, plus persisted review/security reports and an acceptance record mapping each exit criterion to evidence.
- **Ops rules (06).** Shared-checkout git verbs that destroy a peer's work (`add -A`, `stash`, `checkout --`, rebasing a dirty tree; pathspec commits skip untracked files). Append-only files merge per row, never `-X ours|theirs`. Disjoint id blocks. Disk and RAM checked before a fan-out.
- **Agent definitions (04 + templates).** Builder defs gain `## Regression closure` and `## Never` sections; tester, reviewer and orchestrator must-haves carry the new rules; `cavecrew-reviewer` is the mandatory pre-merge pass on fix diffs.
- **Plans (05).** Header names working paths that must not break, the gate list, user-gated steps, out of scope and risks.
- **ALIGN (02).** Adoption asks for the working paths and proposes a fold when STATE.md or memory has become a journal.
- **New templates:** fix report, acceptance record, runbook, orchestrator memory index. Existing projects pick these up through `upgrade`.

## Install

```bash
npx @weloin/claude-skills@latest --all
```
