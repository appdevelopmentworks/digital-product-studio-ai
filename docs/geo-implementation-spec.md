# GEO 実装仕様書

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 1.4 / [gap-analysis-v0.1.md](gap-analysis-v0.1.md) D-H1 対応の独立文書
**対象**: GEO(Generative Engine Optimization)= LLM 引用最適化
**主担当エージェント**: seo-geo-strategist

---

## 0. 本書の目的

GEO(Generative Engine Optimization)は、ChatGPT / Claude / Perplexity / Google AI Overviews など、LLM 経由の検索・回答生成において自社サイトのコンテンツが**引用・参照されやすくなる**よう最適化する手法群である。

[gap-analysis-v0.1.md](gap-analysis-v0.1.md) D-H1 で指摘されたとおり、v0.1 では GEO が「差別化要素」として言及されただけで具体仕様がなかった。本書は実装可能な水準まで GEO を仕様化する。

本書の主な対象読者:
- `seo-geo-strategist`(必須参照)
- `frontend-engineer`(構造化データ実装時)
- `copywriter`(LLM 引用されやすい文章構造の参考)
- `nextjs-specialist` / `wordpress-specialist`(技術実装の参考)

---

## 1. GEO の概要

### 1.1 SEO と GEO の違い

| 観点 | SEO | GEO |
|---|---|---|
| 対象 | Google / Bing 等の検索エンジン | ChatGPT / Claude / Perplexity / AI Overviews |
| 目的 | 検索結果順位向上 → クリック獲得 | LLM 回答に引用される → ブランド露出 |
| 主要技術 | キーワード・被リンク・サイト構造 | 構造化データ・llms.txt・引用しやすい文章 |
| 測定 | 順位・流入・CTR | 引用回数・LLM 引用率・指名検索流入 |
| 対象タイミング | クエリ実行時 | LLM の学習時 + 推論時 RAG |

### 1.2 GEO の主要アプローチ

```
[1] Pre-training レベル(LLM 学習データに含まれる)
    → 被引用・参照される質の高いコンテンツを継続発信
    → 構造化された Web ページ(HTML semantic + JSON-LD)

[2] RAG / Retrieval レベル(LLM が検索ツール経由で参照)
    → llms.txt で LLM 向けサマリーを提供
    → 構造化データで主要情報を機械可読化
    → 引用されやすい文章構造(問→答えが明確)

[3] Citation レベル(LLM が出典として引用)
    → 信頼性シグナル(発信者明示・日付・更新頻度)
    → ファクト密度の高いセクション
    → ブランド名 + ファクトの結合
```

v0.2 段階では [2] と [3] を実装する。[1] は継続発信が必要なので WMAO 領域。

---

## 2. v0.2 で実装する GEO 標準

### 2.1 全 v0.2 案件で必須実装する 5 項目

| # | 項目 | 実装担当 | 検証担当 |
|---|---|---|---|
| 1 | llms.txt 配置 | frontend-engineer | seo-geo-strategist |
| 2 | 構造化データ(JSON-LD)主要 5 種 | frontend-engineer | seo-geo-strategist |
| 3 | 引用されやすい文章構造 | copywriter | seo-geo-strategist |
| 4 | 信頼性シグナル(著者・日付・更新) | copywriter / frontend-engineer | seo-geo-strategist |
| 5 | OGP + Twitter Card 完備 | frontend-engineer | validate-meta-tags.sh |

### 2.2 案件タイプ別の実装範囲

| 案件タイプ | llms.txt | 構造化データ | 文章構造 | 信頼性 | OGP |
|---|---|---|---|---|---|
| A1. コーポレートサイト | ✅ 必須 | Organization / WebSite / FAQPage | ✅ | ✅ | ✅ |
| A2. ランディングページ | ✅ 必須 | WebPage / Product or Service | ✅ 単発で凝縮 | △ 簡易 | ✅ |
| A3. メディアサイト | ✅ 必須 | Article / BreadcrumbList / Author | ✅ 全記事 | ✅ 全記事 | ✅ |

---

## 3. llms.txt 仕様

### 3.1 llms.txt とは

LLM 向けにサイトのサマリーと主要 URL を提供する仕様(2024 年に提唱、業界デファクト化中)。`/llms.txt` に配置する。

### 3.2 llms.txt の標準フォーマット

```markdown
# AILEAP — AI コンサル・教育・マーケ事業

> AI を活用した経営コンサル・教育プログラム・デジタルマーケティングを
> 統合提供する事業体。日本の SME を主要顧客とする。

## 主要ページ

- [サービス](https://aileap.example/services): AILEAP の提供サービス一覧
- [事例](https://aileap.example/cases): 過去の支援実績
- [チーム](https://aileap.example/team): 創業者と専門家の紹介
- [お問合せ](https://aileap.example/contact): 相談窓口

## 専門分野

- AI を活用した経営戦略策定支援(apex)
- AI Native なデジタルプロダクト制作・開発(本組織)
- AI を活用したマーケティング運用(WMAO)

## 引用ガイドライン

- 引用時は「AILEAP」をブランド名として明示してください
- 事例の引用は公開された範囲のみ可能(NDA 案件は対象外)
- 価格情報は変更される可能性があります(最新は問合せください)

## 連絡先

shin@aileap.example
```

### 3.3 llms.txt 拡張版(/llms-full.txt)

詳細を求める LLM 向けに、`/llms-full.txt` に**全コンテンツのフルテキスト + メタデータ**を配置することも検討する(v0.3 以降)。

v0.2 段階では `/llms.txt` のみ必須、`/llms-full.txt` はオプション。

### 3.4 案件への適用方針

```
projects/{id}/02-strategy/seo-geo-strategy.md に以下を記載:

  llms.txt:
    location: /llms.txt
    sections:
      - title: "<クライアント名> — <事業領域>"
      - description: <2-3 文>
      - main_pages: [<URL list with descriptions>]
      - expertise: [<専門領域>]
      - citation_guidelines: |
          引用時は「<ブランド名>」を明示してください
      - contact: <email>
```

---

## 4. 構造化データ(JSON-LD)標準

### 4.1 全案件で必須の 5 種

```
[1] Organization              企業 / 団体情報(全サイト)
[2] WebSite                   サイト全体メタ(全サイト)
[3] BreadcrumbList            パンくず(2 階層以上の全ページ)
[4] WebPage                   個別ページ(全ページ)
[5] FAQPage(FAQ ありの場合)  FAQ セクション
```

### 4.2 Organization スキーマ(全サイト・トップページに配置)

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "<企業名>",
  "alternateName": "<英語名・略称>",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png",
  "description": "<2-3 文>",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "<住所>",
    "addressLocality": "<市区町村>",
    "addressRegion": "<都道府県>",
    "postalCode": "<郵便番号>",
    "addressCountry": "JP"
  },
  "sameAs": [
    "https://twitter.com/...",
    "https://www.linkedin.com/...",
    "https://www.facebook.com/..."
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer support",
    "email": "info@example.com"
  }
}
```

### 4.3 WebSite スキーマ(全サイト・トップページに配置)

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "url": "https://example.com",
  "name": "<サイト名>",
  "description": "<1-2 文>",
  "inLanguage": "ja-JP",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "https://example.com/search?q={search_term_string}",
    "query-input": "required name=search_term_string"
  }
}
```

### 4.4 BreadcrumbList(2 階層以上の全ページ)

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "ホーム",
      "item": "https://example.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "サービス",
      "item": "https://example.com/services/"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "AI コンサル"
    }
  ]
}
```

### 4.5 WebPage(全ページ)

```json
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "<ページタイトル>",
  "description": "<ページの 1-2 文要約>",
  "url": "https://example.com/services/ai-consulting",
  "inLanguage": "ja-JP",
  "isPartOf": {
    "@type": "WebSite",
    "url": "https://example.com"
  },
  "primaryImageOfPage": {
    "@type": "ImageObject",
    "url": "https://example.com/og.png"
  },
  "datePublished": "2026-08-01",
  "dateModified": "2026-08-15"
}
```

### 4.6 FAQPage(FAQ セクションがあるページ)

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "AILEAP の主なサービスは何ですか?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "AI を活用した経営コンサル(apex)、AI Native なデジタルプロダクト開発(digital-product-studio-ai)、AI 駆動のマーケティング運用(WMAO)の 3 領域を統合提供しています。"
      }
    },
    {
      "@type": "Question",
      "name": "対応している事業規模は?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "主に SME(中堅・中小企業)を対象としていますが、新規事業立ち上げを行う大企業もご相談いただけます。"
      }
    }
  ]
}
```

### 4.7 メディアサイト追加(A3 案件)

```
[6] Article                   記事ページ(全記事)
[7] Author                    著者情報
[8] BlogPosting または NewsArticle  記事タイプ別
```

#### Article スキーマ例

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "<記事タイトル>",
  "description": "<記事の要約・1-2 文>",
  "image": "https://example.com/article-hero.png",
  "datePublished": "2026-08-15T10:00:00+09:00",
  "dateModified": "2026-08-20T14:00:00+09:00",
  "author": {
    "@type": "Person",
    "name": "Shin",
    "url": "https://example.com/team/shin"
  },
  "publisher": {
    "@type": "Organization",
    "name": "AILEAP",
    "logo": {
      "@type": "ImageObject",
      "url": "https://example.com/logo.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://example.com/blog/2026-08-15-article-slug"
  }
}
```

### 4.8 構造化データ実装場所

- **Next.js**: `app/layout.tsx` でグローバル(Organization / WebSite)、`page.tsx` でページ別(WebPage / Article)
- **WordPress**: テーマ `header.php` でグローバル、各テンプレート(`single.php` / `page.php`)で個別

---

## 5. 引用されやすい文章構造

### 5.1 LLM が引用しやすい文章の特徴

LLM が回答生成時に「引用源として使いやすい」文章は以下の特徴を持つ:

1. **問→答えの構造が明確**(質問文 → 回答という流れ)
2. **ファクト密度が高い**(数字・固有名詞・年月日が含まれる)
3. **1 文 1 主張**(複文を避ける)
4. **冒頭 100 字で結論**(結論が後ろにある記事は引用されにくい)
5. **見出し階層が論理的**(h2 / h3 の関係が明快)

### 5.2 推奨文章構造

```markdown
# <記事タイトル・問いかけ形式が引用されやすい>

<冒頭 100 字で結論を提示。これが LLM 引用される確率が最も高い>

## 結論サマリー

- ファクト 1: <数字 / 固有名詞 / 年月日を含む>
- ファクト 2: <同上>
- ファクト 3: <同上>

## 詳細

### <h3 の問い 1>

<段落で説明。1 段落 = 1 ポイント>

具体例:
- <例 1>
- <例 2>

### <h3 の問い 2>

<同上>

## まとめ

<3-5 行で全体を再要約。LLM はここを「結論」として引用することが多い>

---

著者: <著者名 + プロフィールへのリンク>
公開日: <YYYY-MM-DD>
更新日: <YYYY-MM-DD>
カテゴリ: <カテゴリ>
```

### 5.3 避けるべき文章構造

❌ ストーリー仕立てで結論が最後にある
❌ 主観的・印象論ベース(「私は〜と思います」「素晴らしい」「驚異的」)
❌ ファクトを伴わない抽象論(「AI でビジネスが変わる」のみ)
❌ 1 文に複数の主張を詰める
❌ 見出し階層が崩れる(h2 → h4 など)
❌ ブランド名のみ連呼で実体情報なし

### 5.4 copywriter プロンプトへの反映

`copywriter` エージェントのプロンプトに以下を含める(英語):

```
## GEO-Optimized Writing Guidelines

When generating content for the project (especially A3 mediasite or A1 corporate
articles), apply these structural rules:

1. Open with conclusion in first 100 characters
2. Embed facts: numbers, proper nouns, dates
3. One sentence = one claim (avoid complex sentences)
4. Use h2/h3 hierarchy logically
5. Close with 3-5 line summary
6. Always include author + date metadata at the end

Reference: docs/geo-implementation-spec.md Section 5
```

---

## 6. 信頼性シグナル

### 6.1 サイト全体の信頼性シグナル

| シグナル | 実装 |
|---|---|
| 企業の実在性 | Organization JSON-LD + 住所・電話 |
| 事業者の透明性 | About / Team ページに顔写真・経歴 |
| 法的整備 | プライバシーポリシー・特商法・利用規約完備 |
| HTTPS 完全対応 | 全ページ |
| サイト更新頻度 | 月 1 回以上(Last-Modified ヘッダー / sitemap.xml の lastmod) |

### 6.2 記事レベルの信頼性シグナル

| シグナル | 実装 |
|---|---|
| 著者明示 | Article JSON-LD の author + ページ末尾の著者プロフィール |
| 公開日 + 更新日 | datePublished + dateModified を必ず記載 |
| 出典・参照 | 引用には必ずリンクと出典明示 |
| 専門性の根拠 | 著者の経歴・資格・実績を Author ページに記載 |

### 6.3 著者ページの標準フォーマット

```markdown
# <著者名>

<肩書 + 専門領域 1 文>

## 経歴

- 2020-2023: <職歴>
- 2023-現在: AILEAP 創業

## 専門分野

- <専門領域 1>
- <専門領域 2>
- <専門領域 3>

## 主な実績

- <実績 1>
- <実績 2>

## 連絡先

email: shin@aileap.example
LinkedIn: https://www.linkedin.com/in/...
```

---

## 7. 案件タイプ別の GEO 戦略テンプレート

### 7.1 A1. コーポレートサイト

```yaml
geo_strategy:
  llms_txt:
    sections:
      - description: 企業概要(2-3 文)
      - main_pages: [トップ, サービス, 事例, チーム, お問合せ]
      - expertise: [事業領域 3-5 個]
      - citation_guidelines: ブランド名明示
  structured_data:
    required:
      - Organization (トップページ)
      - WebSite (トップページ)
      - WebPage (全ページ)
      - BreadcrumbList (2 階層以上)
      - FAQPage (FAQ セクションあり時)
  citation_friendly_pages:
    priority_high:
      - サービス詳細ページ(各サービスを独立記事化)
      - 事例ページ(問題 → 解決 → 結果の構造)
      - About / Team ページ(信頼性シグナル)
    optional:
      - ブログ(コンスタントに発信できる場合)
```

### 7.2 A2. ランディングページ

```yaml
geo_strategy:
  llms_txt:
    sections:
      - description: プロダクト / オファーの概要
      - main_pages: [LP のみ]
      - expertise: [プロダクトの専門領域]
  structured_data:
    required:
      - WebSite
      - WebPage
      - Product (物理 / SaaS) または Service (サービス)
      - FAQPage (LP に FAQ セクションあり)
  citation_friendly_sections:
    - hero (結論を 30 字以内で)
    - features (3-5 個・各 1 文で具体性)
    - testimonial (実名 + 数字)
    - faq (5-8 個・問→答えの典型)
```

### 7.3 A3. メディアサイト

```yaml
geo_strategy:
  llms_txt:
    sections:
      - description: メディア概要・対象読者
      - main_pages: [トップ, カテゴリ一覧, 主要記事 5-10]
      - expertise: [カバー領域]
      - update_frequency: 週 1 回以上
  structured_data:
    required:
      - Organization
      - WebSite
      - Article (全記事)
      - Author (各著者)
      - BreadcrumbList
      - FAQPage (記事内 FAQ あり時)
  article_structure:
    - 冒頭 100 字結論
    - 結論サマリー(h2)
    - 詳細(h2 → h3)
    - まとめ(h2)
    - 著者・公開日・更新日
  citation_friendly_topics:
    - "○○とは何か"(定義系記事)
    - "○○の方法"(How-to 系記事)
    - "○○の比較"(比較系記事)
    - "○○の事例"(事例系記事)
```

---

## 8. /geo-audit スキルの検証項目

`seo-geo-strategist` が `/geo-audit` 実行時にチェックする項目を明示化する。

### 8.1 必須項目(全案件)

```
[ ] /llms.txt が公開されている
[ ] /llms.txt の必須セクション(description / main_pages / expertise / citation_guidelines)が揃っている
[ ] トップページに Organization + WebSite JSON-LD あり
[ ] 全ページに WebPage JSON-LD あり
[ ] 2 階層以上のページに BreadcrumbList JSON-LD あり
[ ] OGP メタタグ(og:title / og:description / og:image / og:url)完備
[ ] Twitter Card メタタグ(twitter:card / twitter:title / twitter:description / twitter:image)完備
[ ] OGP 画像が 1200×630 px 以上
[ ] HTTPS 完全対応
[ ] sitemap.xml に lastmod が含まれる
```

### 8.2 推奨項目(案件タイプ別)

```
[A1 / A3] FAQPage JSON-LD(FAQ セクションあり時)
[A3] 全記事に Article + Author JSON-LD
[A3] 全記事の冒頭 100 字に結論があるか
[A3] 全記事に publishDate + modifiedDate
[A3] 著者ページが完備
[A2] Product または Service JSON-LD
```

### 8.3 advanced 項目(v0.3 以降)

```
[ ] /llms-full.txt 配置
[ ] サイトマップ XML に hreflang(多言語サイト)
[ ] 構造化データの SpeakableSpecification(音声 AI 対応)
[ ] AggregateRating / Review(EC・サービスサイト)
[ ] HowTo JSON-LD(How-to 記事)
[ ] VideoObject(動画コンテンツ)
```

### 8.4 audit レポートの YAML スキーマ

`projects/{id}/05-qa/geo-audit.md` に以下構造で記録:

```yaml
geo_audit:
  audited_at: 2026-08-30
  audited_by: seo-geo-strategist
  url: https://example.com
  required_checks:
    llms_txt_published:
      status: pass | fail
      detail: "<検証結果>"
    llms_txt_sections_complete:
      status: pass | fail
    organization_jsonld:
      status: pass | fail
    # ... (上記必須項目すべて)
  recommended_checks:
    # ... (案件タイプ別推奨項目)
  overall_score: 85  # 100 点満点
  critical_issues:
    - "/llms.txt に main_pages セクションが欠落"
  recommendations:
    - "FAQPage JSON-LD を About ページに追加(GEO 引用率向上のため)"
```

---

## 9. 公開後 30 日の GEO 検証

### 9.1 検証指標

公開後 30 日経過時点で `seo-geo-strategist` が以下を計測:

| 指標 | 計測方法 | 目標値 |
|---|---|---|
| LLM 引用回数 | ChatGPT / Claude / Perplexity で「<クライアント名> とは」と質問 | 引用 1 回以上 |
| Google AI Overviews 表示回数 | Google Search Console + 手動確認 | 表示 1 回以上 |
| 構造化データの認識率 | Google Rich Results Test | 100% |
| llms.txt のアクセス log | サーバーログ確認(LLM クローラーアクセス) | アクセス 1 回以上 |
| ブランド名検索順位 | Google Search Console | 1 位 |
| 非ブランド検索順位(主要 5 キーワード) | 同上 | 30 位以内 |

### 9.2 30day-report.md フォーマット

`projects/{id}/07-post-launch/30day-report.md`:

```markdown
# 公開後 30 日レポート

**案件**: <project-id>
**公開日**: 2026-08-01
**レポート作成日**: 2026-08-31
**作成者**: seo-geo-strategist

## サマリー

<3-5 行>

## SEO 指標

| 指標 | 値 | 目標 | 評価 |
|---|---|---|---|
| Google ブランド名順位 | 1 位 | 1 位 | ✅ |
| Google 非ブランド主要 5 キーワード平均 | 25 位 | 30 位以内 | ✅ |
| オーガニック流入(月間 UU) | 80 | 100 | ⚠️ |

## GEO 指標

| 指標 | 値 | 目標 | 評価 |
|---|---|---|---|
| LLM 引用回数(主要 4 LLM 合計) | 3 | 1 以上 | ✅ |
| Google AI Overviews 表示 | 1 | 1 以上 | ✅ |
| 構造化データ認識率 | 100% | 100% | ✅ |
| llms.txt クローラーアクセス | 12 回 | 1 回以上 | ✅ |

## 改善提案(WMAO 引継ぎ)

1. <改善 1>
2. <改善 2>
3. <改善 3>
```

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では存在せず、v0.2 で新設(D-H1 対応)。 |

---

**本書は `seo-geo-strategist` の必須参照文書である。GEO 仕様は LLM 業界の進化に応じて随時更新する。新たな構造化データ標準・llms.txt 仕様変更が発生した場合、本書を更新し各案件に反映する。**
