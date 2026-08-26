# 04_comms — Agent rules

**Session root:** `/home/evo/evo_01/04_comms`. Boot: [`continue.md`](continue.md) → [`STATE.md`](STATE.md) → [`README.md`](README.md).

## Identity

Primary: **investor update emails** (copy → hosted HTML → Gmail draft).  
Secondary: **quarterly PDFs** (`reports/quarterly/`) and **social** (`social-post-pipeline`).

**Reports rule:** Build here. Final PDFs → `_assets/horses/{slug}/documents/`. Index in `01_evolution/horses/{slug}/documents.md`. Comms is not the PDF archive.

---

## Investor updates (default)

1. Load `.agents/skills/investor-update-pipeline/SKILL.md`  
2. Do not ask horse/type if inferable  
3. Stay in folders mapped in `README.md`  
4. Ship with `just ship {slug} "{subject}" {hero}` when SEND + hosted HTML exist  
5. Pass horse so BCC loads from `inbox/bcc_lists/{slug}.json`  
6. Reply: **Check your drafts.** + subject + preview URL  

---

## Core laws

1. **No canonical horse truth here** — facts from `01_evolution/`.  
2. **Voice is absolute** — canonical: `evo_00/doc/ABOUT_AND_AUDIENCE.md` + `evo_00/doc/VOICE_AND_TONE_MANUAL.md` (identity: `evo_00/doc/IDENTITY.md`). Email shape: `strategy/INVESTOR_UPDATE_VOICE.md`. Ignore `strategy/_archive/`, `_shared/dna/` (retired), and legacy DNA brand trees for new copy.  
3. **Lead with the thoroughbred** — ban crypto, blockchain, RWA, Web3, and Tokinvest partnership claims in consumer-facing copy.  

---

## Data / assets

- Horse/race: `01_evolution/horses/`  
- Media: `_assets/horses/`, `_assets/brand/`  
- Design tokens: `_assets/brand/colors/` (consume, do not invent)  

---

## Verification

Every task ends with a verification command and its output.

---

## Related

- [`README.md`](README.md) — operator paths  
- [`BUILD_SUMMARY.md`](BUILD_SUMMARY.md) — map of what exists  
- [`strategy/README.md`](strategy/README.md) — foundation index  
