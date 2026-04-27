# digital-product-studio-ai 要件定義書 v0.1

**プロジェクト名**: digital-product-studio-ai
**バージョン**: 0.1
**作成日**: 2026-04-27
**所属組織**: AILEAP
**位置づけ**: AILEAP 3組織アーキテクチャの中流レイヤー(制作 + 開発 + 納品)

---

## 0. ドキュメント概要

本書は AILEAP の3組織アーキテクチャにおける中流レイヤー、すなわち「**ヒアリングから納品までの全工程をAIエージェントで遂行するデジタルプロダクト開発スタジオ**」の v0.1 要件を定義する。

参照モデルは Anthropic 公式コミュニティの Claude-Code-Game-Studios(48エージェント、37スキル、3層階層、path-scoped rules)であり、その組織モデルを Web/デジタルプロダクト開発文脈に適合させたものである。

本書の対象読者は Shin(本プロジェクトのオーナー兼アーキテクト)であり、レビュー後に v0.2 への gap 分析を実施することを前提とする。

---

## 1. ミッションとスコープ

### 1.1 ミッション

> **SME クライアントのデジタルプロダクト案件(コーポレートサイト〜SaaS開発まで)を、ヒアリングから保守運用まで AI エージェント中心で遂行する。**

### 1.2 扱う案件タイプ(In Scope)

| カテゴリ | サブタイプ | 主な技術領域 |
|---|---|---|
| **A. 制作系** | A1. コーポレートサイト | Next.js / Astro / WordPress |
| | A2. ランディングページ | Next.js / Astro / 静的HTML |
| | A3. メディア・オウンドメディア | WordPress / Headless CMS |
| | A4. リブランド改修 | 既存スタックの拡張 |
| **B. 開発系** | B1. SaaS MVP | Next.js + tRPC + Postgres |
| | B2. SaaS スケール | NestJS / マイクロサービス |
| | B3. 社内業務システム | Next.js + 認証 + 業務DB |
| | B4. AI機能搭載プロダクト | LLM API / RAG / Vector DB |
| **C. ハイブリッド** | C1. EC構築 | Shopify / Next.js Commerce |
| | C2. プラットフォーム + ブランドサイト | フルスタック動員 |
| | C3. リニューアル + 機能拡張 | 移行 + 新規開発 |

### 1.3 範囲外(Out of Scope)

以下は本組織の責任範囲外とし、AILEAP 内の他組織または外部に委ねる。

| 範囲外領域 | 委ねる先 | 理由 |
|---|---|---|
| 事業戦略・経営戦略・業務改革コンサル | apex-consulting-ai | 本組織はチャネル戦略までを扱う |
| 業界・市場のビジネスモデル分析 | apex-consulting-ai | 同上 |
| 公開後の継続SEO・GEO改善運用 | web-marketing-ai-org (WMAO) | 本組織は土台構築まで |
| コンテンツマーケティングの継続運用 | WMAO | 同上 |
| SNS運用・広告運用・メルマガ運用 | WMAO | 同上 |
| A/Bテスト・CRO の継続運用 | WMAO | 同上 |
| 写真撮影・動画撮影の実作業 | 外部パートナー | AI 単独で不可。本組織はディレクションまで |
| 個別の法的判断・契約書最終レビュー | 外部弁護士 | AI による法的助言は不可 |

---

## 2. AILEAP 3組織アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│ apex-consulting-ai【上流: 戦略・経営】(既存)                 │
│   事業戦略 / 業務改革 / 市場分析 / デジタル戦略全体           │
│   → 「Webプロダクトが必要」と判断したらハンドオフ             │
└──────────────────────────┬──────────────────────────────────┘
                           │ /handoff-from-strategy
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ digital-product-studio-ai【中流: 制作・開発】(本書)           │
│   案件タイプ判定 → Discovery → Design → Engineering →       │
│   QA → Launch → Handoff                                     │
└──────────────────────────┬──────────────────────────────────┘
                           │ /handoff-to-marketing
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ web-marketing-ai-org (WMAO)【下流: 運用・成長】(既存)         │
│   継続SEO / GEO / コンテンツマーケ / SNS / 広告 / 改善運用    │
└─────────────────────────────────────────────────────────────┘
```

### 2.1 ハンドオフプロトコル仕様

#### 2.1.1 Inbound: apex → digital-product-studio-ai

apex から受領するパッケージ:

```yaml
handoff_id: <UUID>
from: apex-consulting-ai
to: digital-product-studio-ai
client:
  name: <クライアント名>
  industry: <業界>
  size: <SME規模>
  decision_maker: <決裁者>
strategic_context:
  business_objective: <事業目的>
  target_audience: <ターゲット>
  competitive_position: <競合上の位置>
  digital_strategy: <デジタル戦略全体像>
project_brief:
  recommended_channels: [web, app, ...]
  kgi: <経営KPI>
  budget_range: <予算レンジ>
  timeline: <希望時期>
  constraints: [<既存システム制約等>]
attachments:
  - apex_strategy_report.pdf
  - market_analysis.pdf
```

受け側のアクション:
1. `studio-director` が受領
2. `delivery-director` がプロジェクトIDを採番
3. `projects/{client-name}_{project-id}/` を生成
4. 案件タイプ判定 → `/team-*` コマンドを起動

#### 2.1.2 Outbound: digital-product-studio-ai → WMAO

WMAO へ引き渡すパッケージ:

```yaml
handoff_id: <UUID>
from: digital-product-studio-ai
to: web-marketing-ai-org
project:
  client: <クライアント>
  url: <公開URL>
  launched_at: <公開日>
delivered_assets:
  - sitemap.xml
  - design_system.md
  - persona.md
  - measurement_plan.md  # GA4 / GTM 設置情報
  - seo_strategy.md      # 設計時のキーワード・構造方針
  - geo_strategy.md      # LLM 引用最適化の前提
  - content_strategy.md
  - cms_credentials.md   # WMAO 用権限
post_launch_targets:
  kgi: <KGI>
  kpi:
    - metric: 月間問い合わせ件数
      target: <数値>
    - metric: オーガニック流入
      target: <数値>
maintenance:
  sla: <保守SLA>
  contact: <技術問い合わせ先>
```

#### 2.1.3 内部フェーズ移行

```
Engagement → Discovery → Strategy → Design →
Implementation → QA → Launch → Handoff
```

各フェーズ間は `delivery-director` が gate-check を実施し、次フェーズへの移行可否を判定する。

---

## 3. 組織構造(5プラクティス制)

### 3.1 階層全体図

```
Tier 0:  Studio Director(統合トップ・Opus)
         └─ 1名

Tier 1:  Practice Directors(Opus・5名)
         ├─ Strategy Practice
         ├─ Creative Practice
         ├─ Engineering Practice
         ├─ Product Practice
         └─ Delivery Practice

Tier 2:  Discipline Leads(Sonnet・8名)
         各 Practice 配下

Tier 3:  Specialists(Sonnet/Haiku・18名)

横断:    Tech Stack Specialists(Sonnet・5名)
         案件起動時に動的に呼び出し
```

**合計: 37エージェント**(Game Studio 48、apex 12、WMAO 10 と比較し中規模)

### 3.2 Practice の責任分界

| Practice | 責任領域 | リーダー |
|---|---|---|
| **Strategy Practice** | チャネル戦略・UX戦略・コンテンツ戦略・SEO/GEO戦略 | strategy-director |
| **Creative Practice** | デザイン・ブランド表現・モーション・コピー | creative-director |
| **Engineering Practice** | 実装・インフラ・セキュリティ・パフォーマンス | technology-director |
| **Product Practice** | プロダクト戦略・ユーザーリサーチ(開発系案件のみ) | product-director |
| **Delivery Practice** | 顧客対応・契約・スケジュール・公開・納品 | delivery-director |

---

## 4. エージェント・ロスター(全37名)

### 4.1 Tier 0 — Studio Director(1名・Opus)

| Agent | Model | 役割 |
|---|---|---|
| studio-director | Opus | 全Practiceの統合判断、apex/WMAO とのハンドオフ管轄、最終意思決定 |

### 4.2 Tier 1 — Practice Directors(5名・Opus)

| Agent | Model | 主な責任 |
|---|---|---|
| strategy-director | Opus | チャネル戦略・UX戦略・コンテンツ戦略の最終判断 |
| creative-director | Opus | ビジュアル・ブランド表現・トーン&マナーの守護 |
| technology-director | Opus | アーキテクチャ・技術選定・セキュリティ方針 |
| product-director | Opus | プロダクト戦略(開発系案件)・PMF判断 |
| delivery-director | Opus | 顧客関係・予算・スケジュール・契約・公開遂行 |

### 4.3 Tier 2 — Discipline Leads(8名・Sonnet)

| Agent | 所属 Practice | 主な責任 |
|---|---|---|
| ux-strategy-lead | Strategy | 情報設計・サイトマップ・ユーザージャーニー |
| content-strategy-lead | Strategy | コンテンツ戦略・コピー方針・SEO/GEO 構造設計 |
| art-direction-lead | Creative | ビジュアル統括・デザインシステム |
| frontend-lead | Engineering | フロントエンド実装統括 |
| backend-lead | Engineering | バックエンド・API・DB 統括 |
| platform-lead | Engineering | DevOps・インフラ・CI/CD・監視 |
| qa-lead | Engineering | テスト戦略・品質保証 |
| client-success-lead | Delivery | ヒアリング・納品・保守窓口 |

### 4.4 Tier 3 — Specialists(18名・Sonnet/Haiku)

#### Discovery & Strategy(4名)

| Agent | 役割 |
|---|---|
| competitor-analyst | Web視点での競合5社調査(構造・UX・SEO・コピー) |
| persona-designer | ペルソナ・カスタマージャーニーマップ作成 |
| measurement-architect | KGI/KPI 設計、GA4/GTM 計測設計 |
| seo-geo-strategist | SEO戦略 + GEO(LLM引用最適化)戦略設計 |

#### Design & Content(4名)

| Agent | 役割 |
|---|---|
| ui-designer | UI 詳細設計・コンポーネントデザイン |
| motion-designer | モーション・インタラクション設計 |
| copywriter | 全ページコピー・CTA・SEO/GEO 観点コピー |
| asset-rights-validator | 素材権利検証(著作権・肖像権・フォント) |

#### Engineering(7名)

| Agent | 役割 |
|---|---|
| frontend-engineer | コンポーネント実装・SSR/SSG・状態管理 |
| backend-engineer | API・ビジネスロジック・データモデル |
| cms-engineer | WordPress / Headless CMS 構築 |
| devops-engineer | デプロイ・環境構築・監視 |
| security-engineer | 認証認可・脆弱性対応・OWASP |
| accessibility-specialist | WCAG 2.2 AA 準拠 |
| performance-engineer | Core Web Vitals・Lighthouse 最適化 |

#### Delivery(3名)

| Agent | 役割 |
|---|---|
| commercial-manager | 見積・契約・SOW・変更注文管理 |
| launch-conductor | 公開当日の統合管理(DNS/SSL/モニタリング) |
| migration-engineer | リニューアル時のデータ移行・リダイレクト設計 |
| cms-trainer | CMS操作マニュアル・動画教育コンテンツ生成 |

(Delivery 配下は実際は4名。表記訂正: Delivery 4名で合計18名)

### 4.5 Tech Stack Specialists(5名・Sonnet・横断)

案件起動時に動的に呼び出される横断的スペシャリスト。Game Studio の Engine specialist 概念をそのまま転用。

| Agent | 対応領域 |
|---|---|
| nextjs-specialist | Next.js App Router / RSC / Server Actions |
| astro-specialist | Astro Islands / 静的サイト / コンテンツコレクション |
| wordpress-specialist | WordPress テーマ開発 / ACF / セキュリティ |
| headless-cms-specialist | microCMS / Sanity / Contentful / Strapi |
| saas-stack-specialist | tRPC / Drizzle / Postgres / Vercel / Auth |

将来追加候補: ai-integration-specialist, mobile-pwa-specialist, framer-webflow-specialist, aws-specialist 等。

---

## 5. Slash Commands(30個)

### 5.1 Engagement(顧客接点・6個)

| Command | 動作 |
|---|---|
| /client-onboarding | 初回ヒアリング構造化フロー(stakeholder-mapper を含む) |
| /requirements-gathering | 要件定義書ドラフト生成 |
| /competitor-analysis | 競合5社の Web 視点比較レポート |
| /tech-stack-recommendation | 予算・要件・運用体制から最適スタック提案(2-3案) |
| /estimate | 工数・費用見積生成(リスクバッファ含む) |
| /proposal-deck | 提案書 PPTX/PDF 生成 |

### 5.2 Strategy & Design(4個)

| Command | 動作 |
|---|---|
| /sitemap-design | 情報設計・サイトマップ生成 |
| /design-system | デザインシステム文書生成 |
| /content-strategy | コンテンツ戦略文書生成 |
| /measurement-plan | KGI/KPI・GA4/GTM 計測設計書生成 |

### 5.3 Implementation(3個)

| Command | 動作 |
|---|---|
| /component-design | コンポーネント設計レビュー |
| /code-review | コードレビュー(path-scoped rules 適用) |
| /design-review | デザインレビュー |

### 5.4 Audit(4個)

| Command | 動作 |
|---|---|
| /seo-audit | 従来型SEO監査(メタ・構造化データ・内部リンク等) |
| /geo-audit | LLM/AI検索向け最適化監査(llms.txt・構造化データ・引用されやすさ) |
| /accessibility-audit | WCAG 2.2 AA 準拠チェック |
| /performance-audit | Lighthouse / Core Web Vitals 計測・改善案 |

### 5.5 Production Management(3個)

| Command | 動作 |
|---|---|
| /sprint-plan | スプリント計画 |
| /change-order | 変更注文書生成(追加見積含む) |
| /scope-check | スコープ逸脱検出 |

### 5.6 Launch(3個)

| Command | 動作 |
|---|---|
| /launch-checklist | 公開直前チェックリスト実行(DNS/SSL/モニタ等) |
| /redirect-map | リニューアル時のURL マッピング・301設定 |
| /handoff-package | 納品パッケージ生成(マニュアル・権限・SLA等) |

### 5.7 Post-launch & Handoff(2個)

| Command | 動作 |
|---|---|
| /cms-training | CMS操作マニュアル・動画教育コンテンツ生成 |
| /handoff-to-marketing | WMAO へのハンドオフパッケージ生成 |

### 5.8 Team Orchestration(5個)

複数エージェントを協調起動するチーム編成コマンド:

| Command | 動員エージェント |
|---|---|
| /team-corporate-site | CD + UX strategy + frontend + cms + seo-geo + copywriter |
| /team-landing-page | CD + copywriter + frontend + measurement |
| /team-mediasite | CD + content strategy + cms + seo-geo + copywriter |
| /team-saas-mvp | product director + product design + fullstack + platform + qa |
| /team-ecommerce | CD + product + frontend + backend + payment + cms + seo |

### 5.9 オーケストレーション補助(任意・将来追加)

| Command | 動作 |
|---|---|
| /gate-check | フェーズ移行可否判定(delivery-director 主導) |
| /retrospective | 案件振り返り |
| /reverse-document | 既存サイト分析 → 設計文書逆生成 |

---

## 6. Hooks(7個)

| Hook | 起動タイミング | 動作 |
|---|---|---|
| session-start.sh | セッション開始 | 直近の案件状態・git活動を読込 |
| validate-meta-tags.sh | git commit | title/description/og の有無検証 |
| validate-images.sh | `public/images/**` への書込 | alt属性・最適化(WebP変換)検証 |
| validate-a11y.sh | git commit | コントラスト・キーボード操作・基本a11y検証 |
| lighthouse-budget.sh | デプロイ前 | Lighthouse スコア閾値割れで停止(Performance≥90等) |
| legal-pages-check.sh | デプロイ前 | プライバシーポリシー・利用規約・特商法・Cookie同意の存在検証 |
| session-stop.sh | セッション終了 | 進捗・成果物を案件ログに記録 |

---

## 7. Path-scoped Rules(10個)

`Game Studio` の path-scoped rule 思想を Web プロダクト用に再定義。

| Path | 適用ルール |
|---|---|
| `src/components/**` | Atomic Design 準拠、Props型定義必須、Storybook記述推奨 |
| `app/**` または `pages/**` | SEO メタ・構造化データ必須、OGP画像指定必須 |
| `content/**` | コピーガイドライン準拠、誤字検出 |
| `design/**` | デザインシステム準拠、トークン使用必須 |
| `public/images/**` | WebP/AVIF 推奨、サイズ最適化、alt属性元データ必須 |
| `src/api/**` | 入力バリデーション必須、エラーハンドリング標準化、認証必須 |
| `db/migrations/**` | 破壊的変更禁止、ロールバック手順記載必須 |
| `tests/**` | テスト命名規則、AAA パターン、カバレッジ閾値 |
| `docs/legal/**` | プライバシーポリシー・利用規約等のひな型遵守 |
| `projects/{id}/**` | 案件外への参照禁止(マルチテナント隔離) |

---

## 8. Templates(21個)

`docs/templates/` 配下に格納。Game Studio の GDD テンプレートに相当。

### 8.1 営業・契約フェーズ(5個)

- proposal-deck.md(提案書)
- estimate.md(見積書)
- sow.md(SOW)
- change-order.md(変更注文書)
- requirements-v0.md(要件定義書ひな型)

### 8.2 Discovery・戦略フェーズ(7個)

- competitor-analysis.md
- persona.md
- user-journey-map.md
- sitemap.md
- measurement-plan.md(KGI/KPI/計測設計)
- content-strategy.md
- seo-geo-strategy.md

### 8.3 Design フェーズ(1個)

- design-system.md

### 8.4 Launch フェーズ(3個)

- launch-checklist.md
- redirect-map.md(リニューアル時)
- handoff-package.md(納品パッケージ)

### 8.5 納品後(2個)

- cms-manual.md(CMS操作マニュアル)
- handoff-to-wmao.md(WMAO へのハンドオフ)

### 8.6 法務(3個)

- legal-privacy-policy.md(プライバシーポリシーひな型)
- legal-terms.md(利用規約ひな型)
- legal-tokushoho.md(特商法ひな型)

---

## 9. プロジェクトディレクトリ構造

### 9.1 リポジトリ全体構造

```
digital-product-studio-ai/
├── README.md                       プロジェクト概要・3組織連携図
├── CLAUDE.md                       マスター設定
├── UPGRADING.md                    バージョン間移行手順
├── .claude/
│   ├── settings.json               Hooks / 権限 / 安全ルール
│   ├── agents/                     37エージェント定義
│   │   ├── tier0-studio-director.md
│   │   ├── tier1-strategy-director.md
│   │   ├── ...
│   │   └── stack-saas-stack-specialist.md
│   ├── skills/                     30 slash commands
│   │   ├── client-onboarding/
│   │   │   └── SKILL.md
│   │   ├── ...
│   ├── hooks/                      7 hooks(bash)
│   └── rules/                      10 path-scoped rules
├── docs/
│   ├── requirements-v0.1.md        本書
│   ├── architecture.md             5プラクティス制の設計思想
│   ├── handoff-protocols.md        apex / WMAO とのハンドオフ仕様
│   ├── agent-roster.md             全エージェント一覧
│   ├── agent-coordination-map.md   委譲・エスカレーション経路
│   ├── quick-start.md              利用ガイド
│   ├── setup-requirements.md       前提環境
│   └── templates/                  21テンプレート
└── projects/                       案件ごとのワークスペース
    └── {client-name}_{project-id}/
        ├── 00-engagement/
        ├── 01-discovery/
        ├── 02-strategy/
        ├── 03-design/
        ├── 04-implementation/
        ├── 05-qa/
        ├── 06-launch/
        ├── 07-handoff/
        ├── session-state/
        └── PROJECT.md              案件メタデータ
```

### 9.2 マルチテナント設計

Game Studio は1作品集中前提だが、本組織は5〜10案件並列前提。

- 各案件は `projects/{client-name}_{project-id}/` で完全隔離
- session-state は案件ごとに分離
- `path-scoped rule: projects/{id}/**` で案件外参照を禁止
- studio-director が現在アクティブな案件 ID を保持・切替

---

## 10. エージェント協調ルール(Game Studio 流用)

Game Studio の 4 原則をそのまま採用:

1. **Vertical delegation**(垂直委譲)
   - Directors → Leads → Specialists の方向のみ命令可
2. **Horizontal consultation**(水平相談)
   - 同層は相談可だが拘束力ある決定は不可
3. **Conflict resolution**(衝突解決)
   - 意見不一致は共通の親エージェントへエスカレーション
   - 例: frontend-engineer vs ui-designer → creative-director ↔ technology-director の合議、最終的に studio-director
4. **Domain boundaries**(担当範囲)
   - 担当外のファイルは触らない
   - 例: ui-designer は `src/components/**` の見た目は提案するが、ロジックは frontend-engineer に委譲

加えて Web 制作・開発特有の追加原則:

5. **Client-touching boundary**(顧客接触境界)
   - 顧客と直接対話するエージェントは Delivery Practice 配下のみ
   - 他 Practice のエージェントは社内向けアウトプットのみ生成
6. **Phase gate enforcement**(フェーズゲート)
   - delivery-director の `/gate-check` 通過なしに次フェーズへ進めない
7. **Change propagation**(変更伝播)
   - スコープ変更は必ず `commercial-manager` が `/change-order` で記録

---

## 11. 協調モデル: Collaborative, Not Autonomous

Game Studio と同じ思想を継承する。

1. **Ask** — 提案前に質問する
2. **Present options** — 2〜4案を提示(pros/cons 付き)
3. **You decide** — Shin が判断する
4. **Draft** — 最終化前にドラフトを見せる
5. **Approve** — 承認なしに書き込まない

特に顧客対応(`/client-onboarding`、`/proposal-deck` 等)は、**クライアント送付前に必ず Shin の承認を得る**ことを強制する。

---

## 12. 案件タイプ別ワークフロー(代表3例)

### 12.1 制作系: コーポレートサイト(`/team-corporate-site`)

```
[1] /client-onboarding      ヒアリング(client-success-lead)
[2] /competitor-analysis    競合調査(competitor-analyst)
[3] /requirements-gathering 要件定義(ux-strategy-lead)
[4] /tech-stack-recommendation スタック選定(technology-director)
[5] /estimate / /proposal-deck 見積・提案(commercial-manager)
[6] [契約締結後]
[7] /sitemap-design          情報設計(ux-strategy-lead)
[8] /design-system           デザイン(art-direction-lead + ui-designer)
[9] /content-strategy        コンテンツ(content-strategy-lead + copywriter)
[10] /measurement-plan       計測設計(measurement-architect)
[11] [実装フェーズ]          (frontend-lead + frontend-engineer + cms-engineer)
[12] /seo-audit /geo-audit /accessibility-audit /performance-audit
[13] /launch-checklist       公開準備(launch-conductor)
[14] /handoff-package        納品(client-success-lead)
[15] /cms-training           CMS教育(cms-trainer)
[16] /handoff-to-marketing   WMAO へ引継ぎ
```

### 12.2 開発系: SaaS MVP(`/team-saas-mvp`)

```
[1] /client-onboarding
[2] /requirements-gathering  + ペルソナ・UJM
[3] /tech-stack-recommendation
[4] /estimate / /proposal-deck
[5] [契約締結後]
[6] product-director 主導でプロダクトロードマップ策定
[7] /design-system + プロトタイプ(product-design)
[8] [スプリント1〜N]         /sprint-plan で進行
[9] [実装]                   (saas-stack-specialist + backend + frontend)
[10] /code-review が継続的に走る
[11] /security-audit /performance-audit
[12] /launch-checklist       MVP リリース
[13] /handoff-package        運用引継ぎ
```

### 12.3 ハイブリッド: EC構築(`/team-ecommerce`)

```
[1〜5] 上記と同様
[6] EC固有: 決済・在庫・配送設計
[7] /sitemap-design + 商品カテゴリ構造設計
[8] /design-system
[9] /content-strategy + 商品コピー戦略
[10] /measurement-plan(EC計測: 購入CV、ECフィルター)
[11] [実装]                  (Shopify or 自前: backend + frontend + cms)
[12] /seo-audit (商品ページSEO重要)
[13] /security-audit (決済関連必須)
[14] /launch-checklist + 決済テスト
[15] /handoff-package + 商品登録運用マニュアル
[16] /handoff-to-marketing(EC は WMAO 連携が特に重要)
```

---

## 13. v0.1 のスコープ(MVP判定)

### 13.1 v0.1 で実装するもの

- 全37エージェント(プロンプト本文付き)
- 30 slash commands(SKILL.md 付き)
- 7 hooks(動作する bash スクリプト)
- 10 path-scoped rules
- 21 templates(空ではなく実用テンプレート)
- 案件タイプ A1(コーポレートサイト)、B1(SaaS MVP)、C1(EC構築)の3つだけ team orchestration を完備
- AILEAP 3組織のハンドオフプロトコル文書化(実装は手動、自動化は v0.2 以降)
- マルチテナント projects/ ディレクトリ構造

### 13.2 v0.1 では実装しないもの(v0.2 以降)

- A2/A3/A4、B2/B3/B4、C2/C3 の team orchestration コマンド
- apex / WMAO との自動ハンドオフ(v0.1 は手動でファイルコピー)
- Slack 等への通知連携
- 案件並列管理ダッシュボード
- 受注後の請求・売上管理(別組織で扱うべき)
- 多言語対応(localization-specialist は v0.2 以降)
- ai-integration-specialist 等の追加スタック specialist

---

## 14. 品質ゲート(Quality Gates)

各フェーズ移行時に `/gate-check` で以下を検証:

| Gate | 検証項目 |
|---|---|
| Engagement → Discovery | 契約締結、SOW 合意、決裁者特定 |
| Discovery → Strategy | 要件定義書承認、ペルソナ確定、KGI/KPI 合意 |
| Strategy → Design | サイトマップ承認、計測設計承認、コンテンツ方針承認 |
| Design → Implementation | デザインシステム承認、全画面デザイン承認 |
| Implementation → QA | 全機能実装完了、ステージング環境動作確認 |
| QA → Launch | 全 audit パス、Lighthouse スコア閾値クリア、法務ページ存在 |
| Launch → Handoff | DNS/SSL 切替完了、計測動作確認、CMS教育完了 |

ゲート失敗時は `delivery-director` が前フェーズへの差戻しを実行。

---

## 15. 設計思想(Design Philosophy)

Game Studio の MDA / SDT / Flow / Bartle に対し、本組織は以下を採用:

1. **Jobs-to-be-Done(JTBD)** — クライアントが「雇いたい」価値の特定
2. **Double Diamond** — Discover → Define → Develop → Deliver の4段階
3. **Atomic Design** — コンポーネント階層化(Atom → Molecule → Organism → Template → Page)
4. **Progressive Enhancement** — 基本機能優先・段階的強化
5. **Dual Track Agile** — Discovery と Delivery の並行(開発系案件)
6. **Lean Startup** — Build-Measure-Learn ループ(MVP・SaaS案件)
7. **WCAG 2.2 AA** — アクセシビリティの最低基準
8. **Core Web Vitals** — パフォーマンスの最低基準

---

## 16. 成功指標(Success Metrics)

v0.1 の成功は以下で判定:

### 16.1 内部指標(本組織自体の品質)

| 指標 | 目標値 |
|---|---|
| エージェント定義の整合性 | 全37エージェントで domain boundary 明文化 |
| ハンドオフプロトコル整合性 | apex/WMAO とのスキーマ整合 100% |
| テンプレート実用性 | 21テンプレート全てが実案件で使える状態 |
| MBB readiness 相当(自己評価) | 80%以上(apex 88% を参考値とする) |

### 16.2 外部指標(運用1案件の検証)

v0.1 完成後、自社サイト改修(AILEAP の web)で1サイクル回し、以下を計測:

| 指標 | 目標値 |
|---|---|
| Engagement → Launch までの所要日数 | 30日以内 |
| Lighthouse Performance | 90以上 |
| WCAG 2.2 AA 準拠率 | 100% |
| 必要だった Shin の手戻り回数 | 5回以下 |

---

## 17. 既知のリスクと未解決事項

### 17.1 リスク

| リスク | 影響 | 緩和策 |
|---|---|---|
| 37エージェントの肥大化 | プロンプト管理コスト増 | v0.1 終了後にエージェント統廃合の振返り実施 |
| 顧客対話の AI 委任への抵抗感 | 受注機会損失 | 重要な顧客対話は Shin が必ず最終承認 |
| 法務責任の所在不明 | 訴訟リスク | 法務関連は弁護士の最終確認を必須化 |
| 複数案件並列時の context 混線 | 案件取り違え | projects/{id}/** 隔離 + studio-director の状態管理 |
| AI 単独で出ない品質(撮影・特殊実装) | 納期遅延 | 外部パートナー網を別途構築 |

### 17.2 未解決事項(v0.1 中に決定する)

- [ ] AILEAP の3組織を1リポジトリに統合するか別リポジトリで運用するか
- [ ] Slack 連携の有無(WMAO は Slack-approval-gated 設計のため整合確認)
- [ ] 案件管理 SaaS(Asana/Notion 等)との外部連携の有無
- [ ] エージェント間通信のフォーマット(YAML / JSON / 自由記述)の統一
- [ ] ハイクサイトでの納品物保管(Vercel / Cloudflare / 自前 S3)の標準

---

## 18. 次アクション

本書の Shin レビュー後、以下を順に進める:

1. **gap 分析セッション**(apex の 88% MBB readiness 到達プロセスを踏襲)
2. **v0.1 → v0.2 改訂**(gap 解消)
3. **README.md / CLAUDE.md / settings.json 作成**
4. **エージェント定義の執筆**(Tier 0 から順に37体)
5. **Slash commands の SKILL.md 執筆**(30個)
6. **Hooks スクリプト実装**(7個)
7. **Templates 執筆**(21個)
8. **自社サイト改修案件で1サイクル検証**

---

## 付録 A. Game Studio 参照モデルとの差分

| 項目 | Game Studio | digital-product-studio-ai | 差分理由 |
|---|---|---|---|
| エージェント数 | 48 | 37 | Web/Digital で必要な役割に絞り込み |
| 階層 | 3層 | 4層(Tier 0 追加) | 顧客対応のため統合トップを設置 |
| Practice | 暗黙(7部門) | 明示(5プラクティス) | 業界標準の組織呼称に合わせ |
| Engine specialist | 3(Godot/Unity/Unreal) | 5(Tech Stack) | スタックの選択肢が多様 |
| 顧客対応エージェント | なし | Delivery Practice 8体 | Web は受託前提 |
| 並列案件管理 | 単一作品前提 | マルチテナント | 制作会社の現実 |
| Hooks 種別 | コミット中心 | デプロイ・公開前検証中心 | Web の事故防止重点 |
| 法務対応 | なし | legal-pages-check + テンプレート | 日本市場必須 |

---

## 付録 B. 用語集

- **Engagement**: 1案件の総称
- **Discovery**: 課題・要件・ユーザーを掘る初期フェーズ
- **Practice**: 職能単位の部門
- **Discipline**: 個別職能(UX、Frontend 等)
- **SOW**: Statement of Work(作業範囲記述書)
- **GEO**: Generative Engine Optimization(LLM 引用最適化)
- **Core Web Vitals**: Google が定めるWeb性能指標(LCP/INP/CLS)
- **WCAG**: Web Content Accessibility Guidelines
- **JTBD**: Jobs to be Done
- **Dual Track**: Discovery と Delivery を並行する開発手法

---

**本書は v0.1 のドラフトであり、Shin のレビュー後に gap 分析を経て v0.2 へ改訂される。**
