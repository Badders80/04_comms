# Canva Social Master — DAHNpr1STP4

**Edit URL:** https://www.canva.com/design/DAHNpr1STP4/Lae-YwKvf-E3w7CzMy1B_g/edit

**Brand kit:** `kAFBk5Zb2X4`

**Post format:** Single image — export **page 1 only** at 1080×1350 PNG.

---

## Copy workflow

1. `copy-design` with `design_id: DAHNpr1STP4`
2. Rename via `update_title` → `{Horse} — {Venue} {Date}`

---

## Standard text replacements (find_and_replace_text)

| Find | Replace with |
|------|----------------|
| `Stable Update` | `Next Up` |
| `TE RAPA` / `Te Rapa` | `{VENUE}` uppercase |
| `MASA HASBIZUNE` | `MASA HASHIZUME` |
| Horse name in headline block | `{HORSE}` uppercase |
| Telemetry line | `{DIST}M \| {VENUE} \| {BENCHMARK}` |

Pull `{VENUE}`, `{DIST}`, `{BENCHMARK}` from investor JSON `race_facts`.

---

## Hero image

1. `upload-asset-from-url` with hosted hero:
   `https://www.evolutionstables.nz/updates/{hero_image}`
2. `get-assets` on page 1 fills if multiple images — pick full-bleed hero
3. `update_fill` with uploaded `asset_id`

---

## Export

```json
{
  "design_id": "{copy_id}",
  "format": {
    "type": "png",
    "pages": [1],
    "width": 1080,
    "height": 1350,
    "export_quality": "pro"
  }
}
```

Download export URL → `poster.png`.

---

## Legacy masters (do not copy for new work)

| ID | Notes |
|----|-------|
| `DAHLfddH_NM` | 3-slide; superseded |
| `DAHK6p1wPsM` | 8-slide carousel |
| `DAHMNxfVSSc` | 1-page alternate |