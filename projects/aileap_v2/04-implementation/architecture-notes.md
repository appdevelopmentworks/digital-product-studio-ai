# 実装アーキテクチャノート — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-05-01
**作成者**: technology-director(frontend-lead 補強)
**ステータス**: 確認済(internal)

---

## 1. 技術スタック確定

### 1.1 主要選定

| 領域 | 採用 | 主な理由 |
|---|---|---|
| **フレームワーク** | Next.js 14 App Router | RSC で初期表示高速化 / metadata API で SEO 効率化 / Vercel との親和性 |
| **言語** | TypeScript 5.x(strict mode) | 型安全 + 既存 AILEAP 慣行 |
| **スタイリング** | Tailwind CSS 3.x + CSS Modules(局所) | デザイントークン直接マッピング + 開発速度 |
| **CMS** | microCMS(Headless) | A3 検証兼用 / 国内サポート / WordPress より軽量 |
| **i18n** | next-intl v3 | App Router native / hreflang サポート / 翻訳辞書 JSON |
| **ホスティング** | Vercel | 既存 `aileap-hazel.vercel.app` から継続 |
| **フォーム** | react-hook-form + zod | クライアント検証 + サーバー検証の二段構え |
| **アナリティクス** | GA4 + GSC | 標準 / WMAO 引継ぎでもそのまま継続 |
| **エラー監視** | (v0.3 段階では Sentry 採用見送り) | A1 案件規模では Vercel logs + UptimeRobot で十分 |
| **画像最適化** | next/image | WebP/AVIF 自動配信 + CLS 防止 |
| **フォント** | Noto Sans JP(主)/ Inter(補助・en) | 多言語対応 + 視認性 |

### 1.2 検討した代替案と却下理由

| 候補 | 却下理由 |
|---|---|
| Astro Islands | コンポーネント interactivity が limited、フォーム実装に手間 |
| WordPress + Custom Theme | A3(メディアサイト)では強いが、A1 では microCMS の方が運用が軽い |
| Cloudflare Pages | 既存 Vercel 環境からの移行コスト > 移行 benefit |
| Sentry | 月額費用 + A1 規模では Vercel logs で十分(v0.4 で再検討) |

### 1.3 アーキテクチャ概略図

```
┌──────────────────────────────────────────────────────────┐
│ Vercel(本番ホスティング)                                │
│                                                          │
│  ┌──────────────────────────────────────────────┐       │
│  │  Next.js 14 App Router                       │       │
│  │  ├── app/                                    │       │
│  │  │    ├── [locale]/(routes)/...              │       │
│  │  │    ├── api/contact/route.ts               │       │
│  │  │    └── llms.txt/route.ts                  │       │
│  │  ├── messages/{ja,en}.json                   │       │
│  │  └── middleware.ts(locale 判定)              │       │
│  └────┬─────────────────────────────────────────┘       │
│       │                                                  │
│       ├─→ microCMS API(blogs / services / works)       │
│       ├─→ Resend API(お問い合わせメール送信)            │
│       └─→ GA4 / GSC(クライアント側計測)                 │
└──────────────────────────────────────────────────────────┘
                  ↑
                  │ git push to main → 自動 preview / staging
                  │ git tag v* → 手動 production deploy
                  │
            ┌─────────────────┐
            │ GitHub Actions  │
            │ (CI: lint /     │
            │  typecheck /    │
            │  test / build / │
            │  Lighthouse /   │
            │  axe-core)      │
            └─────────────────┘
```

---

## 2. ディレクトリ構造

```
aileap-v2/
├── app/
│   ├── [locale]/
│   │   ├── (routes)/
│   │   │   ├── page.tsx              # / (locale routing で /ja/ /en/ 切替)
│   │   │   ├── about/page.tsx
│   │   │   ├── services/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [slug]/page.tsx   # ja のみ(en は fallback)
│   │   │   ├── works/
│   │   │   │   ├── page.tsx
│   │   │   │   └── [slug]/page.tsx   # ja のみ
│   │   │   ├── careers/page.tsx       # ja のみ
│   │   │   ├── contact/page.tsx
│   │   │   ├── blog/
│   │   │   │   ├── page.tsx           # ja のみ
│   │   │   │   ├── [slug]/page.tsx
│   │   │   │   └── category/[slug]/page.tsx
│   │   │   └── privacy/page.tsx       # ja のみ
│   │   └── layout.tsx                 # locale 別 root layout
│   ├── api/
│   │   ├── contact/route.ts           # お問い合わせフォーム送信
│   │   └── careers/route.ts           # 採用エントリー(任意)
│   ├── llms.txt/route.ts              # 動的 llms.txt 配信
│   ├── sitemap.ts                     # sitemap.xml 自動生成
│   ├── robots.ts                      # robots.txt 自動生成
│   └── globals.css                    # Tailwind base + design tokens
├── src/components/
│   ├── atoms/                         # Button, Input, Badge, Icon
│   ├── molecules/                     # FormField, NavItem, Card, LanguageSwitcher
│   ├── organisms/                     # Header, Footer, HeroSection, FAQSection, ContactForm
│   └── templates/                     # PageLayout, ArticleLayout
├── src/lib/
│   ├── microcms.ts                    # microCMS クライアント
│   ├── seo.ts                         # メタタグヘルパー
│   ├── jsonld.ts                      # 構造化データジェネレータ
│   └── i18n.ts                        # next-intl 設定
├── messages/
│   ├── ja.json
│   └── en.json
├── public/
│   ├── images/                        # WebP/AVIF
│   ├── og/                            # OGP 画像 1200×630
│   ├── favicon.ico
│   └── apple-touch-icon.png
├── tests/
│   ├── e2e/
│   │   ├── critical-journeys/         # CJ-001 〜 CJ-005
│   │   └── a11y/
│   └── unit/
├── middleware.ts                      # locale 判定 + リダイレクト
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── .env.example
```

---

## 3. レンダリング戦略

### 3.1 ページ別の選定

| ページ | レンダリング | 理由 |
|---|---|---|
| `/` | SSG(ビルド時生成) | 内容変更頻度低 / 初期表示最速 |
| `/about` | SSG | 同上 |
| `/services` | SSG | 同上 |
| `/services/[slug]` | SSG + ISR(60 分) | microCMS で更新可 / SEO 重要 |
| `/works` | SSG + ISR(60 分) | 同上 |
| `/works/[slug]` | SSG + ISR(60 分) | 同上 |
| `/blog` | SSG + ISR(60 分) | 記事追加で再生成 |
| `/blog/[slug]` | SSG + ISR(60 分) | 同上 / SEO 重要 |
| `/careers` | SSG | 募集情報変更時のみ再ビルド |
| `/contact` | SSR | フォームの動的処理 |
| `/privacy` | SSG | 法務テキストは静的 |
| `/api/contact` | Edge Runtime | 軽量・低レイテンシ |
| `/llms.txt` | Edge Runtime | キャッシュ可 / 動的生成も可 |
| `/sitemap.xml` | ビルド時生成 | next-sitemap で自動 |

### 3.2 microCMS との同期

更新フロー:
```
クライアント(Shin)が microCMS で blog 投稿
    ↓
microCMS Webhook → Vercel Deploy Hook
    ↓
Vercel が増分ビルド or ISR で再生成
    ↓
公開反映(数分以内)
```

ISR(60 分)に加え、Webhook 経由の即時再ビルドで「更新即反映」を実現。

---

## 4. パフォーマンス予算

### 4.1 Lighthouse 目標(技術 director の予算)

| 指標 | 最低許容 | 目標 |
|---|---|---|
| Performance | 90 | 95+ |
| Accessibility | 95 | 100 |
| SEO | 100 | 100 |
| Best Practices | 90 | 100 |

`lighthouse-budget.sh` hook で deploy 前にチェック。

### 4.2 Core Web Vitals 目標

| 指標 | Good | 目標 |
|---|---|---|
| LCP | ≤ 2.5s | ≤ 2.0s |
| INP | ≤ 200ms | ≤ 100ms |
| CLS | ≤ 0.1 | ≤ 0.05 |

### 4.3 実装側の責任(frontend-engineer)

- ヒーロー画像: WebP / `priority` / 明示寸法(LCP 確保)
- フォント: 日本語サブセット / `font-display: swap` / `<link rel="preload">`
- JS: server-component-first / 必要箇所のみ client component / dynamic import で lazy
- CSS: Tailwind 完成版を critical extraction
- 画像 lazy: above-the-fold は eager / それ以外 lazy

---

## 5. SEO/GEO 実装方針

[02-strategy/seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) を実装する。

### 5.1 メタタグ実装(全ページ)

```typescript
// app/[locale]/(routes)/about/page.tsx
import type { Metadata } from 'next';

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const t = await getTranslations({ locale: params.locale, namespace: 'about' });
  return {
    title: `${t('meta.title')} | AILEAP`,
    description: t('meta.description'),  // 100-120 字、結論先出し
    openGraph: {
      title: t('meta.title'),
      description: t('meta.description'),
      images: [{ url: '/og/about.png', width: 1200, height: 630 }],
      locale: params.locale === 'en' ? 'en_US' : 'ja_JP',
      type: 'website',
    },
    alternates: {
      canonical: `https://aileap.example${params.locale === 'ja' ? '' : `/${params.locale}`}/about`,
      languages: {
        ja: 'https://aileap.example/about',
        en: 'https://aileap.example/en/about',
        'x-default': 'https://aileap.example/about',
      },
    },
  };
}
```

### 5.2 JSON-LD 実装

`src/lib/jsonld.ts` に generator を集約:

```typescript
export function organizationJsonLd() {
  return {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: 'AILEAP',
    url: 'https://aileap.example',
    logo: 'https://aileap.example/logo.png',
    contactPoint: {
      '@type': 'ContactPoint',
      contactType: 'customer service',
      email: 'contact@aileap.example',
    },
    inLanguage: ['ja', 'en'],
  };
}

export function faqPageJsonLd(items: FAQItem[]) { /* ... */ }
export function breadcrumbListJsonLd(items: Crumb[]) { /* ... */ }
export function articleJsonLd(post: BlogPost) { /* ... */ }
```

各ページで必要な JSON-LD を `<script type="application/ld+json">` で出力。

---

## 6. アクセシビリティ実装

[03-design/design-system.md](../03-design/design-system.md) のトークンを忠実に実装。

### 6.1 必須実装

- セマンティック HTML(`<header>` `<nav>` `<main>` `<aside>` `<footer>`)
- `<html lang>` を `[locale]` で動的設定
- フォーカスインジケーター: design-system §7 のトークンを CSS で実装
- スキップリンク: 「メインコンテンツへ」を実装(全ページ)
- Reduce Motion: `prefers-reduced-motion: reduce` メディアクエリで無効化
- フォーム: `<label>` 紐付け + `aria-invalid` + エラーメッセージ `aria-describedby`

### 6.2 検証

- Lighthouse Accessibility ≥ 95
- axe-core via @axe-core/playwright(全 critical journey で実行)
- Pa11y CI(全静的ページ)

---

## 7. セキュリティ・運用

### 7.1 ヘッダー

`next.config.js` で:
```javascript
headers: () => [{
  source: '/(.*)',
  headers: [
    { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
    { key: 'X-Content-Type-Options', value: 'nosniff' },
    { key: 'X-Frame-Options', value: 'DENY' },
    { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
    { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=()' },
  ],
}]
```

### 7.2 環境変数

```
# .env.example
MICROCMS_SERVICE_DOMAIN=
MICROCMS_API_KEY=
RESEND_API_KEY=
NEXT_PUBLIC_SITE_URL=https://aileap.example
NEXT_PUBLIC_GA_MEASUREMENT_ID=
```

すべて Vercel 環境変数で管理(production / preview / development を分離)。

### 7.3 デプロイゲート

[.claude/hooks/](../../../.claude/hooks/) の hooks が deploy 前に検証:

| Hook | 検証内容 |
|---|---|
| `lighthouse-budget.sh` | Lighthouse スコア閾値 |
| `legal-pages-check.sh` | privacy ページ存在 + lawyer_confirmation: true |
| `pre-deploy-approval-check.sh` | approvals.yaml::launch_approval が approved |
| `placeholder-detection.sh` | `<<...>>` の残置がない |

すべて pass しないと deploy できない。

---

## 8. 残課題と申し送り

### 8.1 Phase H で実装する項目(本文書の対象範囲)

- [x] Next.js 14 App Router セットアップ
- [x] microCMS クライアント実装
- [x] next-intl 設定
- [x] middleware で locale 判定
- [x] 全ページのメタタグ・JSON-LD 実装
- [x] お問い合わせフォーム + Resend 統合
- [x] llms.txt / sitemap.xml / robots.txt 配信
- [x] Lighthouse / a11y / SEO テスト

### 8.2 v0.4 以降の継続課題

- Sentry 統合(エラー監視の本格運用)
- Storybook 導入(コンポーネントカタログ)
- Visual regression(Chromatic)
- en コピーの自動翻訳パイプライン CI 化
- /careers の en 化
- /blog の en 化(主要記事のみ)

---

## 9. 改訂履歴

| 版 | 日付 | 主な変更 |
|---|---|---|
| 1.0 | 2026-05-01 | 初版。Phase H 実装着手時のアーキテクチャ確定。 |

---

**Document Owner**: technology-director
**Last Updated**: 2026-05-01
**Version**: 1.0
