#!/usr/bin/env bash
# Every module under Canteen/ must be imported by Canteen.lean, so that it is
# built, tested and covered by the axiom audit.
set -uo pipefail
cd "$(dirname "$0")/.."

status=0
while IFS= read -r f; do
  mod=$(sed -e 's#\.lean$##' -e 's#/#.#g' <<<"$f")
  if ! grep -qxF "import $mod" Canteen.lean; then
    echo "FAIL  $f is not imported by Canteen.lean"
    status=1
  fi
done < <(find Canteen -name '*.lean' | sort)
[ $status -eq 0 ] && echo "ok    every module under Canteen/ is imported by Canteen.lean"
exit $status
