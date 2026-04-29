---
description: All client-facing documents and project deliverables must be written in Japanese (Language Policy Layer 1). Covers docs/, project engagement/strategy/design outputs.
globs:
  - "docs/**"
  - "projects/**/00-engagement/**"
  - "projects/**/01-discovery/**"
  - "projects/**/02-strategy/**"
  - "projects/**/03-design/**"
  - "projects/**/05-launch/**"
  - "projects/**/06-handoff/**"
alwaysApply: false
---

# Language Policy — Layer 1: Japanese (Client-Facing)

Reference: `docs/language-policy.md`

## Scope

All Markdown documents, client deliverables, and meeting artifacts in the paths
covered by this rule are **Japanese-primary** (Layer 1). This applies to headings,
body text, bullet points, table content, and user-visible YAML values.

## Requirements

### Text content
- Write in Japanese (丁寧語ベース / ですます調) for all client-facing prose
- Technical terms may remain English where no natural Japanese equivalent exists
  (e.g., HTML, CSS, API, SEO, GEO, Lighthouse, Next.js, TypeScript)
- Translate all section headings — no English-only headings in client documents

### YAML files in these paths
- **Keys**: English snake_case (e.g., `project_id`, `approved_by`, `status`)
- **Values**: Japanese where user-facing text (e.g., `title: "会社概要"`)
- **Enum values**: English lowercase (e.g., `status: approved`, `phase: strategy`)
- **IDs and codes**: English format (e.g., `APV-001`, `DEC-005`)

### File encoding and format
- UTF-8, no BOM
- Line endings: LF (Unix-style) — avoid CRLF

### Do NOT translate
- File names and paths (stay in English/ASCII)
- Code blocks and inline `code` snippets
- URLs and domain names

## Common Mistakes to Avoid

- ❌ Writing client documents in English ("the design system was updated")
- ❌ Using English prose where Japanese is expected
- ✅ "デザインシステムを更新しました"
- ❌ YAML key in Japanese (`承認者: 田中`)
- ✅ YAML key in English (`approved_by: 田中 太郎`)
