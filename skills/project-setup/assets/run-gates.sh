#!/usr/bin/env bash
# run-gates.sh — gate runner (project-setup 06 §5b evidence discipline, mechanized).
#
# Usage:   bash scripts/run-gates.sh <group-name> [gates-file]
# gates-file (default docs/project/gates/gates.list), one gate per line:
#   <id>|<command...>
#   e.g.  rust-clippy|cargo clippy --workspace --all-targets -- -D warnings
#         go-vet|go vet ./...
# ids: [A-Za-z0-9._-] only. Lines starting with # and blank lines are ignored.
#
# Behavior (do not weaken — these ARE the rules):
#   * Every gate's full output is captured to docs/project/gates/evidence/<group>-<id>.log
#     — verdicts come from exit codes read directly, never from piped output.
#   * Commands run with pipefail and stdin closed (a stdin-reading gate must not
#     swallow the remaining list).
#   * A gate whose command binary is missing is a FAIL, not a skip (missing toolchain = FAIL).
#   * Exit status is non-zero if ANY gate failed. Summary table on stdout.
set -u

GROUP="${1:?usage: run-gates.sh <group-name> [gates-file]}"
LIST="${2:-docs/project/gates/gates.list}"
EVID="docs/project/gates/evidence"

case "$GROUP" in *[!A-Za-z0-9._-]*|'') echo "FAIL: group name must be [A-Za-z0-9._-]"; exit 2 ;; esac
[ -f "$LIST" ] || { echo "FAIL: gates file '$LIST' not found"; exit 2; }
mkdir -p "$EVID"

overall=0
printf '%-24s %-6s %s\n' "GATE" "VERDICT" "EVIDENCE"
# `|| [ -n "$id" ]` keeps a final line without trailing newline from being dropped.
while IFS='|' read -r id cmd || [ -n "${id:-}" ]; do
  # strip CR (CRLF files) and surrounding whitespace from id
  id="${id%$'\r'}"; cmd="${cmd%$'\r'}"
  id="${id#"${id%%[![:space:]]*}"}"; id="${id%"${id##*[![:space:]]}"}"
  case "$id" in ''|\#*) continue ;; esac
  case "$id" in *[!A-Za-z0-9._-]*)
    printf '%-24s %-6s %s\n' "$id" "FAIL" "(invalid gate id — allowed: A-Za-z0-9._-)"
    overall=1; continue ;;
  esac
  log="$EVID/${GROUP}-${id}.log"
  # Toolchain probe only when the first word is a plain command name;
  # env-prefixed / subshell / complex commands just run (their own failure is the verdict).
  bin="${cmd%% *}"
  if [ -n "$bin" ] && [[ "$bin" =~ ^[A-Za-z0-9_./-]+$ ]] && ! command -v "$bin" >/dev/null 2>&1; then
    echo "missing toolchain: '$bin' not on PATH" > "$log"
    printf '%-24s %-6s %s\n' "$id" "FAIL" "$log (missing toolchain)"
    overall=1
    continue
  fi
  if bash -c "set -o pipefail; $cmd" < /dev/null > "$log" 2>&1; then
    printf '%-24s %-6s %s\n' "$id" "PASS" "$log"
  else
    rc=$?
    printf '%-24s %-6s %s\n' "$id" "FAIL" "$log (exit $rc)"
    overall=1
  fi
done < "$LIST"

exit $overall
