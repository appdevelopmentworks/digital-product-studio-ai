# エージェント・ロスター

**バージョン**: 0.3
**作成日**: 2026-04-27(v0.2 初版)/ 2026-05-01(v0.3 更新)
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 5 / [architecture.md](architecture.md) Section 1-2 の詳細名簿
**対象**: v0.3 段階の **26 エージェント**(v0.2 21 体 + v0.3 で 5 体追加 — Phase G で B 系プロダクト開発体制を解放)

---

## 0. 本書の目的

本書は v0.2 段階で実装する全エージェントの一覧と、各エージェントの責任・所属 Practice・モデル割当・担当範囲を一括管理するロスター(名簿)である。

実装時には `.claude/agents/` 配下の各エージェント定義ファイル(.md)が本書と整合している必要がある。本書はその正本となる。

加えて、v0.3 / v0.4 で追加予定のエージェントも参考として列挙する(段階展開戦略の透明化のため)。

---

## 1. v0.3 全エージェント一覧表(26 体)

| # | Tier | Agent 名 | ファイル名 | Model | 所属 Practice | 主な動員案件 | v0.3 ステータス |
|---|---|---|---|---|---|---|---|
| 1 | 0 | studio-director | `tier0-studio-director.md` | Opus | (横断) | 全案件 | 既存 |
| 2 | 1 | strategy-director | `tier1-strategy-director.md` | Opus | Strategy | 全案件 | 既存 |
| 3 | 1 | creative-director | `tier1-creative-director.md` | Opus | Creative | 全案件 | 既存 |
| 4 | 1 | technology-director | `tier1-technology-director.md` | Opus | Engineering | 全案件 | 既存 |
| 5 | 1 | product-director | `tier1-product-director.md` | Opus | Product | **B 系・自社プロダクト案件**(v0.3 でフル稼働) | **拡張(v0.3)** |
| 6 | 1 | delivery-director | `tier1-delivery-director.md` | Opus | Delivery | 全案件 | 既存 |
| 7 | 2 | ux-strategy-lead | `tier2-ux-strategy-lead.md` | Sonnet | Strategy | A1 / A3 | 既存 |
| 8 | 2 | content-strategy-lead | `tier2-content-strategy-lead.md` | Sonnet | Strategy | A1 / A3 | 既存 |
| 9 | 2 | art-direction-lead | `tier2-art-direction-lead.md` | Sonnet | Creative | 全案件 | 既存 |
| 10 | 2 | frontend-lead | `tier2-frontend-lead.md` | Sonnet | Engineering | 全案件 | 既存 |
| 11 | 2 | backend-lead | `tier2-backend-lead.md` | Sonnet | Engineering | A 系で軽量・**B 系でフル稼働**(direct reports +3 体) | **拡張(v0.3)** |
| 12 | 2 | client-success-lead | `tier2-client-success-lead.md` | Sonnet | Delivery | 全案件 | 既存 |
| **13** | **2** | **product-manager** | `tier2-product-manager.md` | **Sonnet** | **Product** | **B 系・自社プロダクト案件** | **🆕 新規(v0.3)** |
| 14 | 3 | ui-designer | `tier3-ui-designer.md` | Sonnet | Creative | 全案件 | 既存 |
| 15 | 3 | copywriter | `tier3-copywriter.md` | Sonnet | Creative | 全案件 | 既存 |
| 16 | 3 | frontend-engineer | `tier3-frontend-engineer.md` | Sonnet | Engineering | 全案件 | 既存 |
| 17 | 3 | cms-engineer | `tier3-cms-engineer.md` | Sonnet | Engineering | A1(WordPress) / A3 | 既存 |
| 18 | 3 | seo-geo-strategist | `tier3-seo-geo-strategist.md` | Sonnet | Strategy | 全案件 | 既存 |
| 19 | 3 | commercial-manager | `tier3-commercial-manager.md` | Sonnet | Delivery | 全案件 | 既存 |
| **20** | **3** | **backend-engineer** | `tier3-backend-engineer.md` | **Sonnet** | **Engineering** | **B 系・自社プロダクト案件**(API / DB / 認証) | **🆕 新規(v0.3)** |
| **21** | **3** | **devops-engineer** | `tier3-devops-engineer.md` | **Sonnet** | **Engineering** | **B 系・自社プロダクト案件**(CI/CD / インフラ / 監視) | **🆕 新規(v0.3)** |
| **22** | **3** | **qa-engineer** | `tier3-qa-engineer.md` | **Sonnet** | **Engineering** | **B 系主導・A 系で QA ゲート補助** | **🆕 新規(v0.3)** |
| 23 | Stack | nextjs-specialist | `stack-nextjs-specialist.md` | Sonnet | (横断) | A1 / A2 / B 系(Next.js 採用時) | 既存 |
| 24 | Stack | wordpress-specialist | `stack-wordpress-specialist.md` | Sonnet | (横断) | A1 / A3(WordPress 採用時) | 既存 |
| 25 | Stack | localization-specialist | `stack-localization-specialist.md` | Sonnet | (横断・Q5 前倒し) | 多言語要件案件 | 既存 |

**合計: 26 体**(v0.2 21 体 + v0.3 で 5 体追加 = 拡張済 1 体含む実装済み 26 体)

### 1.1 v0.3 で追加された 5 体

| # | 役割 | Tier | 種類 |
|---|---|---|---|
| 5 | product-director | 1 | 既存(本格起動仕様へ拡張) |
| 13 | product-manager | 2 | 🆕 新規 |
| 20 | backend-engineer | 3 | 🆕 新規 |
| 21 | devops-engineer | 3 | 🆕 新規 |
| 22 | qa-engineer | 3 | 🆕 新規 |

backend-lead(#11)も direct reports が +3 体になり、責務範囲が拡張(B 系で 3 名の direct report を統括)。

---

## 2. Tier 0 — Studio Director(1 体)

### 2-1. studio-director

- **ファイル**: `.claude/agents/tier0-studio-director.md`
- **Model**: Opus
- **所属 Practice**: 横断(全 5 Practice の上位)
- **主な責任**:
  - 全 Practice の統合判断
  - apex / WMAO とのハンドオフ管轄(`/handoff-from-strategy` 受領、`/escalate-to-strategy` / `/handoff-back-to-production` 起動)
  - Practice 間衝突の最終裁定者
  - 並列案件の優先度判定・案件切替時の context flush
  - 案件 ID 採番監督(実行は delivery-director が担当)
- **v0.2 段階での動員**: すべての案件で起動時・フェーズ移行時・衝突発生時に介在
- **担当パス**:
  - 読込: 全パス
  - 書込: `projects/{id}/PROJECT.md`、`projects/{id}/session-state/`
- **主な対話相手**: 全 Tier 1 Director、Shin
- **モード**: 制作モード / 開発モード / ハイブリッドモード を案件タイプで切替

---

## 3. Tier 1 — Practice Directors(5 体)

### 3-1. strategy-director

- **ファイル**: `.claude/agents/tier1-strategy-director.md`
- **Model**: Opus
- **所属 Practice**: Strategy
- **主な責任**:
  - チャネル戦略・UX 戦略・コンテンツ戦略・SEO/GEO 戦略の最終判断
  - 配下 Lead(ux-strategy-lead, content-strategy-lead)・Specialist(seo-geo-strategist)の統括
  - apex から渡された `strategic_context` を本組織側の戦略に翻訳
  - 案件タイプ判定(A1 vs A2 vs A3 など)
- **v0.2 段階での動員**: すべての案件で Strategy フェーズに介在
- **担当パス**:
  - 読込: `projects/{id}/00-engagement/`、`projects/{id}/01-discovery/`、`projects/{id}/02-strategy/`
  - 書込: `projects/{id}/02-strategy/strategy-decisions.md`
- **主な対話相手**: studio-director、ux-strategy-lead、content-strategy-lead、seo-geo-strategist、creative-director(横相談)

### 3-2. creative-director

- **ファイル**: `.claude/agents/tier1-creative-director.md`
- **Model**: Opus
- **所属 Practice**: Creative
- **主な責任**:
  - ビジュアル・ブランド表現・トーン&マナーの守護
  - デザインシステム承認
  - 配下 Lead(art-direction-lead)・Specialist(ui-designer, copywriter)の統括
  - 顧客のブランドガイドラインと AILEAP の差別化軸の整合
- **v0.2 段階での動員**: 全案件の Design フェーズで介在
- **担当パス**:
  - 読込: `projects/{id}/03-design/`、`design/`
  - 書込: `projects/{id}/03-design/design-decisions.md`
- **主な対話相手**: studio-director、art-direction-lead、ui-designer、copywriter、technology-director(横相談・実装可否確認)

### 3-3. technology-director

- **ファイル**: `.claude/agents/tier1-technology-director.md`
- **Model**: Opus
- **所属 Practice**: Engineering
- **主な責任**:
  - アーキテクチャ・技術選定・セキュリティ方針の最終判断
  - スタック推奨(Next.js / Astro / WordPress / 他)
  - 配下 Lead(frontend-lead, backend-lead)・Specialist の統括
  - Tech Stack Specialist(nextjs / wordpress / localization)の動的呼出判断
- **v0.2 段階での動員**: 全案件の Engagement(技術スタック推奨)・Implementation フェーズで介在
- **担当パス**:
  - 読込: `projects/{id}/`(全フェーズ)
  - 書込: `projects/{id}/00-engagement/tech-stack-recommendation.md`、`projects/{id}/04-implementation/architecture-notes.md`
- **主な対話相手**: studio-director、frontend-lead、backend-lead(v0.3 以降)、creative-director(横相談)、Tech Stack Specialists

### 3-4. product-director

- **ファイル**: `.claude/agents/tier1-product-director.md`
- **Model**: Opus
- **所属 Practice**: Product
- **主な責任**:
  - プロダクト戦略(開発系案件・自社プロダクト)の最終判断
  - PMF 判断
  - 自社プロダクト(MeetingAI 等)の中長期戦略
- **v0.2 段階での動員**: A 系案件(制作系)では基本待機。自社プロダクト案件で本格動員。
- **担当パス**:
  - 読込: `projects/{id}/`(自社プロダクト案件のみフルアクセス)
  - 書込: `projects/{id}/02-strategy/product-strategy.md`(自社プロダクト案件のみ)
- **主な対話相手**: studio-director、strategy-director、Shin
- **v0.2 制約**: A1 / A2 / A3 では待機状態、必要時に strategy-director と連携してアドバイスのみ提供

### 3-5. delivery-director

- **ファイル**: `.claude/agents/tier1-delivery-director.md`
- **Model**: Opus
- **所属 Practice**: Delivery
- **主な責任**:
  - 顧客関係・予算・スケジュール・契約・公開遂行
  - 全フェーズの `/gate-check` 実行
  - 案件 ID 採番(studio-director の監督下)
  - 配下 Lead(client-success-lead)・Specialist(commercial-manager)の統括
  - 承認ゲート管理(`approvals.yaml` の正確性確保)
  - フェーズ移行可否判定
- **v0.2 段階での動員**: 全案件の全フェーズで継続的に介在
- **担当パス**:
  - 読込: 全パス
  - 書込: `projects/{id}/00-engagement/`、`projects/{id}/PROJECT.md`、`projects/{id}/06-launch/`、`projects/{id}/08-handoff/`
- **主な対話相手**: studio-director、client-success-lead、commercial-manager、全 Tier 1 Director(gate-check 時)

---

## 4. Tier 2 — Discipline Leads(6 体)

### 4-1. ux-strategy-lead

- **ファイル**: `.claude/agents/tier2-ux-strategy-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Strategy
- **主な責任**:
  - 情報設計・サイトマップ
  - ユーザージャーニーマップ
  - ペルソナ作成(v0.2 では研究系 specialist 不在のため Lead が直接作成)
  - 制約条件発見プロセス(H-5 対応・`/client-onboarding` の制約発見ステップ実装)
- **v0.2 段階での動員**: A1 / A3 の Strategy フェーズで主導役
- **担当パス**:
  - 読込: `projects/{id}/00-engagement/`、`projects/{id}/01-discovery/`
  - 書込: `projects/{id}/01-discovery/persona.md`、`projects/{id}/01-discovery/user-journey-map.md`、`projects/{id}/02-strategy/sitemap.md`
- **主な対話相手**: strategy-director(上位)、content-strategy-lead(横)、ui-designer(下流連携)

### 4-2. content-strategy-lead

- **ファイル**: `.claude/agents/tier2-content-strategy-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Strategy
- **主な責任**:
  - コンテンツ戦略
  - コピー方針
  - SEO/GEO の構造設計サポート
  - 競合分析(Web 視点)
  - 初期コンテンツ 5-10 本の制作監督(B-C2 対応・copywriter と協業)
- **v0.2 段階での動員**: A1 / A3 の Strategy → Content フェーズで主導役、A2 では補助
- **担当パス**:
  - 読込: `projects/{id}/01-discovery/`、`content/`、`projects/{id}/02-strategy/`
  - 書込: `projects/{id}/01-discovery/competitor-analysis.md`、`projects/{id}/02-strategy/content-strategy.md`
- **主な対話相手**: strategy-director(上位)、copywriter(下位)、seo-geo-strategist(横)、ux-strategy-lead(横)

### 4-3. art-direction-lead

- **ファイル**: `.claude/agents/tier2-art-direction-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Creative
- **主な責任**:
  - ビジュアル統括
  - デザインシステム作成主導
  - a11y 設計組込(H-4 対応・design-system テンプレに a11y 章を必ず含める)
  - フォント・カラー・タイポグラフィの選定
- **v0.2 段階での動員**: 全案件の Design フェーズで主導役
- **担当パス**:
  - 読込: `design/`、`projects/{id}/03-design/`
  - 書込: `projects/{id}/03-design/design-system.md`
- **主な対話相手**: creative-director(上位)、ui-designer(下位)、frontend-lead(横・実装可否)

### 4-4. frontend-lead

- **ファイル**: `.claude/agents/tier2-frontend-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Engineering
- **主な責任**:
  - フロントエンド実装統括
  - コンポーネント分割粒度の決定
  - 状態管理方針
  - パフォーマンス予算管理
- **v0.2 段階での動員**: 全案件の Implementation フェーズで主導役
- **担当パス**:
  - 読込: `src/`、`app/`、`pages/`、`design/`
  - 書込: `src/`、`app/`、`pages/`(コードレビュー結果反映)
- **主な対話相手**: technology-director(上位)、frontend-engineer(下位)、art-direction-lead(横)、cms-engineer(横)、Tech Stack Specialists

### 4-5. backend-lead

- **ファイル**: `.claude/agents/tier2-backend-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Engineering
- **主な責任**:
  - バックエンド・API・DB 統括
  - データモデル設計
  - 認証認可方針
- **v0.2 段階での動員**: A 系案件では基本待機。お問合せフォーム等の最小限のサーバー処理がある場合のみ介在。**v0.3 以降の B 系案件で本格動員**
- **担当パス**:
  - 読込: `src/api/`、`db/`(v0.3 以降)
  - 書込: `src/api/`、`db/`(v0.3 以降)
- **主な対話相手**: technology-director(上位)、frontend-lead(横)、(v0.3 以降)backend-engineer

### 4-6. client-success-lead

- **ファイル**: `.claude/agents/tier2-client-success-lead.md`
- **Model**: Sonnet
- **所属 Practice**: Delivery
- **主な責任**:
  - クライアントヒアリング(`/client-onboarding` 主導)
  - 納品窓口・保守窓口
  - **AI 判断の人間翻訳**(B-M3 対応・クライアントが AI 出力に質問してきた時の応答役)
  - 議事録生成(`/meeting-minutes` 起動)
  - 意思決定ログ記録(`/decision-log` 起動)
  - アセット受領管理(`/asset-checklist` / `/asset-status` 起動・C-4 対応)
  - 承認管理(`/approval-request` / `/approval-record` / `/approval-status` 起動・C-1 対応)
- **v0.2 段階での動員**: 全案件の Engagement → Discovery、Launch、Handoff フェーズで主導役
- **担当パス**:
  - 読込: 全パス(顧客向け説明のため)
  - 書込: `projects/{id}/00-engagement/`(議事録・承認・アセット)、`projects/{id}/08-handoff/`
- **主な対話相手**: delivery-director(上位)、commercial-manager(横)、Shin、(対外)クライアント

---

## 5. Tier 3 — Specialists(6 体)

### 5-1. ui-designer

- **ファイル**: `.claude/agents/tier3-ui-designer.md`
- **Model**: Sonnet
- **所属 Practice**: Creative
- **主な責任**:
  - UI 詳細設計
  - コンポーネントデザイン
  - ヒーローセクション・主要画面のビジュアル設計
  - レスポンシブ対応設計
- **v0.2 段階での動員**: 全案件の Design フェーズ
- **担当パス**:
  - 読込: `design/`、`projects/{id}/03-design/`
  - 書込: `design/components/`、`projects/{id}/03-design/screens/`
  - 提案のみ: `src/components/`(実装は frontend-engineer に委譲)
- **主な対話相手**: art-direction-lead(上位)、frontend-engineer(横・実装委譲)、copywriter(横・コピーレイアウト)

### 5-2. copywriter

- **ファイル**: `.claude/agents/tier3-copywriter.md`
- **Model**: Sonnet
- **所属 Practice**: Creative
- **主な責任**:
  - 全ページコピー
  - CTA コピー
  - SEO/GEO 観点コピー(content-strategy-lead と連携)
  - **初期コンテンツ 5-10 本の制作**(B-C2 対応)
  - 多言語コピー(localization-specialist と連携)
- **v0.2 段階での動員**: 全案件の Content フェーズ
- **担当パス**:
  - 読込: `projects/{id}/02-strategy/`、`content/`
  - 書込: `content/`、`projects/{id}/03-design/copy/`
  - 提案のみ: 法務テンプレ(弁護士確認必須)
- **主な対話相手**: content-strategy-lead(上位)、seo-geo-strategist(横)、ui-designer(横)、localization-specialist(多言語時)

### 5-3. frontend-engineer

- **ファイル**: `.claude/agents/tier3-frontend-engineer.md`
- **Model**: Sonnet
- **所属 Practice**: Engineering
- **主な責任**:
  - コンポーネント実装
  - SSR/SSG 実装
  - 状態管理実装
  - レスポンシブ実装
  - メタタグ・OGP・構造化データの実装
- **v0.2 段階での動員**: 全案件の Implementation フェーズ
- **担当パス**:
  - 読込: 全コードパス
  - 書込: `src/`、`app/`、`pages/`、`public/`、`tests/`(v0.2 では限定的)
- **主な対話相手**: frontend-lead(上位)、ui-designer(横・デザイン受領)、cms-engineer(横・CMS 連携)、Tech Stack Specialists
- **モード**:
  - 制作モード(A 系): デザイン再現精度・LP 最適化を優先
  - 開発モード(B 系・v0.3 以降): 状態管理・性能・テスト網羅を優先

### 5-4. cms-engineer

- **ファイル**: `.claude/agents/tier3-cms-engineer.md`
- **Model**: Sonnet
- **所属 Practice**: Engineering
- **主な責任**:
  - WordPress テーマ実装
  - Headless CMS 構築(microCMS / Sanity / Contentful 等)
  - カスタム投稿タイプ・ACF 設計
  - CMS の操作教育用マニュアル素材作成(納品時の cms-manual テンプレ素材を提供)
- **v0.2 段階での動員**: A1(WordPress 採用時) / A3 の Implementation フェーズ
- **担当パス**:
  - 読込: 全コードパス
  - 書込: `wp-content/`(WordPress)、`cms/`(Headless 設定)
- **主な対話相手**: frontend-lead(上位)、frontend-engineer(横)、wordpress-specialist(動的呼出)

### 5-5. seo-geo-strategist

- **ファイル**: `.claude/agents/tier3-seo-geo-strategist.md`
- **Model**: Sonnet
- **所属 Practice**: Strategy
- **主な責任**:
  - SEO 戦略(キーワード・サイト構造・内部リンク・構造化データ)
  - GEO 戦略(llms.txt・LLM 引用最適化)
  - 公開後 30 日の初動検証(B-C1 対応・H-2 暫定対応)
  - `/seo-audit` / `/geo-audit` 主導
  - [geo-implementation-spec.md](geo-implementation-spec.md) の実装監督
- **v0.2 段階での動員**: 全案件の Strategy → Audit → Post-launch
- **担当パス**:
  - 読込: 全パス
  - 書込: `projects/{id}/02-strategy/seo-geo-strategy.md`、`projects/{id}/05-qa/seo-audit.md`、`projects/{id}/05-qa/geo-audit.md`、`projects/{id}/07-post-launch/30day-report.md`
- **主な対話相手**: strategy-director(上位)、content-strategy-lead(横)、copywriter(横)、frontend-engineer(横・実装連携)

### 5-6. commercial-manager

- **ファイル**: `.claude/agents/tier3-commercial-manager.md`
- **Model**: Sonnet
- **所属 Practice**: Delivery
- **主な責任**:
  - 見積生成(`/estimate` 主導・**3 パターン提案必須**: T&M / Fixed / Retainer)
  - SOW 作成
  - 変更注文書作成(`/change-order` 主導)
  - スコープ逸脱検出(`/scope-check` 主導)
  - リテイナー設計(`/retainer-design` 主導・C-3 対応)
  - 自社プロダクト案件の内部見積生成(請求書発行はしない)
- **v0.2 段階での動員**: 全案件の Engagement・契約締結後・変更発生時
- **担当パス**:
  - 読込: `projects/{id}/00-engagement/`、`projects/{id}/04-implementation/`(進捗確認)
  - 書込: `projects/{id}/00-engagement/estimate.md`、`projects/{id}/00-engagement/sow.md`、`projects/{id}/00-engagement/change-orders/`
- **主な対話相手**: delivery-director(上位)、client-success-lead(横)、technology-director(横・工数試算)

---

## 6. Tech Stack Specialists(3 体・横断)

### 6-1. nextjs-specialist

- **ファイル**: `.claude/agents/stack-nextjs-specialist.md`
- **Model**: Sonnet
- **所属**: Engineering Practice の横断スペシャリスト
- **主な責任**:
  - Next.js App Router / RSC / Server Actions の専門助言
  - パフォーマンス最適化(Image / Font / streaming)
  - SEO 関連実装(metadata API / sitemap.xml / robots.txt)
  - Vercel 等のホスティング設定
- **v0.2 段階での動員**: A1 / A2 で Next.js を採用した場合のみ動的呼出
- **担当パス**:
  - 読込: `next.config.js`、`app/`、`src/`、`public/`、`vercel.json`
  - 書込: 同上
- **主な対話相手**: frontend-lead(上位)、frontend-engineer(横)

### 6-2. wordpress-specialist

- **ファイル**: `.claude/agents/stack-wordpress-specialist.md`
- **Model**: Sonnet
- **所属**: Engineering Practice の横断スペシャリスト
- **主な責任**:
  - WordPress テーマ開発
  - ACF(Advanced Custom Fields)設計
  - WordPress セキュリティ(プラグイン選定・脆弱性対応)
  - パフォーマンス最適化(キャッシュ・画像・DB)
- **v0.2 段階での動員**: A1(WordPress 採用時) / A3 で動的呼出
- **担当パス**:
  - 読込: `wp-content/`、`wp-config.php`(秘匿・読込のみ)
  - 書込: `wp-content/themes/`、`wp-content/mu-plugins/`(セキュリティ用)
- **主な対話相手**: frontend-lead(上位)、cms-engineer(横)

### 6-3. localization-specialist(Q5 前倒し)

- **ファイル**: `.claude/agents/stack-localization-specialist.md`
- **Model**: Sonnet
- **所属**: 横断スペシャリスト(Q5 前倒し・20 枠外)
- **主な責任**:
  - 多言語対応戦略(`/i18n-strategy` 主導)
  - 対応技術: next-intl / Astro i18n / WordPress Polylang
  - 4 言語(日英中韓)の URL 構造設計
  - 翻訳ワークフロー設計(機械翻訳 → 人手レビュー)
  - hreflang 等の SEO 整合
- **v0.2 段階での動員**: 多言語要件のある案件のみ動的呼出
- **担当パス**:
  - 読込: `i18n/`、`content/`、`projects/{id}/02-strategy/`
  - 書込: `i18n/`、`projects/{id}/02-strategy/i18n-strategy.md`
- **主な対話相手**: technology-director(上位・指名)、copywriter(横・翻訳協業)、seo-geo-strategist(横・hreflang 整合)
- **v0.2 制約**: 全テンプレートの 4 言語化は v0.3 以降。v0.2 では戦略設計と最小実装のみ。

---

## 7. v0.3 で実装済の追加エージェント(2026-05-01 確定 / Phase G)

論点 3(2026-04-30 Shin との合意)の通り、v0.3 では **+5 体** を追加し合計 26 体に到達。当初 v0.2 改訂方針指示書で想定されていた v0.3 リスト(research-lead / motion-design-lead / qa-lead 等)は v0.4 以降に持ち越し。

### v0.3 で追加された 5 体(実装済)

| Tier | Agent | Model | 所属 Practice | 主な責任 |
|---|---|---|---|---|
| 1 | product-director(本格起動) | Opus | Product | B 系プロダクト戦略・PMF 判断・roadmap |
| 2 | product-manager(新規) | Sonnet | Product | スプリント計画・バックログ管理・週次進捗 |
| 3 | backend-engineer(新規) | Sonnet | Engineering | API / DB / 認証 / ビジネスロジック実装 |
| 3 | devops-engineer(新規) | Sonnet | Engineering | CI/CD / インフラ / 監視 / シークレット |
| 3 | qa-engineer(新規) | Sonnet | Engineering | 自動テスト / E2E / リグレッション / QA レポート |

backend-lead(既存)も v0.3 で direct reports が +3 体になり、責務範囲を拡張。

### v0.3 で対応する案件タイプ追加

- B1. SaaS MVP(Phase I-B 検証案件として投入予定)
- AILEAP 自社プロダクト案件の本格運用(MeetingAI 含む)

### v0.3 では対応しない(v0.4+ に持ち越し)

| Agent | 持ち越し理由 |
|---|---|
| research-lead, user-researcher, data-analyst | ユーザーリサーチの本格運用は v0.4 で(現状 ux-strategy-lead がペルソナ作成を兼任) |
| motion-design-lead | A 系で art-direction-lead が兼任可能 |
| qa-lead | qa-engineer が backend-lead 配下で運用 — Tier 2 専任は v0.4 で |
| accessibility-specialist | seo-geo-strategist が H-4 fix で兼任 |
| saas-stack-specialist | B1 案件の検証結果を見て v0.4 で必要性判定 |
| headless-cms-specialist | A3 案件の検証結果を見て v0.4 で必要性判定 |
| astro-specialist | 同上 |
| A4 リブランド改修 / C3 リニューアル + 機能拡張 | v0.4 で対応(段階展開原則) |

---

## 8. v0.4 で追加予定のエージェント(参考)

合計 +6-8 体、v0.4 段階で 38+ 体に拡張予定。

### Tier 1 追加(検討中)

| Agent | 所属 Practice | 主な責任 |
|---|---|---|
| platform-lead | Engineering | DevOps / インフラ / CI/CD / 監視の専任 |

### Tier 3 追加(8 体)

| Agent | 所属 Practice | 主な責任 |
|---|---|---|
| security-engineer | Engineering | 認証認可・脆弱性対応・OWASP |
| performance-engineer | Engineering | Core Web Vitals・Lighthouse 最適化 |
| migration-engineer | Delivery | データ移行・リダイレクト設計 |
| asset-coordinator | Delivery | アセット受領管理(C-4 を専任化) |
| approval-tracker | Delivery | 承認管理(C-1 を専任化) |
| launch-conductor | Delivery | 公開当日の統合管理 |
| cms-trainer | Delivery | CMS 操作マニュアル・教育コンテンツ |
| partner-coordinator | Delivery | 外部パートナー(撮影・特殊実装)連携 |

### Tech Stack 追加(検討中)

- ai-integration-specialist(LLM API / RAG / Vector DB)
- shopify-specialist(EC)
- mobile-pwa-specialist
- aws-specialist

### v0.4 で対応する案件タイプ追加

- B2. SaaS スケール
- B3. 社内業務システム
- B4. AI 機能搭載プロダクト
- C1. EC 構築
- C2. プラットフォーム + ブランドサイト

---

## 9. モデル割当の設計判断

### 9.1 Opus 採用エージェント(6 体)

- studio-director
- strategy-director
- creative-director
- technology-director
- product-director
- delivery-director

理由:
- **戦略判断・衝突解決の最終裁定者**である
- **クライアント案件の品質と価格を統合判断**する責任を持つ
- 推論精度が直接案件の成否に影響する

### 9.2 Sonnet 採用エージェント(15 体)

- 全 Tier 2 Lead(6 体)
- 全 Tier 3 Specialist(6 体)
- 全 Tech Stack Specialist(3 体)

理由:
- **専門領域の実行担当**であり、Director の判断を受けて動く
- パターン化されたタスク(コード生成・コピー作成・監査)が多い
- Sonnet で品質損失なく対応可能

### 9.3 Haiku 採用しない理由

v0.2 段階では Haiku 採用エージェントを設けない。理由:

- 本組織の成果物はすべてクライアント納品物であり、品質要求が高い
- Haiku 採用候補(typo 検出など)は hooks や rules で代替可能
- 21 体規模なら Sonnet 一律で運用コストが許容範囲

v0.3 以降で Haiku 採用候補が見えてきた場合に再検討する。

---

## 10. エージェントプロンプトの共通要素

すべてのエージェント定義ファイル(`.claude/agents/*.md`)には以下の要素を必ず含める。詳細は Phase B2 実装時に各エージェント定義に反映する。

### 10.1 frontmatter

```yaml
---
name: <agent-name>
model: opus | sonnet
tier: 0 | 1 | 2 | 3 | stack
practice: strategy | creative | engineering | product | delivery | cross
v0_2_active: true | false
modes:
  production: true   # 制作モード対応
  development: false # 開発モード対応(v0.3 以降)
---
```

### 10.2 共通セクション(英語で記述)

1. Role and Mission
2. Reporting Structure(誰の上位・下位か)
3. Domain Boundaries(触れるパス・触れないパス)
4. Mode Switching(制作モード・開発モードの振る舞い差)
5. Collaboration with Other Agents
6. Output Format Requirements
7. **Output Language Policy**(必須・[language-policy.md](language-policy.md) 参照)

### 10.3 Output Language Policy(必須)

すべてのエージェントプロンプト末尾に以下を含める([v0.2-direction.md](v0.2-direction.md) Section 3.3 / [language-policy.md](language-policy.md) 参照):

```markdown
## Output Language Policy

**ALWAYS respond in the user's native language.** Detection rules:

- Internal team communication (with Shin / AILEAP): **Japanese**
- Client deliverables (proposals, requirements docs, presentations):
  Match the client's language. Default to **Japanese** for domestic SME
  clients in Japan unless otherwise specified.
- Multi-language sites (i18n projects): Generate content in all target
  languages as specified in the project's i18n configuration.
- Technical artifacts read only by other agents (intermediate YAML,
  internal logs): English is acceptable.

When in doubt, default to **Japanese**.
```

---

## 11. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では requirements 内の 4.1-4.5 に分散。v0.2 で独立文書化、20+1 体に整理。 |
| 0.3 | 2026-05-01 | Phase G 完了。B 系プロダクト開発体制を解放(+5 体): product-director フル稼働化、product-manager / backend-engineer / devops-engineer / qa-engineer 新規追加。合計 21 → 26 体。backend-lead の direct reports を 3 体に拡張。§7 を v0.4 想定にシフト。 |

---

**本書は v0.3 エージェント・ロスターの正本である。`.claude/agents/` 配下の各エージェント定義ファイルは本書と整合していること。エージェント追加・削除・モデル変更時は本書を更新する。**
