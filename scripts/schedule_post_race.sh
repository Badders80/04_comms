#!/usr/bin/env bash
# Schedule thin post-race auto-send ~10 min after race time (one-shot `at` job).
# Usage: schedule_post_race.sh <horse_slug> --pre-race-slug <slug> [--delay-min 10]
set -euo pipefail

COMMS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HORSE="${1:?Usage: schedule_post_race.sh <horse_slug> --pre-race-slug <slug> [--delay-min 10]}"
shift

PRE_RACE_SLUG=""
TAB_URL_OVERRIDE=""
RACE_AT_OVERRIDE=""
DELAY_MIN=10

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pre-race-slug) PRE_RACE_SLUG="${2:?}"; shift 2 ;;
    --tab-url) TAB_URL_OVERRIDE="${2:?}"; shift 2 ;;
    --race-at) RACE_AT_OVERRIDE="${2:?}"; shift 2 ;;
    --delay-min) DELAY_MIN="${2:?}"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

JSON=""
if [[ -n "$PRE_RACE_SLUG" ]]; then
  JSON="$COMMS/../../studio/legacy/templates/${PRE_RACE_SLUG}.json"
  if [[ ! -f "$JSON" ]]; then
    JSON=""
  fi
fi

if [[ -z "$JSON" && -z "$TAB_URL_OVERRIDE" ]]; then
  echo "Error: need --pre-race-slug (with JSON in pipelines/studio/legacy/templates/) or --tab-url + --race-at" >&2
  exit 1
fi

PARSED="$(python3 - "$JSON" "$DELAY_MIN" "$TAB_URL_OVERRIDE" "$RACE_AT_OVERRIDE" <<'PY'
import json, re, sys
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

path, delay, tab_override, race_at_override = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
if tab_override and race_at_override:
    send_at = datetime.fromisoformat(race_at_override)
    if send_at.tzinfo is None:
        send_at = send_at.replace(tzinfo=ZoneInfo("Pacific/Auckland"))
    send_at = send_at + timedelta(minutes=delay)
    print(json.dumps({
        "tab_url": tab_override,
        "race_at": race_at_override,
        "send_at": send_at.isoformat(),
        "send_at_local": send_at.strftime("%Y-%m-%d %H:%M %Z"),
        "at_spec": send_at.strftime("%H:%M %d %b %Y"),
    }))
    sys.exit(0)

if not path:
    print("MISSING_TAB")
    sys.exit(0)

data = json.load(open(path))
tab_url = (data.get("tab_url") or "").strip()
if not tab_url:
    print("MISSING_TAB")
    sys.exit(0)

facts = data.get("race_facts") or {}
date_txt = facts.get("date", "")
dist = facts.get("distance", "")
m = re.search(r"(\d{1,2}:\d{2})\s*(am|pm)", dist, re.I)
if not m:
    print("MISSING_TIME")
    sys.exit(0)
hour, minute = map(int, m.group(1).split(":"))
ampm = m.group(2).lower()
if ampm == "pm" and hour != 12:
    hour += 12
elif ampm == "am" and hour == 12:
    hour = 0

dm = re.search(r"(\d{1,2})\s+(\w{3})", date_txt)
if not dm:
    print("MISSING_DATE")
    sys.exit(0)
day = int(dm.group(1))
mon = dm.group(2).title()

year = None
slug = data.get("slug", "")
ym = re.search(r"(\d{4})", slug)
if ym:
    year = int(ym.group(1))
else:
    md = data.get("masthead", {}).get("date", "")
    if md:
        year = int(md.split(".")[-1])
if not year:
    year = datetime.now().year

tz = ZoneInfo("Pacific/Auckland")
race_at = datetime.strptime(f"{day} {mon} {year} {hour:02d}:{minute:02d}", "%d %b %Y %H:%M").replace(tzinfo=tz)
send_at = race_at + timedelta(minutes=delay)

print(json.dumps({
    "tab_url": tab_url,
    "race_at": race_at.isoformat(),
    "send_at": send_at.isoformat(),
    "send_at_local": send_at.strftime("%Y-%m-%d %H:%M %Z"),
    "at_spec": send_at.strftime("%H:%M %d %b %Y"),
}))
PY
)"

if [[ "$PARSED" == "MISSING_TAB" ]]; then
  echo "Error: pre-race JSON has no tab_url — add it before scheduling." >&2
  exit 2
fi
if [[ "$PARSED" == "MISSING_TIME" || "$PARSED" == "MISSING_DATE" ]]; then
  echo "Error: could not parse race time from race_facts in $JSON" >&2
  exit 2
fi

TAB_URL="$(echo "$PARSED" | python3 -c "import sys,json; print(json.load(sys.stdin)['tab_url'])")"
SEND_AT="$(echo "$PARSED" | python3 -c "import sys,json; print(json.load(sys.stdin)['send_at_local'])")"
AT_SPEC="$(echo "$PARSED" | python3 -c "import sys,json; print(json.load(sys.stdin)['at_spec'])")"
RACE_AT="$(echo "$PARSED" | python3 -c "import sys,json; print(json.load(sys.stdin)['race_at'])")"

if ! command -v at >/dev/null 2>&1; then
  echo "Warning: 'at' not installed. Queue saved; run manually after race:" >&2
  echo "  just post-race-auto $HORSE --pre-race-slug $PRE_RACE_SLUG" >&2
  SCHEDULED_VIA="manual"
else
  JOB_CMD="cd $COMMS && POST_RACE_DELAY_MIN=$DELAY_MIN ./scripts/run_post_race_auto.sh $HORSE --pre-race-slug $PRE_RACE_SLUG >> $COMMS/inbox/post_race_auto.log 2>&1"
  echo "$JOB_CMD" | TZ=Pacific/Auckland at "$AT_SPEC"
  SCHEDULED_VIA="at"
fi

QUEUE="$COMMS/inbox/post_race_queue.json"
python3 - "$HORSE" "$PRE_RACE_SLUG" "$TAB_URL" "$RACE_AT" "$SEND_AT" "$SCHEDULED_VIA" "$QUEUE" <<'PY'
import json, sys
from datetime import datetime, timezone
horse, pre_slug, tab, race_at, send_at, via, path = sys.argv[1:]
try:
    data = json.load(open(path))
except FileNotFoundError:
    data = {"pending": [], "log": []}
entry = {
    "horse_slug": horse,
    "pre_race_slug": pre_slug,
    "tab_url": tab,
    "race_at": race_at,
    "send_at": send_at,
    "status": "scheduled",
    "scheduled_via": via,
    "queued_at": datetime.now(timezone.utc).isoformat(),
}
data.setdefault("pending", []).append(entry)
json.dump(data, open(path, "w"), indent=2)
open(path, "a").write("\n")
PY

echo "Scheduled post-race auto-send for $HORSE"
echo "  Race:    $RACE_AT"
echo "  Send at: $SEND_AT (+${DELAY_MIN} min)"
echo "  TAB:     $TAB_URL"
if [[ "$SCHEDULED_VIA" == "at" ]]; then
  echo "  Job:     at queue (check with: atq)"
fi