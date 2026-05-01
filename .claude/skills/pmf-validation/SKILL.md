---
name: pmf-validation
description: Run a structured PMF (Product-Market Fit) validation for a B-series project — capture hypothesis, evidence (signals + anti-signals), decision (continue / pivot / kill), and the next gate. Lead agent product-director (Tier 1, full activation v0.3).
auto_trigger_keywords:
  - PMF
  - product-market fit
  - PMF 検証
  - プロダクト判断
  - pivot
  - go/no-go
  - PMF validation
  - プロダクト戦略レビュー
---

# /pmf-validation

## Purpose

Apply structured PMF (Product-Market Fit) validation to a B-series project at scheduled gates. Avoid "vibes-based" go/no-go calls by forcing hypothesis-evidence-decision discipline.

The output is a decision document, not a forecast. Decisions are: **continue** (current trajectory), **pivot** (change a key dimension), or **kill** (stop and reallocate).

## When to Use

- Pre-launch (validate the launch hypothesis before deploy)
- Week-4 post-launch (mandatory — first PMF gate after live)
- Quarterly thereafter for active B-series products
- AILEAP internal products at every roadmap revision
- When product-director or Shin requests an evidence-backed reassessment

## Lead Agent

**product-director** is the sole owner. **product-manager** provides sprint-data context. **strategy-director** cross-consults on go-to-market signals. **Shin** has final authority on pivot / kill decisions.

## Inputs

- Active B-series project's `02-strategy/product-strategy.md` (current strategy)
- `02-strategy/product-roadmap.md` (current roadmap)
- `04-implementation/weekly-progress-*.md` (sprint signals)
- `07-post-launch/*.md` (if post-launch — actual usage data)
- External signals: GA4 / GSC / user interviews / support tickets / churn data

## Process

### 1. State the current hypothesis

Pull the value hypothesis from `product-strategy.md` and restate it crisply:

```
Hypothesis: <Target user> will <do action> because <reason>, validated by <metric reaching threshold> within <timeframe>.

Example:
Hypothesis: SME marketing managers will use AILEAP MeetingAI to generate
meeting summaries because manual minute-taking takes 30+ min/week,
validated by 50% of trial users continuing past day 14, within 8 weeks of launch.
```

If the hypothesis cannot be restated in this form, the PMF gate fails before evidence collection — the strategy document is too vague.

### 2. Collect signals (positive evidence)

Document concrete observations that support the hypothesis:

- Quantitative: usage metrics, retention curves, feature engagement, time-to-value, NPS
- Qualitative: user interviews, support ticket sentiment, organic word-of-mouth, sales call transcripts

Each signal must include:
- Source (e.g., GA4 event, interview log path, ticket #)
- Date observed
- Strength (strong / moderate / weak)

### 3. Collect anti-signals (disconfirming evidence)

This step is mandatory and often skipped. Document evidence **against** the hypothesis:

- Users who cancelled / churned
- Activation funnel drop-offs
- Negative interview feedback
- Competitor's stronger position
- Internal team's expressed doubts

If you cannot list any anti-signals, you are not looking — restart the step.

### 4. Apply the decision rule

| Signals | Anti-signals | Decision |
|---|---|---|
| Strong + corroborated by 2+ independent sources | Few / minor | **Continue** — invest in current trajectory |
| Mixed: strong on adoption, weak on retention | Significant on retention | **Pivot** — change the retention model (pricing, onboarding, value loop) |
| Weak + isolated | Strong + corroborated | **Pivot or Kill** — escalate to Shin |
| Insufficient evidence (too early) | n/a | **Continue + define next gate** — set the next checkpoint with clearer success criteria |

The decision rule is a starting point. Document any deviation with rationale.

### 5. Write the decision

Output `projects/{id}/02-strategy/pmf-review-{YYYYMMDD}.md`:

```markdown
# PMF レビュー — {YYYY-MM-DD}

**案件**: {project-id}
**レビュー実施**: product-director
**承認**: Shin
**判定**: ✅ Continue / ⚠️ Pivot / ❌ Kill

## 仮説の再宣言

ターゲットユーザー: <<...>>
取る行動: <<...>>
理由: <<...>>
検証指標: <<...>> が <<閾値>> に達する
時間軸: <<...>>

## ポジティブシグナル

| # | 内容 | 出典 | 観察日 | 強度 |
|---|---|---|---|---|
| S1 | 起動 7 日後の継続率 65% | GA4 / cohort.csv | 2026-09-15 | 強 |
| S2 | ユーザー 8 名中 6 名が「他に代替がない」と発言 | interviews/2026-09-W2.md | 2026-09-12 | 強 |
| S3 | ... | | | |

## アンチシグナル

| # | 内容 | 出典 | 観察日 | 強度 |
|---|---|---|---|---|
| A1 | 月額プランの継続率 35%(目標 50%) | Stripe ダッシュボード | 2026-10-01 | 強 |
| A2 | ... | | | |

## 判定とロジック

(決定ルールに照らした判定の根拠を 200-400 字で記述)

## 次のゲート

- 再評価日: 2026-12-01
- 期日までに達成すべき指標:
  - 月額継続率 50% 以上
  - 週次アクティブユーザー 100 名
- 達成しない場合: 月額プランの構造変更(2 段階課金 vs フリーミアム)を検討
```

### 6. Append decision log

If the decision is `Pivot` or `Kill`, append a `DEC-NNN` to `decisions.yaml`:

```yaml
- id: DEC-NNN
  date: 2026-10-01
  type: pmf_pivot
  context: |
    PMF レビュー結果として月額プラン構造を変更する判断
  decided_by:
    - product-director
    - Shin
  evidence_ref: 02-strategy/pmf-review-20261001.md
  related_files:
    - 02-strategy/product-strategy.md (改訂予定)
    - 02-strategy/product-roadmap.md (改訂予定)
  reversible: true
```

## Outputs

- `projects/{id}/02-strategy/pmf-review-{YYYYMMDD}.md` (Japanese)
- New `DEC-NNN` entry in `decisions.yaml` if pivot or kill
- Updated `02-strategy/product-strategy.md` and `product-roadmap.md` if pivot

## Boundary Notes

- This skill is for **B-series projects only**. A-series websites have a different success model (KGI for the client, not PMF).
- Internal AILEAP products use this skill identically. Internal mode does not relax the discipline.
- The decision is product-director's; Shin has override on pivot / kill.
- Do NOT mark Continue without listing at least 2 anti-signals you considered.
- Do NOT mark Kill without proposing the resource reallocation plan in the decision.

## Reference Documents

- `docs/pricing-strategy.md §4.5` (internal AILEAP product handling)
- `.claude/agents/tier1-product-director.md` (lead agent definition)
- `.claude/agents/tier2-product-manager.md` (provides sprint context)
