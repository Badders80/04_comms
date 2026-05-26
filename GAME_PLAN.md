# 04_comms — Game Plan

**Status:** 🟢 Phase 1 — Editorial Office Setup
**Created:** 2026-05-27
**Last Updated:** 2026-05-27

---

## Workspace Boundary

| Workspace | Purpose | What Lives Here |
|-----------|---------|-----------------|
| `04_comms/` | **Marketing & Content Strategy** | Social media campaigns, copywriting drafts, and brand voice guidelines |

**Rule:** This project never writes canonical truth. It consumes from and submits metadata to `01_evolution/` via HTTP APIs. All scheduled posts or campaign configurations are registered in `01`'s Firestore collections.

---

## Goal

Provide a dedicated, clutter-free desk for copywriters and content agents to draft, plan, and schedule campaigns without polluting the core software codebases.

**Scope:**
- Centralizing raw markdown copy drafts (`inbox/`)
- Writing clear, actionable brand voice and editorial constraints (`strategy/`)
- Organizing weekly campaign logs and schedules (`campaigns/`)

**Non-Goals (current phase):**
- Programmatic video rendering or splicing (handled by `03_studio`)
- Hosting client-facing code or web pages (handled by `02_website`)

---

## Architecture Decisions (Locked)

| Decision | Choice | Rationale | Date |
|----------|--------|-----------|------|
| Tech stack | Markdown, JSON | Human-editable, highly indexable by AI copywriter agents, Zero-overhead. | 2026-05-27 |

---

## Phase 1 Definition of Done

1. Structure `strategy/`, `inbox/`, and `campaigns/` directories
2. Migrate all raw drafts (e.g. `content-inbox/` from `02_website`) to `04_comms/inbox/`
3. Push clean initial baseline to remote repository
4. Ensure no uncommitted garbage or build leftovers exist in the directory

---

## Related Documents

- **Current status:** [`MEMORY.md`](MEMORY.md)
- **Agent rules:** [`AGENTS.md`](AGENTS.md)
- **API contract:** [`HANDSHAKE.md`](HANDSHAKE.md)
- **Build map:** [`BUILD_SUMMARY.md`](BUILD_SUMMARY.md)
- **Task hub:** [`../01_evolution/docs/PROGRESS.md`](../01_evolution/docs/PROGRESS.md)
