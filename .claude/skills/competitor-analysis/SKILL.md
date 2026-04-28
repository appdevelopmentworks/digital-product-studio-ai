---
name: competitor-analysis
description: Web-perspective competitor analysis (5 competitors) covering site structure, hero narrative, service presentation, case format, content cadence, SEO/GEO posture, tone of voice. Lead agent content-strategy-lead with seo-geo-strategist contributing.
---

# /competitor-analysis

## Purpose

Produce a web-perspective competitor analysis that informs strategy and design. NOT a market-perspective analysis (that belongs to apex). Focus is on what 5 reference sites are doing well or badly, and how AILEAP positions against them.

## When to Use

- Discovery phase, before `/sitemap-design` and `/content-strategy`
- When repositioning is needed (e.g., during a /handoff-back-to-production renewal)

## Lead Agent

**content-strategy-lead** is the primary author. **seo-geo-strategist** contributes the SEO/GEO posture row.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (apex's market context, if any)
- `projects/{id}/00-engagement/onboarding-record.md`
- 5 competitor URLs (provided by client or determined by content-strategy-lead with Shin)

## Process

1. **Select 5 competitors** mixing:
   - Direct competitors (same offering, same audience)
   - Aspirational benchmarks (best-in-class)
   - Adjacent-industry references (different industry, similar persona)
2. **For each competitor, evaluate**:
   - Site structure (IA depth, primary nav, depth of detail)
   - Hero / opening narrative (first 5 seconds impression)
   - Service / product presentation (how they explain what they do)
   - Case study / proof format (testimonials, numbers, before/after)
   - Content cadence (blog, news — frequency)
   - SEO/GEO posture (meta, structured data, llms.txt, citation-friendliness)
   - Tone of voice (formal/casual, authority/peer)
3. **Synthesize**:
   - Overall positioning recommendation for this client
   - Differentiation opportunities (where AILEAP / client can stand out)
   - Risks (where competitors are aggressively strong)

## Outputs

- `projects/{id}/01-discovery/competitor-analysis.md` (Japanese, structured Markdown)

Format: per-competitor section + overall synthesis + 1-paragraph positioning recommendation.

## Example Output (Japanese excerpt)

```markdown
# 競合分析レポート

**案件**: <project-id>
**作成日**: 2026-05-08
**作成者**: content-strategy-lead + seo-geo-strategist

## 1. 競合サイト 5 社

| # | URL | 種別 | カテゴリ |
|---|---|---|---|
| 1 | competitor-a.example.com | 直接競合 | AI コンサル |
| 2 | competitor-b.example.com | 直接競合 | AI コンサル |
| 3 | aspiration-x.com | アスピレーション | 海外 SaaS |
| 4 | adjacent-y.example.com | 隣接業界 | DX コンサル |
| 5 | adjacent-z.example.com | 隣接業界 | デジタルマーケ |

## 2. 各社評価

### 競合 A(competitor-a.example.com)

- **サイト構造**: 4 階層、サービス詳細が深い
- **ヒーロー**: 「AI で経営を変える」の抽象的訴求
- **サービス提示**: 業界別の事例ページ充実
- **証跡**: 大手企業ロゴ並列、定量数値少ない
- **コンテンツ**: 月 2 本のブログ、人月コミット型
- **SEO/GEO**: 構造化データ未実装、llms.txt なし
- **トーン**: 権威系・硬め

(以下省略)

## 3. 総合ポジショニング推奨

5 社中、構造化データと llms.txt を実装している企業はゼロ。
AILEAP の GEO 標準装備が明確な差別化軸となる。
コンテンツ更新頻度では競合 B が最も高頻度(週 1)。
本案件では「速度」と「GEO」の 2 軸での訴求を推奨する。
```

## Boundary Notes

- Web-perspective only — do NOT analyze competitor's business model, pricing strategy, M&A history (that's apex)
- Do NOT scrape or copy competitor content into deliverables (copyright)
- Do NOT name-and-shame competitors in client-facing copy (legal risk per `docs/legal-escalation-rules.md` Section 5.5 Q5)

## Reference Documents

- `docs/templates/competitor-analysis.md`
- `docs/geo-implementation-spec.md` Section 8 (audit checklist used for SEO/GEO posture row)
