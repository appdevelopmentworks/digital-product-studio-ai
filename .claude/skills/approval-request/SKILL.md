---
name: approval-request
description: Generate a client approval-request mail draft for a specific artifact (proposal/design/launch/etc.). Lead agent client-success-lead with the responsible Practice providing context.
auto_trigger_keywords:
  - 承認依頼
  - approval request
  - 承認メール
  - 承認依頼書
---

# /approval-request

## Purpose

Produce the approval-request mail draft that Shin sends to the client. Captures: what is being approved, what changes are still possible, deadline, attached artifact references.

## When to Use

- Before each major approval gate (proposal / requirements / design / content / launch / change-order)
- Whenever a Practice needs client sign-off before proceeding

## Lead Agent

**client-success-lead** authors the mail draft. The responsible Practice (commercial-manager for proposal, art-direction-lead for design, etc.) provides artifact context.

## Inputs

- The artifact being submitted for approval (path)
- Approval type (proposal / requirements / design / content / launch / change-order)
- Approver contact info from `stakeholders.yaml`
- Standard deadline (typically 3-5 business days)

## Process

1. Identify approval type and target artifact
2. Identify approver from `stakeholders.yaml`
3. Draft email per template:
   - Subject: 【ご確認のお願い】<artifact name>
   - Salutation
   - What is being submitted
   - What approval means (e.g., "デザインで進めて OK")
   - What changes are still possible
   - Deadline (3-5 business days standard)
   - Attached artifact reference (path, or PDF link)
   - Approval method (reply mail / call / meeting)
   - Signature
4. Generate `approvals.yaml` entry in `pending` state
5. Pass to Shin for review and send

## Outputs

- Mail draft staged for Shin's send (Markdown text)
- `00-engagement/approvals.yaml` updated with new pending entry

## Example Output (Japanese excerpt)

```markdown
## 件名

【ご確認のお願い】ご提案書 v1 — <案件名>

## 本文

<決裁者氏名> 様

いつもお世話になっております。AILEAP の <Shin> です。

先日お打合せいただきましたお話を踏まえ、ご提案書 v1 を取りまとめましたので、
ご確認のうえご承認いただけますでしょうか。

▼ ご確認いただきたい内容
1. 案件の進め方(3 パターン:固定価格 / 時間単価 / リテイナー)
2. 想定スコープ
3. 想定スケジュール
4. 御社にご準備いただく素材一覧

▼ ご承認後の進め方
ご承認後、ご選択いただいたパターンに沿って SOW(Statement of Work)を
取りまとめ、契約締結に進めさせていただきます。

▼ 修正可能な範囲
本承認をいただいた後でも、スコープの追加・変更は変更注文書(/change-order)
を通じて柔軟に対応可能です。

▼ ご提案書
別添 PDF をご確認ください。
projects/<id>/00-engagement/proposal-v1.pdf

▼ 承認方法・期限
本メールへのご返信、もしくは <YYYY-MM-DD> までにご回答いただけますと幸いです。
電話・オンラインミーティングでのご相談も承ります。

ご不明点ございましたら、いつでもご連絡ください。

何卒よろしくお願いいたします。

---
AILEAP
<Shin>
shin@aileap.example
```

## Boundary Notes

- Mail is staged — Shin reviews and sends. Never auto-send.
- Approver per `stakeholders.yaml` decision-maker (or designated alternate)
- For internal AILEAP projects: simplified internal-approval flow (no formal mail)

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.1 (approval management)
- `docs/agent-roster.md` Section 4-6 (client-success-lead)
