# Investor Update Types — Corpus Review

Reviewed: Prudentia May–Jun 2026, First Gear Dec 2025–Mar 2026, Coco welcome, sandbox style guide.

**Default for investors:** full-content **600px email** (`investor_update_email_master.html`).  
**Optional:** Gmail **teaser** linking to hosted HTML (`email_teaser_master.html`).

---

## Type A — Pre-race preview

**When:** Horse accepted for an upcoming race (nomination confirmed, fields published).

| | |
|--|--|
| **Gold reference** | `prudentia_update_27june2026_email.html` |
| **Earlier examples** | `example_update.json` (28 May sprint test), `prudentia_update_26june2026` |
| **Subject** | `Investor Update — {Horse} \| {Track}, {Day DD Month}` |
| **Headline** | `{Verb} to *{Hook}*` — e.g. Back to *Maiden* Ground, The Sprint Test: *Prudentia* |
| **Arc** | Last chapter → current form → race card facts → trainer quote on conditions → 3 tactical cards → TAB link → post-race follow-up promise |
| **Unique blocks** | Race facts strip (Date / Race / Distance), tactical analysis (3 cards), TAB URL |
| **Words** | 220–300 narrative |

**Voice:** Forward-looking, calm confidence. Hook question in subhead optional (*Can she do it again?*). Quote = tactics + ground + weight, not generic praise.

---

## Type B — Post-race review (keep it simple)

**When:** Same day or next day — often drafted on the run after checking the TAB race page.

| | |
|--|--|
| **Style reference** | Brief narrative from `prudentia_update_02june2026` (tone only) — **not** the full layout |
| **Subject** | `Investor Update — {Horse} \| {Track} Review` |
| **Headline** | `{Track} Review: *{Horse}*` or short outcome line |
| **Arc** | **Result** (position) → **what happened** in the race (2 short paragraphs max) → **TAB race link** → optional hero pic → brief close if yard comment available |
| **Include** | Finishing position, honest passage summary, link to same TAB race URL used pre-race |
| **Skip** | Tactical analysis grid, 4 review cards, replay link blocks, race facts strip — unless user asks |
| **Ingest on the run** | `https://www.tab.co.nz/racing/{track}/{race-uuid}` — field, result, margins where published |
| **Words** | **120–200** — shorter than pre-race |

**Voice:** Straight report. "We finished fifth — pocketed on the rail, fought on once clear." No over-analysis. Physical/trot-up line only if you have it. Next-target line optional.

**Strip sponsor names** from race titles in copy (use BM75, 1400m, Tauranga).

---

## Type C — Campaign pivot / withdrawal

**When:** Scratching, soreness, target change, missed engagement.

| | |
|--|--|
| **Gold reference** | `prudentia_update_10june2026.json` + landing page |
| **Subject** | `Investor Update — {Horse} \| Campaign Update` |
| **Headline** | `{Track} Target: *{Horse}* Pivots Campaign` |
| **Arc** | What happened → why withdrawal is correct → yard response (swim, pads, etc.) → quote ("ran out of runway") → revisit past runs → 4 cards on recovery plan + next date |
| **Unique blocks** | Audio hero on **landing page** optional; email uses still image. No race facts strip. No TAB link. |
| **Words** | 220–280 |

**Voice:** **Tactical withdrawal** — protect the longer campaign. Matter-of-fact, zero drama. Andrew Scott quote explains decision. Name next target date and venue when known.

---

## Type D — Stable news / training report

**When:** No imminent race; work reports, spelling, gear changes, general fitness.

| | |
|--|--|
| **Examples** | First Gear Dec 2025 updates (editorial), training stills |
| **Subject** | `Investor Update — {Horse} \| Stable Report` |
| **Headline** | Training / conditioning angle — less date-driven |
| **Arc** | Physical state → recent work → trainer quote → what's next (window, not race card) |
| **Blocks** | May omit tactical grid or use 2–3 cards on fitness markers |
| **Words** | 150–220 |

**Voice:** Quiet authority on work metrics (gallop times, pull-up clean). No race hype.

---

## Type E — Welcome / onboarding

**When:** New co-owners join a horse.

| | |
|--|--|
| **Reference** | `03_studio/coco_welcome_email.html` |
| **Subject** | `Welcome Aboard — {Horse}` |
| **Arc** | Welcome → horse snapshot → trainer → what to expect from updates → Enter Stable |
| **Not in standard pipeline** | One-off; separate template |

---

## Type F — Email teaser (optional second artifact)

**When:** You want a short Gmail body + link to full hosted update.

| | |
|--|--|
| **Template** | `email_teaser_master.html` |
| **JSON field** | `email_teaser_body`, `email_cta_text` |
| **Body** | 2–3 sentences + single gold-underline CTA to `evolutionstables.nz/updates/{slug}_email.html` |

**Default policy:** Investors get **full email** (Type A/B/C). Teaser is legacy / deliverability fallback only.

---

## Type G — Editorial mobile (legacy)

**When:** Long mature arcs, First Gear era.

| | |
|--|--|
| **Reference** | `First-Gear-Update-18Dec2025.html` (430px, drop caps, bullet-highlight) |
| **Status** | **Deprioritised** — do not use for new Prudentia emails. Keep for First Gear archive style. |

---

## Cross-type voice rules (from corpus)

1. **Next page, not reprint** — reference last update's outcome; don't relist old facts verbatim.
2. **British spelling** throughout.
3. **Trainer first** — Lance O'Sullivan & Andrew Scott / Wexford Stables; jockey named when booked.
4. **Metrics woven in** — barrier, kg, metres, time, BM grade in prose not bullet lists (except race facts strip).
5. **Quote discipline** — one primary quote per update; specific to *this* story.
6. **Discard** — WhatsApp hype ("Far out!", "Believe!"), misspellings, training-table noise ("left a lot of food").
7. **Stablemates** — one clause max if same race (e.g. Ribkraka B6).

---

## Ingest classification (Wexford email)

| Email signal | Update type |
|--------------|-------------|
| Nominations / fields / "she's in" / barrier draw | **A — Pre-race** |
| Result + sectionals / "trotted up" / scoped | **B — Post-race** |
| Withdrawn / sore / swimming / "won't run Saturday" | **C — Pivot** |
| Trackwork only / no acceptance date | **D — Stable news** |

Raw ingest default path: `04_comms/inbox/wexford_emails_raw.txt` (append latest email before running pipeline).