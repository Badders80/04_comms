#!/usr/bin/env bash
# Deploy hosted HTML + assets, verify URLs, push Gmail draft — one shot.
set -euo pipefail

SLUG="${1:?Usage: ship_investor_update.sh <slug> <subject> [--horse slug] [hero-asset ...]}"
SUBJECT="${2:?Subject required}"
shift 2

HORSE=""
ASSETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --horse)
      HORSE="${2:?--horse requires slug}"
      shift 2
      ;;
    *)
      ASSETS+=("$1")
      shift
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEND_HTML="$SCRIPT_DIR/../inbox/${SLUG}_email_SEND.html"
HOSTED_HTML="/home/evo/evo_01/02_website/public/updates/${SLUG}_email.html"

if [[ ! -f "$SEND_HTML" ]]; then
  echo "Error: missing send file: $SEND_HTML" >&2
  exit 1
fi

if [[ ! -f "$HOSTED_HTML" ]]; then
  echo "Error: missing hosted file: $HOSTED_HTML" >&2
  echo "Build both SEND + hosted HTML before shipping." >&2
  exit 1
fi

"$SCRIPT_DIR/deploy_investor_update_assets.sh" "$SLUG" "${ASSETS[@]}"

PUSH_ARGS=("$SEND_HTML" "$SUBJECT")
if [[ -n "$HORSE" ]]; then
  PUSH_ARGS+=(--horse "$HORSE")
fi
"$SCRIPT_DIR/push_investor_update_draft.sh" "${PUSH_ARGS[@]}"

echo ""
echo "Done. Check Gmail → Drafts → review → Send."
echo "Preview: https://www.evolutionstables.nz/updates/${SLUG}_email.html"