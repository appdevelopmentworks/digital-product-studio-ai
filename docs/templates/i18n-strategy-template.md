# 多言語戦略テンプレート（i18n Strategy）

**用途**: 多言語サイトの言語スコープ・URL 構造・翻訳パイプライン・hreflang 計画を定義
**配置先**: `projects/<project_id>/02-strategy/i18n-strategy.md`
**主担当**: `localization-specialist`（Q5 priority、v0.2 で前倒し）
**スキル**: `/i18n-strategy`
**言語層**: Layer 1（クライアント向け日本語）
**対応言語**: JA / EN / ZH / KO（v0.2 標準）

---

## 使い方

1. 案件の `target_languages` が `[ja]` 以外を含む場合に作成
2. 翻訳パイプラインを DeepL / Claude / GPT-4 + 必要時に Shin のネイティブレビュー
3. JA/EN/ZH/KO は Shin のネイティブレビュー対応可能
4. 公開前に hreflang 検証必須

---

## テンプレート本体

```markdown
# 多言語戦略

**案件**: <<株式会社サンプル コーポレートサイト>>
**案件 ID**: <<AXYZ-20260601-001>>
**版**: 1.0
**作成日**: <<YYYY-MM-DD>>
**作成者**: digital-product-studio-ai / localization-specialist
**ステータス**: 確認待ち / 承認済

---

## 1. 言語スコープ

### 1.1 対象言語

| 言語 | コード（BCP-47）| ロケール | 優先度 | ネイティブレビュー |
|---|---|---|---|---|
| 日本語 | ja | ja_JP | プライマリ | Shin |
| 英語 | en | en_US | セカンダリ | Shin |
| <<中国語>> | <<zh>> | <<zh_CN>> | <<検討中>> | Shin |
| <<韓国語>> | <<ko>> | <<ko_KR>> | <<検討中>> | Shin |

**注**: Shin は JA/EN/ZH/KO のネイティブレビュー可能。これ以外の言語が必要な場合は外部翻訳者の追加見積。

### 1.2 言語別ターゲット

| 言語 | 想定ユーザー | 主要マーケット | コンテンツ深度 |
|---|---|---|---|
| ja | 日本国内顧客 | 日本 | フルセット |
| en | 海外顧客（北米・欧州・アジア英語圏） | 米英・グローバル | フルセット |
| zh | 中国本土・台湾・香港 | <<中国本土 / 繁体>> | 主要ページのみ |
| ko | 韓国 | 韓国 | 主要ページのみ |

### 1.3 言語別スコープ

| ページ種別 | ja | en | zh | ko |
|---|---|---|---|---|
| トップ | ✅ | ✅ | ✅ | ✅ |
| 会社概要 | ✅ | ✅ | ✅ | ✅ |
| サービス一覧 | ✅ | ✅ | ✅ | ✅ |
| サービス詳細 | ✅ | ✅ | ✅ | △（一部のみ）|
| 実績 | ✅ | ✅ | △ | ❌ |
| 採用 | ✅ | △（英語のみ）| ❌ | ❌ |
| 記事 | ✅ | △（厳選翻訳）| ❌ | ❌ |
| お問い合わせ | ✅ | ✅ | ✅ | ✅ |
| プライバシーポリシー | ✅ | ✅ | ✅ | ✅ |

---

## 2. URL 構造

### 2.1 URL パターン: パス型（推奨）

```
https://example.com/         → 自動言語判定 → リダイレクト
https://example.com/ja/      → 日本語
https://example.com/en/      → 英語
https://example.com/zh/      → 中国語
https://example.com/ko/      → 韓国語
```

#### 採用理由

- SEO で言語別の検索エンジンインデックスが期待できる
- hreflang 設定が直感的
- ユーザーが URL から言語を判別できる
- サーバー設定がシンプル

### 2.2 URL パターン: サブドメイン型（非推奨）

```
ja.example.com / en.example.com / zh.example.com
```

採用しない理由: SSL 証明書管理の複雑化、SEO ドメイン分散リスク。

### 2.3 URL パターン: ccTLD 型（非推奨）

```
example.jp / example.com（en） / example.cn
```

採用しない理由: 各国 ccTLD の取得コスト・管理工数の増加。

### 2.4 ルートアクセスの挙動

```
https://example.com/  への直接アクセス時:

1. Cookie に lang_pref があれば → /<lang>/ にリダイレクト
2. Accept-Language ヘッダーで自動判定 → /<lang>/ にリダイレクト
3. 判定不能 → デフォルト /ja/ にリダイレクト
4. ユーザーが手動切替したら Cookie に保存（30日有効）
```

⚠️ **404 / 503 ページ**: 言語切替前提のため `/ja/404` `/en/404` 等を用意。

---

## 3. hreflang 設定

### 3.1 全ページに必須

各ページの `<head>` に以下を追加:

```html
<link rel="alternate" hreflang="ja"      href="https://example.com/ja/services" />
<link rel="alternate" hreflang="en"      href="https://example.com/en/services" />
<link rel="alternate" hreflang="zh-Hans" href="https://example.com/zh/services" />
<link rel="alternate" hreflang="ko"      href="https://example.com/ko/services" />
<link rel="alternate" hreflang="x-default" href="https://example.com/ja/services" />
```

### 3.2 注意点

- `hreflang="zh-Hans"`（簡体字）または `zh-Hant`（繁体字）を区別する場合は両方記載
- `x-default` には デフォルト言語を指定（通常 ja）
- 自分自身の言語にも hreflang を含める（自己参照）
- 各言語版は **同じ** hreflang セットを持つ（双方向リンク）

### 3.3 sitemap.xml への追加

```xml
<url>
  <loc>https://example.com/ja/services</loc>
  <xhtml:link rel="alternate" hreflang="ja" href="https://example.com/ja/services" />
  <xhtml:link rel="alternate" hreflang="en" href="https://example.com/en/services" />
  <xhtml:link rel="alternate" hreflang="zh-Hans" href="https://example.com/zh/services" />
  <xhtml:link rel="alternate" hreflang="ko" href="https://example.com/ko/services" />
</url>
```

---

## 4. 翻訳パイプライン

### 4.1 翻訳プロセス（推奨フロー）

```
1. 日本語原稿（copywriter / クライアント）
   ↓
2. 機械翻訳（DeepL / Claude / GPT-4）
   ↓
3. 文脈調整（localization-specialist）
   ↓
4. ネイティブレビュー（Shin）  ★ JA→EN/ZH/KO の場合
   ↓
5. クライアント確認
   ↓
6. CMS 反映 / 公開
```

### 4.2 翻訳エンジンの使い分け

| エンジン | 強み | 弱み | 主用途 |
|---|---|---|---|
| DeepL | 自然な翻訳、ビジネス文書 | 文脈解釈は弱い | 契約・ビジネス文書 |
| Claude | 文脈理解、ニュアンス保持 | コスト | マーケティングコピー |
| GPT-4 | 多言語対応広い | 表現に揺れ | 補助的に使用 |
| Google 翻訳 | 速度、無料 | 品質低 | 一次下書きのみ |

### 4.3 翻訳コスト（参考）

| パターン | 1ページあたり工数（時間）| 単価例 |
|---|---|---|
| 機械翻訳のみ | 0.5 | 5,000 円 |
| 機械翻訳 + ネイティブ調整 | 1.5 | 15,000 円 |
| 全文ネイティブ翻訳 | 3 | 30,000 円 |

クライアント案件では **機械翻訳 + ネイティブ調整** を標準とする。

### 4.4 翻訳後の最終チェック項目

- [ ] 用語統一（「お客様」「貴社」「Customer」「Client」など）
- [ ] 数字・固有名詞の正確性
- [ ] 文化的配慮（祝日・祭り名・タブー）
- [ ] 通貨・単位（JPY / USD / EUR、メートル / ヤード等）
- [ ] 連絡先（電話番号書式 +81-3-XXXX）
- [ ] 法務文言の正確性（弁護士確認必要時は別パス）

### 4.5 自動翻訳の禁止対象

以下は機械翻訳のみでの公開を禁止:

- 法務ページ（プライバシーポリシー / 特商法 / 利用規約）
- 契約条文
- 重要な顧客向け案内（料金・SLA 等）

これらは必ずネイティブレビュー + 弁護士確認（必要時）。

---

## 5. 技術実装

### 5.1 Next.js（App Router）の場合

```typescript
// app/[locale]/layout.tsx
import { NextIntlClientProvider } from 'next-intl';

export default async function LocaleLayout({
  children,
  params: { locale }
}: { children: React.ReactNode; params: { locale: string } }) {
  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider locale={locale} messages={...}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
```

ファイル構成:
```
messages/
  ja.json
  en.json
  zh.json
  ko.json
app/
  [locale]/
    page.tsx
    services/
      page.tsx
```

### 5.2 Astro の場合

```astro
---
// src/pages/[lang]/index.astro
import { getCollection } from 'astro:content';
const { lang } = Astro.params;
---
<html lang={lang}>
  <head>
    <link rel="alternate" hreflang={lang} href={`https://example.com/${lang}/`} />
    {/* 他の言語の hreflang */}
  </head>
</html>
```

### 5.3 WordPress（Polylang / WPML）の場合

- Polylang: 無料・標準的、軽量。中小規模に推奨
- WPML: 有料、機能豊富。大規模に推奨

設定:
```
1. 言語追加（Languages: 日本語・英語・中国語・韓国語）
2. 投稿タイプごとに翻訳可否設定
3. 翻訳ページの URL 構造を設定（/ja/ /en/）
4. 言語切替ウィジェットを配置
```

### 5.4 ロケールデータの取扱い

| 項目 | 設定例 |
|---|---|
| 日付フォーマット | ja: `YYYY/MM/DD`、 en: `MMM DD, YYYY` |
| 時刻フォーマット | ja: 24h、 en: 12h |
| 通貨 | ja: ¥, en: $/€, zh: ¥, ko: ₩ |
| 数値区切り | ja/en: 1,000,000、 一部欧州: 1.000.000 |
| 名前順序 | ja: 姓-名、 en/zh/ko: 名-姓（ただし zh/ko も姓-名のケース多）|

---

## 6. SEO/GEO の言語別対応

### 6.1 言語別 OG タグ

```html
<meta property="og:locale" content="ja_JP" />
<meta property="og:locale:alternate" content="en_US" />
<meta property="og:locale:alternate" content="zh_CN" />
<meta property="og:locale:alternate" content="ko_KR" />
```

### 6.2 言語別 OG 画像

可能であれば言語ごとに OG 画像を分ける（タイトル文字が言語別）:

```
https://example.com/og/ja/services.png
https://example.com/og/en/services.png
```

### 6.3 言語別 llms.txt

```
/llms.txt          ← デフォルト（日本語）
/llms-en.txt       ← 英語版
/llms-zh.txt       ← 中国語版
```

### 6.4 構造化データの言語

`inLanguage` フィールドを必ず設定:

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "inLanguage": "ja",
  "headline": "..."
}
```

### 6.5 言語切替UIのSEO配慮

- 言語切替リンクは `<a href>` で実装（JS 切替のみだとクローラー追跡不可）
- 言語アイコンと言語名（自国語表記）を併用: 「日本語 / English / 中文 / 한국어」

---

## 7. CMS / 運用上の留意

### 7.1 翻訳メモリ（Translation Memory）

長期運用案件は翻訳メモリを構築:

- DeepL Pro / Phrase TMS / Crowdin 等
- 用語集（Glossary）を作成し用語ぶれを防止
- 同じ文の翻訳を再利用（コスト削減）

### 7.2 用語集（Glossary）の例

| 日本語 | 英語 | 中国語 | 韓国語 |
|---|---|---|---|
| お問い合わせ | Contact | 联系我们 | 문의하기 |
| 会社概要 | About | 关于我们 | 회사소개 |
| 採用情報 | Careers | 招聘信息 | 채용정보 |
| サービス | Services | 服务 | 서비스 |
| 資料請求 | Request Documents | 资料申请 | 자료 요청 |

### 7.3 翻訳のバージョン管理

- メインコンテンツ更新時、翻訳版の更新ステータスを追跡
- 「Stale 翻訳」（原文だけ更新済）を可視化
- WMAO への引継ぎ時に「翻訳メンテナンス計画」を含める

---

## 8. アクセシビリティとi18n

### 8.1 文字方向

- ja/en/zh/ko: LTR（左から右）→ 標準実装で問題なし
- アラビア語・ヘブライ語が将来加わる場合: RTL 対応必要（v0.2 では対象外）

### 8.2 文字長の差

英語は日本語より長くなりがち。レイアウト崩れチェック:

| 言語 | 同内容の文字長比率（vs JA）|
|---|---|
| ja | 1.0 |
| en | 1.5-2.0 |
| zh | 0.7-0.9 |
| ko | 1.0-1.2 |

ボタン文言・ナビゲーション・ヘッダーは英語版が長くなる可能性を見込んだレイアウト。

### 8.3 言語属性

```html
<html lang="ja">
<p lang="en">English snippet within Japanese text</p>
```

スクリーンリーダーが正しい発音で読み上げる。

---

## 9. 確認事項

### 9.1 クライアント様への確認依頼

- [ ] 対応言語スコープが事業計画と整合（特に zh/ko の要否）
- [ ] 言語別ページスコープ（記事翻訳の範囲等）
- [ ] URL 構造（パス型推奨）への合意
- [ ] 翻訳コストの想定（標準: 機械翻訳 + ネイティブ調整）
- [ ] 法務ページの翻訳要否（必要時は弁護士確認別途）

---

## 10. 別添

- `sitemap.md` — 言語別ページ構成
- `content-strategy.md` — コンテンツ戦略
- `design-system.md` — レイアウト・タイポ設計
- 用語集（別添 CSV）

---

**Document Owner**: digital-product-studio-ai / localization-specialist
**Last Updated**: <<YYYY-MM-DD>>
**Version**: 1.0
```

---

## チェックリスト

- [ ] 対象言語を BCP-47 コードで明記（ja, en, zh, ko 等）
- [ ] URL 構造はパス型（推奨）
- [ ] 全ページに hreflang 設定
- [ ] hreflang セットは全言語版で同一（自己参照含む）
- [ ] x-default を設定（デフォルト ja）
- [ ] 法務ページは機械翻訳のみで公開禁止
- [ ] ネイティブレビュー（Shin が JA/EN/ZH/KO 担当）の工程明記
- [ ] 用語集を作成
- [ ] OG タグの `og:locale:alternate` 設定
- [ ] 構造化データに `inLanguage` を設定
- [ ] CMS の翻訳プラグイン選定が完了

---

## よくある間違い

| 誤り | 正しい書き方 |
|---|---|
| サブドメイン型を選択 | パス型（`/ja/` `/en/`）が標準 |
| hreflang の自己参照を入れない | 自己参照含めて全言語分記載 |
| `x-default` 未設定 | 必ず設定（デフォルト ja） |
| 法務ページを機械翻訳で公開 | ネイティブレビュー + 弁護士確認 |
| 文字長の差を考慮しないレイアウト | 英語版で 1.5-2倍を見込む |
| 構造化データに `inLanguage` なし | 必須 |
