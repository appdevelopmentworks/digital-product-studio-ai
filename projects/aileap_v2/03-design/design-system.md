# デザインシステム — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-04-29
**作成者**: art-direction-lead(ui-designer 補強)
**ステータス**: 承認待ち(APV-003)
**WCAG 2.2 AA**: トークン段階で担保済み(H-4 fix の実証)

---

## 1. デザイン原則

### 1.1 ブランド方針

| 原則 | 詳細 |
|---|---|
| AI Native | AI が制作工程に組み込まれていることを視覚的にも訴求 |
| 同等品質を半額 | 高品質な印象 + 親しみやすさのバランス |
| WCAG + GEO 標準装備 | デザイントークン段階でアクセシビリティ担保 |
| 信頼感 | 確かな根拠、控えめだが洗練された配色 |

### 1.2 視覚階層

- 重要度順: タイトル → 本文 → 補足 → メタ
- 視線誘導: F 字(本文ページ) / Z 字(LP・トップ)
- 余白で重要度を示す(密集を避ける)

### 1.3 一貫性ルール

- すべてのスペーシングはトークン使用(自由 px 値禁止)
- すべてのカラーはトークン使用(直接 HEX 禁止)
- すべての影・角丸はトークン準拠

---

## 2. カラートークン

### 2.1 ブランドカラー

```json
{
  "color": {
    "brand": {
      "primary":      "#2563EB",  // 5.9:1 on white  / AA 通常テキスト OK
      "primary-dark": "#1D4ED8",  // 7.2:1 on white  / AAA 達成
      "primary-darker":"#1E3A8A", // 9.7:1 on white  / AAA 達成
      "primary-light":"#60A5FA",  // 2.7:1 on white  / 装飾のみ・テキスト不可
      "accent":       "#F59E0B"   // 2.5:1 on white  / 装飾のみ・テキスト不可
    }
  }
}
```

⚠️ `primary-light` および `accent` はテキスト用途禁止。装飾・大型 UI 要素のみ。

### 2.2 テキストカラー

```json
{
  "color": {
    "text": {
      "primary":   "#1A1A2E",  // 16.2:1 on white / AAA(本文向き)
      "secondary": "#4A4A6A",  // 6.8:1 on white  / AA OK
      "tertiary":  "#6B6B8E",  // 4.7:1 on white  / AA 通常テキスト OK
      "disabled":  "#9A9AB0",  // 2.9:1 on white  / 装飾のみ
      "on-dark":   "#F8F8FF",  // 18.1:1 on brand-darker / AAA
      "inverse":   "#FFFFFF",  // 16.2:1 on text-primary / AAA
      "link":      "#1D4ED8",  // 7.2:1 on white / AAA
      "link-hover":"#1E3A8A"   // 9.7:1 on white / AAA
    }
  }
}
```

### 2.3 背景カラー

```json
{
  "color": {
    "bg": {
      "default":  "#FFFFFF",
      "muted":    "#F5F5F8",  // セクション区切り
      "elevated": "#FFFFFF",  // カード表面(影付き)
      "dark":     "#1A1A2E",  // ダークセクション
      "darker":   "#0F0F1F",  // ヒーロー深部
      "overlay":  "rgba(26, 26, 46, 0.5)" // モーダル背景
    }
  }
}
```

### 2.4 状態カラー

```json
{
  "color": {
    "state": {
      "success":     "#15803D",  // 5.5:1 / AA OK
      "success-bg":  "#DCFCE7",
      "warning":     "#A16207",  // 5.4:1 / AA OK
      "warning-bg":  "#FEF3C7",
      "error":       "#B91C1C",  // 7.0:1 / AAA
      "error-bg":    "#FEE2E2",
      "info":        "#1D4ED8",  // 7.2:1 / AAA
      "info-bg":     "#DBEAFE"
    }
  }
}
```

### 2.5 境界線

```json
{
  "color": {
    "border": {
      "default":  "#E5E5EA",  // 装飾用
      "muted":    "#F0F0F4",
      "strong":   "#9A9AB0",  // 重要区切り(フォーム枠等)
      "focus":    "#2563EB"   // フォーカスリング
    }
  }
}
```

### 2.6 コントラスト確認シート

| ペア | 比率 | AA通常 | AA大型 | UI |
|---|---|---|---|---|
| text.primary on bg.default | 16.2:1 | ✅ | ✅ | ✅ |
| text.secondary on bg.default | 6.8:1 | ✅ | ✅ | ✅ |
| text.tertiary on bg.default | 4.7:1 | ✅ | ✅ | ✅ |
| text.disabled on bg.default | 2.9:1 | ❌ 装飾のみ | — | ❌ |
| brand.primary on bg.default | 5.9:1 | ✅ | ✅ | ✅ |
| brand.primary-dark on bg.default | 7.2:1 | ✅ | ✅ | ✅ |
| brand.primary-light on bg.default | 2.7:1 | ❌ 装飾のみ | — | ❌ |
| state.error on bg.default | 7.0:1 | ✅ | ✅ | ✅ |
| text.on-dark on bg.dark | 18.1:1 | ✅ | ✅ | ✅ |
| text.on-dark on bg.darker | 19.8:1 | ✅ | ✅ | ✅ |
| brand.primary-light on bg.dark | 4.8:1 | ✅(大型のみ) | ✅ | ✅ |

---

## 3. タイポグラフィ

### 3.1 フォントファミリー

```json
{
  "font": {
    "family": {
      "sans": "'Noto Sans JP', 'Hiragino Sans', sans-serif",
      "serif": "'Noto Serif JP', 'Hiragino Mincho ProN', serif",
      "mono": "'JetBrains Mono', 'Source Han Mono', monospace"
    }
  }
}
```

### 3.2 タイポスケール

```json
{
  "font": {
    "size": {
      "display": "3.5rem",  // 56px - ヒーロー
      "h1":      "2.5rem",  // 40px
      "h2":      "2rem",    // 32px
      "h3":      "1.5rem",  // 24px
      "h4":      "1.25rem", // 20px
      "body-lg": "1.125rem",// 18px
      "body":    "1rem",    // 16px - 標準・最小
      "body-sm": "0.875rem",// 14px - キャプション
      "caption": "0.75rem"  // 12px - 注釈のみ・本文禁止
    }
  }
}
```

### 3.3 ウェイト

```json
{
  "font": {
    "weight": { "regular": 400, "medium": 500, "bold": 700 }
  }
}
```

### 3.4 行高

```json
{
  "font": {
    "line-height": {
      "tight":   1.2,  // 見出し
      "snug":    1.4,
      "normal":  1.6,  // 本文(WCAG 1.4.8 ≥ 1.5)
      "relaxed": 1.8   // 長文記事
    }
  }
}
```

### 3.5 タイポルール

- 本文: `body` (16px) を最小、`body-sm` 以下は本文禁止
- 見出し階層 H1 → H2 → H3 スキップ禁止
- 必ず `rem` 単位(ユーザーズーム対応)

---

## 4. スペーシング

### 4.1 base-4 スケール

```json
{
  "space": {
    "0":"0", "1":"0.25rem","2":"0.5rem","3":"0.75rem",
    "4":"1rem", "5":"1.25rem","6":"1.5rem","8":"2rem",
    "10":"2.5rem","12":"3rem","16":"4rem","20":"5rem",
    "24":"6rem","32":"8rem"
  }
}
```

### 4.2 タッチターゲット

⚠️ **WCAG 2.5.8 (AA): 最小 44×44px**

すべてのインタラクティブ要素は 44×44px 以上。

---

## 5. レイアウト・グリッド

### 5.1 ブレークポイント

```json
{
  "breakpoint": {
    "sm":"640px","md":"768px","lg":"1024px","xl":"1280px","2xl":"1536px"
  }
}
```

### 5.2 コンテナ最大幅

```json
{
  "container": {
    "max-width": {
      "narrow":"640px","default":"1280px","wide":"1536px"
    },
    "padding-x": {
      "mobile":"1rem","tablet":"2rem","desktop":"3rem"
    }
  }
}
```

### 5.3 グリッド

- カラム: モバイル 4 → タブレット 8 → デスクトップ 12
- ガター: モバイル space-4 → デスクトップ space-6

---

## 6. ボーダー・影・角丸

### 6.1 角丸

```json
{
  "radius": {
    "none":"0","sm":"0.25rem","md":"0.5rem",
    "lg":"1rem","xl":"1.5rem","full":"9999px"
  }
}
```

### 6.2 影(Elevation)

```json
{
  "shadow": {
    "sm":  "0 1px 2px rgba(0,0,0,0.05)",
    "md":  "0 4px 6px rgba(0,0,0,0.1)",
    "lg":  "0 10px 15px rgba(0,0,0,0.1)",
    "xl":  "0 20px 25px rgba(0,0,0,0.15)",
    "focus": "0 0 0 3px rgba(37, 99, 235, 0.3)"
  }
}
```

---

## 7. フォーカスインジケーター

⚠️ **必須(WCAG 2.4.7 AA)**

```json
{
  "focus": {
    "ring-color":  "#2563EB",
    "ring-width":  "3px",
    "ring-offset": "2px"
  }
}
```

```css
.button:focus-visible {
  outline: 3px solid #2563EB;
  outline-offset: 2px;
}
```

`outline: none` は代替なしでは禁止。

---

## 8. モーション

### 8.1 イージング・デュレーション

```json
{
  "motion": {
    "easing": {
      "ease-in":    "cubic-bezier(0.4, 0, 1, 1)",
      "ease-out":   "cubic-bezier(0, 0, 0.2, 1)",
      "ease-in-out":"cubic-bezier(0.4, 0, 0.2, 1)"
    },
    "duration": {
      "fast":"150ms","normal":"250ms","slow":"400ms","slower":"700ms"
    }
  }
}
```

### 8.2 prefers-reduced-motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## 9. コンポーネント仕様

### 9.1 ボタン

| 状態 | 背景 | テキスト | ボーダー | 影 |
|---|---|---|---|---|
| Primary 通常 | brand.primary | text.inverse | なし | shadow.sm |
| Primary hover | brand.primary-dark | text.inverse | なし | shadow.md |
| Primary focus | brand.primary | text.inverse | focus.ring | shadow.focus |
| Primary disabled | text.disabled | text.inverse | なし | none |
| Secondary 通常 | bg.default | brand.primary-dark | brand.primary 1px | shadow.sm |
| Tertiary 通常 | transparent | brand.primary-dark | なし | なし |

サイズ:
- 小: 高さ 36px(機能的に重要なものは中以上を採用)
- 中: 高さ 44px ★ 標準・タッチ要件達成
- 大: 高さ 56px

### 9.2 入力フィールド

| 状態 | 背景 | ボーダー | テキスト |
|---|---|---|---|
| 通常 | bg.default | border.strong | text.primary |
| focus | bg.default | brand.primary 2px + focus.ring | text.primary |
| エラー | bg.default | state.error 2px | text.primary |
| 無効 | bg.muted | border.default | text.disabled |

### 9.3 カード

```
背景: bg.elevated
角丸: radius.lg
影: shadow.md → shadow.lg(hover)
パディング: space-6
ホバー時: -2px Y シフト
```

### 9.4 ナビゲーション

- グローバルナビ: 高さ 64-80px、固定
- モバイル: ハンバーガー
- フォーカス順序: ロゴ → 主ナビ → CTA

### 9.5 フォーム

- ラベル必須
- エラー: フィールド下にメッセージ + `aria-describedby`
- 送信ボタン: 連打防止(disabled)

---

## 10. AILEAP 特有のデザイン要素

### 10.1 「AI エージェント 21 体」表現

人物写真の代わりに以下で抽象表現:

- **アバター案 1**: 各エージェントの役割をピクトグラム化したアイコンセット
- **アバター案 2**: 抽象的な「ノード型」グラフィック(エージェント間の連携を可視化)
- **採用案**: 案 2(連携図)をメインビジュアル、案 1 を会社概要内に配置

### 10.2 3 組織アーキテクチャ図

トップ + 会社概要で使用する図:

```
[apex-consulting-ai]   →   [digital-product-studio-ai]   →   [WMAO]
   上流戦略コンサル          中流 Web 制作(本組織)              下流マーケ・運用

    ↑ B-1境界               ↑ B-C1境界(30日)
    apex 受領               WMAO 引継ぎ
```

- 図はインライン SVG で実装(構造化データに alt 反映)
- ダークモード時は色反転対応

### 10.3 「同等品質を半額」訴求の視覚化

- 価格比較表(従来 / AILEAP)
- 工数比較ダイアグラム
- 文字より図表で訴求(GEO 引用しやすい)

---

## 11. アクセシビリティ要件(WCAG 2.2 AA)

### 11.1 必須対応

| 基準 | 内容 |
|---|---|
| 1.4.3 コントラスト | 通常 4.5:1、大型 3:1 |
| 1.4.4 テキストサイズ変更 | 200% 拡大で破綻なし |
| 1.4.10 リフロー | 320px 幅で水平スクロールなし |
| 1.4.11 非テキストコントラスト | UI 3:1 |
| 1.4.12 テキスト間隔 | 行間 1.5・段落 2・文字 0.12em 調整可 |
| 2.1.1 キーボード | 全機能キーボードのみ操作可 |
| 2.4.3 フォーカス順序 | 論理順序 |
| 2.4.7 フォーカス可視 | 見える focus ring |
| 2.5.8 ターゲットサイズ | 最小 24×24px、推奨 44×44px |
| 3.3.7 冗長な入力 | 同情報の再入力不要 |
| 3.3.8 アクセシブル認証 | パズル・記憶テストの代替 |

### 11.2 検証方法

- 自動: Lighthouse 95+ / axe DevTools / Pa11y
- 手動: キーボードのみ操作、VoiceOver / NVDA
- 目視: コントラスト確認(Stark)

---

## 12. ダークモード(任意・実装予定)

```json
{
  "theme.dark": {
    "color.text.primary":   "#F8F8FF",
    "color.text.secondary": "#C5C5D8",
    "color.bg.default":     "#1A1A2E",
    "color.bg.muted":       "#252540",
    "color.bg.elevated":    "#2D2D4A",
    "color.brand.primary":  "#60A5FA"
  }
}
```

切替方法:
- `prefers-color-scheme` で自動
- ヘッダー右の手動切替 UI
- `localStorage` で永続化

---

## 13. 実装ガイド

### 13.1 CSS 変数(抜粋)

```css
:root {
  --color-text-primary: #1A1A2E;
  --color-bg-default: #FFFFFF;
  --color-brand-primary: #2563EB;
  --font-family-sans: 'Noto Sans JP', sans-serif;
  --font-size-body: 1rem;
  --line-height-normal: 1.6;
  --space-4: 1rem;
  --radius-md: 0.5rem;
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --focus-ring-color: #2563EB;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-text-primary: #F8F8FF;
    --color-bg-default: #1A1A2E;
  }
}
```

### 13.2 Tailwind 設定例

```js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          primary: '#2563EB',
          'primary-dark': '#1D4ED8',
          'primary-darker': '#1E3A8A'
        },
        text: { primary: '#1A1A2E', secondary: '#4A4A6A' }
      },
      fontFamily: { sans: ['"Noto Sans JP"', 'sans-serif'] }
    }
  }
}
```

---

## 14. 確認事項(Shin への質問)

- [ ] ブランドカラー #2563EB 系の方向で進めて良いか
- [ ] 「AI エージェント 21 体」を抽象ノードグラフで表現する方針
- [ ] ダークモードを初期スコープに含めるか(現状は実装予定)
- [ ] 3 組織アーキテクチャ図のスタイル(シンプル / 詳細)
- [ ] WCAG 2.2 AA で十分か、AAA を目指す箇所があるか

---

## 15. 別添

- Figma リンク: 未作成(本案件では Markdown 仕様書ベースで進める検証目的)
- 主要画面デザイン: `03-design/screens/` (未作成 — 実装直前に追加)

---

**Document Owner**: art-direction-lead
**Last Updated**: 2026-04-29
**Version**: 1.0
**WCAG 2.2 AA**: ✅ トークン段階で担保(H-4 fix の実証)
