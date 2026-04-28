---
name: accessibility-audit
description: Run WCAG 2.2 AA compliance audit covering semantic HTML, ARIA, keyboard interaction, focus visibility, contrast, motion safety. Lead agent seo-geo-strategist (in v0.2; v0.3 hands to accessibility-specialist).
---

# /accessibility-audit

## Purpose

Verify WCAG 2.2 AA compliance — non-negotiable per AILEAP differentiation axis. Failing accessibility blocks launch.

In v0.2, this skill is run by **seo-geo-strategist** as a temporary owner (no a11y specialist exists in v0.2). v0.3 hands ownership to `accessibility-specialist`.

## When to Use

- QA phase (Implementation → QA gate) — required pass
- Post-launch verification (lighter rerun)
- After major changes to design system or interactive components

## Lead Agent

**seo-geo-strategist** (v0.2 temporary owner)
- v0.3+: **accessibility-specialist** (Tier 3)

## Inputs

- Live staging URL
- All page files
- `projects/{id}/03-design/design-system.md` (a11y chapter is the source of truth)

## Process

Run WCAG 2.2 AA checks across 4 principles (Perceivable / Operable / Understandable / Robust).

### 1. Perceivable

- [ ] All non-text content has alt or accessible name
- [ ] Color contrast ratios pass:
  - Body text ≥ 4.5:1
  - Large text (18pt+ or 14pt+ bold) ≥ 3:1
  - UI components ≥ 3:1
- [ ] Information not conveyed by color alone
- [ ] Text resizable to 200% without loss of content
- [ ] Audio / video has captions or transcript (if applicable)

### 2. Operable

- [ ] All functionality keyboard-accessible (Tab, Enter, Esc, Arrow keys)
- [ ] No keyboard traps
- [ ] Skip-to-main-content link
- [ ] Focus visible on all interactive elements (not color-only)
- [ ] No content flashes more than 3 times/sec
- [ ] Touch targets ≥ 24×24 CSS pixels
- [ ] Reduce-Motion respected (`@media (prefers-reduced-motion)`)
- [ ] No automatic content changes without warning (carousels, etc.)

### 3. Understandable

- [ ] Page language declared (`<html lang="ja">` or appropriate locale)
- [ ] Content language changes declared (`<span lang="en">...</span>`)
- [ ] Form fields have labels (visible or `aria-label`)
- [ ] Error messages are clear and identify the error
- [ ] Predictable navigation order

### 4. Robust

- [ ] Valid HTML (no major parser errors)
- [ ] Semantic HTML elements used (`<button>` not `<div onClick>`)
- [ ] ARIA roles only when needed (don't override semantic HTML unnecessarily)
- [ ] Status messages use `role="status"` or `aria-live="polite"`

### 5. Multi-Language Considerations (when localization in scope)

- [ ] Each language version has correct `lang` attribute
- [ ] Right-to-left languages handled (not in v0.2 scope; v0.4+)
- [ ] Translation captures meaning, not just words

## Outputs

- `projects/{id}/05-qa/accessibility-audit.md` (Japanese, structured)

## Example Output (Japanese excerpt)

```markdown
# アクセシビリティ監査レポート

**案件**: <project-id>
**監査日**: 2026-07-26
**監査者**: seo-geo-strategist(v0.2 暫定担当)
**対象 URL**: https://staging.example.com
**基準**: WCAG 2.2 AA

## サマリー

総合: Pass with 2 High issues
Critical: 0 件
High: 2 件
Medium: 4 件

## 1. 知覚可能(Perceivable)

| # | 項目 | 状態 |
|---|---|---|
| 1.1 | 画像 alt 属性 | ✅ Pass |
| 1.2 | コントラスト比(本文 ≥ 4.5:1) | ✅ Pass |
| 1.3 | 大文字コントラスト(≥ 3:1) | ⚠️ High: ヒーローのキャッチコピー(28px)が 2.8:1 |
| 1.4 | 色のみで情報伝達なし | ✅ Pass |
| 1.5 | 200% 拡大対応 | ✅ Pass |

## 2. 操作可能(Operable)

| # | 項目 | 状態 |
|---|---|---|
| 2.1 | キーボード操作 | ⚠️ High: フッターの SNS リンクが Tab で到達できない |
| 2.2 | フォーカス可視性 | ✅ Pass |
| 2.3 | スキップリンク | ✅ Pass |
| 2.4 | Reduce-Motion 尊重 | ✅ Pass |

(以下省略)

## High 問題と修正方針

1. ヒーローキャッチコピーのコントラスト不足(2.8:1)→ 背景色を darker に変更、または text-shadow 追加で 3:1 確保
2. フッター SNS リンクが Tab で到達不可 → `tabindex="0"` を追加、または `<a>` 要素に変更

## 修正後再監査

修正後に再度 /accessibility-audit を実行し全項目 Pass を確認。
```

## Boundary Notes

- Audit is read-only — findings are fed to ui-designer / frontend-engineer for fixes
- WCAG 2.2 AA is non-negotiable per AILEAP differentiation axis
- Do NOT certify "WCAG 2.2 AAA" — that requires deeper audit not in v0.2 scope
- v0.3 will introduce dedicated `accessibility-specialist` who can do AAA-level audits

## Reference Documents

- WCAG 2.2 AA standard
- `docs/templates/design-system.md` (a11y chapter as source of truth)
- `docs/requirements-v0.2.md` Section 22.3 (Lighthouse Accessibility ≥ 95)
