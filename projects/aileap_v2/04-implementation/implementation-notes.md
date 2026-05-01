# 実装ノート — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-05-01
**作成者**: frontend-lead(frontend-engineer / cms-engineer 補強)
**ステータス**: 実装ガイド(internal)

> 本書は Phase H の実装フェーズ進行ログ。実コードは別途 `aileap-v2/` リポジトリ
> (本リポジトリとは別管理)に存在することを想定。本書は実装範囲・方針・主要決定の記録。

---

## 1. 実装フェーズの全体像

### 1.1 フェーズ進行(2026-05-15 〜 2026-06-08 想定)

| 週 | 主な実装内容 | 主担当 |
|---|---|---|
| W1(5/15-5/21) | プロジェクト初期化 / Next.js + Tailwind / microCMS クライアント | frontend-engineer |
| W2(5/22-5/28) | atoms / molecules / organisms 実装 / design-system トークン適用 | frontend-engineer + ui-designer 連携 |
| W3(5/29-6/04) | 主要ページ実装(top / about / services / contact)/ i18n 設定 | frontend-engineer + localization-specialist |
| W4(6/05-6/08) | 動的ページ(services 詳細 / blog / works)/ お問い合わせ API / llms.txt 配信 | frontend-engineer + backend-lead(軽量介入) |

### 1.2 実装済 / 残作業の管理

実装済機能チェックリスト(進行中のため check は実装完了時に更新):

- [ ] プロジェクト初期化(Next.js 14 + TypeScript + Tailwind)
- [ ] design-system トークンの globals.css / tailwind.config.ts への展開
- [ ] atoms 実装(Button, Input, Badge, Icon, Heading)
- [ ] molecules 実装(FormField, NavItem, Card, LanguageSwitcher, Breadcrumb)
- [ ] organisms 実装(Header, Footer, HeroSection, FAQSection, ContactForm)
- [ ] templates 実装(PageLayout, ArticleLayout)
- [ ] microCMS クライアント実装
- [ ] next-intl ルーティング + middleware 実装
- [ ] 全ページのメタタグ実装(generateMetadata)
- [ ] 全ページの JSON-LD 実装(jsonld.ts ヘルパー経由)
- [ ] llms.txt 配信ルート
- [ ] sitemap.xml + robots.txt 自動生成
- [ ] お問い合わせ API(`/api/contact`)+ Resend メール送信
- [ ] アクセシビリティ実装(skip link / focus / Reduce Motion)
- [ ] エラー監視(Vercel logs ベース)
- [ ] OGP 画像 12 枚生成(全ページ + 記事 7 本分)
- [ ] favicon / apple-touch-icon

### 1.3 実装上の主要決定

| ID | 決定 | 根拠 |
|---|---|---|
| IMPL-001 | Next.js 14 App Router を採用 | architecture-notes.md §1 |
| IMPL-002 | microCMS を採用(WordPress ではなく) | A3 検証兼用 / Headless で運用軽量 |
| IMPL-003 | next-intl v3 を採用 | App Router native + hreflang サポート |
| IMPL-004 | Tailwind 3.x + CSS Modules(局所) | デザイントークン即時反映 + 開発速度 |
| IMPL-005 | i18n は middleware ベース(自動言語判定) | UX が良い / SEO の hreflang と整合 |
| IMPL-006 | お問い合わせフォームは Edge Function で軽量実装 | A1 規模では十分 / コスト極小 |

主要決定は `decisions.yaml` にも DEC エントリで記録。

---

## 2. コンポーネント実装計画

### 2.1 Atomic Design 階層

```
atoms/        — Button / Input / Badge / Icon / Heading / Link / Image
molecules/    — FormField / NavItem / Card / LanguageSwitcher / Breadcrumb / FAQItem
organisms/    — Header / Footer / HeroSection / ServicesSection / FAQSection / ContactForm / BlogList
templates/    — PageLayout / ArticleLayout / FormLayout
pages/        — 各 route(app/[locale]/(routes)/...)
```

### 2.2 design-system → Tailwind / CSS 変数のマッピング

```css
/* app/globals.css */
@layer base {
  :root {
    /* color (design-system §2 から) */
    --color-text-primary: #1A1A2E;       /* AAA */
    --color-text-secondary: #4A4A6A;     /* AA */
    --color-bg-default: #FFFFFF;
    --color-brand-primary: #2563EB;      /* AA */
    --color-brand-primary-dark: #1D4ED8; /* AAA */

    /* font */
    --font-family-sans: 'Noto Sans JP', 'Hiragino Sans', sans-serif;
    --font-family-en: 'Inter', sans-serif;

    /* space */
    --space-1: 0.25rem;
    --space-2: 0.5rem;
    --space-4: 1rem;
    --space-6: 1.5rem;
    --space-8: 2rem;

    /* focus */
    --focus-ring-color: #2563EB;
    --focus-ring-width: 3px;
    --focus-ring-offset: 2px;
  }

  *:focus-visible {
    outline: var(--focus-ring-width) solid var(--focus-ring-color);
    outline-offset: var(--focus-ring-offset);
  }

  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
      animation-duration: 0.01ms !important;
      transition-duration: 0.01ms !important;
    }
  }
}
```

### 2.3 i18n 統合

```typescript
// app/[locale]/(routes)/page.tsx(トップページ・en/ja 両対応)
import { useTranslations } from 'next-intl';

export default function HomePage() {
  const t = useTranslations('home');
  return (
    <main>
      <HeroSection
        title={t('hero.title')}
        subtitle={t('hero.subtitle')}
      />
      {/* ... */}
    </main>
  );
}
```

---

## 3. CMS 構築(microCMS)

### 3.1 オブジェクト設計(sitemap §7.1 を実装)

| API ID | 用途 | 主要フィールド |
|---|---|---|
| `services` | サービス情報 | title, slug, summary, problem, solution, process, price, faqs, related_works |
| `works` | 実績 | title, slug, client_name, industry, period, problem, solution, results, agents_involved |
| `blog` | 記事 | title, slug, body(リッチテキスト), author(参照)、category(参照)、tags、cover_image, published_at |
| `careers` | 募集職種 | title, role, requirements, salary_range, work_style, faqs |
| `categories` | ブログカテゴリ | name, slug, description |
| `authors` | 著者 | name, role, bio, image, social_links |

### 3.2 microCMS API クライアント

```typescript
// src/lib/microcms.ts
import { createClient } from 'microcms-js-sdk';

export const microcms = createClient({
  serviceDomain: process.env.MICROCMS_SERVICE_DOMAIN!,
  apiKey: process.env.MICROCMS_API_KEY!,
});

export async function getServices() {
  return microcms.getList<Service>({
    endpoint: 'services',
    queries: { limit: 100, orders: 'order' },
  });
}
// 同様に getBlogs / getWorks / etc.
```

### 3.3 ISR の Webhook 設定

microCMS 側で `services` / `blog` 等のコンテンツ更新時に Vercel Deploy Hook を叩く設定:

```
microCMS Webhook URL: https://api.vercel.com/v1/integrations/deploy/...
Event: コンテンツ作成 / 更新 / 削除
```

これで「公開即反映」を実現(ISR の 60 分待ちを回避できる)。

---

## 4. SEO/GEO 実装

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) と architecture-notes.md §5 を実装。

### 4.1 全ページの metadata

generateMetadata で:
- title(言語別)
- description(100-120 字、結論先出し、言語別)
- canonical(自動生成)
- og:image(ページ別 1200×630)
- alternates.languages(hreflang ja/en/x-default)

### 4.2 構造化データ(JSON-LD)

`src/lib/jsonld.ts` のヘルパー経由で全ページに必要なスキーマを出力。サービス詳細・記事詳細では FAQPage を必須(GEO 引用度の核心)。

### 4.3 llms.txt 配信

```typescript
// app/llms.txt/route.ts
export const runtime = 'edge';

export async function GET() {
  const content = generateLlmsTxt();  // seo-geo-strategy.md §4.1 の内容
  return new Response(content, {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
}
```

---

## 5. お問い合わせフォーム実装

### 5.1 Frontend(react-hook-form + zod)

```typescript
// src/components/organisms/ContactForm.tsx
const ContactSchema = z.object({
  name: z.string().min(1, '氏名は必須です').max(100),
  company: z.string().min(1, '会社名は必須です').max(200),
  email: z.string().email('メールアドレスが不正です'),
  phone: z.string().optional(),
  inquiry_type: z.enum(['service', 'recruit', 'media', 'other']),
  message: z.string().min(10, 'お問い合わせ内容は 10 文字以上').max(2000),
  privacy_consent: z.literal(true, { errorMap: () => ({ message: '同意が必要です' }) }),
});
```

### 5.2 Backend(Edge Function + Resend)

```typescript
// app/api/contact/route.ts
export const runtime = 'edge';

export async function POST(req: Request) {
  const body = await req.json();
  const parsed = ContactSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json({ error: parsed.error.issues }, { status: 422 });
  }

  // Honeypot / Rate limit(IP ベース、5 req/15 min)
  // ...

  // Resend でメール送信
  const resend = new Resend(process.env.RESEND_API_KEY);
  await resend.emails.send({
    from: 'noreply@aileap.example',
    to: 'contact@aileap.example',
    subject: `[お問い合わせ] ${parsed.data.inquiry_type}`,
    html: renderInquiryEmail(parsed.data),
  });

  return Response.json({ ok: true }, { status: 201 });
}
```

### 5.3 セキュリティ

- reCAPTCHA v3(任意 / 当面 honeypot で対応)
- Rate limit(Edge KV ベース、IP ベース 5 req/15min)
- Privacy Policy 同意必須(チェックボックス)
- 個人情報は微 CMS / DB に保存しない(メール送信のみ・PII を log しない)

---

## 6. アクセシビリティ実装の詳細

[03-design/design-system.md](../03-design/design-system.md) §10 を実装。

### 6.1 必須実装

- セマンティック HTML(`<button>` を `<div onClick>` で代替しない)
- `<html lang>` を locale で設定(`<html lang="ja">` / `<html lang="en">`)
- スキップリンク: `<a href="#main">メインコンテンツへ</a>` を Header 直前に配置
- フォーカス可視: `:focus-visible` で `outline 3px solid #2563EB`
- Reduce Motion: `@media (prefers-reduced-motion: reduce)` で animation/transition を 0.01ms に
- フォームラベル: 全 input に `<label>` 紐付け
- エラー: `aria-invalid="true"` + `aria-describedby` でメッセージリンク
- パンくず: `<nav aria-label="breadcrumb">` + `aria-current="page"`
- 言語切替: `<a hreflang="en">English</a>` + `aria-label="Switch to English"`

### 6.2 検証(Phase H4 QA で実施)

- Lighthouse Accessibility ≥ 95
- axe-core via @axe-core/playwright(全 critical journey で実行)
- 手動 keyboard test(Tab / Enter / Esc)
- VoiceOver / NVDA 動作確認(最低 3 ページ)

---

## 7. デプロイ環境

### 7.1 環境別設定

| 環境 | URL | 用途 |
|---|---|---|
| Local | `http://localhost:3000` | 開発 |
| Preview | `<branch>.aileap-v2.vercel.app` | PR レビュー |
| Production | `https://aileap.example`(本番ドメイン取得後)/ 当面は `aileap-hazel.vercel.app` 継続 | 本番 |

### 7.2 環境変数(本番)

Vercel ダッシュボードで設定:

| 変数 | 値の出処 |
|---|---|
| `MICROCMS_SERVICE_DOMAIN` | aileap-microcms |
| `MICROCMS_API_KEY` | microCMS dashboard |
| `RESEND_API_KEY` | Resend dashboard |
| `NEXT_PUBLIC_SITE_URL` | `https://aileap.example` |
| `NEXT_PUBLIC_GA_MEASUREMENT_ID` | GA4 |

### 7.3 ローンチ手順(launch-checklist.md と整合)

1. 全 hook が pass(smoke-test 含む)
2. 全 audit が pass(seo / geo / a11y)
3. approvals.yaml::launch_approval が approved
4. 法務確認(privacy)が lawyer_confirmation: true
5. placeholder-detection が pass(`<<...>>` 残置なし)
6. Vercel manual production deploy
7. 公開直後 smoke-test(本書 §8 / launch-checklist §12)
8. GA4 / GSC 動作確認
9. 30 日カウント開始(Phase 5 サポート)

---

## 8. 公開直後 smoke-test(launch-checklist との連動)

公開直後に手動で以下を確認:

- [ ] `/`(ja)が正常表示 + LCP < 2.5s
- [ ] `/en/`(en)が正常表示 + 言語切替動作
- [ ] `/services` のサービスカード一覧が表示
- [ ] `/contact` フォーム送信成功(Resend メール到達確認)
- [ ] `/llms.txt` が plain text で配信される
- [ ] `/sitemap.xml` に全ページが含まれる
- [ ] `/robots.txt` に GPTBot / ClaudeBot Allow が含まれる
- [ ] 構造化データ(Google Rich Results Test)が valid
- [ ] hreflang が ja/en で相互参照
- [ ] OGP プレビュー(Facebook Debugger)で 5 ページの OGP 画像が表示

すべて pass で「公開完了」を Shin に報告。

---

## 9. v0.3 検証で残された課題

### 9.1 Phase H で発見されるであろう gap(予測)

実コード実装を伴わない検証案件のため、以下は v0.4 で実コード実装時に再評価:

- microCMS の WYSIWYG 編集体験(クライアント目線の UX)
- ISR + Webhook の更新即時性
- Vercel Edge Function の cold start 影響
- Lighthouse 100 達成の難所

### 9.2 v0.4 への申し送り

- Sentry 統合
- Storybook
- Visual regression(Chromatic)
- en コピー自動更新パイプライン

---

## 10. 改訂履歴

| 版 | 日付 | 主な変更 |
|---|---|---|
| 1.0 | 2026-05-01 | 初版。Phase H 実装フェーズの方針確定。 |

---

**Document Owner**: frontend-lead
**Last Updated**: 2026-05-01
**Version**: 1.0
