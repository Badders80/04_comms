# 04_comms — Live State

**Last updated:** 2026-07-13 (session protocol: continue.md + STATE.md)
**Canonical for agents:** yes — this file + [`README.md`](README.md) are the only required reads for most sessions.

**Owner skill:** `.agents/skills/investor-update-pipeline/SKILL.md` (load for any investor update task)

---

## Agent boot (island protocol)

| Order | File | Role |
|-------|------|------|
| **1** | [`continue.md`](continue.md) | **Next action** — overwrite every session wrap |
| **2** | This file (`STATE.md`) | **Current truth** — architecture, live, remaining work |

**Start:** read continue → this file → do Next action.  
**End:** say *“update the end of session notes”* → overwrite continue + patch this file.  
**Protocol:** [`../docs/SESSION_PROTOCOL.md`](../docs/SESSION_PROTOCOL.md)



## Architecture

```
Wexford ingest → inbox/wexford_emails_raw.txt
       ↓
Copy + masthead → 03_studio/templates/ → HTML
       ↓
02_website/public/updates/  (hosted)
       ↓
inbox/{slug}_email_SEND.html → just ship → Gmail draft
```

**Completion phrase:** *"Check your drafts."* + subject + preview URL

---

## What's live

| Component | Status | Notes |
|-----------|--------|-------|
| **Investor update pipeline** | ✅ | Owner skill + `just ship` chains deploy + draft |
| **inbox/** | ✅ | Drafts, SEND files, Wexford raw, BCC lists |
| **strategy/** | ✅ | `INVESTOR_UPDATE_VOICE.md`, `BRAND_KIT.md` |
| **Post-race auto** | ✅ | `just post-race-auto`, `just schedule-post-race` |
| **Quarterly PDFs** | ✅ | Locked 6pp · `report-draft-doc` → **user edits Doc** → `report-pull-doc` → `report-export` · Q2 shipped |
| **Social pipeline** | 🟡 | Phase 0 Doc review wired · Canva + X unchanged · needs first trial post |
| **NZ Racing Weekly inbox** | ✅ | `inbox/nz-racing-weekly/{date}/` — shippable packs from `05_industry-data` pipeline |

---

## Campaign Cross-Reference (Prudentia Q2 2026)

- **Content Tracker:** `strategy/CONTENT-TRACKER.md` — master campaign view
- **Campaign Pipeline:** `inbox/social_prudentia_qreport_2026/CAMPAIGN-PIPELINE.md` — content calendar
- **Brand Production System:** `strategy/BRAND_PRODUCTION_SYSTEM.md` — template specs + video standards
- **LinkedIn Article:** `inbox/social_prudentia_qreport_2026/LINKEDIN-ARTICLE.md` — draft locked
- **Active Tasks:** Article ready for fixes + publish, Phase 1 text pieces need drafting
- **Blockers:** Founder video recording (Alex), Canva carousel builds
- **Status command:** `python3 /home/evo/evo_01/scripts/status.py`
- **Last Updated:** 2026-07-04

---

## Content-review workflow (locked Jul 2026)

| Line | Push | Human edit | Pull | Then |
|------|------|------------|------|------|
| Quarterly PDF | `just report-draft-doc {horse} {period}` | Google Doc (auto-saves) | `just report-pull-doc` | `report-export` when `content_locked` |
| Social / story | `just social-draft-doc inbox/social_{slug}` | Google Doc (auto-saves) | `just social-pull-doc` | Canva → `push_x_post.sh` when `content_locked` |
| Investor email | `just ship` | Gmail draft | Send in Gmail | — |

**Shared helpers:** `scripts/google-doc-draft.mjs` · templates: `inbox/SOCIAL-DRAFT.template.md` · doc meta: `.social-draft-doc.json` / `.report-draft-doc.json`

**Rule:** Doc edits do **not** sync to repo until pull. User never resaves/downloads.

---

## Remaining work

1. **Trial social draft** — scaffold `SOCIAL-DRAFT.md` on next post; run Doc push/pull before Canva
2. Keep BCC lists current per horse (`inbox/bcc_lists/{slug}.json`)
3. Quarterly report cadence per horse (Q3 scaffold when ready)

---

## Handoffs (human)

| Item | Action |
|------|--------|
| **Review + Send** | Agent creates draft → you review Gmail → Send |
| **TAB link** | Post-race auto needs `tab_url` in pre-race JSON or you paste URL |
| **X API keys** | `X_API_*` in `/home/evo/.env` for live posts; use `--dry-run` first |

---

## Constraints

- **Never writes canonical horse truth** — names/facts from `01_evolution/horses/`
- **Brand voice lock** — `strategy/INVESTOR_UPDATE_VOICE.md`; ban crypto/Web3/RWA in investor copy
- **PDF archive** — final PDFs in `_assets/horses/{slug}/documents/`, indexed in `01_evolution/horses/{slug}/documents.md`
- **Three surfaces per send** — comms → studio template → website deploy (~1 min Vercel)

---

## Verify (every task)

```bash
cd /home/evo/evo_01/04_comms
# After ship:
ls -la inbox/*_email_SEND.html
curl -sI "https://www.evolutionstables.nz/updates/{slug}_email.html" | head -1
# Draft pushed via just ship / push-draft — confirm in Gmail Drafts
```

---

## Stale docs

- `MEMORY.md` — superseded by this file (2026-05 editorial setup notes)