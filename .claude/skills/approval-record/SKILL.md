---
name: approval-record
description: Record a client approval result into approvals.yaml with full metadata (approver, date, evidence reference). Lead agent client-success-lead.
---

# /approval-record

## Purpose

Capture the client's approval response — whether approve / reject / request changes — into `approvals.yaml` formally. This is the single source of truth that the deploy-blocking hook (`pre-deploy-approval-check.sh`) consults.

## When to Use

- When a client responds to an `/approval-request`
- When a verbal/meeting approval is given (transcribe and record)
- When a change-order is approved

## Lead Agent

**client-success-lead** records. **delivery-director** verifies completeness.

## Inputs

- Client response (mail / call notes / meeting minutes)
- The original `approval-request` mail / `approvals.yaml` pending entry
- Evidence reference (mail thread URL, meeting minutes path, recording timestamp)

## Process

1. Identify the pending approval entry by `id` in `approvals.yaml`
2. Update with client's response:
   - `status: approved | rejected | needs_revision`
   - `approver`: name + role
   - `approved_at`: ISO date
   - `evidence_reference`: where the approval was given
   - `notes`: free-form context (e.g., "Y 案で確定", "色を 3 案中 2 案に絞る指示")
3. If `needs_revision`: keep entry open and create a follow-up loop
4. If `approved`: phase-gate can proceed
5. If `rejected`: escalate to delivery-director / studio-director / Shin

## Outputs

- `00-engagement/approvals.yaml` updated entry

## Example Output (YAML excerpt)

```yaml
approvals:
  - id: APV-001
    type: proposal
    target_artifact: 00-engagement/proposal-v1.pdf
    requested_at: 2026-04-30
    requested_by: shin@aileap.example
    approver: 田中 太郎(代表取締役)
    approver_email: tanaka@example.com
    status: approved
    approved_at: 2026-05-02
    evidence_reference: 00-engagement/correspondence/2026-05-02_approval-mail.txt
    notes: |
      パターン C(リテイナー)で進行。SOW 締結後にキックオフ。
      「金額レンジ A 案で確定」とのコメントあり。

  - id: APV-002
    type: requirements
    target_artifact: 00-engagement/requirements-v0.md
    status: needs_revision
    notes: |
      「ペルソナを 2 名から 3 名に増やしたい」「事業領域 X を追加してほしい」
      → ux-strategy-lead に修正依頼、APV-002b を新規発行予定
```

## Boundary Notes

- Always include evidence reference — protects both AILEAP and client
- Verbal approvals must have transcript (meeting minutes / call notes) attached
- Email approvals: keep full mail thread, not just the approving line

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.1
