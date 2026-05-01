---
name: asset-status
description: Visualize asset receipt state and generate reminder mail drafts for not-yet-received items. Lead agent client-success-lead.
auto_trigger_keywords:
  - 素材状態
  - asset status
  - 素材受領
  - 素材未着
  - 素材リマインド
---

# /asset-status

## Purpose

Track asset-receipt state and surface bottlenecks. If a phase blocks because an asset isn't received, the project halts — this skill makes that visible early.

## When to Use

- Weekly cadence during Discovery / Strategy / Design phases
- Before each phase gate (delivery-director consults)
- When an asset is overdue (>3 days past deadline)

## Lead Agent

**client-success-lead** generates. **delivery-director** consumes for gate checks.

## Inputs

- `01-discovery/assets-required.yaml`
- Project current phase from `PROJECT.md`
- Today's date

## Process

1. Read `assets-required.yaml`
2. Categorize:
   - Received (`received: true`)
   - Pending in-window (deadline > today)
   - Overdue (deadline < today, `received: false`)
   - Blocking-current-phase (deadline < today AND `blocker_for` ≤ current phase)
3. For overdue items, generate reminder mail drafts
4. Output status table

## Outputs

- Status table (Markdown)
- Reminder mail drafts (per overdue asset)
- Optionally `00-engagement/asset-status-{date}.md`

## Example Output (Japanese excerpt)

```markdown
# アセット受領ステータス

**案件**: <project-id>
**確認日**: 2026-06-10
**現在フェーズ**: Strategy

## サマリー

総数: 12 件 / 受領済: 7 件 / 期限内未受領: 3 件 / 期限超過: 2 件

## 受領済(7 件)

| ID | アセット | 受領日 |
|---|---|---|
| AST-001 | ロゴ(SVG / PNG) | 2026-05-08 |
| AST-002 | GA4 / GSC アクセス権 | 2026-05-04 |
| ... |

## 期限内未受領(3 件)

| ID | アセット | 期限 | 残日数 | ブロック対象 |
|---|---|---|---|---|
| AST-003 | チームメンバー写真 | 2026-06-01 | -9 日 | 04-implementation |
| AST-005 | プライバシーポリシー素案 | 2026-06-20 | +10 日 | 06-launch |
| AST-007 | 既存ブランドガイド | 2026-06-15 | +5 日 | 03-design |

## 期限超過(2 件)— 警告

### AST-003 チームメンバー写真(9 日超過)

ブロック対象: 04-implementation
影響: 実装フェーズで Author ページ生成不可

▼ リマインドメール案
```
件名: 【再送】チームメンバー写真ご提供のお願い

<決裁者氏名> 様

たびたび恐縮です。
プロジェクト進行に必要な「チームメンバー写真(5 名分)」が
6/1 の期限を 9 日経過しておりますが、まだお手元にございますでしょうか。

該当フェーズが間もなく開始されますため、お早めのご提供をお願いいたします。
撮影の手配が難しい場合、AILEAP 提携の撮影パートナーをご紹介可能です
(別途実費 〇〇 円〜)。

ご不明点ございましたら、ご返信ください。

何卒よろしくお願いいたします。
```

### AST-008 〇〇〇〇

(以下省略)

## ブロッカー警告

⚠️ AST-003 が 04-implementation を阻害する可能性が高い
→ 6/15 までに受領または代替手段確定が必要
```

## Boundary Notes

- Mail drafts are staged for Shin's review and send — never auto-send
- Repeated reminders should escalate tone (1st: gentle / 2nd: firmer / 3rd: escalate to delivery-director)
- For overdue assets blocking phase progression, suggest alternatives (e.g., AILEAP partner photographer)

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.3
- `docs/agent-roster.md` Section 4-6
