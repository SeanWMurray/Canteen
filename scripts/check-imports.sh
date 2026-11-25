#!/usr/bin/env bash
# Every module under TaxLean/ must be imported by TaxLean.lean, so that it is
# built, tested and covered by the axiom audit.
set -uo pipefail
cd "$(dirname "$0")/.."

status=0
while IFS= read -r f; do
  mod=$(sed -e 's#\.lean$##' -e 's#/#.#g' <<<"$f")
  if ! grep -qxF "import $mod" TaxLean.lean; then
    echo "FAIL  $f is not imported by TaxLean.lean"
    status=1
  fi
done < <(find TaxLean -name '*.lean' | sort)
[ $status -eq 0 ] && echo "ok    every module under TaxLean/ is imported by TaxLean.lean"
exit $status
