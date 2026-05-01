# デザインシステムテンプレート（WCAG 2.2 AA 込み）

**用途**: 案件のデザイントークン（カラー・タイポ・スペーシング・コンポーネント・モーション・アクセシビリティ）を一元定義
**配置先**: `projects/<project_id>/03-design/design-system.md`
**主担当**: `art-direction-lead`（`ui-designer` がコンポーネント詳細を補強）
**スキル**: `/design-system`
**言語層**: Layer 1（クライアント向け日本語）
**参照**: `.claude/rules/design-wcag-system.md`（H-4 fix）/ `docs/requirements-v0.2.md` Section 7

---

## 重要原則

⚠️ **WCAG 2.2 AA 対応はデザインシステムのトークン段階で組み込む。後付けのアクセシビリティパスは禁止。**
- すべてのカラーペア: 通常テキスト 4.5:1、大型テキスト 3:1、UI 要素 3:1
- すべてのタッチターゲット: 44×44px 以上
- フォーカスインジケーターは全コンポーネントで定義必須

---

## 使い方

1. デザインシステムを定義
2. 各カラートークンに **コントラスト比** をコメントで記載
3. アクセシビリティチェックリストを必ず通す
4. 設計完了後、`approvals.yaml` に `design_approval` の APV-NNN を作成

---

## テンプレート本体

```markdown
# デザインシステム v1

**案件**: <<株式会社サンプル コーポレートサイト>>
**案件 ID**: <<AXYZ-20260601-001>>
**版**: 1.0
**作成日**: <<YYYY-MM-DD>>
**作成者**: digital-product-studio-ai / art-direction-lead
**ステータス**: 確認待ち / 承認済
**WCAG 2.2 AA**: トークン段階で担保済み

---

## 1. デザイン原則

### 1.1 ブランド方針

| 原則 | 詳細 |
|---|---|
| <<信頼感>> | <<確かな根拠を示す配色・タイポグラフィ>> |
| <<先進性>> | <<モダンな余白設計、洗練されたコンポーネント>> |
| <<親しみやすさ>> | <<読みやすいタイポ、適度な丸み>> |
| <<アクセシブル>> | <<WCAG 2.2 AA 準拠は土台>> |

### 1.2 視覚階層

- 重要度順: タイトル → 本文 → 補足 → メタ情報
- 視線誘導: 左上 → 右下（Z 字）または 上 → 下（F 字）

### 1.3 一貫性ルール

- すべてのスペーシングはトークンを使う（自由な px 値禁止）
- すべてのカラーはトークンを使う（直接 HEX 禁止）
- すべての影・角丸はトークンに準拠

### 1.4 ブランド固有のデザイン指針（Brand-specific design directives）

> [gap-analysis-v0.2.md](../gap-analysis-v0.2.md) G-H6 で指摘された「ブランド固有要素枠の不足」を本節で解消する。
> 標準トークンでは表現しきれないクライアント固有・案件固有の要素を構造化された枠で受け止める。

#### 1.4.1 本節に書くべき内容

以下のような **標準デザインシステムでは表現しきれない案件固有のディレクション** を記述する。

| 領域 | 例 |
|---|---|
| ブランドの世界観 | <<「中の人 = AI エージェント 21 体」を視覚化するメタファー>>、<<創業者ストーリー>>、<<ブランドパーソナリティ>> |
| 業界・カテゴリ固有 | <<医療業界の信頼感トーン>>、<<金融の堅実さ>>、<<クリエイティブ業界の遊び>> |
| 文化・地域配慮 | <<和洋折衷の組合せ>>、<<多言語(中韓)版での慣用色の差異>>、<<縁起色の制限>> |
| ブランドアセット | <<独自フォトスタイル>>、<<イラストトーン>>、<<モーショングラマー>> |
| ブランド禁止事項 | <<競合に近い色の不使用>>、<<軽率なテンプレ画像の不使用>>、<<タブー色・タブーキーワード>> |
| クライアント固有装飾 | <<創業 N 周年エンブレム>>、<<業界アワードロゴ>>、<<認証マーク掲出位置>> |

**ない案件は本節を空欄で残してよい**(全クライアントに固有要素があるわけではない)。
ただし、§14「別添」に「ブランドガイドライン PDF」が存在する場合は本節で必ず参照すること。

#### 1.4.2 記述形式

各ディレクティブは以下の 4 要素で構造化する:

```markdown
### 1.4.X <<ディレクティブ名>>

- **目的**: <<このディレクティブで達成したい体験 / 印象>>
- **適用範囲**: <<どのコンポーネント / どのページ / どの状況に適用するか>>
- **必須 / 推奨**: <<MUST / SHOULD / MAY>>
- **検証方法**: <<どうやって守られているか確認するか>>
```

**MUST**(必須)は art-direction-lead がコンポーネント設計時に必ず参照する。
**SHOULD**(推奨)は ui-designer が個別画面で判断的に適用する。
**MAY**(任意)は将来の参考として記録する。

#### 1.4.3 記述例(本節を有効活用するための参考 — AILEAP 自社サイトのケース)

```markdown
### 1.4.A AI エージェント可視化のメタファー

- **目的**: AILEAP の最大の差別化点「中の人 = AI エージェント 21 体」を、
  説明文ではなく視覚で直感させる
- **適用範囲**: トップページのヒーロー / About / Service の各セクション冒頭
- **必須 / 推奨**: MUST
- **検証方法**: ヒーローを 5 秒見て「AI が動いている」と感じるかをユーザーテスト
- **具体指示**: 抽象的なノードグラフ + 微かなアニメーション。
  人間アバター / ロボット風キャラは使用しない(「同僚として動く知性」を表現するため)
- **禁止事項**: ストックフォトの「PC を操作する人」「握手する手」等の凡庸な代替

### 1.4.B 中庸トーンの徹底

- **目的**: AI が前面に出すぎる印象を避け、「冷静な味方」のトーンを維持
- **適用範囲**: 全コピー、全装飾、特に色のサチュレーション
- **必須 / 推奨**: MUST
- **検証方法**: コピー and ビジュアルが「派手・煽り・誇大」に近づいていないか
  copywriter / art-direction-lead 共同レビュー
- **具体指示**:
  - サチュレーション 80% 以上の色は装飾要素のみ(本文背景・カード背景には使わない)
  - エクスクラメーションマーク(!)は CTA を含めても各ページ最大 2 個
  - 強調色 #F59E0B(accent)は意図的な強調のみ。乱用しない
```

#### 1.4.4 案件で本節を空欄にする場合

ブランド固有要素が薄い案件(例: 標準的な A2 LP)では、本節を以下の最小構造のみとする:

```markdown
### 1.4 ブランド固有のデザイン指針

本案件では標準デザインシステム（§2-12）以外の固有指針はない。
別添ブランドガイド: <<該当なし>> または <<https://...>>
```

完全削除はしない(他案件と構造を揃えるため)。

---

## 2. カラートークン

### 2.1 ブランドカラー

```json
{
  "color": {
    "brand": {
      "primary":      "#2563EB",  // 5.9:1 on white  / AA 通常テキスト OK
      "primary-dark": "#1D4ED8",  // 7.2:1 on white  / AAA 達成
      "primary-light":"#60A5FA",  // 2.7:1 on white  / 装飾のみ・テキスト不可
      "accent":       "#F59E0B"   // 2.5:1 on white  / 装飾のみ・テキスト不可
    }
  }
}
```

⚠️ **`primary-light` および `accent` はテキスト用途禁止**。装飾・大型UI要素のみ使用。
テキストとして使う場合は `primary-dark` に置換。

### 2.2 テキストカラー

```json
{
  "color": {
    "text": {
      "primary":   "#1A1A2E",  // 16.2:1 on white / AAA 達成（本文向き）
      "secondary": "#4A4A6A",  // 6.8:1 on white  / AA 達成
      "tertiary":  "#6B6B8E",  // 4.7:1 on white  / AA 通常テキスト OK
      "disabled":  "#9A9AB0",  // 2.9:1 on white  / 装飾のみ・読み手向きテキスト不可
      "on-dark":   "#F8F8FF",  // 18.1:1 on brand-dark / AAA 達成
      "inverse":   "#FFFFFF",  // 16.2:1 on text-primary / AAA 達成
      "link":      "#1D4ED8",  // 7.2:1 on white  / AAA 達成
      "link-hover":"#1E3A8A"   // 9.7:1 on white  / AAA 達成
    }
  }
}
```

### 2.3 背景カラー

```json
{
  "color": {
    "bg": {
      "default":   "#FFFFFF",
      "muted":     "#F5F5F8",  // セクション区切り用
      "elevated":  "#FFFFFF",  // カード表面（影付き）
      "dark":      "#1A1A2E",  // ダークセクション用
      "overlay":   "rgba(26, 26, 46, 0.5)" // モーダル背景
    }
  }
}
```

### 2.4 状態カラー

```json
{
  "color": {
    "state": {
      "success":         "#15803D",  // 5.5:1 on white / AA OK
      "success-bg":      "#DCFCE7",  // 装飾用
      "warning":         "#A16207",  // 5.4:1 on white / AA OK
      "warning-bg":      "#FEF3C7",  // 装飾用
      "error":           "#B91C1C",  // 7.0:1 on white / AAA 達成
      "error-bg":        "#FEE2E2",  // 装飾用
      "info":            "#1D4ED8",  // 7.2:1 on white / AAA 達成
      "info-bg":         "#DBEAFE"   // 装飾用
    }
  }
}
```

### 2.5 境界線・区切り

```json
{
  "color": {
    "border": {
      "default":  "#E5E5EA",  // 1.4:1 contrast / 装飾のみ
      "muted":    "#F0F0F4",
      "strong":   "#9A9AB0",  // 2.9:1 / 重要な区切り線（フォーム枠等）
      "focus":    "#2563EB"   // フォーカスリング色
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
| brand.primary-light on bg.default | 2.7:1 | ❌ 装飾のみ | — | ❌ |
| state.error on bg.default | 7.0:1 | ✅ | ✅ | ✅ |
| text.on-dark on bg.dark | 18.1:1 | ✅ | ✅ | ✅ |

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
      "display": "3.5rem",  // 56px - ヒーロー見出し
      "h1":      "2.5rem",  // 40px
      "h2":      "2rem",    // 32px
      "h3":      "1.5rem",  // 24px
      "h4":      "1.25rem", // 20px
      "body-lg": "1.125rem",// 18px - 大型本文
      "body":    "1rem",    // 16px - 標準本文（最小）
      "body-sm": "0.875rem",// 14px - キャプション
      "caption": "0.75rem"  // 12px - 注釈のみ・本文禁止
    }
  }
}
```

⚠️ `caption` (12px) は本文用途禁止。注釈・著作権表記等のみ使用。

### 3.3 ウェイト

```json
{
  "font": {
    "weight": {
      "regular": 400,
      "medium":  500,
      "bold":    700
    }
  }
}
```

### 3.4 行高

```json
{
  "font": {
    "line-height": {
      "tight":   1.2,  // 見出し
      "snug":    1.4,  // サブ見出し
      "normal":  1.6,  // 本文（WCAG 1.4.8 で 1.5 以上推奨）
      "relaxed": 1.8   // 長文記事
    }
  }
}
```

### 3.5 文字間（letter-spacing）

```json
{
  "font": {
    "tracking": {
      "tight":   "-0.02em",  // 見出し
      "normal":  "0",
      "wide":    "0.05em"    // 大文字英文用
    }
  }
}
```

### 3.6 タイポルール

- 本文: `body` (16px) を最小とする。`body-sm` 以下は本文に使わない
- 見出し階層: H1 → H2 → H3 をスキップしない
- 行高: 本文 1.6 以上（WCAG 1.4.8）
- 単位: 必ず `rem`（ユーザーズーム対応）

---

## 4. スペーシング

### 4.1 スケール（base-4）

```json
{
  "space": {
    "0":   "0",
    "1":   "0.25rem",  //  4px
    "2":   "0.5rem",   //  8px
    "3":   "0.75rem",  // 12px
    "4":   "1rem",     // 16px
    "5":   "1.25rem",  // 20px
    "6":   "1.5rem",   // 24px
    "8":   "2rem",     // 32px
    "10":  "2.5rem",   // 40px
    "12":  "3rem",     // 48px
    "16":  "4rem",     // 64px
    "20":  "5rem",     // 80px
    "24":  "6rem",     // 96px
    "32":  "8rem"      // 128px
  }
}
```

### 4.2 用途ガイド

| 用途 | スペース |
|---|---|
| アイコン内余白 | 1-2 |
| ボタン内余白（垂直） | 2-3 |
| ボタン内余白（水平） | 4-6 |
| 入力フィールド内余白 | 3-4 |
| カード内余白 | 4-6 |
| セクション内要素間 | 6-8 |
| セクション間 | 16-24 |
| ページ上下マージン | 12-20 |

### 4.3 タッチターゲット

⚠️ **WCAG 2.5.8 (AA): 最小 44×44px**

すべてのインタラクティブ要素（ボタン・リンク・アイコンボタン）は **44×44px 以上** とする。

---

## 5. レイアウト・グリッド

### 5.1 ブレークポイント

```json
{
  "breakpoint": {
    "sm": "640px",   // モバイル横向き
    "md": "768px",   // タブレット縦
    "lg": "1024px",  // タブレット横 / 小型デスクトップ
    "xl": "1280px",  // デスクトップ
    "2xl":"1536px"   // ワイドデスクトップ
  }
}
```

### 5.2 コンテナ最大幅

```json
{
  "container": {
    "max-width": {
      "narrow":  "640px",   // 記事本文向け
      "default": "1280px",  // 標準
      "wide":    "1536px"   // ワイド画面用
    },
    "padding-x": {
      "mobile":  "1rem",    // 16px
      "tablet":  "2rem",    // 32px
      "desktop": "3rem"     // 48px
    }
  }
}
```

### 5.3 グリッド

- カラム: モバイル4 → タブレット8 → デスクトップ12
- ガター: モバイル space-4 → デスクトップ space-6

---

## 6. ボーダー・影・角丸

### 6.1 ボーダー幅

```json
{
  "border-width": {
    "thin":   "1px",
    "medium": "2px",
    "thick":  "4px"
  }
}
```

### 6.2 角丸

```json
{
  "radius": {
    "none": "0",
    "sm":   "0.25rem",   //  4px - 小型UI
    "md":   "0.5rem",    //  8px - ボタン・入力
    "lg":   "1rem",      // 16px - カード
    "xl":   "1.5rem",    // 24px - 大型コンテナ
    "full": "9999px"     // ピル型
  }
}
```

### 6.3 影（Elevation）

```json
{
  "shadow": {
    "sm":  "0 1px 2px rgba(0,0,0,0.05)",
    "md":  "0 4px 6px rgba(0,0,0,0.1)",
    "lg":  "0 10px 15px rgba(0,0,0,0.1)",
    "xl":  "0 20px 25px rgba(0,0,0,0.15)",
    "focus": "0 0 0 3px rgba(37, 99, 235, 0.3)"  // フォーカス用
  }
}
```

---

## 7. フォーカスインジケーター

⚠️ **必須要件（WCAG 2.4.7 AA）**

```json
{
  "focus": {
    "ring-color":  "#2563EB",  // brand.primary
    "ring-width":  "3px",
    "ring-offset": "2px",
    "outline-style": "solid"
  }
}
```

### 適用ルール

- 全インタラクティブ要素に `:focus-visible` で適用
- `outline: none` 禁止（代替がない場合）
- 暗い背景時は `text.on-dark` を使った明るいリング色に切替
- `outline` ベース実装（`box-shadow` より互換性が高い）

```css
/* 標準実装パターン */
.button:focus-visible {
  outline: 3px solid #2563EB;
  outline-offset: 2px;
}
```

---

## 8. モーション

### 8.1 イージング

```json
{
  "motion": {
    "easing": {
      "linear":     "linear",
      "ease-in":    "cubic-bezier(0.4, 0, 1, 1)",
      "ease-out":   "cubic-bezier(0, 0, 0.2, 1)",
      "ease-in-out":"cubic-bezier(0.4, 0, 0.2, 1)"
    }
  }
}
```

### 8.2 デュレーション

```json
{
  "motion": {
    "duration": {
      "instant": "75ms",
      "fast":    "150ms",
      "normal":  "250ms",
      "slow":    "400ms",
      "slower":  "700ms"
    }
  }
}
```

### 8.3 アクセシビリティ：prefers-reduced-motion

⚠️ **WCAG 2.3.3 (AAA だが推奨)**: モーション削減設定への対応

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

パララックス・自動再生動画・大型アニメーションは `prefers-reduced-motion: reduce` 時に無効化必須。

---

## 9. コンポーネント仕様

### 9.1 ボタン

| 状態 | 背景色 | テキスト色 | ボーダー | 影 |
|---|---|---|---|---|
| Primary 通常 | brand.primary | text.inverse | なし | shadow.sm |
| Primary hover | brand.primary-dark | text.inverse | なし | shadow.md |
| Primary focus | brand.primary | text.inverse | focus.ring | shadow.focus |
| Primary active | brand.primary-dark | text.inverse | なし | shadow.sm |
| Primary disabled | text.disabled | text.inverse | なし | none |
| Secondary 通常 | bg.default | brand.primary-dark | brand.primary 1px | shadow.sm |
| Tertiary 通常 | transparent | brand.primary-dark | なし | なし |

**サイズ**:
- 小: 高さ 36px（パディング space-2/space-4）
- 中: 高さ 44px（パディング space-3/space-6）★ 標準・タッチターゲット要件達成
- 大: 高さ 56px（パディング space-4/space-8）

### 9.2 入力フィールド

| 状態 | 背景色 | ボーダー | テキスト色 |
|---|---|---|---|
| 通常 | bg.default | border.strong | text.primary |
| focus | bg.default | brand.primary 2px + focus.ring | text.primary |
| エラー | bg.default | state.error 2px | text.primary |
| 無効 | bg.muted | border.default | text.disabled |

- ラベル必須（`<label>` または `aria-label`）
- エラー時は `aria-invalid="true"` + エラーメッセージリンク

### 9.3 カード

```
背景: bg.elevated
角丸: radius.lg
影: shadow.md（hover で shadow.lg）
パディング: space-6
ホバー時: わずかに上方へ -2px シフト
```

### 9.4 リンク

```
通常: color: text.link, underline
hover: color: text.link-hover, underline
visited: color: 7e22ce (任意・指定不要)
focus: outline ring
```

### 9.5 ナビゲーション

- グローバルナビ: 高さ 64-80px、固定または上スクロール時に出現
- モバイル: ハンバーガーメニュー、パネル左/右からスライド
- フォーカス順序: ロゴ → 主ナビ → 検索 → CTA → 主コンテンツ

### 9.6 フォーム

- 1セクション1ラベル
- 必須は `aria-required="true"` + 視覚記号「*」
- エラー: フィールド下にメッセージ + `aria-describedby` で関連付け
- 送信ボタン: 連打防止（`disabled` 状態）

---

## 10. アクセシビリティ要件（WCAG 2.2 AA）

### 10.1 必須対応

| 基準 | 内容 |
|---|---|
| 1.4.3 コントラスト | 通常 4.5:1、大型 3:1 |
| 1.4.4 テキストサイズ変更 | 200% 拡大で破綻なし |
| 1.4.10 リフロー | 320px 幅で水平スクロールなし |
| 1.4.11 非テキストコントラスト | UI 3:1 |
| 1.4.12 テキスト間隔 | 行間 1.5・段落 2・文字 0.12em 調整可能 |
| 2.1.1 キーボード | 全機能キーボードのみで操作可能 |
| 2.4.3 フォーカス順序 | 論理順序 |
| 2.4.7 フォーカス可視 | 見える焦点インジケーター |
| 2.5.8 ターゲットサイズ（AA） | 最小 24×24px、推奨 44×44px |
| 3.3.7 冗長な入力 | 同じ情報の再入力不要 |
| 3.3.8 アクセシブル認証 | パズル・記憶テストの代替提供 |

### 10.2 検証方法

- 自動: Lighthouse Accessibility 95+ / axe DevTools / Pa11y
- 手動: キーボードのみ操作、スクリーンリーダー（VoiceOver / NVDA）
- 目視: コントラスト確認（Stark プラグイン等）

---

## 11. ダークモード（任意・推奨）

### 11.1 トークン切替

```json
{
  "theme": {
    "light": { /* 上記がデフォルト */ },
    "dark": {
      "color.text.primary":   "#F8F8FF",  // 18.1:1 on bg.dark
      "color.text.secondary": "#C5C5D8",  // 9.3:1 on bg.dark
      "color.bg.default":     "#1A1A2E",
      "color.bg.muted":       "#252540",
      "color.bg.elevated":    "#2D2D4A",
      "color.brand.primary":  "#60A5FA"   // 5.5:1 on bg.dark
    }
  }
}
```

### 11.2 切替方法

- `prefers-color-scheme` で自動切替
- ユーザーが手動切替できる UI を提供（ヘッダー右）
- 設定は `localStorage` で永続化

---

## 12. 実装ガイド

### 12.1 CSS 変数マッピング

```css
:root {
  /* color */
  --color-text-primary: #1A1A2E;
  --color-bg-default: #FFFFFF;
  --color-brand-primary: #2563EB;

  /* font */
  --font-family-sans: 'Noto Sans JP', sans-serif;
  --font-size-body: 1rem;
  --line-height-normal: 1.6;

  /* space */
  --space-4: 1rem;

  /* radius */
  --radius-md: 0.5rem;

  /* shadow */
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);

  /* focus */
  --focus-ring-color: #2563EB;
}
```

### 12.2 Tailwind 設定例

```js
// tailwind.config.js（抜粋）
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: { primary: '#2563EB', 'primary-dark': '#1D4ED8' },
        text: { primary: '#1A1A2E', secondary: '#4A4A6A' }
      },
      fontFamily: {
        sans: ['"Noto Sans JP"', 'sans-serif']
      }
    }
  }
}
```

---

## 13. 確認事項

### 13.1 クライアント様への確認依頼

- [ ] ブランドカラー（プライマリ・アクセント）が御社ブランドガイドと整合
- [ ] フォント選定（Noto Sans JP は標準。指定がある場合は変更）
- [ ] ロゴ・写真などブランド資産との整合
- [ ] ダークモード対応の要否
- [ ] アクセシビリティ目標（WCAG 2.2 AA を標準、AAA 希望時は別途）

---

## 14. 別添

- Figma リンク: <<URL>>
- 主要画面デザイン（`03-design/screens/`）
- コンポーネントライブラリ（`03-design/components/`）

---

**Document Owner**: digital-product-studio-ai / art-direction-lead
**Last Updated**: <<YYYY-MM-DD>>
**Version**: 1.0
**WCAG 2.2 AA**: ✅ トークン段階で担保
```

---

## チェックリスト（H-4 fix 必須項目）

- [ ] 全カラートークンにコントラスト比をコメント記載
- [ ] AA 不適合トークンに「装飾のみ」明記
- [ ] タイポは rem 単位、最小 16px（body）
- [ ] 行高 1.6 以上（本文）
- [ ] スペースは base-4 / base-8 スケール
- [ ] タッチターゲット 44×44px 以上明記
- [ ] フォーカスインジケーターが全コンポーネントで定義
- [ ] `outline: none` 禁止ルールが記載
- [ ] `prefers-reduced-motion` 対応が記載
- [ ] 全コンポーネント状態が default/hover/focus/active/disabled/error で定義
- [ ] レスポンシブブレークポイントが標準値
- [ ] ダークモード対応の方針記載

---

## よくある間違い

| 誤り | 正しい書き方 |
|---|---|
| カラーをトークンなしで HEX 直書き | 必ずトークン経由 |
| `text-secondary` で 4.5:1 未満 | コントラスト比検証してトークン化 |
| タッチターゲット < 44×44px | 必ず 44×44px 以上 |
| `outline: none` で代替なし | 代替フォーカスデザインを定義 |
| アクセシビリティを後付け | トークン段階で組み込み（H-4 fix） |
| px 単位でフォントサイズ | rem 単位（ユーザーズーム対応） |
