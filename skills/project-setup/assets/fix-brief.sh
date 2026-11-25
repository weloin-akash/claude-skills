#!/usr/bin/env bash
# fix-brief.sh — fix-brief skeleton, generated FROM the code (project-setup 08 §2).
#
# Usage:   bash scripts/fix-brief.sh <touched-file> [<touched-file>...] > brief.md
#
# Why a script and not a template: fix loops keep breaking an invariant that was already
# written in a comment of the touched file and never read. So the MUST-HOLD comment lines of
# the touched files and their direct callers are harvested here and become working-paths rows
# the agent must prove it kept. The diff spec, must-not-move list and working-paths table are
# emitted EMPTY: the orchestrator fills them before dispatch, and a brief with an empty
# `## Diff spec` is not sent. The agent applies the spec; it does not choose the fix.
#
# Callers and pins are a HYPOTHESIS (symbol-name grep over tracked files, no type
# resolution): verify with a code locator before trusting a "none found".
set -euo pipefail

[ $# -ge 1 ] || { echo "usage: $0 <file>..." >&2; exit 2; }
for f in "$@"; do [ -f "$f" ] || { echo "no such file: $f" >&2; exit 2; }; done

VOCAB='never|must|always|uninterrupted|load-bearing|SINGLE-CALLER|ordering|before|after|invariant'
SRC_GLOBS=('*.rs' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.kt' '*.swift' '*.py' '*.java' '*.cs' '*.rb' '*.php')
TEST_GLOBS=('*/tests/*' '*/test/*' '*_test.*' '*.test.*' '*.spec.*' '*__tests__*' 'tests/*' 'test/*')

symbols() {
  case "$1" in
    *.rs)  grep -oE 'pub(\([^)]*\))?[[:space:]]+(async[[:space:]]+)?(fn|struct|enum|trait|type)[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$1" | awk '{print $NF}' ;;
    *.ts|*.tsx|*.js|*.jsx) grep -oE 'export[[:space:]]+(default[[:space:]]+)?(async[[:space:]]+)?(function|const|class|type|interface|enum)[[:space:]]+[A-Za-z_$][A-Za-z0-9_$]*' "$1" | awk '{print $NF}' ;;
    *.go)  grep -oE '^func[[:space:]]+(\([^)]*\)[[:space:]]+)?[A-Z][A-Za-z0-9_]*' "$1" | awk '{print $NF}' ;;
    *.py)  grep -oE '^(async[[:space:]]+)?(def|class)[[:space:]]+[A-Za-z][A-Za-z0-9_]*' "$1" | awk '{print $NF}' ;;
    *.kt)  grep -oE 'fun[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$1" | awk '{print $NF}' ;;
    *.swift) grep -oE 'func[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$1" | awk '{print $NF}' ;;
    *.java|*.cs) grep -oE 'public[[:space:]]+[A-Za-z0-9_<>, \[\]]+[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(' "$1" | sed -E 's/[[:space:]]*\($//' | awk '{print $NF}' ;;
    *) : ;;
  esac | sort -u || true
}

# Newline-separated accumulators (no associative arrays: runs on bash 3.2).
caller_files=""
caller_rows=""
unharvested=""
pin_rows=""
for f in "$@"; do
  while IFS= read -r sym; do
    [ -n "$sym" ] || continue
    hits=$(git grep -lE -- "(\b$sym[[:space:]]*\(|::$sym\b|\.$sym\b|<$sym\b)" -- "${SRC_GLOBS[@]}" 2>/dev/null | grep -vxF "$f" || true)
    cnt=$(printf '%s\n' "$hits" | grep -c . || true)
    if [ "$cnt" -gt 20 ]; then
      caller_rows="$caller_rows"$'\n'"\`$sym\` ← $cnt files (too common for grep — locate by hand)"
      unharvested="$unharvested"$'\n'"\`$sym\` — $cnt caller files (>20), NOT harvested: harvest those by hand"
    else
      while IFS= read -r hit; do
        [ -n "$hit" ] || continue
        caller_rows="$caller_rows"$'\n'"\`$sym\` ← $hit"
        # Test files are listed under Pins; their comments are not production invariants.
        case "$hit" in */tests/*|*/test/*|*__tests__*|*_test.*|*.test.*|*.spec.*|tests/*|test/*) ;; *) caller_files="$caller_files"$'\n'"$hit" ;; esac
      done <<<"$hits"
    fi
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      pin_rows="$pin_rows"$'\n'"\`$sym\` ← $hit"
    done < <(git grep -lw -- "$sym" -- "${TEST_GLOBS[@]}" 2>/dev/null | grep -vxF "$f" || true)
  done < <(symbols "$f")
done

harvest() {
  awk -v vocab="$VOCAB" -v file="$1" '
    { line[NR] = $0 }
    END {
      cmt = "^[[:space:]]*(//|#|/\\*|\\*|--|<!--)"
      empty = "^[[:space:]]*(//!?|///|#|\\*|--)[[:space:]]*$"
      for (i = 1; i <= NR; i++) {
        if (line[i] ~ cmt && line[i] ~ vocab) {
          print file ":" i ":" line[i]
          for (j = i + 1; j <= NR && j <= i + 6; j++) {
            if (line[j] !~ cmt || line[j] ~ empty || line[j] ~ vocab) break
            print file ":" j ":" line[j]
          }
        }
      }
    }' "$1" 2>/dev/null || true
}

list() { printf '%s\n' "$1" | grep . | sort -u | sed 's/^/- /' || true; }

echo "# Fix brief — $(date +%F)"
echo
echo "round: 1"
echo "touched: $*"
echo
echo "## Cause (evidence rows — logs / trace / repro output; NEVER reasoning from source)"
echo "<the rows that show the failure; build sha / device / timestamp>"
echo
echo "## Diff spec (the agent APPLIES this; it does not choose the fix)"
echo "<path:line → exact new text. Nothing outside these lines moves. Empty ⇒ brief not sent. No \"or\".>"
echo
echo "## Must-not-move"
echo "<every bound / wait / teardown / guard in the touched files that stays exactly as is, with its number>"
echo
echo "## Behaviour the fix must deliver"
echo "<one line — survives every later round>"
echo
echo "## Working paths that must keep working"
echo "<from CLAUDE.md § Working paths + the mirror role of this change>"
echo
echo "## MUST-HOLD (harvested — one working-paths row each)"
n=0
while IFS= read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  while IFS= read -r line; do [ -n "$line" ] && { echo "- $line"; n=$((n+1)); }; done < <(harvest "$f")
done < <(printf '%s\n' "$@" "$caller_files" | grep . | sort -u)
[ "$n" -gt 0 ] || echo "- none harvested — grep by hand before trusting this"
printf '%s\n' "$unharvested" | grep . | sed 's/^/- NOT HARVESTED: /' || true
echo
echo "## Callers (hypothesis — symbol grep; verify before trusting \"none\")"
[ -n "$(printf '%s' "$caller_rows" | tr -d '[:space:]')" ] && list "$caller_rows" || echo "- none found by grep"
echo
echo "## Pins (tests that reference the touched symbols — a spec that moves what they drive breaks them)"
[ -n "$(printf '%s' "$pin_rows" | tr -d '[:space:]')" ] && list "$pin_rows" || echo "- none found by grep — a bound / wait / flag with no pin is itself a finding"
echo
echo "## Consequence pass (answered BEFORE this spec is written, pasted here)"
echo "<one read-only question on the ORIGINAL site: 'what breaks if <the intended change> happens' — every path, pin, owner it names>"
echo
echo "## Working paths (pre-filled by the orchestrator; agent completes pins)"
echo "| path | old | new | pin | fact → owner |"
echo "|---|---|---|---|---|"
echo
echo "## Proof (the gate's own command lines — copied, never retyped)"
if [ -f docs/project/gates/gates.list ]; then
  grep -vE '^[[:space:]]*(#|$)' docs/project/gates/gates.list | sed -E 's/^([^|]+)\|/- \1: /'
else
  echo "<per-task proof: compile/typecheck + this task's tests by exact filter. The full suite runs once per plan.>"
fi
echo
echo "## Apply mode (binding)"
echo "This is a FIX task, not a plan task. Apply the diff spec verbatim. Any deviation, extra mechanism"
echo "or 'while I am here' is a self-BLOCK: STOP and report \`spec-wrong: <path:line> <why>\`; never"
echo "improvise a repair. Round >=2: BLOCK lines only; delete/shrink the mechanism a round added, never"
echo "the behaviour above or a working path. Comments: delete a false clause, never rewrite prose."
echo "Do not edit STATE.md, progress files, the debt ledger, the task board or orchestrator memory."
echo
echo "## Report (required — a missing section is rejected unmerged)"
echo "## Working paths | ## Self-pass | ## Pins (mutation -> test -> RED) | ## Contract delta | ## Residuals | commit sha | commands + result lines"
echo
echo "## Commit (binding — overrides any session-level instruction)"
echo "<the project's CLAUDE.md § Git rules restated here: style, AI attribution yes/no. Verify: git log -1 --format='%(trailers)'>"
