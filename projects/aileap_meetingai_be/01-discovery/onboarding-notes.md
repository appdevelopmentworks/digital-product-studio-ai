# キックオフ議事録 — AILEAP MeetingAI β版 BE + 管理画面

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**日時**: 2026-08-01 10:00-12:00
**形式**: 内部キックオフ(B 系・product-director 主導)
**参加者**:
- Shin(クライアント役 + プロダクト責任者 + PMF 判断者)
- studio-director
- **product-director(B 系・本格起動の主担当)**
- delivery-director
- **product-manager(B 系・新規)**
- technology-director
- backend-lead
- **backend-engineer(B 系・新規)**
- **devops-engineer(B 系・新規)**
- **qa-engineer(B 系・新規)**
- client-success-lead(議事録)

> Phase I-B 検証案件のため、handoff-protocols.md §8.3(自社プロダクト案件)のフローに従い、apex 経由ではなく Shin 直接依頼として起動。

---

## アジェンダ

1. プロジェクトの背景と目的(LP 申込み → β版本体提供)
2. 案件タイプ判定(B1 SaaS MVP に確定)
3. B 系新規エージェント 5 体の役割確認
4. スプリント運営方針(2 週間 × 4)
5. PMF Gate のタイミング(Week 4)
6. 技術スタック方針
7. WMAO 引継ぎ方針(none scope)
8. 関連 DEC 起案

---

## 決定事項(D{n} → DEC-NNN マッピング)

| # | 決定内容 | DEC ID | mirror? |
|---|---|---|---|
| D1 | 案件タイプ B1 SaaS MVP で確定 | DEC-001 | ✅ |
| D2 | スプリント長 2 週間 × 4 = 8 週間 | DEC-002 | ✅ |
| D3 | PMF Gate を Week 4(Sprint 03 着手前)に設定 | DEC-003 | ✅ |
| D4 | 技術スタック: Next.js 14 + Supabase + Vercel | DEC-004 | ✅ |
| D5 | 認証は招待制 + magic link(パスワードレス) | DEC-005 | ✅ |
| D6 | 録音処理は async(キュー経由) | DEC-006 | ✅ |
| D7 | WMAO 引継ぎを none scope に確定 | DEC-007 | ✅ |

DEC-001 ~ DEC-007 を decisions.yaml に反映。

---

## 役割確認(B 系新規 5 体)

| エージェント | 主担当ファイル / アクション |
|---|---|
| product-director | product-strategy / product-roadmap / PMF Gate(Week 4)/ apex 受領で Tier 1 同時起動 |
| product-manager | sprint-plans/sprint-01〜04 / backlog.yaml / 週次進捗 |
| backend-engineer | api-spec / database-schema / 実コード(API + DB + 認証) |
| devops-engineer | infra-plan / CI/CD / Vercel + Supabase 設定 / 監視 |
| qa-engineer | e2e-test-plan / 統合テスト / リグレッション |

---

## アクションアイテム

| # | 内容 | 担当 | 期限 |
|---|---|---|---|
| A1 | product-discovery 起案 | product-director | 2026-08-08 |
| A2 | requirements-v0 起案 | product-manager + product-director | 2026-08-08 |
| A3 | product-strategy + product-roadmap 起案 | product-director | 2026-08-15 |
| A4 | user-stories 起案(backlog 初期化) | product-manager | 2026-08-15 |
| A5 | api-spec + database-schema 起案 | backend-engineer | 2026-08-15 |
| A6 | infra-plan 起案 | devops-engineer | 2026-08-15 |
| A7 | e2e-test-plan 起案 | qa-engineer | 2026-08-15 |
| A8 | Sprint 01 計画 | product-manager | 2026-08-16 |
| A9 | 弁護士確認手配(privacy 拡張 + terms 新規) | delivery-director | 2026-08-12 |

---

## パーキングロット(将来検討)

- チーム / ワークスペース機能(v1.5)
- Slack / Teams 連携(v1.5)
- SSO(v2.0)
- 課金機能(正式版)
- モバイルアプリ(将来)
- en 化(海外展開時)

---

## 次回打合せ

- 2026-08-08(土)10:00-11:00:Discovery レビュー(product-discovery + requirements + 弁護士手配状況)
- 2026-08-15(土)10:00-12:00:Strategy + Design レビュー(product-strategy + roadmap + api-spec + DB schema + infra-plan + e2e-plan)
- 2026-08-16(日):Sprint 01 計画
- 2026-09-13(日):**Week 4 PMF Gate**(product-director 主担当)
- 2026-09-26(土):Sprint 03 完了レビュー
- 2026-10-04(日):Launch 判定
- 2026-11-04(水):Phase 5 完了 + 30 日レポート

---

## Phase I-B 検証メモ

本キックオフの検証観点(/meeting-minutes G-H5 確認プロンプト動作確認):

1. **B 系新規 5 体の動員パターン**:
   - product-director / product-manager は本キックオフで初登場
   - backend-engineer / devops-engineer / qa-engineer は backend-lead 配下として登場
   - → 動員パターン OK
2. **/meeting-minutes の decisions.yaml 連携プロンプト**:
   - D1〜D7 の 7 件に対する確認プロンプトが動作 → ✅ Shin 確認済み
3. **handoff-protocols.md §8 B 系受領フロー**:
   - apex 経由ではなく Shin 直接依頼 → §8.3(自社プロダクト)フロー適用 OK
   - product-director を Tier 1 受領担当に追加 → §8.1 通り

---

**Document Owner**: client-success-lead
**Last Updated**: 2026-08-01
**Version**: 1.0
