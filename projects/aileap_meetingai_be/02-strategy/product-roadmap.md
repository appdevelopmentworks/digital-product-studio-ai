# プロダクトロードマップ — AILEAP MeetingAI

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: product-director
**ステータス**: 承認済(APV-001 内)
**サイクル**: 3 ヶ月詳細 / 6 ヶ月テーマ別 / 12 ヶ月方向性

---

## 0. ロードマップ全体像

```
2026
├── Q3(本案件)
│   ├── 2026-08:Discovery + Strategy + Sprint 01-02
│   ├── 2026-09:Sprint 03 + PMF Gate(Week 4) + Sprint 04
│   └── 2026-10:QA + Launch(2026-10-05)+ Phase 5 開始
├── Q4(別案件・本組織内継続)
│   ├── 2026-11:Phase 5 完了(2026-11-04) + 30 日レポート
│   ├── 2026-12:正式版開発着手(チーム機能 + Slack 連携 + 課金)
│   └── 2027-01:正式版ローンチ予定

2027 Q1-Q2
├── SSO(SAML)対応
├── API 公開(法人向け)
└── 海外展開検討(en 化)

2027 H2
├── モバイルアプリ?(検討)
└── 業界特化機能(検討)
```

---

## 1. 3 ヶ月詳細(2026-08 ~ 10)

本案件のスコープ。詳細は `04-implementation/sprint-plans/` 参照。

### 1.1 Sprint 01(2026-08-16 ~ 08-29)

**テーマ**: インフラ + 認証 + 基本 CRUD

| 主要ストーリー | 担当 | 工数 |
|---|---|---|
| Supabase project 初期化 + RLS | devops-engineer + backend-engineer | 12h |
| Next.js + Supabase Auth(magic link) | backend-engineer | 16h |
| User / Invitation / Recording テーブル | backend-engineer | 8h |
| 招待発行管理画面 | backend-engineer + frontend-engineer | 12h |
| Vercel 本番環境設定 | devops-engineer | 6h |
| CI/CD(GitHub Actions)+ 環境変数管理 | devops-engineer | 6h |

**Sprint Review**: 2026-08-29(招待発行 + magic link 動作確認)

### 1.2 Sprint 02(2026-08-30 ~ 09-12)

**テーマ**: 録音 upload + Whisper 統合

| 主要ストーリー | 担当 | 工数 |
|---|---|---|
| 録音アップロード API + Supabase Storage | backend-engineer | 12h |
| Inngest ジョブキュー設定 | devops-engineer + backend-engineer | 8h |
| Whisper API 統合 + 文字起こし保存 | backend-engineer | 16h |
| ユーザー UI(録音 upload + 進捗表示) | frontend-engineer | 12h |
| E2E テスト基盤(qa-engineer) | qa-engineer | 8h |
| Sprint 02 demo + Shin レビュー | product-manager | 4h |

**Sprint Review**: 2026-09-12(録音 upload + Whisper 文字起こし完了)
**APV-004(Sprint 02 完了レビュー)**: 2026-09-12

### 1.3 ★ PMF Gate(2026-09-13)

**最重要マイルストーン**: product-director + Shin による PMF 判断

- 入力:Sprint 02 完了 + 5 名テストユーザー(社内)の文字起こし結果
- 評価:`/pmf-validation` スキル実行 → 06-handoff/pmf-validation-week-4.md
- 判断:continue / pivot / kill

DEC-008 として記録。

### 1.4 Sprint 03(2026-09-13 ~ 09-26)

**テーマ**: LLM 要約 + 議事録 PDF

| 主要ストーリー | 担当 | 工数 |
|---|---|---|
| Claude API 統合 + プロンプトチューニング | backend-engineer + product-director | 16h |
| 構造化議事録生成(JSONB)| backend-engineer | 8h |
| 議事録 PDF 生成(react-pdf or puppeteer) | backend-engineer | 12h |
| 議事録閲覧 UI | frontend-engineer | 12h |
| 通知メール(完了通知)| backend-engineer | 4h |
| E2E テスト(録音 → 要約 → PDF) | qa-engineer | 8h |

**Sprint Review**: 2026-09-26(録音 → 要約 → PDF が end-to-end 動作)

### 1.5 Sprint 04(2026-09-27 ~ 09-29 / 短縮)

**テーマ**: 管理画面 + 利用統計

| 主要ストーリー | 担当 | 工数 |
|---|---|---|
| 管理画面ダッシュボード | frontend-engineer + backend-engineer | 12h |
| 利用統計 API + UI | backend-engineer + frontend-engineer | 12h |
| LLM コスト集計 | backend-engineer | 4h |
| 監視 / アラート(Sentry / UptimeRobot) | devops-engineer | 8h |
| 公開前最終 E2E + リグレッション | qa-engineer | 4h |

### 1.6 QA + Launch(2026-09-30 ~ 10-05)

| 日 | タスク |
|---|---|
| 2026-09-30 | 全 E2E pass + Lighthouse / a11y 監査 |
| 2026-10-01 | placeholder-detection / legal-pages-check / pre-deploy hooks 通過 |
| 2026-10-04 | APV-006(launch_approval)approved |
| 2026-10-05 | β版公開 |

---

## 2. 6 ヶ月テーマ別(2026 Q4 ~ 2027 Q1)

### 2.1 公開後 30 日(Phase 5 / 本組織内 / 2026-10-05 ~ 11-04)

- Day +1:Whisper / Claude API 動作確認
- Day +7:GA4 / Sentry データ初期確認
- Day +14:5 名テストユーザー → 20 名(LP 申込み 50 名から段階拡大)
- Day +21:中間 PMF 確認(Week 7 = 30 件録音処理達成見込み確認)
- Day +30:30 日レポート発行 / **次フェーズ判断**

### 2.2 正式版開発(2026-11 ~ 2027-01 / 別案件)

| テーマ | 期間 | 主担当 |
|---|---|---|
| チーム / ワークスペース機能 | 2026-11-15 ~ 12-15 | backend-engineer + product-manager |
| Slack / Teams 連携 | 2026-12-01 ~ 12-31 | backend-engineer |
| 課金機能(Stripe) | 2027-01-01 ~ 01-31 | backend-engineer + commercial-manager |
| 正式版ローンチ | 2027-02-01 | delivery-director |

---

## 3. 12 ヶ月方向性(2027 H1 ~ H2)

### 3.1 H1(2027-01 ~ 06)

- SSO(SAML)対応 — Enterprise 顧客対応
- API 公開(法人向け)
- 業界特化テンプレート(医療 / 法務 / 人材)

### 3.2 H2(2027-07 ~ 12)

- 海外展開検討(en 化が前提)
- モバイルアプリ(iOS / Android)
- AI 機能拡張(感情分析 / 発言者特定 / トピック分類)

---

## 4. 決定ゲート

| ゲート | 日付 | 判断者 | 判断対象 |
|---|---|---|---|
| ★ PMF Gate(Week 4) | 2026-09-13 | product-director + Shin | continue / pivot / kill |
| 30 日レポート判断 | 2026-11-04 | product-director + Shin | 正式版着手 / 継続 β版 / kill |
| 正式版ローンチ判断 | 2027-01-31 | studio-director + Shin | 公開 / 延期 / 機能削減 |
| H2 海外展開判断 | 2027-06 | studio-director + Shin | 着手 / 見送り |

---

## 5. リスク + 緩和(roadmap 観点)

| リスク | 影響 | 緩和策 |
|---|---|---|
| PMF Gate kill | 本案件停止 | プロンプトチューニング + 1 ヶ月延長余地を確保 |
| 正式版開発の遅延 | 競合に先行される | β版で「日本語特化精度」の評判を確立 |
| LLM API 価格高騰 | コスト構造崩壊 | モデル切替の柔軟性を確保(Claude / GPT / Gemini) |
| 海外展開のリソース不足 | en 化遅延 | 国内市場確立後の段階的判断 |

---

## 6. 検証メモ(Phase I-B)

- product-director のロードマップ文書として、3/6/12 ヶ月の階層構造が機能することを確認
- 各 Sprint と PMF Gate がロードマップ全体に位置づけられている
- agent-coordination-map.md §11.6(B 系フェーズゲート責任者)の Quarter Boundary が「正式版ローンチ判断 = 2027-01-31」として実装されていることを確認

---

**Document Owner**: product-director
**Last Updated**: 2026-08-15
**Version**: 1.0
