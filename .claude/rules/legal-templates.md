---
description: Legal page templates (privacy policy, tokushoho, terms) require a mandatory lawyer-confirmation YAML header. Do not provide actual legal advice — structural templates only.
globs:
  - "docs/templates/*legal*"
  - "docs/templates/*privacy*"
  - "docs/templates/*tokushoho*"
  - "docs/templates/*terms*"
  - "projects/**/legal-review.yaml"
  - "projects/**/00-engagement/legal-*"
alwaysApply: false
---

# Legal Templates — Mandatory Header and Scope Rules

Reference: `docs/legal-escalation-rules.md`

## Mandatory Frontmatter Header

Every legal page template MUST begin with this YAML frontmatter block:

```yaml
---
template_type: legal          # privacy-policy | tokushoho | terms-of-service
requires_lawyer_review: true  # ALWAYS true for legal templates
lawyer_confirmation: false    # Set to true only after a licensed lawyer has reviewed
last_reviewed_by: null        # Fill in: lawyer name or firm
last_reviewed_at: null        # Fill in: YYYY-MM-DD
aileap_version: "0.2"
warning: |
  このテンプレートは法律的助言ではありません。
  実際の掲載前に必ず弁護士の確認を受けてください。
---
```

**Never set `lawyer_confirmation: true`** in a template file itself.
The flag is set in `projects/[id]/00-engagement/legal-review.yaml` after
the actual client's legal counsel has reviewed the finalized content.

## Content Rules

### Placeholder format
Use `<<PLACEHOLDER>>` (double angle brackets) for all client-specific values:
- `<<COMPANY_NAME>>` — Company legal name
- `<<COMPANY_ADDRESS>>` — Registered address
- `<<REPRESENTATIVE_NAME>>` — Representative director name
- `<<EMAIL_ADDRESS>>` — Contact email
- `<<PHONE_NUMBER>>` — Phone number
- `<<SERVICE_NAME>>` — Product/service name

### What to include (structure only)
- Section headings and logical structure
- Required legal clauses as noted in current Japanese law
- Placeholder markers for all client-specific data

### What NOT to include
- ❌ Specific legal advice or interpretations
- ❌ Filled-in client data (always use placeholders)
- ❌ Claims that the template is legally sufficient as-is
- ❌ `lawyer_confirmation: true` in template files

## legal-review.yaml Schema

When creating `projects/[id]/00-engagement/legal-review.yaml`:

```yaml
project_id: ABC-001
requires_lawyer_review: true    # A3, EC, payment, B-series = always true
lawyer_confirmation: false       # Updated by delivery-director after review
lawyer_name: null
lawyer_firm: null
reviewed_at: null
pages_reviewed:
  - privacy_policy
  - tokushoho
notes: ""
```

## When lawyer review is mandatory (per legal-escalation-rules.md)
- A3 (mediasite) — always
- Any project with payment/EC functionality
- Projects collecting personal information beyond email/name
- B-series projects (v0.3+)
- A1/A2 projects where client explicitly requests it
