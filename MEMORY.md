# 04_comms — Session Memory

**Last Updated:** 2026-05-27
**Active Sprint:** Editorial Office Setup

---

## Current State

Setting up the repository framework under `04_comms` to serve as the campaign planning and copywriting hub.

---

## Recent Decisions

| Date | Decision | Why |
|------|----------|-----|
| 2026-05-27 | Repository Initialization | Created `04_comms` following `_template` scaffolding to establish a focused copywriting and campaign scheduling space. |

---

## Blockers

*None.*

---

## Next Actions

1. Create subfolders: `campaigns/`, `inbox/`, and `strategy/`.
2. Migrate raw campaign logs and drafts (such as `02_website/content-inbox/*`) to `04_comms/inbox/`.
3. Clear `02_website/content-inbox` to keep the frontend repository clean and dedicated.

---

## Handoff Points

- **Consumes from:** `01_evolution/` — Horse names, registered microchip IDs, and GCS media asset links.
- **Produces for:** `01_evolution/` — Scheduled social media post records, text hooks, and campaign parameters.

---

## Context Chain

<- inherits from: `../01_evolution/AGENTS.md`
<- inherits from: `/home/evo/evo_01/README.md`
<- inherits from: `/home/evo/workspace/CLAUDE.md`
