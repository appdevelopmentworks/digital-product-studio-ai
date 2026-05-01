---
name: sitemap-design
description: Design the information architecture and sitemap for a project. Output is a 3-tier hierarchy with URL conventions and rationale, validated against content depth and SEO/GEO friendliness. Lead agent ux-strategy-lead.
auto_trigger_keywords:
  - サイトマップ
  - sitemap design
  - 情報アーキテクチャ
  - ページ構成
  - URL 設計
---

# /sitemap-design

## Purpose

Produce a sitemap that maps the project's information architecture: pages, hierarchy, URL pattern, and rationale. This is the contract that downstream Practices (Creative for layout, Engineering for routing) work against.

## When to Use

- Strategy phase, after `/competitor-analysis` and `/requirements-gathering` v0
- Re-do during a /handoff-back-to-production renewal

## Lead Agent

**ux-strategy-lead** is the primary author. Validators:
- **content-strategy-lead**: ensures content depth fits the IA
- **seo-geo-strategist**: validates URL pattern, hreflang plan
- **strategy-director**: approves direction

## Inputs

- `projects/{id}/01-discovery/persona.md`
- `projects/{id}/01-discovery/user-journey-map.md`
- `projects/{id}/01-discovery/competitor-analysis.md`
- `projects/{id}/00-engagement/requirements-v0.md`
- `projects/{id}/PROJECT.md` (project type)

## Process

For A1 / A3:

1. Read JTBD (jobs to be done) for primary persona
2. Map JTBD to user journeys: awareness → consideration → action → retention
3. List pages each journey needs at minimum
4. Group into 3-tier hierarchy: Top → Category → Detail
5. Define URL pattern (kebab-case, semantic, < 60 chars where possible)
6. Validate with content-strategy-lead (will the content fit?)
7. Validate with seo-geo-strategist (URL friendliness, hreflang for multi-lang)
8. Submit to strategy-director for direction approval

For A2:

1. Single-page LP — sitemap is section-ordering instead of page hierarchy
2. Define section sequence: Hero → Problem → Solution → Proof → CTA → FAQ → Closing CTA
3. Define anchor IDs (`#hero`, `#features`, etc.) for in-page navigation

## Outputs

- `projects/{id}/02-strategy/sitemap.md` (Japanese for client deliverable)
  - ASCII tree diagram
  - URL table (path + page name + purpose + priority + parent)
  - Rationale paragraph

## Example Output (Japanese excerpt)

```markdown
# サイトマップ

**案件**: <project-id>
**作成日**: 2026-05-12
**作成者**: ux-strategy-lead

## 構造図

```
/
├── /about/
│   ├── /about/team/
│   └── /about/company/
├── /services/
│   ├── /services/ai-consulting/
│   ├── /services/digital-marketing/
│   └── /services/training/
├── /cases/
│   └── /cases/{case-slug}/
├── /blog/
│   ├── /blog/category/{cat-slug}/
│   ├── /blog/tag/{tag-slug}/
│   └── /blog/{post-slug}/
├── /contact/
└── (footer) /privacy/, /terms/, /tokushoho/
```

## URL 一覧表

| URL | ページ名 | 目的 | 優先度 |
|---|---|---|---|
| / | トップ | 第一印象とナビゲーション | P0 |
| /about/ | About 親 | 企業概要 | P0 |
| /about/team/ | チーム | 信頼性・GEO 引用 | P1 |
| ... | | | |

## 設計理由

決裁者ペルソナはまず /about/ で企業の信頼性を確認する傾向があるため、
グローバルナビの 2 番目に配置。
事例(/cases/)は /services/ の下ではなく独立配置とすることで、
GEO 引用時に「導入事例」として独立 URL で参照されやすくする。

(以下省略)
```

## Boundary Notes

- Maximum 3-tier depth — beyond that, IA gets unmaintainable
- URL slugs in English for SEO predictability (e.g., `/cases/` not `/事例/`)
- For multi-language, prefix with locale (`/ja/about/`, `/en/about/`)
- Content depth must be validated — empty pages dilute SEO/GEO

## Reference Documents

- `docs/templates/sitemap.md`
- `docs/geo-implementation-spec.md` Section 4.4 (BreadcrumbList structured data)
