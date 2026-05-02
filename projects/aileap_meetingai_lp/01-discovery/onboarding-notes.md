# キックオフ議事録 — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**日時**: 2026-06-01 14:00-15:00
**形式**: 内部キックオフ(Shin がクライアント役兼任)
**参加者**:
- Shin(クライアント役 + プロダクト責任者・MeetingAI)
- studio-director(本組織 Tier 0)
- delivery-director(本組織 Tier 1)
- client-success-lead(本組織 Tier 2 / A2 では UX 系の主担当兼任)
- art-direction-lead(aileap_v2 デザイン継承担当として参加)
- copywriter(LP の主役)
- (録音にて client-success-lead が議事録化)

> Phase I-A 検証案件のため、自社内部で apex を経由しない疑似キックオフ。

---

## アジェンダ

1. プロジェクトの背景と目的の確認
2. 案件タイプ判定(A2 で確定)
3. スコープ確認(2 ページ + フォーム)
4. デザインシステム継承方針(aileap_v2 から)
5. スケジュール感
6. 関連 DEC 起案

---

## 決定事項(D{n} → DEC-NNN マッピング)

| # | 決定内容 | DEC ID | mirror? |
|---|---|---|---|
| D1 | 案件タイプ A2(LP)で確定 | DEC-001 | ✅ |
| D2 | 多言語(en)対応はスコープアウト | DEC-002 | ✅ |
| D3 | aileap_v2 デザインシステムを継承(差分のみ Document 化) | DEC-003 | ✅ |
| D4 | commercial-manager は internal mode で動作 | DEC-004 | ✅ |
| D5 | フォームスタックは aileap_v2 と同一(Resend + reCAPTCHA) | DEC-005 | ✅ |
| D6 | プライバシーポリシーは aileap_v2 統合運用 | (legal-review.yaml で記録) | — |

D1〜D5 は decisions.yaml に DEC-001 〜 DEC-005 として反映済。

---

## アクションアイテム

| # | 内容 | 担当 | 期限 |
|---|---|---|---|
| A1 | requirements-v0 起案 | client-success-lead | 2026-06-02 |
| A2 | 内部見積 | commercial-manager | 2026-06-02 |
| A3 | コピー初稿(コアメッセージ + FAQ) | copywriter | 2026-06-12 |
| A4 | デザイン差分設計 | art-direction-lead + ui-designer | 2026-06-10 |
| A5 | 実装着手 | frontend-engineer | 2026-06-11 |
| A6 | 公開判定 | delivery-director | 2026-06-29 |

---

## パーキングロット(将来検討)

- MeetingAI 正式版(課金開始)時の特商法ページ追加
- en 化(海外展開時)
- ウェビナー連動 LP(プロダクトローンチ後)
- A/B テスト導入(Phase 5 後)

---

## 次回打合せ

- 2026-06-08(月)15:00-16:00:戦略レビュー(sitemap + コンテンツ戦略 + コピー初稿)
- 2026-06-15(月)15:00-16:00:デザイン差分レビュー
- 2026-06-26(金):公開前最終レビュー

---

## Phase I-A 検証メモ

本キックオフの検証観点:

1. **A2 軽量フローの動員エージェント確認**: ux-strategy-lead 不在で client-success-lead が UX 系を兼任できるか
   → 動作確認 OK(本議事録の参加者構成で問題なし)
2. **aileap_v2 との横連携**: art-direction-lead が aileap_v2 デザインシステムを継承できるか
   → DEC-003 で正式承認 + design-notes.md で差分のみ記述する形で動作確認予定
3. **/meeting-minutes スキルの確認プロンプト**: G-H5 で追加した「決定事項を decisions.yaml に追記する確認プロンプト」が動作したか
   → ✅ D1〜D5 すべて Shin の確認を経て decisions.yaml に追記(動作確認 OK)

---

**Document Owner**: client-success-lead
**Last Updated**: 2026-06-01
**Version**: 1.0
