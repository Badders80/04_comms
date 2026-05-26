# API Handshake — 04_comms ↔ 01_evolution

**Version:** 1.0
**Last Updated:** 2026-05-27

---

## Overview

This document defines how `04_comms/` connects to the backend (`01_evolution/`).

**Architecture:**
```
04_comms (Trigger Scripts) → HTTP API Calls → 01_evolution (GCP Cloud Functions)
```

---

## Backend Endpoints

### SSOT API
**Base URL:** `https://australia-southeast1-evolution-engine.cloudfunctions.net/ssot`

| Endpoint | Method | Use | Response |
|----------|--------|-----|----------|
| `/horses` | GET | Browse registered horses for campaign tagging | `Horse[]` |
| `/content` | POST | Schedule/Register new campaign content items | `{ content_id }` |

### Assets API
**Base URL:** `https://australia-southeast1-evolution-engine.cloudfunctions.net/assets`

| Endpoint | Method | Use | Response |
|----------|--------|-----|----------|
| `/retrieve` | GET | Check existing media assets for attachment to campaign | `Asset[]` |

---

## Related
- [`../01_evolution/api/README.md`](../01_evolution/api/README.md) — Backend API docs
