---
name: meeting-minutes
description: Convert recording / notes into structured meeting minutes. Captures participants, agenda, decisions (auto-mirrored to decisions.yaml), action items, parking lot. Lead agent client-success-lead.
auto_trigger_keywords:
  - 議事録
  - meeting minutes
  - ミーティング記録
  - 会議録
  - 打ち合わせ
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
   - Each decision → record in minutes with a stable `D{n}` ID
   - Each significant decision → also append to `decisions.yaml` with a `DEC-NNN` ID
4. Extract action items with owner and deadline
5. Note open questions / parking-lot items
6. Schedule next meeting if mentioned
7. **decisions.yaml mirroring confirmation prompt (G-H5 v0.3 — mandatory)**:
   Before completing the skill, surface a structured confirmation prompt that
   lists every `D{n}` row from the minutes side-by-side with its proposed
   `DEC-NNN` mirroring intent, and ask the user to confirm. See §"decisions.yaml
   mirroring prompt" below.

## decisions.yaml mirroring prompt (mandatory)

After drafting the minutes but before writing the final files, present the
following confirmation prompt to the user. The user MUST explicitly approve,
modify, or skip each row before the skill writes anything to `decisions.yaml`.

```
以下の決定事項を 00-engagement/decisions.yaml に追記してよろしいですか?
(各行について「追記する / 追記しない / 修正してから追記」を選んでください)

| # | 議事録 ID | 決定内容(要約) | 提案 DEC ID | mirror? | 理由 |
|---|---|---|---|---|---|
| 1 | D1 | A1 案件で確定 | DEC-007 | ✅ 推奨 | プロジェクト基本構成 |
| 2 | D2 | 多言語(日英)を初期から | DEC-008 | ✅ 推奨 | スコープ確定 |
| 3 | D3 | KGI 月間問合せ 30 件 | DEC-009 | ✅ 推奨 | 経営目標と紐づく |
| 4 | D4 | WordPress 維持 | DEC-010 | ✅ 推奨 | 技術選定の固定 |
| 5 | D5 | 撮影パートナー検討 | -        | ❌ skip  | パーキングロット項目 |

選択肢:
  all-yes        全項目を提案通りに追記
  yes <番号>     指定番号のみ追記
  skip <番号>    指定番号を追記しない
  edit <番号>    DEC ID または内容を修正してから追記
  cancel         追記を全件中止(議事録のみ書き出し)
```

ルール:
- パーキングロット項目(まだ決定していない議題)は **mirror しない**(`skip`)
- アクションアイテムは decisions.yaml の対象外(別ロジックで管理)
- 同じ内容の DEC が既に存在する場合は新規発番ではなく既存 DEC への補足として扱う
- ユーザーが `cancel` を選んだ場合でも、議事録ファイルは書き出す

## Outputs

- `00-engagement/meetings/YYYY-MM-DD_<topic>.md` (Japanese)
- Updates to `00-engagement/decisions.yaml` if user approved mirroring (per the
  prompt above) — otherwise the minutes are written but decisions.yaml stays
  unchanged
- Inline note in the minutes: `(D1-D4 は decisions.yaml にも反映済 / D5 は
  パーキングロットのため未反映)` — fully transparent record of the mirroring
  decision

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
