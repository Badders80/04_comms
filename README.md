# 04_comms

**Open Grok/Cursor in this folder** for investor updates and social posts.


## Agent / session boot

**This folder is an island.** Do not invent “what’s next” from chat.

| Order | File |
|-------|------|
| **1** | [`continue.md`](continue.md) |
| **2** | [`STATE.md`](STATE.md) |

```text
Read continue.md and STATE.md. What's next?
```

End session: *“update the end of session notes”* → overwrite continue + patch STATE.  
Full protocol: [`../docs/SESSION_PROTOCOL.md`](../docs/SESSION_PROTOCOL.md)

---

**Agent boot:** [`STATE.md`](STATE.md) → this file → owner skill when doing investor/social work.

Skill: `.agents/skills/investor-update-pipeline/SKILL.md` (loads on “investor update”, “draft update”, “post-race”, etc.)

---

## Two paths

### A — You have content (or Wexford ingest)

Say one line, e.g. *“pls send the automated post race update”*.

Agent: **TAB fetch** (same URL as pre-race) → thin outcome email (no image) → deploy → **send** investors.

If no `tab_url` in the pre-race JSON → agent asks for the TAB link only.

**Schedule after pre-race ships** (race time + 10 min, one-shot `at` job):

```bash
just schedule-post-race prudentia prudentia_update_27june2026
```

**Manual trigger** (race night or if cron missed):

```bash
just post-race-auto prudentia --pre-race-slug prudentia_update_27june2026
# test send: just post-race-auto prudentia --to baddeley0@gmail.com --tab-url "https://..."
```

In-depth post-race (Wexford / yard audio) is a **separate** next-morning send — not this path.

```bash
just tab-fetch "https://www.tab.co.nz/racing/tauranga/{uuid}" Prudentia -o inbox/prudentia_tab_result.json
```

### B — You have HTML (review + ship)

Put working HTML in `inbox/{slug}_email_SEND.html` (and hosted copy in `02_website/public/updates/`).

Say: *“review this investor update and push to drafts”*.

Agent: voice/layout check → fix if needed → ship.

---

## Folders touched (investor update)

| Folder | Role | You touch it? |
|--------|------|----------------|
| **`04_comms/inbox/`** | Working drafts, SEND copy, registry, Wexford raw | Yes — intake + send file |
| **`04_comms/scripts/`** | deploy, verify, masthead, push-draft, **ship** | Run via `just` |
| **`04_comms/strategy/`** | Voice + brand (read-only for agent) | Rarely |
| **`03_studio/templates/`** | HTML master + JSON schema | Agent builds from here |
| **`02_website/public/updates/`** | Hosted HTML + images (live URLs) | Agent commits + Vercel |

**Not touched every time:** `01_evolution/`, `workspace/`, social `inbox/social_*` (optional, pre-race only).

---

## Fast commands (from `04_comms/`)

```bash
just list-horses                    # VOL / NO per horse
just reserve-masthead prudentia my_slug "Subject line" 2026-06-28
just deploy-update my_slug hero.jpg
just push-draft inbox/my_slug_email_SEND.html "Subject line"
just ship my_slug "Subject line" prudentia hero.jpg   # deploy + verify + draft + BCC
```

---

## Pipeline (6 steps — agent runs these)

1. **Ingest** — `inbox/wexford_emails_raw.txt` or transcripts you paste
2. **Copy** — `03_studio/templates/{slug}.json` + `just reserve-masthead`
3. **Build** — master HTML → `02_website/public/updates/{slug}_email.html` + `inbox/{slug}_email_SEND.html`
4. **Deploy** — `just ship` (or `deploy-update` alone)
5. **Draft** — included in `just ship` → alex@evolutionstables.nz Drafts (BCC auto if horse passed)
6. **You** — review → Send

**BCC lists:** `inbox/bcc_lists/{horse}.json` — Prudentia locked (8 recipients).

Completion phrase: **Check your drafts.**

---

## Why it felt slow

- **Three surfaces:** comms → studio template → website deploy (~1 min Vercel build)
- **Agent was debugging** footer icons, hero regression, asset corruption — not the normal path
- **Steps weren’t chained** — now `just ship` does deploy + draft in one go
- **Opening at repo root** pulls in unrelated context — **open here** (`04_comms/`) instead

---

## Reports (quarterly PDFs)

Comms **builds**; `_assets` **stores**; `01_evolution` **indexes**.

```bash
cd reports/quarterly/prudentia/2026-q2 && node export-pdf.mjs
# → _assets/horses/prudentia/documents/quarterly/Prudentia-Q2-2026-Investor-Report.pdf
```

See `reports/README.md`. Race data: `01_evolution/horses/{slug}/race-record.json`.

---

## Structure

```
04_comms/
├── inbox/              ← email drafts, SEND files, registry, wexford ingest
├── reports/            ← long-form PDFs (quarterly, annual, …) — build only
├── scripts/            ← ship, deploy, masthead, push-draft
├── strategy/           ← INVESTOR_UPDATE_VOICE.md, BRAND_KIT.md
├── .agents/skills/     ← investor-update-pipeline, social-post-pipeline
├── Justfile            ← just ship, push-draft, list-horses
├── STATE.md            ← live state (read first)
└── AGENTS.md           ← short rules
```

---

## Surfaces (done = observable)

| Done | Verify |
|------|--------|
| Hosted HTML | https://www.evolutionstables.nz/updates/{slug}_email.html |
| Gmail draft | Drafts folder, correct subject |
| Send | You add BCC and hit Send |

See `../SURFACES.md` §1 (web) and §2 (comms).