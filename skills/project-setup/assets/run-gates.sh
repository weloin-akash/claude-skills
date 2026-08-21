#!/usr/bin/env bash
# run-gates.sh — gate runner (project-setup 06 §5b evidence discipline, mechanized).
#
# Usage:   run-gates.sh <group-name> [gates-file]
# gates-file (default docs/project/gates/gates.list), one gate per line:
#   <id>|<command...>
#   e.g.  rust-clippy|cargo clippy --workspace --all-targets -- -D warnings
#         go-vet|go vet ./...
# Lines starting with # and blank lines are ignored.
#
# Behavior (do not weaken — these ARE the rules):
#   * Every gate's full output is captured to docs/project/gates/evidence/<group>-<id>.log
#     — verdicts come from exit codes read directly, never from piped output.
#   * A gate whose command binary is missing is a FAIL, not a skip (missing toolchain = FAIL).
#   * Exit status is non-zero if ANY gate failed. Summary table on stdout.
set -u

GROUP="${1:?usage: run-gates.sh <group-name> [gates-file]}"
LIST="${2:-docs/project/gates/gates.list}"
EVID="docs/project/gates/evidence"
mkdir -p "$EVID"

[ -f "$LIST" ] || { echo "FAIL: gates file '$LIST' not found"; exit 2; }

overall=0
printf '%-24s %-6s %s\n' "GATE" "VERDICT" "EVIDENCE"
while IFS='|' read -r id cmd; do
  case "$id" in ''|\#*) continue ;; esac
  log="$EVID/${GROUP}-${id}.log"
  bin="${cmd%% *}"
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "missing toolchain: '$bin' not on PATH" > "$log"
    printf '%-24s %-6s %s\n' "$id" "FAIL" "$log (missing toolchain)"
    overall=1
    continue
  fi
  if bash -c "$cmd" > "$log" 2>&1; then
    printf '%-24s %-6s %s\n' "$id" "PASS" "$log"
  else
    printf '%-24s %-6s %s\n' "$id" "FAIL" "$log (exit $?)"
    overall=1
  fi
done < "$LIST"

exit $overall
