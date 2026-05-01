---
name: code-review
description: Review code changes against path-scoped rules, Atomic Design contract, accessibility patterns, performance hazards, and SEO/GEO at page level. Lead agent frontend-lead with frontend-engineer self-reviewing first.
auto_trigger_keywords:
  - コードレビュー
  - code review
  - PR review
  - 実装レビュー
---

# /code-review

## Purpose

Review code changes systematically — applying path-scoped rules, performance budget, a11y, SEO/GEO checks. Output is structured feedback with severity tags and suggested fixes.

## When to Use

- Continuously during Implementation phase
- Before phase-gate Implementation → QA
- After significant changes (new component, new page, new integration)

## Lead Agent

**frontend-lead** is the orchestrator. **frontend-engineer** self-reviews first; frontend-lead provides 2nd pass. **Tech Stack Specialists** (nextjs / wordpress) review stack-specific patterns when invoked.

## Inputs

- Changed files (via `git diff` or specified paths)
- `.claude/rules/` (path-scoped rules)
- `projects/{id}/03-design/design-system.md` (token compliance check)
- `projects/{id}/02-strategy/seo-geo-strategy.md` (SEO/GEO requirements)

## Process

1. Read changed files (full content, not just diff if context needed)
2. Apply path-scoped rules per `.claude/rules/{rule}.md`:
   - `components.md` for `src/components/**`
   - `pages.md` for `app/**` or `pages/**`
   - `content.md` for `content/**`
   - `design.md` for `design/**`
   - `images.md` for `public/images/**`
   - `api.md` for `src/api/**`
   - `legal.md` for `docs/legal/**`
   - `projects.md` for `projects/{id}/**`
   - `secrets.md` for `.env`, `secrets/**`
   - `i18n.md` for `i18n/**`
3. Check categorically:
   - Component contract (Props type, naming, default export)
   - Atomic Design level appropriateness
   - Accessibility (semantic HTML, ARIA, keyboard, focus, contrast tokens)
   - Performance hazards (large bundles, unoptimized images, sync data fetching above the fold)
   - SEO/GEO at page level (metadata API, structured data presence)
   - Path-scoped rule compliance
4. Output review with severity tags

## Severity Tags

- **Critical**: Blocks merge — security issue, accessibility blocker, broken build
- **High**: Strongly recommend fix before merge — performance hazard, SEO/GEO requirement missing, inconsistent design-system token use
- **Medium**: Suggest fix — code clarity, minor performance, alternative pattern
- **Low**: Nice-to-have — style preference, future-proofing

## Outputs

- Inline comments (when integrated with PR tooling) OR
- `projects/{id}/04-implementation/code-review-{date}.md` — file-by-file findings with severity

## Example Output (Japanese excerpt)

```markdown
# Code Review — 2026-06-15

**Reviewer**: frontend-lead
**Reviewee**: frontend-engineer
**Files reviewed**: 7

## src/components/HeroSection.tsx

### [High] Missing alt text fallback

行 23: `<Image src={heroImage} />`
alt 属性が空文字列。背景画像でない限り、説明的な alt が必要。

修正案:
```tsx
<Image src={heroImage} alt={heroAltText} priority />
```

### [Medium] Component is at page-level concerns

このコンポーネントは Hero 専用とのことだが、CTA ボタンのロジック
(onClick, navigation)を含むため Organism 相当。
ファイル名 `HeroSection` のままで OK だが、Atomic Design 的には
内部に Button (Atom) + Heading (Atom) + Image (Atom) の合成と
意識して構成すること。

## app/services/[slug]/page.tsx

### [Critical] generateMetadata が JSON-LD を含まない

`docs/geo-implementation-spec.md` Section 4 で全ページ JSON-LD 必須。
WebPage / BreadcrumbList / Service の 3 種類を追加してください。

### [High] og:image 未指定

`metadata.openGraph.images` を追加。1200×630 の OG 画像を
public/og/services-{slug}.png に配置。
```

## Boundary Notes

- Reviews are non-judgmental — focus on the code, not the developer
- Suggested fixes should be actionable (concrete code, not vague directives)
- Severity tags must be defensible — Critical = real blocker
- Do NOT review legal-template content (lawyer's responsibility)

## Reference Documents

- `.claude/rules/*.md` (path-scoped rules)
- `docs/geo-implementation-spec.md` (SEO/GEO requirements)
- `docs/requirements-v0.2.md` Section 22.3 (performance floors)
