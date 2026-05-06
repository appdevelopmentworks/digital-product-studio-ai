# ユーザーストーリー — AILEAP MeetingAI β版

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: product-manager(product-director 監修)
**ステータス**: 承認済(APV-001 内)

> B 系の story-level breakdown。`backlog.yaml` の人間可読版として位置づけ。

---

## 0. 命名規則

- ID: `STORY-001` 〜
- 担当: 主実装者(コード作業の owner)
- Priority: P0(必須)/ P1(重要)/ P2(推奨)/ P3(任意)
- Sprint: 1-4 のいずれか + null(backlog 待ち)

---

## 1. ストーリー一覧(全 24 件)

### Sprint 01(2026-08-16 ~ 08-29):インフラ + 認証 + 基本 CRUD

#### STORY-001: Supabase project 初期化 + RLS 設計

- **As a** devops-engineer
- **I want to** Supabase project を作成し RLS を設定する
- **So that** 他ユーザーの録音にアクセスできない構造を保証する
- **Acceptance**:
  - [ ] Supabase project 作成済(URL + anon + service_role 取得)
  - [ ] users / recordings / transcripts / summaries に RLS policy 設定
  - [ ] テスト:user A の録音が user B から見えないこと
- **Priority**: P0 / **Estimate**: 6h / **Sprint**: 01 / **Owner**: devops-engineer

#### STORY-002: Next.js + Supabase Auth(magic link)実装

- **As a** ユーザー
- **I want to** メールアドレスだけでログインできる
- **So that** パスワード管理せずに使い始められる
- **Acceptance**:
  - [ ] /login で email 入力 → magic link 送信
  - [ ] /auth/callback でセッション確立
  - [ ] 招待されていないメールは送信を拒否
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 01 / **Owner**: backend-engineer

#### STORY-003: 招待発行管理画面

- **As a** 管理者
- **I want to** β版招待を発行する
- **So that** β版ユーザーを段階的に増やせる
- **Acceptance**:
  - [ ] /admin/invite で email 入力 → 招待発行
  - [ ] invitations テーブルに記録
  - [ ] Resend 経由で招待メール送信
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 01 / **Owner**: backend-engineer

#### STORY-004: User / Invitation / Recording テーブル + 基本 CRUD

- **As a** backend-engineer
- **I want to** 主要テーブルを実装する
- **So that** 後続スプリントでデータを永続化できる
- **Acceptance**:
  - [ ] DB マイグレーション実行
  - [ ] CRUD API(/api/recordings)動作
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 01 / **Owner**: backend-engineer

#### STORY-005: Vercel 本番環境設定 + 環境変数

- **As a** devops-engineer
- **I want to** production / preview の環境変数を分離設定
- **So that** secrets 漏洩を防ぐ
- **Acceptance**:
  - [ ] Vercel に MeetingAI BE プロジェクト作成
  - [ ] 環境変数 production / preview 分離
- **Priority**: P0 / **Estimate**: 4h / **Sprint**: 01 / **Owner**: devops-engineer

#### STORY-006: CI/CD(GitHub Actions)

- **Acceptance**:
  - [ ] PR で typecheck / lint / build / test
  - [ ] main マージで Vercel deploy
  - [ ] secrets を GitHub Secrets で管理
- **Priority**: P0 / **Estimate**: 6h / **Sprint**: 01 / **Owner**: devops-engineer

### Sprint 02(2026-08-30 ~ 09-12):録音 upload + Whisper

#### STORY-007: 録音アップロード API

- **As a** ユーザー
- **I want to** 録音ファイルをアップロードする
- **So that** 議事録を生成してもらえる
- **Acceptance**:
  - [ ] POST /api/recordings(multipart/form-data)
  - [ ] Supabase Storage に保存(ファイルサイズ制限 1GB)
  - [ ] DB に recording レコード作成(status: uploaded)
  - [ ] Inngest ジョブ登録
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 02 / **Owner**: backend-engineer

#### STORY-008: Inngest ジョブキュー設定

- **Acceptance**:
  - [ ] Inngest project 作成 + Vercel 連携
  - [ ] テストジョブ実行(retry 動作確認)
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 02 / **Owner**: devops-engineer + backend-engineer

#### STORY-009: Whisper API 統合 + 文字起こし保存

- **Acceptance**:
  - [ ] Inngest ワーカーで Whisper API 呼出
  - [ ] transcripts テーブルに保存
  - [ ] エラー時 retry(最大 3 回)
- **Priority**: P0 / **Estimate**: 16h / **Sprint**: 02 / **Owner**: backend-engineer

#### STORY-010: ユーザー UI(録音 upload + 進捗表示)

- **As a** ユーザー
- **I want to** /upload で録音をアップロードし進捗を見たい
- **Acceptance**:
  - [ ] /upload 画面
  - [ ] アップロード進捗バー
  - [ ] 文字起こし中のステータス表示
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 02 / **Owner**: frontend-engineer

#### STORY-011: E2E テスト基盤

- **Acceptance**:
  - [ ] Playwright 設定
  - [ ] critical journey 1 件(login → upload → transcribed)
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 02 / **Owner**: qa-engineer

### Sprint 03(2026-09-13 ~ 09-26):LLM 要約 + 議事録 PDF

#### STORY-012: Claude API 統合 + プロンプトチューニング

- **As a** ユーザー
- **I want to** 文字起こしから構造化された議事録が自動生成される
- **Acceptance**:
  - [ ] Inngest ワーカーで Claude API 呼出
  - [ ] プロンプトテンプレート確定(タイトル / 参加者 / アジェンダ / 決定事項 / アクション / FAQ)
  - [ ] summaries テーブルに JSONB 保存
- **Priority**: P0 / **Estimate**: 16h / **Sprint**: 03 / **Owner**: backend-engineer + product-director

#### STORY-013: 構造化議事録の保存

- **Acceptance**:
  - [ ] summaries.content (JSONB) に構造化議事録
  - [ ] accuracy_score(初期は LLM 自己評価)を記録
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 03 / **Owner**: backend-engineer

#### STORY-014: 議事録 PDF 生成

- **Acceptance**:
  - [ ] react-pdf or puppeteer で PDF 生成
  - [ ] Supabase Storage に保存
  - [ ] /api/recordings/:id/pdf でダウンロード
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 03 / **Owner**: backend-engineer

#### STORY-015: 議事録閲覧 UI

- **Acceptance**:
  - [ ] /recordings/:id で議事録テキスト表示
  - [ ] PDF ダウンロードボタン
  - [ ] 「議事録を編集」ボタン(v1.5 で実装)→ 本案件では disabled
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 03 / **Owner**: frontend-engineer

#### STORY-016: 完了通知メール

- **Acceptance**:
  - [ ] 議事録生成完了時にユーザーへメール
  - [ ] メールに /recordings/:id へのリンク
- **Priority**: P0 / **Estimate**: 4h / **Sprint**: 03 / **Owner**: backend-engineer

#### STORY-017: E2E テスト(録音 → 要約 → PDF)

- **Acceptance**:
  - [ ] critical journey の end-to-end テスト
  - [ ] 60 分音声テストケース
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 03 / **Owner**: qa-engineer

### Sprint 04(2026-09-27 ~ 09-29 / 短縮):管理画面 + 利用統計

#### STORY-018: 管理画面ダッシュボード

- **As a** 管理者
- **Acceptance**:
  - [ ] /admin で利用統計サマリー表示
  - [ ] 直近 7/30 日の録音件数 / 完了率 / コスト
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 04 / **Owner**: frontend-engineer + backend-engineer

#### STORY-019: 利用統計 API + UI

- **Acceptance**:
  - [ ] /api/admin/stats(日次集計)
  - [ ] グラフ表示(recharts 等)
- **Priority**: P0 / **Estimate**: 12h / **Sprint**: 04 / **Owner**: backend-engineer + frontend-engineer

#### STORY-020: LLM コスト集計

- **Acceptance**:
  - [ ] Claude / Whisper の使用 token 数を audit_logs に記録
  - [ ] コスト概算を /admin/stats で表示
- **Priority**: P1 / **Estimate**: 4h / **Sprint**: 04 / **Owner**: backend-engineer

#### STORY-021: 監視 / アラート

- **Acceptance**:
  - [ ] Sentry 統合(error 検知)
  - [ ] UptimeRobot 監視(API endpoint)
  - [ ] Slack 通知(critical alert)
- **Priority**: P0 / **Estimate**: 8h / **Sprint**: 04 / **Owner**: devops-engineer

#### STORY-022: 公開前最終 E2E + リグレッション

- **Acceptance**:
  - [ ] 全 critical journey pass
  - [ ] パフォーマンス基準 pass(API レイテンシ p95 < 30s)
- **Priority**: P0 / **Estimate**: 4h / **Sprint**: 04 / **Owner**: qa-engineer

### Backlog(本案件スコープ外・参考)

#### STORY-023: Slack / Teams 連携(v1.5)

- **Sprint**: null / **Priority**: P1(v1.5)/ **Owner**: 別案件

#### STORY-024: 議事録の意味検索(v1.5)

- **Sprint**: null / **Priority**: P1(v1.5)/ **Owner**: 別案件

---

## 2. 進捗集計(Phase I-B 完走時点)

| Sprint | 計画 | 完了 | 完了率 |
|---|---|---|---|
| Sprint 01 | 6 ストーリー | 6 / 6 | 100% |
| Sprint 02 | 5 ストーリー | 5 / 5 | 100% |
| Sprint 03 | 6 ストーリー | 6 / 6 | 100% |
| Sprint 04 | 5 ストーリー | 5 / 5 | 100% |
| **本案件合計** | **22 ストーリー** | **22 / 22** | **100%** |
| Backlog(参考)| 2 件 | — | v1.5 案件で実装 |

---

## 3. 検証メモ(Phase I-B)

- B 系 story-level breakdown が動作(各ストーリーに owner / sprint / priority / estimate 完備)
- backlog.yaml(`04-implementation/backlog.yaml`)の人間可読版として機能
- /sprint-plan スキルがこの user-stories.md を入力源として動作確認

---

**Document Owner**: product-manager
**Last Updated**: 2026-08-15
**Version**: 1.0
