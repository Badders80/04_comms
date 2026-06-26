#!/usr/bin/env bash
# Push investor update HTML to Gmail as a draft via gws (same path as googleworkspace MCP).
set -euo pipefail

HTML="${1:?Usage: push_investor_update_draft.sh <html-file> <subject> [--send-draft-id ID]}"
SUBJECT="${2:?Subject required}"

if ! command -v gws >/dev/null 2>&1; then
  echo "Error: gws not installed. Run: npm install -g @googleworkspace/cli" >&2
  exit 1
fi

HTML_BODY=$(cat "$HTML")

echo "Creating Gmail draft for alex@evolutionstables.nz ..."
OUT=$(gws gmail +send \
  --to "alex@evolutionstables.nz" \
  --subject "$SUBJECT" \
  --body "$HTML_BODY" \
  --html \
  --draft 2>&1)

echo "$OUT"

DRAFT_ID=$(echo "$OUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null || true)

if [[ -n "$DRAFT_ID" ]]; then
  echo ""
  echo "Draft ready. Open Gmail → Drafts → add BCC → Send."
  echo "Or send from CLI:"
  echo "  gws gmail users.drafts.send --body '{\"id\":\"${DRAFT_ID}\"}'"
fi

if [[ "${3:-}" == "--send-draft-id" && -n "${4:-}" ]]; then
  echo "Sending draft ${4} ..."
  gws gmail users.drafts.send --body "{\"id\":\"${4}\"}"
  echo "Sent."
fi