---
# PROJECT.md — AILEAP MeetingAI β版バックエンド + 管理画面(Phase I-B 検証案件)

# === 識別子 ===
id: AILEAP-MTG-BE-20260801-001
type: B1                                    # SaaS MVP
status: active                              # Phase I-B 完走後も本組織内継続運用
phase: post-launch                          # discovery → strategy → 4 sprints → qa → launch → post-launch (Phase I-B 完走 2026-05-04)

# === クライアント情報 ===
client_name: 株式会社 AILEAP(自社・MeetingAI 事業部)
client_contact: Shin
client_email: shin@aileap.example
client_phone: ""
internal_client: true                       # ★ 自社プロダクト

# === タイムライン ===
created_at: 2026-08-01
target_launch_at: 2026-09-30                # 2 ヶ月後を目標(B1 SaaS MVP 標準は 3 ヶ月)
launched_at: 2026-10-05                     # Phase I-B で β版公開
completed_at: null                          # 自社プロダクト案件のため継続運用 — Phase I-B 検証完了は 2026-05-04

# === 言語スコープ ===
target_languages:
  - ja                                      # 必須
  # en は対象外(MeetingAI 国内提供開始)

# === 並列案件管理(★ 3 件並列の上限テスト)===
parallel_project_count: 3                   # aileap_v2 + aileap_meetingai_lp + 本案件 = 3 件
                                            # DPSAI_MAX_PARALLEL_PROJECTS=3 の上限

# === ハンドオフ参照 ===
apex_handoff_ref: APX-INTERNAL-MTG-BE-001  # 自社のため疑似ハンドオフ
parent_project: aileap_meetingai_lp        # ★ G-I-A-002 で発見した親案件参照(本案件で先行採用)
related_projects:
  - aileap_meetingai_lp                    # LP 申込み → 本案件バックエンドで処理
  - aileap_v2                              # AILEAP コーポレート(姉妹案件)
wmao_handoff_ref: null                      # B 系は WMAO 引継ぎ原則なし(本組織内継続運用)

# === KGI/KPI ===
kgi: |
  MeetingAI β版で 50 ユーザーが 30 件以上の会議録音を処理(公開後 90 日以内・PMF gate 判断材料)
kpi:
  - β版アクティブユーザー(WAU)20+ / Week 4
  - 録音 → 要約完了率 90% 以上
  - 平均要約精度(自己評価)4.0 / 5.0 以上
  - 議事録共有 → Slack/Teams 連携率 50% 以上
  - 月間 API レイテンシ p95 < 30 秒(録音 60 分の場合)

# === 主要関係者(B 系新規エージェント全動員)===
stakeholders:
  - role: 決裁者 / プロダクト責任者
    name: Shin
    email: shin@aileap.example
  - role: PMF 判断責任者
    name: product-director(B 系・v0.3 でフル稼働)
    email: internal
  - role: スプリント運営
    name: product-manager(B 系・新規)
    email: internal
  - role: 主実装(API / DB / 認証)
    name: backend-engineer(B 系・新規)
    email: internal
  - role: インフラ / CI/CD / 監視
    name: devops-engineer(B 系・新規)
    email: internal
  - role: テスト戦略
    name: qa-engineer(B 系・新規)
    email: internal

# === メモ ===
notes: |
  本案件は v0.3 Phase I-B の検証案件。
  目的:
  1. B 系新規エージェント 5 体の実戦投入(product-director / product-manager /
     backend-engineer / devops-engineer / qa-engineer)
  2. B 系新規スキル 5 個の動作検証(/pmf-validation, /sprint-plan,
     /api-design, /infra-plan, /e2e-test-plan)
  3. handoff-protocols.md §8(v0.3 補遺)の B 系受領フロー検証
  4. PMF gate(week 4)の Shin 判断プロセス検証
  5. 並列案件 3 件(aileap_v2 + aileap_meetingai_lp + 本案件)の上限動作確認

  既存連携:
  - aileap_meetingai_lp(LP)からの β 申込みを本案件バックエンドが処理
  - aileap_v2 デザインシステムを管理画面で継承(SaaS 内 UI 部分のみ)

  検証スコープ外:
  - 多言語(en)— MeetingAI 国内提供
  - 大規模データ分析(data-engineer 不在 — v0.4)
  - 大規模ユーザーリサーチ(user-researcher 不在 — v0.4)

  B 系の特殊スコープ(A 系との差分):
  - スプリント運営(2 週間サイクル × 4 スプリント想定)
  - PMF gate week 4(product-director 主担当)
  - WMAO 引継ぎなし(本組織内継続運用)
  - 公開後の継続改修が前提(LP のような「30 日 + 引継ぎ」モデルではない)

# === スコープ概要 ===
scope_summary:
  product_features:
    - β版申込み管理画面(管理者用 / 招待発行)
    - β版ユーザー認証(招待制・メールリンクのみ・パスワードレス)
    - 会議録音アップロード API(.mp3 / .m4a / .wav 対応・最大 1GB)
    - 会議要約 API(LLM API ラッパー / Whisper + Claude or GPT-4)
    - 議事録 PDF 生成(構造化された議事録 → PDF 出力)
    - β版利用統計ダッシュボード(管理者向け)
  out_of_scope_v1:
    - チーム / ワークスペース機能(個人ユーザー想定で v1.5 以降)
    - Slack / Teams 連携(v1.5 以降)
    - SSO(v2.0)
    - 課金機能(正式版から)
---

# AILEAP MeetingAI β版バックエンド + 管理画面

## 案件概要

aileap_meetingai_lp(A2 LP)から流入した β 版申込者に対して、実際に MeetingAI を提供する SaaS バックエンド + 管理画面を構築する。

本案件は **v0.3 Phase I-B の検証案件** として、B 系新規エージェント 5 体の実戦投入と、B 系新規スキル 5 個の動作検証を主目的とする。

### 本案件の三重性

| 観点 | 内容 |
|---|---|
| 表面的な意味 | MeetingAI β版本体(SaaS)の MVP 開発 |
| 検証的な意味 | digital-product-studio-ai v0.3 の B 系案件動作検証 1 サイクル |
| プロダクト的な意味 | AILEAP の自社プロダクト第 1 号(将来の収益柱候補)の PMF 検証 |

`internal_client: true` のため `commercial-manager` は internal mode。

## ディレクトリ構成

```
projects/aileap_meetingai_be/
├── PROJECT.md                              # 本ファイル
├── 00-engagement/                          # 契約・承認・決定ログ(B 系仕様)
├── 01-discovery/                           # ヒアリング + 要件 + product-discovery
├── 02-strategy/                            # product-strategy + product-roadmap + user-stories
├── 03-design/                              # api-spec + database-schema + design-notes
├── 04-implementation/                      # architecture + infra + sprint-plans/ + backlog
│   └── sprint-plans/                       # sprint-01 〜 sprint-04
├── 05-qa/                                  # e2e-test-plan + a11y(管理画面のみ)
├── 05-launch/                              # launch-checklist + handoff-package(SaaS 用)
├── 06-handoff/                             # pmf-validation-week-4 + 30day-report
└── validation-notes.md                     # 検証 gap
```

## 進行ルール(B 系特有)

- **スプリント 2 週間サイクル × 4 スプリント** を想定(8 週間 = 公開まで)
- **PMF gate week 4 を必須実施**(product-director 主担当・Shin 判断)
- **internal_client: true で commercial-manager は internal mode**(pricing-strategy.md §4.5)
- **WMAO 引継ぎは原則実施しない**(本組織内継続運用 — handoff-protocols.md §8.4 partial / none)

## 検証の観点(Phase I-B 特有)

1. **B 系新規エージェント 5 体の動員パターン確認**:
   - product-director: PMF 判断(week 4 gate)
   - product-manager: スプリント運営(4 スプリント)
   - backend-engineer: API + DB + 認証実装
   - devops-engineer: CI/CD + Vercel + Supabase + 監視
   - qa-engineer: E2E テスト + リグレッション
2. **B 系新規スキル 5 個の動作確認**:
   - /pmf-validation
   - /sprint-plan
   - /api-design
   - /infra-plan
   - /e2e-test-plan
3. **handoff-protocols.md §8 B 系受領フロー検証**(`product_specifics` の使い方)
4. **並列案件 3 件の上限動作**(session-start hook が 3 件を表示)
5. **B 系特有の WMAO 非引継ぎ運用**(partial scope = none)

検証結果は `validation-notes.md` に記録、Phase J(gap-analysis-v0.3.md)で集計。

## 関連 DEC(Phase I-B 内)

- DEC-001: 案件タイプを B1 SaaS MVP に確定
- DEC-002: スプリント長 2 週間 × 4 スプリント = 8 週間に確定
- DEC-003: PMF gate を week 4 に設定
- DEC-004: 技術スタック確定(Next.js + Supabase + Vercel)
- DEC-005: 認証方式は招待制 + メールリンク(パスワードレス)
- DEC-006: 録音処理は async(キュー経由・即時 → 完了通知)
- DEC-007: WMAO 引継ぎを none scope に確定(本組織内継続)
