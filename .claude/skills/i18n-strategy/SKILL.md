---
name: i18n-strategy
description: Design the multi-language strategy — target languages, URL structure, translation pipeline, hreflang plan, locale considerations. Lead agent localization-specialist (Q5 priority — v0.2 forward-pulled).
---

# /i18n-strategy

## Purpose

Define how the project handles multi-language. v0.2 supports JA / EN / ZH-CN / KO as standard target languages — Shin's native or near-native review is AILEAP's differentiation.

## When to Use

- Strategy phase, when project has multi-language scope (declared during `/client-onboarding`)
- Re-do for renewal projects expanding language coverage

## Lead Agent

**localization-specialist** is the sole owner. Coordinates with:
- **copywriter**: source-language translation-friendliness
- **seo-geo-strategist**: hreflang plan
- **technology-director**: stack-level i18n decisions

## Inputs

- `00-engagement/onboarding-record.md` (multi-language scope confirmation)
- `PROJECT.md` (`target_languages` field)
- `02-strategy/sitemap.md` (URL structure for locale prefix)
- `docs/language-policy.md` (the canonical language policy)

## Process

1. **Determine target languages** — JA / EN / ZH-CN / KO are v0.2 standards
2. **Determine launch scope**:
   - All languages at launch (full)
   - JA + 1 other at launch, others later (phased)
   - JA-only at launch, i18n-ready architecture (defer)
3. **Determine URL structure**:
   - Sub-path (recommended for v0.2): `/ja/`, `/en/`, `/zh/`, `/ko/`
   - Sub-domain: `en.example.com` (heavier ops)
   - Separate domain: `example.com` + `example.cn` (heaviest ops)
4. **Determine translation source-of-truth**:
   - JSON files (next-intl, Astro i18n)
   - Database (WordPress + Polylang)
5. **Design translation pipeline**:
   - Source-language drafts by copywriter (JA primary)
   - Machine translation via DeepL API or Claude/GPT-4 with style guide
   - **Native review by Shin** (JA/EN/ZH/KO native or high-fluency speaker)
   - Review feedback loop for terminology consistency
6. **hreflang plan** (coordinate with seo-geo-strategist)
7. **Locale-specific considerations**:
   - Date / number formatting
   - Currency display
   - Honorifics (敬語 in JA, polite tier in KO)

## Outputs

- `02-strategy/i18n-strategy.md` (Japanese, client deliverable; impl notes English-keyed)

## Example Output (Japanese excerpt)

```markdown
# 多言語対応戦略

**案件**: <project-id>
**作成日**: 2026-06-05
**作成者**: localization-specialist

## 1. 対象言語

- **日本語(ja)**: デフォルト・オリジナル
- **英語(en)**: 海外顧客対応
- **中国語簡体字(zh-CN)**: アジア展開準備(Phase 2 検討)
- **韓国語(ko)**: 同上

v0.2 ローンチ時:
- 確定: ja + en
- Phase 2 候補: zh-CN, ko(+30 万円/言語)

## 2. URL 構造

サブパス方式を採用:
- ja(デフォルト): /ja/services/
- en: /en/services/
- zh: /zh/services/(Phase 2)
- ko: /ko/services/(Phase 2)

理由: 単一ドメインで権威性を集約、ホスティング・運用コスト最小、SEO 整合最適

## 3. 翻訳パイプライン

```
[1] copywriter が日本語で執筆(翻訳しやすい構造で)
[2] DeepL API で機械翻訳(ja → en)
[3] Shin によるネイティブレビュー
[4] terminology glossary に新語追加
[5] 翻訳ファイル(en.json)に反映
```

## 4. 翻訳しやすい原文の書き方

copywriter への指示として:
- 短文(1 段落 ≤ 4 文)
- 慣用句・駄洒落・漢字遊びを避ける
- 業界用語は最初に定義、以降一貫
- 文化固有のレファレンスは意図的な場合のみ(翻訳可能なもの)

## 5. hreflang 設定

すべてのページで:
```html
<link rel="alternate" hreflang="ja" href="https://example.com/ja/services" />
<link rel="alternate" hreflang="en" href="https://example.com/en/services" />
<link rel="alternate" hreflang="x-default" href="https://example.com/ja/services" />
```

## 6. ロケール固有の対応

### 日本語(ja)
- 敬語: 丁寧語ベース(「ですます」)
- 数字: 半角、3 桁区切りカンマ
- 日付: ISO 8601(2026-08-01)推奨

### 英語(en)
- トーン: フォーマル(B2B SME 向け)
- 数字: comma 区切り
- 日付: August 1, 2026
- 通貨: ¥ または USD で併記(別 UI)

## 7. 実装方式(Next.js 採用時)

- next-intl ライブラリを採用
- middleware.ts で locale 自動検出
- 翻訳ファイルは i18n/{locale}.json
- 詳細は localization-specialist と nextjs-specialist で実装協議

## 8. 翻訳費用見積

```
初回翻訳(ja → en):
  全 7 ページ × 平均 2,000 字 = 14,000 字
  DeepL API 使用: 自動(コスト微小)
  Shin レビュー: 4-6 時間 = 60,000 円(commercial-manager 計上)

Phase 2 zh / ko 追加:
  各言語あたり: 60,000-100,000 円(レビュー含む)
```
```

## Boundary Notes

- Full 4-language template translation is v0.3+ scope
- Native review by Shin is AILEAP's differentiation — don't outsource without good reason
- Multi-language SEO via hreflang must be cross-validated by seo-geo-strategist
- WordPress + Polylang scenarios are wordpress-specialist territory; you coordinate

## Reference Documents

- `docs/requirements-v0.2.md` Section 16 (multi-language strategy)
- `docs/language-policy.md` (canonical policy)
- `docs/agent-roster.md` Section 6-3 (localization-specialist)
