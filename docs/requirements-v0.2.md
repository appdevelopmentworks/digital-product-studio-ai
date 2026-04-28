# digital-product-studio-ai 要件定義書 v0.2

**プロジェクト名**: digital-product-studio-ai
**バージョン**: 0.2
**作成日**: 2026-04-27
**所属組織**: AILEAP
**位置づけ**: AILEAP 3組織アーキテクチャの中流レイヤー(制作 + 開発 + 納品)
**前バージョン**: [requirements-v0.1.md](requirements-v0.1.md) / [gap-analysis-v0.1.md](gap-analysis-v0.1.md) / [v0.2-direction.md](v0.2-direction.md)

---

## 0. ドキュメント概要

### 0.1 本書の位置づけ

本書は AILEAP の3組織アーキテクチャにおける中流レイヤー、すなわち「**ヒアリングから納品までの全工程を AI エージェントで遂行するデジタルプロダクト開発スタジオ**」の v0.2 要件を定義する。

v0.1 で示した骨格を、自己批判分析([gap-analysis-v0.1.md](gap-analysis-v0.1.md))と Shin との合意([v0.2-direction.md](v0.2-direction.md))に基づいて再構築したものである。Game Studio 参照モデル(48エージェント、3層階層、path-scoped rules)を Web/デジタルプロダクト開発文脈に適合させる方針は維持しつつ、以下4点を本書で大きく強化する。

1. **段階展開戦略**: 38 エージェントを一気に展開せず、v0.2 = 20+1 体で開始し、v0.3 / v0.4 で順次拡張
2. **顧客対応プロセスの構造化**: 承認・議事録・アセット受領を要件レベルで定義
3. **AI Native 制作会社としての差別化軸**: 8 軸の比較表を要件レベルで明文化
4. **責任分界の精緻化**: SEO/GEO の段階別境界、初期コンテンツ制作の境界、制作系/開発系のモード切替

### 0.2 v0.1 からの主要変更点

| 領域 | v0.1 | v0.2 | 関連 Critical/High |
|---|---|---|---|
| エージェント数 | 37/38(混在) | 20+1(段階展開明示) | F-C1, CO-C1 |
| Slash Commands | 30 | 28(顧客対応 7 個追加・将来分は除外) | CO-H1 |
| Hooks | 7 | 8(承認チェック追加) | C-1 |
| Path-scoped Rules | 10 | 10(env/i18n 追加・migrations/tests 削除) | M-6, H-6 |
| Templates | 21 | 21(法務確認ヘッダー強制) | F-H3 |
| 差別化軸 | 未定義 | 8 軸の比較表 | D-C1 |
| 顧客対応プロセス | Section 11 のみ | 独立章(承認・議事録・アセット) | C-1〜C-4 |
| 段階展開戦略 | なし | 独立章 | F-C1 |
| 多言語対応 | v0.2 以降 | v0.2 で localization-specialist 追加 | H-6, Q5 |
| 自社プロダクト対応 | 不明 | 内部クライアントとして対象化 | D-H3, Q2 |
| 動作環境 | 未定義 | Windows 11 + WSL2 プライマリ | F-H2, Q3 |
| 法務テンプレート | ひな型のみ | 弁護士確認ヘッダー強制 | F-H3, Q4 |
| 通信フォーマット | 未統一 | YAML 標準化 | F-H1 |

### 0.3 関連文書との関係

本書は要件の中核を定義する。以下の独立文書がそれぞれ詳細仕様を担う。

```
requirements-v0.2.md (本書)
├── architecture.md            5プラクティス制の設計思想・段階展開ロードマップ
├── handoff-protocols.md       apex / WMAO 双方向ハンドオフ YAML スキーマ
├── agent-roster.md            20+1 エージェント全員の名前・役割・モデル割当
├── agent-coordination-map.md  委譲・エスカレーション・衝突解決マトリクス
├── quick-start.md             初回セットアップ・最初の案件起動手順
├── setup-requirements.md      Windows 11 + WSL2 環境構築手順
├── pricing-strategy.md        単価レンジ・リテイナー・成果報酬・LTV
├── geo-implementation-spec.md llms.txt / 構造化データ / 引用最適化
├── legal-escalation-rules.md  弁護士介在ポイントの Decision Tree
└── language-policy.md         全エージェント・スキルが参照する言語ポリシー
```

本書は要件の概要と各文書への参照ハブとして機能する。詳細は各独立文書を正本とする(単一情報源原則)。

---

## 1. ミッションとスコープ

### 1.1 ミッション

> **SME クライアントおよび AILEAP 自社プロダクトのデジタルプロダクト案件(コーポレートサイト〜SaaS 開発まで)を、ヒアリングから保守運用直前まで AI エージェント中心で遂行する。**

v0.1 からの変更点: 「自社プロダクト」を対象に明示追加(D-H3 / Q2 対応)。

### 1.2 扱う案件タイプ(In Scope)

| カテゴリ | サブタイプ | 主な技術領域 | v0.2 対応 |
|---|---|---|---|
| **A. 制作系** | A1. コーポレートサイト | Next.js / Astro / WordPress | ✅ |
| | A2. ランディングページ | Next.js / Astro / 静的 HTML | ✅ |
| | A3. メディア・オウンドメディア | WordPress / Headless CMS | ✅ |
| | A4. リブランド改修 | 既存スタックの拡張 | v0.3 |
| **B. 開発系** | B1. SaaS MVP | Next.js + tRPC + Postgres | v0.3 |
| | B2. SaaS スケール | NestJS / マイクロサービス | v0.4 |
| | B3. 社内業務システム | Next.js + 認証 + 業務 DB | v0.4 |
| | B4. AI 機能搭載プロダクト | LLM API / RAG / Vector DB | v0.4 |
| **C. ハイブリッド** | C1. EC 構築 | Shopify / Next.js Commerce | v0.4 |
| | C2. プラットフォーム + ブランドサイト | フルスタック動員 | v0.4 |
| | C3. リニューアル + 機能拡張 | 移行 + 新規開発 | v0.3 |

v0.2 で正式対応するのは A1 / A2 / A3 の3タイプ。これは段階展開戦略([Section 3](#3-段階展開戦略)参照)に基づく。

### 1.3 範囲外(Out of Scope)

以下は本組織の責任範囲外とし、AILEAP 内の他組織または外部に委ねる。

| 範囲外領域 | 委ねる先 | 理由 |
|---|---|---|
| 事業戦略・経営戦略・業務改革コンサル | apex-consulting-ai | 本組織はチャネル戦略までを扱う |
| 業界・市場のビジネスモデル分析 | apex-consulting-ai | 同上 |
| 公開後 31 日以降の継続 SEO・GEO 改善運用 | web-marketing-ai-org (WMAO) | 本組織は土台構築 + 公開後 30 日検証まで |
| コンテンツマーケティングの継続運用(11 本目以降) | WMAO | 初期 5-10 本は本組織で制作 |
| SNS 運用・広告運用・メルマガ運用 | WMAO | 同上 |
| A/B テスト・CRO の継続運用 | WMAO | 同上 |
| 写真撮影・動画撮影の実作業 | 外部パートナー | AI 単独で不可。本組織はディレクションまで |
| 個別の法的判断・契約書最終レビュー | 外部弁護士 | AI による法的助言は不可 |

v0.1 から変更: SEO/GEO とコンテンツマーケの境界を「公開後 30 日」「初期 10 本」で明確化(B-C1 / B-C2 対応)。

### 1.4 Differentiation Axis(差別化軸)— 新規

AI Native 制作会社としての訴求軸を要件レベルで明文化する(D-C1 対応)。全エージェントは本軸を念頭に振る舞い、特に `commercial-manager` は提案書生成時に必ず以下 8 軸を反映する。

| 軸 | 従来制作会社 | digital-product-studio-ai |
|---|---|---|
| 速度 | 提案書 1 週間 | 提案書 1 営業日 |
| 価格 | デザイン+実装 100-300 万 | 同等品質 50-150 万 |
| 技術選定 | 1 社 1 スタック固定 | 案件ごとに最適スタック(Next.js / Astro / WordPress / 他) |
| GEO 対応 | ほぼ未対応 | 標準装備(llms.txt / 構造化データ / 引用最適化) |
| 修正対応 | 営業日対応 | 24 時間以内ドラフト |
| コンサル統合 | 別会社・別費用 | apex-consulting-ai 連携で 1 パッケージ |
| 多言語 | 別途見積 | 標準対応(日英中韓) |
| アクセシビリティ | オプション | 標準 WCAG 2.2 AA |

各軸の運用詳細は本書の関連セクションで定義する。

- 速度: [Section 17. 速度優位性の仕組み](#17-速度優位性の仕組みspeed-critical-path) で具体化
- 価格: [pricing-strategy.md](pricing-strategy.md) で詳細
- GEO: [geo-implementation-spec.md](geo-implementation-spec.md) で詳細
- 多言語: [Section 16. 多言語対応戦略](#16-多言語対応戦略)
- アクセシビリティ: [Section 8. Path-scoped Rules](#8-path-scoped-rules10-個) と design-system テンプレートで担保

---

## 2. AILEAP 3組織アーキテクチャ

### 2.1 全体構造

```
┌─────────────────────────────────────────────────────────────┐
│ apex-consulting-ai【上流: 戦略・経営】(既存)                 │
│   事業戦略 / 業務改革 / 市場分析 / デジタル戦略全体           │
│   → 「Web プロダクトが必要」と判断したらハンドオフ            │
└──────────────────────────┬──────────────────────────────────┘
                           │ /handoff-from-strategy
                           ↑ /escalate-to-strategy(逆ハンドオフ・新設)
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ digital-product-studio-ai【中流: 制作・開発】(本書)           │
│   案件タイプ判定 → Discovery → Design → Engineering →       │
│   QA → Launch → 公開後 30 日検証 → Handoff                  │
└──────────────────────────┬──────────────────────────────────┘
                           │ /handoff-to-marketing
                           ↑ /handoff-back-to-production(逆ハンドオフ・新設)
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ web-marketing-ai-org (WMAO)【下流: 運用・成長】(既存)         │
│   継続 SEO / GEO / コンテンツマーケ / SNS / 広告 / 改善運用   │
└─────────────────────────────────────────────────────────────┘
```

3組織は別リポジトリで独立管理する(Q6 確定)。各組織は自分のリポジトリ内で完結し、ハンドオフは YAML プロトコル + 手動ファイルコピーで行う。v0.2 では自動化しない。

### 2.2 ハンドオフプロトコル仕様(概要)

詳細な YAML スキーマ定義と全フィールド仕様は [handoff-protocols.md](handoff-protocols.md) に集約する。本書では概要のみ示す。

#### 2.2.1 順方向ハンドオフ

| プロトコル | 起動側 | 受領側 |
|---|---|---|
| `/handoff-from-strategy` | apex-consulting-ai | digital-product-studio-ai |
| `/handoff-to-marketing` | digital-product-studio-ai | web-marketing-ai-org |

#### 2.2.2 逆方向ハンドオフ(新設・B-H1 / B-H2 対応)

| プロトコル | 起動側 | 受領側 | 用途 |
|---|---|---|---|
| `/escalate-to-strategy` | digital-product-studio-ai | apex-consulting-ai | 「Web で解決すべきでなく経営課題」と判定した場合 |
| `/handoff-back-to-production` | web-marketing-ai-org | digital-product-studio-ai | 運用中に「サイト構造改修が必要」と判定した場合 |

### 2.3 内部フェーズ移行

v0.1 と同じ 7 フェーズに、公開後検証フェーズを追加して 8 フェーズとする(B-C1 対応)。

```
Engagement → Discovery → Strategy → Design →
Implementation → QA → Launch → Post-launch (30日検証) → Handoff
```

各フェーズ間は `delivery-director` が `/gate-check` を実施し、次フェーズへの移行可否を判定する。Post-launch フェーズの 30 日経過後にのみ WMAO ハンドオフが可能。

---

## 3. 段階展開戦略 — 新規

### 3.1 採用理由

v0.1 では 38 エージェントを一気に展開する想定だったが、以下の理由で段階展開に変更する(F-C1 対応)。

- apex-consulting-ai は 12 エージェント、web-marketing-ai-org は 10 エージェントで運用中。digital-product-studio-ai が 38 を一気に抱えると、プロンプト管理・整合性維持・改訂コストが apex+WMAO 合算より重くなる。
- 一気に全機能展開すると初回案件で多数の不整合が露見する(apex の v0.1→v0.2 の経験から)。
- 段階ごとに実案件で検証することで、不要なエージェントの削減・必要なエージェントの追加が現実的なコストでできる。

### 3.2 ロードマップ

```
v0.2 (Production-ready core):  20 + 1 エージェント
   - Tier 0: 1
   - Tier 1: 5(全 Practice Director)
   - Tier 2: 6(主要 Discipline Lead のみ)
   - Tier 3: 6(Critical Specialists のみ)
   - Tech Stack: 2(nextjs / wordpress)+ 1(localization・Q5 前倒し)
   対応案件タイプ: A1 / A2 / A3
   合計: 21 体(20 枠 + 多言語 1 体)

v0.3 (Expansion):              30 エージェント前後
   - Tier 2 追加: research-lead, motion-design-lead, qa-lead
   - Tier 3 追加: backend-engineer, devops-engineer, user-researcher,
                  data-analyst, accessibility-specialist
   - Tech Stack 追加: saas-stack, headless-cms, astro
   対応案件タイプ追加: A4 / B1 / C3

v0.4 (Full):                   38+ エージェント
   - Tier 1 追加可能性: platform-lead 等
   - Tier 3 追加: security-engineer, performance-engineer,
                  migration-engineer, asset-coordinator,
                  approval-tracker, launch-conductor, cms-trainer,
                  partner-coordinator
   対応案件タイプ追加: B2 / B3 / B4 / C1 / C2
```

### 3.3 段階移行の合格基準

各段階で 1 案件回して検証してから次に進むことを必須化する。具体的な合格基準は Phase D 着手時に Shin と協議のうえ決定するが、暫定的に以下を想定する。

| 観点 | 目標値 |
|---|---|
| Engagement → Launch までの所要日数 | 案件タイプ別標準納期内([Section 17](#17-速度優位性の仕組みspeed-critical-path)) |
| Lighthouse Performance | 90 以上 |
| Lighthouse Accessibility | 95 以上 |
| Lighthouse SEO | 100 |
| WCAG 2.2 AA 準拠率 | 100% |
| Critical な手戻り回数 | 5 回以下 |
| エージェント間の不整合発生件数 | 3 件以下 |

実際の合格基準は Phase D 着手時に [v0.2-direction.md](v0.2-direction.md) Section 11 の Definition of Done と合わせて再確定する。

---

## 4. 組織構造(5プラクティス制)

### 4.1 階層全体図(v0.2 段階)

```
Tier 0:  Studio Director(統合トップ・Opus)
         └─ 1 名

Tier 1:  Practice Directors(Opus・5 名)
         ├─ Strategy Practice
         ├─ Creative Practice
         ├─ Engineering Practice
         ├─ Product Practice
         └─ Delivery Practice

Tier 2:  Discipline Leads(Sonnet・6 名)
         主要プラクティスに 1 体ずつ配置

Tier 3:  Specialists(Sonnet・6 名)
         Critical な役割のみ

横断:    Tech Stack Specialists(Sonnet・3 名)
         案件起動時に動的に呼び出し
         (うち localization-specialist は Q5 前倒しで v0.2 投入)
```

合計: **20 + 1 = 21 体**(20 枠 + 多言語 1 体)。

### 4.2 Practice の責任分界

| Practice | 責任領域 | リーダー |
|---|---|---|
| **Strategy Practice** | チャネル戦略・UX 戦略・コンテンツ戦略・SEO/GEO 戦略 | strategy-director |
| **Creative Practice** | デザイン・ブランド表現・モーション・コピー | creative-director |
| **Engineering Practice** | 実装・インフラ・セキュリティ・パフォーマンス | technology-director |
| **Product Practice** | プロダクト戦略・ユーザーリサーチ(開発系案件のみ) | product-director |
| **Delivery Practice** | 顧客対応・契約・スケジュール・公開・納品 | delivery-director |

v0.2 段階では Product Practice は director のみ配置し、配下の specialist 拡充は v0.3 以降。

詳細は [architecture.md](architecture.md) を参照。

---

## 5. エージェント・ロスター(20+1 名)

詳細は [agent-roster.md](agent-roster.md) に集約する。本書では一覧のみ示す。

### 5.1 Tier 0 — Studio Director(1 名・Opus)

| Agent | Model | 役割 |
|---|---|---|
| studio-director | Opus | 全 Practice の統合判断、apex/WMAO とのハンドオフ管轄、最終意思決定、案件切替時の context flush |

### 5.2 Tier 1 — Practice Directors(5 名・Opus)

| Agent | Model | 主な責任 |
|---|---|---|
| strategy-director | Opus | チャネル戦略・UX 戦略・コンテンツ戦略の最終判断 |
| creative-director | Opus | ビジュアル・ブランド表現・トーン&マナーの守護 |
| technology-director | Opus | アーキテクチャ・技術選定・セキュリティ方針 |
| product-director | Opus | プロダクト戦略(開発系案件)・PMF 判断 |
| delivery-director | Opus | 顧客関係・予算・スケジュール・契約・公開遂行・全フェーズの gate-check |

### 5.3 Tier 2 — Discipline Leads(6 名・Sonnet)

| Agent | 所属 Practice | 主な責任 |
|---|---|---|
| ux-strategy-lead | Strategy | 情報設計・サイトマップ・ユーザージャーニー |
| content-strategy-lead | Strategy | コンテンツ戦略・コピー方針・SEO/GEO 構造設計 |
| art-direction-lead | Creative | ビジュアル統括・デザインシステム |
| frontend-lead | Engineering | フロントエンド実装統括 |
| backend-lead | Engineering | バックエンド・API・DB 統括(B 系案件・v0.3 から本格活用) |
| client-success-lead | Delivery | ヒアリング・納品・保守窓口・AI 判断の人間翻訳 |

### 5.4 Tier 3 — Specialists(6 名・Sonnet)

| Agent | 所属 Practice | 主な責任 |
|---|---|---|
| ui-designer | Creative | UI 詳細設計・コンポーネントデザイン |
| copywriter | Creative | 全ページコピー・CTA・SEO/GEO 観点コピー・初期コンテンツ 5-10 本 |
| frontend-engineer | Engineering | コンポーネント実装・SSR/SSG・状態管理 |
| cms-engineer | Engineering | WordPress / Headless CMS 構築 |
| seo-geo-strategist | Strategy | SEO 戦略 + GEO(LLM 引用最適化)戦略設計・公開後 30 日検証 |
| commercial-manager | Delivery | 見積・契約・SOW・変更注文管理・3 パターン提案(T&M / Fixed / Retainer)必須化 |

### 5.5 Tech Stack Specialists(3 名・Sonnet・横断)

| Agent | 対応領域 |
|---|---|
| nextjs-specialist | Next.js App Router / RSC / Server Actions |
| wordpress-specialist | WordPress テーマ開発 / ACF / セキュリティ |
| localization-specialist | next-intl / Astro i18n / WordPress Polylang(Q5 前倒し) |

### 5.6 v0.3 / v0.4 で追加予定のエージェント

[agent-roster.md](agent-roster.md) に v0.3 / v0.4 で追加予定の一覧を集約する。本書では参考までに代表例を記載する。

- **v0.3 追加候補**: research-lead, motion-design-lead, qa-lead, backend-engineer, devops-engineer, user-researcher, data-analyst, accessibility-specialist, saas-stack-specialist, headless-cms-specialist, astro-specialist
- **v0.4 追加候補**: platform-lead, security-engineer, performance-engineer, migration-engineer, asset-coordinator, approval-tracker, launch-conductor, cms-trainer, partner-coordinator

---

## 6. Slash Commands(28 個)

### 6.1 Engagement(顧客接点・4 個)

| Command | 動作 |
|---|---|
| /client-onboarding | 初回ヒアリング構造化フロー(stakeholder + 制約発見) |
| /requirements-gathering | 要件定義書ドラフト生成 |
| /competitor-analysis | 競合 5 社の Web 視点比較レポート |
| /estimate | 工数・費用見積生成(リスクバッファ含む) |

### 6.2 Strategy & Design(3 個)

| Command | 動作 |
|---|---|
| /sitemap-design | 情報設計・サイトマップ生成 |
| /design-system | デザインシステム文書生成(a11y 章必須) |
| /content-strategy | コンテンツ戦略文書生成 |

### 6.3 Implementation(1 個)

| Command | 動作 |
|---|---|
| /code-review | コードレビュー(path-scoped rules 適用) |

### 6.4 Audit(3 個)

| Command | 動作 |
|---|---|
| /seo-audit | 従来型 SEO 監査(メタ・構造化データ・内部リンク等) |
| /geo-audit | LLM/AI 検索向け最適化監査(llms.txt・構造化データ・引用されやすさ) |
| /accessibility-audit | WCAG 2.2 AA 準拠チェック |

### 6.5 Production Management(2 個)

| Command | 動作 |
|---|---|
| /change-order | 変更注文書生成(追加見積含む) |
| /scope-check | スコープ逸脱検出 |

### 6.6 Launch(2 個)

| Command | 動作 |
|---|---|
| /launch-checklist | 公開直前チェックリスト実行(DNS/SSL/モニタ等) |
| /handoff-package | 納品パッケージ生成(マニュアル・権限・SLA 等) |

### 6.7 Post-launch(1 個)

| Command | 動作 |
|---|---|
| /handoff-to-marketing | WMAO へのハンドオフパッケージ生成(公開後 30 日経過必須) |

### 6.8 Team Orchestration(3 個・v0.2 範囲)

| Command | 動員エージェント |
|---|---|
| /team-corporate-site | strategy-director + ux-strategy-lead + creative-director + ui-designer + frontend-lead + frontend-engineer + cms-engineer + content-strategy-lead + copywriter + seo-geo-strategist + delivery-director |
| /team-landing-page | strategy-director + creative-director + ui-designer + copywriter + frontend-engineer + seo-geo-strategist + delivery-director |
| /team-mediasite | strategy-director + content-strategy-lead + copywriter + cms-engineer + seo-geo-strategist + creative-director + ui-designer + delivery-director |

v0.3 で `/team-saas-mvp` / `/team-corporate-renewal` 等を追加。v0.4 で `/team-ecommerce` 等を追加。

### 6.9 Approval(新設・3 個・C-1 対応)

| Command | 動作 |
|---|---|
| /approval-request | クライアントへの承認依頼書(メール下書き含む)生成 |
| /approval-record | 承認結果の記録 |
| /approval-status | 案件全体の承認状況可視化 |

### 6.10 Asset Management(新設・2 個・C-4 対応)

| Command | 動作 |
|---|---|
| /asset-checklist | 案件タイプに応じた必要アセット一覧生成 |
| /asset-status | 受領状況可視化、未受領のリマインドメール下書き生成 |

### 6.11 Meeting & Decision(新設・2 個・C-2 対応)

| Command | 動作 |
|---|---|
| /meeting-minutes | 録音・メモから構造化議事録生成 |
| /decision-log | 重要意思決定をエスカレーションパス付きで記録 |

### 6.12 Pricing(新設・1 個・C-3 対応)

| Command | 動作 |
|---|---|
| /retainer-design | 月額保守契約設計 |

### 6.13 Multi-language(Q5 前倒し・1 個)

| Command | 動作 |
|---|---|
| /i18n-strategy | 多言語対応戦略文書生成(対応言語・URL 構造・翻訳ワークフロー) |

合計: **28 スキル**

---

## 7. Hooks(8 個)

| Hook | 起動タイミング | 動作 |
|---|---|---|
| session-start.sh | セッション開始 | 直近の案件状態・git 活動を読込 |
| validate-meta-tags.sh | git commit | title/description/og の有無検証 |
| validate-images.sh | `public/images/**` への書込 | alt 属性・最適化(WebP 変換)検証 |
| validate-a11y.sh | git commit | コントラスト・キーボード操作・基本 a11y 検証 |
| lighthouse-budget.sh | デプロイ前 | Lighthouse スコア閾値割れで停止(Performance ≥ 90 等) |
| legal-pages-check.sh | デプロイ前 | プライバシーポリシー・利用規約・特商法・Cookie 同意の存在 + 弁護士確認ヘッダー検証 |
| pre-deploy-approval-check.sh | デプロイ前 | デザイン承認・公開承認が `approvals.yaml` に記録されているか検証(C-1 対応) |
| session-stop.sh | セッション終了 | 進捗・成果物を案件ログに記録 |

すべて bash で実装、Windows 11 + WSL2 + Git Bash で動作することを必須要件とする。PowerShell 版は v0.4 以降。

---

## 8. Path-scoped Rules(10 個)

| Path | 適用ルール |
|---|---|
| `src/components/**` | Atomic Design 準拠、Props 型定義必須、Storybook 記述推奨 |
| `app/**` または `pages/**` | SEO メタ・構造化データ必須、OGP 画像指定必須 |
| `content/**` | コピーガイドライン準拠、誤字検出 |
| `design/**` | デザインシステム準拠、トークン使用必須 |
| `public/images/**` | WebP/AVIF 推奨、サイズ最適化、alt 属性元データ必須 |
| `src/api/**` | 入力バリデーション必須、エラーハンドリング標準化、認証必須 |
| `docs/legal/**` | プライバシーポリシー・利用規約等のひな型遵守、弁護士確認ヘッダー必須 |
| `projects/{id}/**` | 案件外への参照禁止(マルチテナント隔離) |
| `.env, secrets/**` | コミット禁止、暗号化必須(F-M6 / M-6 対応・新設) |
| `i18n/**` | 4 言語(日英中韓)テンプレ準拠、欠落キー検出(Q5 対応・新設) |

v0.1 から削除: `db/migrations/**`(B 系案件 v0.3 以降のため)、`tests/**`(包括的なテスト戦略は qa-lead 投入の v0.3 以降)。

---

## 9. Templates(21 個)

すべて日本語で記述する。法務 3 個には弁護士確認ヘッダーを冒頭挿入する(Q4 確定)。

### 9.1 営業・契約フェーズ(5 個)

- proposal-deck.md
- estimate.md
- sow.md
- change-order.md
- requirements-v0.md

### 9.2 Discovery・戦略フェーズ(7 個)

- competitor-analysis.md
- persona.md
- user-journey-map.md
- sitemap.md
- measurement-plan.md
- content-strategy.md
- seo-geo-strategy.md

### 9.3 Design フェーズ(1 個)

- design-system.md(a11y 章必須・H-4 対応)

### 9.4 Launch フェーズ(3 個)

- launch-checklist.md
- redirect-map.md
- handoff-package.md

### 9.5 納品後(2 個)

- cms-manual.md
- handoff-to-wmao.md

### 9.6 法務(3 個・弁護士確認ヘッダー強制)

- legal-privacy-policy.md
- legal-terms.md
- legal-tokushoho.md

### 9.7 弁護士確認ヘッダー仕様

法務 3 テンプレート冒頭に必ず以下のブロックを挿入する。

```markdown
> **⚠️ 法務確認必須**
> 本テンプレートはひな型であり、AILEAP は法的助言を行いません。
> 本番運用前に必ず弁護士による確認を受けてください。
> 本テンプレートの使用に起因する一切の損害について、
> AILEAP は責任を負いません。
```

`legal-pages-check.sh` フックがこのヘッダーの存在を検証する。

---

## 10. プロジェクトディレクトリ構造

### 10.1 リポジトリ全体構造

```
digital-product-studio-ai/
├── README.md                       日本語(プロジェクト概要)
├── CLAUDE.md                       日本語(Shin 向け部分)+ 英語(AI 向け部分)
├── UPGRADING.md                    日本語(v0.1 → v0.2 移行手順)
├── .git/
├── .gitignore
├── .claude/
│   ├── settings.json               英語
│   ├── agents/                     英語(21 体のプロンプト)
│   ├── skills/                     英語(28 スキル)
│   ├── hooks/                      英語(8 hooks, .sh)
│   └── rules/                      英語(10 rules)
├── docs/                           日本語(全て)
│   ├── requirements-v0.1.md        履歴として保持
│   ├── gap-analysis-v0.1.md        履歴として保持
│   ├── v0.2-direction.md           履歴として保持
│   ├── claude-code-handoff.md      履歴として保持
│   ├── requirements-v0.2.md        本書
│   ├── architecture.md
│   ├── handoff-protocols.md
│   ├── agent-roster.md
│   ├── agent-coordination-map.md
│   ├── quick-start.md
│   ├── setup-requirements.md
│   ├── pricing-strategy.md
│   ├── geo-implementation-spec.md
│   ├── legal-escalation-rules.md
│   ├── language-policy.md
│   └── templates/                  日本語(21 テンプレート)
└── projects/                       案件ごとのワークスペース
    └── {client-name}_{project-id}/
```

### 10.2 案件ディレクトリ構造(C-2 / C-4 対応で拡張)

```
projects/{client-name}_{project-id}/
├── PROJECT.md                      案件メタデータ
├── 00-engagement/
│   ├── meetings/                   議事録(C-2 対応・新設)
│   │   └── YYYY-MM-DD_<topic>.md
│   ├── correspondence/             メール・チャット抜粋(C-2 対応・新設)
│   ├── decisions.yaml              意思決定ログ(C-2 対応・新設)
│   ├── approvals.yaml              承認ログ(C-1 対応・新設)
│   └── stakeholders.yaml
├── 01-discovery/
│   ├── competitor-analysis.md
│   ├── persona.md
│   ├── user-journey-map.md
│   ├── assets-required.yaml        必要アセットチェックリスト(C-4 対応・新設)
│   ├── assets-received/            受領済みアセット(C-4 対応・新設)
│   └── credentials/                認証情報(暗号化前提・C-4 対応・新設)
├── 02-strategy/
│   ├── sitemap.md
│   ├── content-strategy.md
│   ├── seo-geo-strategy.md
│   └── measurement-plan.md
├── 03-design/
│   └── design-system.md
├── 04-implementation/
├── 05-qa/
│   ├── seo-audit.md
│   ├── geo-audit.md
│   ├── accessibility-audit.md
│   └── performance-report.md
├── 06-launch/
│   ├── launch-checklist.md
│   └── redirect-map.md
├── 07-post-launch/                 公開後 30 日検証(B-C1 対応・新設)
│   ├── 30day-report.md
│   └── initial-content/            初期コンテンツ 5-10 本(B-C2 対応)
├── 08-handoff/
│   ├── handoff-package.md
│   ├── handoff-to-wmao.md
│   └── cms-manual.md
└── session-state/                  studio-director の状態保存
```

### 10.3 マルチテナント設計

- 各案件は `projects/{client-name}_{project-id}/` で完全隔離
- session-state は案件ごとに分離
- path-scoped rule `projects/{id}/**` で案件外参照を禁止
- studio-director が現在アクティブな案件 ID を保持・切替
- 案件切替時に context flush(F-C2 対応)

### 10.4 並列案件数の現実的制約(F-C2 対応)

[Section 18. 並列案件管理の現実的制約](#18-並列案件管理の現実的制約) を参照。

---

## 11. エージェント協調ルール

Game Studio の 4 原則をそのまま採用し、Web 制作・開発特有の追加原則を加える。

### 11.1 基本 4 原則

1. **Vertical delegation**(垂直委譲): Directors → Leads → Specialists の方向のみ命令可
2. **Horizontal consultation**(水平相談): 同層は相談可だが拘束力ある決定は不可
3. **Conflict resolution**(衝突解決): 意見不一致は共通の親エージェントへエスカレーション
4. **Domain boundaries**(担当範囲): 担当外のファイルは触らない

### 11.2 Web 制作・開発特有の追加原則

5. **Client-touching boundary**(顧客接触境界): 顧客と直接対話するエージェントは Delivery Practice 配下のみ
6. **Phase gate enforcement**(フェーズゲート): delivery-director の `/gate-check` 通過なしに次フェーズへ進めない
7. **Change propagation**(変更伝播): スコープ変更は必ず `commercial-manager` が `/change-order` で記録
8. **Mode switching**(モード切替・新設・B-C3 対応): エージェントは「制作モード」「開発モード」を案件タイプから自動判定して振る舞いを切替
9. **Approval gate**(承認ゲート・新設・C-1 対応): デザイン承認・公開承認が `approvals.yaml` に記録されない限りデプロイ不可

### 11.3 衝突解決マトリクス

詳細は [agent-coordination-map.md](agent-coordination-map.md) に集約する。代表例のみ示す。

| 衝突パターン | 一次エスカレーション先 | 最終判断 |
|---|---|---|
| frontend-engineer vs ui-designer | creative-director ↔ technology-director | studio-director |
| copywriter vs seo-geo-strategist | content-strategy-lead | strategy-director |
| commercial-manager vs technology-director(価格と品質) | delivery-director ↔ technology-director | studio-director |
| クライアント要望 vs デザインシステム | client-success-lead → creative-director | studio-director |

---

## 12. 協調モデル: Collaborative, Not Autonomous

Game Studio と同じ思想を継承する。

1. **Ask** — 提案前に質問する
2. **Present options** — 2〜4 案を提示(pros/cons 付き)
3. **You decide** — Shin が判断する
4. **Draft** — 最終化前にドラフトを見せる
5. **Approve** — 承認なしに書き込まない

特に顧客対応(`/client-onboarding`、`/proposal-deck` 等)は、**クライアント送付前に必ず Shin の承認を得る**ことを強制する。

---

## 13. 案件タイプ別ワークフロー(v0.2 対応 3 タイプ)

v0.2 で対応するのは A1 / A2 / A3 のみ。残りは v0.3 / v0.4 で対応する。

### 13.1 A1: コーポレートサイト(`/team-corporate-site`)

```
[1]  /client-onboarding           ヒアリング(client-success-lead)
[2]  /asset-checklist             必要アセット定義(C-4 新設)
[3]  /competitor-analysis         競合調査(content-strategy-lead 主導)
[4]  /requirements-gathering      要件定義(ux-strategy-lead)
[5]  /estimate                    見積(commercial-manager・3 パターン提案必須)
[6]  /approval-request            提案承認依頼(C-1 新設)
[7]  [契約締結後]
[8]  /sitemap-design              情報設計(ux-strategy-lead)
[9]  /design-system               デザイン(art-direction-lead + ui-designer)
[10] /content-strategy            コンテンツ(content-strategy-lead + copywriter)
[11] /i18n-strategy               多言語必要時(localization-specialist・Q5)
[12] /approval-request            デザイン承認依頼
[13] [実装フェーズ]               (frontend-lead + frontend-engineer + cms-engineer + nextjs-specialist or wordpress-specialist)
[14] /code-review                 継続的に走る
[15] /seo-audit /geo-audit /accessibility-audit
[16] /approval-request            公開承認依頼
[17] /launch-checklist            公開準備(delivery-director 主導)
[18] [Post-launch 30 日検証]      seo-geo-strategist が初動分析
[19] /handoff-package             納品(client-success-lead)
[20] /handoff-to-marketing        WMAO へ引継ぎ(30 日経過後)
```

### 13.2 A2: ランディングページ(`/team-landing-page`)

```
[1]  /client-onboarding
[2]  /asset-checklist
[3]  /competitor-analysis(LP 観点・1-2 社)
[4]  /requirements-gathering
[5]  /estimate
[6]  [契約締結後]
[7]  /design-system(LP 単体・軽量)
[8]  /content-strategy(コピー集中)
[9]  [実装]                       (frontend-engineer)
[10] /seo-audit /accessibility-audit
[11] /approval-request            公開承認
[12] /launch-checklist
[13] [Post-launch 30 日検証]
[14] /handoff-package
[15] /handoff-to-marketing
```

### 13.3 A3: メディアサイト(`/team-mediasite`)

```
[1]  /client-onboarding
[2]  /asset-checklist
[3]  /competitor-analysis(コンテンツ戦略観点)
[4]  /requirements-gathering
[5]  /estimate
[6]  [契約締結後]
[7]  /sitemap-design
[8]  /content-strategy            コンテンツが中核
[9]  /design-system
[10] [実装]                       (cms-engineer + wordpress-specialist or headless cms)
[11] [初期コンテンツ 5-10 本制作]  (copywriter + content-strategy-lead・B-C2 対応)
[12] /seo-audit /geo-audit
[13] /approval-request            公開承認
[14] /launch-checklist
[15] [Post-launch 30 日検証]
[16] /handoff-package + cms-manual
[17] /handoff-to-marketing(WMAO が 11 本目以降のコンテンツ運用を引継ぎ)
```

---

## 14. 顧客対応プロセス — 新規

C-1 / C-2 / C-4 対応で要件レベルに昇格させる(v0.1 では Section 11 の 5 行のみ)。

### 14.1 承認管理プロセス(C-1)

#### 14.1.1 承認イベントの定義

| 承認名 | 必須/推奨 | 起動スキル | 記録先 |
|---|---|---|---|
| 提案承認 | 必須 | `/approval-request` → `/approval-record` | `00-engagement/approvals.yaml` |
| 要件承認 | 必須 | 同上 | 同上 |
| デザイン承認 | 必須 | 同上 | 同上 |
| コンテンツ承認 | 推奨 | 同上 | 同上 |
| 公開承認 | 必須 | 同上 | 同上 |

#### 14.1.2 承認ゲートの強制

`pre-deploy-approval-check.sh` フックがデプロイ前に以下を検証する。

- 提案承認・要件承認・デザイン承認・公開承認が `approvals.yaml` に記録されている
- 各承認に承認者氏名・承認日・対象成果物が記載されている
- 承認後に成果物が変更されていない(ハッシュ照合・将来拡張)

承認未記録のままデプロイを試みた場合、フックがエラーで停止する。

#### 14.1.3 approvals.yaml スキーマ

```yaml
approvals:
  - id: APV-001
    type: proposal
    requested_at: 2026-04-30
    requested_by: shin@aileap.example
    target_artifact: 00-engagement/proposal-v1.pdf
    approver: client_decision_maker@example.com
    status: approved | pending | rejected
    approved_at: 2026-05-02
    notes: "金額レンジ A 案で確定"
```

### 14.2 議事録・コミュニケーション履歴管理(C-2)

#### 14.2.1 議事録(meetings/)

`/meeting-minutes` スキルで生成する構造化議事録を `00-engagement/meetings/YYYY-MM-DD_<topic>.md` に格納する。

格納すべき要素:
- 参加者
- アジェンダ
- 決定事項(decisions.yaml にも反映)
- アクションアイテム(担当者・期限付き)
- 次回ミーティング予定

#### 14.2.2 メール・チャット履歴(correspondence/)

クライアントとのメール・チャットの重要部分を `00-engagement/correspondence/` に抜粋として保管する。AI エージェントは案件文脈把握のためにこれを参照する。

#### 14.2.3 意思決定ログ(decisions.yaml)

`/decision-log` スキルで構造化記録する。エスカレーションパス付き。

```yaml
decisions:
  - id: DEC-001
    date: 2026-05-02
    title: "技術スタックを Next.js に決定"
    context: "WordPress と比較検討、保守運用体制の観点で Next.js 採用"
    decided_by: studio-director (proposed) → shin (approved)
    impacted_agents: [technology-director, frontend-lead, frontend-engineer]
    related_artifacts:
      - 00-engagement/meetings/2026-05-02_kickoff.md
```

### 14.3 アセット受領管理(C-4)

#### 14.3.1 必要アセットチェックリスト(assets-required.yaml)

`/asset-checklist` で案件タイプ別に生成する。

```yaml
required_assets:
  - id: AST-001
    name: ロゴ(SVG / PNG・透過)
    category: brand
    received: false
    deadline: 2026-05-10
    blocker_for: [03-design]
  - id: AST-002
    name: 既存サイトの GA4 / GSC アクセス権
    category: credentials
    received: false
    deadline: 2026-05-05
    blocker_for: [02-strategy]
```

#### 14.3.2 受領状況可視化

`/asset-status` で未受領アセットをリストアップし、リマインドメール下書きを生成する。`blocker_for` フェーズに到達した時点で未受領の場合、`delivery-director` がフェーズ進行をブロックする。

#### 14.3.3 認証情報の取扱

`projects/{id}/01-discovery/credentials/` は path-scoped rule `secrets.md` の対象とし、コミット禁止・暗号化必須。

---

## 15. 価格戦略・収益モデル — 新規

C-3 対応。詳細は [pricing-strategy.md](pricing-strategy.md) に集約する。本書では要件レベルの方針のみ示す。

### 15.1 必須提案 3 パターン

`commercial-manager` は見積生成時に必ず以下 3 パターンを提示する。

1. **Time & Material(T&M)**: 時間単価 × 工数
2. **Fixed Price**: 固定価格 + 変更注文
3. **Retainer**: 月額保守 + 機能追加枠

### 15.2 ストック収益化の方針

労働集約から脱却するため、以下を方針とする(AILEAP の事業目標に整合)。

- 受注時に Retainer 提案を必須化
- 制作後 3 ヶ月以内に Retainer 移行率の目標を設定
- 自社プロダクト(MeetingAI 等)の継続開発も Retainer 相当として位置づけ

### 15.3 価格レンジ(暫定)

| 案件タイプ | 速度パス | 価格レンジ |
|---|---|---|
| A1. コーポレートサイト | 1 ヶ月 | 50-150 万円 |
| A2. ランディングページ | 2 週間 | 20-50 万円 |
| A3. メディアサイト | 1.5 ヶ月 | 80-200 万円 |
| Retainer(月額保守) | 継続 | 5-30 万円/月 |

詳細・成果報酬・LTV 戦略は [pricing-strategy.md](pricing-strategy.md) を参照。

---

## 16. 多言語対応戦略 — 新規

H-6 / Q5 対応。日英中韓 4 言語を AILEAP の差別化要素として位置づけ、v0.2 で前倒し導入する。

### 16.1 v0.2 での実装範囲

- `localization-specialist`(Tech Stack 横断)を 21 体目として配置
- `/i18n-strategy` スキルを実装
- path-scoped rule `i18n/**` を整備
- 対応技術: next-intl / Astro i18n / WordPress Polylang

### 16.2 対応言語

- 日本語(ja・デフォルト)
- 英語(en)
- 中国語簡体字(zh-CN)
- 韓国語(ko)

### 16.3 v0.2 では実装しないもの

- 全テンプレート 21 個の 4 言語化(v0.3 以降)
- 機械翻訳パイプライン自動化(v0.4 以降)
- 中国語繁体字(zh-TW)対応(v0.4 以降)

### 16.4 案件適用方針

- A1 / A2 / A3 すべての案件で多言語要件をヒアリング段階で確認する
- 多言語不要な国内 SME 案件では `localization-specialist` を呼ばない
- 多言語必要案件では `/i18n-strategy` を Strategy フェーズで必ず実行する

---

## 17. 速度優位性の仕組み(Speed-Critical Path)— 新規

D-H2 対応。AI Native の最大優位である「速度」を要件レベルで保証する。

### 17.1 案件タイプ別標準納期

| 案件タイプ | Engagement → Launch | Post-launch 検証期間 |
|---|---|---|
| A1. コーポレートサイト | 1 ヶ月 | 30 日 |
| A2. ランディングページ | 2 週間 | 30 日 |
| A3. メディアサイト | 1.5 ヶ月 | 30 日 |

### 17.2 速度を支える仕組み

- **テンプレート再利用**: 21 templates を案件起動時に自動適用
- **デザインシステム継承**: 過去案件のデザインシステムを base として継承
- **並列実行戦略**: 複数エージェントが同時並行で成果物を生成
- **AI ドラフト → Shin 承認 → クライアント送付**: 承認サイクルの短縮
- **24 時間以内ドラフト保証**: 修正依頼から 24 時間以内に修正版を提示

### 17.3 速度測定指標

各案件で以下を計測し、`07-post-launch/30day-report.md` に記録する。

- 提案書作成所要時間
- 要件定義書作成所要時間
- デザインシステム作成所要時間
- 修正依頼から修正版提示までの平均時間
- 標準納期内完了率

---

## 18. 並列案件管理の現実的制約 — 新規

F-C2 対応。Claude のコンテキスト制約上、無制限の並列は不可能。

### 18.1 同時アクティブ案件数の上限

**v0.2 段階での上限: 同時 2-3 案件**(現実的な context window 制約から)。

3 案件を超える場合、`studio-director` が新規案件受注を拒否するか、既存案件の保守フェーズ移行を待つ。

### 18.2 案件切替時のセッション分離プロトコル

`studio-director` は案件切替時に以下を実行する。

1. 現在の案件の session-state を `projects/{current-id}/session-state/` に保存
2. context flush(関連エージェントの内部状態をクリア)
3. 切替先案件の session-state を `projects/{target-id}/session-state/` から復元
4. path-scoped rule `projects/{id}/**` の対象 id を切替

### 18.3 案件間のリソース取り合い解決

複数案件が同じエージェント(例: nextjs-specialist)を同時要求した場合、`studio-director` が以下の優先順位で判定する。

1. 公開直前案件(launch ブロッカー)
2. 契約上の納期が近い案件
3. クライアント単価が高い案件
4. 自社プロダクト案件は最低優先

詳細は [agent-coordination-map.md](agent-coordination-map.md) に集約。

---

## 19. v0.2 のスコープ

### 19.1 v0.2 で実装するもの

- 全 21 エージェント(プロンプト本文付き)
- 28 slash commands(SKILL.md 付き)
- 8 hooks(動作する bash スクリプト・WSL2 / Git Bash 動作確認済)
- 10 path-scoped rules
- 21 templates(法務 3 個は弁護士確認ヘッダー強制挿入)
- 案件タイプ A1 / A2 / A3 の team orchestration を完備
- AILEAP 3 組織のハンドオフプロトコル文書化(実装は手動コピー)
- 双方向ハンドオフ(`/escalate-to-strategy` / `/handoff-back-to-production`)
- マルチテナント projects/ ディレクトリ構造(承認・議事録・アセット拡張済)
- 11 文書(本書 + 10 独立ドキュメント)
- AILEAP 自社サイト改修案件で 1 サイクル検証(Phase D)
- gap-analysis-v0.2.md(Phase E)

### 19.2 v0.2 では実装しないもの(v0.3 以降)

- A4 / B 系 / C 系の team orchestration コマンド
- apex / WMAO との自動ハンドオフ(v0.2 は手動でファイルコピー)
- Slack 等への通知連携
- 案件並列管理ダッシュボード
- 受注後の請求・売上管理(別組織で扱うべき)
- 全テンプレートの 4 言語化
- v0.3 / v0.4 で追加予定のエージェント全件
- PowerShell 版 hooks(v0.4 以降)
- API 仕様書テンプレート(B 系案件投入の v0.3 以降)

---

## 20. 品質ゲート(Quality Gates)

各フェーズ移行時に `/gate-check` で以下を検証する。

| Gate | 検証項目 |
|---|---|
| Engagement → Discovery | 契約締結、SOW 合意、決裁者特定、提案承認記録 |
| Discovery → Strategy | 要件定義書承認、ペルソナ確定、KGI/KPI 合意、必要アセット 80% 受領 |
| Strategy → Design | サイトマップ承認、計測設計承認、コンテンツ方針承認 |
| Design → Implementation | デザインシステム承認、全画面デザイン承認、a11y 設計確認 |
| Implementation → QA | 全機能実装完了、ステージング環境動作確認、code-review 通過 |
| QA → Launch | 全 audit パス、Lighthouse スコア閾値クリア、法務ページ存在 + 弁護士確認ヘッダー |
| Launch → Post-launch | DNS/SSL 切替完了、計測動作確認、CMS 教育完了、公開承認記録 |
| Post-launch → Handoff | 30 日経過、初動 SEO/GEO 検証完了、初期コンテンツ 5-10 本完成 |

ゲート失敗時は `delivery-director` が前フェーズへの差戻しを実行する。

---

## 21. 設計思想

Game Studio の MDA / SDT / Flow / Bartle に対し、本組織は以下を採用する。

| 設計思想 | 主な適用案件 | 主な適用フェーズ |
|---|---|---|
| **Jobs-to-be-Done(JTBD)** | 全案件 | Discovery |
| **Double Diamond** | 全案件 | Discovery → Design |
| **Atomic Design** | 制作系全般 | Design → Implementation |
| **Progressive Enhancement** | 全案件 | Implementation |
| **Dual Track Agile** | 開発系(B 系・v0.3 以降) | Discovery → Implementation 並行 |
| **Lean Startup** | SaaS 案件(B1・v0.3 以降) | MVP 全工程 |
| **WCAG 2.2 AA** | 全案件 | 全フェーズ(設計段階で組込) |
| **Core Web Vitals** | 全案件 | Implementation → QA |

v0.2 段階では制作系(A1 / A2 / A3)に該当するもののみ実運用。Dual Track / Lean は v0.3 以降。

---

## 22. 成功指標(Success Metrics)

### 22.1 v0.2 の予測スコア(参考)

[gap-analysis-v0.1.md](gap-analysis-v0.1.md) Section 7 / [v0.2-direction.md](v0.2-direction.md) Section 8 の予測。

| 観点 | v0.1 | v0.2 予測 | 改善幅 |
|---|---|---|---|
| 完備性 | 72 | 88 | +16 |
| 責任分界 | 68 | 87 | +19 |
| 実現可能性 | 75 | 89 | +14 |
| 整合性 | 70 | 91 | +21 |
| 差別化 | 78 | 92 | +14 |
| **総合** | **73** | **89** | **+16** |

### 22.2 内部指標(本組織自体の品質)

| 指標 | 目標値 |
|---|---|
| エージェント定義の整合性 | 全 21 エージェントで domain boundary 明文化 |
| ハンドオフプロトコル整合性 | apex/WMAO とのスキーマ整合 100% |
| テンプレート実用性 | 21 テンプレート全てが実案件で使える状態 |
| Critical 12 件解消率 | 100% |
| High 上位 8 件解消率 | 100% |

### 22.3 外部指標(Phase D 検証案件)

AILEAP 自社サイト(aileap-hazel.vercel.app)改修で 1 サイクル回し、以下を計測する。

| 指標 | 目標値 |
|---|---|
| Engagement → Launch までの所要日数 | A1 標準納期(1 ヶ月)以内 |
| Lighthouse Performance | 90 以上 |
| Lighthouse Accessibility | 95 以上 |
| Lighthouse SEO | 100 |
| WCAG 2.2 AA 準拠率 | 100% |
| 必要だった Shin の手戻り回数 | 5 回以下 |
| 多言語化サンプル(localization-specialist 検証) | 4 言語のうち 1 言語以上で運用 |

---

## 23. 既知のリスクと未解決事項

### 23.1 リスク

| リスク | 影響 | 緩和策 |
|---|---|---|
| 21 エージェントでも肥大化懸念 | プロンプト管理コスト増 | 段階展開戦略で v0.3 / v0.4 への拡張時に振返り |
| 顧客対話の AI 委任への抵抗感 | 受注機会損失 | 重要な顧客対話は Shin が必ず最終承認 |
| 法務責任の所在不明 | 訴訟リスク | 弁護士確認ヘッダー強制挿入 + [legal-escalation-rules.md](legal-escalation-rules.md) |
| 複数案件並列時の context 混線 | 案件取り違え | projects/{id}/** 隔離 + studio-director 状態管理 + 同時 2-3 案件上限 |
| AI 単独で出ない品質(撮影・特殊実装) | 納期遅延 | 外部パートナー網を v0.4 で `partner-coordinator` 経由構築 |
| WSL2 + Git Bash 環境固有の hooks 動作不良 | デプロイ事故 | Phase D で動作検証、PowerShell 版は v0.4 検討 |
| 多言語前倒しによる工数増 | v0.2 完成遅延 | localization-specialist は最小実装、全テンプレ 4 言語化は v0.3 |

### 23.2 未解決事項(v0.2 中に決定する)

- [ ] 段階移行の合格基準の正式確定(Phase D 着手時)
- [ ] WMAO Slack 連携の整合確認(現状: WMAO は Slack-approval-gated 設計)
- [ ] 案件管理 SaaS(Asana/Notion 等)との外部連携方針(v0.3 以降検討)
- [ ] 納品物保管先(Vercel / Cloudflare / 自前 S3)の標準化(Phase D 検証で確定)

### 23.3 v0.1 から確定した事項(再掲)

[v0.2-direction.md](v0.2-direction.md) で確定済の Q1〜Q6:

- Q1: 段階展開戦略 → 採用
- Q2: 自社プロダクト → 対象に含める
- Q3: 動作環境 → Windows 11 + WSL2 プライマリ
- Q4: 法務テンプレート → ひな型 + 弁護士確認ヘッダー強制
- Q5: 多言語対応 → v0.2 で前倒し採用
- Q6: リポジトリ統合 → 別リポジトリ維持

---

## 24. 次アクション

本書承認後、Claude Code は以下を順に進める([v0.2-direction.md](v0.2-direction.md) Section 9 と整合)。

```
Phase A: 文書整備(全 11 文書、日本語、Opus 4.7)
  A1.  requirements-v0.2.md           (本書)
  A2.  architecture.md
  A3.  handoff-protocols.md
  A4.  agent-roster.md
  A5.  agent-coordination-map.md
  A6.  quick-start.md
  A7.  setup-requirements.md
  A8.  pricing-strategy.md
  A9.  geo-implementation-spec.md
  A10. legal-escalation-rules.md
  A11. language-policy.md

Phase B: AI 内部ファイル実装(全英語)
  B1. settings.json                    (Opus 4.7)
  B2. agents 21 体                     (Opus 4.7)
  B3. skills 28 個                     (Opus 4.7)
  B4. hooks 8 個                       (Sonnet 4.6 切替)
  B5. rules 10 個                      (Sonnet 4.6)

Phase C: テンプレート実装(全日本語、法務確認ヘッダー強制)
  C1. templates 21 個                  (Opus 4.7 切替)

Phase D: 検証案件
  D1. AILEAP 自社サイト改修案件で 1 サイクル(Opus 4.7)

Phase E: gap 分析 v0.2(自己批判)
  E1. gap-analysis-v0.2.md             (Opus 4.7)
```

---

## 付録 A. v0.1 → v0.2 差分サマリー

### A.1 構成変更

| 章 | v0.1 | v0.2 | 備考 |
|---|---|---|---|
| 1 | ミッションとスコープ | ミッションとスコープ + 差別化軸 | 1.4 新設 |
| 2 | 3 組織アーキテクチャ | 同左 + 逆ハンドオフ | 双方向化 |
| 3 | 組織構造 | 段階展開戦略(新設) | v0.1 の 3 章を 4 章へ後送 |
| 4 | エージェント・ロスター | 組織構造 | 章構成シフト |
| 5 | Slash Commands | エージェント・ロスター(20+1) | 同 |
| 6-9 | Hooks / Rules / Templates / Dir 構造 | Slash / Hooks / Rules / Templates(28/8/10/21) | カウント明確化 |
| 10-12 | 協調ルール・モデル・ワークフロー | プロジェクトディレクトリ + 協調 | 構造拡張 |
| 13 | v0.1 のスコープ | 案件タイプ別ワークフロー(A1/A2/A3) | 範囲明示 |
| 14- | 品質ゲート以下 | 顧客対応プロセス(新設)/ 価格戦略(新設)/ 多言語(新設)/ 速度(新設)/ 並列制約(新設) | 大幅追加 |
| 19- | 同 | v0.2 のスコープ以降は v0.1 構成踏襲 | 整合 |

### A.2 解消した Critical / High 一覧

#### Critical 12 件(全件解消)

| ID | 内容 | 本書での対応箇所 |
|---|---|---|
| F-C1 | 段階展開戦略 | Section 3 |
| CO-C1 | エージェント数整合 | Section 5 / 0.2 |
| D-C1 | 差別化軸 | Section 1.4 |
| C-1 | クライアント合意形成 | Section 14.1 |
| C-2 | 議事録・コミュニケーション履歴 | Section 14.2 |
| C-3 | 価格戦略 | Section 15 / [pricing-strategy.md](pricing-strategy.md) |
| C-4 | アセット受領管理 | Section 14.3 |
| B-C1 | SEO/GEO 段階別境界 | Section 1.3 / 13.1 / 20 |
| B-C2 | 初期コンテンツ境界 | Section 1.3 / 13.3 |
| B-C3 | 制作系/開発系モード切替 | Section 11.2 |
| F-C2 | 並列案件数の現実的制約 | Section 18 |
| CO-C2 | 案件タイプとチーム編成整合 | Section 6.8 / 13 |

#### High 上位 8 件(全件解消)

| ID | 内容 | 本書での対応箇所 |
|---|---|---|
| H-1 | ユーザーリサーチ強化 | v0.3 で research-lead 投入(Section 5.6) |
| H-2 | 公開後 30 日のデータ分析責任 | Section 1.3 / 13(seo-geo-strategist が暫定担当・v0.3 で data-analyst 投入) |
| H-6 | 多言語対応 | Section 16 / [language-policy.md](language-policy.md) |
| B-H1 | apex 逆ハンドオフ | Section 2.2.2 / [handoff-protocols.md](handoff-protocols.md) |
| B-H2 | WMAO 逆ハンドオフ | 同上 |
| D-H1 | GEO 具体仕様 | [geo-implementation-spec.md](geo-implementation-spec.md) |
| D-H2 | 速度優位性の仕組み | Section 17 |
| F-H1 | 通信フォーマット統一 | Section 14 系全 YAML 統一 / [handoff-protocols.md](handoff-protocols.md) |

### A.3 数値整合(CO-C1 解消)

- エージェント数: **20 + 1 = 21 体**(20 枠 + 多言語 1 体)で統一
- Slash Commands: **28 個**で統一
- Hooks: **8 個**で統一
- Path-scoped Rules: **10 個**で統一
- Templates: **21 個**で統一
- 文書: **11 個**(本書 + 10 独立ドキュメント)で統一

---

## 付録 B. 用語集

- **Engagement**: 1 案件の総称
- **Discovery**: 課題・要件・ユーザーを掘る初期フェーズ
- **Practice**: 職能単位の部門
- **Discipline**: 個別職能(UX、Frontend 等)
- **SOW**: Statement of Work(作業範囲記述書)
- **GEO**: Generative Engine Optimization(LLM 引用最適化)
- **Core Web Vitals**: Google が定める Web 性能指標(LCP/INP/CLS)
- **WCAG**: Web Content Accessibility Guidelines
- **JTBD**: Jobs to be Done
- **Dual Track**: Discovery と Delivery を並行する開発手法
- **Retainer**: 月額固定の継続契約(保守 + 機能追加枠)
- **T&M**: Time & Material(時間単価 × 工数)
- **Speed-Critical Path**: 速度優位性を支える仕組み(Section 17)
- **Mode switching**: 制作モード/開発モードのエージェント振る舞い切替
- **Approval gate**: 承認ゲート(承認記録なしにデプロイ不可)

---

**本書は v0.2 要件定義の正本である。実装は本書 + 10 独立ドキュメントを単一情報源として進めること。**
