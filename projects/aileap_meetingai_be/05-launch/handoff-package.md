# 納品パッケージ — AILEAP MeetingAI β版 BE + 管理画面

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-10-04
**作成者**: delivery-director(backend-lead / product-director 補強)
**ステータス**: 公開準備完了

> B 系自社プロダクト案件のため、外部納品ではなく本組織内の運用引継ぎパッケージ。
> WMAO 引継ぎは原則なし(handoff-protocols.md §8.4 / DEC-007)。

---

## 1. パッケージ概要

| 項目 | 値 |
|---|---|
| 公開予定日 | 2026-10-05 |
| 本番 URL | https://meetingai.aileap.example/ + /api/v1/ |
| ステージング URL | https://staging.meetingai.aileap.example/ |
| ホスティング | Vercel + Supabase + Inngest |
| 親プロジェクト | aileap_meetingai_lp(LP) |
| 統合運用 | aileap_v2(コーポレート)/ aileap_meetingai_lp(LP) |

---

## 2. 引き渡しアセット

### 2.1 ソースコード

| アセット | 場所 | アクセス権 |
|---|---|---|
| メインリポジトリ | `aileap-meetingai-be/`(別 GitHub repo) | Shin / AILEAP all agents(read) |
| Vercel project | aileap-meetingai-be.vercel.app | Shin |
| Supabase project | aileap-meetingai-be(ap-northeast-1) | Shin(admin) |
| Inngest workspace | aileap-meetingai-be | Shin |

### 2.2 設計成果物

| アセット | パス |
|---|---|
| product-discovery | 01-discovery/product-discovery.md |
| 要件定義 | 01-discovery/requirements-v0.md |
| product-strategy | 02-strategy/product-strategy.md |
| product-roadmap | 02-strategy/product-roadmap.md |
| user-stories | 02-strategy/user-stories.md |
| API 設計 | 03-design/api-spec.md |
| DB スキーマ | 03-design/database-schema.md |
| デザインノート | 03-design/design-notes.md |
| アーキテクチャ | 04-implementation/architecture-notes.md |
| インフラ計画 | 04-implementation/infra-plan.md |
| Sprint plans | 04-implementation/sprint-plans/(4 件) |
| Backlog | 04-implementation/backlog.yaml |

### 2.3 QA レポート

| レポート | 結果 |
|---|---|
| E2E テスト計画 + 実行結果 | ✅ Pass(全 critical journey 8 件)|
| アクセシビリティ監査 | ✅ Pass(WCAG 2.2 AA 100 達成)|

### 2.4 公開チェックリスト

`05-launch/launch-checklist.md` 全 75 項目 pass。

### 2.5 PMF Gate(★ B 系特有)

`06-handoff/pmf-validation-week-4.md` — Week 4 PMF Gate で **continue 判断 + APV-005 approved**。

---

## 3. CMS / データベース引き渡し情報

### 3.1 Supabase

| 項目 | 値 |
|---|---|
| Project ID | aileap-meetingai-be |
| Region | ap-northeast-1 |
| Plan | Pro($25/月) |
| URL | (別経路で受け渡し) |
| API Keys | (別経路で受け渡し:1Password) |

DB 管理:
- マイグレーション:`supabase/migrations/`
- バックアップ:Supabase 自動(daily)+ PITR(7 日)
- 監視:Supabase Dashboard

### 3.2 Inngest

| 項目 | 値 |
|---|---|
| Workspace | aileap-meetingai-be |
| Plan | Free Tier(月 50,000 events) |
| Functions | 4 件(process-recording / send-email / cleanup / cost-aggregate) |

### 3.3 ユーザー権限

| 役割 | アカウント | 権限 |
|---|---|---|
| Admin | Shin(MeetingAI プロダクト責任者) | 全機能 |
| 編集者 | (将来 / Shin が判断) | β版運用 / 招待発行 |

---

## 4. アクセス情報

### 4.1 ホスティング / 運用

| サービス | URL | 管理者 |
|---|---|---|
| Vercel | https://vercel.com/aileap/aileap-meetingai-be | Shin |
| GitHub | https://github.com/aileap/aileap-meetingai-be | Shin |
| Supabase | https://app.supabase.com/project/aileap-meetingai-be | Shin |
| Inngest | https://app.inngest.com/aileap-meetingai-be | Shin |
| Sentry | https://sentry.io/organizations/aileap/projects/meetingai-be | Shin |
| UptimeRobot | aileap_v2 と共有 | Shin |

### 4.2 環境変数

別経路(1Password)で受け渡し済。Vercel + GitHub Secrets で分離管理。

### 4.3 LLM API アカウント

- Anthropic Claude:AILEAP 既存アカウント(monthly cap 設定済)
- OpenAI Whisper:AILEAP 既存アカウント(usage cap 設定済)

---

## 5. 保守 / SLA(B 系特殊・本組織内継続運用)

### 5.1 Phase 5 サポート(公開後 30 日)

[handoff-protocols.md §8.5](../../../docs/handoff-protocols.md) の B 系 Phase 5:

- 重大バグ修正(無償)
- API レイテンシ再測定 + 必要に応じたチューニング
- Week 4(初動)+ Week 8(30 日)PMF gate 確認
- LLM コスト監視 + alert 設定調整(M-001)
- 軽微な機能追加(Phase 5 内・累計 24h 以内)

### 5.2 31 日目以降(本組織内継続運用)

A 系のような WMAO 引継ぎは行わない。本組織内で:
- product-director:継続 PMF 監視 + Quarter Boundary review
- product-manager:正式版開発スプリント運営(2026-11 着手)
- backend-engineer:バグ修正 + 機能追加
- devops-engineer:インフラ運用 + コスト監視
- qa-engineer:継続テスト + リグレッション

### 5.3 SLA

| 項目 | 値 |
|---|---|
| 稼働率目標 | 99.5%(UptimeRobot 測定) |
| 重大障害対応 | 24h 以内 |
| 軽微改修 | 72h 以内 |
| 連絡先 | meetingai-tech@aileap.example |

---

## 6. 引継ぎチェックリスト

公開直後に確認:

- [x] 全 hook pass
- [x] launch-checklist 全 75 項目 pass
- [x] E2E テスト + a11y 監査 pass
- [x] APV-001 〜 APV-006 全 approved(★ APV-005 PMF Gate continue)
- [x] privacy + terms_of_service が lawyer_confirmation: true
- [x] placeholder-detection pass
- [x] Vercel + Supabase + Inngest 本番動作
- [x] LLM API 接続確認
- [x] Sentry / UptimeRobot 動作

---

## 7. 既知の課題(Phase 5 内対応)

| ID | 内容 | 重要度 | 対応予定 |
|---|---|---|---|
| K-001 | Sentry alert 閾値が厳しすぎ(noise) | 中 | Phase 5 内・devops-engineer |
| K-002 | 60 分音声 e2e の CI 実行コスト | 中 | Phase 5 内・qa-engineer |
| K-003 | スキップリンクスタイル(他案件と共通) | 低 | aileap_v2 + lp と一括対応 |

---

## 8. 申し送り事項(B 系継続運用)

### 8.1 公開直後(Day 0-7)

- 5 名社内テストユーザーで動作再確認
- LP 申込み 50 名から 5-10 名に招待発行(段階拡大)
- LLM コスト初動確認(目安:¥1,000/週)

### 8.2 Phase 5 期間中(Day 8-30)

- β版ユーザー 20 名まで拡大
- 中間 PMF 確認(Day 14)
- 30 日レポート発行(Day 30 / 2026-11-04)

### 8.3 31 日目以降(本組織内継続)

- product-director:正式版開発判断(2026-11 着手判断)
- 継続スプリント運営(2026-11 ~ 2027-01:正式版機能 — チーム / Slack / 課金)

---

## 9. v0.4 以降の継続課題

- Storybook 導入
- Visual regression(Chromatic)
- Sentry profiling 有効化
- API 公開(法人向け)
- en 化(海外展開時)

---

**Document Owner**: delivery-director
**Last Updated**: 2026-10-04
**Version**: 1.0
