#!/usr/bin/env bash
# Verify hosted assets for investor update email return HTTP 200.
set -euo pipefail

BASE="https://www.evolutionstables.nz/updates"
ASSETS=(
  "evolution-stables-logo-header.jpg"
  "EvolutionStables-Mono-White.png"
  "AB_Signiture.png"
)

HERO="${1:-}"
if [[ -n "$HERO" ]]; then
  ASSETS+=("$HERO")
fi

FAIL=0
for f in "${ASSETS[@]}"; do
  code=$(curl -sI "${BASE}/${f}" | head -1 | awk '{print $2}')
  if [[ "$code" == "200" ]]; then
    echo "OK  ${f}"
  else
    echo "FAIL ${f} (HTTP ${code:-none})"
    FAIL=1
  fi
done

exit "$FAIL"