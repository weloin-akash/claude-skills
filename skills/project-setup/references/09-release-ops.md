# Release, Deploy + Destructive Ops (situational — load BEFORE the first command)

Trigger: push, tag, release/store upload, deploy, client rebuild/install on the user's devices, disk or worktree cleanup, anything touching production. Rule 20 binds.

## 1. The user-gated list (every autonomy mode — AUTO never waives it)

| Action | Needs |
|---|---|
| `git push` (any remote), tag push | the user's word for THIS push |
| Dispatching a release / store / deploy workflow | the user's word, naming the target |
| Rebuilding or reinstalling a client on the user's devices | the user's word — a green gate is not a request |
| Production writes, migrations | the user's word AFTER seeing what ships (§4) |
| Deleting worktrees, branches, caches, data; killing processes | the user's word AFTER the classification (§6) |

A hold ("no commit", "not now", "don't touch X", "wait for me") stands until the user explicitly releases it. A question, a side-answer, or silence is not consent. Write every hold into STATE.md `## Holds` the moment it is given — it must survive compaction and a new session. Approval is scoped to what was asked: "push" is not "deploy".

## 2. Push

- Pull/rebase in the root checkout first; commit with pathspecs; `git status` clean of other agents' work before pushing.
- **Know what the push triggers** — read the workflow `on:` blocks. A pushed tag that matches a release trigger STARTS the release pipeline: if you only meant to create the tag, cancel that run before it publishes.
- **Never push CI/workflow-file changes while a release or build run is in flight.** Token-scoped publish steps fail mid-run against a changed workflow tree; land workflow edits before dispatching, or after the run ends.
- Records-only commits made after a push stay local until the next word.

## 3. Release

1. Version bump = its own commit, landed BEFORE the dispatch. Every version site (per-platform manifests, store configs, changelog) is listed in a runbook — a bump that misses one ships mismatched versions.
2. **Artifact before link.** A download page, redirect, or consumer goes live only AFTER the artifact exists at its public URL — sequence it as a later wave, never the same one.
3. Public artifact names and URLs are a contract (rule 12): changing who writes a name, or adding one, is a contract commit landed first, alone.
4. Verify the published thing, not the green tick: checksum against the build output, a size-checked HEAD on the public URL, the OS verifier for signed/notarized artifacts (run inside the workflow as a gate, before upload).
5. Failed publish with artifacts already built → say what a full re-run would redo, then prefer completing the missing step by hand and verifying checksums.
6. First run of any release path is manual and watched; only a proven path is wired to fire automatically.

## 4. Deploy

1. Staging first, when one exists; clients under test point at staging and say so.
2. **Diff against what production RUNS** (the deployment record's sha), not against the last push — every lane between those two shas ships.
3. Before asking for the go: list the lanes that rebuild, every migration by number, and any config/secret the new code reads. Then ask.
4. After: health check several times, the changed surface exercised once, production sha recorded in STATE.md.
5. One test database / one shared environment → one writer at a time; say who holds it.

## 5. Secrets + production data

- Secret NAMES only. Values never appear in chat, a brief, a log, a commit, or `argv` — load from the env file inside the same command and pass on stdin.
- Production data: read-only, counts and names only, no PII, unless the user asks for more.
- Device files and logs pulled for debugging: names / counts / lengths, never contents that identify a person.

## 6. Destructive ops

1. **Classify first:** for each thing to delete — what it is, whether its work is merged (ancestor-check the branch TIP, and remember a cherry-pick is invisible to ancestry: compare content), whether it holds uncommitted edits.
2. A cleanup request from the user covers what is PROVABLY safe — merged tip, no uncommitted edits, not locked: delete those now and report. Anything unmerged, dirty or locked is outside that request: save uncommitted edits as patches outside the repo, report the list with what each holds, and ask before deleting.
3. Delete worktrees, keep branches unless told otherwise — committed work stays recoverable.
4. Processes: kill by PID, never by name pattern (a pattern matches your own wrapper); check for live work (transfers, writes, a running gate) first.
5. Disk: per-agent build directories fill a disk fast. Check free disk + RAM before a fan-out; every dispatch brief names its build dir and deletes it at the end. A full disk leaves zero-byte files that read as "written".

## 7. Client builds

- Build after the gate is green, from a named sha; record sha per device so a later trace can be dated against it.
- Generated bindings / codegen drift (including doc-only contract edits) surfaces at BUILD time — regenerate as part of the contract commit, not after a failed build.
- A running dev instance holding the gate's ports turns the gate red — stop it (by PID, §6) before gating; restart only if the user wants it back.

## 8. Second time = runbook

The first time a release, deploy, or device procedure is performed, write `docs/project/runbooks/<name>.md` — commands, order, traps met. The second time follows the runbook. A trap met twice becomes a check in the workflow or the gate (rule 19).
