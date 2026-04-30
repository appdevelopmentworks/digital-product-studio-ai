---
# PROJECT.md — AILEAP 自社サイト v2(Phase D 検証案件)

# === 識別子 ===
id: AILEAP-20260429-001
type: A1                                    # コーポレートサイト
status: active
phase: discovery                            # 起動時点

# === クライアント情報 ===
client_name: 株式会社 AILEAP                  # 法人名は仮(設立予定)
client_contact: Shin
client_email: shin@aileap.example
client_phone: ""
internal_client: true                       # ★ 自社案件 — 外部請求なし

# === タイムライン ===
created_at: 2026-04-29
target_launch_at: 2026-06-15                # 約1.5ヶ月後を目標
launched_at: null
completed_at: null

# === 言語スコープ ===
target_languages:
  - ja                                      # 必須
  # - en                                    # Phase 2 で検討(検証スコープ外)

# === 並列案件管理 ===
parallel_project_count: 1                   # 起動時点では本案件のみ

# === ハンドオフ参照 ===
apex_handoff_ref: APX-20260429-001          # apex 仮想ハンドオフ(検証用)
wmao_handoff_ref: null                      # 公開後 30 日経過後に発行

# === KGI/KPI ===
kgi: AILEAP として月間問い合わせ件数 30件達成(公開後 6ヶ月以内)
kpi:
  - オーガニック流入 1,000 UU/月
  - GEO 経由(LLM 参照)セッション 50 セッション/月
  - 採用エントリー 月 5件
  - フォーム CV 率 2.5%

# === 主要関係者 ===
stakeholders:
  - role: 決裁者 / 代表
    name: Shin
    email: shin@aileap.example
  - role: 主担当(自社のため Shin が兼務)
    name: Shin
    email: shin@aileap.example
  - role: コンテンツ提供者(社内全エージェント)
    name: copywriter / content-strategy-lead
    email: internal

# === メモ ===
notes: |
  本案件は v0.2 Phase D の検証案件。
  目的:
  1. 全エージェント(20体 + Q5)・全スキル(28個)・全 hook(8個)が動作することを検証
  2. テンプレート(21個)を実プロジェクトで使用し、過不足を洗い出す
  3. apex / WMAO ハンドオフプロトコルが現実的に動くか確認
  4. 検証で発見した課題を gap-analysis-v0.2.md に集約

  既存サイト: aileap-hazel.vercel.app (情報量不足・SEO 弱・GEO 未対応)
  改修内容: コーポレートサイトとして本格化(A1 案件相当)
  内部見積: 工数管理のみ(請求書発行なし、commercial-manager は internal mode)

  検証スコープ外:
  - 多言語対応(ja のみ。en は v0.3 で検証)
  - 大規模リブランド(A4 相当は v0.3)
  - B 系プロダクト機能(v0.3 以降)
---

# AILEAP 自社サイト v2

## 案件概要

AILEAP（apex-consulting-ai → digital-product-studio-ai → web-marketing-ai-org の3組織体制）の
コーポレートサイトを既存 `aileap-hazel.vercel.app` から本格的なコーポレートサイトに刷新する。

本案件は **v0.2 の Phase D 検証案件** として位置づけられ、digital-product-studio-ai 自身の
実装（21エージェント・28スキル・8 hook・21テンプレート）を実プロジェクトで動作確認する。

### 本案件の二重性

| 観点 | 内容 |
|---|---|
| 表面的な意味 | AILEAP 自社サイトの A1 コーポレートサイト案件 |
| 検証的な意味 | digital-product-studio-ai v0.2 の動作検証 1 サイクル |

`internal_client: true` のため、`commercial-manager` は内部見積モード（工数管理のみ）で動作する。

## ディレクトリ構成

```
projects/aileap_v2/
├── PROJECT.md                              # 本ファイル
├── 00-engagement/                          # 契約・承認・決定ログ
│   ├── apex-to-dpsai-handoff.yaml          # apex 仮想ハンドオフ
│   ├── approvals.yaml                      # 承認状態管理
│   ├── assets-required.yaml                # 必要素材(自社のため社内が provider)
│   ├── decisions.yaml                      # ADR 風意思決定ログ
│   ├── estimate.yaml                       # 内部見積(internal_client: true)
│   ├── sow.md                              # 業務範囲(内部版)
│   └── legal-review.yaml                   # 法務確認状態
├── 01-discovery/                           # ヒアリング・要件草案
│   ├── onboarding-notes.md                 # キックオフ議事録
│   └── requirements-v0.md                  # 要件定義 v0
├── 02-strategy/                            # 戦略・サイトマップ
│   ├── sitemap.md                          # 3階層サイトマップ
│   └── content-strategy.md                 # コンテンツ戦略(4柱)
├── 03-design/                              # デザインシステム
│   └── design-system.md                    # WCAG 2.2 AA 込み
├── 05-launch/                              # 公開チェックリスト
│   └── launch-checklist.md
├── 06-handoff/                             # WMAO 引継ぎ + 30日レポート
│   └── seo-geo-30day-report.md             # 検証用プレースホルダー
└── validation-notes.md                     # 検証で発見した gap 候補リスト
```

## 進行ルール

- 自社案件のため、外部クライアント案件と同等のワークフローで進める（検証目的）
- フェーズ遷移時は通常案件と同じく `decisions.yaml` に DEC-NNN を追記
- `commercial-manager` は internal mode で動作（請求書発行なし）
- 法務テンプレート（プライバシー / 特商法 / 利用規約）は弁護士確認を必須とする
  - ただし AILEAP 自社のため、Shin が「弁護士確認手配済み」とマークするタイミングで対応

## 検証の観点

1. **テンプレート整合性**: 21テンプレートが各フェーズで過不足なく使えるか
2. **エージェント動作**: 21エージェントが期待通り起動・委譲・エスカレーションするか
3. **スキル動作**: 28スキルが期待通り起動するか
4. **hook 動作**: 8 hook が WSL2 / Git Bash 環境で動くか
5. **ルール衝突**: rules ファイルが path-scoped で適切に作用するか
6. **言語ポリシー**: Layer 1/2/3 の分離が実プロジェクトで維持されるか
7. **承認ゲート**: approvals.yaml が phase 進行を適切にゲートするか
8. **ハンドオフ**: apex 受領・WMAO 引継ぎの YAML が運用に耐えるか
