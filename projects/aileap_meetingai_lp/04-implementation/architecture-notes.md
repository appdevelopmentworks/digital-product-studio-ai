# 実装アーキテクチャノート — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0
**作成日**: 2026-06-11
**作成者**: technology-director(frontend-lead 補強)
**ステータス**: 確認済(internal)

> **継承元**: [aileap_v2/04-implementation/architecture-notes.md](../../aileap_v2/04-implementation/architecture-notes.md)
> A2 LP は aileap_v2 と同一スタックを採用し、本書は **差分のみ** を記録。

---

## 1. 技術スタック(aileap_v2 継承)

| 領域 | 採用 | 継承先 |
|---|---|---|
| フレームワーク | Next.js 14 App Router | aileap_v2 |
| 言語 | TypeScript 5.x(strict) | aileap_v2 |
| スタイリング | Tailwind CSS 3.x | aileap_v2 |
| CMS | **使用しない**(LP は静的・コピーは messages/ja.json) | LP 固有差分 |
| i18n | **使用しない**(ja のみ) | LP 固有差分 |
| ホスティング | Vercel | aileap_v2 |
| フォーム | react-hook-form + zod | aileap_v2 |
| メール送信 | Resend(共有 API キー) | aileap_v2 |
| アナリティクス | GA4(統合プロパティ + utm_campaign 識別) | aileap_v2 |
| 画像最適化 | next/image | aileap_v2 |
| フォント | Noto Sans JP | aileap_v2 |
| reCAPTCHA | v3 | aileap_v2 |

aileap_v2 と同じスタックを採用することで実装工数を最小化。

## 2. ドメイン戦略

DEC-008(Phase I-A 内): **サブドメイン運用** で確定

```
https://aileap.example/                    ← aileap_v2(コーポレート)
https://meetingai.aileap.example/          ← MeetingAI LP(本案件)
```

理由:
- ブランド一貫性(同一ドメイン傘下)
- llms.txt 統合運用が容易
- aileap_v2 sitemap.xml に MeetingAI LP を含めることが可能
- SSL 証明書はワイルドカード(*.aileap.example)で 1 枚

代替案(却下):
- 別ドメイン(meetingai.app):ブランド分散・SEO 評価分散
- パスベース(aileap.example/meetingai/):aileap_v2 と分離管理が困難

---

## 3. ディレクトリ構造

```
aileap-meetingai-lp/                       # 別 GitHub repo
├── app/
│   ├── (routes)/
│   │   ├── page.tsx                       # / (LP 本体)
│   │   ├── thanks/
│   │   │   └── page.tsx                   # /thanks
│   │   └── layout.tsx
│   ├── api/
│   │   └── beta-signup/route.ts           # β版申込みフォーム
│   ├── sitemap.ts
│   ├── robots.ts
│   └── globals.css
├── src/components/
│   ├── atoms/                             # aileap_v2 と同等(再利用検討)
│   ├── molecules/
│   ├── organisms/
│   │   ├── HeroSection.tsx                # LP 固有
│   │   ├── FeatureSection.tsx             # LP 固有
│   │   ├── BetaPerksSection.tsx           # LP 固有
│   │   ├── FAQSection.tsx                 # aileap_v2 から流用可
│   │   └── BetaSignupForm.tsx             # LP 固有
│   └── templates/
│       └── LandingPageLayout.tsx          # LP 専用テンプレート
├── messages/
│   └── ja.json                            # ja のみ(en は不使用)
├── public/
│   ├── images/
│   │   ├── hero/                          # ヒーロー画像
│   │   ├── features/                      # 機能スクリーンショット 5 枚
│   │   └── og/                            # OGP 画像
│   ├── favicon.ico
│   └── apple-touch-icon.png
├── tests/
│   └── e2e/
│       └── signup-form.spec.ts            # フォーム送信 E2E
├── next.config.js
├── tailwind.config.ts
└── .env.example
```

LP のため middleware.ts は不要(i18n routing なし)。

---

## 4. レンダリング戦略

| ページ | レンダリング | 理由 |
|---|---|---|
| `/` | SSG(ビルド時生成) | LP は内容固定・初期表示最速 |
| `/thanks` | SSG | 同上 / noindex |
| `/api/beta-signup` | Edge Runtime | 軽量・低レイテンシ |
| `/llms.txt` | (aileap_v2 と統合のため本 LP に置かない) | — |
| `/sitemap.xml` | ビルド時生成 | next-sitemap |
| `/robots.txt` | ビルド時生成 | — |

---

## 5. パフォーマンス予算(LP は厳しめ)

| 指標 | 目標 |
|---|---|
| Lighthouse Performance | **95+**(LP は速度が CV に直結) |
| Lighthouse Accessibility | 100(継承) |
| Lighthouse SEO | 100 |
| Lighthouse Best Practices | 100 |
| LCP | ≤ 2.0s(aileap_v2 より厳しい) |
| INP | ≤ 100ms |
| CLS | ≤ 0.05(aileap_v2 より厳しい) |

LP の Lighthouse Performance を 95+ に設定する理由:
- LP は CV までの離脱率が高い
- 1 秒の表示遅延で CV 率が ~5% 落ちると言われる(GA4 で実測予定)

---

## 6. SEO/GEO 実装方針

[seo-geo-strategy.md](../02-strategy/seo-geo-strategy.md) §3-4 を実装。要点:

### 6.1 metadata API(LP 1 ページ)

```typescript
export const metadata: Metadata = {
  title: 'MeetingAI(会議要約 SaaS)| AILEAP',
  description: 'MeetingAI は会議の録音から要約 + 議事録 + 検索を自動化する SaaS。日本語特化精度 95% で中堅企業のバックオフィスの工数を 90% 削減。β版を無料で試す。',
  // ...
};
```

### 6.2 構造化データ(Service スキーマが核心)

`src/lib/jsonld.ts` に LP 固有のヘルパー追加:

```typescript
export function meetingAIServiceJsonLd() {
  return {
    '@context': 'https://schema.org',
    '@type': 'Service',
    name: 'MeetingAI',
    provider: { '@type': 'Organization', name: 'AILEAP' },
    serviceType: '会議要約 / 議事録自動生成 SaaS',
    areaServed: 'JP',
    offers: {
      '@type': 'Offer',
      price: '0',
      priceCurrency: 'JPY',
      description: 'β版は無料。正式版は月 5,000 円〜(2026 Q4 予定)',
    },
  };
}
```

FAQPage は aileap_v2 と同じ helper(`faqPageJsonLd`)を流用。

### 6.3 llms.txt(統合運用)

本 LP に `/llms.txt` は配置せず、aileap_v2 の `/llms.txt` で本 LP を言及。
これにより llms.txt の重複を避け、AILEAP ブランド全体での GEO 戦略を一元化。

---

## 7. フォーム実装(aileap_v2 と同一パターン)

### 7.1 zod スキーマ

```typescript
const BetaSignupSchema = z.object({
  name: z.string().min(1).max(100),
  company: z.string().max(200).optional(),
  email: z.string().email(),
  team_size: z.enum(['1-10', '11-50', '51-300', '300+']),
  purpose: z.string().max(500).optional(),
  privacy_consent: z.literal(true, { errorMap: () => ({ message: '同意が必要です' }) }),
  recaptcha_token: z.string().min(1),
});
```

### 7.2 API route(Edge Runtime)

```typescript
// app/api/beta-signup/route.ts
export const runtime = 'edge';

export async function POST(req: Request) {
  const body = await req.json();
  const parsed = BetaSignupSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json({ error: parsed.error.issues }, { status: 422 });
  }

  // reCAPTCHA v3 検証
  const score = await verifyRecaptcha(parsed.data.recaptcha_token);
  if (score < 0.5) return Response.json({ error: 'verification_failed' }, { status: 403 });

  // Resend で通知
  const resend = new Resend(process.env.RESEND_API_KEY);
  await resend.emails.send({
    from: 'noreply@aileap.example',
    to: 'meetingai-beta@aileap.example',
    subject: `[MeetingAI β申込] ${parsed.data.name} (${parsed.data.company ?? 'N/A'})`,
    html: renderBetaSignupEmail(parsed.data),
  });

  // 自動返信メール
  await resend.emails.send({
    from: 'meetingai@aileap.example',
    to: parsed.data.email,
    subject: 'MeetingAI β版申込みを受け付けました',
    html: renderBetaConfirmationEmail(parsed.data),
  });

  return Response.json({ ok: true }, { status: 201 });
}
```

aileap_v2 の `/api/contact/route.ts` と同じパターンで実装。

---

## 8. デプロイゲート

aileap_v2 と同じ hooks がデプロイ前に検証:

| Hook | 動作 |
|---|---|
| `lighthouse-budget.sh` | Performance 95+ / その他 90+ |
| `placeholder-detection.sh` | `<<...>>` 残置 0 件 |
| `pre-deploy-approval-check.sh` | APV-005 approved |
| `legal-pages-check.sh` | privacy_policy が aileap_v2 から継承 + lawyer_confirmation: true |

すべて pass で本番デプロイ可能。

---

## 9. v0.4 以降の継続課題

- ブログ連動(aileap_v2 側で MeetingAI 関連記事を増やす)
- A/B テスト導入(Vercel Edge Config + GrowthBook 等)
- en 化(海外展開時)
- 比較表ページの追加

---

## 10. 検証メモ(Phase I-A)

- aileap_v2 と同一スタックでの実装が現実的に動作することを確認
- 実装工数 18h(A2 標準 30-40h より圧縮)— 継承効果を実証
- フォーム + reCAPTCHA + Resend の 3 段構えがそのまま流用可能

---

**Document Owner**: technology-director
**Last Updated**: 2026-06-11
**Version**: 1.0
**継承元**: aileap_v2/04-implementation/architecture-notes.md
