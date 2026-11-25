#!/usr/bin/env bash
# Every file in tests/should-fail/ must FAIL to compile, and its error output must
# contain the text on its first line ("-- expect: <text>"). This shows the
# validation harness catches broken rules and hidden gaps (design §6, roadmap Phase 2).
# Run after `lake build`.
set -uo pipefail
cd "$(dirname "$0")/.."

status=0
for f in tests/should-fail/*.lean; do
  expect=$(head -n 1 "$f" | sed -n 's/^-- expect: //p')
  if [ -z "$expect" ]; then
    echo "FAIL  $f: first line must be '-- expect: <text>'"
    status=1
    continue
  fi
  if out=$(lake env lean "$f" 2>&1); then
    echo "FAIL  $f: compiled, but it should have been rejected"
    status=1
  elif ! grep -qF -- "$expect" <<<"$out"; then
    echo "FAIL  $f: rejected, but the output does not mention '$expect':"
    sed 's/^/        /' <<<"$out"
    status=1
  else
    echo "ok    $f (rejected: mentions '$expect')"
  fi
done
exit $status
