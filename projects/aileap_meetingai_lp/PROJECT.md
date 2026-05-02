---
# PROJECT.md — AILEAP MeetingAI 紹介 LP(Phase I-A 検証案件)

# === 識別子 ===
id: AILEAP-MTG-20260601-001
type: A2                                    # ランディングページ
status: active                              # Phase I-A 完走後も継続運用
phase: post-launch                          # discovery → strategy → design → implementation → qa → launch → post-launch (Phase I-A 完走 2026-05-02)

# === クライアント情報 ===
client_name: 株式会社 AILEAP(自社・MeetingAI 事業部)
client_contact: Shin
client_email: shin@aileap.example
client_phone: ""
internal_client: true                       # ★ 自社案件 — 外部請求なし

# === タイムライン ===
created_at: 2026-06-01
target_launch_at: 2026-06-30                # 約 2 週間後を目標(A2 標準)
launched_at: 2026-06-30                     # Phase I-A で公開
completed_at: null                          # 自社案件のため継続運用 — Phase I-A 検証完了は 2026-05-02

# === 言語スコープ ===
target_languages:
  - ja                                      # 必須
  # en は対象外(MeetingAI は国内提供から開始)

# === 並列案件管理 ===
parallel_project_count: 2                   # aileap_v2(post-launch 継続)+ 本案件

# === ハンドオフ参照 ===
apex_handoff_ref: APX-INTERNAL-MTG-001     # 自社のため疑似ハンドオフ
wmao_handoff_ref: null                      # 公開後 30 日経過後に発行

# === KGI/KPI ===
kgi: MeetingAI β 版申込件数 50 件達成(公開後 3 ヶ月以内)
kpi:
  - LP 流入 UU 月 2,000(GA4)
  - β 版申込フォーム CV 率 5%(=月 100 件想定)
  - 公開後 14 日以内に LLM 引用検出 3 件
  - 平均ページ滞在時間 60 秒以上

# === 主要関係者 ===
stakeholders:
  - role: 決裁者 / 代表
    name: Shin
    email: shin@aileap.example
  - role: プロダクト責任者(MeetingAI)
    name: Shin(兼務)
    email: shin@aileap.example
  - role: コピー監修
    name: copywriter / content-strategy-lead
    email: internal

# === メモ ===
notes: |
  本案件は v0.3 Phase I-A の検証案件。
  目的:
  1. /team-landing-page スキルの動作検証(A2 軽量フロー)
  2. A2 案件タイプでのエージェント動員パターン確認
  3. aileap_v2 デザインシステムの継承動作確認(art-direction-lead が他案件で再利用できるか)
  4. internal_client mode の継続検証(commercial-manager の連続運用)
  5. Phase H の知見を Phase I-A で再利用できるか確認

  既存連携:
  - aileap_v2(`/services/landing-page` ページから本 LP に CTA 経由で誘導)
  - aileap_v2 ブログ「MeetingAI とは」記事との整合性

  検証スコープ外:
  - 多言語(en)対応 — MeetingAI は国内提供開始のため
  - メディアサイト化 — A2 のため LP 単発
  - 大規模カスタムデザイン — aileap_v2 の design-system を継承

  A2 軽量フローの特徴(A1 との差分):
  - ux-strategy-lead は不要(LP はサイトマップ単純 — top + thank you)
  - cms-engineer は不要(LP は静的 + フォームのみ)
  - 初期記事制作不要(コンテンツは LP 1 ページのみ)
  - 法務テンプレは privacy のみ(利用規約・特商法は不要)
---

# AILEAP MeetingAI 紹介 LP

## 案件概要

AILEAP の自社プロダクト「MeetingAI」のβ版申込みを獲得する LP を制作する。
2026 Q3 のβ版開始に向けたマーケティング起点 LP として位置づけ。

本案件は **v0.3 Phase I-A の検証案件** として、A2 軽量フローを 1 サイクル完走することで:

- /team-landing-page スキルの動作確認
- A2 案件タイプの体制(動員エージェント・スキル・hook)の妥当性検証
- aileap_v2(A1 完走済)のデザインシステム継承の動作確認
- internal_client mode の連続運用検証

を達成する。

### 本案件の二重性

| 観点 | 内容 |
|---|---|
| 表面的な意味 | MeetingAI β版申込み獲得 LP |
| 検証的な意味 | digital-product-studio-ai v0.3 の A2 案件動作検証 1 サイクル |

`internal_client: true` のため `commercial-manager` は internal mode で動作。

## ディレクトリ構成

```
projects/aileap_meetingai_lp/
├── PROJECT.md                              # 本ファイル
├── 00-engagement/                          # 契約・承認・決定ログ
├── 01-discovery/                           # ヒアリング・要件
├── 02-strategy/                            # 戦略
├── 03-design/                              # デザイン(aileap_v2 継承)
├── 04-implementation/                      # 実装ノート
├── 05-qa/                                  # 監査
├── 05-launch/                              # 公開チェックリスト
├── 06-handoff/                             # WMAO 引継ぎ + 30日レポート
└── validation-notes.md                     # 検証で発見した gap
```

## 進行ルール

- 自社案件のため Shin がクライアント役を兼務
- A2 軽量フローを採用(A1 比較で discovery / strategy 各 50% 程度の工数)
- aileap_v2 のデザインシステムを継承(差分のみ design 文書化)
- 法務は privacy のみ弁護士確認(他は対象外)

## 検証の観点(Phase I-A 特有)

1. **A2 軽量フロー**: 全 28+ スキルのうち A2 で必要なものに絞れているか
2. **エージェント動員パターン**: ux-strategy-lead 不在で UX が成立するか
3. **デザインシステム継承**: art-direction-lead が aileap_v2 design-system をどう参照するか
4. **internal_client mode 連続運用**: commercial-manager が 2 連続案件で正しく動作するか
5. **並列案件管理**: aileap_v2(post-launch)+ 本案件(active)の並列で session-start hook が表示するか
6. **/team-landing-page スキル**: orchestration が動作するか

検証結果は `validation-notes.md` に記録、Phase J(gap-analysis-v0.3.md)で集計。

## 関連 DEC(Phase I-A 内)

- DEC-001: 案件タイプを A2 に確定(LP 1 ページ)
- DEC-002: en 化スコープアウト(MeetingAI 国内開始のため)
- DEC-003: aileap_v2 デザインシステムを継承(art-direction-lead が差分のみ追加)
- DEC-004: internal mode 採用(自社プロダクト LP)
- DEC-005: フォームは Resend + reCAPTCHA(aileap_v2 と同一スタック継承)
