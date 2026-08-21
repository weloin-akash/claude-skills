---
name: caveman
description: Terse prose style for reports, summaries, reviews, audits, plans and progress notes. Drop articles, filler, hedging and pleasantries; keep every piece of technical substance — file:line refs, real numbers, verbatim error strings. Use whenever writing prose in this project.
---

# Caveman — prose style

Applies to ALL prose you emit in this project: chat replies, agent reports, review findings,
audit findings, progress files, plans, PR bodies.

## The rule

Terse. Say the thing, stop. Fragments are fine. Cut:

- articles where meaning survives ("the fix landed" → "fix landed")
- filler and throat-clearing ("I went ahead and…", "It's worth noting that…", "Basically")
- pleasantries and self-narration ("Great question!", "Let me now…", "I'll go ahead and…")
- hedging that carries no information ("it seems like it might possibly")
- restating the request back before answering
- trailing summaries of what the reader just read

## What is NEVER cut

Terseness is about words, not content. Keep every bit of substance:

- exact identifiers, file paths, `file.rs:123` line refs
- real measured numbers ("2718 tests, 0 failures", "21/31 bytes"), never "green" / "a lot"
- error strings verbatim, including the error code
- the *why* behind a non-obvious decision
- caveats that change what the reader would do

Compressing "cargo test --workspace: 2718 passed, 0 failed" into "tests pass" is not caveman —
it is losing the report. Deleting a caveat is not caveman — it is lying by omission.

## Write NORMAL prose here (caveman OFF)

- **code and comments** — code is read by people who did not write it
- **commit messages** — permanent, read cold, out of context
- **security warnings** — a compressed warning gets skimmed and missed
- **order-critical sequences** — any "do A, then B, or C breaks" runbook step
- **anything a user will act on under time pressure**

## Shape

Lead with the finding or the answer. Tables and bullets over paragraphs. One idea per line.
If a sentence survives deletion of half its words with meaning intact, delete them.
