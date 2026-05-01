---
name: geo-audit
description: Run GEO (Generative Engine Optimization) checklist per docs/geo-implementation-spec.md Section 8 — llms.txt, JSON-LD, citation-friendliness, trust signals. Lead agent seo-geo-strategist.
auto_trigger_keywords:
  - GEO 監査
  - llms.txt
  - LLM citation
  - 生成 AI 最適化
  - AI 検索最適化
---

# /geo-audit

## Purpose

Verify GEO (LLM-citation optimization) readiness. The LLM-citation half of the audit; pair with `/seo-audit` for classic-search half.

GEO is AILEAP's differentiation axis — failing GEO audit blocks launch.

## When to Use

- QA phase (Implementation → QA gate)
- Strategy phase to audit existing site
- Post-launch 30-day verification

## Lead Agent

**seo-geo-strategist** is the sole owner.

## Inputs

- `projects/{id}/02-strategy/seo-geo-strategy.md`
- `docs/geo-implementation-spec.md` Section 8 (canonical checklist)
- All page files
- `/llms.txt`
- Live staging URL

## Process

Run the canonical checklist from `docs/geo-implementation-spec.md` Section 8.

### Required (all v0.2 projects)

- [ ] `/llms.txt` published
- [ ] `/llms.txt` has all required sections (description, main_pages, expertise, citation_guidelines)
- [ ] Organization JSON-LD on root
- [ ] WebSite JSON-LD on root
- [ ] WebPage JSON-LD on every page
- [ ] BreadcrumbList JSON-LD on 2+-depth pages
- [ ] OGP meta tags complete (og:title, og:description, og:image, og:url, og:type)
- [ ] Twitter Card complete (twitter:card, twitter:title, twitter:description, twitter:image)
- [ ] OGP image ≥ 1200×630 px
- [ ] HTTPS-only enforced
- [ ] sitemap.xml has lastmod for all entries

### Recommended (per project type)

#### A1 / A3
- [ ] FAQPage JSON-LD when FAQ section exists

#### A3 only
- [ ] All articles have Article + Author JSON-LD
- [ ] All articles open with conclusion in first 100 characters (citation-friendliness check)
- [ ] All articles have publishDate + dateModified
- [ ] Author profile pages exist with structured Author info
- [ ] Editorial cadence documented (for WMAO continuation)

#### A2
- [ ] Product or Service JSON-LD

### Advanced (v0.3+)
- `/llms-full.txt` (full-text version) — optional in v0.2
- SpeakableSpecification (voice AI)
- AggregateRating / Review (e-commerce / service sites)
- HowTo (how-to articles)
- VideoObject (video content)

## Outputs

- `projects/{id}/05-qa/geo-audit.md` (Japanese, structured per `docs/geo-implementation-spec.md` Section 8.4 schema)

## Example Output (Japanese excerpt)

```markdown
# GEO 監査レポート

**案件**: <project-id>
**監査日**: 2026-07-25
**監査者**: seo-geo-strategist
**対象 URL**: https://staging.example.com

## サマリー

総合スコア: 88 / 100

| 領域 | スコア | 評価 |
|---|---|---|
| 必須項目 | 10/11 | ⚠️ 1 件未実装 |
| 推奨項目(A1) | 7/7 | ✅ |
| 高度項目(v0.3+) | n/a | — |

## 必須項目チェック

| # | 項目 | 状態 | 備考 |
|---|---|---|---|
| 1 | /llms.txt 公開 | ✅ | |
| 2 | /llms.txt 必須セクション | ✅ | description / main_pages / expertise / citation_guidelines 揃う |
| 3 | Organization JSON-LD | ✅ | |
| 4 | WebSite JSON-LD | ✅ | |
| 5 | WebPage JSON-LD(全ページ) | ⚠️ | /contact/ で欠落 |
| 6 | BreadcrumbList(2 階層以上) | ✅ | |
| 7 | OGP メタ | ✅ | |
| 8 | Twitter Card | ✅ | |
| 9 | OG 画像 1200×630 | ✅ | |
| 10 | HTTPS-only | ✅ | |
| 11 | sitemap.xml lastmod | ✅ | |

## Critical 問題

なし(必須項目で 1 件 High)

## High 問題

1. /contact/ ページに WebPage JSON-LD が未実装 → frontend-engineer に実装依頼
   修正案: app/contact/page.tsx に metadata 内の JSON-LD ブロックを追加

## 修正後再監査

未実装の WebPage JSON-LD 修正後、再度 /geo-audit を実行し 100% 合格を確認。
```

## Boundary Notes

- GEO audit is read-only — findings are fed to frontend-engineer / cms-engineer for fixes
- AILEAP differentiation axis — failure must be fixed, not waived
- LLM citation outcomes are observable in post-launch 30-day report (separate skill)
- Pair with `/seo-audit` for full search-coverage

## Reference Documents

- `docs/geo-implementation-spec.md` — full spec
- `docs/templates/seo-geo-strategy.md`
