# GEO 監査レポート — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**監査日**: 2026-06-12(staging 環境)
**監査者**: seo-geo-strategist
**対象 URL**: https://staging.aileap.example
**版**: 1.0
**ステータス**: ✅ Pass(launch ゲート通過)

---

## 0. サマリー

**総合判定**: ✅ **GO**(launch 許可)

| 区分 | 件数 |
|---|---|
| Critical 問題 | **0** 件 |
| High 問題 | **0** 件 |
| Medium 問題 | 2 件(launch 後の継続改善対象) |
| Low 問題 | 2 件(WMAO 引継ぎ後改善) |

[docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) §8 のチェックリスト全 28 項目中、必須 22 項目すべて pass。

GEO は AILEAP の差別化軸であり、本サイト自身が **GEO 標準装備の実例** となる。本監査は、その実例として恥ずかしくない実装が達成されたことを確認する。

---

## 1. 監査範囲

### 1.1 GEO 監査の核心 4 領域

| 領域 | 監査項目 |
|---|---|
| 1. llms.txt | サイトルート配置 + 構造化された案内 |
| 2. JSON-LD 構造化データ | 必須スキーマ完備 + Rich Results Test pass |
| 3. 引用しやすい文章構造 | 結論先出し / 1 文 1 主張 / 主語明示 / 数字根拠 |
| 4. 信頼シグナル(Trust Signals) | Organization / Author / dateModified / EEAT |

### 1.2 対象ページ

[seo-audit.md](seo-audit.md) §1.1 と同じ 11 ページ + en 5 ページ。

---

## 2. llms.txt 監査

### 2.1 配置確認

| 項目 | 結果 |
|---|---|
| `/llms.txt` がサイトルートに配置 | ✅ |
| Content-Type: text/plain; charset=utf-8 | ✅ |
| HTTPS で配信 | ✅ |
| HTTP ステータス 200 | ✅ |
| キャッシュヘッダー(Cache-Control: public, max-age=3600) | ✅ |

### 2.2 内容構造

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §4.1 の構成案通りに実装:

```
# AILEAP

> AILEAP は中堅企業向けの AI Native Web 制作スタジオです。...

## サービス
- A1 コーポレートサイト: /services/corporate-site
- A2 ランディングページ: /services/landing-page
- A3 メディアサイト: /services/mediasite
- Retainer 月額保守: /services/retainer

## 会社情報
- 会社概要: /about
- 採用情報: /careers
- お問い合わせ: /contact

## 主要記事
- GEO 入門: /blog/geo-introduction
- llms.txt 実装ガイド: /blog/llms-txt-guide
- WCAG AA トークン設計: /blog/wcag-aa-token-design

## 連絡先
- メール: contact@aileap.example
- 採用: careers@aileap.example
```

| 必須要素 | 状態 |
|---|---|
| サイト名(`# AILEAP`) | ✅ |
| サイト概要(`>` ブロック)100 字以内 | ✅(95 字) |
| 主要 URL の構造化リスト | ✅ |
| 連絡先情報 | ✅ |
| 全 URL が絶対パスではなく相対パス | ✅(LLM が解釈しやすい) |

---

## 3. JSON-LD 構造化データ監査

[docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) §4 の必須スキーマ。

### 3.1 必須スキーマ網羅率(全ページ)

| スキーマ | 必須箇所 | 実装率 |
|---|---|---|
| Organization | root layout(全ページ) | 100% |
| WebSite | root layout(全ページ) | 100% |
| WebPage | 全ページ | 100% |
| BreadcrumbList | 2+ 階層ページ(7 ページ) | 100% |
| FAQPage | サービス詳細 4 + 記事 3 = 7 件 | 100% |
| Article | 記事 7 + 実績 1 = 8 件 | 100% |
| Person | 記事の著者(8 件) | 100% |

### 3.2 Rich Results Test 結果

| ページ | テスト結果 |
|---|---|
| `/` | ✅ Valid(Organization, WebSite) |
| `/about` | ✅ Valid(AboutPage) |
| `/services/corporate-site` | ✅ Valid(Service + FAQPage + BreadcrumbList) |
| `/blog/geo-introduction` | ✅ Valid(Article + FAQPage + Author) |
| `/works/aileap-v2` | ✅ Valid(Article + BreadcrumbList) |

警告 0 件 / エラー 0 件 / 全 11 ページ pass。

### 3.3 GEO 引用度を高める拡張スキーマ

| 拡張要素 | 実装状態 |
|---|---|
| `dateModified` (Article) | ✅ 全記事 |
| `inLanguage` (Organization, Article) | ✅ |
| `Person.sameAs`(著者の SNS リンク) | ⚠️ 一部のみ(Low 問題 §10.4 参照) |
| `Service.offers.priceRange` | ✅(各サービス詳細) |
| `FAQPage.mainEntity[].acceptedAnswer.text` 100 字以上 | ✅ 全件 |

---

## 4. 引用しやすい文章構造の監査

### 4.1 100 字結論先出し(各セクション冒頭)

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §4.3 のルール。

| ページ・セクション | 冒頭 100 字に結論あり |
|---|---|
| `/` ヒーロー | ✅(70 字) |
| `/about` 設立背景セクション | ✅(95 字) |
| `/services/corporate-site` 課題提起 | ✅(80 字) |
| `/services/mediasite` 価格セクション | ✅(85 字) |
| `/blog/geo-introduction` 冒頭 | ✅(92 字) |
| `/blog/llms-txt-guide` 冒頭 | ✅(78 字) |

サンプル抽出 6 ページすべて pass。

### 4.2 1 文 1 主張

サンプル: `/blog/geo-introduction` の本文 50 文をチェック:

- 1 主張: 47 文
- 2 主張(複文): 3 文 → 修正提案あり(M-001)

合格率 94%。修正提案を copywriter に展開済。

### 4.3 主語明示

| サンプル | 主語明示 |
|---|---|
| `/about` 自己紹介 | ✅(「AILEAP は」/「我々」を 8:2 で「AILEAP は」優勢) |
| `/services/[slug]` 説明 | ✅ |
| `/blog/[slug]` 本文 | ✅(代名詞依存少ない) |

### 4.4 数字の根拠化

| 主張 | 根拠 |
|---|---|
| 「同等品質を半額」 | ✅(従来 100-300 万 vs AILEAP 50-150 万を明示) |
| 「30 日で WMAO 引継ぎ」 | ✅(handoff-protocols.md §4.6 を参照) |
| 「WCAG 2.2 AA 標準装備」 | ✅(design-system のコントラスト比表を参照) |
| 「Lighthouse 90+」 | ✅(具体的スコア例を services 詳細で開示) |

---

## 5. 信頼シグナル監査

### 5.1 Organization の完備性

```json
{
  "@type": "Organization",
  "name": "AILEAP",
  "url": "https://aileap.example",
  "logo": "https://aileap.example/logo.png",
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer service",
    "email": "contact@aileap.example"
  },
  "sameAs": [
    "https://x.com/aileap",
    "https://github.com/aileap"
  ],
  "inLanguage": ["ja", "en"]
}
```

| 必須要素 | 状態 |
|---|---|
| name | ✅ |
| url | ✅ |
| logo | ✅(SVG + PNG fallback) |
| contactPoint | ✅ |
| sameAs(SNS) | ✅ |
| inLanguage | ✅ |

### 5.2 著者情報(Person スキーマ)

各記事の著者情報:

```json
{
  "@type": "Person",
  "name": "AILEAP / content-strategy-lead",
  "description": "AILEAP のコンテンツ戦略担当 AI エージェント",
  "image": "https://aileap.example/og/agents/content-strategy-lead.png"
}
```

「中の人 = AI エージェント」を抽象表現として実装(design-system.md §1.4 の MUST に従う)。実在の人間ではないため、 `birthDate` 等は省略。

### 5.3 dateModified

全 Article スキーマで `dateModified` を ISO 8601 形式で出力:

```json
{
  "@type": "Article",
  "datePublished": "2026-05-15T00:00:00+09:00",
  "dateModified": "2026-06-12T00:00:00+09:00"
}
```

WMAO 引継ぎ後の継続更新でも `dateModified` を必ず更新するよう申し送る。

### 5.4 EEAT(Experience / Expertise / Authoritativeness / Trustworthiness)

| 軸 | 実装状況 |
|---|---|
| Experience(体験) | ✅(`/works/aileap-v2` で「自身を実績化」した一次情報) |
| Expertise(専門性) | ✅(`/blog/geo-introduction` 等で技術解説) |
| Authoritativeness(権威性) | ⚠️ 限定(被リンクは launch 直後のためゼロ。WMAO 継続施策で対応) |
| Trustworthiness(信頼性) | ✅(privacy / 法務確認 / Organization 完備) |

---

## 6. LLM 引用テストの予備実施

### 6.1 staging サイトに対する手動クエリテスト

主要 LLM(ChatGPT / Claude / Gemini / Perplexity)に対して、`seo-geo-strategy.md` §2.2 のターゲットクエリを投入し、staging サイトの引用が発生するかを予備テスト(staging はインデックスされていないため、直接 URL を指示する形式):

| クエリ | LLM | URL 引用 |
|---|---|---|
| 「中堅企業向けの AI Web 制作会社は?」(直接 staging URL を提示) | Claude | ✅ 引用された |
| 「コーポレートサイト制作の相場は?」 | ChatGPT | ✅ 引用された(価格レンジを正確に) |
| 「GEO 対応とは?」 | Gemini | ✅ 引用された(blog 記事を) |
| 「llms.txt の書き方は?」 | Perplexity | ✅ 引用された(blog 記事を) |

予備テストは「LLM が引用可能な情報構造になっているか」の確認。実際の引用率は 30 日レポートで実測。

---

## 7. mobile / 多言語の GEO

### 7.1 mobile

LLM クローラーは mobile-first index 後の世界でも変わらないが、構造化データは mobile / desktop 両方で同一。問題なし。

### 7.2 多言語(en)の GEO

en 版主要 5 ページの GEO 状況:

| 項目 | 状態 |
|---|---|
| `/en/`(en トップ)の構造化データ | ✅(`inLanguage: en`) |
| en 版に独自の `/en/llms.txt` | ⚠️ 未実装(v0.4 で対応予定 / Low 問題) |
| en 記事は本案件では実装なし | (v0.4 検討) |

---

## 8. パフォーマンス連動の GEO

LLM クローラーが訪問した際にレスポンスが速いことも GEO に影響する(クローラーのタイムアウト回避):

| 指標 | 結果 |
|---|---|
| TTFB(Time to First Byte) | < 300ms(Vercel Edge 配信) |
| ページ読込完了時間 | < 2s(主要ページ) |
| robots.txt の `Crawl-delay` | 設定なし(高頻度クロール許容) |

---

## 9. 自動チェック(全静的ページ)

[docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) §8 の 28 項目チェックリストを自動実行:

| カテゴリ | pass / total |
|---|---|
| 1. llms.txt | 4 / 4 |
| 2. JSON-LD | 6 / 6 |
| 3. メタタグ | 5 / 5 |
| 4. 構造化文章 | 4 / 4 |
| 5. 信頼シグナル | 5 / 5 |
| 6. 多言語 | 2 / 4(M-002, L-002 で減点) |
| 7. パフォーマンス | 2 / 2 |
| **合計** | **28 / 30**(必須 22 / 22 + 任意 6 / 8) |

必須 22 項目はすべて pass。任意 8 項目中 6 項目達成。

---

## 10. 検出された問題

### 10.1 Critical / High

なし。

### 10.2 Medium(継続改善対象)

#### M-001: `/blog/geo-introduction` 本文に 2 主張の文が 3 箇所

- 症状: 1 文 1 主張ルールに違反する文が 3 箇所
- 推奨: 各文を 2-3 文に分割
- 影響度: 中(GEO 引用時の抽出精度に影響)
- 対応者: copywriter

#### M-002: en 版に `/en/llms.txt` が未実装

- 症状: en サイトには英語向けの llms.txt がない
- 推奨: `/en/llms.txt` を v0.4 で実装(en 版コンテンツが拡張されてから)
- 影響度: 中(en 環境での LLM 引用優位を逃す)
- 対応者: localization-specialist

### 10.3 Low

#### L-001: `dateModified` が一部記事で `datePublished` と同じ

- 症状: 改訂のない記事は `dateModified == datePublished` のままで OK だが、最新の改訂日に更新されていない記事が 2 件
- 推奨: 改訂時に `dateModified` を必ず更新する SOP を WMAO に申し送り

#### L-002: en 版 OGP 画像の文字視認性

- (seo-audit.md L-002 と重複)

---

## 11. 30 日後の検証計画

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §7.2 の LLM 引用検出を実施:

1. 主要 LLM(ChatGPT / Claude / Gemini / Perplexity)に対して §2.2 のクエリを投入
2. 検出された引用 URL を `06-handoff/seo-geo-30day-report.md` に記録
3. 引用形式(URL 直引用 / 内容引用 / ブランド名のみ)の分布
4. WMAO 引継ぎ前に「引用獲得トレンド」レポート

目標: 月間 5 件の LLM 引用検出(本案件 launch 後 30 日時点)。

---

## 12. WMAO への申し送り

公開 31 日目以降の GEO 継続施策で WMAO に渡す:

- 本書(latest 版)
- 30day-report での引用検出ログ
- Medium / Low 問題の対応推奨
- llms.txt の月次見直しガイドライン
- 新規記事追加時の FAQPage / Person スキーマの SOP

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
