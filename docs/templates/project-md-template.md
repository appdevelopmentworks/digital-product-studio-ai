# PROJECT.md テンプレート

**用途**: 各 `projects/<project_id>/` 配下に必ず1つ配置する正典メタデータ
**配置先**: `projects/<project_id>/PROJECT.md`
**参照**: `.claude/rules/project-scaffold.md` / `docs/quick-start.md`
**言語層**: Layer 1（日本語ベース、YAML キーは英語 snake_case）

---

## 使い方

1. 案件 ID（`<<CLIENT_ABBR>>-YYYYMMDD-NNN`）を確定する
2. 本テンプレートを `projects/<project_id>/PROJECT.md` にコピー
3. `<<PLACEHOLDER>>` を実値に置換
4. `created_at` に当日 ISO 日付を入れる
5. `phase: discovery` から開始（順送りでしか進まない）
6. フェーズ遷移時は本ファイルの `phase` を更新 + `00-engagement/decisions.yaml` に DEC-NNN を追記

---

## テンプレート本体

```yaml
---
# PROJECT.md — 案件メタデータの正典
# 1案件1ファイル / フィールド省略禁止（任意は空文字 "" で明示）

# === 識別子 ===
id: <<CLIENT_ABBR>>-<<YYYYMMDD>>-<<NNN>>   # 例: AXYZ-20260601-001
type: <<A1|A2|A3|Internal>>                # v0.2 で扱える 4 種
status: active                              # active | paused | completed | archived
phase: discovery                            # discovery → strategy → design → implementation → staging → launch → post-launch

# === クライアント情報 ===
client_name: <<株式会社サンプル>>             # 法人格込みの正式名称
client_contact: <<田中 太郎>>                # 主担当者氏名
client_email: <<tanaka@example.com>>        # 主担当者メールアドレス
client_phone: <<03-0000-0000>>              # 任意。なければ ""
internal_client: false                      # AILEAP 自社案件のときのみ true

# === タイムライン ===
created_at: <<YYYY-MM-DD>>                  # 案件初期化日
target_launch_at: <<YYYY-MM-DD>>            # 目標公開日（暫定可）
launched_at: null                           # 公開日（公開時に記入）
completed_at: null                          # archive 時に記入

# === 言語スコープ ===
target_languages:
  - ja                                      # 必須(必ず ja を含める)
  # - en                                    # スコープ確定時にコメント解除
  # - zh
  # - ko

# === 並列案件管理 ===
parallel_project_count: <<1>>               # 起動時点で同時に進行している案件数
# v0.2 上限: 3案件(DPSAI_MAX_PARALLEL_PROJECTS)
# 4 案件目を起こすときは studio-director の承認が必要

# === ハンドオフ参照 ===
apex_handoff_ref: null                      # apex-consulting-ai からの引継ぎ ID(あれば)
wmao_handoff_ref: null                      # WMAO への引継ぎ ID(完了時)

# === KGI/KPI(初期ヒアリングで埋める) ===
kgi: <<未確定 / 例: 月間問い合わせ 30件達成>>
kpi:
  - <<未確定 / 例: オーガニック流入 1,000 UU/月>>
  - <<未確定 / 例: フォーム CV 率 2.5%>>

# === 主要関係者 ===
stakeholders:
  - role: 決裁者
    name: <<未確認>>
    email: <<未確認>>
  - role: 主担当
    name: <<田中 太郎>>
    email: <<tanaka@example.com>>
  - role: コンテンツ提供者
    name: <<未確認>>
    email: <<未確認>>

# === メモ(任意) ===
notes: |
  <<案件特有の要点をここに残す。例:
  - apex から「採用強化」の戦略コンテキストあり
  - 既存 WordPress サイトからの移行案件
  - 公開予定日が固い(展示会連動)>>
---

# <<案件名 / 例: 株式会社サンプル コーポレートサイト>>

## 案件概要

<<2-3行で案件の目的・スコープを記述>>

## ディレクトリ構成

```
projects/<<id>>/
├── PROJECT.md                  # 本ファイル
├── 00-engagement/              # 契約・承認・決定ログ
│   ├── approvals.yaml
│   ├── decisions.yaml
│   ├── assets-required.yaml
│   ├── estimate.yaml
│   ├── sow.md
│   └── legal-review.yaml
├── 01-discovery/               # ヒアリング・要件草案
│   ├── onboarding-notes.md
│   └── requirements-v0.md
├── 02-strategy/                # 戦略・サイトマップ
│   ├── sitemap.md
│   ├── content-strategy.md
│   └── i18n-strategy.md         # 多言語案件のみ
├── 03-design/                  # デザインシステム + 画面
│   ├── design-system.md
│   └── screens/
├── 04-implementation/          # 実装(リポジトリ参照のみここに残す)
├── 05-launch/                  # 公開チェックリスト
└── 06-handoff/                 # WMAO 引継ぎ + 30日レポート
    ├── seo-geo-30day-report.md
    └── dpsai-to-wmao-handoff.yaml
```

## 進行ルール

- フェーズ遷移は順送りのみ。スキップは studio-director 承認 + DEC-NNN 必須
- 法務テンプレート(プライバシーポリシー / 特商法 / 利用規約)は弁護士確認が完了するまで
  `lawyer_confirmation: false` を維持する
- 並列案件 3 を超えるときは studio-director に必ずエスカレーション
```

---

## チェックリスト（このファイルを作成し終えた直後に確認）

- [ ] `id` がプロジェクト命名規則 `{CLIENT_ABBR}-{YYYYMMDD}-{NNN}` に従っている
- [ ] `type` が A1 / A2 / A3 / Internal のいずれか
- [ ] `phase` が `discovery` から開始している
- [ ] `target_languages` に `ja` が含まれている
- [ ] `created_at` が ISO 8601 (`YYYY-MM-DD`) 形式
- [ ] 並列案件数を確認し、3 を超えないことを確認した
- [ ] `00-engagement/` 直下のディレクトリ枠だけ先に切ってある

---

## よくある間違い

| 誤り | 正しい書き方 |
|---|---|
| `id: axyz-20260601-001` | `id: AXYZ-20260601-001`（クライアント略称は大文字） |
| `phase: implementation` で開始 | `phase: discovery` で開始 |
| `created_at: 2026/06/01` | `created_at: 2026-06-01` |
| `internal_client: True` | `internal_client: true`（小文字） |
| `target_languages: ja, en` | YAML 配列で記述（`- ja` `- en`） |
