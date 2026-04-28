# digital-product-studio-ai アーキテクチャ設計書

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 4 / 11 の詳細化文書
**読者**: Shin / 本組織を運用する関係者 / AILEAP 内の他組織アーキテクト

---

## 0. 本書の目的

本書は digital-product-studio-ai の組織アーキテクチャを定義する。具体的には:

1. **5 プラクティス制**を採用した理由と運用方針
2. **階層委譲(Vertical Delegation)/ 横相談(Horizontal Consultation)/ 衝突解決(Conflict Resolution)**の具体運用
3. **段階展開ロードマップ**(v0.2 → v0.3 → v0.4)とその設計判断

要件定義は [requirements-v0.2.md](requirements-v0.2.md)、エージェント名簿は [agent-roster.md](agent-roster.md)、衝突解決マトリクス詳細は [agent-coordination-map.md](agent-coordination-map.md) に分散しているため、本書はそれらを統合的に解釈する設計思想層を担う。

---

## 1. アーキテクチャ全体像

### 1.1 4 層 + 横断構造

```
┌──────────────────────────────────────────────────────────────┐
│ Tier 0: Studio Director(統合トップ・Opus・1 体)             │
│   - 5 プラクティス全体の統合判断                             │
│   - apex / WMAO とのハンドオフ管轄                           │
│   - 案件切替時の context flush                              │
└──────────────────────────────────────────────────────────────┘
                              │
        ┌──────────┬──────────┼──────────┬──────────┐
        ▼          ▼          ▼          ▼          ▼
┌──────────┐┌──────────┐┌──────────┐┌──────────┐┌──────────┐
│ Strategy ││ Creative ││Engineerg ││ Product  ││ Delivery │
│ Practice ││ Practice ││ Practice ││ Practice ││ Practice │
│ Director ││ Director ││ Director ││ Director ││ Director │
└──────────┘└──────────┘└──────────┘└──────────┘└──────────┘
   Opus×5                                              ← Tier 1
        │          │          │          │          │
        ▼          ▼          ▼          ▼          ▼
   Discipline Leads(Sonnet×6)                        ← Tier 2
   ux-strategy / content-strategy / art-direction /
   frontend / backend / client-success
        │          │          │          │          │
        ▼          ▼          ▼          ▼          ▼
   Specialists(Sonnet×6)                             ← Tier 3
   ui-designer / copywriter / frontend-engineer /
   cms-engineer / seo-geo-strategist / commercial-manager

────────────────────────────────────────────────────────────
   横断: Tech Stack Specialists(Sonnet×3)
   nextjs / wordpress / localization
────────────────────────────────────────────────────────────
```

合計: **20 + 1 = 21 体**(20 枠 + 多言語横断 1 体)。

### 1.2 v0.2 の階層採用人数

| Tier | 人数 | モデル | 役割 |
|---|---|---|---|
| Tier 0 | 1 | Opus | Studio Director |
| Tier 1 | 5 | Opus | Practice Director |
| Tier 2 | 6 | Sonnet | Discipline Lead |
| Tier 3 | 6 | Sonnet | Specialist |
| 横断 | 3 | Sonnet | Tech Stack Specialist |
| **合計** | **21** | — | — |

### 1.3 階層数の選定根拠

参照モデル(Claude-Code-Game-Studios)は 3 層階層だが、本組織は **Tier 0(Studio Director)を増やして 4 層**とする。理由は以下。

1. **顧客対応の統合判断者が必要**: 制作会社は 5 プラクティスをまたぐ統合判断(価格と品質、速度と完成度)が頻発。Practice Director 同士の合議だけでは決まらない衝突を裁く役割が必須。
2. **3 組織アーキテクチャのハンドオフ管轄が必要**: apex / WMAO とのハンドオフは 1 体の責任者がいる方が整合する(分散させると Practice 間で「自分の担当ではない」と押し付け合う)。
3. **マルチテナント並列案件の context 管理が必要**: 案件切替時の状態管理は、Practice をまたぐ統合視点でないと不可能。

---

## 2. 5 プラクティス制の設計思想

### 2.1 採用理由

参照モデルの Game Studio は暗黙の 7 部門だったが、本組織は明示的に 5 プラクティスとする。理由:

- 業界標準の組織呼称に揃える(Strategy / Creative / Engineering / Product / Delivery は制作会社・開発会社双方で通じる)
- 顧客側の発注担当者が「○○の担当者を出して」と指名しやすい
- AILEAP の他組織(apex / WMAO)とプラクティス命名規則を整合させやすい

### 2.2 各 Practice の責任領域とミッション

#### Strategy Practice

**ミッション**: クライアントの事業目的をデジタル戦略に翻訳し、サイト構造・コンテンツ方針・SEO/GEO 戦略を設計する。

**責任領域**:
- チャネル戦略(なぜ Web か、どの構造で)
- UX 戦略(誰のための情報設計か)
- コンテンツ戦略(何をどの順で語るか)
- SEO/GEO 戦略(検索流入と LLM 引用最適化)

**範囲外**:
- 経営戦略・事業戦略 → apex
- 公開後 31 日以降の継続 SEO 改善 → WMAO

**v0.2 の構成**:
- Director: strategy-director(Opus)
- Lead: ux-strategy-lead(Sonnet)/ content-strategy-lead(Sonnet)
- Specialist: seo-geo-strategist(Sonnet)

#### Creative Practice

**ミッション**: ブランド表現を視覚化し、デザインシステム + UI + コピーで一貫した世界観を構築する。

**責任領域**:
- ビジュアルデザイン
- デザインシステム
- コピーライティング
- ブランド表現の統一

**範囲外**:
- モーション・撮影実作業(モーションは v0.3 以降、撮影は外部パートナー)
- 法務文言の作成(弁護士の領域)

**v0.2 の構成**:
- Director: creative-director(Opus)
- Lead: art-direction-lead(Sonnet)
- Specialist: ui-designer(Sonnet)/ copywriter(Sonnet)

#### Engineering Practice

**ミッション**: 設計を技術実装に翻訳し、性能・保守性・セキュリティを担保する。

**責任領域**:
- フロントエンド実装
- バックエンド実装(B 系・v0.3 以降は本格活用)
- CMS 構築
- 技術スタック選定

**範囲外**:
- インフラ運用の継続(v0.3 以降に platform-lead が担当)
- セキュリティ監査(v0.4 以降に security-engineer が担当)

**v0.2 の構成**:
- Director: technology-director(Opus)
- Lead: frontend-lead(Sonnet)/ backend-lead(Sonnet)
- Specialist: frontend-engineer(Sonnet)/ cms-engineer(Sonnet)
- Tech Stack 横断: nextjs-specialist / wordpress-specialist / localization-specialist

#### Product Practice

**ミッション**: 開発系案件(SaaS / 業務システム / AI プロダクト)におけるプロダクト戦略と PMF 判断を担う。

**責任領域**:
- プロダクトロードマップ
- ユーザーリサーチ(v0.3 以降本格化)
- PMF 判断
- 自社プロダクト(MeetingAI 等)の中長期戦略

**範囲外**:
- 制作系案件(A 系)では Director のみ関与、配下は呼ばない
- マーケティング戦略 → WMAO

**v0.2 の構成**:
- Director: product-director(Opus)のみ
- Lead / Specialist: v0.3 以降に research-lead, user-researcher, data-analyst を投入

**v0.2 段階の運用**: Product Practice は director のみ。A 系案件では呼び出されないか、必要時に strategy-director と連携してアドバイスのみ提供する。

#### Delivery Practice

**ミッション**: 顧客との接点・契約・スケジュール・納品を一手に担い、AI エージェントとクライアントの「翻訳機」となる。

**責任領域**:
- 顧客対応(ヒアリング・承認・進捗報告)
- 契約・見積・SOW・変更注文
- スケジュール管理
- 公開遂行
- 納品パッケージング
- 全フェーズの gate-check

**範囲外**:
- 法的判断(弁護士の領域)
- 撮影実作業(外部パートナー)

**v0.2 の構成**:
- Director: delivery-director(Opus)
- Lead: client-success-lead(Sonnet)
- Specialist: commercial-manager(Sonnet)

**特殊な権限**: Delivery Practice は唯一**顧客と直接対話する権限**を持つ。他 Practice の Specialist が顧客と直接やり取りすることは禁止される(Client-touching boundary 原則・Section 4.5 参照)。

### 2.3 Practice 間の関係性

```
       Strategy ←──────→ Creative
          ↕                  ↕
        Product          Engineering
          ↕                  ↕
       (v0.3+)        (Tech Stack 横断)
                ↘ ↙
              Delivery(全 Practice の出力を顧客に向けて統合)
```

- Strategy ↔ Creative: コンテンツとデザインの整合(seo-geo-strategist と copywriter の対話など)
- Creative ↔ Engineering: デザインと実装の整合(ui-designer と frontend-engineer の対話など)
- Strategy ↔ Engineering: 技術選定と戦略の整合(技術スタックが SEO/GEO 要件を満たすか)
- Product ↔ Engineering: 開発系案件における PMF と技術実装の整合(v0.3 以降)
- Delivery ↔ 全 Practice: クライアント要望の翻訳と納品物の品質ゲート

---

## 3. 階層委譲(Vertical Delegation)の運用

### 3.1 基本原則

**Directors → Leads → Specialists の方向のみ命令可。**

逆方向の命令(Specialist が Lead に指示する等)は禁止。Specialist が Lead の判断に異議を持つ場合は、**横相談 → エスカレーション**の経路をたどる(Section 4 / 5 参照)。

### 3.2 委譲できるタスクの種類

| 委譲元 | 委譲先 | 委譲できるタスク例 |
|---|---|---|
| Tier 0 → Tier 1 | studio-director → 各 Practice Director | Practice 横断の方針判断要請、案件全体の優先度指示 |
| Tier 1 → Tier 2 | strategy-director → ux-strategy-lead | UX 領域の Lead レベル判断委譲(サイトマップ承認等) |
| Tier 1 → Tier 3(直接) | technology-director → seo-geo-strategist | Lead 不在のため直接(seo-geo-strategist は Strategy Practice 配下だが Lead 経由でも直接でも可) |
| Tier 2 → Tier 3 | frontend-lead → frontend-engineer | 個別コンポーネント実装の指示 |

### 3.3 委譲の粒度

- **戦略レベル(Director)**: 「この案件はメディアサイトとして構築」「Next.js を採用」等の方針判断
- **戦術レベル(Lead)**: 「サイトマップは 3 層構造」「コンポーネントは Atomic Design」等の構造判断
- **戦闘レベル(Specialist)**: 「このコピーをこの文言に」「このコンポーネントをこう実装」等の実行判断

### 3.4 委譲の文書化

すべての委譲は以下のいずれかで記録される:

- **decisions.yaml**: 戦略レベルの委譲(後から参照可能にする)
- **meetings/**: ミーティング議事録の中での委譲指示
- **Slash command 起動ログ**: `/team-corporate-site` 等の起動時にどのエージェントが動員されたか
- **session-state**: 案件単位のエージェント割り当て状態

---

## 4. 横相談(Horizontal Consultation)の運用

### 4.1 基本原則

**同層は相談可だが拘束力ある決定は不可。**

横相談で意見が割れた場合、共通の親エージェントへエスカレーションする(Section 5)。

### 4.2 横相談の典型パターン

#### パターン 1: 同 Practice 内の Lead 同士

例: ux-strategy-lead と content-strategy-lead が「コンテンツ階層をどう設計するか」で相談

→ 合意できれば そのまま設計に反映。割れたら strategy-director にエスカレーション。

#### パターン 2: 異 Practice の Lead 同士

例: art-direction-lead と frontend-lead が「コンポーネント分割粒度」で相談

→ 合意できれば そのまま実装。割れたら creative-director ↔ technology-director の合議、最終的に studio-director。

#### パターン 3: 異 Practice の Specialist 同士

例: ui-designer と frontend-engineer が「アニメーション実装可否」で相談

→ 合意できればそのまま。割れたら art-direction-lead と frontend-lead に持ち上げ、さらに割れたら creative-director / technology-director に持ち上げ。

### 4.3 横相談の文書化

横相談は議事録にまとめなくてよい(意思決定そのものではないため)。ただし以下の場合は decisions.yaml に記録する:

- 横相談の結果として**合意点が決定事項になった**場合
- 横相談で**衝突が発生し上位エスカレーションした**場合

---

## 5. 衝突解決(Conflict Resolution)の運用

### 5.1 エスカレーションの基本経路

```
Specialist 衝突
  ↓ 同 Practice 内の Lead が裁定
  ↓ 解決しなければ Practice Director が裁定
  ↓ 異 Practice 間の衝突なら 2 人の Director の合議
  ↓ 合議も決まらなければ Studio Director が最終裁定
```

### 5.2 衝突解決マトリクス(代表例)

詳細は [agent-coordination-map.md](agent-coordination-map.md) に集約する。本書では代表 4 例。

| 衝突パターン | 一次裁定者 | 最終裁定者 |
|---|---|---|
| frontend-engineer vs ui-designer(実装可否) | art-direction-lead ↔ frontend-lead | creative-director ↔ technology-director → studio-director |
| copywriter vs seo-geo-strategist(コピーと SEO の優先度) | content-strategy-lead | strategy-director |
| commercial-manager vs technology-director(価格 vs 品質) | delivery-director ↔ technology-director | studio-director |
| クライアント要望 vs デザインシステム整合 | client-success-lead → creative-director | studio-director |

### 5.3 衝突解決の決定要因

衝突時に裁定者が判断する基準は以下の優先順位:

1. **クライアント合意事項**: SOW / 議事録 / decisions.yaml に記録された合意
2. **法的制約・倫理的制約**: 法務 / プライバシー / アクセシビリティ
3. **プロジェクトの KGI/KPI**: 案件の目的に最も寄与する選択肢
4. **品質基準**: WCAG 2.2 AA / Lighthouse 閾値 / Core Web Vitals
5. **納期・予算**: 標準納期内・見積範囲内
6. **AILEAP の差別化軸**: [requirements-v0.2.md](requirements-v0.2.md) Section 1.4 の 8 軸

### 5.4 衝突解決の文書化

衝突解決の結果は必ず **decisions.yaml** に記録する。

```yaml
decisions:
  - id: DEC-005
    date: 2026-05-15
    title: "ヒーローセクションのアニメーション実装可否"
    context: "ui-designer はパララックス強推奨、frontend-engineer は性能影響を懸念"
    escalated_to: creative-director ↔ technology-director
    final_decision_by: studio-director
    decision: "Lighthouse Performance 90 を保てる範囲で実装、Reduce Motion 設定者には無効化"
    rationale: "差別化軸の速度と a11y を両立"
```

---

## 6. 担当範囲(Domain Boundaries)の運用

### 6.1 基本原則

**担当外のファイルは触らない。**

例:
- ui-designer は `src/components/**` の見た目は提案するが、ロジックは frontend-engineer に委譲
- copywriter は `content/**` のコピーは書くが、セマンティック HTML 構造は frontend-engineer に委譲
- commercial-manager は `00-engagement/**` の契約系は触るが、技術成果物には触らない

### 6.2 path-scoped rules による強制

[requirements-v0.2.md](requirements-v0.2.md) Section 8 の path-scoped rules は、エージェントごとに「触れるパス」と「触れないパス」を間接的に定義している。

- `src/components/**` → frontend-engineer / ui-designer(提案のみ)
- `app/**` / `pages/**` → frontend-engineer / seo-geo-strategist(メタ・構造化データ)
- `content/**` → copywriter / content-strategy-lead
- `design/**` → art-direction-lead / ui-designer
- `public/images/**` → ui-designer / frontend-engineer(最適化)
- `src/api/**` → frontend-engineer(v0.2 段階・将来的に backend-engineer)
- `docs/legal/**` → 弁護士確認必須(AI は提案のみ)
- `projects/{id}/**` → 該当案件にアサインされたエージェントのみ
- `.env, secrets/**` → コミット禁止
- `i18n/**` → localization-specialist + copywriter

### 6.3 担当範囲を超えた振る舞いの検出

session-stop.sh フックで「どのエージェントがどのパスを編集したか」をログ記録し、担当範囲外の編集が検出された場合に Shin に通知する(v0.3 で本格実装、v0.2 は基本ログのみ)。

---

## 7. Web 制作・開発特有の協調原則

参照モデルの 4 原則(Vertical Delegation / Horizontal Consultation / Conflict Resolution / Domain Boundaries)に加え、本組織は以下 5 原則を追加する。

### 7.1 Client-touching Boundary(顧客接触境界)

**顧客と直接対話するエージェントは Delivery Practice 配下のみ。**

- ✅ 許可: client-success-lead / commercial-manager / delivery-director / studio-director
- ❌ 禁止: ui-designer / frontend-engineer / copywriter / その他全 Specialist

理由:
- AI 判断の「人間翻訳」が必要(クライアントは AI 専門用語を理解しない)
- 営業上のトーン管理が必要
- 法的責任の所在を明確化

### 7.2 Phase Gate Enforcement(フェーズゲート強制)

**delivery-director の `/gate-check` 通過なしに次フェーズへ進めない。**

各フェーズゲートの検証項目は [requirements-v0.2.md](requirements-v0.2.md) Section 20 に定義。ゲート失敗時は前フェーズへ差戻し。

### 7.3 Change Propagation(変更伝播)

**スコープ変更は必ず `commercial-manager` が `/change-order` で記録。**

口頭での変更合意は禁止。すべての変更は文書化され、追加見積が発生する場合は事前承認を得る。

### 7.4 Mode Switching(モード切替・新設・B-C3 対応)

**エージェントは「制作モード」「開発モード」を案件タイプから自動判定して振る舞いを切替。**

| モード | 適用案件 | エージェントの振る舞い変化 |
|---|---|---|
| 制作モード | A 系(コーポレート / LP / メディア) | デザイン再現精度・LP 最適化・コピー品質を優先 |
| 開発モード | B 系(SaaS / 業務システム)・v0.3 以降 | 状態管理・性能チューニング・テスト網羅性を優先 |
| ハイブリッドモード | C 系(EC / プラットフォーム)・v0.4 以降 | 両モードを案件内のフェーズで切替 |

`/team-*` コマンド起動時に自動でモードが切替わる。各エージェントプロンプトには両モードの振る舞いが記述される。

### 7.5 Approval Gate(承認ゲート・新設・C-1 対応)

**デザイン承認・公開承認が `approvals.yaml` に記録されない限りデプロイ不可。**

`pre-deploy-approval-check.sh` フックがデプロイ前に検証する。承認未記録のデプロイ試行はフックがブロックする。

---

## 8. 段階展開ロードマップ

### 8.1 段階展開の設計判断

#### なぜ v0.1 の 38 体ではなく v0.2 の 21 体か

[gap-analysis-v0.1.md](gap-analysis-v0.1.md) F-C1 で指摘されたとおり、apex が 12 体・WMAO が 10 体で運用している中で digital-product-studio-ai だけが 38 体を抱えると、プロンプト管理コストが apex+WMAO 合算より重くなる。実案件で検証していない 38 体定義は「机上の空論」になりやすい。

段階展開によって:
- **v0.2 の 21 体は実案件で検証可能な規模**
- **v0.3 で追加する具体的な役割が明確化される**(検証で見えた不足を補う)
- **v0.4 の 38+ 体は段階的に整合性が確保される**

#### v0.2 で 21 体を選んだ判断

20 + 1 体(20 枠 + 多言語横断 1 体)の構成根拠:

- **Tier 0(1 体)**: 必須(統合判断者がいないと衝突解決が回らない)
- **Tier 1(5 体)**: 全 Practice Director を揃える(Practice の柱を最初から立てる)
- **Tier 2(6 体)**: 主要 Lead のみ(motion-design / qa / research / platform は v0.3 以降)
- **Tier 3(6 体)**: A 系案件で動員する Critical Specialist のみ(backend / devops / security 等は v0.3 / v0.4)
- **Tech Stack(3 体)**: A 系案件で必須の nextjs / wordpress + Q5 前倒しの localization

### 8.2 v0.2 → v0.3 への移行判断基準

v0.3 着手は以下の条件を満たした場合のみ。

1. v0.2 で AILEAP 自社サイト改修案件を 1 サイクル完走
2. [v0.2-direction.md](v0.2-direction.md) Section 11 の Definition of Done を全件達成
3. gap-analysis-v0.2.md で総合スコア 85 以上
4. v0.3 で投入する案件タイプ(A4 / B1 / C3)の最低 1 件の受注見込みがある

### 8.3 v0.3 で追加するエージェント(計画)

```
Tier 2 追加(3 体):
  research-lead          (Product Practice)
  motion-design-lead     (Creative Practice)
  qa-lead                (Engineering Practice)

Tier 3 追加(5 体):
  backend-engineer       (Engineering Practice)
  devops-engineer        (Engineering Practice)
  user-researcher        (Product Practice)
  data-analyst           (Product Practice)
  accessibility-specialist (Engineering Practice)

Tech Stack 追加(3 体):
  saas-stack-specialist  (B 系案件用)
  headless-cms-specialist
  astro-specialist
```

合計: 21 + 11 = **32 体**(v0.3 想定値)

対応案件タイプ追加:
- A4. リブランド改修
- B1. SaaS MVP
- C3. リニューアル + 機能拡張

新規 Slash Commands(想定):
- /team-saas-mvp
- /team-corporate-renewal
- /team-saas-renewal
- /user-interview-script
- /usability-test-plan
- /research-synthesis
- /retrospective
- /tech-stack-recommendation(本格化)

### 8.4 v0.4 で追加するエージェント(計画)

```
Tier 1 追加可能性:
  platform-lead          (Engineering Practice 専門化)

Tier 3 追加(8 体):
  security-engineer      (Engineering Practice)
  performance-engineer   (Engineering Practice)
  migration-engineer     (Delivery Practice)
  asset-coordinator      (Delivery Practice)
  approval-tracker       (Delivery Practice)
  launch-conductor       (Delivery Practice)
  cms-trainer            (Delivery Practice)
  partner-coordinator    (Delivery Practice・外部パートナー連携)

Tech Stack 追加:
  ai-integration-specialist
  shopify-specialist など
```

対応案件タイプ追加:
- B2. SaaS スケール
- B3. 社内業務システム
- B4. AI 機能搭載プロダクト
- C1. EC 構築
- C2. プラットフォーム + ブランドサイト

### 8.5 ロードマップ全体像

```
2026 Q2-Q3:  v0.2 リリース(21 体・A 系 3 タイプ対応)
2026 Q3-Q4:  v0.2 で AILEAP 自社サイト改修・SME 案件 1-2 件回す
2026 Q4-Q1:  v0.3 リリース(32 体・A4 / B1 / C3 追加)
2027 Q1-Q2:  v0.3 で SaaS MVP 案件 1 件回す
2027 Q2-Q3:  v0.4 リリース(38+ 体・全案件タイプ対応)
```

実際のリリースタイミングは案件受注状況に応じて調整。

---

## 9. マルチテナント設計の詳細

### 9.1 設計原則

参照モデルの Game Studio は単一作品集中前提だが、本組織は **複数案件並列** が前提。ただし context 制約上、**同時アクティブは 2-3 案件**(F-C2 対応)。

### 9.2 案件分離の仕組み

#### ファイルシステムレベル

- 各案件は `projects/{client-name}_{project-id}/` で完全隔離
- path-scoped rule `projects/{id}/**` で「他の案件を参照しない」を強制
- session-state は案件ごとに分離

#### エージェントレベル

- studio-director が現在アクティブな案件 ID を保持
- 案件切替時に **context flush** を実行(関連エージェントの内部状態クリア)
- ハンドオフ・横相談は同一案件内のみ許可

#### Slash Command レベル

- すべての Slash Command は案件 ID を引数として受け取る
- 案件 ID 未指定時は studio-director が現在アクティブな案件 ID を補完
- 異なる案件にまたがる操作(例: 別案件のデザインシステム参照)は明示的な許可が必要

### 9.3 並列案件のリソース調整

複数案件が同じエージェント(例: nextjs-specialist)を同時要求した場合、studio-director が以下優先順位で判定:

1. 公開直前案件(launch ブロッカー)
2. 契約上の納期が近い案件
3. クライアント単価が高い案件
4. 自社プロダクト案件は最低優先

### 9.4 案件アーカイブ戦略

- 公開後 90 日経過 + WMAO ハンドオフ完了案件は `projects/_archive/` へ移動
- アーカイブ後はサイズ最適化(画像・大容量ファイルは外部ストレージへ参照化)
- アーカイブ案件への参照は studio-director の明示許可が必要

---

## 10. AILEAP 3 組織内での位置づけ

### 10.1 組織関係性

```
apex-consulting-ai           上流: 戦略・経営
  ├ MBB readiness モデル
  ├ 12 エージェント
  └ digital-product-studio-ai に「Web プロダクトが必要」と判断したらハンドオフ
        ↓
digital-product-studio-ai    中流: 制作・開発(本書)
  ├ 21 エージェント(v0.2)
  └ web-marketing-ai-org に「公開後 30 日経過」を経てハンドオフ
        ↓
web-marketing-ai-org (WMAO)  下流: マーケ・運用・成長
  ├ 10 エージェント
  └ 必要なら digital-product-studio-ai に「サイト改修必要」と判断したら逆ハンドオフ
```

### 10.2 各組織の特徴比較

| 観点 | apex | digital-product-studio-ai | WMAO |
|---|---|---|---|
| 規模 | 12 体 | 21 体(v0.2)→ 38+ 体(v0.4) | 10 体 |
| 階層 | 3 層 | 4 層 | 3 層 |
| Practice 数 | 4 | 5 | 3-4 |
| 顧客接触 | 直接(MBB style) | 直接(Delivery Practice) | Slack-approval-gated |
| 主要成果物 | 戦略レポート | サイト・アプリ・ドキュメント | 運用レポート・改善提案 |
| KPI | 戦略採用率 | 公開・納品 | 流入・CV・LTV |

### 10.3 ハンドオフの責任分界(再掲・[handoff-protocols.md](handoff-protocols.md) で詳述)

| 組織間 | プロトコル | 起動条件 |
|---|---|---|
| apex → 本組織 | `/handoff-from-strategy` | 経営戦略上 Web プロダクトが必要と判断 |
| 本組織 → apex | `/escalate-to-strategy` | 「Web で解決すべきでない経営課題」と判断 |
| 本組織 → WMAO | `/handoff-to-marketing` | 公開後 30 日経過 + 初動検証完了 |
| WMAO → 本組織 | `/handoff-back-to-production` | サイト構造改修・大規模リニューアルが必要と判断 |

---

## 11. 設計判断の記録(Architecture Decision Records 相当)

本書執筆時点で記録すべき主要な設計判断:

### ADR-001: 4 層階層の採用(Tier 0 を追加)

- **判断**: Game Studio の 3 層に Tier 0 を追加
- **理由**: 顧客対応の統合判断・3 組織アーキテクチャのハンドオフ管轄・マルチテナント context 管理
- **代替案**: 3 層維持(Practice Director 合議制)
- **却下理由**: 衝突解決と context 管理の責任が分散すると現実的に回らない

### ADR-002: 5 プラクティス制(暗黙の 7 部門ではなく)

- **判断**: Strategy / Creative / Engineering / Product / Delivery の 5 プラクティス
- **理由**: 業界標準呼称・顧客側からの指名容易性・AILEAP 他組織との整合
- **代替案**: 7 部門細分化 / 3 部門統合
- **却下理由**: 7 部門は管理過多、3 部門は責任分界不明瞭

### ADR-003: 段階展開戦略(38 体一括ではなく 21 体から)

- **判断**: v0.2 = 21 体、v0.3 = 32 体、v0.4 = 38+ 体
- **理由**: 検証可能な規模で開始、実案件で必要性を確認しながら拡張
- **代替案**: 38 体一括展開
- **却下理由**: apex / WMAO の運用規模(12 / 10)から逆算して非現実的

### ADR-004: 多言語対応の v0.2 前倒し

- **判断**: localization-specialist を v0.4 ではなく v0.2 に投入
- **理由**: Shin の多言語スキル(日英中韓)を AILEAP の差別化軸として要件化(Q5)
- **代替案**: v0.4 まで延期
- **却下理由**: 海外 SME 開拓の入り口を要件レベルで保証する必要

### ADR-005: 法務テンプレートの作成 + 弁護士確認ヘッダー強制

- **判断**: v0.2 でひな型を作成、ただし弁護士確認ヘッダーを強制挿入
- **理由**: 受注時に提示できる雛形は必要、ただし AI が法的助言を行ったと誤解されない仕組みが必須
- **代替案**: v0.2 で作成しない
- **却下理由**: 受注機会損失

### ADR-006: 別リポジトリ維持(3 組織統合せず)

- **判断**: apex / digital-product-studio-ai / WMAO は別リポジトリで運用
- **理由**: 名前空間の独立・既存の運用慣れ・性能(統合すると Claude Code の動作が遅くなる)
- **代替案**: 1 リポジトリに統合
- **却下理由**: 統合のメリット(整合性確保)よりデメリット(肥大化・性能低下)が大きい

---

## 12. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版(本書)。v0.1 では存在せず、v0.2 で新設。 |

---

**本書は v0.2 アーキテクチャの正本である。実装判断時は本書の設計思想と整合しているかを確認すること。詳細は [agent-roster.md](agent-roster.md) / [agent-coordination-map.md](agent-coordination-map.md) を併読する。**
