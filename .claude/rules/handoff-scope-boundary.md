---
description: Handoff scope boundaries between this org (digital-product-studio-ai) and upstream (apex-consulting-ai) and downstream (web-marketing-ai-org / WMAO). Defines B-C1, B-C2, F-C1 boundaries.
globs:
  - "projects/**/06-handoff/**"
  - "projects/**/00-engagement/handoff-*"
  - "docs/handoff-protocols.md"
alwaysApply: false
---

# Handoff Scope Boundaries

Reference: `docs/handoff-protocols.md`, `docs/requirements-v0.2.md` Section 13

## This Organization's Scope

**digital-product-studio-ai** is the middle layer of AILEAP's 3-org architecture:

```
apex-consulting-ai          → [apex handoff] →
digital-product-studio-ai   ← you are here
                            → [wmao handoff] →
web-marketing-ai-org (WMAO)
```

## Boundary B-C1: SEO/GEO Post-Launch Verification

| Period | Owner |
|---|---|
| Launch day through **Day 30** | **This org** (seo-geo-strategist) |
| Day 31 onwards | **WMAO** (continuous SEO improvement) |

The B-C1 deliverable from this org:
- 30-day SEO/GEO verification report
- Baseline metrics (impressions, clicks, GSC data, LLM citation checks)
- Handoff memo with recommendations for WMAO

Do NOT scope WMAO continuous improvement work into this org's deliverables.

## Boundary B-C2: Initial Article Production

| Scope | Owner |
|---|---|
| Initial **5-10 articles** | **This org** (copywriter + content-strategy-lead) |
| Article **11 onwards** | **WMAO** (content production pipeline) |

This applies to A3 (mediasite) projects. Initial articles establish the
content template and tone — production volume is WMAO's domain.

## Boundary F-C1: Stage Expansion (v0.2 scope)

v0.2 scope is limited to A-series projects (A1/A2/A3):
- B-series (product development) → v0.3
- C-series (consulting/service) → v0.4+

Do NOT scope B-series work items, B-series agents (product-director activation),
or C-series workflows into v0.2 project plans.

## Apex Handoff (Incoming)

When receiving a handoff from apex-consulting-ai:

Required fields in `apex-to-dpsai-handoff.yaml`:
```yaml
handoff_id: APX-20260601-001
from_org: apex-consulting-ai
to_org: digital-product-studio-ai
client_name: <<CLIENT>>
project_type: A1          # apex's recommendation
strategic_context: |      # What apex discovered
  ...
recommended_kgi: ""
recommended_kpi: []
assets_provided: []       # logos, brand guides, etc.
handoff_at: 2026-06-01
```

If apex handoff is missing required fields, request completion before proceeding.
Do NOT proceed to `/client-onboarding` without a valid apex handoff package.

## WMAO Handoff (Outgoing)

When handing off to web-marketing-ai-org, use `/handoff-to-marketing` skill.

Required in `dpsai-to-wmao-handoff.yaml`:
```yaml
handoff_id: DPS-20260901-001
from_org: digital-product-studio-ai
to_org: web-marketing-ai-org
project_id: AXYZ-20260601-001
handoff_type: post-launch             # post-launch | mid-project (exception)
site_url: https://example.com
cms_access_provided: true
analytics_access_provided: true       # GA4, GSC
baseline_lighthouse_scores:
  performance: 95
  accessibility: 98
  seo: 100
  best_practices: 93
b_c1_report_ref: "06-handoff/seo-geo-30day-report.md"
b_c2_articles_count: 7               # articles produced by this org
wmao_scope_start: "Article 8+ / Day 31 SEO"
handoff_at: 2026-09-01
```

## What to Include vs Exclude in Handoff Packages

### Include (this org delivers)
- Complete source code and deployment access
- CMS credentials and setup docs
- Design system and component library
- Initial 5-10 articles (B-C2 scope)
- 30-day SEO/GEO verification report (B-C1 scope)
- Retainer contract (if applicable)
- Training materials for CMS

### Exclude (WMAO scope — do NOT promise in this org's SOW)
- Ongoing content production (article 11+)
- Continuous SEO improvement (day 31+)
- Performance marketing / ad campaigns
- Social media management
- Email marketing automation
