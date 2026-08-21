---
name: ponytail
description: Laziest-solution-that-works engineering discipline. Climb the reuse ladder before writing new code, refuse unrequested abstractions, prefer deletion over addition, and mark deliberate corner-cuts with a ponytail comment plus a debt row. Use when writing, reviewing, planning or delegating any code change.
---

# Ponytail — laziest solution that works

The goal is the SMALLEST correct change. Not the cleverest, not the most general, not the one
that anticipates next quarter.

## The ladder — climb it in order, stop at the first rung that works

1. **Is this needed at all?** The cheapest code is the code not written. Challenge the
   requirement before implementing it.
2. **Already in this codebase?** Search first. Reuse beats re-invent, every time.
3. **Standard library?**
4. **An existing dependency?** (An existing one. Adding a dep is a rung, not a shortcut.)
5. **One line / a few lines inline?**
6. **Only now:** the minimum new code, in the fewest files.

## Refuse unrequested abstraction

- No trait/interface with exactly one implementation
- No config knob for a value that is a constant
- No scaffolding "for later", no hooks nobody calls, no generic layer for one caller
- No new file when an existing one is the obvious home
- **Deletion over addition.** A change that removes code and passes the same tests wins.

## Marking a deliberate corner-cut

When you knowingly take a shortcut, say so at the site:

```rust
// ponytail: fixed 64-entry cap instead of an LRU — ceiling is the 64 KiB sync payload;
// upgrade path = swap for the existing bounded store in obs/ if a real eviction need appears.
```

Name the **ceiling** (when it breaks) and the **upgrade path** (what replaces it). If it is a
real shortcut rather than a judgement call, it also gets a row in `docs/project/40-debt.md` in
the SAME commit — that is the project rule at `mvp` maturity.

## NEVER simplify these away

Laziness stops at the trust boundary. Not negotiable:

- validation at a trust boundary (anything crossing an API, a bridge/FFI, the wire, user input)
- error handling that prevents data loss
- security measures, crypto correctness, zero-knowledge properties
- explicit spec or plan requirements
- tests

## Comprehension is not lazy

Read and understand the whole flow FIRST. Laziness applies to the SOLUTION, never to the
investigation. A small change made without reading the surrounding code is not lazy — it is a
guess, and guesses surface later as silent failures with no error pointing at them.

## When delegating rather than coding

Same discipline applied to the task: prefer the plan with the laziest design that meets spec,
strip speculative scope out of the brief before dispatching, and reuse existing machinery
instead of commissioning a new abstraction.
