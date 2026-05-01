---
name: handoff-to-marketing
description: Generate the WMAO handoff package per docs/handoff-protocols.md Section 4. Requires 30-day post-launch elapsed + Shin's final approval. Lead agent delivery-director with seo-geo-strategist providing 30-day report.
auto_trigger_keywords:
  - WMAO 引継ぎ
  - marketing handoff
  - 30日引継ぎ
  - post-launch handoff
  - マーケ引継ぎ
---

# /handoff-to-marketing

## Purpose

Generate the structured handoff package for web-marketing-ai-org (WMAO) — the downstream organization that takes over continuous SEO/GEO improvement, content marketing, ads, and social.

## When to Use

- After Post-launch phase (30-day verification) completes
- Before transitioning maintenance to WMAO

## Lead Agent

**delivery-director** orchestrates. **seo-geo-strategist** provides the 30-day verification report. **content-strategy-lead** provides editorial calendar handoff. **studio-director** + Shin must approve before initiation.

## Inputs

- All project deliverables
- `projects/{id}/07-post-launch/30day-report.md` (REQUIRED — handoff blocked without this)
- `projects/{id}/00-engagement/approvals.yaml`
- Original `handoff-from-strategy.yaml` (apex's original brief — chain of context)
- `docs/handoff-protocols.md` Section 4 (canonical schema)

## Process

1. **Verify 30-day elapsed**: `delivery-director` checks gate
2. **Verify Shin's approval**: explicit yes from Shin required
3. **Compile delivered_assets** (full list per `handoff-protocols.md` Section 4.3):
   - Strategy: sitemap, content-strategy, seo-geo-strategy, measurement-plan
   - Design: design-system
   - Research: persona, user-journey-map, competitor-analysis
   - Delivery: cms-manual, handoff-package
   - Post-launch: 30day-report
4. **Compile client_relationship section** (decision-maker, CMS users, credentials location, approval history)
5. **Compile post_launch_targets** (KGI, KPIs with current vs target values, target dates)
6. **Compile initial_content section** (5-10 articles for A3, with `remaining_to_wmao: true`)
7. **Compile maintenance section** (Retainer terms if any)
8. **Compile expected_wmao_actions** (immediate / medium-term / long-term)
9. **Compile known_issues** (with severity, workarounds, fix plans)
10. Generate YAML per `handoff-protocols.md` Section 4.3 schema

## Outputs

- `projects/{id}/08-handoff/handoff-to-marketing.yaml` (snake_case YAML)
- `projects/{id}/08-handoff/wmao-package/` (directory containing all referenced artifacts as physical copies for portable handoff)

## Example Output (YAML excerpt)

```yaml
handoff_id: HO-20260901-001
protocol: handoff-to-marketing
version: 0.2
from:
  organization: digital-product-studio-ai
  agent: delivery-director
  timestamp: 2026-09-01T10:00:00+09:00
to:
  organization: web-marketing-ai-org
  agent: <WMAO Tier 0 agent>
status: submitted

project:
  id: aileap_v2
  client: AILEAP
  type: A1
  url: https://aileap-hazel.vercel.app
  launched_at: 2026-08-01
  post_launch_period_end: 2026-08-31

delivered_assets:
  strategy:
    - path: 02-strategy/sitemap.md
    - path: 02-strategy/content-strategy.md
    - path: 02-strategy/seo-geo-strategy.md
    - path: 02-strategy/measurement-plan.md
  design:
    - path: 03-design/design-system.md
  research:
    - path: 01-discovery/persona.md
    - path: 01-discovery/user-journey-map.md
    - path: 01-discovery/competitor-analysis.md
  delivery:
    - path: 08-handoff/cms-manual.md
    - path: 08-handoff/handoff-package.md
  post_launch_report:
    - path: 07-post-launch/30day-report.md

post_launch_targets:
  kgi:
    metric: 月間問合せ件数
    current_value: 5
    target_value: 30
    target_date: 2027-02-28
  kpi:
    - metric: オーガニック流入(月間 UU)
      current_value: 100
      target_value: 1000
      target_date: 2027-02-28
    - metric: GEO 流入(LLM 経由)
      current_value: 0
      target_value: 50
      target_date: 2027-02-28

initial_content:
  count: 7
  remaining_to_wmao: true
  content_calendar_provided: true

maintenance:
  contract_type: retainer
  monthly_fee: 80000
  sla:
    response_time: 24h
    resolution_time: 72h
    uptime_target: 99.5

expected_wmao_actions:
  immediate:
    - 月間流入レポートの定期発行
    - GEO 引用状況のモニタリング
    - 11 本目以降の継続コンテンツ制作
```

## Boundary Notes

- **Cannot fire without 30-day elapsed** — `delivery-director` enforces gate
- **Cannot fire without Shin's approval** — explicit yes required
- **v0.2 is manual file-copy** — Shin physically copies the YAML + package to WMAO's repository
- WMAO acceptance response should arrive within 7 days; if not, follow up

## Reference Documents

- `docs/handoff-protocols.md` Section 4 (full schema)
- `docs/templates/handoff-to-wmao.md`
