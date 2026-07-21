#!/usr/bin/env bash
# PostToolUse (Edit|Write): format Dart files under packages/ apps/ lib/ test/.
# Advisory only — never blocks the edit (always exits 0).
set -uo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import sys, json
try:
    print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))
except Exception:
    print("")' 2>/dev/null || true)"

# Only Dart files.
case "$file" in
  *.dart) ;;
  *) exit 0 ;;
esac

# Only inside project source dirs (skip skill templates, scratchpad, etc.).
case "$file" in
  */packages/*|*/apps/*|*/lib/*|*/test/*) ;;
  *) exit 0 ;;
esac

command -v dart >/dev/null 2>&1 || exit 0
[ -f "$file" ] || exit 0

dart format "$file" >/dev/null 2>&1 || true
exit 0
