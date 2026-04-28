---
name: scope-check
description: Compare in-progress deliverables against SOW to detect scope deviations. Outputs severity-tagged report; deviations may trigger /change-order. Lead agent commercial-manager.
---

# /scope-check

## Purpose

Detect scope creep / drift / blockers by comparing what's being built against what was contracted. Run periodically and at every phase gate.

## When to Use

- Before each phase gate
- When a client request feels ambiguous (boundary check)
- When team velocity diverges from estimate (creep symptom)
- Mid-Implementation phase, weekly cadence

## Lead Agent

**commercial-manager** is the primary owner. Cross-consult Practice Directors when deviations affect their domains.

## Inputs

- `projects/{id}/00-engagement/sow.md` (the contract)
- `projects/{id}/00-engagement/requirements-v0.md` (originally agreed scope)
- `projects/{id}/00-engagement/change-orders/` (formally added scope)
- Current `02-strategy/`, `03-design/`, `04-implementation/` artifacts
- Recent meeting minutes + correspondence

## Process

1. Read SOW + approved change orders → form "Approved Scope" baseline
2. Survey current artifacts and in-progress work
3. Identify deviations:
   - **Critical (substantially out of scope)**: Requires immediate change order or work-stop
   - **High (creep — would require change order if continued)**: Surface to client now
   - **Medium (minor expansion within SOW spirit)**: Note but no formal change yet
   - **Low (negligible)**: Note only
4. For each Critical/High deviation, propose:
   - Stop work and wait for change order
   - Or generate change order pre-emptively
5. Output report

## Outputs

- `projects/{id}/00-engagement/scope-check-{date}.md` (Japanese)

## Example Output (Japanese excerpt)

```markdown
# スコープチェック報告

**案件**: <project-id>
**チェック日**: 2026-06-25
**作成者**: commercial-manager

## サマリー

承認済スコープ: SOW v1 + CO-20260620-001(英語版追加)
逸脱: Critical 0 / High 1 / Medium 2 / Low 1

## 逸脱詳細

### [High] アニメーション要件の拡張

**承認スコープ**:
ヒーローセクションのフェードイン・パララックスのみ。

**現状**:
ui-designer のデザイン提案で全セクションにスクロール連動アニメが
含まれており、frontend-engineer が実装を始めている。

**影響**:
工数 +12h(120,000 円相当)
Lighthouse Performance リスク(現状 92 → 86 まで落ちる可能性)

**推奨**:
本日中に作業停止 → クライアント確認:
1. ヒーローのみで OK → スコープ縮小
2. 全セクション維持 → /change-order 発行(120,000 円追加)

### [Medium] お問合せフォームの追加項目

(以下省略)
```

## Boundary Notes

- Scope-check is read-only; doesn't author change orders directly — that's `/change-order`
- Critical deviations require work-stop until resolved
- Use this to protect both AILEAP (margin) and client (no surprises)

## Reference Documents

- `docs/templates/sow.md`
- `docs/pricing-strategy.md` Section 2.3
