# SEO 監査レポート — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**監査日**: 2026-06-25(staging 環境)
**監査者**: seo-geo-strategist
**対象 URL**: https://staging.meetingai.aileap.example
**版**: 1.0
**ステータス**: ✅ Pass(launch ゲート通過)

---

## サマリー

**総合判定**: ✅ **GO**(launch 許可)

| 区分 | 結果 |
|---|---|
| Lighthouse SEO スコア(`/` + `/thanks`) | **100 / 100** |
| Critical 問題 | **0** 件 |
| High 問題 | **0** 件 |
| Medium 問題 | 1 件(launch 後対応可) |
| Low 問題 | 1 件 |

---

## 1. 監査範囲(LP 軽量版)

| URL | 監査済 |
|---|---|
| `/` | ✅ |
| `/thanks` | ✅(noindex 確認) |

aileap_v2 の SEO 監査(11 ページ)と比べて非常にコンパクト。

---

## 2. メタタグ監査

| 項目 | `/` | `/thanks` |
|---|---|---|
| `<title>` 30-60 字 | ✅(31 字) | ✅(20 字) |
| description 100-120 字 | ✅(118 字 / 結論先出し) | ✅(noindex のため簡素) |
| og:title / og:description / og:image / og:url / og:type / og:locale | ✅ | ✅ |
| twitter:card(summary_large_image) | ✅ | ✅ |
| canonical | ✅(末尾スラッシュなし統一) | ✅ |
| robots(thanks のみ noindex) | — | ✅ noindex |

### 2.1 `/` の description サンプル

> 「MeetingAI は会議の録音から要約 + 議事録 + 検索を自動化する SaaS。日本語特化精度 95% で中堅企業のバックオフィスの工数を 90% 削減。β版を無料で試す。」(118 字 / 結論先出し / 数字根拠 / CTA 言及)

GEO 引用観点でも最適化済み。

---

## 3. 構造化データ(JSON-LD)監査

| ページ | スキーマ | Rich Results Test |
|---|---|---|
| `/` | Organization, WebSite, WebPage, Service, FAQPage | ✅ Valid |
| `/thanks` | WebPage | ✅ Valid |

### 3.1 Service スキーマ(LP 固有・GEO 引用最重要)

```json
{
  "@type": "Service",
  "name": "MeetingAI",
  "provider": { "@type": "Organization", "name": "AILEAP" },
  "serviceType": "会議要約 / 議事録自動生成 SaaS",
  "areaServed": "JP",
  "offers": { "@type": "Offer", "price": "0", "priceCurrency": "JPY" }
}
```

✅ 全フィールド完備 / Rich Results Test pass。

### 3.2 FAQPage スキーマ(8 件・GEO 引用の核心)

8 件すべて 100 字以上の `acceptedAnswer.text` で実装。Rich Results Test pass。

---

## 4. サイトマップ・robots.txt 監査

| 項目 | 結果 |
|---|---|
| `/sitemap.xml` 存在 | ✅(`/` のみ・thanks 除外) |
| `<lastmod>` あり | ✅ |
| `/robots.txt` 存在 | ✅ |
| `Sitemap:` ディレクティブで sitemap.xml 参照 | ✅ |
| GPTBot / ClaudeBot / Google-Extended Allow | ✅(GEO 観点で必須) |
| `/thanks` Disallow | ✅(noindex と整合) |

---

## 5. canonical / hreflang 監査

| 項目 | 結果 |
|---|---|
| canonical 全ページ | ✅ |
| HTTPS / 末尾スラッシュなしの統一 | ✅ |
| hreflang | 配置なし(本 LP は ja のみ・意図通り) |

---

## 6. 内部リンク監査

| 項目 | 結果 |
|---|---|
| LP 内のスクロール用アンカーリンク | ✅(機能 1/2/3 / FAQ / フォームへ) |
| aileap_v2 への外部リンク(統合運用) | ✅(フッター + thanks ページ) |
| broken link | 0 件 |

LP 単独のため内部リンクは限定的。aileap_v2 との統合運用が機能している。

---

## 7. 画像 SEO 監査

| 項目 | 結果 |
|---|---|
| 全画像に `alt` | ✅ 全件 |
| 装飾画像 alt="" 明示 | ✅(背景画像) |
| WebP / AVIF 配信 | ✅(next/image 経由) |
| 画像寸法指定(CLS 防止) | ✅ |
| ヒーロー画像 priority | ✅ |
| OGP 1200×630 | ✅(2 ページ分) |

---

## 8. ページ速度(Lighthouse)

| ページ | Performance | Accessibility | SEO | Best Practices |
|---|---|---|---|---|
| `/` | **97** | 100 | 100 | 100 |
| `/thanks` | 99 | 100 | 100 | 100 |

LP の Performance 95+ 目標を達成。

### 8.1 Core Web Vitals(`/`)

| 指標 | 実測 | 目標 |
|---|---|---|
| LCP | 1.6s | ≤ 2.0s ✅ |
| INP | 80ms | ≤ 100ms ✅ |
| CLS | 0.02 | ≤ 0.05 ✅ |

---

## 9. mobile-friendly 監査

✅ Mobile Friendly Test pass / 320px 幅で水平スクロールなし / タップターゲット 44×44px 以上。

---

## 10. 検出された問題

### Critical / High: なし

### Medium

#### M-001: ヒーロー OGP 画像のフォント視認性

- 症状: OGP 画像のサブテキスト(英字)が小サイズで視認しづらい
- 推奨: フォントサイズを 24px → 32px に拡大
- 影響度: 中(SNS シェア時のみ)
- 対応者: ui-designer / frontend-engineer
- 対応期日: 公開後 14 日以内(launch ブロックではない)

### Low

#### L-001: アンカーリンクの scroll-margin-top 微調整

- 症状: アンカーリンクで遷移時にヘッダーがコンテンツに被る場合がある(SP のみ)
- 推奨: scroll-margin-top: 80px → 96px に微調整
- 影響度: 低

---

## 11. 30 日後の検証計画

[seo-geo-strategy.md §5](../02-strategy/seo-geo-strategy.md#5-30-日後の検証計画) の手法を実施。`06-handoff/seo-geo-30day-report.md` で集計。

---

## 12. WMAO への申し送り

- 本書(latest 版)
- 30 日レポート(発行予定)
- A/B テスト候補リスト(LP 改善施策)
- Medium / Low 問題の対応推奨

---

## 13. Sign-off

| 役割 | 名前 | 日付 |
|---|---|---|
| 監査者 | seo-geo-strategist | 2026-06-25 |
| 技術確認 | frontend-lead | 2026-06-25 |
| 最終承認 | delivery-director | 2026-06-25 |

**判定**: ✅ launch ゲート通過

---

**Document Owner**: seo-geo-strategist
**Last Updated**: 2026-06-25
**Version**: 1.0
