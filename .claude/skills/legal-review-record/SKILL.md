---
name: legal-review-record
description: Record a completed lawyer review of a project's legal pages (privacy policy / tokushoho / terms-of-service). Updates `00-engagement/legal-review.yaml` `lawyer_confirmation: false → true` for the named page, and appends a `DEC-NNN` to decisions.yaml. The ONLY sanctioned path to flip the confirmation flag — direct edits are forbidden by `.claude/rules/legal-templates.md`.
auto_trigger_keywords:
  - 弁護士確認
  - 弁護士レビュー
  - 法務確認
  - lawyer_confirmation
  - legal review
  - 法務承認
  - lawyer-review-record
  - 法律確認完了
---

# /legal-review-record

## Purpose

Record the completion of a lawyer's review for a specific legal page in the active project, and update `legal-review.yaml` so that `pre-deploy-approval-check.sh` and `legal-pages-check.sh` will allow the deploy to proceed.

This skill exists because direct edits to `lawyer_confirmation: false → true` are forbidden by `.claude/rules/legal-templates.md` (template-side flag is always `false`). The flip must happen ONLY via this skill, with verified inputs (lawyer name / firm / review date / pages confirmed) so that the audit trail is complete.

## When to Use

- Lawyer has confirmed the privacy policy / tokushoho / terms page is acceptable for production
- Before launch, when `legal-pages-check.sh` blocks deploy citing missing lawyer confirmation
- After amendments to a legal page that re-trigger lawyer review (re-confirmation cycle)

## Lead Agent

**delivery-director** owns the gate decision (only delivery-director may execute this skill, per the legal-escalation rules). **client-success-lead** collects the lawyer's response document from the client. **commercial-manager** logs the lawyer-review cost line item if applicable.

## Inputs (all required — skill REFUSES to run with missing fields)

| Field | Type | Example | Source |
|---|---|---|---|
| `project_id` | string | `AXYZ-20260601-001` | active `PROJECT.md` |
| `page` | enum | `privacy_policy` \| `tokushoho` \| `terms_of_service` | enumerate from `legal-review.yaml::pages_reviewed[].page` |
| `lawyer_name` | string | `山田 太郎` | client / lawyer's response |
| `lawyer_firm` | string | `〇〇法律事務所` | client / lawyer's response |
| `bar_registration_no` | string | `第12345号` | client / lawyer's response (recommended for evidentiary value) |
| `reviewed_at` | ISO date | `2026-08-15` | lawyer's response |
| `review_method` | enum | `written_opinion` \| `email_confirmation` \| `signed_pdf` | client uploaded evidence |
| `evidence_path` | path | `00-engagement/legal-evidence/privacy-2026-08-15.pdf` | uploaded by client-success-lead |
| `review_notes` | multiline | "個人情報取扱事業者としての記載を強化済" | summary of changes / sign-offs |

If any of the above is missing or null, the skill refuses to update — it does NOT silently skip required fields.

## Process

### 1. Load active project and current `legal-review.yaml`

Read `projects/{project_id}/00-engagement/legal-review.yaml`. If missing, refuse and instruct user to run `/legal-escalation-rules` first.

### 2. Validate inputs against schema

- `page` must exist in `pages_reviewed[].page`
- `reviewed_at` must be a valid ISO date NOT in the future
- `evidence_path` must point to a file that exists under the project's `00-engagement/legal-evidence/`
- `lawyer_name` and `lawyer_firm` must both be non-empty (no placeholder like `<<...>>` allowed — placeholder-detection.sh would block deploy anyway)

### 3. Verify the lawyer evidence file is present and readable

```yaml
# Required pre-check
00-engagement/legal-evidence/{evidence_filename} must exist
```

If absent, refuse and prompt client-success-lead to upload.

### 4. Update `legal-review.yaml`

For the matching `pages_reviewed[]` entry:

```yaml
- page: privacy_policy
  required: true
  lawyer_confirmation: true            # was false
  template_used: docs/templates/privacy-policy-template.md
  lawyer_name: 山田 太郎                # filled
  lawyer_firm: 〇〇法律事務所            # filled
  bar_registration_no: 第12345号        # filled (new field)
  reviewed_at: 2026-08-15              # filled
  review_method: written_opinion        # filled (new field)
  evidence_path: 00-engagement/legal-evidence/privacy-2026-08-15.pdf
  review_notes: |
    (lawyer-supplied notes / amendments confirmed)
  publish_blocked: false               # was true — now allowed
```

Also update file-level metadata:

```yaml
last_updated_at: <today>
```

### 5. Recompute `overall_lawyer_confirmation`

If every page with `required: true` now has `lawyer_confirmation: true`:

```yaml
overall_lawyer_confirmation: true
```

Otherwise leave as `false` and report which required pages still need review.

### 6. Update `pre_launch_checklist`

Mark the matching item `status: completed`:

```yaml
pre_launch_checklist:
  - item: privacy_policy が lawyer_confirmation: true
    status: completed                 # was pending
    blocker_for_launch: true
    completed_at: 2026-08-15
```

### 7. Append a `DEC-NNN` entry to `decisions.yaml`

```yaml
- id: DEC-NNN                         # auto-incremented
  date: 2026-08-15
  type: legal_confirmation
  context: |
    {page} の弁護士確認を取得し、lawyer_confirmation を true に更新した。
  decided_by:
    - delivery-director
    - client(承認者: Shin)
  evidence_ref: 00-engagement/legal-evidence/privacy-2026-08-15.pdf
  related_files:
    - 00-engagement/legal-review.yaml
  impacted_agents:
    - delivery-director
    - client-success-lead
    - frontend-engineer (deploy unblocked)
  reversible: false                  # 弁護士確認の取消には新規の更新が必要
```

### 8. Confirmation report

Produce a `projects/{id}/00-engagement/legal-review-record-{date}.md` summarizing:

- Page confirmed
- Lawyer name / firm / bar number
- Review date and method
- Evidence file path
- New state of `legal-review.yaml`
- DEC ID created
- Whether deploy is now unblocked (or which pages still block)

## Outputs

- Updated `projects/{id}/00-engagement/legal-review.yaml`
- New `projects/{id}/00-engagement/legal-review-record-{date}.md` (Japanese, structured)
- New entry in `projects/{id}/00-engagement/decisions.yaml`

## Example Output (Japanese excerpt)

```markdown
# 法務確認記録 — privacy_policy

**案件**: AILEAP-20260429-001
**記録日**: 2026-08-15
**記録者**: delivery-director

## 確認内容

- ページ: プライバシーポリシー
- 弁護士: 山田 太郎(〇〇法律事務所 / 弁護士登録番号 第12345号)
- 確認日: 2026-08-15
- 確認方法: 書面意見書(written_opinion)
- 証跡: `00-engagement/legal-evidence/privacy-2026-08-15.pdf`

## 弁護士コメント要旨

個人情報取扱事業者としての記載を強化(第3条)。
GDPR 配慮について、EU 在住者向けの記載は将来的な国際展開時に再確認推奨。

## 状態変化

| 項目 | Before | After |
|---|---|---|
| `lawyer_confirmation` (privacy_policy) | false | **true** |
| `publish_blocked` (privacy_policy) | true | **false** |
| `overall_lawyer_confirmation` | false | true(他の必須ページもすべて確認済) |

## 関連 DEC

- DEC-007: 法務確認(privacy_policy)取得

## 公開可否への影響

✅ 本ページに関する公開ブロックは解除されました。
   `pre-deploy-approval-check.sh` および `legal-pages-check.sh` は
   この更新により本ページについては通過します。

## 次のアクション

- `/launch-checklist` で全 launch 条件を再確認
- 全ブロッカーが解除されたら `/approval-request type=launch_approval` を実行
```

## Boundary Notes

- **This skill is the ONLY sanctioned way to flip `lawyer_confirmation` to true**. Direct edits to `legal-review.yaml` to change this flag must be reverted by `delivery-director` and re-done through this skill.
- The skill does NOT verify legal correctness — it records that a qualified lawyer has done so. The lawyer's signed opinion is the authority; this skill only formalizes the record.
- For amended legal pages (post-launch), re-run this skill after the lawyer re-confirms. The previous DEC entry is preserved; a new DEC entry is appended.
- If `evidence_path` is not yet available (e.g., lawyer confirmed verbally first), instruct client-success-lead to obtain a written confirmation before this skill runs.
- `tokushoho` for sites without commerce: `required: false`; running this skill is optional but recommended if the page is published as a future-proofing measure.

## Reference Documents

- `.claude/rules/legal-templates.md` (placeholder + lawyer_confirmation enforcement)
- `docs/legal-escalation-rules.md` (when lawyer review is mandatory)
- `.claude/hooks/legal-pages-check.sh` (PreToolUse hook that this skill unblocks)
- `docs/gap-analysis-v0.2.md` G-C3 (this skill resolves the gap)
