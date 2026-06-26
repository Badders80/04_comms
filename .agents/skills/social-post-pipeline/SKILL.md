---
name: social-post-pipeline
description: >
  End-to-end X social post production: copy Canva poster master, swap hero + text,
  export slide 1, generate caption, push to @EvolutionStable via X API.
  Triggers: social post, x post, post to x, canva poster, race poster, /social-post.
---

# Social Post Production Line (X)

**Goal:** After investor update JSON exists → agent delivers **posted to X** (or dry-run package if creds missing).

Pairs with `investor-update-pipeline` — run social step after email deploy, or standalone when user asks only for X.

---

## Completion message

**Posted:**
> **Live on X.**  
> https://x.com/EvolutionStable/status/{id}

**Dry-run / creds missing:**
> **Package ready.**  
> `04_comms/inbox/social_{slug}/` — add X API creds to `/home/evo/.env` then:
> `04_comms/scripts/push_x_post.sh --package 04_comms/inbox/social_{slug}/`

---

## Read first

1. `04_comms/inbox/SOCIAL_WEEK1.md` — voice (no "digital syndication" on social)
2. `references/CANVA_MASTER.md` — design ID, text swaps, layout rules
3. Investor JSON: `04_comms/inbox/{slug}.json` or `03_studio/templates/{slug}.json`

---

## Pipeline

### 1. Caption (scriptable)

```bash
04_comms/scripts/generate_social_caption.py prudentia_update_27june2026 \
  -o 04_comms/inbox/social_prudentia_tauranga_27june2026/x_caption.txt
```

User-approved overrides (nomination wording, drop fixed post time) → edit `x_caption.txt` before post.

### 2. Canva (MCP — grok_com_canva)

Master for copies: **`DAHNpr1STP4`** (not `DAHLfddH_NM`).

| Step | Tool | Notes |
|------|------|-------|
| Copy | `copy-design` | `design_id: DAHNpr1STP4` → save new `design_id` |
| Hero | `upload-asset-from-url` | `https://www.evolutionstables.nz/updates/{hero.jpg}` |
| Edit | `start-editing-transaction` → `perform-editing-operations` → `commit-editing-transaction` | See `CANVA_MASTER.md` |
| Export | `export-design` | `format.type: png`, `pages: [1]`, `width: 1080`, `height: 1350` |
| Save | download URL | → `04_comms/inbox/social_{slug}/poster.png` |

Layout rules (encode in edits):
- Hero full-bleed (not inset)
- Horse name on dark band over photo
- Context tag: **Next Up**
- Telemetry: `1400M | TAURANGA | BM75` (pipe-separated)

### 3. Package manifest

Write `04_comms/inbox/social_{slug}/manifest.json`:

```json
{
  "slug": "social_{slug}",
  "type": "poster",
  "status": "ready_to_post",
  "channel": "x_single_image",
  "post_asset": "poster.png",
  "canva_design_id": "{new_copy_id}",
  "canva_master_for_future_copies": "DAHNpr1STP4",
  "caption_file": "x_caption.txt"
}
```

### 4. Post to X

```bash
# Validate first
04_comms/scripts/push_x_post.sh --package 04_comms/inbox/social_{slug}/ --dry-run

# Live
04_comms/scripts/push_x_post.sh --package 04_comms/inbox/social_{slug}/
```

Requires in `/home/evo/.env`:
- `X_API_KEY`, `X_API_SECRET`, `X_ACCESS_TOKEN`, `X_ACCESS_TOKEN_SECRET`

Canva MCP does **not** publish to X. Apify token is scrape-only.

---

## X account setup (one-time)

1. [developer.x.com](https://developer.x.com) → App with **Read and Write**
2. User authentication → OAuth 1.0a → generate access token for **@EvolutionStable**
3. Add four vars to `/home/evo/.env`
4. Dry-run, then post

---

## File map

```
04_comms/inbox/social_{slug}/
  poster.png
  x_caption.txt
  manifest.json
04_comms/scripts/generate_social_caption.py
04_comms/scripts/push_x_post.py
04_comms/scripts/push_x_post.sh
04_comms/.agents/skills/social-post-pipeline/references/CANVA_MASTER.md
```