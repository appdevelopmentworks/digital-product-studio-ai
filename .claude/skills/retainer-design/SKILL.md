---
name: retainer-design
description: Design the monthly maintenance contract (Retainer) — tier, monthly fee, included services with hour caps, overage rate, minimum period. Lead agent commercial-manager (per docs/pricing-strategy.md Section 4 / 9.2).
auto_trigger_keywords:
  - リテイナー
  - retainer
  - 月額保守
  - 保守契約
  - 月額契約
  - maintenance
---

# /retainer-design

## Purpose

Design the monthly Retainer contract — included scope, hour caps, overage rate, escalation triggers. The Retainer is AILEAP's LTV-maximization vehicle (per `docs/pricing-strategy.md` Section 4).

## When to Use

- During `/estimate` (Retainer pattern is mandatory)
- Post-launch transition to maintenance phase
- Renewal time (when an existing Retainer is up for re-design)
- Tier upgrade trigger (3 consecutive months of overage → propose Pro tier)

## Lead Agent

**commercial-manager** is the sole owner.

## Inputs

- `00-engagement/requirements-v0.md` (scope context for what to maintain)
- `PROJECT.md` (project type, internal_client flag)
- `docs/pricing-strategy.md` Section 4 (tier definitions)
- For renewals: previous Retainer + last 6-month usage history

## Process

1. **Choose tier** based on client size and project complexity:
   - **Light** (5-10 万円/月): Small A1, A2 LP — monitoring + minor updates only
   - **Standard** (10-20 万円/月): Standard A1, A3 — monitoring + updates + minor features
   - **Pro** (20-50 万円/月): Larger A1/A3, internal AILEAP — adds SEO/GEO improvement coordination + monthly strategy review
   - **Enterprise** (50 万円+): Reserved for B-series in v0.3+
2. **Define included services with hour caps**:
   - Monitoring & bug fixes
   - Content updates
   - Feature additions / improvements
   - SEO/GEO improvement (coordinate with WMAO post-handoff)
   - Monthly report
3. **Set overage rate** (typically 1.2-1.5× implied hourly rate)
4. **Set minimum period**: 6 months default
5. **Set renewal cadence**: 1-month rolling after minimum period
6. **Set termination notice**: 30 days
7. **Define escalation trigger**: e.g., 3 consecutive months > 30h → propose Pro tier
8. **Save** to `00-engagement/retainer.yaml` + Markdown summary

## Outputs

- `00-engagement/retainer.yaml` (full schema per `docs/pricing-strategy.md` Section 9.2)
- `00-engagement/retainer.md` (Japanese, client-facing)

## Example Output (YAML excerpt)

```yaml
retainer_id: RTN-20260901-001
project:
  id: <project-id>
  base_project_id: <original project>
tier: standard
monthly_fee: 80000
included_services:
  - monitoring: 5h
  - content_update: 5h
  - feature_addition: 5h
  - seo_geo_improvement: 3h
  - monthly_report: included
overage_rate: 12000
contract:
  start_date: 2026-09-01
  minimum_period_months: 6
  next_review_date: 2027-03-01
  termination_notice_days: 30
escalation_to_pro:
  trigger: "月平均 30h 超過 3 ヶ月連続"
  proposed_fee: 150000
```

## Boundary Notes

- For internal AILEAP projects: simplified Retainer (effort tracking only, no external invoicing)
- Retainer's content-update scope refers to client-supplied content; new copy / strategy is overage
- WMAO continuous SEO improvement is separate from this Retainer; this Retainer's SEO/GEO budget is for site-side fixes only

## Reference Documents

- `docs/pricing-strategy.md` Section 4 (tier playbook), Section 9.2 (YAML schema)
- `docs/agent-roster.md` Section 5-6 (commercial-manager)
