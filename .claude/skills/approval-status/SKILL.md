---
name: approval-status
description: Visualize the project's approval state — what's pending, approved, or blocking phase progression. Surface to delivery-director and Shin. Lead agent client-success-lead.
---

# /approval-status

## Purpose

Show at-a-glance state of all approvals for a project. Used at every phase gate and on demand.

## When to Use

- Before each phase-gate check (delivery-director consults)
- Before deploy attempt (the `pre-deploy-approval-check.sh` hook reads this state)
- When the client asks "what's the status?"
- Weekly status report to Shin

## Lead Agent

**client-success-lead** generates. **delivery-director** consumes for gate checks.

## Inputs

- `00-engagement/approvals.yaml`
- Project current phase from `PROJECT.md`

## Process

1. Read `approvals.yaml`
2. Categorize entries by status (approved / pending / needs_revision / rejected)
3. Identify blockers — pending approvals that block current or next phase
4. Generate status table

## Outputs

- Status table (Markdown / printed to terminal)
- Optionally written to `00-engagement/approval-status-{date}.md`

## Example Output (Japanese excerpt)

```markdown
# 承認ステータス報告

**案件**: <project-id>
**確認日**: 2026-06-15
**現在フェーズ**: Implementation

## サマリー

承認: 3 件 / 保留: 1 件 / 却下: 0 件 / 修正中: 1 件

## 承認済み(続行可)

| ID | 種別 | 対象 | 承認者 | 承認日 |
|---|---|---|---|---|
| APV-001 | proposal | proposal-v1.pdf | 田中 太郎 | 2026-05-02 |
| APV-002 | requirements | requirements-v1.md | 田中 太郎 | 2026-05-08 |
| APV-003 | design | design-system.md + screens | 田中 太郎 | 2026-06-01 |

## 保留中(要追跡)

| ID | 種別 | 対象 | 期限 | 経過日数 |
|---|---|---|---|---|
| APV-004 | content | initial-articles-batch1.md | 2026-06-20 | 7 日経過 |

→ 2026-06-20 までにご回答いただけない場合、launch スケジュールに影響します。
本日中に client-success-lead からリマインドメールを送付推奨。

## 修正中(差戻し対応中)

| ID | 種別 | 対象 | 修正内容 |
|---|---|---|---|
| APV-002b | requirements | requirements-v1.1.md | ペルソナ 3 名 + 事業領域 X 追加 |

## ブロッカー警告

⚠️ APV-005(launch 承認)未提出
- 期限: 2026-07-25(launch 予定 2026-08-01 から逆算)
- 担当: client-success-lead が 2026-07-15 までに /approval-request 発行予定

## 推奨アクション

1. APV-004 を本日中にリマインド
2. APV-002b の修正版完成は ux-strategy-lead 担当・2026-06-18 完了見込
3. APV-005 発行準備を 2026-07-10 までに
```

## Boundary Notes

- Status report is read-only — no actions are taken; just visibility
- Blockers should also surface in `decisions.yaml` if non-trivial
- For internal AILEAP projects: simplified internal-status (Shin self-approves)

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.1
- `pre-deploy-approval-check.sh` hook (consumes approvals.yaml directly)
