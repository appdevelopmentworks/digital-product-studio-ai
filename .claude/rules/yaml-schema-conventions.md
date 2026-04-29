---
description: All project YAML files must use English snake_case keys, ISO 8601 dates, predefined status enums, and project-ID naming conventions. Required fields must not be null.
globs:
  - "projects/**/*.yaml"
  - "projects/**/*.yml"
  - "docs/templates/**/*.yaml"
alwaysApply: false
---

# YAML Schema Conventions

Reference: `docs/requirements-v0.2.md` Section 14 (inter-agent communication standard)

## Key Naming

- **Always English snake_case**: `project_id`, `approved_by`, `created_at`
- Never camelCase (`projectId` ❌), kebab-case (`project-id` ❌), or Japanese keys (`承認者` ❌)
- Abbreviations: keep standard ones (`id`, `url`, `seo`, `geo`) — don't abbreviate others

## Date and Time Values

- Date: **ISO 8601** `YYYY-MM-DD` (e.g., `2026-06-15`)
- Datetime: **ISO 8601** `YYYY-MM-DDTHH:MM:SSZ` (UTC)
- Never: `6/15/2026`, `令和8年6月15日`, `June 15, 2026`

## Status Enums

Use only these predefined values for `status` fields:

| Context | Valid values |
|---|---|
| Project status | `active` \| `paused` \| `completed` \| `archived` |
| Approval status | `pending` \| `approved` \| `rejected` \| `waived` |
| Task status | `todo` \| `in_progress` \| `done` \| `blocked` |
| Asset status | `pending` \| `received` \| `overdue` |
| Retainer status | `active` \| `paused` \| `terminated` |

## ID Naming Conventions

| Type | Format | Example |
|---|---|---|
| Project | `{CLIENT_ABBR}-{YYYYMMDD}-{NNN}` | `AXYZ-20260601-001` |
| Approval | `APV-{NNN}` | `APV-007` |
| Decision | `DEC-{NNN}` | `DEC-012` |
| Asset | `AST-{NNN}` | `AST-003` |
| Change Order | `CO-{YYYYMMDD}-{NNN}` | `CO-20260620-001` |
| Estimate | `EST-{YYYYMMDD}-{NNN}` | `EST-20260515-001` |
| Retainer | `RTN-{YYYYMMDD}-{NNN}` | `RTN-20260901-001` |
| Meeting | `MTG-{YYYYMMDD}-{NNN}` | `MTG-20260502-001` |

## Required Fields

Do NOT leave required fields as `null` or omit them. Use empty string `""` only
when the field is genuinely optional and has no value yet. Required fields vary
by schema — consult the relevant `docs/templates/*.yaml` for each document type.

Common required fields that are frequently missed:
- `project_id` — always required in all project documents
- `created_at` — always required (ISO date)
- `status` — always required (enum value, not null)
- `id` — required in any list item that may be referenced later

## Multi-line Strings

Use YAML block scalars for multi-line text:
```yaml
# ✅ Correct — preserves line breaks
notes: |
  初回ヒアリングで確認済み。
  追加要件は変更注文で対応する予定。

# ❌ Avoid — hard to read
notes: "初回ヒアリングで確認済み。追加要件は変更注文で対応する予定。"
```

## Boolean Values

Use lowercase `true` / `false` (YAML canonical):
- ✅ `requires_lawyer_review: true`
- ❌ `requires_lawyer_review: True` / `yes` / `1`

## Null Values

Use explicit `null` (not `~`, not empty):
- ✅ `lawyer_name: null`
- ❌ `lawyer_name: ~`
- ❌ `lawyer_name:` (empty — ambiguous)

## Currency Values

Store as integer (yen, no decimals):
- ✅ `monthly_fee: 80000`
- ❌ `monthly_fee: "¥80,000"`
- ❌ `monthly_fee: 80000.00`

Add a comment for human-readable format if needed:
```yaml
monthly_fee: 80000  # ¥80,000 / 月
```
