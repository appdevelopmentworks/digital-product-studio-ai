---
name: sprint-plan
description: Author a sprint plan for a B-series project — convert backlog stories into committed sprint scope with capacity, definition of done, dependencies, and risks. Lead agent product-manager (Tier 2, new in v0.3). Default sprint length 2 weeks.
auto_trigger_keywords:
  - スプリント計画
  - sprint plan
  - スプリントプランニング
  - sprint planning
  - バックログ
  - backlog
  - 開発計画
  - 開発スプリント
---

# /sprint-plan

## Purpose

Convert the product backlog into a committed sprint plan. The output is a structured Markdown that the engineering Practice (backend-engineer / devops-engineer / qa-engineer + frontend-engineer when relevant) executes against.

Sprints are the cadence of B-series work. A-series (websites) does not use sprints — it uses fixed-phase workflows via `/team-{type}`.

## When to Use

- Day 1 of every sprint (B-series and internal AILEAP product projects)
- When mid-sprint scope adjustment is required (mid-sprint replan)
- When the backlog is freshly groomed and the next sprint's scope needs locking

## Lead Agent

**product-manager** is the sole owner. **backend-lead** signs off on engineering capacity. **product-director** reviews quarter-boundary sprints. **qa-engineer** confirms test plan coverage.

## Inputs

- `projects/{id}/04-implementation/backlog.yaml` — current backlog
- `projects/{id}/04-implementation/sprint-(NN-1)-retro.md` — previous sprint retro (velocity, learnings)
- `projects/{id}/02-strategy/product-roadmap.md` — current roadmap (so sprint serves a roadmap goal, not just velocity)
- Engineering capacity input (backend-lead): hours available across backend-engineer, devops-engineer, qa-engineer
- Optional: frontend-lead capacity if sprint includes UI work

## Process

### 1. Verify the backlog is groomed

Before planning, confirm `backlog.yaml::last_groomed` is within the last 7 days. If older, run grooming first (re-prioritize, refine acceptance criteria, re-estimate ambiguous items).

### 2. Pull velocity baseline

From the previous 3 sprints' retros, compute average completed-hours velocity. Use this as the capacity ceiling for the new sprint, not the theoretical maximum.

```
Velocity (last 3 sprints) = (completed_hours_N-1 + N-2 + N-3) / 3
```

If you have fewer than 3 sprints (early project), use a conservative 70% of theoretical capacity.

### 3. Select stories

Walk the backlog priority order. For each story:

- Confirm its acceptance criteria is testable
- Confirm dependencies (`blocked_by` field) are resolved
- Sum estimate_hours; stop when sum reaches velocity ceiling
- Reserve 15-20% capacity for unplanned defect fixes / scope clarification

### 4. Verify capacity per role

Backend-engineer / devops-engineer / qa-engineer each have a capacity number. Confirm the selected stories fit each role's capacity (no role is over-loaded while another is under-loaded).

If unbalanced, swap stories or surface the imbalance to backend-lead before committing.

### 5. Define the sprint goal

The goal is a 1-sentence statement of what the sprint achieves:

```
Sprint NN goal: ユーザーが新規登録 → 初回ログイン → ダッシュボードに到達できる
```

This is NOT a list of stories; it is the user-observable outcome. If you cannot phrase it in one sentence, the sprint is incoherent — re-select.

### 6. Define Done (sprint-level)

```
Definition of Done (Sprint NN):
- All committed stories' acceptance criteria pass
- All new code has unit + integration tests where applicable
- E2E tests for critical journeys still pass (no regression)
- All new code passes /code-review
- CI green on main branch
- Lighthouse + a11y checks pass for any UI surface touched
```

### 7. Identify risks

Document 2-5 risks that could derail the sprint:

- External dependencies (e.g., third-party API access pending)
- Capacity uncertainty (e.g., devops-engineer also on-call this week)
- Technical unknowns (first time using a library)
- Scope ambiguity in any committed story

For each risk, name the mitigation owner and the trigger to escalate.

### 8. Write the sprint plan

Output `projects/{id}/04-implementation/sprint-plans/sprint-NN.md`:

```markdown
# Sprint NN 計画

**案件**: {project-id}
**期間**: 2026-09-01 ～ 2026-09-14 (2 週間)
**作成者**: product-manager
**承認**: backend-lead, product-director

## ゴール

ユーザーが新規登録 → 初回ログイン → ダッシュボードに到達できる

## 容量

| 担当 | 計画工数 | 内訳 |
|---|---|---|
| backend-engineer | 28h | API + DB |
| devops-engineer | 12h | Auth インフラ + CI |
| qa-engineer | 16h | E2E + 認証回帰 |
| **合計** | **56h** | (前 3 スプリント平均 60h、安全係数適用後 56h) |

## コミットストーリー

| ID | タイトル | 担当 | 工数 | 受入条件 | Status |
|---|---|---|---|---|---|
| STORY-001 | ユーザー登録 | backend-engineer | 12h | (acceptance criteria 抜粋) | ready |
| STORY-002 | 確認メール送信 | backend-engineer | 6h | ... | ready |
| STORY-003 | ログインフロー | backend-engineer | 8h | ... | ready |
| STORY-004 | 認証 CI ゲート設定 | devops-engineer | 6h | ... | ready |
| STORY-005 | E2E 認証フローテスト | qa-engineer | 14h | ... | ready |
| **合計** | | | **46h** | | |

予備: 10h(15-20% バッファ — 未計画の defect / 仕様明確化対応)

## Definition of Done

(本スキル §6 と同じ — sprint-NN 固有の追加条件あれば記載)

## リスク

| # | 内容 | 緩和担当 | エスカレーション条件 |
|---|---|---|---|
| R1 | Auth.js v5 が初導入(学習コスト) | backend-engineer | 着手 3 日経過しても進捗なし → backend-lead |
| R2 | メール送信プロバイダ未確定 | devops-engineer | 着手前に確定要 → product-manager |

## カレンダー

| 日 | 主なイベント |
|---|---|
| Day 1 (Mon 9/1) | スプリント計画完了 / 着手 |
| Day 5 (Fri 9/5) | ミッドスプリントチェック |
| Day 10 (Wed 9/10) | コードフリーズ目標 |
| Day 14 (Sun 9/14) | スプリントレビュー + retro |
```

### 9. Capacity sign-off

Before publishing, get backend-lead's capacity sign-off (asynchronous OK — they reply with "approved" + any caveats). Without sign-off, the sprint is "draft" not "committed."

## Outputs

- `projects/{id}/04-implementation/sprint-plans/sprint-NN.md` (Japanese)
- Updates to `backlog.yaml`: committed stories' `status: in_progress` and `sprint: NN` fields
- Optional: weekly progress report template populated with Sprint NN stories

## Boundary Notes

- B-series projects only. A-series uses `/team-{type}` orchestrators, not sprints.
- product-manager owns scope decisions; product-director reviews at quarter boundaries (every ~6 sprints).
- Capacity sign-off from backend-lead is mandatory — over-committing erodes velocity trust.
- Sprint length is 2 weeks by default. Other lengths require product-director approval.
- Do NOT exceed velocity ceiling on the optimistic case ("we can do more this time"). Velocity is the average, not the maximum.

## Reference Documents

- `.claude/agents/tier2-product-manager.md` (lead agent definition)
- `.claude/agents/tier2-backend-lead.md` (capacity sign-off)
- `.claude/agents/tier1-product-director.md` (quarter-boundary review)
