---
name: infra-plan
description: Author the infrastructure plan for a B-series project — CI/CD pipelines, environment strategy (preview / staging / production), secrets management, monitoring/alerting, deployment gates, cost projection. Lead agent devops-engineer (Tier 3, new in v0.3) with backend-lead architectural review.
auto_trigger_keywords:
  - インフラ計画
  - infra plan
  - CI/CD
  - デプロイ
  - deployment
  - 環境構築
  - 監視
  - monitoring
  - インフラ設計
  - infrastructure
---

# /infra-plan

## Purpose

Produce the infrastructure plan that takes a B-series project from "code in main" to "running in production reliably." The plan covers pipelines, environments, secrets, monitoring, and deployment gates — and serves as the authoritative reference for all infra-as-code in the repo.

For A-series sites (websites on managed platforms), this skill produces a lighter "Section A" — Vercel / Cloudflare Pages config, basic uptime monitoring, SSL / DNS verification.

## When to Use

- B-series project initialization (before sprint 1's first deploy)
- Major infrastructure change (e.g., adding a new environment, switching DB provider)
- Pre-launch readiness review (delivery-director gate)
- Quarterly cost / capacity review

## Lead Agent

**devops-engineer** authors the plan. **backend-lead** reviews CI/CD architecture and quality gates. **technology-director** reviews stack-level infrastructure choices. **delivery-director** reviews launch-day readiness.

## Inputs

- `projects/{id}/02-strategy/product-strategy.md` (scale expectations, e.g., target user count)
- `projects/{id}/04-implementation/api-spec.md` (backend services to deploy)
- Database schema (`db/schema.ts`) — to size DB hosting tier
- Budget constraints from `00-engagement/estimate.yaml` or PROJECT.md
- Compliance requirements from `00-engagement/legal-review.yaml` (PII handling → hosting region)

## Process

### 1. Environment matrix

Document each environment:

| Environment | Purpose | Hosting | URL | Auto-deploy | Data |
|---|---|---|---|---|---|
| Local | Developer machine | n/a | localhost:3000 | n/a | Local DB or seeded fixtures |
| Preview | Per-PR preview | Vercel preview | <branch>.<proj>.vercel.app | Yes (on PR) | Shared dev DB |
| Staging | Pre-production | Vercel | staging.<domain> | Yes (on merge to main) | Staging DB (anonymized) |
| Production | Live | Vercel + Postgres | <domain> | **Manual** | Production DB |

Decision points to document:
- DB provider (Vercel Postgres / Neon / Supabase / Cloud SQL) — choose based on free-tier fit + region
- Region: closest to primary user base; for JP-primary B-series, Tokyo or Osaka

### 2. CI/CD pipeline

Sketch the workflow:

```yaml
# .github/workflows/ci.yml (B-series default)
name: CI
on: [push, pull_request]

jobs:
  ci:
    steps:
      - lint
      - typecheck
      - test (unit + integration via Vitest)
      - build
      - lighthouse (PR only)
      - axe-core a11y (PR only)
      - e2e (label-gated, PR only)
```

```yaml
# .github/workflows/deploy-prod.yml
name: Deploy to Production
on:
  workflow_dispatch:        # MANUAL trigger
    inputs:
      release_tag: required
jobs:
  deploy:
    environment: production    # GitHub env = required reviewer (delivery-director)
    steps:
      - placeholder-check    (.claude/hooks/placeholder-detection.sh equivalent)
      - lighthouse-budget    (.claude/hooks/lighthouse-budget.sh equivalent)
      - approval-check       (.claude/hooks/pre-deploy-approval-check.sh equivalent)
      - legal-pages-check    (.claude/hooks/legal-pages-check.sh equivalent)
      - deploy
      - smoke-test
      - notify Slack
```

### 3. Secrets management

List every required secret and its source:

| Secret | Used by | Source | Rotation policy |
|---|---|---|---|
| DATABASE_URL | backend-engineer | Vercel env | Per personnel change or 12 months |
| AUTH_SECRET | backend-engineer | Vercel env | Per personnel change or 12 months |
| STRIPE_SECRET_KEY | backend-engineer | Vercel env (production only) | Per breach or 12 months |
| RESEND_API_KEY | backend-engineer (email) | Vercel env | Per breach or 12 months |
| SENTRY_AUTH_TOKEN | CI (build-time) | GitHub Secrets | Per breach |
| (every other secret) | ... | ... | ... |

`.env.example` lists all required env vars with descriptions.

### 4. Monitoring stack

```
Uptime:    UptimeRobot (5-min check, multi-region)
                        ↓
                     Slack: #aileap-alerts

Errors:    Sentry (project per environment)
                        ↓
                     Slack + email (delivery-director on-call)

Performance: Vercel Analytics + Web Vitals
                        ↓
                     Weekly review by devops-engineer

Logs:      Vercel logs (built-in, 30-day retention)
                       + Axiom (if logs need >30d retention; v0.4 consideration)

Cost:      Vercel + database provider dashboards
                        ↓
                     Monthly review with delivery-director
```

For A-series: UptimeRobot only is the v0.3 default. Sentry and Vercel Analytics optional.

### 5. Deployment gates

The deploy workflow integrates with existing AILEAP hooks:

| Hook (already built) | Equivalent CI step | Owner |
|---|---|---|
| `placeholder-detection.sh` | run scan against build artifacts before deploy | client-success-lead |
| `lighthouse-budget.sh` | Lighthouse CI threshold check | technology-director |
| `pre-deploy-approval-check.sh` | check `approvals.yaml::launch_approval` | client-success-lead |
| `legal-pages-check.sh` | verify legal page presence + lawyer-confirmed | delivery-director |

CI fails if any gate fails. Manual deploy workflow re-runs the gates as a final check before production.

### 6. Backup and disaster recovery

Document for B-series:
- DB: automatic daily backup retained 30 days (default for Vercel Postgres / Neon)
- DB: weekly point-in-time recovery test (restoration to staging → smoke test → discard)
- Code: GitHub is the source of truth (no recovery needed)
- Infra config: Vercel project + GitHub Actions are recoverable from `infra/` IaC + `.env.example`

For A-series: skip DB section; backup target is the source repo.

### 7. Cost projection

Estimate first 12-month cost:

| Item | Tier / size | Monthly | Annual |
|---|---|---|---|
| Vercel Pro | Team plan | $20 | $240 |
| Vercel Postgres | Pro tier (256MB) | $20 | $240 |
| Sentry Team | 50K events | $26 | $312 |
| UptimeRobot | Free | $0 | $0 |
| Domain | (one-time / yearly) | — | $20 |
| **Total** | | **~$66** | **~$812** |

Surface to delivery-director for inclusion in `estimate.yaml::patterns.retainer.monthly_fee_jpy` if not already.

### 8. Write the plan

Output `projects/{id}/04-implementation/infra-plan.md`:

```markdown
# インフラ計画 — v1

**案件**: {project-id}
**作成者**: devops-engineer
**承認**: backend-lead, technology-director, delivery-director

## 環境マトリクス
(本スキル §1)

## CI/CD パイプライン
(YAML 抜粋 + 説明)

## シークレット管理
(全 env var 一覧 + 出典 + ローテーション)

## 監視スタック
(stack 図解 + アラート先)

## デプロイゲート
(hook 連動 + manual approval)

## バックアップ・障害復旧
(B-series のみ)

## コスト試算
(12 ヶ月計画)

## ランブック索引

- infra/runbooks/db-migration-rollback.md
- infra/runbooks/ssl-renewal-failure.md
- infra/runbooks/sentry-alert-triage.md
```

## Outputs

- `projects/{id}/04-implementation/infra-plan.md` (Japanese)
- `infra/` directory with IaC files if applicable
- `.github/workflows/ci.yml`, `deploy-prod.yml` (or equivalent)
- `.env.example` updated with full env var list
- Initial runbooks in `infra/runbooks/`

## Boundary Notes

- B-series primary. A-series produces the lighter "Section A" version (Vercel + UptimeRobot only).
- Cost estimates are projections; actuals tracked monthly via `commercial-manager` for retainer reconciliation.
- Production deploy is **manual approval-gated** in v0.3 default. This is a Definition-of-Done item, not optional.
- Secrets are never committed to git. Even one slip requires rotation.
- Monitoring without alerting is wasted effort — every monitor must page somewhere.

## Reference Documents

- `.claude/agents/tier3-devops-engineer.md` (lead agent definition)
- `.claude/agents/tier2-backend-lead.md` (architectural review)
- `.claude/hooks/lighthouse-budget.sh`, `pre-deploy-approval-check.sh`, `legal-pages-check.sh`, `placeholder-detection.sh`
- `docs/setup-requirements.md §1.7` (smoke-test for hooks themselves)
