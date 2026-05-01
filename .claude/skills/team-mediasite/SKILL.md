---
name: team-mediasite
description: Orchestrate A3 mediasite workflow — heavy CMS, content-driven, initial 5-10 articles produced, 1.5-month timeline. Lead by studio-director.
auto_trigger_keywords:
  - A3
  - メディアサイト
  - mediasite
  - オウンドメディア
  - ブログサイト
  - 記事サイト
---

# /team-mediasite

## Purpose

Orchestrate the A3 mediasite workflow — content-heavy, CMS-driven, with the B-C2 boundary (5-10 initial articles produced before launch, 11+ handed to WMAO).

## When to Use

- New A3 mediasite project initialization
- Editorial / blog / owned-media projects

## Lead Agent

**studio-director** dispatches. **delivery-director** enforces phase gates.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (or manual intake)
- `projects/{id}/PROJECT.md` set to `project_type: A3`, `mode: production`

## Dispatched Agents

| Phase | Agents activated |
|---|---|
| Engagement | delivery-director, client-success-lead, ux-strategy-lead, commercial-manager |
| Discovery | client-success-lead, ux-strategy-lead, content-strategy-lead (lead role), seo-geo-strategist |
| Strategy | strategy-director, content-strategy-lead (lead role), seo-geo-strategist (lead role) |
| Design | creative-director, art-direction-lead, ui-designer (template focus) |
| Implementation | technology-director, frontend-lead, frontend-engineer, cms-engineer (lead role), wordpress-specialist or future headless-cms-specialist |
| Content (B-C2 boundary) | content-strategy-lead, copywriter (5-10 initial articles) |
| QA | seo-geo-strategist (lead role), frontend-lead |
| Launch | delivery-director, frontend-engineer, seo-geo-strategist |
| Post-launch | seo-geo-strategist (lead role), content-strategy-lead |
| Handoff | delivery-director, content-strategy-lead (editorial calendar handoff) |

## Process

1. **Verify project setup**: A3 type, Production mode
2. **Skill execution order**:
   - Engagement: `/client-onboarding`, `/asset-checklist`, `/competitor-analysis` (focus on content cadence), `/requirements-gathering`, `/estimate`
   - Strategy: `/sitemap-design` (deep IA — categories, tags), `/content-strategy` (most extensive of 3 types), `/i18n-strategy` (if multi-lang)
   - Design: `/design-system` (article template emphasis)
   - Implementation: `/code-review` continuous, CMS schema work
   - Content production: B-C2 boundary — copywriter writes 5-10 initial articles per content-strategy-lead's per-article outlines
   - QA: `/seo-audit`, `/geo-audit` (heavy emphasis on Article + Author JSON-LD), `/accessibility-audit`
   - Launch: `/launch-checklist`
   - Post-launch: 30-day report (focus on traffic + GEO citation indicators)
   - Handoff: `/handoff-package` + `/handoff-to-marketing` with editorial calendar for WMAO continuation

## Outputs

- A3 project workspace
- 5-10 initial articles in `07-post-launch/initial-content/`
- `cms-manual.md` (heavier than A1 due to editorial workflow complexity)
- Editorial calendar handed to WMAO

## Standard Timeline

**1.5 months** Engagement → Launch + 30 days Post-launch verification.

## Initial Article Production Rules (B-C2 boundary)

- Per `docs/requirements-v0.2.md` Section 1.3 and 13.3
- 5-10 articles produced before launch by copywriter under content-strategy-lead direction
- 11+ articles are WMAO's responsibility post-handoff
- Each article applies GEO-optimized structure (per `docs/geo-implementation-spec.md` Section 5)

## Boundary Notes

- A3 has the highest content-strategy-lead and seo-geo-strategist load of the 3 v0.2 types
- WMAO handoff includes editorial calendar showing the next 30-90 days of content topics (not full pieces — just topic + target keyword + outline)
- v0.2 is WordPress-default for A3; Headless CMS option available but requires careful technology-director sign-off

## Reference Documents

- `docs/requirements-v0.2.md` Section 13.3 (A3 workflow)
- `docs/agent-coordination-map.md` Section 6.3
- `docs/geo-implementation-spec.md` Section 5 (GEO-optimized writing — required for articles)
