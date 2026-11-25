# Fix Loop (phase 5, situational — load BEFORE writing any fix brief)

Trigger: bug report, field/device failure, regression, red gate leg, reviewer BLOCK. Rules 15–17 bind. Delegate `superpowers:systematic-debugging` for the investigation if installed; the contract below holds either way.

**Plan task vs fix task — different modes.** Plan task: the agent designs inside constraints and SHOULD correct a wrong plan (fix the wording, record the decision, say so). Fix task: the agent EXECUTES a spec. Every "how" an agent picks for itself in a fix touches code another path relied on — that is how one bug becomes four.

## 1. Evidence before code

- Field / device / production bug → pull logs, traces, journals FIRST. The brief quotes the rows verbatim and names where the bad value first appears. Reading source to guess a cause is not a diagnosis.
- Cause not visible in the evidence → say "not visible", instrument, rebuild, reproduce, pull again. No fix without an observed cause.
- Stale-evidence checks before dispatch: the capture's build post-dates the last fix for this bug; the task is still open on the board; no other session already fixed it (`git log` on the touched files).
- Red gate leg → CLASSIFY before any spec: misinvoked command / install state / environment (port in use, dev instance running, service down) / flake (red 1 of 3) / real. Only "real" gets a fix brief.
- Multi-device or silent-stall class of product, `medium+`: offer a flight recorder once (structured journal on every client + one pull/query script) — after that, every field bug starts from a query, not a guess.

## 2. Brief = diff spec, generated from the code

First fix in a project: copy `assets/fix-brief.sh` → `scripts/fix-brief.sh`. Then `bash scripts/fix-brief.sh <touched files> > <brief file>` and FILL it before dispatch. Persist the brief as a file and pass its path — a long inline brief plus "read the touched files" overflows the agent's context.

| Section | Filled with | Rule |
|---|---|---|
| Cause | evidence rows (§1), never source reasoning | — |
| Diff spec | `path:line → exact new text` | empty ⇒ you do not know the fix yet ⇒ nothing is dispatched |
| Must-not-move | every bound / wait / teardown / guard in the touched files that stays, with its number | — |
| Behaviour to deliver | one line | survives every later round (§5) |
| Working paths to keep | the project's list (CLAUDE.md `## Working paths`) + the mirror role | gives the self-pass a target list |
| MUST-HOLD | harvested comment lines of touched files + direct callers | one working-paths row per line; never truncate the harvest |
| Pins | tests referencing the touched symbols (pasted) | a spec that moves what a pin drives breaks it |
| Consequence pass | ONE read-only question on the ORIGINAL site: "what breaks if <the change> happens" — answered BEFORE the spec | — |
| Proof | the gate's own command lines, copied — never retyped | per-task proof = compile + the task's tests (rule 17) |
| Commit | project commit rules restated (rule 19) | — |

- **No alternative enters a spec.** An "or" or a slash is an undecided design — settle it first with the investigator or a test (which pin drives this line; who owns this fact, rule 18).
- A spec that was never compiled is a hypothesis. The agent's `spec-wrong: <path:line> <why>` + stop is the protocol WORKING — fix the spec, same agent.
- Applier: ≤2 files → `cavecrew-builder` (it has no shell: verify its work by diff); otherwise the owning dev agent in APPLY MODE. ONE fix agent per wave for everything red — parallel fixers on overlapping files mint merge bugs.
- Brief the constraint, not a preferred design, when you do NOT yet hold an exact spec — and then it is a plan task, not a fix.

## 3. Report contract (a section missing ⇒ rejected, unmerged)

```markdown
## Working paths
| path | old | new | pin |
|---|---|---|---|
| <caller / concurrent caller / mirror role / harvested MUST-HOLD line> | <what the old code did, accidental properties included> | <same \| changed: how> | <test name (changed row) \| grep evidence (unchanged row)> |

## Self-pass
<"what did this diff remove that another path relied on; the most likely new bug" — hunted on my own diff, fixed in this run>

## Pins
<mutation → test → RED, one line each; or "executed, mutations unproven">

## Contract delta
<which contract, what changed | none>

## Residuals
<PRE-EXISTING issues only — a bug this change introduced is fixed here, never rowed>

commit: <sha>   commands: <each with its result line; ONE test count, in ONE place>
```

Accidental properties are the rows that matter: a blocking wait that serialized two callers, a teardown that bounded a lifetime, a string match that gated a branch. A moved or lifted bound (timeout, grace, retry count, exception row) names its NEW number. The mirror role (send/recv, host/joiner, client/server, each platform) is fixed or rowed in the same commit.

## 4. Pre-merge review — every fix diff, including contract commits

- Small-diff reviewer (`cavecrew-reviewer`, else the roster reviewer), handed the DIFF — never your conclusion — and ONE fixed question: **"What did this remove that another path relied on? Name the most likely new bug."**
- Named new bug on a working path = BLOCK → back to the SAME agent in the same run (continue it; never a fresh dispatch, never a debt row).
- RISK → debt row, unless its fix is a pure deletion (then it goes back).
- A reviewer's `file:line` is a claim and its proposed shape is a hypothesis — verify both at the current tip before they enter a brief.
- Checking every row of the table does not check the change: also ask what a swap or a rename DELETED.

## 5. Rounds

| Round | Allowed |
|---|---|
| 1 | apply the diff spec |
| ≥2 | BLOCKs only; the reviewer's verified minimal shape applied mechanically; **delete/shrink only** — a new fn / flag / lookup / race in a fix round is a self-BLOCK |
| 3rd red | NO code. Read-only question: "which single invariant did every round violate, and where is it written?" → answer goes into the file's doc comment (if missing), the brief, and memory → then ONE fresh minimal diff by a fresh agent |
| 4th | escalate to the user |

"Shrink" means the MECHANISM a round added — never the behaviour the fix exists to deliver, never a working path. A shrink that drops either is itself a rule-15 violation. Reliability of the feature outranks a hypothetical tightening. Comments in a fix round: delete a false clause; never rewrite or extend prose (reworded sentences were most of the wasted rounds).

## 6. Merge + close

1. Merge preview by exit code (`git merge-tree --write-tree <a> <b>`); never pipe `git merge` through anything; verify with `git log -1`. Format check after every merge, per workspace — a formatting red can exist only post-merge.
2. Keep the fix worktree until the re-gate is green.
3. Re-gate = the red legs + every stack the fix touched or that reads the touched files — not the whole matrix again.
4. Same commit as the fix: a regression check for the bug (test, or a log-lint rule when no test can reach it); the working-paths table persisted in the progress file.
5. Residuals → debt rows minted by the session (rule 18). Field bug → confirm on the device/build that showed it before the task closes; user may waive after a green gate.

## 7. Mutation ladder (what makes a test a pin — rule 17)

1. Test green on the fixed code.
2. Mutate the guarded production line in the direction that REINTRODUCES the bug (deleting a guard and widening one are different tests).
3. Test goes RED for the right reason — read the failure message, not just the colour.
4. Restore by re-applying the edit (never `git checkout --` in a shared checkout); `git diff --numstat` back to baseline.

Unproven ⇒ label "executed, mutations unproven"; it buys no acceptance credit. Assert the EFFECT, not the call shape. Two checks sharing one dependency are one check. A red test is never fixed by editing the test.
