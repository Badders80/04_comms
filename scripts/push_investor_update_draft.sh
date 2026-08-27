#!/usr/bin/env bash
# Push investor update HTML to Gmail as a draft via gws (same path as googleworkspace MCP).
set -euo pipefail

HTML="${1:?Usage: push_investor_update_draft.sh <html-file> <subject> [--horse slug] [--send-draft-id ID]}"
SUBJECT="${2:?Subject required}"
shift 2

HORSE=""
SEND_DRAFT_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --horse)
      HORSE="${2:?--horse requires slug}"
      shift 2
      ;;
    --send-draft-id)
      SEND_DRAFT_ID="${2:?--send-draft-id requires id}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

GWS=""
if command -v gws >/dev/null 2>&1; then
  GWS="gws"
elif npx gws --version >/dev/null 2>&1; then
  GWS="npx gws"
elif npx -p @googleworkspace/cli gws --version >/dev/null 2>&1; then
  GWS="npx -p @googleworkspace/cli gws"
else
  echo "Error: gws not installed and not runnable via npx. Run: npm install -g @googleworkspace/cli" >&2
  exit 1
fi

BCC_LIST=""
if [[ -n "$HORSE" ]]; then
  BCC_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/inbox/bcc_lists/${HORSE}.json"
  if [[ ! -f "$BCC_FILE" ]]; then
    echo "Error: no BCC list for horse '${HORSE}' (${BCC_FILE})" >&2
    exit 1
  fi
  BCC_LIST=$(python3 -c "import json; print(','.join(json.load(open('${BCC_FILE}'))['bcc']))")
  echo "BCC (${HORSE}): ${BCC_LIST}"
fi

HTML_BODY=$(cat "$HTML")

echo "Creating Gmail draft for alex@evolutionstables.nz ..."
GWS_ARGS=(
  gmail +send
  --to "alex@evolutionstables.nz"
  --subject "$SUBJECT"
  --body "$HTML_BODY"
  --html
  --draft
)
if [[ -n "$BCC_LIST" ]]; then
  GWS_ARGS+=(--bcc "$BCC_LIST")
fi

OUT=$($GWS "${GWS_ARGS[@]}" 2>&1)

echo "$OUT"

DRAFT_ID=$(echo "$OUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null || true)

if [[ -n "$DRAFT_ID" ]]; then
  echo ""
  if [[ -n "$BCC_LIST" ]]; then
    echo "Draft ready with BCC locked for ${HORSE}. Open Gmail → Drafts → review → Send."
  else
    echo "Draft ready. Open Gmail → Drafts → add BCC → Send."
  fi
  echo "Or send from CLI:"
  echo "  $GWS gmail users.drafts.send --body '{\"id\":\"${DRAFT_ID}\"}'"
fi

if [[ -n "$SEND_DRAFT_ID" ]]; then
  echo "Sending draft ${SEND_DRAFT_ID} ..."
  $GWS gmail users.drafts.send --body "{\"id\":\"${SEND_DRAFT_ID}\"}"
  echo "Sent."
fi