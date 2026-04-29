---
description: PROJECT.md defines canonical project metadata. Required fields, naming conventions, status/phase enums, and phase-transition logging rules for all client projects.
globs:
  - "projects/*/PROJECT.md"
  - "projects/**/PROJECT.md"
alwaysApply: false
---

# Project Scaffold — PROJECT.md Conventions

Reference: `docs/quick-start.md`, `docs/requirements-v0.2.md` Section 3

## PROJECT.md is the Single Source of Truth

Every project directory under `projects/` must have a `PROJECT.md` at its root.
This file is read by hooks, skills, and agents to identify the active project.

## Required Fields

```yaml
# PROJECT.md — Canonical project metadata
# All fields required unless marked optional

id: AXYZ-20260601-001           # Project ID (format below)
type: A1                         # A1 | A2 | A3 | Internal
status: active                   # active | paused | completed | archived
phase: discovery                 # Current phase (see phase list below)

client_name: 株式会社サンプル      # Legal company name
client_contact: 田中 太郎         # Primary client contact name
client_email: tanaka@example.com  # Primary contact email
internal_client: false            # true for AILEAP self-projects (AILEAP v2, etc.)

created_at: 2026-06-01           # ISO date: project initialized
launched_at: null                 # ISO date: set when phase becomes post-launch
completed_at: null                # ISO date: set when archived

target_languages:                 # Array of BCP-47 locale codes
  - ja                            # Always include ja (Japanese primary)
  # - en                          # Uncomment when English scope confirmed

parallel_project_count: 1         # Current active parallel projects (studio-director tracks)

# Optional fields
notes: ""
apex_handoff_ref: null            # apex-consulting-ai handoff document ID
wmao_handoff_ref: null            # web-marketing-ai-org handoff document ID
```

## Project ID Format

`{CLIENT_ABBR}-{YYYYMMDD}-{NNN}`

- `CLIENT_ABBR`: 2-4 uppercase letters from client name (e.g., `AXYZ`, `SMK`)
- `YYYYMMDD`: Project start date
- `NNN`: Sequence number within that client+date (001, 002...)

Examples:
- `AXYZ-20260601-001` — First AXYZ project starting June 1, 2026
- `AILEAP-20260401-001` — AILEAP self-project (internal_client: true)

## Project Types (v0.2)

| Type | Description | Typical Budget |
|---|---|---|
| `A1` | Corporate site / company website | 50-150万円 |
| `A2` | Landing page (conversion-focused) | 20-50万円 |
| `A3` | Mediasite / content-heavy site | 80-200万円 |
| `Internal` | AILEAP self-projects (no external invoicing) | — |

## Phase Sequence

Phases must progress in order. Skipping phases requires studio-director approval
recorded in `decisions.yaml`.

```
discovery → strategy → design → implementation → staging → launch → post-launch
```

| Phase | Key deliverables |
|---|---|
| `discovery` | assets-required.yaml, requirements-v0.md |
| `strategy` | sitemap.md, content-strategy.md, i18n-strategy.md (if applicable) |
| `design` | design-system.md, key screens, component specs |
| `implementation` | Code, CMS config, i18n files |
| `staging` | Pre-launch checklist, Lighthouse scores |
| `launch` | DNS cutover, analytics, announcement |
| `post-launch` | 30-day SEO/GEO verification (B-C1 boundary) |

## Phase Transition Rule

When changing `phase:` in PROJECT.md, you MUST also:
1. Update `status:` if appropriate
2. Add a `DEC-NNN` entry to `00-engagement/decisions.yaml` recording the transition
3. Confirm gate conditions were met (delivery-director gate check)

## Parallel Project Constraint

Maximum 3 active projects simultaneously (F-C2 fix, per `DPSAI_MAX_PARALLEL_PROJECTS`).
When creating a new project, check `status: active` count across all PROJECT.md files.
If count would exceed 3, escalate to studio-director before proceeding.
