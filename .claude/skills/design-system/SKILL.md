---
name: design-system
description: Produce the project's design system (typography, color, spacing, components, motion, accessibility). The a11y chapter is mandatory per H-4 fix. Lead agent art-direction-lead with ui-designer contributing component-level details.
auto_trigger_keywords:
  - デザインシステム
  - design system
  - デザイントークン
  - デザイン規約
  - カラーパレット
---

# /design-system

## Purpose

Produce the project's design system that all visual decisions reference. The design system is the contract: ui-designer follows it, frontend-engineer implements from it, all visual elements draw tokens from it.

## When to Use

- Design phase, after `/sitemap-design` and `/content-strategy` are settled
- Re-do for major rebrand or A4 renewal projects

## Lead Agent

**art-direction-lead** is the primary author. **ui-designer** contributes component-level details. **creative-director** approves direction.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (apex's brand context)
- `projects/{id}/00-engagement/onboarding-record.md` (client's brand existing assets)
- `projects/{id}/02-strategy/sitemap.md`, `content-strategy.md`
- Client-supplied brand guidelines (if any)

## Process

Build the design system covering all 8 mandatory chapters:

1. **Brand foundation**: logo usage rules, brand voice → visual tone mapping
2. **Typography**: typeface, scale, line-height, text styles (display/body/caption), JA-friendly considerations
3. **Color**: palette with documented contrast ratios (≥ 4.5:1 body, ≥ 3:1 large), semantic tokens
4. **Spacing**: 4px or 8px base scale, layout grid
5. **Components**: atomic to organism — minimum set per project type
6. **Imagery & icons**: photo style, illustration style, icon library
7. **Motion**: easing, durations, motion-safe defaults (Reduce-Motion compliance)
8. **Accessibility (mandatory chapter — H-4 fix)**:
   - Contrast ratios documented
   - Focus visibility patterns (focus rings, color-independent)
   - ARIA pattern conventions
   - Keyboard interaction map
   - Reduce-Motion mapping
   - Multi-language type considerations (when localization in scope)

## Outputs

- `projects/{id}/03-design/design-system.md` (Japanese, client deliverable; design tokens use English keys for impl-side)

Format: structured Markdown with each chapter as h2 section, tokens in YAML/code blocks.

## Example Output (Japanese excerpt)

```markdown
# デザインシステム

**案件**: <project-id>
**作成日**: 2026-05-20
**作成者**: art-direction-lead

## 1. ブランド基礎

ブランドのコア: 「信頼できる先進性」
ビジュアルトーン: 静謐 / 余白多め / クリーン

ロゴ使用ルール:
- 単色版 / フルカラー版 / モノクロ版を用意
- 最小サイズ 48px(横幅)
- 余白(クリアスペース): ロゴ高さの 1/4

## 2. タイポグラフィ

### 書体
- 本文(ja): Noto Sans JP / Inter(en)
- 見出し(ja): Noto Sans JP Bold / Inter Bold(en)

### スケール

```yaml
typography:
  display-1: 56px / 72px line-height / 700 weight
  display-2: 40px / 56px / 700
  h1: 32px / 48px / 700
  h2: 24px / 36px / 700
  h3: 20px / 30px / 700
  body-large: 18px / 30px / 400
  body: 16px / 28px / 400
  caption: 14px / 22px / 400
  small: 12px / 18px / 400
```

## 3. カラー

### パレット

```yaml
color:
  brand-primary: "#0B5FFF"   # AAA on white
  brand-secondary: "#0A1F44"
  text-primary: "#0A1F44"     # 14.8:1 on white
  text-secondary: "#5A6478"   # 5.7:1 on white(AA pass)
  text-muted: "#8A95A8"       # 3.5:1(AA large only)
  bg-default: "#FFFFFF"
  bg-subtle: "#F5F7FA"
  border: "#D7DBE3"
  success: "#16A34A"
  warning: "#D97706"
  danger: "#DC2626"
```

(...省略)

## 8. アクセシビリティ(必須章)

### コントラスト
本文(text-primary on bg-default): 14.8:1 ✅(AAA)
副次本文(text-secondary on bg-default): 5.7:1 ✅(AA)

### フォーカス可視性
すべてのインタラクティブ要素に focus ring を実装。
色のみに依存せず、太さ 2px / オフセット 2px の outline と合わせて表示。

### ARIA パターン
- ナビゲーションランドマーク: `<nav role="navigation" aria-label="Primary">`
- モーダル: `role="dialog"` + `aria-modal="true"` + focus trap
- ライブリージョン: フォーム送信成功・エラーで `aria-live="polite"` を使用

### キーボード操作
- Tab: 主要なインタラクティブ要素を順に巡回
- Enter / Space: ボタン押下
- Esc: モーダル / ドロップダウンを閉じる

### Reduce-Motion 対応
`@media (prefers-reduced-motion: reduce)` で:
- 自動再生アニメーション停止
- パララックス無効化
- トランジション 0.01s に短縮
```

## Boundary Notes

- The a11y chapter is non-negotiable — no design-system delivery without it
- Tokens use English keys; descriptive prose uses Japanese
- Custom fonts must be evaluated for LCP impact (cross-consult frontend-lead per technology-director's performance budget)

## Reference Documents

- `docs/templates/design-system.md`
- `docs/requirements-v0.2.md` Section 22.3 (Lighthouse floors)
