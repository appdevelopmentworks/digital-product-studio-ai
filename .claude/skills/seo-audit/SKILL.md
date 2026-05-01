---
name: seo-audit
description: Run classic-SEO checklist (meta tags, structured data, sitemap, robots, canonical, hreflang, internal links, image alt, page speed). Output is a checklist report with critical findings. Lead agent seo-geo-strategist.
auto_trigger_keywords:
  - SEO 監査
  - SEO audit
  - メタタグ
  - sitemap.xml
  - robots.txt
  - canonical
---

# /seo-audit

## Purpose

Verify classic-SEO readiness before launch and during post-launch verification. The classic-SEO half of the audit; pair with `/geo-audit` for the LLM-citation half.

## When to Use

- QA phase (Implementation → QA gate)
- Strategy phase to audit existing site (when reviewing inherited sites)
- Post-launch 30-day verification (lighter rerun)

## Lead Agent

**seo-geo-strategist** is the sole owner. **frontend-engineer** contributes implementation-side checks.

## Inputs

- `projects/{id}/02-strategy/seo-geo-strategy.md`
- All page files in `app/**`, `pages/**`, or theme templates
- `sitemap.xml`, `robots.txt`, `llms.txt`
- Live staging URL (for runtime checks)

## Process

Run through the checklist:

### 1. Meta Tags (every page)

- `<title>` present, ≤ 60 chars, descriptive
- `<meta name="description">` present, ≤ 160 chars, includes target keyword
- `og:title`, `og:description`, `og:image`, `og:url`, `og:type` complete
- `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image` complete
- `og:image` is 1200×630, accessible URL

### 2. Structured Data (JSON-LD)

- Organization JSON-LD on root layout
- WebSite JSON-LD on root layout
- WebPage JSON-LD on every page
- BreadcrumbList on 2+-depth pages
- FAQPage when FAQ section exists
- Article + Author on blog detail pages
- All JSON-LD valid (test mentally with Schema.org or Google Rich Results Test)

### 3. Sitemap & robots

- `sitemap.xml` exists and is registered
- `lastmod` populated for all entries
- `robots.txt` allows search engines, disallows admin/staging paths
- `robots.txt` references sitemap URL

### 4. Canonical & hreflang

- Canonical URL on every page (avoid duplicates)
- hreflang on every page (multi-language)
- hreflang reciprocal (each language references all others)
- `x-default` set

### 5. Internal Links

- Major pages reachable within 3 clicks from home
- No broken internal links (test crawl)
- Anchor text descriptive (not "click here")

### 6. Images

- Every content image has descriptive alt text (see `validate-images.sh` hook)
- No decorative images with redundant alt
- WebP/AVIF where applicable

### 7. Page Speed (Lighthouse SEO score)

- Lighthouse SEO = 100 (per technology-director's budget)
- No render-blocking resources
- HTTPS-only
- Mobile-friendly (responsive)

## Outputs

- `projects/{id}/05-qa/seo-audit.md` (Japanese, structured)

## Example Output (Japanese excerpt)

```markdown
# SEO 監査レポート

**案件**: <project-id>
**監査日**: 2026-07-25
**監査者**: seo-geo-strategist
**対象 URL**: https://staging.example.com

## サマリー

総合: 92 / 100
Critical: 0 件
High: 2 件
Medium: 3 件

## 1. メタタグ

| ページ | title | description | og | twitter | 評価 |
|---|---|---|---|---|---|
| / | ✅ | ✅ | ✅ | ✅ | Pass |
| /services/ | ✅ | ✅ | ✅ | ✅ | Pass |
| /services/ai-consulting/ | ✅ | ⚠️ 165字 | ✅ | ✅ | High: description が 160 字超 |

## 2. 構造化データ

| ページ | Organization | WebSite | WebPage | BreadcrumbList | 評価 |
|---|---|---|---|---|---|
| / | ✅ | ✅ | ✅ | n/a | Pass |
| /services/ | ✅ | ✅ | ✅ | ✅ | Pass |
| /blog/{post} | ✅ | ✅ | ✅ | ✅ + Article + Author | Pass |

## Critical 問題: なし

## High 問題

1. /services/ai-consulting/ description が 165 字 → 155 字以内に短縮
2. /blog/2026-07-launch.html — title が 65 字 → 60 字以内に短縮

## Medium 問題

1. ...
```

## Boundary Notes

- Audit is read-only — do NOT modify code; report findings to frontend-engineer / cms-engineer for fix
- Pair with `/geo-audit` for LLM-citation coverage
- Pair with `/accessibility-audit` for a11y (separate skill)

## Reference Documents

- `docs/geo-implementation-spec.md` Section 8 (audit checklist for combined SEO+GEO)
- `docs/templates/seo-geo-strategy.md`
