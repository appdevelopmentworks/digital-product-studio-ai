---
description: Implementation code must meet Lighthouse budget (P≥90/A≥95/S≥100/BP≥90), follow Atomic Design hierarchy, TypeScript strict mode, WCAG 2.2 AA, and WebP/AVIF image format. No hardcoded copy strings.
globs:
  - "projects/**/04-implementation/**"
  - "projects/**/src/**"
  - "projects/**/app/**"
  - "projects/**/components/**"
  - "projects/**/pages/**"
  - "projects/**/*.tsx"
  - "projects/**/*.ts"
  - "projects/**/*.jsx"
  - "projects/**/*.astro"
alwaysApply: false
---

# Implementation Code Standards

Reference: `docs/requirements-v0.2.md` Section 7 / `docs/geo-implementation-spec.md`

## Lighthouse Budget (Non-Negotiable)

| Metric | Minimum | Env Variable |
|---|---|---|
| Performance | ≥ 90 | `DPSAI_LIGHTHOUSE_PERFORMANCE_MIN` |
| Accessibility | ≥ 95 | `DPSAI_LIGHTHOUSE_ACCESSIBILITY_MIN` |
| SEO | ≥ 100 | `DPSAI_LIGHTHOUSE_SEO_MIN` |
| Best Practices | ≥ 90 | `DPSAI_LIGHTHOUSE_BEST_PRACTICES_MIN` |

These are enforced by `lighthouse-budget.sh` before every deploy.

## TypeScript

- Always use TypeScript strict mode (`"strict": true` in tsconfig)
- No `any` type without an explanatory comment (`// eslint-disable-next-line @typescript-eslint/no-explicit-any`)
- Prefer `interface` over `type` for object shapes (exception: union types)
- Explicitly type all function return values for public APIs

## Atomic Design Component Hierarchy

```
atoms/        — Button, Input, Badge, Icon (no business logic)
molecules/    — FormField, Card, NavItem (composes atoms)
organisms/    — Header, Footer, HeroSection, ContactForm (composes molecules)
templates/    — PageLayout, ArticleLayout (layout structure only)
pages/        — Actual route pages (minimal logic — mostly template instantiation)
```

- Components in `atoms/` must have zero external data dependencies
- State management only in `organisms/` and above
- No direct API calls in components below `organisms/`

## Accessibility (WCAG 2.2 AA)

- All `<img>` and `<Image>` elements: non-empty `alt` (or `alt=""` for decorative with comment)
- All form inputs: associated `<label>` or `aria-label`
- All interactive elements: visible focus indicator (`:focus-visible`)
- Heading hierarchy: logical progression (h1→h2→h3, no skips)
- Minimum color contrast: 4.5:1 (normal text), 3:1 (large text ≥18pt or ≥14pt bold)
- `<html lang="ja">` (or appropriate locale) on all pages

## Images

- Prefer WebP or AVIF for raster images (not JPEG/PNG in production)
- Exceptions: `favicon.ico`, `og-image.png`, `apple-touch-icon.png`
- All images must have explicit `width` and `height` to prevent CLS
- Use `loading="lazy"` for below-the-fold images
- Use `fetchpriority="high"` for LCP image

## Internationalization (i18n)

- No hardcoded Japanese string literals in component files
- All copy must come from i18n JSON files (`messages/ja.json`, `messages/en.json`)
- Use `next-intl` (Next.js) or `Astro i18n` patterns
- Format: `t('namespace.key')` — never `"お問い合わせ"` inline

## Meta Tags / GEO (per geo-implementation-spec.md)

Every page component must export metadata including:
- `title` — unique per page, format: `{Page} | {Site Name}`
- `description` — 100-120 characters, start with conclusion
- `og:title`, `og:description`, `og:image` (1200×630px)
- `og:type`: `website` for top/category, `article` for posts
- Structured data: JSON-LD for relevant schema types

## Code Style

- No inline styles — use CSS Modules, Tailwind utility classes, or design tokens
- Design tokens from the project's design system (never hardcode hex colors)
- Imports: absolute paths preferred (e.g., `@/components/atoms/Button`)
- No `console.log` in production code (use structured logging utilities)
