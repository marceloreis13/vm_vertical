#!/usr/bin/env bash
# Stop hook: run `dart analyze` once per turn as an advisory check.
# Never blocks (always exits 0). No-ops when dart is missing or no pubspec.
set -uo pipefail

command -v dart >/dev/null 2>&1 || exit 0
[ -f pubspec.yaml ] || exit 0

out="$(dart analyze 2>&1 || true)"
if printf '%s' "$out" | grep -qiE '(error|warning) '; then
  echo "dart analyze found issues:"
  printf '%s\n' "$out" | grep -iE '(error|warning) ' | head -20
fi
exit 0
