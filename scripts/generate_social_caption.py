#!/usr/bin/env python3
"""Generate X caption text from an investor-update JSON slug."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

COMMS_ROOT = Path(__file__).resolve().parents[1]
INBOX = COMMS_ROOT / "inbox"
TEMPLATES = Path(__file__).resolve().parents[3] / "studio" / "legacy" / "templates"

PARTNER_TAGS = "@WexfordStables @BAXLTD @Tokinvest_Cap"


def load_json(slug: str) -> dict:
    candidates = [
        INBOX / f"{slug}.json",
        TEMPLATES / f"{slug}.json",
        INBOX / slug / "update.json",
    ]
    for path in candidates:
        if path.exists():
            return json.loads(path.read_text(encoding="utf-8"))
    raise FileNotFoundError(f"No JSON found for slug '{slug}' in inbox or templates")


def parse_race_facts(race_facts: dict) -> tuple[str, str, str]:
    date = race_facts.get("date", "")
    race = race_facts.get("race", "")
    distance = race_facts.get("distance", "")

    day = "Saturday"
    if re.search(r"sat", date, re.I):
        day = "Saturday"
    elif re.search(r"sun", date, re.I):
        day = "Sunday"
    elif re.search(r"fri", date, re.I):
        day = "Friday"

    race_bits = [bit.strip() for bit in race.split("·") if bit.strip()]
    race_label = " · ".join(race_bits) if race_bits else race.strip()

    dist_match = re.search(r"(\d+m)", distance, re.I)
    dist = dist_match.group(1) if dist_match else distance.split("·")[0].strip()

    return day, race_label, dist


def extract_venue(data: dict) -> str:
    subject = data.get("subject", "")
    match = re.search(r"\|\s*([^,|]+),", subject)
    if match:
        return match.group(1).strip()
    body = data.get("body_2", "")
    venue_match = re.search(r"at\s+([A-Za-z]+)", body)
    return venue_match.group(1) if venue_match else "Tauranga"


def extract_barrier_weight_jockey(data: dict) -> tuple[str, str, str]:
    body = data.get("body_2", "")
    barrier = "Barrier 1"
    weight = "54.0kg"
    jockey = "Masa Hashizume"

    barrier_match = re.search(r"Barrier\s+(\d+)", body, re.I)
    if barrier_match:
        barrier = f"Barrier {barrier_match.group(1)}"

    weight_match = re.search(r"(\d+\.?\d*kg)", body, re.I)
    if weight_match:
        weight = weight_match.group(1)
        if "minimum" in body.lower():
            weight = f"{weight} (minimum weight)"

    jockey_match = re.search(r"([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)\s+is booked", body)
    if jockey_match:
        jockey = jockey_match.group(1)

    return barrier, weight, jockey


def hook_line(data: dict) -> str:
    before = data.get("headline_before", "").strip()
    emphasis = data.get("headline_emphasis", "").strip()
    after = data.get("headline_after", "").strip()
    if before and emphasis:
        return f"{before} {emphasis.lower()} {after}".strip().rstrip(".") + "."
    return "Race day."


def body_line(data: dict, venue: str) -> str:
    subhead = data.get("subhead", "").strip()
    if subhead:
        first = subhead.split(".")[0].strip()
        if first:
            return first + ("." if not first.endswith(".") else "")
    horse = data.get("horse", "She")
    return f"{horse} returns to {venue} Saturday — recovered, sharp in her work, and ready for a big day!"


def nomination_line(data: dict, race_label: str, dist: str) -> str:
    body = data.get("body_2", "")
    if re.search(r"nominated", body, re.I):
        nom_match = re.search(r"nominated[^.]*", body, re.I)
        if nom_match:
            return f"🏁 {nom_match.group(0).strip()}"
    return f"🏁 {race_label} · {dist}"


def build_caption(data: dict) -> str:
    horse = data.get("horse", "Prudentia")
    venue = extract_venue(data)
    tab_url = data.get("tab_url", "").strip()
    race_facts = data.get("race_facts", {})
    day, race_label, dist = parse_race_facts(race_facts)
    barrier, weight, jockey = extract_barrier_weight_jockey(data)

    lines = [
        hook_line(data),
        "",
        body_line(data, venue),
        "",
        f"📍 {venue}",
        f"🕓 {day}",
        nomination_line(data, race_label, dist),
        f"⚖️ {weight}",
        f"🎯 {barrier}",
        f"👤 {jockey}",
    ]
    if tab_url:
        lines.extend(["", f"🔗 Race updates → {tab_url}", "", PARTNER_TAGS])
    else:
        lines.extend(["", PARTNER_TAGS])

    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate X caption from investor JSON")
    parser.add_argument("slug", help="Update slug (e.g. prudentia_update_27june2026)")
    parser.add_argument(
        "-o",
        "--output",
        help="Output path (default: inbox/social_{slug}/x_caption.txt)",
    )
    args = parser.parse_args()

    try:
        data = load_json(args.slug)
    except FileNotFoundError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    caption = build_caption(data)
    out = (
        Path(args.output)
        if args.output
        else INBOX / f"social_{args.slug.replace('_update', '')}" / "x_caption.txt"
    )
    if not args.output and not out.parent.exists():
        social_slug = args.slug.replace("_update", "")
        out = INBOX / f"social_{social_slug}" / "x_caption.txt"

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(caption + "\n", encoding="utf-8")
    print(f"Wrote {out} ({len(caption)} chars)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())