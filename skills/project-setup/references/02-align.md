# Phase 1 (ALIGN path): Adopt Existing Project

Overlay the SSOT framework on an existing codebase WITHOUT disrupting it.

## 1. Automated audit (no questions yet)

Detect, in parallel where possible:
1. Structure: top-level dirs, service boundaries (`ls`, Explore agent for large repos).
2. Stack: `package.json` / `go.mod` / `requirements.txt` / `pyproject.toml` / `Cargo.toml` / `Gemfile` / `pom.xml` / `composer.json` / Docker files / Makefile.
3. Architecture shape: monolith / multi-service / monorepo from layout + configs.
4. Git conventions: `git log --oneline -20` (commit style), `git branch -a` (naming, gitflow?). **No git repo / empty history:** ask user first, then `git init` + one baseline commit of the existing tree (`chore: baseline existing code`) — adoption needs a commit to diff against; user declines → STOP, adoption requires version control. Git-derived findings marked `n/a (fresh repo)`; commit style + branching asked in the interview (§2 Q9 → Q16b/Q14 from 01) instead of detected.
5. CI/CD: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`.
6. Standards: linters, formatters, `README.md`, `CONTRIBUTING.md`.
7. Tests: dirs, configs, script commands; run count if cheap.
8. Docs: `docs/`, wikis, existing specs.
9. Maturity signals: tests present+passing? CI configured? DB migrations dir? secrets handling (`.env` committed? hardcoded keys?)? error-handling depth (spot-check).
10. Deploy envs (feeds `scale` subcommand + `make_workflow`): Helm charts, K8s manifests, `deploy.sh`, CI deploy jobs, per-env config (`.env.staging`/`.env.production`, `values-*.yaml`) → classify local / staging / production as present | partial | absent.

Present compressed audit table: stack / architecture / commit style / branches / CI / tests / docs / deploy envs (local·staging·prod) → one line each.

**Boundary map (feeds roster + gates, rule 13):** from findings 1–3 + 5, list every tech boundary explicitly — language × platform × toolchain (e.g. `rust core / go server / ts client / android / ios / desktop-shell`), each with: build entry point, test command, CI coverage (built in CI? which OS runner?). A boundary CI never builds is a finding, not a footnote.

## 2. Shortened interview

Batched AskUserQuestion; ask ONLY what audit cannot answer:
1. Audit accurate? Corrections? (open)
2. What is this project + target user (if README unclear).
3. Scale (sets `scale` in STATE.md).
3b. Maturity — propose inferred level with one-line evidence ("no tests, secrets in code → prototype — agree?"); user confirms/overrides → STATE.md `maturity`. prototype|mvp → create `docs/project/40-debt.md`. Inference sets the go-forward bar only — never triggers restructuring (hard rules below hold).
4. Done vs remaining: what works, what's left. (open — this seeds progress pre-population)
5. Strategy going forward: keep-current / strangler-fig (modernizing legacy piecewise behind a facade) / vertical-slice / server-first / ui-complete-first / other — full catalog + recommendation matrix in 01 §Q11 (ALIGN row recommends strangler-fig when modernization is the goal); presentation contextualized to the audit.
6. Change anything about current process? (testing, conventions, CI) — default: nothing.
7. Testing expectation going forward.
8. Autonomy default: AUTO / GUIDED / MANUAL.
9. Gitflow + commit style: keep detected pattern / change (catalogs: 01 Q14 branching, Q16b commit strategy).
10. Security audit agent? (medium+; report-only)
11. Anything else.

## 3. Hard rules — respect what exists

- DO NOT restructure dirs, rename files, rewrite code to new patterns.
- DO NOT touch existing CI/CD, linters, configs unless asked.
- DO NOT overwrite `README.md` or `.gitignore` (append to `.gitignore` only if needed).
- Existing `CLAUDE.md`: merge SSOT pointers in, preserve all existing content.
- CLAUDE.md documents ACTUAL detected conventions, not imposed ones.
- Agents scoped to existing structure.

## 4. Outputs

- **Blink (SKILL.md rule 7):** existing tracking found in the audit (TODO files, issue lists, trackers) or user wants a live board → delegate `blink:setup` (surveys, converts on confirm); skill missing → `blink` CLI `blink init .` + CLAUDE.md block, or offer `npm i -g @weloin/blink@latest`; declined → progress files only.
- `docs/project/STATE.md` — `phase: 2-architecture`, detected+confirmed values, `next: document current architecture + design remaining work`.
- `docs/project/00-brief.md` — includes `## Current State` (what exists, from audit + user answer 4).
- `docs/project/10-requirements.md` — existing features marked ✅ done; remaining work as requirements.
- Progress scaffold later (Phase 4) pre-populates completed items.
- Commit: `docs: adopt project into structured workflow`.

## 5. Initial alignment (every existing-project adoption — before Phase 2)

One pass, compressed report, user approves each delta before applying (rule 6 holds — propose, never impose):
1. **Roster vs boundary map (rule 13):** existing `.claude/agents/` scope lines vs the audit's boundary map → uncovered boundary / stale agent / scope overlap table; deltas via 04 §2 update-aware diff. No agents yet → noted; roster is built at Phase 3 from this map.
2. **Gates vs stacks:** every boundary needs a runnable check command on the dev host + CI; missing toolchain or CI-never-builds rows reported (candidate `50-enforcement.md` OWED rows if gating on).
3. **Board vs reality (rule 14, `.blink/` present):** `blink:sync` or fallback compare vs `git log`; reconcile to git truth.
Findings the user defers → recorded in STATE.md `## Notes`, not dropped.

Then continue Phase 2 (03-architecture.md) with one adjustment: architecture doc has `## Current` (as-is, documented not judged) + `## Target` (remaining work only — never propose rewriting what's built unless user asked in Q6).
