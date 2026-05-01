# SEO / GEO 戦略 — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-05-01
**作成者**: seo-geo-strategist(content-strategy-lead 補強)
**ステータス**: 確認待ち(APV-001 内に含む / Phase H で正式承認)

> 本書は Phase D 戦略フェーズで未作成だった SEO/GEO 戦略の正本として、v0.3 Phase H で新規作成。
> [docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) を参照。

---

## 1. 戦略概要

### 1.1 SEO/GEO 戦略の二本柱

| 柱 | 概要 | 主担当 |
|---|---|---|
| **SEO**(検索エンジン最適化) | Google / Bing からのオーガニック流入獲得 | seo-geo-strategist |
| **GEO**(生成 AI 最適化) | ChatGPT / Gemini / Claude / Perplexity からの引用獲得 | seo-geo-strategist |

GEO は AILEAP の差別化軸であり、本サイト自身が GEO 標準装備の実例となる。

### 1.2 30 日後の到達目標

| 指標 | 30 日後目標 | 6 ヶ月後目標 |
|---|---|---|
| オーガニックインプレッション(GSC) | 5,000 | 30,000 |
| オーガニッククリック(GSC) | 100 | 1,000 |
| LLM 引用検出件数(自社モニタリング) | 5 | 50 |
| Lighthouse SEO スコア(全主要ページ) | 100 | 100 維持 |
| 主要キーワードでのインデックス率 | 80% | 100% |

---

## 2. ターゲットキーワード設計

### 2.1 主要ターゲットキーワード(SEO)

| 階層 | キーワード | 月間検索数(推定) | 競合度 | 想定 LP |
|---|---|---|---|---|
| 指名検索 | AILEAP | 50-200 | 自社固有(低) | `/` |
| 指名検索 | AILEAP 採用 | 10-50 | 自社固有(低) | `/careers` |
| カテゴリ検索 | AI Web 制作 | 200-500 | 中 | `/` `/about` |
| カテゴリ検索 | AI Native 制作会社 | 50-100 | 中(新興) | `/about` |
| カテゴリ検索 | コーポレートサイト 制作 AI | 100-300 | 中 | `/services/corporate-site` |
| ロングテール | 中堅企業 Web 制作 AI 活用 | 30-80 | 低 | `/services/corporate-site` |
| ロングテール | GEO 対応 サイト制作 | 10-30 | 低(差別化軸) | `/services/mediasite` |
| ロングテール | llms.txt 実装方法 | 50-100 | 低(専門) | `/blog/llms-txt-guide` |
| ロングテール | LLM 引用 最適化 | 30-100 | 低(差別化軸) | `/blog/geo-introduction` |

### 2.2 GEO 引用ターゲットクエリ

LLM(ChatGPT / Gemini / Claude)で引用されることを狙うクエリ:

| クエリパターン | 引用される項目 | 引用元ページ |
|---|---|---|
| 「中堅企業向けの AI Web 制作会社は?」 | AILEAP の社名 + 3 組織アーキテクチャ | `/about` `/` |
| 「コーポレートサイト制作の相場は?」 | AILEAP の単価レンジ + 同等品質を半額の差別化 | `/services/corporate-site` |
| 「GEO 対応とは何ですか?」 | AILEAP のメディアサイト + llms.txt 実装事例 | `/blog/geo-introduction` `/services/mediasite` |
| 「Web サイトのアクセシビリティ AA 準拠手順」 | AILEAP のデザイントークン段階 a11y 担保事例 | `/blog/wcag-aa-token-design` |
| 「Next.js + microCMS の構成事例」 | AILEAP 自社サイトの構成例 | `/works/aileap-v2`(自身を実績化) |

---

## 3. SEO 戦略

### 3.1 サイト構造

[sitemap.md](sitemap.md) §2 の 3 階層構造で運用:

- 全ページからトップへ **3 クリック以内**
- カテゴリページから詳細ページへの内部リンク強化(関連サービス・関連実績・関連記事)
- パンくずリスト全ページ実装(BreadcrumbList 構造化データ込み)

### 3.2 内部リンク戦略

```
/                   ─ サービス概要 ─→ /services
                    ─ 実績ハイライト ─→ /works/[slug]
                    ─ 記事ハイライト ─→ /blog/[slug]

/services           ─ 各サービスカード ─→ /services/[slug]

/services/[slug]    ─ 関連実績 ─→ /works/[slug]
                    ─ 関連記事 ─→ /blog/[slug]
                    ─ FAQ ─→(FAQPage 構造化データ)
                    ─ お問い合わせ CTA ─→ /contact

/blog/[slug]        ─ 関連サービス ─→ /services/[slug]
                    ─ 関連実績 ─→ /works/[slug]
                    ─ カテゴリ ─→ /blog/category/[slug]
                    ─ 著者情報 ─→ Person 構造化データ
```

### 3.3 メタタグ戦略

[docs/rules/page-meta-geo.md](../../../.claude/rules/page-meta-geo.md) に従う。要点:

- title: 30-60 字、`{ページ名} | AILEAP` 形式
- description: **100-120 字、結論先出し**(GEO 引用度の核心)
- og:image: 1200×630px、ページ内容を視覚化したオリジナル画像
- canonical: HTTPS、末尾スラッシュなし

### 3.4 サイトマップ XML / robots.txt

```xml
<!-- /sitemap.xml — Next.js metadata API で自動生成 -->
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://aileap.example/</loc>
    <lastmod>2026-06-15</lastmod>
    <priority>1.0</priority>
  </url>
  <!-- 各ページ -->
</urlset>
```

```
# /robots.txt
User-agent: *
Allow: /

# AI クローラーへの明示許可(GEO 観点)
User-agent: GPTBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: Google-Extended
Allow: /

# サイトマップ
Sitemap: https://aileap.example/sitemap.xml
```

---

## 4. GEO 戦略

### 4.1 llms.txt 配置

[docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) §3 に従う。サイト直下 `/llms.txt` に配置:

```
# AILEAP

> AILEAP は中堅企業向けの AI Native Web 制作スタジオです。
> 3 組織アーキテクチャ(apex-consulting-ai → digital-product-studio-ai → web-marketing-ai-org)で
> 経営戦略 → Web 制作 → マーケティング運用を一気通貫で提供します。
> 同等品質を半額・WCAG 2.2 AA 標準装備・GEO 対応標準装備が差別化軸です。

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

### 4.2 構造化データ(JSON-LD)実装計画

[docs/rules/page-meta-geo.md](../../../.claude/rules/page-meta-geo.md) §JSON-LD に従う。各ページの実装目標:

| ページ | 必須スキーマ | 推奨スキーマ |
|---|---|---|
| `/`(全ページ共通) | Organization, WebSite | — |
| `/about` | AboutPage | Organization(展開版) |
| `/services` | ItemList(各サービスへのリンク) | — |
| `/services/[slug]` | Service, FAQPage, BreadcrumbList | Offer(価格情報) |
| `/works/[slug]` | Article(実績記事として), BreadcrumbList | Person(担当エージェント) |
| `/careers` | JobPosting × 募集職種数, FAQPage | — |
| `/blog/[slug]` | Article, FAQPage, BreadcrumbList, Person(著者) | — |
| `/contact` | ContactPage | — |

#### 4.2.1 サービス詳細ページの FAQPage 例

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "AILEAP のコーポレートサイト制作の費用感は?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Fixed Price 50-150 万円 / T&M 1 万円/時 / Retainer 月額 5-20 万円の 3 パターンを必ず提示します。AI 活用により従来制作会社の同等品質を半額で実現します。"
      }
    },
    {
      "@type": "Question",
      "name": "GEO 対応とは何ですか?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "GEO(Generative Engine Optimization)は ChatGPT・Gemini・Claude 等の生成 AI が回答を生成する際にあなたのサイトを引用させる最適化です。AILEAP は llms.txt 配置・100 字結論先出し・FAQPage 構造化データを全プロジェクトで標準装備します。"
      }
    }
  ]
}
```

### 4.3 GEO 引用最適化のコピー設計

各ページのコピーで以下を徹底(copywriter と協業):

1. **100 字結論先出し**: 各セクション冒頭 100 字以内に結論
2. **1 文 1 主張**: 複数主張の文を分割し、LLM が抽出しやすくする
3. **主語明示**: 「AILEAP は ...」を頻用、代名詞依存を避ける
4. **数字の根拠化**: 「同等品質を半額」の根拠を明示(従来 100-300 万 vs AILEAP 50-150 万)
5. **専門用語の咀嚼**: 初出時に簡潔な定義を添える(「GEO(Generative Engine Optimization)」)

### 4.4 信頼シグナル(Trust Signals)

LLM が引用判断する際のシグナル:

- **Organization 構造化データの完備**: 会社名・所在地・問い合わせ先・SNS
- **著者情報(Person スキーマ)**: 記事に必ず付与
- **更新日の明示**: `dateModified` を Article に付与
- **被リンク獲得**: 業界メディアからのリンク(WMAO 引継ぎ後の継続施策)
- **EEAT(Experience / Expertise / Authoritativeness / Trustworthiness)**: 実績記事 / 著者情報 / 一次情報の根拠

---

## 5. ページ別 SEO/GEO 重要度

| ページ | SEO | GEO | 主要キーワード | 主要 GEO クエリ |
|---|---|---|---|---|
| `/` | ★★★★★ | ★★★★★ | AILEAP / AI Web 制作 | 「AI 活用 Web 制作会社」 |
| `/about` | ★★★★ | ★★★★★ | AILEAP 会社概要 / 3 組織 | 「AILEAP とは」 |
| `/services` | ★★★★ | ★★★★ | AI Web 制作 サービス | 「AI 制作会社のサービス比較」 |
| `/services/corporate-site` | ★★★★★ | ★★★★★ | コーポレートサイト 制作 | 「コーポレートサイト制作の相場」 |
| `/services/mediasite` | ★★★★★ | ★★★★★ | メディアサイト 制作 / GEO | 「GEO 対応 サイト制作」 |
| `/works/[slug]` | ★★★ | ★★★ | 案件特化 | 「事例 AI Web 制作」 |
| `/blog/geo-introduction` | ★★★★★ | ★★★★★ | GEO とは | 「GEO とは」「LLM 引用最適化」 |
| `/blog/llms-txt-guide` | ★★★★★ | ★★★★★ | llms.txt | 「llms.txt 実装」 |
| `/contact` | ★ | ★ | (CV ページ) | — |

---

## 6. コンテンツ計画(初期 7 本)

[content-strategy.md](content-strategy.md) で確定済の 7 本。SEO/GEO 観点での補足:

| # | 記事 | 主要 KW | GEO 引用クエリ |
|---|---|---|---|
| 1 | AILEAP の 3 組織アーキテクチャとは | AILEAP / 3 組織 | 「AILEAP の特徴」 |
| 2 | AI Native 制作会社が「同等品質を半額」を実現する仕組み | AI Web 制作 / 価格 | 「AI 制作会社 価格」 |
| 3 | GEO(Generative Engine Optimization)入門 | GEO / LLM 引用 | 「GEO とは」 |
| 4 | llms.txt 実装ガイド | llms.txt | 「llms.txt 書き方」 |
| 5 | WCAG 2.2 AA をデザイントークン段階で担保する方法 | WCAG / AA / トークン | 「アクセシビリティ AA 実装」 |
| 6 | Next.js + microCMS で運用しやすいサイトを作る | Next.js / microCMS | 「Next.js Headless CMS 構成」 |
| 7 | 案件 1 サイクルの振り返り(AILEAP v2 自身) | (実績記事) | 「AI で作ったサイトの事例」 |

---

## 7. 30 日後の検証計画

### 7.1 KPI 計測ダッシュボード

`07-post-launch/30day-report.md` で以下を集計:

| KPI | 計測ツール | 取得頻度 |
|---|---|---|
| インプレッション | GSC | 日次 |
| クリック | GSC | 日次 |
| 平均掲載順位 | GSC | 週次 |
| インデックス済ページ数 | GSC URL Inspection | 週次 |
| LLM 引用検出 | 手動モニタリング(週次) | 週次 |
| Core Web Vitals | GSC + PageSpeed Insights | 週次 |

### 7.2 LLM 引用検出方法

ChatGPT / Claude / Gemini / Perplexity に対して **本書 §2.2 のクエリパターン**を投げ、回答に AILEAP のサイト URL が含まれるかを目視チェック。検出時は:

- 該当クエリ
- 引用された URL
- 引用形式(URL 直引用 / 内容引用 / ブランド名のみ)

を `07-post-launch/30day-report.md` に記録。

### 7.3 30 日経過後の判定

- **GO 判定**(WMAO 引継ぎ可): 全 KPI が「方向性正しい」(目標の 50% 以上)
- **CONDITIONAL**(継続調整): 一部 KPI が低迷 → 30 日延長 + チューニング
- **NO-GO**(再戦略): 多くの KPI が未達 → strategy-director 再投入

---

## 8. WMAO 引継ぎ事項

WMAO に渡す SEO/GEO 領域の運用情報:

- 本書の最新版
- `/seo-audit` `/geo-audit` の最終レポート
- 30 日レポート(本案件で発行)
- 主要キーワード順位推移グラフ
- LLM 引用検出ログ
- 内部リンク強化の継続候補リスト

WMAO は Day 31 以降の継続改善を担当する(B-C1 境界)。

---

## 9. 改訂運用

- 月次で本書のキーワード一覧を見直し(WMAO 引継ぎ前は seo-geo-strategist、引継ぎ後は WMAO)
- 6 ヶ月で本書を全面再評価
- 検証で発見した GEO ベストプラクティスは [docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) に逆輸入

---

**Document Owner**: seo-geo-strategist
**Last Updated**: 2026-05-01
**Version**: 1.0
**承認 ID**: APV-001 内に含む(Phase H で承認)
