#!/usr/bin/env bash
# Render every blueprint to docs/blueprint/. With --check, fail if the committed
# documents differ from what the Lean sources produce. Run after `lake build`.
set -euo pipefail
cd "$(dirname "$0")/.."

lake env lean scripts/GenerateBlueprints.lean

if [ "${1:-}" = "--check" ]; then
  if ! git diff --exit-code -- docs/blueprint || [ -n "$(git status --porcelain -- docs/blueprint)" ]; then
    echo "FAIL  docs/blueprint is out of date: run scripts/blueprint.sh and commit the result"
    exit 1
  fi
  echo "ok    docs/blueprint matches the Lean sources"
fi
