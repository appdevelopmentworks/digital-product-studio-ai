---
name: team-corporate-site
description: Orchestrate A1 corporate-site workflow — dispatch agents per phase, set Production mode, wire up the 8-gate flow. Lead by studio-director.
---

# /team-corporate-site

## Purpose

Orchestrate the full A1 corporate-site workflow — from Engagement through Handoff. This is a team orchestration skill: it dispatches the right agents at each phase and sets up Production mode.

## When to Use

- New A1 project initialization (after `/handoff-from-strategy` reception or manual intake)
- Internal AILEAP corporate-site projects (`internal_client: true`)

## Lead Agent

**studio-director** dispatches. **delivery-director** provides phase-gate enforcement.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (or manual intake equivalent)
- `projects/{id}/PROJECT.md` set to `project_type: A1`, `mode: production`

## Dispatched Agents

| Phase | Agents activated |
|---|---|
| Engagement | delivery-director, client-success-lead, ux-strategy-lead, commercial-manager |
| Discovery | client-success-lead, ux-strategy-lead, content-strategy-lead, seo-geo-strategist |
| Strategy | strategy-director, ux-strategy-lead, content-strategy-lead, seo-geo-strategist |
| Design | creative-director, art-direction-lead, ui-designer, copywriter |
| Implementation | technology-director, frontend-lead, frontend-engineer, cms-engineer (if WordPress), nextjs-specialist or wordpress-specialist (dynamic), localization-specialist (if multi-lang) |
| QA | seo-geo-strategist, frontend-lead, delivery-director |
| Launch | delivery-director, frontend-engineer, seo-geo-strategist |
| Post-launch | seo-geo-strategist, delivery-director, content-strategy-lead |
| Handoff | delivery-director, client-success-lead |

## Process

1. **Verify project setup**:
   - PROJECT.md has `project_type: A1`
   - Mode is `production`
2. **Set initial gate**: Engagement → Discovery
3. **Dispatch agents per phase**:
   - Each phase, `studio-director` activates the relevant agents
   - `delivery-director` runs `/gate-check` between phases
4. **Run skills in order**:
   - Engagement: `/client-onboarding`, `/competitor-analysis`, `/requirements-gathering`, `/asset-checklist`, `/estimate`, `/approval-request`
   - Discovery → Strategy: `/sitemap-design`, `/content-strategy`
   - Strategy → Design: `/design-system`, `/i18n-strategy` (if multi-lang)
   - Design → Implementation: `/code-review` (continuous)
   - QA: `/seo-audit`, `/geo-audit`, `/accessibility-audit`
   - Launch: `/launch-checklist`
   - Post-launch: `/30day-report` (via seo-geo-strategist)
   - Handoff: `/handoff-package`, `/handoff-to-marketing` (after 30 days)

## Outputs

- Project workspace fully populated through phases
- Phase-gate reports in `decisions.yaml`
- Final `/handoff-to-marketing` YAML

## Standard Timeline (per `docs/requirements-v0.2.md` Section 17)

A1 standard timeline: **1 month** Engagement → Launch + 30 days Post-launch verification.

## Example Invocation (Japanese)

```
> /team-corporate-site project_id=aileap_v2

studio-director: A1 コーポレートサイト案件を起動します。
  プロジェクト ID: aileap_v2
  モード: Production
  動員エージェント:
    - Engagement: delivery-director, client-success-lead,
                  ux-strategy-lead, commercial-manager
  最初のステップ: /client-onboarding を実行

  公開承認、デザイン承認、要件承認は必須です。
  WMAO ハンドオフは公開後 30 日経過後にのみ可能です。

次のアクション: /client-onboarding を実行しますか?
```

## Boundary Notes

- v0.2 only A1 / A2 / A3 supported — for B-series escalate to studio-director
- Internal AILEAP projects: same workflow but `internal_client: true` flag changes commercial-manager behavior
- Skill orchestration is sequential; studio-director adapts dispatch order based on actual project rhythm

## Reference Documents

- `docs/requirements-v0.2.md` Section 13.1 (full A1 workflow)
- `docs/agent-coordination-map.md` Section 6.1
- `docs/agent-roster.md` Section 1 (full roster)
