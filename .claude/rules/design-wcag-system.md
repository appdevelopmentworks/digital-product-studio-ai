---
description: Design system files must embed WCAG 2.2 AA color contrast, focus indicators, and spacing from day one. No arbitrary hex values — use design tokens. Responsive breakpoints required.
globs:
  - "projects/**/03-design/**"
  - "docs/templates/design-system*"
  - "projects/**/*.tokens.json"
  - "projects/**/*.tokens.css"
  - "projects/**/design-tokens*"
  - "projects/**/theme.*"
alwaysApply: false
---

# Design System & WCAG 2.2 AA Standards

Reference: `docs/requirements-v0.2.md` Section 7 (H-4 fix — WCAG from day 1)

## Core Principle: Accessibility is NOT a post-launch retrofit

WCAG 2.2 AA compliance must be embedded in the design system token layer,
not added as a separate accessibility pass. Every color token, spacing token,
and component specification must be AA-compliant by default.

## Color Tokens

### Contrast requirements
- Normal text on background: **minimum 4.5:1** (WCAG 1.4.3 AA)
- Large text (≥18pt / ≥14pt bold): **minimum 3:1**
- UI components and graphical objects: **minimum 3:1** (WCAG 1.4.11)
- Decorative elements: no requirement

### Token naming convention
```json
{
  "color": {
    "text": {
      "primary":   "#1A1A2E",   // contrast: 16.2:1 on white
      "secondary": "#4A4A6A",   // contrast: 6.8:1 on white
      "disabled":  "#9A9AB0",   // contrast: 2.9:1 — decorative only, never for readable text
      "on-dark":   "#F8F8FF"    // contrast: 18.1:1 on brand-dark
    },
    "brand": {
      "primary":   "#2563EB",   // note contrast: 5.9:1 on white (AA compliant)
      "primary-dark": "#1D4ED8" // 7.2:1 on white (AAA compliant)
    }
  }
}
```

Always document the contrast ratio in a comment next to each color token.
If a token fails AA, mark it `// decorative-only — do not use for text`.

## Spacing Tokens

Use a base-4 or base-8 scale (never arbitrary values):
```
space-1: 4px
space-2: 8px
space-3: 12px
space-4: 16px
space-6: 24px
space-8: 32px
space-12: 48px
space-16: 64px
```

Minimum touch target: **44×44px** (WCAG 2.5.8 — Target Size AA)

## Typography Tokens

- Base font size: minimum 16px (1rem) for body text
- Line height: minimum 1.5 for body text (WCAG 1.4.8)
- Never use `px` for font sizes in CSS — use `rem` for user zoom support
- Define scale: display / h1 / h2 / h3 / h4 / body-lg / body / body-sm / caption

## Focus Indicator Tokens

```json
{
  "focus": {
    "ring-color": "#2563EB",
    "ring-width": "3px",
    "ring-offset": "2px"
  }
}
```

- Focus ring must be visible on ALL backgrounds the element may appear on
- Use `outline` not `box-shadow` for better browser compatibility
- Never suppress focus for keyboard users (`outline: none` is forbidden without replacement)

## Responsive Breakpoints

Standard breakpoints for all v0.2 projects:
```
sm:  640px   (mobile landscape)
md:  768px   (tablet portrait)
lg:  1024px  (tablet landscape / small desktop)
xl:  1280px  (desktop)
2xl: 1536px  (wide desktop)
```

Mobile-first approach: style for mobile, then override at breakpoints.

## Design Document Requirements

Every design system document must include:
1. Color palette with contrast ratios documented
2. Typography scale with rem values
3. Component states: default / hover / focus / active / disabled / error
4. Spacing system
5. Responsive behavior description per breakpoint
