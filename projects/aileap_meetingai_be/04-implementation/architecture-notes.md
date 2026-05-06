# 実装アーキテクチャノート — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: technology-director / backend-lead(backend-engineer 補強)
**ステータス**: 確認済(internal)

> **継承元**: [aileap_v2/04-implementation/architecture-notes.md](../../aileap_v2/04-implementation/architecture-notes.md)
> B 系のため API / DB / 非同期ジョブ層が追加。継承部分は Web フロントのみ。

---

## 1. 技術スタック

| 領域 | 採用 | 備考 |
|---|---|---|
| フレームワーク | Next.js 14 App Router | aileap_v2 継承 |
| 言語 | TypeScript 5.x(strict) | 同上 |
| スタイリング | Tailwind CSS 3.x + design-tokens | 同上 |
| **DB / Auth / Storage** | **Supabase**(Postgres + Auth + Storage) | ★ B 系新規 |
| **ジョブキュー** | **Inngest** | ★ B 系新規(録音 → 要約の非同期処理) |
| **LLM API**(音声→テキスト) | **OpenAI Whisper(whisper-large-v3)** | ★ B 系新規 |
| **LLM API**(要約) | **Anthropic Claude(claude-sonnet-4-6)** | ★ B 系新規 |
| **PDF 生成** | **react-pdf**(or puppeteer 検討) | ★ B 系新規 |
| ホスティング | Vercel | aileap_v2 継承 |
| メール送信 | Resend | aileap_v2 継承 |
| **エラー監視** | **Sentry**(B 系標準) | ★ B 系新規 |
| アクセス監視 | UptimeRobot | aileap_v2 継承 |
| アナリティクス | GA4(管理画面のみ) | 簡素化 |

DEC-004 で確定。

---

## 2. アーキテクチャ概略図

```
┌──────────────────────────────────────────────────────────────┐
│                      Vercel(本番)                          │
│                                                              │
│  ┌────────────────────────────────────────────────────┐     │
│  │  Next.js 14 App Router                              │     │
│  │                                                     │     │
│  │  ┌──────────────────────────────┐                  │     │
│  │  │  app/                        │                  │     │
│  │  │  ├── (auth)/login            │                  │     │
│  │  │  ├── (user)/dashboard        │                  │     │
│  │  │  ├── (user)/upload           │                  │     │
│  │  │  ├── (user)/recordings/[id]  │                  │     │
│  │  │  ├── (admin)/admin/...       │                  │     │
│  │  │  └── api/v1/...              │                  │     │
│  │  └──────────────────────────────┘                  │     │
│  └────┬────────────────────────────────────────────────┘     │
│       │                                                       │
│       │  ┌─────────────────────┐                              │
│       ├─→│  Supabase Postgres  │ (RLS, schema)                │
│       │  └─────────────────────┘                              │
│       │  ┌─────────────────────┐                              │
│       ├─→│  Supabase Auth      │ (magic link)                 │
│       │  └─────────────────────┘                              │
│       │  ┌─────────────────────┐                              │
│       ├─→│  Supabase Storage   │ (録音 + 議事録 PDF)         │
│       │  └─────────────────────┘                              │
│       │  ┌─────────────────────┐                              │
│       └─→│  Inngest(ジョブ)  │                              │
│          └──┬──────────────────┘                              │
│             │                                                 │
│             ├─→ OpenAI Whisper(音声 → テキスト)             │
│             ├─→ Anthropic Claude(要約 + 構造化)            │
│             ├─→ react-pdf(PDF 生成)                        │
│             └─→ Resend(完了通知メール)                     │
└──────────────────────────────────────────────────────────────┘
        ↑
        │  GitHub Actions(CI/CD)+ Sentry(エラー監視)
```

---

## 3. ディレクトリ構造

```
aileap-meetingai-be/                   # 別 GitHub repo
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── auth/callback/page.tsx
│   ├── (user)/
│   │   ├── dashboard/page.tsx
│   │   ├── upload/page.tsx
│   │   └── recordings/[id]/page.tsx
│   ├── (admin)/
│   │   └── admin/
│   │       ├── page.tsx              # /admin ダッシュボード
│   │       ├── users/page.tsx
│   │       ├── invite/page.tsx
│   │       ├── recordings/page.tsx
│   │       └── stats/page.tsx
│   ├── api/v1/
│   │   ├── auth/...
│   │   ├── recordings/...
│   │   ├── admin/...
│   │   └── webhook/...
│   ├── layout.tsx
│   └── globals.css
├── src/
│   ├── components/
│   │   ├── atoms/                    # aileap_v2 流用
│   │   ├── molecules/                # aileap_v2 流用 + B 系新規(StatusBadge / ProgressBar)
│   │   ├── organisms/                # B 系新規(RecordingCard / SummaryViewer / AdminSidebar 等)
│   │   └── templates/
│   ├── lib/
│   │   ├── supabase/                 # client / server / admin
│   │   ├── inngest/                  # ジョブ定義
│   │   ├── llm/                      # whisper / claude wrapper
│   │   ├── pdf/                      # react-pdf テンプレート
│   │   ├── schemas.ts                # zod スキーマ
│   │   └── audit.ts                  # audit_logs ヘルパー
│   └── middleware.ts                 # auth ミドルウェア
├── supabase/
│   ├── migrations/                   # DB マイグレーション
│   └── seed.sql
├── tests/
│   ├── e2e/
│   │   ├── critical-journeys/
│   │   └── a11y/
│   └── unit/
├── inngest/
│   └── functions/                    # Inngest workflow 定義
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── .env.example
```

---

## 4. 実行環境(Runtime)

| エンドポイント | Runtime | 理由 |
|---|---|---|
| /api/v1/me / recordings GET | Edge | 軽量・低レイテンシ |
| /api/v1/recordings POST | Node | Supabase Storage upload + Inngest ジョブ登録 |
| /api/v1/admin/* | Edge | 軽量 |
| /api/v1/webhook/* | Node | Inngest webhook 処理 |
| /admin/* (Server Components) | Node | DB アクセス必要 |
| /(user)/* (Server Components) | Node | 同上 |

Inngest worker 自体は Inngest クラウドで実行(Vercel Function ではない)。

---

## 5. 認証アーキテクチャ

[03-design/api-spec.md §4](../03-design/api-spec.md#4-認証--認可) を実装。

```
[1] User → POST /api/v1/auth/magic-link { email }
[2] Server: invitations 確認 → Supabase Auth で magic link 発行
[3] Resend で送信
[4] User がリンクをクリック
[5] Supabase Auth が token を検証 → Cookie session 確立
[6] middleware.ts で session 検証 → API ガード
[7] admin role は user_profiles.role で判定
```

---

## 6. 非同期処理アーキテクチャ(Inngest)

```
[1] POST /api/v1/recordings
    ├─ Supabase Storage upload
    ├─ DB に recording レコード作成(status: uploaded)
    └─ Inngest event: 'recording.uploaded' 発火

[2] Inngest function 'process-recording'
    ├─ Step 1: Whisper API(retry 3 回)→ transcripts 保存(status: transcribed)
    ├─ Step 2: Claude API(retry 3 回)→ summaries 保存(status: summarized)
    ├─ Step 3: react-pdf で PDF 生成 → Supabase Storage(status: completed)
    └─ Step 4: Resend で完了通知メール

[3] エラー時(全 retry 失敗)
    ├─ status: failed + failure_reason 記録
    ├─ Sentry 通知
    └─ admin に Slack alert
```

Inngest の利点:
- Vercel Cron より柔軟な retry / scheduling
- Step ベースで途中失敗から再開可能
- 開発環境(ローカル)で本番と同じワークフロー実行

---

## 7. パフォーマンス予算

| 指標 | 目標 |
|---|---|
| API GET 系 p95 | < 200ms(Edge Runtime) |
| API POST /recordings p95 | < 500ms(Node + Storage upload) |
| 録音処理 end-to-end p95(60 分音声)| < 30 分 |
| 管理画面 Lighthouse Performance | 90+(SaaS のため目標下げ・aileap_v2 95+ より低め)|
| 管理画面 Lighthouse Accessibility | 100(継承)|

API レイテンシは Vercel Analytics + Sentry で測定。

---

## 8. セキュリティ実装方針

- HTTPS + HSTS
- HTTP ヘッダー(aileap_v2 継承):X-Frame-Options DENY / X-Content-Type-Options nosniff / Referrer-Policy strict-origin
- Supabase RLS(database-schema.md §3 参照)
- API ガード(middleware.ts):session 検証 + admin role チェック
- 環境変数:Vercel + GitHub Secrets で分離管理
- LLM API:input filtering(プロンプトインジェクション対策)
- Webhook:HMAC 署名検証(Inngest)
- レート制限:Vercel KV ベース(api-spec.md §5)

---

## 9. デプロイゲート(B 系特有)

aileap_v2 と同じ hooks に加えて、B 系特有のゲート:

| ゲート | 検証 |
|---|---|
| pre-deploy-approval-check | APV-006(launch_approval)approved |
| placeholder-detection | `<<...>>` 残置 0 件 |
| legal-pages-check | privacy + terms_of_service の lawyer_confirmation: true |
| lighthouse-budget | 管理画面 Lighthouse Performance 90+ |
| **API contract test**(B 系新規) | E2E で全 API endpoint のレスポンス validation |
| **DB マイグレーション dry-run** | 本番 DB へのマイグレーション前に検証 |

API contract test と DB migration dry-run は GitHub Actions で実行。

---

## 10. v0.4 以降の継続課題

- Storybook 導入(コンポーネントカタログ)
- Visual regression(Chromatic)
- Sentry profiling 有効化
- Inngest dashboard カスタマイズ
- Supabase Edge Functions(Deno)へ一部移行検討

---

## 11. 検証メモ(Phase I-B)

- B 系のアーキテクチャ確定文書として、aileap_v2 継承部分と B 系新規追加部分が明確に分離
- /api-design スキル(B 系新規)+ /infra-plan スキル(B 系新規)が本書を起点として連携
- backend-lead が direct reports 3 体(backend-engineer / devops-engineer / qa-engineer)を統括する体制で動作

---

**Document Owner**: technology-director / backend-lead
**Last Updated**: 2026-08-15
**Version**: 1.0
