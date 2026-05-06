# 要件定義書 v0 — AILEAP MeetingAI β版 BE + 管理画面

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: v0
**作成日**: 2026-08-08
**作成者**: product-manager + product-director
**ステータス**: 承認済(APV-001 / 2026-08-15)

> B 系の要件定義は product-discovery.md と分離。本書は「機能要件 + 非機能要件」を中心に記述。

---

## 1. プロジェクト目的

### 1.1 ビジネスゴール(KGI)

公開後 90 日以内に **β版で 50 ユーザーが 30 件以上の会議録音を処理**(PMF gate 判断材料)。

### 1.2 主要 KPI

[product-discovery.md §7](product-discovery.md#7-成功の定義success-metrics) を参照。

---

## 2. スコープ

### 2.1 対象範囲(MVP)

[product-discovery.md §5.1](product-discovery.md#51-必須機能本案件-v10--β版で実装) を実装。

### 2.2 対象外(明示)

- チーム / ワークスペース機能(v1.5)
- Slack / Teams 連携(v1.5)
- SSO(v2.0)
- 課金機能(正式版)

---

## 3. 機能要件

### 3.1 ユーザー権限

| ロール | 権限 |
|---|---|
| 管理者(AILEAP)| 全機能 + 招待発行 + ユーザー一覧 + 利用統計 |
| β版ユーザー | 招待リンクからの登録 + 録音アップロード + 自分の議事録閲覧 + PDF DL |

### 3.2 主要画面・API

#### 3.2.1 ユーザー側 Web UI

| 画面 | URL | 機能 |
|---|---|---|
| ログイン | `/login` | magic link 送信フォーム |
| 認証完了 | `/auth/callback` | magic link クリックの受け口 |
| ダッシュボード | `/dashboard` | 自分の録音 + 議事録一覧 |
| 録音アップロード | `/upload` | ファイル選択 + 件名 + アップロード |
| 議事録閲覧 | `/recordings/[id]` | 議事録テキスト + PDF DL リンク |

最小限の UI(B1 MVP のため UX より機能性重視)。

#### 3.2.2 管理画面

| 画面 | URL | 機能 |
|---|---|---|
| 管理ログイン | `/admin/login` | 管理者用 magic link |
| 管理ダッシュボード | `/admin` | 利用統計サマリー |
| ユーザー一覧 | `/admin/users` | ユーザー一覧 + 招待発行 |
| 招待発行 | `/admin/invite` | メールアドレス入力 → 招待 |
| 利用統計詳細 | `/admin/stats` | 録音件数・要約完了率・LLM コスト等 |

#### 3.2.3 API エンドポイント

| エンドポイント | メソッド | 用途 |
|---|---|---|
| /api/recordings | POST | 録音アップロード(非同期処理開始) |
| /api/recordings/:id | GET | 録音 + 議事録の状態取得 |
| /api/recordings/:id/pdf | GET | 議事録 PDF ダウンロード |
| /api/admin/users | GET | ユーザー一覧 |
| /api/admin/users/invite | POST | 招待発行 |
| /api/admin/stats | GET | 利用統計取得 |
| /api/webhook/whisper-completed | POST | Whisper 処理完了通知(内部) |
| /api/webhook/claude-completed | POST | Claude 処理完了通知(内部) |

詳細は `03-design/api-spec.md` 参照。

### 3.3 録音処理フロー

```
[ユーザー]
  ↓ POST /api/recordings(録音ファイル + 件名)
  ↓
[Next.js API Route]
  ↓ Supabase Storage アップロード
  ↓ DB に recording レコード作成(status: uploading → uploaded)
  ↓ Inngest にジョブ登録
  ↓ 即時 200 返却
  ↓
[Inngest Worker(非同期)]
  ↓ Whisper API → 文字起こし(status: transcribing → transcribed)
  ↓ Claude API → 要約 + 構造化議事録(status: summarizing → summarized)
  ↓ PDF 生成(status: generating_pdf → completed)
  ↓ ユーザーに通知メール送信
  ↓
[ユーザー]
  完了通知メールをクリック → /recordings/:id で議事録閲覧
```

---

## 4. 非機能要件

### 4.1 パフォーマンス

- API レスポンス時間(ジョブ登録系): p95 < 500ms
- 録音処理時間(60 分音声): 5-15 分(非同期・許容)
- 管理画面 Lighthouse Performance: 90+(ユーザー UI は最低限のため目標下げ)
- API レイテンシ p95: < 30 秒(録音 60 分の場合・end-to-end)

### 4.2 アクセシビリティ

- 管理画面 WCAG 2.2 AA 準拠(aileap_v2 design-system 継承)
- ユーザー UI も WCAG 2.2 AA(キーボード操作 + スクリーンリーダー対応)

### 4.3 セキュリティ

- HTTPS 必須(HSTS 有効)
- 認証: Supabase Auth magic link(パスワードレス)
- データ: AES-256 暗号化保存(Supabase Storage)
- RLS(Row Level Security)で他ユーザーの録音にアクセス不可
- LLM API 経由のデータは「学習に使わない」設定を確認(Anthropic / OpenAI)
- 環境変数で API キー管理

### 4.4 可用性

- 99.5% uptime(UptimeRobot 監視)
- DB バックアップ毎日(Supabase 自動)

### 4.5 ブラウザ・デバイス対応

- Chrome / Edge / Safari / Firefox 最新 2 バージョン
- iOS Safari / Android Chrome 最新 2 バージョン

---

## 5. データモデル概要

詳細は `03-design/database-schema.md` 参照。主要テーブル:

| テーブル | 主要カラム |
|---|---|
| users | id, email, role(admin/user), created_at |
| invitations | id, email, token, used_at, created_by_user_id |
| recordings | id, user_id, title, file_path, status, duration_seconds, created_at |
| transcripts | id, recording_id, content(text), created_at |
| summaries | id, recording_id, content(jsonb), pdf_path, accuracy_score, created_at |
| audit_logs | id, user_id, action, payload, created_at |

---

## 6. 制約事項

- aileap_v2 / aileap_meetingai_lp と同じ Vercel + 既存スタック
- LLM API は Anthropic Claude(主)+ OpenAI Whisper
- 認証は招待制 + magic link(SSO は v2.0)
- 課金機能は本案件スコープ外(正式版から)
- 多言語(en)対応は本案件スコープ外

---

## 7. 進行計画

[sow.md §2](../00-engagement/sow.md#2-フェーズ構成b-系スプリント運営) のフェーズ構成を採用。

---

## 8. リスクと対応

[sow.md §7](../00-engagement/sow.md#7-リスク--対策) を継承。

---

## 9. 別添

- `00-engagement/apex-to-dpsai-handoff.yaml`(product_specifics 含む)
- `00-engagement/estimate.yaml` / `sow.md`
- `01-discovery/onboarding-notes.md`
- `01-discovery/product-discovery.md`
- `02-strategy/product-strategy.md`(本書の上位戦略)
- `02-strategy/product-roadmap.md`
- `02-strategy/user-stories.md`
- `03-design/api-spec.md` / `database-schema.md`

---

**Document Owner**: product-manager(product-director 監修)
**Last Updated**: 2026-08-08
**Version**: v0
