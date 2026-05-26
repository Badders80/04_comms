# 04_comms — Build Summary

**Track:** Marketing & Content Strategy
**Repository:** `04_comms/`
**Status:** 🟢 Active — Initialized

---

## Architecture

```
04_comms/
├── campaigns/    → Active social media campaigns & weekly schedules
├── inbox/        → Draft copy, creative briefs, and content drops
├── strategy/     → Brand voice parameters and messaging rules
├── MEMORY.md     → Current state, blockers, recent decisions
├── AGENTS.md     → Agent rules
├── HANDSHAKE.md  → API contract with 01_evolution/
├── BUILD_SUMMARY.md  → This file (what exists)
└── GAME_PLAN.md  → Build plan
```

---

## What Exists

| Component | Status | Notes |
|-----------|--------|-------|
| Brand Strategy | 🟢 Configured | Guidelines established in `strategy/` |
| Content Inbox | 🟢 Deployed | Migration of raw draft schedules to `inbox/` |
| Active Campaigns | 🟡 Planned | Future automated social scheduling hooks |

---

## Dependencies

| Dependency | Source |
|------------|--------|
| Data / APIs | `01_evolution/` (SSOT, Content) |
| Assets | `Evolution_Content/assets/` or GCS |
| Design system | `_shared/brand/` |

---

## What's Next

1. Migrate existing raw content-inbox files from `02_website` to `04_comms/inbox/`.
2. Construct automated triggers linking copywriting scripts to programmatic rendering and posting pathways.

---

## Related
- **Backend:** [`../01_evolution/docs/BUILD_SUMMARY.md`](../01_evolution/docs/BUILD_SUMMARY.md)
- **Task hub:** [`../01_evolution/docs/PROGRESS.md`](../01_evolution/docs/PROGRESS.md)
