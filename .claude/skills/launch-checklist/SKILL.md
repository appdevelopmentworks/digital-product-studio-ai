---
name: launch-checklist
description: Pre-launch verification — DNS, SSL, redirects, analytics, monitoring, legal pages, approvals. Comprehensive go/no-go check. Lead agent delivery-director with seo-geo-strategist on SEO checks.
auto_trigger_keywords:
  - 公開チェック
  - launch checklist
  - ローンチ
  - 公開前チェック
  - go-live
  - 本番デプロイ
---

# /launch-checklist

## Purpose

Run the comprehensive pre-launch checklist. Pass = green-light deploy. Fail = block launch and fix.

## When to Use

- Just before production deploy (Launch phase)
- Before staging-to-production cutover for renewals (A4 / C3 type)

## Lead Agent

**delivery-director** orchestrates. **seo-geo-strategist** runs SEO/GEO sub-checks. **frontend-engineer** runs technical sub-checks.

## Inputs

- All audit reports (`/seo-audit`, `/geo-audit`, `/accessibility-audit`)
- `approvals.yaml` — must contain launch approval
- Lighthouse local run results
- Production environment configuration

## Process

Run the checklist, marking each item Pass / Fail / N/A:

### 1. Approvals
- [ ] Launch approval recorded in `approvals.yaml`
- [ ] Design approval recorded
- [ ] Requirements approval recorded

### 2. DNS / SSL / Hosting
- [ ] Production domain configured
- [ ] SSL certificate valid
- [ ] DNS propagation tested
- [ ] HSTS configured (preload eligibility)
- [ ] Hosting auto-scaling / cache rules set

### 3. SEO/GEO
- [ ] `/seo-audit` passed (≥ 95)
- [ ] `/geo-audit` passed (≥ 90 with no Critical)
- [ ] sitemap.xml deployed at `/sitemap.xml`
- [ ] robots.txt deployed
- [ ] llms.txt deployed
- [ ] Search Console verified
- [ ] Bing Webmaster Tools verified (optional)

### 4. Accessibility
- [ ] `/accessibility-audit` passed (no Critical)
- [ ] Lighthouse Accessibility ≥ 95

### 5. Performance
- [ ] Lighthouse Performance ≥ 90 on key pages (production-like environment)
- [ ] Core Web Vitals: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1
- [ ] Image optimization verified
- [ ] Critical CSS inlined
- [ ] No render-blocking resources

### 6. Analytics & Tracking
- [ ] GA4 configured and event tracking verified
- [ ] GTM containers configured (if used)
- [ ] Search Console linked
- [ ] Cookie consent functioning (Consent Mode v2 if applicable)

### 7. Legal
- [ ] Privacy policy page exists at expected URL
- [ ] Terms page exists at expected URL
- [ ] Tokushoho page exists (if B2C)
- [ ] All 3 legal templates have lawyer-confirmation header (`legal-pages-check.sh` enforces)
- [ ] Cookie consent banner active

### 8. Forms & Backend
- [ ] Contact form submission tested
- [ ] Backend endpoint receiving submissions
- [ ] Email/CRM forwarding verified
- [ ] Honeypot/anti-spam working
- [ ] Privacy policy consent checkbox required

### 9. CMS (if A1 with WP or A3)
- [ ] CMS admin accounts configured
- [ ] Editor permissions correct
- [ ] Custom post types tested
- [ ] ACF field groups verified
- [ ] Backups configured

### 10. Redirects (if renewal)
- [ ] `redirect-map.md` complete
- [ ] All old URLs redirect to new equivalents
- [ ] 301 status codes (not 302)

### 11. Monitoring
- [ ] Uptime monitoring configured (UptimeRobot or hosting native)
- [ ] Error monitoring configured (if Next.js — Sentry recommended; v0.3+)

### 12. Final Smoke Test
- [ ] Click through main user journeys on production
- [ ] Test on mobile + tablet + desktop
- [ ] Test on Chrome / Safari / Firefox / Edge
- [ ] No 404s on internal navigation

## Outputs

- `projects/{id}/06-launch/launch-checklist.md` (Japanese, fully filled)
- Go / No-Go decision: structured at top of checklist

## Example Output (Japanese excerpt)

```markdown
# 公開チェックリスト

**案件**: <project-id>
**確認日**: 2026-08-01
**確認者**: delivery-director
**判定**: ✅ GO

## サマリー

全 70 項目中: Pass 68 / Fail 0 / N/A 2

## 1. 承認

- [x] 公開承認記録(approvals.yaml CO-... + APV-005)
- [x] デザイン承認記録(APV-003)
- [x] 要件承認記録(APV-002)

## 2. DNS / SSL / Hosting

- [x] 本番ドメイン: example.com 設定済
- [x] SSL: Let's Encrypt 有効、2026-11-01 まで
- [x] DNS 浸透: 主要 5 都市から確認済
- [x] HSTS: max-age=63072000; includeSubDomains; preload

(以下省略)
```

## Boundary Notes

- Any Critical Fail blocks launch — escalate to studio-director / Shin
- Pre-deploy hooks (`pre-deploy-approval-check.sh`, `legal-pages-check.sh`, `lighthouse-budget.sh`) catch some items automatically
- Post-launch monitoring continues 30-day verification (separate `seo-geo-strategist` deliverable)

## Reference Documents

- `docs/templates/launch-checklist.md`
- `docs/requirements-v0.2.md` Section 20 (gate criteria)
