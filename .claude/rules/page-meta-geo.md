---
description: Every routable page component must include complete meta tags (title, description, OG) and JSON-LD structured data per docs/geo-implementation-spec.md. GEO-optimized copy rules apply.
globs:
  - "projects/**/pages/**/*.tsx"
  - "projects/**/pages/**/*.jsx"
  - "projects/**/app/**/page.tsx"
  - "projects/**/app/**/page.jsx"
  - "projects/**/src/pages/**/*.astro"
  - "projects/**/*.html"
alwaysApply: false
---

# Page Meta Tags & GEO Requirements

Reference: `docs/geo-implementation-spec.md`

## Required Meta Tags (Every Page)

Every page that renders as an HTML document must have ALL of the following:

### 1. Title
- Unique per page
- Format: `{Page Name} | {Site Name}`
- Length: 30-60 characters
- Example: `サービス一覧 | 株式会社サンプル`

### 2. Meta Description
- Unique per page
- Length: **100-120 characters** (key GEO requirement)
- Start with the conclusion (invert-pyramid writing)
- Example: `AILEAP は中小企業向けの AI 活用 Web 制作スタジオです。コーポレートサイトから LP まで対応します。`

### 3. Open Graph Tags
```html
<meta property="og:title"       content="{page title without site name}" />
<meta property="og:description" content="{description — same as meta description}" />
<meta property="og:image"       content="{absolute URL, 1200×630px}" />
<meta property="og:type"        content="website" />  <!-- or "article" for blog posts -->
<meta property="og:url"         content="{canonical URL}" />
<meta property="og:locale"      content="ja_JP" />    <!-- or en_US for English pages -->
<meta property="og:site_name"   content="{site name}" />
```

### 4. Twitter Card
```html
<meta name="twitter:card"        content="summary_large_image" />
<meta name="twitter:title"       content="{title}" />
<meta name="twitter:description" content="{description}" />
<meta name="twitter:image"       content="{og:image URL}" />
```

### 5. Canonical URL
```html
<link rel="canonical" href="{absolute canonical URL}" />
```

### 6. hreflang (Multi-language sites only)
```html
<link rel="alternate" hreflang="ja"      href="https://example.com/ja/{path}" />
<link rel="alternate" hreflang="en"      href="https://example.com/en/{path}" />
<link rel="alternate" hreflang="x-default" href="https://example.com/ja/{path}" />
```

## Next.js Implementation Pattern

```typescript
// app/services/page.tsx
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'サービス一覧 | 株式会社サンプル',
  description: 'Web 制作・AI 活用コンサルの専門スタジオ。コーポレートサイト・LP・メディアサイト制作に対応。',
  openGraph: {
    title: 'サービス一覧',
    description: 'Web 制作・AI 活用コンサルの専門スタジオ。',
    images: [{ url: 'https://example.com/og/services.png', width: 1200, height: 630 }],
    type: 'website',
    locale: 'ja_JP',
  },
  alternates: {
    canonical: 'https://example.com/ja/services',
    languages: { 'ja': '/ja/services', 'en': '/en/services' },
  },
}
```

## JSON-LD Structured Data (per geo-implementation-spec.md)

### Required on homepage: Organization + WebSite
```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "<<COMPANY_NAME>>",
  "url": "https://<<DOMAIN>>",
  "logo": "https://<<DOMAIN>>/logo.png",
  "contactPoint": { "@type": "ContactPoint", "contactType": "customer service" }
}
```

### Required on every page: WebPage + BreadcrumbList
```json
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "<<PAGE_TITLE>>",
  "description": "<<DESCRIPTION>>",
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [...]
  }
}
```

### Required on FAQ sections: FAQPage
Use FAQPage schema for any accordion/Q&A section (major GEO citation signal).

## GEO Copy Rules (Generative Engine Optimization)

These rules make content citable by LLMs (ChatGPT, Gemini, Claude, etc.):

1. **Lead conclusion**: The first sentence of every section must state the conclusion
   - ❌ "まず背景を説明します。..."
   - ✅ "AILEAP の強みはネイティブレビュー付き多言語対応です。..."

2. **Fact density**: Include at least 1 verifiable fact per 100 characters
   - Include: statistics, dates, specific numbers, named methodologies

3. **1-claim sentences**: One main claim per sentence (aids LLM extraction)

4. **No ambiguous pronouns**: Always name the subject ("AILEAP は" not "私たちは")

5. **llms.txt**: The site root must include `/llms.txt` (see geo-implementation-spec.md)
