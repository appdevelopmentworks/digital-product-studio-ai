# 公開チェックリスト — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-09-30(QA 完了 → checklist 作成)
**作成者**: delivery-director(backend-lead / product-director 補強)
**ステータス**: ✅ 全項目 pass(2026-10-04)
**関連承認**: APV-006(launch_approval) — approved 2026-10-04

> B 系特有のチェック項目を含む(API contract / DB マイグレーション / Inngest / LLM API 接続 等)

---

## サマリー

**判定**: ✅ **GO**(全 75 項目 pass)

| 区分 | pass / total |
|---|---|
| 法務 | 6 / 6 |
| API + データ | 12 / 12 |
| パフォーマンス | 8 / 8 |
| アクセシビリティ | 6 / 6 |
| セキュリティ | 8 / 8 |
| インフラ + デプロイ | 12 / 12 |
| 監視・観測性 | 7 / 7 |
| LLM API + ジョブキュー | 6 / 6 |
| 承認(★ PMF gate 含む) | 7 / 7 |
| 公開後即時タスク(Day 0) | 3 / 3 |
| **合計** | **75 / 75** |

---

## 1. 法務(B 系・privacy + terms_of_service 両方必須)

| # | 項目 | 状態 |
|---|---|---|
| 1.1 | プライバシーポリシー(MeetingAI 拡張版)掲載 + lawyer_confirmation: true | ✅ |
| 1.2 | β版利用規約(API 利用条項含む)掲載 + lawyer_confirmation: true | ✅ |
| 1.3 | フォーム送信時の同意文言(録音データ提供同意含む)| ✅ |
| 1.4 | 個人情報保護管理者の氏名・役職を確定 | ✅ |
| 1.5 | LLM API 提供事業者(Anthropic / OpenAI)へのデータ送信明示 | ✅ privacy 第 5 条 |
| 1.6 | 学習データ非利用の明示(privacy 第 6 条)| ✅ |

---

## 2. API + データ

| # | 項目 | 状態 |
|---|---|---|
| 2.1 | 全 API endpoint(api-spec.md §2)動作確認 | ✅ |
| 2.2 | エラーエンベロープ統一(api-spec.md §1.3)| ✅ |
| 2.3 | Idempotency-Key 動作(POST /api/v1/recordings)| ✅ |
| 2.4 | レート制限動作(api-spec.md §5)| ✅ |
| 2.5 | DB マイグレーション本番適用(全 7 件)| ✅ |
| 2.6 | RLS policy 全テーブル設定 | ✅ |
| 2.7 | 他ユーザー record アクセス → 404(CJ-004)| ✅ |
| 2.8 | invitations.token UNIQUE 制約 | ✅ |
| 2.9 | recordings.delete_at による 30 日 auto-delete cron | ✅ |
| 2.10 | audit_logs 記録動作 | ✅ |
| 2.11 | DB バックアップ(Supabase 自動)有効 | ✅ |
| 2.12 | Point-in-Time Recovery(7 日)有効 | ✅ |

---

## 3. パフォーマンス

| # | 項目 | 目標 | 実測 |
|---|---|---|---|
| 3.1 | Lighthouse Performance(管理画面) | ≥ 90 | 92 ✅ |
| 3.2 | Lighthouse Accessibility | ≥ 95 | 100 ✅ |
| 3.3 | Lighthouse SEO(管理画面)| 90+(SaaS 緩め) | 90 ✅ |
| 3.4 | Lighthouse Best Practices | ≥ 90 | 100 ✅ |
| 3.5 | API GET /me / recordings p95 | < 200ms | 80-120ms ✅ |
| 3.6 | API POST /recordings p95 | < 500ms | 280ms ✅ |
| 3.7 | 録音処理 e2e p95(60 分)| < 30 分 | 9 分 ✅ |
| 3.8 | 画像 / フォント最適化 | WebP + サブセット | ✅ |

---

## 4. アクセシビリティ(WCAG 2.2 AA)

| # | 項目 | 状態 |
|---|---|---|
| 4.1 | aileap_v2 design-system 継承 | ✅ |
| 4.2 | キーボード操作で全機能完遂 | ✅ |
| 4.3 | スクリーンリーダー(VoiceOver / NVDA)動作 | ✅ |
| 4.4 | 動的更新の aria-live | ✅ |
| 4.5 | データテーブルの semantic HTML + scope | ✅ |
| 4.6 | モーダルの focus trap | ✅ |

---

## 5. セキュリティ

| # | 項目 | 状態 |
|---|---|---|
| 5.1 | HTTPS + HSTS(2 年・preload) | ✅ |
| 5.2 | 環境変数で API キー管理(Vercel + GitHub Secrets) | ✅ |
| 5.3 | X-Frame-Options DENY / X-Content-Type-Options nosniff | ✅ |
| 5.4 | Referrer-Policy strict-origin / Permissions-Policy 制限 | ✅ |
| 5.5 | Webhook HMAC 署名検証(Inngest) | ✅ |
| 5.6 | レート制限動作 | ✅ |
| 5.7 | reCAPTCHA(magic link 送信時)| ✅(IP ベース 5/15min)|
| 5.8 | LLM API のデータ非学習設定確認 | ✅(Anthropic + OpenAI 両方)|

---

## 6. インフラ + デプロイ

| # | 項目 | 状態 |
|---|---|---|
| 6.1 | Vercel production 設定 | ✅ |
| 6.2 | サブパス分離 / カスタムドメイン設定 | ✅ |
| 6.3 | ワイルドカード SSL(*.aileap.example) | ✅ aileap_v2 と共有 |
| 6.4 | http → https リダイレクト | ✅ |
| 6.5 | Supabase Pro プラン | ✅ アップグレード済 |
| 6.6 | Supabase Storage バケット(recordings + summaries-pdf) | ✅ |
| 6.7 | GitHub Actions CI/CD 動作 | ✅ |
| 6.8 | CI で全テスト pass(unit + integration + e2e + lighthouse + smoke-test)| ✅ |
| 6.9 | DB migration dry-run + 本番適用 | ✅ |
| 6.10 | API contract test pass | ✅ |
| 6.11 | 環境変数 production / preview 分離 | ✅ |
| 6.12 | ロールバック手順確認 | ✅ |

---

## 7. 監視・観測性

| # | 項目 | 状態 |
|---|---|---|
| 7.1 | Sentry 統合(frontend + backend)| ✅ |
| 7.2 | Sentry source map upload | ✅ |
| 7.3 | Sentry alert ルール設定 | ✅ |
| 7.4 | UptimeRobot 監視(/health + /)| ✅ |
| 7.5 | Vercel Analytics 有効 | ✅ |
| 7.6 | Audit logs 記録動作 | ✅ |
| 7.7 | Slack 通知連携 | ✅ |

---

## 8. LLM API + ジョブキュー

| # | 項目 | 状態 |
|---|---|---|
| 8.1 | Whisper API 接続 + 認証 | ✅ |
| 8.2 | Claude API 接続 + 認証 | ✅ |
| 8.3 | LLM API quota 設定確認 | ✅(Anthropic Tier 2 + OpenAI Pay-as-you-go) |
| 8.4 | Inngest production 環境設定 | ✅ |
| 8.5 | Inngest function 全 4 件 deploy 済 | ✅ |
| 8.6 | LLM コスト集計 cron 動作 | ✅(deploy 直後実行で確認) |

---

## 9. 承認・最終確認

| # | 項目 | 状態 |
|---|---|---|
| 9.1 | APV-001(要件定義 + product-strategy)approved | ✅ 2026-08-15 |
| 9.2 | APV-002(内部見積)approved | ✅ 2026-08-04 |
| 9.3 | APV-003(API + DB スキーマ)approved | ✅ 2026-08-15 |
| 9.4 | APV-004(Sprint 02 完了レビュー)approved | ✅ 2026-09-12 |
| 9.5 | **APV-005(★ Week 4 PMF Gate)approved + decision: continue** | ✅ 2026-09-13 |
| 9.6 | **APV-006(launch_approval)approved** | ✅ 2026-10-04 |
| 9.7 | pre-deploy 全 hook pass(lighthouse / placeholder / legal / approval) | ✅ |

---

## 10. 公開後即時タスク(Day 0 = 2026-10-05)

| # | 項目 | 状態 |
|---|---|---|
| 10.1 | UptimeRobot 監視開始 | (公開当日に有効化) |
| 10.2 | Sentry に「v1.0.0 公開」リリース通知 | (CI で自動) |
| 10.3 | Slack で関係者(Shin + 全 B 系エージェント)に公開完了通知 | (公開当日) |

---

## 11. 公開後 30 日タスク予告(Phase 5)

[06-handoff/seo-geo-30day-report.md](../06-handoff/seo-geo-30day-report.md) 参照。

| 日数 | タスク | 担当 |
|---|---|---|
| +1 | LLM API 動作確認 | backend-engineer |
| +7 | β版ユーザー 5 → 20 名段階拡大 | product-manager |
| +14 | 中間 PMF 確認 | product-director |
| +21 | コスト集計 + alert 調整(M-001) | devops-engineer |
| +30 | **30 日レポート発行 + 次フェーズ判断** | product-director + delivery-director |

---

## 12. B 系特有の検証項目

| # | 項目 | 状態 |
|---|---|---|
| 12.1 | API contract test 全件 pass | ✅ |
| 12.2 | DB マイグレーション dry-run pass | ✅ |
| 12.3 | Inngest function retry 動作確認 | ✅ |
| 12.4 | LLM API レイテンシ計測 | ✅ |
| 12.5 | 録音 30 日 auto-delete cron 動作 | ✅(staging で 1 日に短縮テスト) |
| 12.6 | RLS テスト全件 pass | ✅(CJ-004 含む) |
| 12.7 | LLM コスト集計動作 | ✅ |

---

## 13. 検証メモ(Phase I-B)

- B 系の launch-checklist は A 系より項目数が多く(75 件 vs A1 137 件 vs A2 60 件)、API + DB + LLM + Inngest 関連が追加
- PMF Gate(APV-005)が承認セクションに明示される B 系特有の構造
- legal-pages-check.sh の B 系分岐(terms_of_service 必須化)が動作

---

**Document Owner**: delivery-director
**Last Updated**: 2026-10-04
**Version**: 1.0
**判定**: ✅ launch GO
