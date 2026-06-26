# Investor Update — Voice & Copy

**Status:** Locked v2 (corpus-reviewed)  
**Scope:** All Evolution Stables ownership-layer investor emails  
**Parents:** `strategy/BRAND_KIT.md` §3, `workspace/DNA/brand/VOICE_SYSTEM.md`, `04_comms/.agents/skills/investor-update-pipeline/references/UPDATE_TYPES.md`

---

## 1. Persona

**Private Banker Standard** (BRAND_KIT §3) — warm authority, accessible expertise, heritage-informed.

- Lead with the **Thoroughbred, yard, turf** — not platform or tokens.
- **Active voice**, British spelling (behaviour, metres, programme).
- **No exclamation marks**, no hype, no betting slang.
- State barrier, weight, distance, grade, times — let metrics talk.

Legacy note: older sandbox docs used "James — The Storyteller"; same register, different label.

---

## 2. Update types (pick one)

| Type | Trigger phrase | Subject pattern |
|------|----------------|-----------------|
| **A Pre-race** | "prerace", "race preview", "she's in Saturday" | `Investor Update — {Horse} \| {Track}, {Day DD Month}` |
| **B Post-race** | "post-race", "race review", "after Te Rapa", "how did she go" | `Investor Update — {Horse} \| {Track} Review` |
| **C Pivot** | "withdrawal", "scratch", "campaign pivot", "sore" | `Investor Update — {Horse} \| Campaign Update` |
| **D Stable news** | "training report", "stable update" (no race) | `Investor Update — {Horse} \| Stable Report` |
| **E Welcome** | new owners | `Welcome Aboard — {Horse}` |
| **F Teaser** | optional short + link | Same subject as full update |

Full structural rules per type → `UPDATE_TYPES.md`.

---

## 3. Shared copy patterns

### Headline (Playfair 44px)
One gold italic emphasis word:

- Pre-race: `Back to *Maiden* Ground`
- Post-race: `Te Rapa Review: *Prudentia* Finishes Tenaciously`
- Pivot: `Tauranga Target: *Prudentia* Pivots Campaign`

### Subhead (Inter 20px medium, justified)
Investor priority in one paragraph. Pre-race may end with a hook question.

### Body (Inter 15px, `#1a1a1a`, justified)
- **50–90 words** per paragraph; 1–3 paragraphs per block.
- Weave race details into prose — never bullet lists in body (race facts strip excepted).
- **Continuity:** next page of the book — reference last update, don't repeat it.

### Quote (Times 28px italic, justified)
One trainer quote, tactical or physical — attributed:

> — Andrew Scott, **Wexford Stables**

### Close
One paragraph. Pre-race: post-race follow-up promise. Post-race: optional yard line or next run — keep brief. Pivot: named next date when known.

### Post-race (Type B) — simplified

**Don't over-complicate.** Same email shell, lighter content:

1. **Headline + subhead** — result in one line (*Finished fifth at Tauranga — pocketed on the rail, ran on once clear.*)
2. **Body** — position + what happened (1–2 short paragraphs)
3. **TAB link** — same race page URL as pre-race (`tab.co.nz/racing/{track}/{uuid}`); ingest result/margins from page when drafting on the run
4. **Hero image** — optional race-day or return photo
5. **No** tactical card grid, no replay block, no race facts strip unless requested

---

## 4. Word counts (narrative only)

| Type | Words |
|------|-------|
| B Post-race | **120–200** (brief) |
| D Stable news | 150–220 |
| A Pre-race | 220–300 |
| C Pivot | 220–280 |

---

## 5. Banned

- crypto, blockchain, Web3, RWA, token (as hero)
- easy money, locks, sure things, ROI
- Exclamation marks (except inside verbatim quotes)
- Full sponsored race names in headlines (use BM75, venue, distance)
- Invented quotes or facts

---

## 6. Preheader

Hidden div, **~90–120 chars**: horse + track/race hook + barrier/weight/jockey if pre-race.

---

## 7. Ingest sources

| Source | Path |
|--------|------|
| Wexford email | `04_comms/inbox/wexford_emails_raw.txt` or pasted in chat |
| Prior update | `02_website/public/updates/{horse}_update_*` (continuity) |
| Audio / Prism | Quote extraction only; email uses still hero |
| TAB / fields | Race URL, barrier, weight confirmation |

**Classify email before writing** → see ingest table in `UPDATE_TYPES.md`.

---

## 8. Sign-off & footer

Alex Baddeley · Evolution Stables · `AB_Signiture.png` · gold hairline.

Footer social: `#8c8c8c`. No Instagram.