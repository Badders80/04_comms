# Investor Update Email — Layout Lock (v1)

**Master template:** `03_studio/templates/investor_update_email_master.html`  
**Gold reference:** `02_website/public/updates/prudentia_update_27june2026_email.html`

## Section order

1. **Preheader** — hidden div, ~120 chars  
2. **Header (white)** — logo → gold eyebrow → Playfair headline → Inter subhead → hero frame → caption  
3. **Body 1** — setback / work narrative  
4. **Quote** — gold bar + `#fafafa`, Times 28px, cite Inter uppercase  
5. **Body 2 + race strip** — race prose → 3-col facts → TAB link  
6. **Tactical (dark `#050505`)** — title + 3 stacked cards  
7. **Close** — one paragraph  
8. **Signature** — gold hairline → AB signature → name  
9. **Footer (black)** — Ownership headline → mono logo + social (`#8c8c8c`)

## Spacing (approved)

| Block | Value |
|-------|-------|
| Logo → eyebrow | 32px |
| Eyebrow → headline | 24px |
| Headline → subhead | 24px |
| Subhead → hero | 28px |
| Caption top | 20px |
| Header bottom pad | 16px |
| Body 1 top | 32px, bottom 8px |
| Quote outer | 40px vertical |
| Quote inner | 32×36px |
| Quote → cite | 32px |
| Body 2 block | 40px top, 48px bottom |
| Body 2 → facts | 40px |
| Facts → TAB | 28px |
| Race → tactical top | 56px |
| Tactical title → cards | 40px |

## Borders (email-safe)

- Race facts table: `border-collapse: separate`, outer + dividers `#d4cfc0`  
- Tactical card stack: outer + row dividers `#222222`, badges `#333333`  
- Never use `rgba(255,255,255,0.06)` for visible borders

## Typography

| Element | Font | Size | Colour |
|---------|------|------|--------|
| Headline | Playfair | 44px | `#000`, emphasis `#d4a964` italic |
| Subhead | Inter | 20px medium | `#222222` justified |
| Body | Inter | 15px | `#1a1a1a` justified |
| Quote | Times New Roman | 28px italic | `#000` justified |
| Race facts label | Inter | 9px uppercase | `#999999` |
| Tactical title | Playfair | 36px light | `#fff` |

## Image URLs (send-ready)

Always absolute after deploy:

```
https://www.evolutionstables.nz/updates/{filename}
```

Required assets per send: `evolution-stables-logo-header.jpg`, hero jpg, `EvolutionStables-Mono-White.png`, `AB_Signiture.png`

## File outputs

| Path | Purpose |
|------|---------|
| `02_website/public/updates/{slug}_email.html` | Canonical hosted HTML |
| `04_comms/inbox/{slug}_email_SEND.html` | Send copy (absolute URLs) |
| `04_comms/inbox/{slug}_email.html` | Working copy |