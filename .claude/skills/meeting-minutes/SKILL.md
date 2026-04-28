---
name: meeting-minutes
description: Convert recording / notes into structured meeting minutes. Captures participants, agenda, decisions (auto-mirrored to decisions.yaml), action items, parking lot. Lead agent client-success-lead.
---

# /meeting-minutes

## Purpose

Produce structured meeting minutes from raw transcript / notes / recording. Captures the truth of what was discussed and decided, so all agents share the same client-context.

## When to Use

- After every client meeting (kickoff, review, status, etc.)
- After internal meetings that involve decisions affecting the project

## Lead Agent

**client-success-lead** is the sole owner.

## Inputs

- Raw transcript / notes / recording timestamp
- Meeting metadata (date, participants, agenda)
- Project ID

## Process

1. Identify meeting metadata (date, participants, location/format)
2. Identify agenda items discussed
3. Extract decisions:
   - Each decision → record in minutes
   - Each significant decision → also append to `decisions.yaml`
4. Extract action items with owner and deadline
5. Note open questions / parking-lot items
6. Schedule next meeting if mentioned

## Outputs

- `00-engagement/meetings/YYYY-MM-DD_<topic>.md` (Japanese)
- Updates to `00-engagement/decisions.yaml` if significant decisions made

## Example Output (Japanese excerpt)

```markdown
# 議事録 — キックオフミーティング

**案件**: <project-id>
**日時**: 2026-05-02 15:00-16:30
**形式**: オンライン(Zoom)
**参加者**:
- 田中 太郎(代表取締役・クライアント側)
- 佐藤 花子(マーケ責任者・クライアント側)
- Shin(AILEAP)
- (録音にて client-success-lead が議事録化)

## アジェンダ

1. プロジェクトの背景と目的の再確認
2. 想定スコープの擦り合わせ
3. 既存サイトの課題ヒアリング
4. 必要素材のご相談
5. 次回打合せの設定

## 決定事項

| # | 決定内容 | 担当 |
|---|---|---|
| D1 | プロジェクトタイプ A1(コーポレートサイト)で確定 | studio-director |
| D2 | 多言語対応(日英)を初期から含める | localization-specialist 動員 |
| D3 | KGI: 月間問合せ件数 30 件(現在 5 件)、目標時期 6 ヶ月 | strategy-director |
| D4 | 既存 WordPress を維持しつつ、テーマを刷新する方針 | technology-director |

(D1-D4 は decisions.yaml にも反映済)

## アクションアイテム

| # | 内容 | 担当 | 期限 |
|---|---|---|---|
| A1 | 競合 5 社リスト共有(クライアント候補先) | 田中様 | 2026-05-08 |
| A2 | 既存サイトの GA4 / GSC アクセス権付与 | 佐藤様 | 2026-05-05 |
| A3 | ロゴデータ(SVG / PNG)送付 | 佐藤様 | 2026-05-10 |
| A4 | 提案書 v1 作成・送付 | Shin / commercial-manager | 2026-05-12 |

## パーキングロット(次回以降検討)

- 中国語版・韓国語版を Phase 2 で追加するか
- 月額保守(Retainer)の具体的内容をいつ詰めるか
- 撮影パートナーの紹介可否(田中様より「検討したい」とのこと)

## 次回打合せ

2026-05-15(木)15:00-16:00
- アジェンダ:競合分析結果、要件定義書 v0 のレビュー、提案書 v1 ご確認
```

## Boundary Notes

- Decisions of significance → also append to `decisions.yaml`
- Sensitive client communication (financials, internal staff issues) → mark `confidential: true` in YAML
- Do NOT include verbatim transcripts in minutes — distill to substance

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.2
- `docs/agent-coordination-map.md` Section 14.2
