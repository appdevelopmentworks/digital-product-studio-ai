---
name: team-landing-page
description: Orchestrate A2 landing-page workflow — leaner team, conversion focus, 2-week timeline. Lead by studio-director.
auto_trigger_keywords:
  - A2
  - ランディングページ
  - landing page
  - 縦長 LP
---

# /team-landing-page

## Purpose

Orchestrate the A2 landing-page workflow — lighter than A1 (no deep IA, no CMS, no editorial calendar). Focus is conversion optimization and copy.

## When to Use

- New A2 LP project initialization
- Campaign LP with hard launch deadline (2-week standard timeline)

## Lead Agent

**studio-director** dispatches. **delivery-director** enforces phase gates.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (or manual intake)
- `projects/{id}/PROJECT.md` set to `project_type: A2`, `mode: production`

## Dispatched Agents (Reduced from A1)

| Phase | Agents activated |
|---|---|
| Engagement | delivery-director, client-success-lead, commercial-manager |
| Strategy | strategy-director, copywriter (lead role for LP) |
| Design | art-direction-lead, ui-designer, copywriter |
| Implementation | technology-director, frontend-engineer, nextjs-specialist (typical) |
| QA | seo-geo-strategist (basic checks), delivery-director |
| Launch | delivery-director, frontend-engineer |
| Post-launch | seo-geo-strategist, delivery-director |
| Handoff | delivery-director, client-success-lead |

**Not invoked for A2** (vs A1):
- ux-strategy-lead (no deep IA needed)
- content-strategy-lead (LP is single content unit; copywriter handles)
- cms-engineer (LP is static)

## Process

1. **Verify project setup**: A2 type, Production mode
2. **Compress timeline**: 2-week standard (vs 1 month for A1)
3. **Skill execution order**:
   - Engagement: `/client-onboarding`, `/asset-checklist`, `/competitor-analysis` (1-2 competitors only), `/requirements-gathering`, `/estimate`
   - Strategy: `/content-strategy` (LP-section-level only)
   - Design: `/design-system` (LP-scoped, lighter), section designs
   - Implementation: `/code-review` continuous
   - QA: `/seo-audit` (basic), `/accessibility-audit`
   - Launch: `/launch-checklist`
   - Post-launch: 30-day report
   - Handoff: `/handoff-package`, `/handoff-to-marketing`

## Outputs

- A2 project workspace
- Single-page LP fully structured
- 30-day report focused on conversion (rather than traffic)

## Standard Timeline

**2 weeks** Engagement → Launch + 30 days Post-launch verification.

## Boundary Notes

- For LP with very short timeline (< 1 week), escalate — quality floors not negotiable but standard 2-week timeline may need adjustment via `/change-order`
- LP standard is single-language; multi-language LP triggers localization-specialist + scope adjustment

## Reference Documents

- `docs/requirements-v0.2.md` Section 13.2 (A2 workflow)
- `docs/agent-coordination-map.md` Section 6.2
