#!/usr/bin/env bash
# Thin post-race auto-send: TAB facts → build (no hero) → deploy → send investors.
# Usage: run_post_race_auto.sh <horse_slug> [--tab-url URL] [--pre-race-slug slug] [--to email] [--draft]
set -euo pipefail

COMMS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HORSE="${1:?Usage: run_post_race_auto.sh <horse_slug> [--tab-url URL] [--pre-race-slug slug] [--to email] [--draft]}"
shift

TAB_URL=""
PRE_RACE_SLUG=""
TO_OVERRIDE=""
DRAFT=0
DELAY_MIN="${POST_RACE_DELAY_MIN:-10}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tab-url) TAB_URL="${2:?}"; shift 2 ;;
    --pre-race-slug) PRE_RACE_SLUG="${2:?}"; shift 2 ;;
    --to) TO_OVERRIDE="${2:?}"; shift 2 ;;
    --draft) DRAFT=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

resolve_tab_url() {
  if [[ -n "$TAB_URL" ]]; then
    echo "$TAB_URL"
    return
  fi
  if [[ -n "$PRE_RACE_SLUG" ]]; then
    local json="$COMMS/../../studio/legacy/templates/${PRE_RACE_SLUG}.json"
    if [[ -f "$json" ]]; then
      python3 -c "import json,sys; d=json.load(open('$json')); print(d.get('tab_url',''))"
      return
    fi
  fi
  local queue="$COMMS/inbox/post_race_queue.json"
  if [[ -f "$queue" ]]; then
    python3 - "$HORSE" "$queue" <<'PY'
import json, sys
horse, path = sys.argv[1], sys.argv[2]
data = json.load(open(path))
for item in reversed(data.get("pending", [])):
    if item.get("horse_slug") == horse and item.get("status") == "scheduled":
        print(item.get("tab_url", ""))
        break
PY
  fi
}

TAB_URL="$(resolve_tab_url | tail -1 | tr -d '\n')"
if [[ -z "$TAB_URL" ]]; then
  echo "Error: no TAB race URL for '${HORSE}'." >&2
  echo "Provide --tab-url or ship pre-race with tab_url in JSON first." >&2
  exit 2
fi

HORSE_NAME="$(python3 -c "
import json
data = json.load(open('$COMMS/inbox/investor_update_registry.json'))
print(data['horses']['$HORSE']['name'].split('(')[0].strip())
")"

TRACK_SLUG="$(python3 -c "
from urllib.parse import urlparse
p = urlparse('$TAB_URL').path.strip('/').split('/')
print(p[1] if len(p) >= 2 else 'race')
")"

DATE_TAG="$(date +%d%b%Y | tr '[:upper:]' '[:lower:]')"
TAB_JSON="$COMMS/inbox/${HORSE}_tab_result_${DATE_TAG}.json"
SLUG="${HORSE}_${TRACK_SLUG}_result_${DATE_TAG}"

RACE_NO=""
if [[ -n "$PRE_RACE_SLUG" ]]; then
  PRE_JSON="$COMMS/../../studio/legacy/templates/${PRE_RACE_SLUG}.json"
  if [[ -f "$PRE_JSON" ]]; then
    RACE_NO="$(python3 -c "
import json, re
d = json.load(open('$PRE_JSON'))
race = (d.get('race_facts') or {}).get('race', '')
m = re.search(r'R(\d+)', race, re.I)
print(m.group(1) if m else '')
")"
  fi
fi

echo "TAB fetch: $TAB_URL"
"$COMMS/scripts/fetch_tab_race.py" "$TAB_URL" "$HORSE_NAME" -o "$TAB_JSON"

if ! python3 -c "import json; d=json.load(open('$TAB_JSON')); exit(0 if d.get('horse') else 1)"; then
  echo "Error: TAB has no result yet for $HORSE_NAME. Retry in ${DELAY_MIN} min." >&2
  exit 3
fi

SUBJECT="$(python3 -c "
import sys
sys.path.insert(0, '$COMMS/scripts')
from build_post_race_thin import subject_line
import json
print(subject_line(json.load(open('$TAB_JSON'))))
")"

SEND_DATE="$(date +%Y-%m-%d)"
MASTHEAD_OUT="$(cd "$COMMS" && ./scripts/investor_update_masthead.py reserve "$HORSE" \
  --date "$SEND_DATE" --slug "$SLUG" --subject "$SUBJECT")"
VOL="$(echo "$MASTHEAD_OUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['vol'])")"
NO="$(echo "$MASTHEAD_OUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['no'])")"
DATE_DISPLAY="$(echo "$MASTHEAD_OUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['date'])")"

BUILD_ARGS=("$COMMS/scripts/build_post_race_thin.py" "$TAB_JSON" "$SLUG" \
  --vol "$VOL" --no "$NO" --date "$DATE_DISPLAY")
if [[ -n "$RACE_NO" ]]; then
  BUILD_ARGS+=(--race-no "$RACE_NO")
fi
"${BUILD_ARGS[@]}"

"$COMMS/scripts/deploy_investor_update_assets.sh" "$SLUG"

SEND_HTML="$COMMS/inbox/${SLUG}_email_SEND.html"
HTML_BODY="$(cat "$SEND_HTML")"

if [[ -n "$TO_OVERRIDE" ]]; then
  TO="$TO_OVERRIDE"
  BCC_ARGS=()
else
  BCC_FILE="$COMMS/inbox/bcc_lists/${HORSE}.json"
  if [[ ! -f "$BCC_FILE" ]]; then
    echo "Error: no BCC list for $HORSE" >&2
    exit 1
  fi
  TO="alex@evolutionstables.nz"
  BCC_LIST="$(python3 -c "import json; print(','.join(json.load(open('$BCC_FILE'))['bcc']))")"
  BCC_ARGS=(--bcc "$BCC_LIST")
fi

GWS_ARGS=(
  gmail +send
  --from "alex@evolutionstables.nz"
  --to "$TO"
  --subject "$SUBJECT"
  --body "$HTML_BODY"
  --html
)
if [[ "${#BCC_ARGS[@]}" -gt 0 ]]; then
  GWS_ARGS+=("${BCC_ARGS[@]}")
fi
if [[ "$DRAFT" -eq 1 ]]; then
  GWS_ARGS+=(--draft)
fi

OUT="$(gws "${GWS_ARGS[@]}" 2>&1)"
echo "$OUT"

QUEUE="$COMMS/inbox/post_race_queue.json"
if [[ -f "$QUEUE" ]]; then
  python3 - "$HORSE" "$SLUG" "$QUEUE" <<'PY'
import json, sys
from datetime import datetime, timezone
horse, slug, path = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.load(open(path))
for item in data.get("pending", []):
    if item.get("horse_slug") == horse and item.get("status") == "scheduled":
        item["status"] = "sent"
        item["sent_slug"] = slug
        item["sent_at"] = datetime.now(timezone.utc).isoformat()
data.setdefault("log", []).append({"horse_slug": horse, "slug": slug, "at": datetime.now(timezone.utc).isoformat()})
json.dump(data, open(path, "w"), indent=2)
open(path, "a").write("\n")
PY
fi

echo ""
if [[ "$DRAFT" -eq 1 ]]; then
  echo "Post-race draft ready. Review in Gmail → Send."
else
  echo "Post-race update sent to investors."
fi
echo "Preview: https://www.evolutionstables.nz/updates/${SLUG}_email.html"