---
description: Estimate files must include all 3 pricing patterns (Fixed/T&M/Retainer). Internal AILEAP projects skip external pricing. Currency is JPY integers. Mandatory Retainer pattern enforces C-3 fix.
globs:
  - "projects/**/00-engagement/estimate*"
  - "projects/**/00-engagement/retainer*"
  - "docs/templates/estimate*"
  - "docs/templates/retainer*"
alwaysApply: false
---

# Estimate & Pricing Conventions

Reference: `docs/pricing-strategy.md` (C-3 fix — Retainer mandatory)

## The 3-Pattern Mandate

Every estimate produced by `/estimate` skill MUST present **all three patterns**:
1. **Fixed Price** (固定価格) — capped scope, lower risk for client
2. **Time & Materials** (実費精算) — flexible scope, capped at estimate ceiling
3. **Retainer** (月額保守) — post-launch recurring, LTV vehicle

**Never** produce a single-pattern estimate. If a client asks for "just Fixed Price",
still include T&M and Retainer patterns with a note that they're for reference.

This is the C-3 fix — Retainer awareness from first touchpoint drives LTV.

## Pricing Ranges by Project Type

| Type | Fixed Price | T&M Ceiling | Retainer Range |
|---|---|---|---|
| A1 Corporate | 50-150万円 | 60-160万円 | 5-20万円/月 |
| A2 Landing Page | 20-50万円 | 25-55万円 | 3-8万円/月 |
| A3 Mediasite | 80-200万円 | 90-220万円 | 8-30万円/月 |

T&M ceiling = Fixed + ~10-15% buffer for scope variance.

## estimate.yaml Schema

```yaml
estimate_id: EST-20260515-001
project_id: AXYZ-20260601-001
created_at: 2026-05-15
valid_until: 2026-06-15           # 30-day validity default

patterns:
  fixed:
    total_jpy: 1200000             # Integer, JPY, no decimals
    hours_included: 160
    payment_schedule:
      - phase: contract_signing
        ratio: 0.3                 # 30% upfront
      - phase: design_approval
        ratio: 0.3
      - phase: launch
        ratio: 0.4
    scope_notes: |
      ページ数: 7ページ（トップ、会社概要、サービス3、採用、お問い合わせ）
      多言語: 日英2言語

  time_and_materials:
    hourly_rate_jpy: 12000
    estimated_hours: 160
    ceiling_jpy: 1400000           # Not-to-exceed ceiling
    billing_cycle: monthly

  retainer:
    tier: standard                 # light | standard | pro | enterprise
    monthly_fee_jpy: 80000
    included_hours: 18             # breakdown below
    overage_rate_jpy: 12000
    minimum_period_months: 6
    services:
      monitoring: 5                # hours/month
      content_update: 5
      feature_addition: 5
      seo_geo_improvement: 3
      monthly_report: included

totals:
  fixed_total_jpy: 1200000
  tm_ceiling_jpy: 1400000
  retainer_annual_projection_jpy: 960000   # monthly × 12

notes: ""
```

## Currency Rules

- All monetary values: **integer JPY** (no decimals, no ¥ symbol in YAML)
- ✅ `monthly_fee_jpy: 80000`
- ❌ `monthly_fee: "¥80,000"` / `monthly_fee: 80000.00`
- Field suffix `_jpy` to make currency explicit

## Internal AILEAP Projects

When `internal_client: true` in PROJECT.md:
- Skip external pricing calculations
- Use `internal_effort_hours` instead of `total_jpy`
- Retainer field: simplified (effort tracking only, no invoicing)

```yaml
# Internal AILEAP project estimate
estimate_id: EST-INTERNAL-001
project_id: AILEAP-20260401-001
internal_client: true
internal_effort_hours: 240
note: "内部プロジェクト — 外部請求なし。工数管理のみ"
```

## Retainer Tier Thresholds

| Tier | Monthly Fee | Typical Scenario |
|---|---|---|
| Light | 5-10万円/月 | Small A1/A2, monitoring only |
| Standard | 10-20万円/月 | Standard A1/A3, updates + minor features |
| Pro | 20-50万円/月 | Larger A1/A3, adds SEO/GEO strategy review |
| Enterprise | 50万円+/月 | B-series (v0.3+) |

**Tier upgrade trigger**: 3 consecutive months with average hours > monthly cap
→ commercial-manager must propose upgrade to next tier.
