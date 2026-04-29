---
description: approvals.yaml manages the client approval state machine. Status transitions (pending → approved/rejected) must follow strict rules. Approvals gate deploy via pre-deploy-approval-check.sh.
globs:
  - "projects/**/00-engagement/approvals.yaml"
  - "projects/**/approvals.yaml"
alwaysApply: false
---

# Approval Gate — approvals.yaml State Machine

Reference: `docs/requirements-v0.2.md` Section 10 (C-1~C-4 fix)

## Purpose

`approvals.yaml` is the authoritative record of client approvals. It gates:
- Phase transitions (e.g., design → implementation requires design_approval)
- Deployment (pre-deploy-approval-check.sh enforces launch_approval)

## State Machine

```
[created] → pending → approved
                  ↘ rejected → (revised) → pending (re-submit cycle)
                  ↘ waived   (delivery-director decision, must log in decisions.yaml)
```

Valid `status` values: `pending` | `approved` | `rejected` | `waived`

**Transitions allowed:**
- `pending` → `approved` (client signs off)
- `pending` → `rejected` (client requests changes)
- `rejected` → `pending` (re-submitted after revision)
- Any → `waived` (delivery-director only, must have decisions.yaml entry)

**Transitions NOT allowed:**
- `approved` → `rejected` (cannot un-approve; raise a change order instead)
- `approved` → `pending` (cannot reset; raise a change order)

## Required Approval Types (per project lifecycle)

| Type | Required before | Gating hook |
|---|---|---|
| `design_approval` | Implementation phase start | pre-deploy-approval-check.sh |
| `content_approval` | Staging phase start | pre-deploy-approval-check.sh |
| `launch_approval` | Production deploy | pre-deploy-approval-check.sh |

Additional optional types: `wireframe_approval`, `prototype_approval`, `estimate_approval`

## Full Schema

```yaml
# 00-engagement/approvals.yaml
project_id: AXYZ-20260601-001

approvals:
  - id: APV-001
    type: design_approval               # required type (see table above)
    status: pending                     # pending | approved | rejected | waived
    subject: "デザインシステム v1 承認依頼"  # human-readable subject
    requested_by: art-direction-lead    # agent that requested approval
    requested_at: 2026-06-10
    artifact_refs:                      # what is being approved
      - "03-design/design-system.md"
      - "03-design/screens/home.md"
    approved_by: null                   # client name (fill when approved)
    approved_at: null                   # ISO date (fill when approved)
    approval_method: null               # email | meeting | written | verbal+followup
    notes: ""
    revision_history: []
```

## Revision History (for rejected approvals)

```yaml
revision_history:
  - round: 1
    status: rejected
    rejected_at: 2026-06-12
    rejected_by: 田中 太郎
    feedback: "ヘッダーの色をブランドカラーに合わせてほしい"
    revised_at: 2026-06-14
    revised_by: art-direction-lead
  - round: 2
    status: approved
    approved_at: 2026-06-16
    approved_by: 田中 太郎
    approval_method: email
```

## Rules for Writing to approvals.yaml

1. **Never set `status: approved` unilaterally** — only when confirmed by client
2. **Always add `approval_method`** when setting approved — document how approval was received
3. **Do NOT delete rejected entries** — append to `revision_history`
4. **Add corresponding decision** — significant approval events warrant a `DEC-NNN` in decisions.yaml
5. **One approval per deliverable version** — if deliverable is revised after approval, create a new APV

## Approved → Change Required Pattern

If a client wants changes AFTER approval:
- Do NOT change existing `approved` entry
- Create a Change Order (`/change-order` skill)
- The CO process creates a new approval request for the change scope
