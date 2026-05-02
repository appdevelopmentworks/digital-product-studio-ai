# アクセシビリティ監査レポート(WCAG 2.2 AA) — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**監査日**: 2026-06-25(staging)
**監査者**: seo-geo-strategist(a11y 兼任 / v0.4 で accessibility-specialist へ移管)
**対象 URL**: https://staging.meetingai.aileap.example
**版**: 1.0
**ステータス**: ✅ Pass

---

## サマリー

**総合判定**: ✅ **GO**

| 区分 | 結果 |
|---|---|
| Lighthouse Accessibility | **100 / 100**(2 ページ平均) |
| axe-core 違反 | **0** 件(Critical / Serious) |
| 手動キーボードテスト | ✅ 全フロー通過 |
| スクリーンリーダー(VoiceOver / NVDA) | ✅ 主要フロー確認 |
| Critical | **0** |
| High | **0** |
| Medium | 0 |
| Low | 1 |

aileap_v2 design-system からトークンレベルで a11y を継承。WCAG 2.2 AA 全 50 項目達成(継承運用)。

---

## 1. 監査範囲

| URL | 監査済 |
|---|---|
| `/` | ✅ |
| `/thanks` | ✅ |

---

## 2. WCAG 2.2 AA 達成状況

aileap_v2 の継承により、すべての必須項目(50 項目)を達成。本書では **LP 固有の検証** のみ記載。

### 2.1 LP 固有の重点監査項目

| 項目 | 結果 |
|---|---|
| ヒーロー画像の alt | ✅(空 alt + ヒーローテキストで意味伝達) |
| 申込みフォームのラベル + エラーメッセージ | ✅(全フィールド label + aria-describedby) |
| FAQ アコーディオン(`<details>` ベース) | ✅(ネイティブ a11y / aria-expanded 自動) |
| 大サイズ CTA ボタン(56px 高) | ✅(タッチターゲット 44×44px 超) |
| アンカーリンクのフォーカス順序 | ✅(論理順序) |
| reCAPTCHA v3(audio 代替) | ✅(v3 は invisible のため代替不要) |

### 2.2 デザイントークン継承の確認

aileap_v2 §10(WCAG 2.2 AA)から継承:

- コントラスト比 全ペア 4.5:1 以上(本文)/ 3:1 以上(UI)
- フォーカスインジケーター 3px ring + 2px offset
- タッチターゲット 44×44px 以上
- prefers-reduced-motion 対応

すべて aileap_v2 design-system から自動継承され、本 LP でも維持されることを確認。

---

## 3. 自動チェック結果

### 3.1 Lighthouse Accessibility

| ページ | スコア |
|---|---|
| `/` | 100 |
| `/thanks` | 100 |
| **平均** | **100** |

### 3.2 axe-core(@axe-core/playwright)

```
Critical violations: 0
Serious violations: 0
Moderate violations: 0
Minor violations: 0

Total tests: 86 rules across 2 pages
Passed: 86 / 86
```

### 3.3 Pa11y CI

```
Issues: 0 errors / 0 warnings / 1 notice(informational)
```

---

## 4. 手動キーボード操作テスト

### 4.1 Critical Journey 3 件

| Journey | 操作内容 | 結果 |
|---|---|---|
| CJ-001 | LP 流入 → スクロール → 機能セクション → アンカーで申込みフォーム | ✅ Tab 順序問題なし |
| CJ-002 | β版申込みフォーム送信(全フィールド入力 + 同意 + 送信)| ✅ |
| CJ-003 | thanks ページから aileap_v2 への遷移 | ✅ |

すべてマウスを使用せず Tab / Enter / Esc / Arrow / Space キーで完遂可能。

### 4.2 FAQ アコーディオンのキーボード操作

`<details>` ネイティブ要素のため:
- Tab で Q にフォーカス → ✅
- Enter / Space で開閉 → ✅
- aria-expanded 自動 → ✅

JS なしで a11y を満たすため、Lighthouse Performance も向上。

---

## 5. スクリーンリーダーテスト

### 5.1 VoiceOver(macOS Safari)

| 確認項目 | 結果 |
|---|---|
| ランドマーク読み上げ(banner / main / contentinfo) | ✅ |
| 見出し階層(h1 → h2 → h3) | ✅ スキップなし |
| FAQ の `<details>` 要素 | ✅(「展開」「折りたたみ」状態を読み上げ) |
| フォームのラベル + エラー | ✅ |

### 5.2 NVDA(Windows Firefox)

同様の項目すべて pass。

### 5.3 動的更新

フォーム送信成功時の `aria-live="polite"` 領域に「送信完了」メッセージ表示 → 自動読み上げ ✅。

---

## 6. 色覚多様性シミュレーション(Stark)

| 種類 | 影響 |
|---|---|
| Protanopia / Deuteranopia / Tritanopia / Achromatopsia | すべて影響なし(色のみで情報伝達せず) |

---

## 7. 検出された問題

### Critical / High / Medium: なし

### Low

#### L-001: スキップリンクのスタイル(継承元と同様の問題)

- 症状: スキップリンクが focus 時に左上 8px 位置に出現するが、ヘッダーロゴと若干重なる(SP のみ)
- 推奨: z-index: 100 + 上部 padding を 16px → 24px に
- 影響度: 低(機能は動作)
- aileap_v2 でも同じ問題(L-002 として記録済)— 共通修正で対応

---

## 8. 30 日後の継続監視

[seo-geo-strategy.md §7](../02-strategy/seo-geo-strategy.md) に従い:

- Lighthouse Accessibility 95+ 維持確認
- 上記 L-001 の対応完了確認

---

## 9. WMAO への申し送り

- 本書(latest 版)
- aileap_v2 design-system §10 / §1.4(継承元)
- LP 改善時の a11y チェックリスト(A/B テスト時に違反を生まない仕組み)
- L-001 の対応推奨(aileap_v2 と共通修正)

---

## 10. Sign-off

| 役割 | 名前 | 日付 |
|---|---|---|
| 監査者 | seo-geo-strategist(a11y 兼任) | 2026-06-25 |
| 技術確認 | frontend-lead | 2026-06-25 |
| デザイン確認 | art-direction-lead | 2026-06-25 |
| 最終承認 | delivery-director | 2026-06-25 |

**判定**: ✅ launch ゲート通過

---

## 11. 検証メモ(Phase I-A)

- aileap_v2 の design-system 継承で WCAG 2.2 AA を自動達成 — H-4 fix(トークン段階担保)が継承運用でも機能することを実証
- LP の `<details>` ベース FAQ がネイティブ a11y + Lighthouse Performance 向上の両立を達成
- A2 案件で a11y 専任不在(seo-geo-strategist 兼任)でも WCAG 2.2 AA 100% を達成可能

---

**Document Owner**: seo-geo-strategist(v0.4 で accessibility-specialist へ移管)
**Last Updated**: 2026-06-25
**Version**: 1.0
