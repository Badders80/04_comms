---
name: investor-update-pipeline
description: >
  End-to-end investor email production: classify Wexford ingest (pre-race, post-race,
  pivot, stable news), write Private Banker voice copy, build from locked HTML master,
  deploy to evolutionstables.nz, push Gmail draft via gws. Triggers: investor update,
  prerace, post-race, race preview, ingest wexford, draft investor update, stable update,
  campaign pivot, /investor-update.
---

# Investor Update Production Line

**Goal:** User says one sentence → agent replies **"Check your drafts."**

---

## Trigger → action map

| User says | Type | You do |
|-----------|------|--------|
| "ingest wexford emails and draft the **prerace** investor update" | A | Classify → copy → build → deploy → draft |
| "draft the **post-race** update for {Horse}" | B | **Simple:** result + what happened + TAB race link + optional pic. No tactical grid. Fetch TAB page if on the run. |
| "**withdrawal** / **pivot** update" | C | No race strip; 4 recovery cards; next target date |
| "**stable report**" / training only | D | Lighter structure |
| "investor update for {Horse}" (ambiguous) | ? | Read latest Wexford ingest → infer A/B/C/D → state type in one line → proceed |

**Do not ask** unless horse name or update type is genuinely unclear.

---

## Completion message (always)

When draft is created successfully, reply **only**:

> **Check your drafts.**  
> Subject: `{exact subject line}`  
> Add BCC → send.

Optionally add: hosted preview URL `https://www.evolutionstables.nz/updates/{slug}_email.html`

---

## Read first

1. `04_comms/strategy/INVESTOR_UPDATE_VOICE.md` — voice lock
2. `references/UPDATE_TYPES.md` — type A/B/C/D/E/F + corpus examples
3. `references/LAYOUT.md` — spacing, borders, typography
4. `03_studio/templates/race_preview_update.schema.json` — JSON shape (adapt per type)

---

## Pipeline (no shortcuts)

### 1. Ingest

```bash
# Append latest Wexford email if not already in file:
# 04_comms/inbox/wexford_emails_raw.txt
```

Extract facts. Classify type (see `UPDATE_TYPES.md` ingest table). Read **previous update** same horse for continuity.

### 2. Copy

Write `{slug}.json`. Run voice checklist in `INVESTOR_UPDATE_VOICE.md`.

### 3. Build

| Type | Master |
|------|--------|
| A Pre-race | `03_studio/templates/investor_update_email_master.html` |
| B Post-race | Same shell; **drop tactical block**; short body + TAB link (reuse pre-race UUID); optional hero only |
| C Pivot | Same shell; drop race strip + TAB; 4 cards; optional audio on landing only |
| D Stable | Same shell; minimal tactical or omit |

Output: `02_website/public/updates/{slug}_email.html`  
Send copy: `04_comms/inbox/{slug}_email_SEND.html` (absolute `https://www.evolutionstables.nz/updates/...` URLs)

### 4. Deploy

```bash
04_comms/scripts/deploy_investor_update_assets.sh {slug} {hero.jpg}
04_comms/scripts/verify_investor_update_assets.sh {hero.jpg}
```

### 5. Gmail draft

```bash
04_comms/scripts/push_investor_update_draft.sh \
  04_comms/inbox/{slug}_email_SEND.html \
  "{Subject line}"
```

Uses `gws` as `alex@evolutionstables.nz` (googleworkspace MCP equivalent).

User adds BCC in Gmail → Send.

### 6. X social (optional — see `social-post-pipeline`)

Pre-race Type A only. Single poster (Canva page 1), not carousel.

```bash
04_comms/scripts/push_x_post.sh --package 04_comms/inbox/social_{slug}/ --dry-run
04_comms/scripts/push_x_post.sh --package 04_comms/inbox/social_{slug}/
```

Requires `X_API_*` in `/home/evo/.env`. Canva steps via MCP — master `DAHNpr1STP4`.

---

## File map

```
04_comms/inbox/wexford_emails_raw.txt     ← append Wexford emails
04_comms/inbox/{slug}_email_SEND.html     ← send file
04_comms/strategy/INVESTOR_UPDATE_VOICE.md
04_comms/scripts/deploy|verify|push_*.sh
03_studio/templates/investor_update_email_master.html
02_website/public/updates/               ← hosted + assets
```

## Corpus references (voice calibration)

| Type | File |
|------|------|
| A Pre-race | `prudentia_update_27june2026_email.html` |
| B Post-race | Tone from `prudentia_update_02june2026` — layout intentionally **lighter** than pre-race |
| C Pivot | `prudentia_update_10june2026.json` |
| A (earlier) | `example_update.json` (28 May) |
| F Teaser | `email_teaser_master.html` |
| E Welcome | `coco_welcome_email.html` |
| G Legacy | `First-Gear-Update-18Dec2025.html` (do not copy for new work) |

---

## Verification

- Asset URLs → HTTP 200
- Draft created → report draft id
- Reply: **Check your drafts.**