# ハンドオフプロトコル仕様書

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 2.2 の詳細仕様
**対象プロトコル**: apex ↔ digital-product-studio-ai ↔ web-marketing-ai-org

---

## 0. 本書の目的と前提

### 0.1 目的

AILEAP の 3 組織アーキテクチャ間で受け渡す情報の YAML スキーマを正式定義する。本書で定義された YAML フィールドは、実装時にエージェントプロンプト・スキル・テンプレートから直接参照される。

### 0.2 整合状況に関する注記

本書執筆時点(2026-04-27)で apex-consulting-ai と web-marketing-ai-org の両リポジトリには digital-product-studio-ai とのハンドオフプロトコルは未定義である(本組織側が後発のため)。

そのため本書は **digital-product-studio-ai 側で先行的にスキーマを定義** し、apex / WMAO 側には Phase D 検証時または v0.3 着手時に反映を依頼する形を取る。スキーマ反映の依頼は別タスク扱いとする。

### 0.3 4 つのプロトコル一覧

| プロトコル | 起動側 | 受領側 | 用途 | YAML スキーマ |
|---|---|---|---|---|
| `/handoff-from-strategy` | apex | digital-product-studio-ai | 経営戦略 → Web プロダクト着手 | Section 2 |
| `/escalate-to-strategy` | digital-product-studio-ai | apex | Web では解決すべきでない経営課題 | Section 3 |
| `/handoff-to-marketing` | digital-product-studio-ai | WMAO | 公開 + 30 日検証完了 | Section 4 |
| `/handoff-back-to-production` | WMAO | digital-product-studio-ai | サイト改修・リニューアル必要 | Section 5 |

### 0.4 共通フィールド

すべてのプロトコルで以下のフィールドは共通とする。

```yaml
handoff_id: HO-YYYYMMDD-NNN     # 例: HO-20260501-001(日付 + 連番)
protocol: <protocol-name>        # 例: handoff-from-strategy
version: 0.2                     # スキーマバージョン
from:
  organization: <org-name>       # apex-consulting-ai / digital-product-studio-ai / web-marketing-ai-org
  agent: <agent-name>            # 起動エージェント
  timestamp: 2026-05-01T10:00:00+09:00
to:
  organization: <org-name>
  agent: studio-director         # 通常は受領側の Tier 0 エージェント
status: draft | submitted | accepted | rejected
notes: <free text>               # 任意
```

### 0.5 命名規則

- フィールド名: **snake_case**
- ファイル名: `handoff-{protocol}-{handoff_id}.yaml`
- 例: `handoff-from-strategy-HO-20260501-001.yaml`

---

## 1. ハンドオフ全体フロー

### 1.1 フロー図

```
┌───────────────────────────────────────────────────────────────┐
│ apex-consulting-ai                                            │
│                                                               │
│  経営戦略レポート完成 → 「Web 必要」と判断                    │
│       │                                                       │
│       ▼  /handoff-from-strategy                              │
└───────┼───────────────────────────────────────────────────────┘
        │
        ▼  YAML + 添付資料(PDF / .md)
┌───────┼───────────────────────────────────────────────────────┐
│ digital-product-studio-ai                                     │
│       ▼                                                       │
│  studio-director 受領                                        │
│  ├ 案件 ID 採番 → projects/{client}_{id}/ 生成               │
│  ├ 案件タイプ判定                                            │
│  ├ /team-{type} 起動                                         │
│  └ Discovery → ... → Launch → Post-launch (30 日検証)        │
│                                              │                │
│  逆方向: /escalate-to-strategy ─→ apex に戻す               │
│                                              │                │
│                                              ▼                │
│                                       /handoff-to-marketing  │
└──────────────────────────────────────────────┼───────────────┘
                                               │
                                               ▼
┌──────────────────────────────────────────────┼───────────────┐
│ web-marketing-ai-org (WMAO)                  ▼                │
│                                                               │
│  運用開始(継続 SEO / GEO / コンテンツ / 広告 / SNS)         │
│       │                                                       │
│  逆方向: /handoff-back-to-production ─→ 本組織に戻す         │
└───────────────────────────────────────────────────────────────┘
```

### 1.2 ハンドオフを起動できるエージェント

| プロトコル | 起動権限を持つエージェント |
|---|---|
| `/handoff-from-strategy` | apex 側の Studio Director 相当(本組織側からは起動不可) |
| `/escalate-to-strategy` | studio-director(本組織) |
| `/handoff-to-marketing` | studio-director / delivery-director(本組織) |
| `/handoff-back-to-production` | WMAO 側の Director 相当(本組織側からは起動不可) |

### 1.3 ハンドオフ前提条件

| プロトコル | 前提条件 |
|---|---|
| `/handoff-from-strategy` | apex 側で経営戦略レポート完成・Web プロダクトが必要と判断 |
| `/escalate-to-strategy` | 本組織の studio-director が「Web で解決すべきでない」と判断、Shin の最終承認 |
| `/handoff-to-marketing` | 公開後 30 日経過 + Post-launch 検証完了 + Shin の最終承認 |
| `/handoff-back-to-production` | WMAO 側で「サイト構造改修必要」と判断、Shin の最終承認 |

すべてのハンドオフは Shin の最終承認を経て実行される(自動化しない)。

---

## 2. /handoff-from-strategy(apex → 本組織)

### 2.1 用途

apex-consulting-ai が経営戦略策定の結果として「Web プロダクト構築が必要」と判断した場合に、本組織へ案件を引き渡すプロトコル。

### 2.2 YAML スキーマ

```yaml
handoff_id: HO-20260501-001
protocol: handoff-from-strategy
version: 0.2
from:
  organization: apex-consulting-ai
  agent: <apex Tier 0 agent name>
  timestamp: 2026-05-01T10:00:00+09:00
to:
  organization: digital-product-studio-ai
  agent: studio-director
status: submitted

# クライアント情報
client:
  name: <クライアント名>
  industry: <業界>
  size: SME              # SME / mid-market / enterprise(本組織の対象は SME 中心)
  decision_maker:
    name: <氏名>
    role: <役職>
    contact: <メール / 電話>
  stakeholders:          # 決裁者以外のキーパーソン
    - name: <氏名>
      role: <役職>
      relationship: <関係性>

# 戦略文脈(apex の成果物サマリー)
strategic_context:
  business_objective: <事業目的・1-2 文>
  target_audience: <ターゲット顧客像>
  competitive_position: <競合上の位置づけ>
  digital_strategy: <デジタル戦略全体像・3-5 文>
  why_web: <なぜ Web が必要か・1-2 文>

# プロジェクトブリーフ
project_brief:
  recommended_channels:  # apex が推奨するチャネル
    - web
    - app
    - other: <記述>
  project_type:          # 想定する案件タイプ([requirements-v0.2.md] Section 1.2 参照)
    primary: A1          # A1-C3 のいずれか
    fallback: A2         # 予算次第で代替案
  kgi: <経営 KPI・1-2 個>
  budget_range:
    min: 500000          # 単位: 円
    max: 1500000
    currency: JPY
  timeline:
    desired_launch: 2026-08-31
    flexibility: hard | soft  # hard = 動かせない、soft = 多少動く
  constraints:
    - 既存 CMS は WordPress 維持
    - 月間 PV 5 万を想定
    - 多言語対応必要(日英中)

# 添付資料
attachments:
  - path: apex_strategy_report.pdf
    type: strategy_report
    description: 経営戦略レポート(本書の根拠)
  - path: market_analysis.pdf
    type: market_analysis
  - path: competitor_landscape.md
    type: competitor_analysis

notes: |
  クライアントは AILEAP との初回案件。意思決定はスピード重視で、
  最短ローンチを優先する傾向あり。
```

### 2.3 受領側の必須アクション

`studio-director` が `/handoff-from-strategy` を受領した時に実行する処理:

1. **案件 ID 採番**: `delivery-director` が `{client-name-slug}_YYYYMMDD-NNN` 形式で採番
2. **ディレクトリ生成**: `projects/{id}/` 配下を [requirements-v0.2.md](requirements-v0.2.md) Section 10.2 のテンプレに従って生成
3. **ハンドオフ YAML 保存**: `projects/{id}/00-engagement/handoff-from-strategy.yaml` に保存
4. **添付資料コピー**: `attachments` 配下を `projects/{id}/00-engagement/from-apex/` にコピー
5. **案件タイプ確定**: `project_brief.project_type.primary` を読み、`/team-{type}` を起動
6. **初回ヒアリング準備**: `client-success-lead` が `/client-onboarding` を起動準備

### 2.4 受領拒否(reject)ケース

以下の場合は studio-director が `status: rejected` で apex に差戻す:

- 必須フィールド(client / strategic_context / project_brief)に欠落あり
- 案件タイプが本組織で対応不可(v0.2 段階で B 系 / C 系・C3 を除く)
- 予算と工数が著しく乖離(commercial-manager が見積試算で +50% 以上のギャップ)
- クライアントが既に並列上限(2-3 案件)に達している

差戻し時は `notes` に理由を明記する。

---

## 3. /escalate-to-strategy(本組織 → apex)

### 3.1 用途

本組織が案件遂行中に「これは Web で解決すべきでなく、経営課題に立ち戻る必要がある」と判断した場合に apex へ戻すプロトコル(B-H1 対応)。

### 3.2 起動の典型ケース

- Discovery フェーズで「事業モデル自体に課題がある」と判明(例: 提供価値が市場とずれている)
- KGI/KPI が本組織のスコープ(Web チャネル)では達成不可能と判明
- クライアント側の組織体制が変革されないと Web プロダクトが機能しない
- M&A や事業譲渡など apex の領域に立ち戻る判断が必要

### 3.3 YAML スキーマ

```yaml
handoff_id: HO-20260520-001
protocol: escalate-to-strategy
version: 0.2
from:
  organization: digital-product-studio-ai
  agent: studio-director
  timestamp: 2026-05-20T15:00:00+09:00
to:
  organization: apex-consulting-ai
  agent: <apex Tier 0 agent name>
status: submitted

# 関連案件
project:
  id: <project-id>
  client: <クライアント名>
  current_phase: discovery | strategy | design | implementation
  original_handoff_id: HO-20260501-001  # 順方向ハンドオフへの参照

# エスカレーション理由
escalation:
  reason_category: business_model | organizational | market_fit | scope_mismatch | other
  summary: <1-2 文・なぜ apex に戻すか>
  detailed_findings: |
    本組織が Discovery フェーズで以下を発見した:
    - 想定 KGI(月間問い合わせ 100 件)は現在の事業モデルでは到達不可能
    - クライアントの提供価値が市場の支払意思と乖離している
    - Web 改修だけではなく、商品設計から見直す必要

# 本組織での確認事項
verification:
  consulted_agents:
    - studio-director
    - delivery-director
    - strategy-director
  shin_approval: true
  shin_approval_date: 2026-05-19
  alternative_considered: |
    Web 上での A/B テスト・LP 改善で吸収できるか検討したが、
    根本的な事業モデル課題のため Web 単独での解決は不可と判断

# 引継ぎ資料
artifacts:
  - path: 01-discovery/findings-summary.md
    description: Discovery フェーズで発見した課題サマリー
  - path: 00-engagement/meetings/2026-05-15_kickoff.md
    description: クライアントとのキックオフ議事録

# 期待するアクション
expected_action:
  type: business_model_review | organizational_consulting | market_fit_validation
  urgency: high | medium | low
  client_relationship: continue | pause | terminate
  reentry_to_production:
    expected: true | false
    estimated_timing: 2026-09 以降

notes: |
  クライアントには既に「経営戦略の再検討が必要」とお伝え済み。
  apex から再度コンタクトを取っていただきたい。
```

### 3.4 起動側の必須アクション

`studio-director` が `/escalate-to-strategy` を起動する前に実行する処理:

1. **Shin の最終承認取得**: 必須(自動エスカレーションは禁止)
2. **YAML 生成**: 上記スキーマに従って `projects/{id}/00-engagement/escalate-to-strategy.yaml` に保存
3. **クライアント通知ドラフト**: client-success-lead が説明メールのドラフト生成
4. **案件ステータス更新**: `PROJECT.md` に `status: escalated_to_strategy` を記録
5. **apex への送付**: 手動で apex リポジトリに YAML + 関連 artifacts をコピー(v0.2 では自動化しない)

### 3.5 案件の取扱い

エスカレーション後の案件状態:

- `current_phase` を `escalated` に変更
- 該当案件のエージェント動員を停止
- session-state は保持(再着手の可能性)
- 90 日経過しても apex から進展なしなら `_archive/` へ移動

---

## 4. /handoff-to-marketing(本組織 → WMAO)

### 4.1 用途

本組織が公開を完遂し、Post-launch 30 日検証フェーズを終えた段階で WMAO に運用を引き渡すプロトコル。

### 4.2 起動条件(必須)

- Post-launch フェーズ着手後 30 日以上経過
- 初動 SEO/GEO 検証完了(seo-geo-strategist の 30 日レポートあり)
- 初期コンテンツ 5-10 本完成(B-C2 対応・メディアサイト案件)
- Shin の最終承認

### 4.3 YAML スキーマ

```yaml
handoff_id: HO-20260901-001
protocol: handoff-to-marketing
version: 0.2
from:
  organization: digital-product-studio-ai
  agent: delivery-director
  timestamp: 2026-09-01T10:00:00+09:00
to:
  organization: web-marketing-ai-org
  agent: <WMAO Tier 0 agent>
status: submitted

# プロジェクト情報
project:
  id: <project-id>
  client: <クライアント名>
  type: A1 | A2 | A3       # 案件タイプ
  url: https://example.com
  staging_url: https://staging.example.com
  launched_at: 2026-08-01
  post_launch_period_end: 2026-08-31  # 30 日検証完了日
  original_handoff_id: HO-20260501-001  # apex からのハンドオフへの参照

# 引継ぎ成果物(必須)
delivered_assets:
  strategy:
    - path: 02-strategy/sitemap.md
    - path: 02-strategy/content-strategy.md
    - path: 02-strategy/seo-geo-strategy.md
    - path: 02-strategy/measurement-plan.md
  design:
    - path: 03-design/design-system.md
  research:
    - path: 01-discovery/persona.md
    - path: 01-discovery/user-journey-map.md
    - path: 01-discovery/competitor-analysis.md
  delivery:
    - path: 08-handoff/cms-manual.md
    - path: 08-handoff/handoff-package.md
  post_launch_report:
    - path: 07-post-launch/30day-report.md
    - description: 公開後 30 日の SEO/GEO 初動分析

# クライアント関係
client_relationship:
  decision_maker:
    name: <氏名>
    role: <役職>
    contact: <連絡先>
    preferred_channel: email | slack | chatwork
  cms_credentials:
    cms_type: WordPress | Headless | Static
    admin_url: <URL>
    credentials_location: 01-discovery/credentials/cms.yaml.encrypted
  cms_users:
    - role: editor
      name: <氏名>
      can_publish: true
  approval_history:
    path: 00-engagement/approvals.yaml

# 公開後の目標
post_launch_targets:
  kgi:
    metric: 月間問い合わせ件数
    current_value: 5         # ローンチ時点
    target_value: 30         # 6 ヶ月後
    target_date: 2027-02-28
  kpi:
    - metric: オーガニック流入
      current_value: 100     # 月間 UU
      target_value: 1000
      target_date: 2027-02-28
    - metric: GEO 流入(LLM 経由)
      current_value: 0
      target_value: 50       # 月間 UU
      target_date: 2027-02-28
    - metric: 平均ページ滞在時間
      current_value: 45
      target_value: 90
      target_date: 2027-02-28
      unit: seconds

# 初期コンテンツ実績
initial_content:
  count: 7  # 初期コンテンツの本数
  list:
    - path: content/blog/2026-08-05-product-launch.md
      title: <タイトル>
      published_at: 2026-08-05
    - path: content/blog/2026-08-12-feature-x.md
      title: <タイトル>
      published_at: 2026-08-12
  remaining_to_wmao: true  # 11 本目以降は WMAO で制作
  content_calendar_provided: true

# 保守 SLA
maintenance:
  contract_type: retainer | break_fix | none
  monthly_fee: 50000      # 単位: 円
  sla:
    response_time: 24h    # 障害発生から
    resolution_time: 72h  # 軽微な改修
    uptime_target: 99.5
  contact:
    technical: tech@aileap.example
    billing: billing@aileap.example

# WMAO への期待
expected_wmao_actions:
  immediate:
    - 月間流入レポートの定期発行(月 1 回)
    - GEO 引用状況のモニタリング
    - 初期コンテンツ 5-10 本以降の継続コンテンツ制作(11 本目から)
  medium_term:
    - キーワード順位改善
    - SNS 運用立ち上げ
    - 広告運用開始(必要に応じて)
  long_term:
    - LTV 最大化
    - 顧客 NPS 向上

# 既知の課題・残課題
known_issues:
  - severity: medium
    description: モバイル版のヒーローアニメーションが iOS 16 以下で重い
    workaround: Reduce Motion 検出時は静止画
    fix_planned: v1.1 で対応予定(v0.4 段階)
  - severity: low
    description: 多言語の中国語版は機械翻訳ベース
    workaround: 主要ページのみ人手レビュー済
    fix_planned: WMAO 運用中にネイティブレビュー依頼

notes: |
  本案件は AILEAP 自社サイトの一例であり、Phase D 検証案件として実装。
  WMAO は本案件で AILEAP 自身の運用も学習することができる。
```

### 4.4 起動側の必須アクション

`delivery-director` が `/handoff-to-marketing` を起動する前に実行する処理:

1. **Post-launch 30 日経過の確認**: `delivery-director` の gate-check
2. **30 日レポート完成確認**: `seo-geo-strategist` が `07-post-launch/30day-report.md` を完成
3. **Shin の最終承認**: 必須
4. **YAML 生成**: 上記スキーマに従って `projects/{id}/08-handoff/handoff-to-marketing.yaml` に保存
5. **artifacts コピー**: `delivered_assets` に列挙した全ファイルを `projects/{id}/08-handoff/wmao-package/` にコピー
6. **WMAO への送付**: 手動で WMAO リポジトリに YAML + パッケージをコピー(v0.2 では自動化しない)

### 4.5 受領側の必須アクション(WMAO 側・参考)

WMAO 側が受領時に実施することを期待する処理(WMAO 側で別途プロトコル化が必要):

1. ハンドオフ YAML の必須フィールド検証
2. WMAO 内の運用案件として登録
3. 月次レポートテンプレートの初期化
4. 初動 30 日のベースライン記録
5. クライアントへの WMAO 担当者紹介(client-success-lead 経由)

---

## 5. /handoff-back-to-production(WMAO → 本組織)

### 5.1 用途

WMAO が運用中に「サイト構造の改修・大規模リニューアル・新機能追加が必要」と判断した場合に本組織へ戻すプロトコル(B-H2 対応)。

### 5.2 起動の典型ケース

- 流入は増えたが CV 改善が頭打ちで、UX 構造を見直す必要
- 新規事業ライン追加で、サイトに新セクション・新サブドメインが必要
- 競合の構造変化に追従するため、サイト構造そのものを再設計する必要
- 大規模リブランド改修(A4 タイプ案件として再受注)

### 5.3 YAML スキーマ

```yaml
handoff_id: HO-20271001-001
protocol: handoff-back-to-production
version: 0.2
from:
  organization: web-marketing-ai-org
  agent: <WMAO Tier 0 agent>
  timestamp: 2027-10-01T10:00:00+09:00
to:
  organization: digital-product-studio-ai
  agent: studio-director
status: submitted

# 関連案件
original_project:
  id: <original-project-id>
  client: <クライアント名>
  url: https://example.com
  original_handoff_to_marketing: HO-20260901-001
  operating_period: 13 months  # WMAO 運用期間

# 改修要望
production_request:
  type: renewal | feature_addition | rebranding | new_section | infrastructure_migration
  scope_summary: <1-2 文>
  detailed_requirements: |
    1. 既存トップページの情報設計を全面再構築
    2. SaaS プロダクトページを新設(現状は LP 単発)
    3. 多言語(中国語・韓国語)を追加
  business_driver: |
    流入は前年比 +180% に成長したが、CV 率が改善しない。
    UX 構造の根本見直しが必要との判断。

# WMAO 側のデータ・知見引継ぎ
wmao_findings:
  user_behavior:
    - heatmap_summary: ヒーローセクションのスクロール率 35%、想定 60% を下回る
    - exit_pages: 導入事例ページの離脱率 80%
    - search_queries: ブランド名 + 「料金」が月 500 件、料金ページ未整備
  content_performance:
    top_performing:
      - path: /blog/2027-03-feature-x
        sessions: 5000
    underperforming:
      - path: /blog/2026-09-launch
        sessions: 50
  seo_status:
    branded_keywords_avg_rank: 1.2
    non_branded_keywords_avg_rank: 28
    geo_citations: 月間 30 件(LLM 引用)

# 期待する案件タイプ
expected_project_type:
  primary: A4    # リブランド改修
  fallback: C3   # リニューアル + 機能拡張
  estimated_budget:
    min: 1500000
    max: 4000000
    currency: JPY
  desired_timeline: 2027-12 着手、2028-03 ローンチ目標

# 添付データ
attachments:
  - path: wmao_operating_report_13months.md
    description: WMAO 運用 13 ヶ月の総合レポート
  - path: heatmap_data/
    description: Hotjar / Microsoft Clarity 等のヒートマップデータ
  - path: ga4_export/
    description: GA4 エクスポート(過去 13 ヶ月)

notes: |
  クライアントには既に「サイト構造改修が必要」とお伝え済み。
  予算枠も内諾を得ている。
```

### 5.4 受領側の必須アクション

`studio-director` が `/handoff-back-to-production` を受領した時に実行する処理:

1. **既存案件 ID の確認**: `original_project.id` が `_archive/` にある場合は復活させる
2. **新規案件 ID 採番**: 改修案件として新 ID を採番(元案件と紐付け)
3. **ディレクトリ生成**: `projects/{new-id}/` を生成、`PROJECT.md` に `original_project_id` を記録
4. **ハンドオフ YAML 保存**: `projects/{new-id}/00-engagement/handoff-back-to-production.yaml`
5. **WMAO データのインポート**: `attachments` を `projects/{new-id}/00-engagement/from-wmao/` にコピー
6. **案件タイプ判定**: `expected_project_type.primary` を起点に `/team-{type}` 起動
7. **過去成果物の参照設定**: 元案件の `08-handoff/` を参照可能にする(path-scoped rule の例外として明示許可)

---

## 6. ハンドオフ運用の実務上の注意

### 6.1 自動化の段階

| バージョン | 自動化レベル |
|---|---|
| v0.2 | 手動コピー(別リポジトリ間でファイルコピー) |
| v0.3 | 半自動(スクリプトでパッケージング、コピーは手動) |
| v0.4 | 完全自動(GitHub Actions / Webhook 等で連携) |

v0.2 段階では Shin が手動でファイルを別リポジトリにコピーする運用とする。

### 6.2 認証情報の取扱

`/handoff-to-marketing` で WMAO に渡す `cms_credentials` などの認証情報は:

- 平文でリポジトリに含めない
- `01-discovery/credentials/` に暗号化して保存(path-scoped rule `secrets.md` の対象)
- ハンドオフパッケージに含める際は別経路(暗号化メール / 1Password 等)で受け渡し
- YAML には `credentials_location` パスのみ記載

### 6.3 ハンドオフのバージョン管理

ハンドオフ YAML は git 管理し、修正時は新しい `handoff_id` で発行する(既存を上書きしない)。

例:
- HO-20260501-001(初回送付・rejected)
- HO-20260502-001(修正再送)

### 6.4 ハンドオフ後のフォローアップ

- `/handoff-from-strategy` 受領後 7 日以内に apex へ「受領確認」を返す
- `/handoff-to-marketing` 受領後 7 日以内に WMAO へ「運用開始確認」を返す
- 確認応答も YAML 形式で記録する

確認応答の YAML スキーマ(簡易):

```yaml
handoff_response:
  for_handoff_id: HO-20260501-001
  responding_organization: digital-product-studio-ai
  status: accepted | needs_clarification | rejected
  response_at: 2026-05-03T14:00:00+09:00
  next_actions:
    - 案件 ID 採番完了: PRJ-20260503-001
    - /team-corporate-site 起動済
  questions:  # needs_clarification の場合のみ
    - "予算上限 150 万は税込か税抜か明示してほしい"
```

---

## 7. テンプレート

実装時のテンプレートは [agent-roster.md](agent-roster.md) Section X(後続) と各エージェントプロンプトに反映される。本書のスキーマは正本として参照される。

ハンドオフ YAML の雛形は `docs/templates/` 配下に配置することも検討中(v0.3 で正式追加)。

---

## 8. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では requirements 内の概要のみ。v0.2 で独立文書化、双方向ハンドオフを新設。 |

---

**本書は v0.2 ハンドオフプロトコルの正本である。実装時は本書の YAML スキーマを必須要件として参照すること。apex / WMAO 側のスキーマ反映は別タスクとして Phase D 検証時または v0.3 着手時に依頼する。**
