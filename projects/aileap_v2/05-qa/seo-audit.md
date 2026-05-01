# SEO 監査レポート — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**監査日**: 2026-06-12(staging 環境)
**監査者**: seo-geo-strategist(frontend-lead 補助)
**対象 URL**: https://staging.aileap.example
**版**: 1.0
**ステータス**: ✅ Pass(launch ゲート通過)

---

## 0. サマリー

**総合判定**: ✅ **GO**(launch 許可)

| 区分 | スコア / 件数 |
|---|---|
| Lighthouse SEO(全主要ページ平均) | **100** / 100 |
| Critical 問題 | **0** 件 |
| High 問題 | **0** 件 |
| Medium 問題 | 2 件(launch 後対応可) |
| Low 問題 | 3 件(WMAO 引継ぎ後改善) |

実装が `02-strategy/seo-geo-strategy.md` の戦略を忠実に反映しており、launch ゲートの最低基準を全項目で満たしている。Medium / Low 問題はすべて launch ブロッカーではない。

---

## 1. 監査範囲

### 1.1 対象ページ(11 ページ)

| # | URL | 監査済 |
|---|---|---|
| 1 | `/` | ✅ |
| 2 | `/about` | ✅ |
| 3 | `/services` | ✅ |
| 4 | `/services/corporate-site` | ✅ |
| 5 | `/services/landing-page` | ✅ |
| 6 | `/services/mediasite` | ✅ |
| 7 | `/services/retainer` | ✅ |
| 8 | `/works`(初期 1 件含む) | ✅ |
| 9 | `/works/aileap-v2`(自身を実績化) | ✅ |
| 10 | `/blog/[slug]`(初期 7 本サンプル) | ✅(代表 3 本) |
| 11 | `/contact` | ✅ |

en バリアント(主要 5 ページ)も併せて監査。

### 1.2 監査項目

[docs/rules/page-meta-geo.md](../../../.claude/rules/page-meta-geo.md) と [02-strategy/seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §3 を基準。

---

## 2. メタタグ監査

### 2.1 全ページ共通項目

| 項目 | 全 11 ページ |
|---|---|
| `<title>` 存在 + 30-60 字 | ✅ 全件 |
| `<meta name="description">` 存在 + 100-120 字 | ✅ 全件(平均 112 字) |
| `og:title` / `og:description` / `og:image` / `og:url` / `og:type` / `og:locale` | ✅ 全件 |
| `twitter:card`(summary_large_image) | ✅ 全件 |
| `<link rel="canonical">` | ✅ 全件(HTTPS / 末尾スラッシュなし) |
| `og:image` 寸法(1200×630) | ✅ 全件 |

### 2.2 個別ページの description サンプル

| ページ | description(112 字以内) |
|---|---|
| `/` | 「AILEAP は中堅企業向けの AI Native Web 制作スタジオ。経営戦略 → Web 制作 → マーケ運用を一気通貫で提供。同等品質を半額・WCAG 2.2 AA・GEO 標準装備が差別化軸。」(110 字) |
| `/about` | 「AILEAP の 3 組織アーキテクチャ(apex / digital-product-studio-ai / WMAO)を紹介。AI エージェント 21 体 + Shin が中堅企業の Web 制作を支える体制。」(108 字) |
| `/services/corporate-site` | 「AILEAP のコーポレートサイト制作は Fixed 50-150 万円 / T&M / Retainer の 3 パターン提示。WCAG 2.2 AA + GEO 標準装備で同等品質を半額。」(105 字) |

すべて結論先出し(GEO 観点)。

---

## 3. 構造化データ(JSON-LD)監査

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §4.2 の実装計画通り。

| ページ | 必須スキーマ | 実装状態 | Google Rich Results Test |
|---|---|---|---|
| `/` | Organization, WebSite | ✅ | ✅ Valid |
| `/about` | AboutPage, Organization | ✅ | ✅ Valid |
| `/services` | ItemList | ✅ | ✅ Valid |
| `/services/[slug]` | Service, FAQPage, BreadcrumbList | ✅ | ✅ Valid |
| `/works/[slug]` | Article, BreadcrumbList | ✅ | ✅ Valid |
| `/blog/[slug]` | Article, FAQPage, BreadcrumbList, Person | ✅ | ✅ Valid |
| `/contact` | ContactPage | ✅ | ✅ Valid |

FAQPage は `/services/[slug]` 全 4 件 + 主要記事 3 本に実装。GEO 引用の中核となる。

---

## 4. サイトマップ・robots.txt 監査

| 項目 | 検証結果 |
|---|---|
| `/sitemap.xml` 存在 | ✅ |
| 全 11 ページが含まれる | ✅(en バリアント 5 ページ含めて 16 URL) |
| `<lastmod>` 全件あり | ✅ |
| hreflang(xhtml:link)が ja/en/x-default で含まれる | ✅ |
| `/robots.txt` 存在 | ✅ |
| `Sitemap:` ディレクティブで sitemap.xml 参照 | ✅ |
| GPTBot / ClaudeBot / Google-Extended Allow | ✅(GEO 観点で必須) |
| 不要パスの Disallow(`/api/` 等) | ✅ |

---

## 5. canonical / hreflang 監査

### 5.1 canonical

| 項目 | 結果 |
|---|---|
| 全ページに canonical あり | ✅ |
| HTTPS / 末尾スラッシュなしの統一 | ✅ |
| 重複コンテンツの canonical 自己参照 | ✅ |
| ja/en バリアント間で canonical が混在しない | ✅ |

### 5.2 hreflang(en 化対象 5 ページ + その ja 版)

| ページ | ja → en | en → ja | x-default |
|---|---|---|---|
| `/` ↔ `/en/` | ✅ | ✅ | ja を指す ✅ |
| `/about` ↔ `/en/about` | ✅ | ✅ | ja ✅ |
| `/services` ↔ `/en/services` | ✅ | ✅ | ja ✅ |
| `/works` ↔ `/en/works` | ✅ | ✅ | ja ✅ |
| `/contact` ↔ `/en/contact` | ✅ | ✅ | ja ✅ |

en 非対応ページ(`/services/[slug]` 等)には hreflang を配置せず(意図通り)。

---

## 6. 内部リンク監査

| 項目 | 結果 |
|---|---|
| 全ページからトップへ 3 クリック以内 | ✅(平均 2 クリック) |
| パンくずリスト全ページ実装 | ✅ |
| BreadcrumbList JSON-LD 付与 | ✅ |
| 内部リンクの anchor text(「click here」を避ける) | ✅(具体的キーワード使用) |
| nofollow 不要箇所の付与確認 | ✅(SNS 等の信頼度低リンクは rel="noopener noreferrer") |
| broken link | 0 件 |

---

## 7. 画像 SEO 監査

| 項目 | 結果 |
|---|---|
| 全画像に `alt` 属性 | ✅ 全件 |
| 装飾画像の alt="" 明示 | ✅(ヒーロー背景等) |
| WebP / AVIF 配信 | ✅(next/image 経由) |
| 画像寸法(width/height)指定 | ✅(CLS 防止) |
| ヒーロー画像 priority + eager | ✅ |
| その他 lazy | ✅ |
| OGP 画像 1200×630 | ✅ 全 11 ページ + 記事 7 本分 |

---

## 8. ページ速度(Lighthouse SEO)

| ページ | Lighthouse SEO | Performance | A11y | Best Practices |
|---|---|---|---|---|
| `/` | 100 | 96 | 100 | 100 |
| `/about` | 100 | 95 | 100 | 100 |
| `/services` | 100 | 94 | 100 | 100 |
| `/services/corporate-site` | 100 | 93 | 100 | 100 |
| `/services/mediasite` | 100 | 93 | 100 | 100 |
| `/works` | 100 | 95 | 100 | 100 |
| `/blog/geo-introduction` | 100 | 92 | 100 | 100 |
| `/contact` | 100 | 96 | 100 | 100 |
| **平均** | **100** | **94.3** | **100** | **100** |

すべて [pricing-strategy.md](../../../docs/pricing-strategy.md) 含む全体予算(SEO 100, Perf 90+, A11y 95+, BP 90+)を超過達成。

---

## 9. mobile-friendly / レスポンシブ監査

| 項目 | 結果 |
|---|---|
| Viewport meta tag(width=device-width, initial-scale=1) | ✅ |
| タップターゲット 44×44px 以上 | ✅(design-system §4.3) |
| 文字サイズ 16px 以上(本文) | ✅ |
| 横スクロール発生 | なし(320px 幅まで OK) |
| Mobile Friendly Test(Google) | ✅ Pass |

---

## 10. 検出された問題

### 10.1 Critical / High

なし。

### 10.2 Medium(launch 後対応可・WMAO 引継ぎ前)

#### M-001: 一部記事の description が結論先出し弱い

- 対象: `/blog/wcag-aa-token-design`
- 症状: description 冒頭 30 字が「アクセシビリティとは...」の概念説明から始まる
- 推奨: 「AILEAP は WCAG 2.2 AA をデザイントークン段階で...」と結論先出しに書き換え
- 影響度: 中(GEO 引用率に若干影響)
- 対応者: copywriter / seo-geo-strategist

#### M-002: 内部記事間の関連リンクが薄い記事あり

- 対象: `/blog/aileap-3org-architecture`
- 症状: 関連サービス・関連実績へのリンクが 1 件のみ(他記事は平均 3 件)
- 推奨: 関連サービスを 2-3 件追加
- 影響度: 中(SEO の内部リンク強度)
- 対応者: copywriter

### 10.3 Low(WMAO 引継ぎ後の継続改善)

#### L-001: 画像の lazy loading で fold 直下に若干の遅延

- 症状: `/blog/[slug]` の本文 1 枚目が viewport 直下にあり、scroll の最初の数秒で表示される印象
- 推奨: 本文 1 枚目を eager に変更(または `loading="eager"`)
- 影響度: 低(LCP は既に < 2.0s)

#### L-002: og:image のテキスト視認性(英語版)

- 症状: en 版 OGP 画像で英語フォントの視認性がやや低い
- 推奨: en 版 OGP 画像のフォントを Inter Bold へ調整
- 影響度: 低(SNS シェア時のみ影響)

#### L-003: structured data の Person スキーマの sameAs 不足

- 症状: 著者(AI agents 抽象)情報の Person スキーマで sameAs が空
- 推奨: GitHub / X 等の SNS リンク追加(将来用)
- 影響度: 低(EEAT 観点でわずかに影響)

---

## 11. 30 日後の検証計画(WMAO 引継ぎ前)

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §7 に従い、公開後 30 日で:

1. GSC でインプレッション・クリック・順位を確認
2. インデックス済ページ数を URL Inspection で確認(目標: 全 11 ページ + en 5 ページ)
3. Core Web Vitals 実測(GSC + PageSpeed Insights)
4. 主要キーワード順位推移
5. 30day-report として `06-handoff/seo-geo-30day-report.md` に集計

---

## 12. WMAO への申し送り

公開 31 日目以降の継続改善で WMAO に渡す:

- 本書(latest 版)
- 30day-report
- Medium 問題 2 件 + Low 問題 3 件の対応推奨
- 主要キーワードリストの月次見直し提案
- バックリンク獲得の継続施策提案(本案件のスコープ外)

---

## 13. Sign-off

| 役割 | 名前 | 日付 |
|---|---|---|
| 監査者 | seo-geo-strategist | 2026-06-12 |
| 技術確認 | frontend-lead | 2026-06-12 |
| 最終承認 | delivery-director | 2026-06-12 |

**判定**: ✅ launch ゲート通過

---

**Document Owner**: seo-geo-strategist
**Last Updated**: 2026-06-12
**Version**: 1.0
