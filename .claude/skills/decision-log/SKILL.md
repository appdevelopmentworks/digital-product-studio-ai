---
name: decision-log
description: Append a structured entry to decisions.yaml with context, decided_by chain, impacted agents, related artifacts, escalation path. Lead agent client-success-lead.
---

# /decision-log

## Purpose

Capture significant decisions in a single source-of-truth format so all agents share the project's decision history. Eliminates "他のエージェントは知らなかった" miscoordination.

## When to Use

- After any significant decision (in meeting, async chat, or studio-director arbitration)
- When a Practice Director resolves a cross-Practice conflict
- When studio-director makes a final-arbitration call
- When Shin overrides a default

## Lead Agent

**client-success-lead** captures from meeting context. **studio-director** writes own arbitration entries. **delivery-director** verifies completeness for gate checks.

## Inputs

- Decision context (meeting minutes, message history, escalation thread)
- Project ID

## Process

1. Identify the decision substance:
   - Title (1-line)
   - Context (1-2 lines)
   - Decided by (chain — proposed by → approved by)
   - Impacted agents
   - Related artifacts (paths)
2. Append to `00-engagement/decisions.yaml`
3. If decision invalidates earlier decisions, mark earlier as `superseded_by: <new-id>`

## Outputs

- `00-engagement/decisions.yaml` updated

## Example Output (YAML excerpt)

```yaml
decisions:
  - id: DEC-001
    date: 2026-05-02
    title: 案件タイプを A1 コーポレートサイトで確定
    context: |
      apex から渡された戦略レポートでは「Web プロダクトが必要」とあったが、
      具体タイプ未指定。client-onboarding でクライアントとすり合わせ、
      A1(コーポレートサイト)で進めることで合意。
    decided_by:
      proposed: studio-director
      approved: shin
    impacted_agents:
      - studio-director
      - delivery-director
      - strategy-director
      - ux-strategy-lead
    related_artifacts:
      - 00-engagement/handoff-from-strategy.yaml
      - 00-engagement/meetings/2026-05-02_kickoff.md
    notes: 多言語(日英)対応も含むため localization-specialist 動員予定

  - id: DEC-005
    date: 2026-06-15
    title: ヒーローアニメーションを Reduce-Motion ベースで実装
    context: |
      ui-designer はパララックス強推奨、frontend-engineer は Lighthouse Performance
      90 維持の観点で懸念。creative-director ↔ technology-director の合議でも
      決まらず、studio-director に escalate。
    decided_by:
      escalated_to: studio-director
      proposed: studio-director
      approved: shin
    impacted_agents:
      - ui-designer
      - frontend-engineer
      - art-direction-lead
      - frontend-lead
    related_artifacts:
      - 03-design/screens/hero.md
      - 04-implementation/architecture-notes.md
    notes: |
      Lighthouse Performance 90 を保てる範囲で実装、
      Reduce-Motion 設定者には無効化。

  - id: DEC-009
    date: 2026-06-20
    title: 英語版追加の変更注文(CO-20260620-001)を承認
    context: クライアントから英語版追加要望、CO-20260620-001 にて 400,000 円追加。
    decided_by:
      proposed: commercial-manager
      approved: client (田中 太郎・APV-006)
    impacted_agents:
      - commercial-manager
      - localization-specialist
      - frontend-engineer
      - seo-geo-strategist
    related_artifacts:
      - 00-engagement/change-orders/CO-20260620-001.md
      - 00-engagement/approvals.yaml#APV-006
```

## Boundary Notes

- Only **significant** decisions go here — not every minor task assignment
- Decisions affecting client commitments or budgets must always be recorded
- Decisions that override earlier ones must explicitly link via `supersedes` or vice-versa `superseded_by`

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.2.3
- `docs/agent-coordination-map.md` Section 5.4
