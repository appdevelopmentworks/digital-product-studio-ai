# 多言語(i18n)戦略 — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-05-01
**作成者**: localization-specialist(seo-geo-strategist 補強・hreflang)
**ステータス**: 確認待ち(APV-001 内に含む / Phase H で正式承認)

> 本書は v0.3 Phase H で新規作成。Phase D では「枠のみ実装」の方針(DEC-002)だったが、
> v0.3 着手時の論点 4 で **主要 5 ページの en 化** が確定したため、本書で正式戦略を定義。

---

## 1. 多言語化スコープ

### 1.1 v0.3 段階のスコープ(本案件)

| 言語 | 対象ページ | 翻訳方針 |
|---|---|---|
| **ja(日本語)** | 全 11 ページ | プライマリ言語(全ページオリジナル) |
| **en(英語)** | **主要 5 ページのみ** | 翻訳パイプライン経由 + Shin native review |

**en 化対象 5 ページ**(論点 4 で確定):

1. `/` トップ
2. `/about` 会社概要
3. `/services` サービス一覧
4. `/works` 実績一覧
5. `/contact` お問い合わせ

### 1.2 en 化対象外(v0.4 以降に持ち越し)

- `/services/[slug]` サービス詳細(全 4 件)
- `/works/[slug]` 実績詳細
- `/blog/[slug]` 記事詳細
- `/blog` ブログ一覧
- `/careers` 採用情報(国内採用優先のため意図的に ja のみ)
- `/privacy` プライバシーポリシー(法務確認の二重コストを避ける)

これらは Phase 2(公開後 3-6 ヶ月)または v0.4 で en 化を検討。

### 1.3 中国語(zh) / 韓国語(ko)の扱い

requirements-v0.md で言及あったが、本案件では **対象外**。zh / ko は v0.4 以降の別案件または継続施策で検討。

---

## 2. URL 構造戦略

### 2.1 サブパス方式を採用

```
https://aileap.example/                      ← 日本語(デフォルト・x-default)
https://aileap.example/en/                   ← 英語

https://aileap.example/about                 ← 日本語(/ja/about ではなく path-prefix なし)
https://aileap.example/en/about              ← 英語
```

**採用理由**:
- 単一ドメインで SEO 評価を集約(複数ドメインに分散しない)
- Vercel + Next.js で簡単に実装可能(next-intl の routing API)
- 将来 zh / ko 追加時もスケール可能(`/zh/` `/ko/`)

**検討した代替案**:
- ❌ サブドメイン(`en.aileap.example`):SEO 評価が分散 + DNS 管理コスト
- ❌ ドメイン分け(`aileap.com` / `aileap.us`):同上 + ブランド一貫性低下
- ❌ クエリパラメータ(`?lang=en`):検索エンジンに解釈されにくい

### 2.2 デフォルト言語の判定

```typescript
// middleware.ts(Next.js App Router)
import { match } from '@formatjs/intl-localematcher';
import Negotiator from 'negotiator';

const locales = ['ja', 'en'];
const defaultLocale = 'ja';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // path に既に locale prefix があるならそのまま
  if (pathname.startsWith('/en/') || pathname === '/en') return;

  // Accept-Language ヘッダから判定 → en preference なら /en/ へリダイレクト
  // それ以外(日本語環境含む)は ja で配信
  const headers = { 'accept-language': request.headers.get('accept-language') ?? '' };
  const languages = new Negotiator({ headers }).languages();
  const locale = match(languages, locales, defaultLocale);

  if (locale === 'en') {
    return NextResponse.redirect(new URL(`/en${pathname}`, request.url));
  }
  // ja の場合はリダイレクトなし(path-prefix なしで配信)
}
```

**注意**: Cookie で「ユーザー手動選択」を覚えた場合は Accept-Language より優先する。

---

## 3. hreflang 戦略(SEO 観点)

### 3.1 全 en 化ページに hreflang 配置

各ページの `<head>` に以下を追加:

```html
<!-- /(ja トップ) -->
<link rel="alternate" hreflang="ja" href="https://aileap.example/" />
<link rel="alternate" hreflang="en" href="https://aileap.example/en/" />
<link rel="alternate" hreflang="x-default" href="https://aileap.example/" />

<!-- /about(ja) -->
<link rel="alternate" hreflang="ja" href="https://aileap.example/about" />
<link rel="alternate" hreflang="en" href="https://aileap.example/en/about" />
<link rel="alternate" hreflang="x-default" href="https://aileap.example/about" />
```

### 3.2 en のみ存在しないページの扱い

`/services/[slug]`, `/blog/[slug]`, `/careers`, `/privacy` は ja のみ。これらのページでは hreflang を **配置しない**(en バリアントが存在しないため)。

### 3.3 sitemap.xml で hreflang 表現

```xml
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <url>
    <loc>https://aileap.example/</loc>
    <xhtml:link rel="alternate" hreflang="ja" href="https://aileap.example/" />
    <xhtml:link rel="alternate" hreflang="en" href="https://aileap.example/en/" />
    <xhtml:link rel="alternate" hreflang="x-default" href="https://aileap.example/" />
  </url>
  <!-- 他 4 ページ同様 -->
</urlset>
```

---

## 4. 翻訳パイプライン

### 4.1 機械翻訳 → AI レビュー → ネイティブ最終確認の 3 段階

```
[Step 1: 機械翻訳]
  copywriter が ja コピーを確定 → DeepL API で en へ翻訳

[Step 2: AI レビュー]
  Claude(Sonnet 4.6)で「自然な英語 + ビジネスクラスの語彙 + AILEAP の tone of voice 維持」を
  プロンプトベースでレビュー。違和感のある表現を修正。

[Step 3: ネイティブ最終確認]
  Shin(英語高度話者)が最終レビュー。文化的差異・業界用語の妥当性を確認。

[Step 4: コミット]
  確定した en コピーを `messages/en.json` または対応する .mdx ファイルにコミット。
```

### 4.2 翻訳辞書の整備

固有名詞・ブランド用語の翻訳ルール:

| ja | en | 確定 |
|---|---|---|
| 株式会社 AILEAP | AILEAP Inc. | ✅ |
| 中堅企業 | mid-sized enterprises(SME ではなく) | ✅(SME は誤訳になりやすい) |
| AI Native 制作会社 | AI-native digital studio | ✅ |
| 同等品質を半額 | Same quality at half the price | ✅ |
| 3 組織アーキテクチャ | three-organization architecture | ✅ |
| コーポレートサイト | corporate website | ✅(corporate site も可) |
| ランディングページ | landing page | ✅ |
| メディアサイト | content media site / owned media | (検討中) |
| Retainer | Retainer (そのまま) | ✅(契約用語) |
| GEO(生成 AI 最適化) | GEO (Generative Engine Optimization) | ✅ |
| WCAG 2.2 AA | WCAG 2.2 Level AA | ✅ |
| llms.txt | llms.txt(そのまま) | ✅ |

辞書は `02-strategy/translation-glossary.yaml`(任意)に保存し、翻訳パイプラインで参照。

### 4.3 トーン・ボイス維持

ja のトーン(信頼感・先進性・親しみやすさ・誠実さ)を en で維持するためのガイドライン:

- 過剰なカタカナ表現を避ける(en では英語そのものなので問題ないが、語彙レベルの一貫性を保つ)
- 「~でしょう」「~ます」の丁寧語の英語訳: 過剰な politeness ではなく、professional neutral
- ブランド主語: 「AILEAP は」 → 「AILEAP」 / 「We at AILEAP」(過剰な one)を避ける
- 数字の表記: ja では「30 件」、en では「30 inquiries」(数字 + 単位を必ずペアで)

---

## 5. UI 言語切替

### 5.1 言語切替コンポーネント

```typescript
// src/components/molecules/LanguageSwitcher.tsx
// グローバルナビゲーション右端に配置

[JA / EN]   ← 現在 ja の場合は「JA」が active
            ← クリックで /en/{現在パス} or /{現在パス} にリダイレクト
```

仕様:
- 言語切替時は **同等ページ間で遷移**(`/about` → `/en/about`)
- en で存在しないページ(`/services/[slug]` 等)では 切替時に `/en/` トップへリダイレクト + トースト「This page is only available in Japanese」を表示
- 切替 を Cookie に保存(`NEXT_LOCALE=en`)し、次回訪問時に優先

### 5.2 アクセシビリティ

- 言語切替リンクには `hreflang="en"` または `hreflang="ja"` を必ず付与
- `aria-label="Switch to English"` / `aria-label="日本語に切り替え"` を付与
- 視覚的に「現在の言語」が分かる(active state)

---

## 6. 翻訳ファイル構造

### 6.1 next-intl 構造

```
messages/
├── ja.json       ← 日本語(プライマリ)
└── en.json       ← 英語(主要 5 ページ分のみ)
```

### 6.2 名前空間分割

```json
// messages/ja.json
{
  "common": {
    "site_name": "AILEAP",
    "cta_contact": "お問い合わせ",
    "cta_services": "サービスを見る",
    "nav.services": "サービス",
    "nav.works": "実績",
    "nav.blog": "ブログ",
    "nav.about": "会社情報",
    "nav.careers": "採用情報",
    "nav.contact": "お問い合わせ"
  },
  "home": {
    "hero.title": "AI Native の Web 制作スタジオ",
    "hero.subtitle": "経営戦略 → Web 制作 → マーケ運用を一気通貫"
  },
  "about": { /* ... */ },
  "services": { /* ... */ },
  "works": { /* ... */ },
  "contact": { /* ... */ }
}
```

```json
// messages/en.json
{
  "common": {
    "site_name": "AILEAP",
    "cta_contact": "Contact us",
    "cta_services": "View services",
    "nav.services": "Services",
    "nav.works": "Works",
    "nav.blog": "Blog",
    "nav.about": "About",
    "nav.careers": "Careers",
    "nav.contact": "Contact"
  },
  "home": {
    "hero.title": "AI-native digital studio",
    "hero.subtitle": "End-to-end: Strategy → Web → Marketing"
  },
  "about": { /* ... */ },
  "services": { /* ... */ },
  "works": { /* ... */ },
  "contact": { /* ... */ }
}
```

### 6.3 ja のみのページの扱い

`/services/[slug]` 等は `messages/en.json` に該当キーを置かない。コンポーネント側で fallback ロジックを実装し、英語キーが存在しない場合は ja で配信。

---

## 7. ロケール固有要素

### 7.1 日付表記

| ロケール | フォーマット | 例 |
|---|---|---|
| ja | YYYY-MM-DD または YYYY 年 MM 月 DD 日 | 2026-06-15 / 2026 年 6 月 15 日 |
| en | MMMM D, YYYY または D MMMM YYYY | June 15, 2026 |

実装: `Intl.DateTimeFormat` で自動切替。

### 7.2 数字表記

| ロケール | 千の区切り | 小数点 | 例 |
|---|---|---|---|
| ja | カンマ | ピリオド | 1,000 / 3.14 |
| en | カンマ | ピリオド | 1,000 / 3.14 |

(実用上の差はほぼない。`Intl.NumberFormat` で扱う)

### 7.3 通貨表記

通貨表示はサイト本文に登場(価格レンジ等):

| ロケール | 表記例 |
|---|---|
| ja | 50-150 万円(税抜) |
| en | JPY 500,000 - 1,500,000 (excl. tax) / approx. USD 3,500 - 10,500 |

en では JPY 表記 + 参考 USD 換算を併記(2026-05 時点 USD/JPY = 145 を仮定)。

### 7.4 法務表記

`/privacy` は ja のみ(法務確認は弁護士が ja のみ確認)。en 化は v0.4 以降に弁護士確認を再実施してから。

---

## 8. SEO 観点の言語対応

### 8.1 個別ページの og:locale

```html
<!-- ja ページ -->
<meta property="og:locale" content="ja_JP" />
<meta property="og:locale:alternate" content="en_US" />

<!-- en ページ -->
<meta property="og:locale" content="en_US" />
<meta property="og:locale:alternate" content="ja_JP" />
```

### 8.2 構造化データ(JSON-LD)の言語属性

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "AILEAP",
  "url": "https://aileap.example",
  "inLanguage": ["ja", "en"]
}
```

### 8.3 GEO 観点

llms.txt は ja 版のみ(`/llms.txt`)を v0.3 では配置。en 版(`/en/llms.txt`)は v0.4 以降。

---

## 9. ローカライゼーション工数

### 9.1 内部見積(commercial-manager 内部 mode)

| タスク | 工数 |
|---|---|
| 翻訳辞書整備 | 3h |
| DeepL 機械翻訳(5 ページ × 平均 1500 字) | 1h |
| Claude AI レビュー(5 ページ) | 4h |
| Shin ネイティブ最終確認(5 ページ) | 5h |
| next-intl 実装(routing + components) | 8h |
| hreflang + sitemap 多言語対応 | 3h |
| 言語切替 UI 実装 | 4h |
| QA(en での動作確認) | 4h |
| **合計** | **32h** |

### 9.2 公開後の継続コスト

en コピー更新時:
- ja 更新 → DeepL → Claude レビュー → Shin 確認 → en 確定
- 1 ページの更新で平均 2-3h

WMAO 引継ぎ後は WMAO が継続更新するか、Shin が引き続きネイティブ確認するかは Phase 5 / Retainer 契約で確定。

---

## 10. 公開後の継続改善

### 10.1 30 日後の検証

- en ページのインデックス状況(GSC で en URL 別)
- en 経由のオーガニック流入(GA4 ロケール別レポート)
- LLM 引用クエリで en クエリの引用検出

### 10.2 v0.4 で en 化拡張の判断材料

- en ページの流入が ja の 5% 以上なら投資価値あり → サービス詳細・記事の en 化を v0.4 に提案
- en 流入が極小なら現状維持

---

## 11. WMAO 引継ぎ事項

WMAO に渡す i18n 領域の運用情報:

- 本書の最新版
- 翻訳辞書(`translation-glossary.yaml`)
- next-intl 設定ドキュメント
- en コピー更新フローの SOP
- 30 日レポートでの en 領域の KPI

---

## 12. 改訂履歴

| 版 | 日付 | 主な変更 |
|---|---|---|
| 1.0 | 2026-05-01 | 初版。v0.3 Phase H で新規作成。主要 5 ページ en 化の正式戦略確定。 |

---

**Document Owner**: localization-specialist
**Last Updated**: 2026-05-01
**Version**: 1.0
**承認 ID**: APV-001 内に含む(Phase H で承認)
