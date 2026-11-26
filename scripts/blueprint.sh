#!/usr/bin/env bash
# Render every blueprint to docs/blueprint/ and every graph page to docs/graphs/.
# With --check, fail if the committed
# documents differ from what the Lean sources produce. Run after `lake build`.
set -euo pipefail
cd "$(dirname "$0")/.."

lake env lean scripts/GenerateBlueprints.lean

if [ "${1:-}" = "--check" ]; then
  if ! git diff --exit-code -- docs/blueprint docs/graphs || [ -n "$(git status --porcelain -- docs/blueprint docs/graphs)" ]; then
    echo "FAIL  docs/blueprint or docs/graphs is out of date: run scripts/blueprint.sh and commit the result"
    exit 1
  fi
  echo "ok    docs/blueprint and docs/graphs match the Lean sources"
fi
