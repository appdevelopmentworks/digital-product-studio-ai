# 業務範囲合意書(SOW)— AILEAP MeetingAI β版 BE + 管理画面

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0(internal)
**作成日**: 2026-08-01
**作成者**: delivery-director / commercial-manager / product-director
**ステータス**: 承認済(APV-002・自社内部)

> 自社案件 + B 系のため通常 SOW より検証フォーカス。internal mode。

---

## 1. 業務範囲

### 1.1 対象スコープ(MVP)

- β版申込み管理画面(管理者用)
- β版ユーザー認証(招待制 + メールリンクのみ・パスワードレス)
- 会議録音アップロード API(.mp3 / .m4a / .wav 対応・最大 1GB)
- 会議要約 API(LLM ラッパー)
- 議事録 PDF 生成
- β版利用統計ダッシュボード(管理者向け)
- 最小限のユーザー Web UI(録音アップロード + 議事録閲覧)

### 1.2 対象外(明示的にスコープアウト)

- チーム / ワークスペース機能(個人ユーザー想定で v1.5 以降)
- Slack / Teams 連携(v1.5 以降)
- SSO(v2.0)
- 課金機能(正式版から)
- モバイルアプリ(Web のみ)
- 多言語(en / zh / ko)対応

---

## 2. フェーズ構成(B 系・スプリント運営)

| フェーズ | 期間 | 主成果物 |
|---|---|---|
| Engagement | 2026-08-01 ~ 08-04(4 日) | apex-handoff / 要件確定 / 見積 |
| Discovery + Strategy | 2026-08-05 ~ 08-15(10 日) | product-discovery / product-strategy / product-roadmap |
| Sprint 01 | 2026-08-16 ~ 08-29(2 週) | インフラ + 認証 + 基本 CRUD |
| Sprint 02 | 2026-08-30 ~ 09-12(2 週) | 録音 upload + Whisper 統合 |
| Sprint 03 | 2026-09-13 ~ 09-26(2 週) | LLM 要約 + 議事録 PDF |
| ★ PMF Gate(Week 4 相当)| 2026-09-13(Sprint 03 着手前) | product-director 判断: continue / pivot / kill |
| Sprint 04 | 2026-09-27 ~ 09-29(3 日 - 短縮)| 管理画面 + 利用統計 |
| QA | 2026-09-30 ~ 10-04(5 日) | E2E + 統合テスト |
| Launch | 2026-10-05 | β版公開 |
| Phase 5 | 2026-10-05 ~ 11-04(30 日) | post-launch サポート + 30 日レポート |

合計: 約 2.5 ヶ月(B1 標準 3 ヶ月から圧縮)+ 公開後 30 日

---

## 3. 第5フェーズ(B 系特殊)

[handoff-protocols.md §8.5](../../../docs/handoff-protocols.md#85-b-系の-phase-5公開後-30-日の特殊扱い) の B 系 Phase 5 を実施:

- 公開直後の重大バグ修正(無償)
- Lighthouse / API レイテンシ再測定
- **Week 4 PMF Gate**(`/pmf-validation` 必須実行)
- 同 Gate で「continue / pivot / kill」を product-director が判断
- pivot / kill の場合は decisions.yaml 記録 + roadmap 改訂

本フェーズの工数(24h)は内部見積(320h)に含む。

## 4. WMAO 引継ぎ(B 系特殊・none scope)

handoff-protocols.md §8.4 に従い、本案件は **WMAO 引継ぎなし**(本組織内継続運用):

| 領域 | 担当 |
|---|---|
| プロダクト機能開発(継続) | 本組織(product-director / product-manager / backend-engineer 等) |
| インフラ運用 | 本組織(devops-engineer) |
| ユーザーサポート | 本組織(client-success-lead) |
| 集客・LP 改善 | aileap_meetingai_lp 案件側(WMAO に partial scope で引継ぎ済) |

WMAO は MeetingAI LP 経由の集客のみ担当(別案件)。

---

## 5. 主要承認(approvals.yaml)

| マイルストーン | 承認 ID | 承認者 |
|---|---|---|
| 要件定義 + product-strategy | APV-001 | Shin |
| 内部見積 | APV-002 | Shin |
| API 設計 + DB スキーマ承認(B 系特有)| APV-003 | Shin + product-director |
| Sprint 02 完了レビュー | APV-004 | Shin + product-director |
| **Week 4 PMF Gate**(continue 判断) | APV-005 | Shin(★ 必須・kill 時は本案件停止) |
| 公開判定 | APV-006 | Shin |
| (B 系のため WMAO 引継ぎ APV はなし) | — | — |

---

## 6. 工数(internal mode)

| フェーズ | 想定工数 |
|---|---|
| Engagement | 8h |
| Discovery + Strategy | 40h(product-discovery 16 + strategy 24) |
| API 設計 | 24h |
| Sprint 01-04 | 220h |
| QA | 20h |
| Launch + Phase 5 | 8h(Phase 5 は内部見積に含まれる別カウント) |
| **合計** | **320h** |

外部委託していたら相当の額(参考値): 450 万円(B1 SaaS MVP 標準 300-800 万円のレンジ低め)

---

## 7. リスク + 対策

| リスク | 影響 | 対応 |
|---|---|---|
| LLM API コスト超過 | 月額 5 万円想定を超過 | β版アクセス頻度に応じて段階的調整 / 必要なら usage cap |
| 要約精度が 4.0/5.0 を下回る | PMF gate kill 判断 | プロンプトチューニング 1 週間 + 再評価 |
| Whisper の日本語精度問題 | 要約品質低下 | Whisper API + 後処理で日本語訂正 |
| Vercel / Supabase 料金プラン超過 | 運用コスト増 | 月次レビュー / Pro プラン超過時は Enterprise 検討 |
| Shin の PMF gate 判断遅延 | リリース遅延 | Sprint 03 着手前に必ず実施(date 固定) |

---

## 8. 関連文書

- `00-engagement/apex-to-dpsai-handoff.yaml`(自社内部疑似ハンドオフ・product_specifics 含む)
- `00-engagement/estimate.yaml`(internal mode)
- `00-engagement/approvals.yaml`(6 件)
- `01-discovery/product-discovery.md`(product-director 主担当)
- `02-strategy/product-strategy.md`
- `02-strategy/product-roadmap.md`
- `03-design/api-spec.md`
- `04-implementation/sprint-plans/`

---

**Document Owner**: delivery-director / commercial-manager / product-director
**Last Updated**: 2026-08-01
**Version**: 1.0
