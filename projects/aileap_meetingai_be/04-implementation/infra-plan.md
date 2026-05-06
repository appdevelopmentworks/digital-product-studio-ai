# インフラ計画 — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: devops-engineer(B 系・新規)
**ステータス**: 承認済(APV-003 内 / 2026-08-15)

> /infra-plan スキル(B 系新規)の動作検証。devops-engineer 主担当の中核ドキュメント。

---

## 1. 環境構成

### 1.1 環境一覧

| 環境 | URL | 用途 |
|---|---|---|
| Local | `http://localhost:3000` | 開発(Supabase ローカル + Inngest dev) |
| Preview | `<branch>.aileap-meetingai-be.vercel.app` | PR レビュー(Supabase Branch DB) |
| Staging | `staging.meetingai.aileap.example` | 公開前検証(本番 DB の sandbox スキーマ) |
| **Production** | `meetingai.aileap.example/api/v1`(将来は app.meetingai...) | β版本番 |

(本案件では LP `meetingai.aileap.example` と SaaS API を同ドメインで共存。サブパス分離 or サブドメイン化は v1.5 で再検討)

### 1.2 環境変数(Vercel + GitHub Secrets)

```
# Supabase
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=         # Edge Function 内のみ
SUPABASE_DB_URL=                   # マイグレーション用

# LLM
OPENAI_API_KEY=                    # Whisper
ANTHROPIC_API_KEY=                 # Claude

# Mail
RESEND_API_KEY=                    # aileap_v2 と共有

# Job Queue
INNGEST_EVENT_KEY=
INNGEST_SIGNING_KEY=

# Monitoring
SENTRY_DSN=
SENTRY_AUTH_TOKEN=                 # source map upload 用

# App
NEXT_PUBLIC_SITE_URL=https://meetingai.aileap.example
NEXT_PUBLIC_GA_MEASUREMENT_ID=     # 管理画面のみ
```

すべて Vercel 環境変数で production / preview / development を分離。`.env.example` で 公開可能な変数名のみ記載。

---

## 2. CI/CD パイプライン

### 2.1 GitHub Actions ワークフロー

```yaml
# .github/workflows/ci.yml(概要)
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  lint:
    - pnpm lint
    - pnpm typecheck

  test:
    - pnpm test:unit
    - pnpm test:integration

  e2e:
    - playwright install
    - pnpm test:e2e

  build:
    - pnpm build

  db-migration-check:
    - supabase db diff --linked  # マイグレーション差分検証
    - 本番 DB へ apply は手動(main マージ後)

  lighthouse:
    - vercel preview URL で Lighthouse CI 実行
    - Performance / A11y / SEO / BP 閾値チェック

  smoke-test:
    - bash .claude/hooks/smoke-test.sh

  security:
    - pnpm audit
    - npm-audit-resolver

  deploy-preview:
    needs: [lint, test, build]
    - Vercel preview deploy(PR ごと)

  deploy-production:
    needs: [all of above]
    if: branch=main
    - Vercel production deploy
```

### 2.2 デプロイフロー

```
[Developer] PR を main へ
    ↓
[CI] lint / typecheck / test / build / e2e / lighthouse / security
    ↓ 全 pass
[Code Review] backend-lead + frontend-lead レビュー
    ↓ approval
[Merge to main]
    ↓
[CI] DB migration apply(本番 Supabase へ)
    ↓
[Vercel] 本番 deploy
    ↓
[Post-deploy] smoke-test 実行 / Sentry に新リリース通知
```

### 2.3 ロールバック

- Vercel の immutable deploy(過去デプロイ即時切替可)
- DB マイグレーションのロールバック:`supabase db reset` で staging 確認後に本番手動

---

## 3. Supabase 設定

### 3.1 プロジェクト構成

| 項目 | 値 |
|---|---|
| Project name | aileap-meetingai-be |
| Region | ap-northeast-1(東京) |
| Plan | Pro($25/month / launch 後) |
| DB | Postgres 15 |

β版運用中の Pro プラン費用は内部コスト($25 + 必要に応じて compute $25 = ~$50/月)。

### 3.2 Storage バケット

| バケット | 用途 | アクセス |
|---|---|---|
| recordings | 録音ファイル(.mp3 / .m4a / .wav) | RLS(自分のみ + admin)/ auto-delete 30 日 |
| summaries-pdf | 議事録 PDF | RLS(自分のみ + admin) |

### 3.3 Auth 設定

- Magic link 有効
- パスワード認証 disabled(招待制のため)
- メール送信:Supabase デフォルト → Phase 5 で Resend 経由に切替検討
- セッション有効期間:access 1h / refresh 30d

### 3.4 RLS

[database-schema.md §3](../03-design/database-schema.md#3-テーブル定義) の policy を全テーブルで適用。

---

## 4. Inngest 設定

### 4.1 アカウント / プラン

- Plan: Free Tier(月 50,000 events まで)
- β版規模(50 ユーザー × 5 録音 = 250 events/month 想定)では Free で十分

### 4.2 Function 構成

| Function | trigger | 用途 |
|---|---|---|
| process-recording | event: recording.uploaded | Whisper → Claude → PDF の 4 step |
| send-completion-email | event: recording.completed | Resend 経由で完了通知 |
| daily-cleanup | cron: 0 2 * * * | 30 日経過録音の auto-delete |
| llm-cost-aggregate | cron: 0 3 * * * | 日次 LLM コスト集計 → audit_logs |

### 4.3 retry / dead-letter

- 各 step で retry 3 回(exponential backoff)
- 全 retry 失敗時 → dead letter queue → Sentry alert + Slack notification

---

## 5. 監視 / 観測性

### 5.1 Sentry

- DSN を環境変数で設定
- frontend / backend 両方で初期化
- Source map アップロード(本番ビルド時)
- Performance monitoring 有効(API レイテンシ計測)
- Alert ルール:
  - Error rate > 1% / 10 分 → admin Slack
  - API レイテンシ p95 > 1s / 10 分 → admin Slack
  - Inngest function failed → admin Slack

### 5.2 UptimeRobot

| 監視対象 | 間隔 | アラート |
|---|---|---|
| https://meetingai.aileap.example/ | 5 分 | 2 連続失敗で Slack |
| /api/v1/health | 5 分 | 同上 |

### 5.3 Vercel Analytics

- Web Vitals(LCP / INP / CLS)を自動計測
- Edge Network ログ

### 5.4 Audit Logs

- アプリ層で audit_logs テーブルに記録(RLS で admin のみ閲覧可)
- 主要アクション:invite / recording_upload / recording_delete / admin_action

---

## 6. シークレット管理

| シークレット | 保管場所 |
|---|---|
| Supabase service_role_key | Vercel env(production / preview のみ)/ GitHub Secrets |
| LLM API キー(Claude / Whisper) | Vercel env / GitHub Secrets |
| Inngest signing key | Vercel env / GitHub Secrets |
| Sentry auth token | GitHub Secrets(CI のみ) |

ローテーション運用:
- 本番デプロイ毎に rotate 検討(B 系では半年ごとを推奨)
- 漏洩時は即時 rotate + audit_logs 監査

---

## 7. コスト見積(月額)

| サービス | 想定 |
|---|---|
| Vercel(Pro) | $20 |
| Supabase(Pro) | $25 |
| Supabase 追加 compute | $25(必要に応じて) |
| Inngest | Free |
| LLM API(Claude + Whisper)| ¥50,000(50 ユーザー x 5 録音 / 月想定) |
| Resend(メール送信) | $0 - $20(送信量次第) |
| Sentry(Team プラン) | $26 |
| **合計(USD + JPY)**| **約 ¥65,000-75,000 / 月** |

β版規模では十分許容範囲。正式版で爆発的増加時はモデル切替 / プラン見直し。

---

## 8. ドメイン / DNS / SSL

- ドメイン:`meetingai.aileap.example`(aileap_meetingai_lp と共有・現時点ではサブパスで分離可能)
- SSL:Vercel 自動(Let's Encrypt)+ ワイルドカード `*.aileap.example`
- HSTS:max-age=63072000 / includeSubDomains / preload
- DNS:Vercel + Cloudflare(検討)

---

## 9. バックアップ / DR

- DB バックアップ:Supabase 自動(daily / 7 日保持)+ Point-in-Time Recovery
- 録音ファイル:Supabase Storage は単一リージョン(ap-northeast-1)/ DR は v1.5 で検討
- audit_logs:DB 内で 1 年保持 + 必要に応じて S3 archive(将来)

---

## 10. デプロイ前チェックリスト(launch-checklist.md と整合)

- [ ] 全 GitHub Actions ワークフロー pass
- [ ] Supabase Pro プランへアップグレード
- [ ] 環境変数すべて設定済(production / preview)
- [ ] Inngest function 全 deploy 済
- [ ] Sentry source map upload 確認
- [ ] DB マイグレーション本番適用済
- [ ] UptimeRobot 監視開始
- [ ] DNS / SSL 動作確認
- [ ] HTTP セキュリティヘッダー確認
- [ ] LLM API quota 設定確認

---

## 11. 検証メモ(Phase I-B)

- /infra-plan スキル(B 系新規)の動作検証
- devops-engineer の中核ドキュメントとして、CI/CD + 環境 + 監視 + シークレット + コストを統合的にカバー
- backend-lead が direct reports devops-engineer を統括する体制で動作 OK
- B 系特有の DB マイグレーション dry-run / API contract test を CI に組み込む形で実装

---

**Document Owner**: devops-engineer
**Last Updated**: 2026-08-15
**Version**: 1.0
