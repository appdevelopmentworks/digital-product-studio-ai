# エージェント協調マップ

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 11 / [architecture.md](architecture.md) Section 3-7 の詳細マップ
**関連**: [agent-roster.md](agent-roster.md)(エージェント名簿)

---

## 0. 本書の目的

本書は v0.2 段階の 21 体エージェントの:

1. **委譲経路**(Vertical Delegation の具体ライン)
2. **横相談ライン**(Horizontal Consultation の典型パターン)
3. **エスカレーション経路**(Conflict Resolution の上位裁定者)
4. **フェーズゲート責任者**(Phase Gate Enforcement の各フェーズ担当)
5. **Practice 間衝突解決マトリクス**(具体的な衝突パターンと裁定者)

を一覧化し、運用時にエージェントが「次に誰に相談すべきか」「どの判断を誰がすべきか」を即時参照可能にする。

---

## 1. 委譲経路マップ

### 1.1 全体図

```
                        ┌─────────────────┐
                        │ studio-director │
                        └────────┬────────┘
                                 │
         ┌──────────────┬────────┼────────┬──────────────┐
         ▼              ▼        ▼        ▼              ▼
┌────────────────┐┌──────────┐┌──────┐┌──────────┐┌────────────────┐
│strategy-       ││creative- ││tech- ││product-  ││delivery-       │
│director        ││director  ││nology││director  ││director        │
└───┬────────────┘└────┬─────┘└──┬───┘└────┬─────┘└────┬───────────┘
    │                  │         │         │           │
    │ ┌────────────┐   │ ┌────┐  │ ┌────┐  │           │ ┌────────────┐
    ├─▶ux-strategy │   ├─▶art-│  ├─▶fe- │  └─(待機)    ├─▶client-     │
    │ │lead        │   │ │dir │  │ │lead│              │ │success-    │
    │ └────────────┘   │ └────┘  │ └────┘              │ │lead        │
    │ ┌────────────┐   │ ┌────┐  │ ┌────┐              │ └────────────┘
    ├─▶content-    │   │ │ui- │  │ │be- │              │ ┌────────────┐
    │ │strategy-   │   │ │des │  │ │lead│ (v0.3)       │ │commercial- │
    │ │lead        │   │ └────┘  │ └────┘              │ │manager     │
    │ └────────────┘   │ ┌────┐  │ ┌────────┐          │ └────────────┘
    │ ┌────────────┐   │ │copy│  │ │fe-eng  │          │
    └─▶seo-geo-    │   │ │wri │  │ └────────┘          │
      │strategist  │   │ │ter │  │ ┌────────┐          │
      └────────────┘   │ └────┘  │ │cms-eng │          │
                       │         │ └────────┘          │
                       │         │ ┌──────────────┐    │
                       │         │ │ Tech Stack   │    │
                       │         │ │ Specialists  │    │
                       │         │ │ (動的呼出)   │    │
                       │         │ └──────────────┘    │
```

### 1.2 委譲経路の正規ライン

| 委譲元 | 委譲先 | 主な委譲内容 |
|---|---|---|
| studio-director | 全 Tier 1 Director | 案件全体方針、Practice 間優先度 |
| strategy-director | ux-strategy-lead | UX 戦略の Lead レベル判断 |
| strategy-director | content-strategy-lead | コンテンツ戦略の Lead レベル判断 |
| strategy-director | seo-geo-strategist | SEO/GEO 戦略の Specialist レベル判断 |
| creative-director | art-direction-lead | デザインシステム承認権限の一部 |
| creative-director | ui-designer | (Lead 経由が原則・例外的に直接) |
| creative-director | copywriter | (Lead 経由が原則・例外的に直接) |
| technology-director | frontend-lead | フロント実装統括権限 |
| technology-director | backend-lead | (v0.2 では待機・v0.3 以降本格) |
| technology-director | nextjs/wordpress/localization-specialist | Stack 選定後の Stack 内判断 |
| product-director | (v0.2 配下なし) | 自社プロダクト案件のみ自身が動く |
| delivery-director | client-success-lead | 顧客対応の Lead レベル判断 |
| delivery-director | commercial-manager | 価格・契約の Specialist レベル判断 |
| ux-strategy-lead | (Tier 3 配下なし・直接 specialist 依頼は不可) | content-strategy-lead と並列で Specialist 群と協業 |
| content-strategy-lead | copywriter(Creative 配下だが横断連携) | コピー方針の落とし込み |
| art-direction-lead | ui-designer | コンポーネントデザインの実行指示 |
| frontend-lead | frontend-engineer | コンポーネント実装の実行指示 |
| frontend-lead | cms-engineer | CMS 統合実装の実行指示 |

### 1.3 委譲できないライン(禁止事項)

- ❌ Tier 3 → Tier 2(逆方向)
- ❌ Tier 2 → Tier 1(逆方向)
- ❌ 異 Practice の Lead → 別 Practice の Specialist に直接命令
- ❌ Tech Stack Specialist → 他のエージェントへの命令(横断助言のみ)
- ❌ Tier 0(studio-director)が Tier 3 を飛び越して直接命令(原則は Director 経由)

---

## 2. 横相談ライン

### 2.1 同 Practice 内の横相談

| Practice | 横相談ペア | 典型的な相談内容 |
|---|---|---|
| Strategy | ux-strategy-lead ↔ content-strategy-lead | サイトマップとコンテンツ階層の整合 |
| Strategy | content-strategy-lead ↔ seo-geo-strategist | コンテンツ戦略と SEO/GEO 戦略の整合 |
| Creative | art-direction-lead ↔ ui-designer | デザイントークンの適用範囲 |
| Creative | ui-designer ↔ copywriter | コピーレイアウトと余白設計 |
| Engineering | frontend-lead ↔ backend-lead | API インターフェース設計(v0.3 以降本格化) |
| Engineering | frontend-engineer ↔ cms-engineer | コンテンツ取得方法・キャッシュ戦略 |
| Delivery | client-success-lead ↔ commercial-manager | 提案内容と価格レンジの整合 |

### 2.2 異 Practice 間の横相談

最も頻発する 5 パターン:

| 横相談ペア | 典型的な相談内容 | エスカレーション先(衝突時) |
|---|---|---|
| ux-strategy-lead ↔ ui-designer | 情報設計とビジュアル設計の整合 | strategy-director ↔ creative-director |
| copywriter ↔ seo-geo-strategist | コピーの SEO 観点(キーワード密度 vs 自然な日本語) | content-strategy-lead → strategy-director |
| ui-designer ↔ frontend-engineer | デザイン実装可否(アニメ・複雑レイアウト) | creative-director ↔ technology-director |
| commercial-manager ↔ technology-director | 価格と技術選定(WordPress 安価 vs Next.js 品質) | delivery-director ↔ technology-director → studio-director |
| client-success-lead ↔ creative-director | クライアント要望とブランドガイドの整合 | delivery-director ↔ creative-director → studio-director |

### 2.3 横断 Stack Specialist の相談

Tech Stack Specialist は通常、frontend-lead からの動的呼出で参加する。横相談は以下のパターン。

| 相談ペア | 典型的な相談内容 |
|---|---|
| nextjs-specialist ↔ frontend-engineer | App Router vs Pages Router の選定 |
| wordpress-specialist ↔ cms-engineer | テーマ vs カスタム実装の境界 |
| localization-specialist ↔ copywriter | 翻訳ワークフローの設計 |
| localization-specialist ↔ seo-geo-strategist | hreflang 設定・多言語 SEO 戦略 |

---

## 3. エスカレーション経路

### 3.1 標準エスカレーションフロー

```
Specialist 衝突発生
    ↓
[1] 同 Practice 内 Lead が裁定
    ↓ (解決しない)
[2] 同 Practice の Director が裁定
    ↓ (異 Practice 間衝突なら)
[3] 関係する 2 名の Director の合議
    ↓ (合議も決まらない)
[4] studio-director が最終裁定
    ↓ (重大判断は)
[5] Shin に escalate(Collaborative-Not-Autonomous 原則)
```

### 3.2 エスカレーションのトリガー

以下の場合に上位裁定者へエスカレーションする:

- 横相談で 1 ターン以内に合意できない
- 衝突する判断のいずれかが path-scoped rule に抵触する
- 衝突する判断のいずれかが Lighthouse / WCAG 閾値を割る可能性
- 衝突する判断のいずれかが SOW / approvals.yaml の合意に矛盾する
- 案件の納期 / 予算に -10% 以上の影響

### 3.3 Shin へのエスカレーションが必須なケース

studio-director でも自動判断せず、必ず Shin に escalate するケース:

- スコープ外への踏み込み(SOW を変更する判断)
- 法務テンプレ確認ヘッダーの省略要望
- 弁護士確認が必要な判断
- クライアントへの返金・契約解除の判断
- ハンドオフの起動(`/handoff-from-strategy` 受領、`/escalate-to-strategy` / `/handoff-to-marketing` / `/handoff-back-to-production`)
- 並列案件の上限超過時の優先度判定
- AILEAP 自社プロダクト案件の中長期方針判断

---

## 4. フェーズゲート責任者

[requirements-v0.2.md](requirements-v0.2.md) Section 20 に定義された 8 フェーズゲートの責任者を一覧化する。**全フェーズゲートは delivery-director が gate-check を実行する**が、各ゲートで主に検証する観点別の主担当エージェントを記載する。

### 4.1 フェーズゲート一覧

| Gate | 主担当(検証観点) | 補助担当 |
|---|---|---|
| Engagement → Discovery | delivery-director(契約・SOW)、client-success-lead(承認記録) | commercial-manager |
| Discovery → Strategy | ux-strategy-lead(要件定義)、client-success-lead(アセット受領) | strategy-director |
| Strategy → Design | strategy-director(サイトマップ・計測・コンテンツ方針承認) | ux-strategy-lead、content-strategy-lead |
| Design → Implementation | creative-director(デザインシステム・全画面承認)、art-direction-lead(a11y) | ui-designer、frontend-lead |
| Implementation → QA | technology-director(全機能実装完了)、frontend-lead(code-review) | frontend-engineer |
| QA → Launch | seo-geo-strategist(audit パス)、(担当)(Lighthouse 閾値)、(担当)(法務ページ + 弁護士確認ヘッダー) | technology-director |
| Launch → Post-launch | delivery-director(DNS/SSL/計測動作)、client-success-lead(CMS 教育) | (cms-trainer は v0.4) |
| Post-launch → Handoff | seo-geo-strategist(30 日経過 + 初動検証)、content-strategy-lead(初期コンテンツ 5-10 本) | delivery-director |

### 4.2 ゲート失敗時の差戻しフロー

ゲート失敗時、delivery-director は以下を実行する:

1. ゲート失敗理由を `decisions.yaml` に記録
2. 失敗観点に対応する Practice Director に差戻し通知
3. 該当 Practice が修正完了するまで次フェーズへの進行をブロック
4. 修正完了後、再度 gate-check を実行
5. 連続 2 回失敗した場合は studio-director / Shin に escalate

---

## 5. Practice 間衝突解決マトリクス

[architecture.md](architecture.md) Section 5 で代表 4 例を示したが、本書では具体的な衝突パターンを網羅的に列挙する。

### 5.1 Strategy ↔ Creative の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| サイトマップ階層 vs ビジュアル階層が不整合 | strategy-director ↔ creative-director | studio-director | KGI / KPI 整合 |
| コピー長さ vs デザイン余白 | content-strategy-lead ↔ ui-designer | strategy-director ↔ creative-director | クライアント承認済デザインを優先 |
| SEO キーワード密度 vs 読みやすさ | seo-geo-strategist vs copywriter | content-strategy-lead | 自然な日本語を優先(GEO 観点でも自然文有利) |

### 5.2 Strategy ↔ Engineering の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| 構造化データ実装範囲(全ページ vs 主要のみ) | seo-geo-strategist vs frontend-lead | strategy-director ↔ technology-director | GEO 重要度 + 工数バランス |
| llms.txt 配置の必須性 | seo-geo-strategist | technology-director | [geo-implementation-spec.md](geo-implementation-spec.md) 必須項目 |
| 多言語実装方式(next-intl vs 静的生成) | localization-specialist vs frontend-lead | technology-director | 案件規模・SEO 整合 |

### 5.3 Creative ↔ Engineering の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| ヒーローアニメーション実装(性能影響) | art-direction-lead ↔ frontend-lead | creative-director ↔ technology-director → studio-director | Lighthouse Performance 90 維持 + Reduce Motion 対応 |
| カスタムフォント採用(LCP 影響) | art-direction-lead ↔ frontend-lead | creative-director ↔ technology-director | LCP 2.5s 維持 |
| デザインシステムのコンポーネント分割粒度 | ui-designer ↔ frontend-engineer | art-direction-lead ↔ frontend-lead | Atomic Design 整合 |
| 画像形式(WebP/AVIF vs PNG/JPG) | ui-designer ↔ frontend-engineer | art-direction-lead ↔ frontend-lead | path-scoped rule `images.md` 強制 |

### 5.4 Delivery ↔ 全 Practice の衝突

Delivery は契約・予算・スケジュールの観点で他 Practice の判断に介入する権限を持つ。

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| 標準納期超過リスク vs 品質追求 | delivery-director ↔ 該当 Director | studio-director | 速度パス([requirements-v0.2.md](requirements-v0.2.md) Section 17) |
| クライアント要望追加 vs スコープ堅持 | client-success-lead → commercial-manager → delivery-director | studio-director → Shin | SOW + 変更注文プロセス |
| 価格レンジ vs 提案内容(過剰品質) | commercial-manager ↔ technology-director | delivery-director ↔ technology-director | [pricing-strategy.md](pricing-strategy.md) レンジ |
| クライアントから AI 出力への質問 | client-success-lead が「人間翻訳」 | delivery-director、必要なら該当 Director | クライアント理解可能性優先 |

### 5.5 Tech Stack Specialist 関連の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| Stack 選定(Next.js vs WordPress vs Astro) | technology-director(自身) | studio-director | 案件タイプ・予算・運用体制 |
| Next.js のレンダリング戦略(SSG vs SSR vs ISR) | nextjs-specialist ↔ frontend-engineer | frontend-lead → technology-director | パフォーマンス予算 + 更新頻度 |
| WordPress プラグイン採用可否 | wordpress-specialist | technology-director | セキュリティ + 保守性 |
| 多言語実装の最小構成 vs フル構成 | localization-specialist | technology-director | [language-policy.md](language-policy.md) Section X |

---

## 6. 案件タイプ別の協調パターン

### 6.1 A1: コーポレートサイト(`/team-corporate-site`)

#### 動員エージェント(主役順)

```
[Engagement]
  studio-director(受領・案件 ID 採番)
  delivery-director(プロジェクト初期化・gate-check)
  client-success-lead(ヒアリング)
  ux-strategy-lead(要件定義)
  commercial-manager(見積)

[Discovery → Strategy]
  ux-strategy-lead(サイトマップ・ペルソナ)
  content-strategy-lead(競合分析・コンテンツ戦略)
  seo-geo-strategist(SEO/GEO 戦略)

[Design]
  art-direction-lead(デザインシステム主導)
  ui-designer(画面デザイン)
  copywriter(コピー)

[Implementation]
  frontend-lead(統括)
  frontend-engineer(実装)
  cms-engineer(WordPress 採用時)
  nextjs-specialist or wordpress-specialist(動的呼出)
  localization-specialist(多言語要件時のみ)

[QA → Launch]
  seo-geo-strategist(audit)
  delivery-director(gate-check)

[Post-launch → Handoff]
  seo-geo-strategist(30 日検証)
  delivery-director、client-success-lead(納品)
```

#### 主な協調ライン

- ux-strategy-lead → art-direction-lead(サイトマップを受けてデザインシステム)
- content-strategy-lead → copywriter(コンテンツ戦略を受けてコピー)
- seo-geo-strategist ↔ copywriter ↔ frontend-engineer(キーワード・コピー・メタタグ整合)
- art-direction-lead ↔ frontend-lead(デザイン実装協議)

### 6.2 A2: ランディングページ(`/team-landing-page`)

#### 動員エージェント(LP 特化で動員数削減)

```
[Engagement]
  delivery-director、client-success-lead、commercial-manager

[Strategy]
  strategy-director(LP 戦略・コンバージョン設計)
  copywriter(主役・LP コピーが命)

[Design]
  art-direction-lead、ui-designer

[Implementation]
  frontend-engineer
  nextjs-specialist(動的呼出・LP は Next.js が主流)

[QA]
  seo-geo-strategist(audit・基本のみ)

[Launch → Post-launch]
  delivery-director、seo-geo-strategist
```

#### A1 との違い

- ux-strategy-lead は不要(LP はサイトマップ単純)
- cms-engineer は不要(LP は静的)
- copywriter が主役(LP の成否はコピー次第)

### 6.3 A3: メディアサイト(`/team-mediasite`)

#### 動員エージェント(コンテンツ + CMS 重視)

```
[Engagement]
  delivery-director、client-success-lead、commercial-manager

[Strategy]
  ux-strategy-lead(カテゴリ階層設計)
  content-strategy-lead(主役・コンテンツが命)
  seo-geo-strategist(主役・流入が命)

[Design]
  art-direction-lead、ui-designer

[Implementation]
  cms-engineer(主役・CMS が命)
  frontend-engineer
  wordpress-specialist or (v0.3 以降の)headless-cms-specialist

[Content]
  copywriter(初期コンテンツ 5-10 本制作・B-C2 対応)
  content-strategy-lead(コンテンツ品質監修)

[QA → Launch → Post-launch → Handoff]
  seo-geo-strategist(30 日検証で流入を測定)
  delivery-director、client-success-lead
```

#### A1 との違い

- content-strategy-lead と seo-geo-strategist が主役
- 初期コンテンツ 5-10 本制作フェーズが追加
- WMAO ハンドオフ時に「コンテンツカレンダー」が必須

---

## 7. 並列案件管理の協調

### 7.1 並列時のエージェント割当

複数案件が並列で走る場合、studio-director が以下を管理する。

| 案件状態 | 割当エージェント例 |
|---|---|
| 案件 A: Implementation 中 | frontend-engineer、cms-engineer、nextjs-specialist |
| 案件 B: Strategy 中 | strategy-director、ux-strategy-lead、content-strategy-lead |
| 案件 C: Engagement 中 | client-success-lead、commercial-manager |

理想的には案件ごとにフェーズが異なれば干渉が少ない。

### 7.2 同一エージェントが複数案件で必要な場合

studio-director の優先順位判定([requirements-v0.2.md](requirements-v0.2.md) Section 18.3):

1. 公開直前案件(launch ブロッカー)
2. 契約上の納期が近い案件
3. クライアント単価が高い案件
4. 自社プロダクト案件は最低優先

衝突時は studio-director が `decisions.yaml` に「○○ specialist は案件 A を優先」と記録する。

### 7.3 案件切替時のプロトコル

```
[切替直前]
  studio-director:
    1. 現在案件 A の session-state を保存
    2. 関連エージェントに「案件 A は一時停止」を通知
    3. context flush

[切替時]
  studio-director:
    4. 案件 B の session-state を復元
    5. 関連エージェントに「案件 B 再開」を通知
    6. path-scoped rule の対象 ID を切替

[切替後]
  Shin に「案件 B に切替完了」を報告
```

---

## 8. ハンドオフ時の協調

[handoff-protocols.md](handoff-protocols.md) で詳述したプロトコル別の主担当:

### 8.1 `/handoff-from-strategy`(apex → 本組織)

- **受領主担当**: studio-director
- **案件 ID 採番**: delivery-director(studio-director の監督下)
- **初動アクション**:
  - delivery-director: ディレクトリ生成、ハンドオフ YAML 保存
  - client-success-lead: 初回ヒアリング準備
  - strategy-director: 案件タイプ判定支援
  - technology-director: 技術スタック推奨

### 8.2 `/escalate-to-strategy`(本組織 → apex)

- **起動主担当**: studio-director
- **必要承認**: Shin
- **準備担当**:
  - delivery-director: YAML 生成
  - client-success-lead: クライアント説明メールドラフト
  - strategy-director: エスカレーション理由の戦略的整理

### 8.3 `/handoff-to-marketing`(本組織 → WMAO)

- **起動主担当**: delivery-director
- **必要承認**: Shin
- **準備担当**:
  - seo-geo-strategist: 30 日レポート完成
  - content-strategy-lead: 初期コンテンツ 5-10 本完成確認
  - commercial-manager: 保守 SLA 整理
  - cms-engineer: CMS 認証情報パッケージング
  - delivery-director: 全成果物のパッケージング

### 8.4 `/handoff-back-to-production`(WMAO → 本組織)

- **受領主担当**: studio-director
- **案件 ID 採番**: delivery-director(元案件と紐付け)
- **初動アクション**:
  - strategy-director: WMAO 知見の戦略への統合
  - technology-director: 既存サイト構造の評価
  - commercial-manager: 改修案件としての見積

---

## 9. 緊急対応(Incident Response)

v0.2 段階では `incident-response` プロトコルは正式実装しないが、本番障害発生時の暫定対応フローを以下に定義する(B-M4 暫定対応)。

### 9.1 障害発生時の連絡経路

```
障害検知(Lighthouse 閾値割れ / 公開直後の表示崩れ等)
  ↓
delivery-director が studio-director に通知
  ↓
studio-director が Shin に通知
  ↓
Shin の指示で対応エージェントを動員
  ↓
緊急修正後、change-order を遡及記録
```

### 9.2 緊急時の権限委譲

緊急時のみ、以下の通常ルールが暫定的に変更される(障害収束後に通常ルールに戻る):

- studio-director が Tier 3 を直接動員可能(通常は Tier 1 経由)
- frontend-engineer が承認なしに本番修正可能(承認は事後記録)
- commercial-manager の事前見積なしで作業着手可能

緊急対応の本格プロトコル化は v0.4 で `launch-conductor` 投入時に実施。

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では requirements 内の Section 10 のみ。v0.2 で独立文書化、衝突解決マトリクス・フェーズゲート責任者・並列管理協調を新設。 |
| 0.3 | 2026-05-01 | Phase G 完了。下記 §11 v0.3 拡張を追加(B 系協調パターン・新規エージェント間の衝突解決マトリクス・スプリント協調)。 |

---

## 11. v0.3 拡張: B 系プロダクト開発体制の協調

[agent-roster.md §7](agent-roster.md#7-v03-で実装済の追加エージェント-2026-05-01-確定--phase-g) で追加された 5 体(product-director フル稼働 + product-manager + backend-engineer + devops-engineer + qa-engineer)の協調パターンを本セクションで確定する。

### 11.1 B 系プロジェクトの委譲経路

```
                              ┌─────────────────┐
                              │ studio-director │
                              └────────┬────────┘
                                       │
       ┌──────────────┬────────────────┼────────────────┬──────────────┐
       ▼              ▼                ▼                ▼              ▼
┌──────────────┐┌──────────┐  ┌─────────────┐  ┌──────────┐  ┌──────────────┐
│strategy-     ││creative- │  │technology-  │  │product-  │  │delivery-     │
│director      ││director  │  │director     │  │director ★│  │director      │
└──────────────┘└──────────┘  └─┬───────────┘  └────┬─────┘  └──────────────┘
                                │                    │
                                ▼                    ▼
                       ┌────────────────┐   ┌─────────────────┐
                       │ backend-lead ★ │   │ product-manager │
                       │ (direct: 3 体) │   │ ★ 新規(Tier 2)│
                       └─┬──────────────┘   └─────────────────┘
                         │
       ┌─────────────────┼─────────────────┐
       ▼                 ▼                 ▼
┌──────────────┐┌────────────────┐┌──────────────┐
│backend-      ││devops-         ││qa-           │
│engineer ★   ││engineer ★     ││engineer ★   │
│ (新規 Tier 3)││ (新規 Tier 3)  ││ (新規 Tier 3)│
└──────────────┘└────────────────┘└──────────────┘
```

★ = v0.3 で追加 / 拡張されたエージェント

### 11.2 B 系プロジェクトの委譲ライン(追記)

| 委譲元 | 委譲先 | 主な委譲内容 |
|---|---|---|
| product-director | product-manager | スプリント運営の day-to-day 委譲 |
| product-director | (cross-consult) backend-lead | アーキテクチャ実現可能性の確認 |
| product-manager | (cross-consult) backend-lead | スプリント容量サイン |
| backend-lead | backend-engineer | API / DB / 認証実装の指示 |
| backend-lead | devops-engineer | CI/CD / インフラ構築の指示 |
| backend-lead | qa-engineer | テスト戦略 / 品質ゲートの指示 |

### 11.3 B 系で頻発する横相談ペア(追加)

| 横相談ペア | 典型的な相談内容 | エスカレーション先(衝突時) |
|---|---|---|
| product-manager ↔ backend-lead | スプリント容量と実装容量のすり合わせ | product-director ↔ technology-director |
| product-director ↔ technology-director | アーキテクチャと roadmap の整合 | studio-director |
| backend-engineer ↔ frontend-engineer | API contract handshake(zod 型共有) | backend-lead ↔ frontend-lead |
| backend-engineer ↔ devops-engineer | env vars / secrets / deploy config | backend-lead |
| backend-engineer ↔ qa-engineer | test fixtures / 統合テストの粒度 | backend-lead |
| devops-engineer ↔ qa-engineer | CI 並列化 / E2E test 環境 | backend-lead |
| qa-engineer ↔ frontend-engineer | UI E2E selectors / `data-testid` strategy | frontend-lead ↔ backend-lead(横並び権限) |
| qa-engineer ↔ seo-geo-strategist | a11y(qa-engineer)と SEO/GEO(seo-geo-strategist)の audit 重複回避 | technology-director |

### 11.4 B 系プロジェクトの追加衝突パターン

#### 11.4.1 Product ↔ Engineering の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| ロードマップの優先順位 vs 技術的負債(リファクタ) | product-director ↔ technology-director | studio-director | PMF 仮説 vs 速度低下リスクのバランス |
| スプリント容量超過(scope creep) | product-manager ↔ backend-lead | product-director ↔ technology-director | velocity ベースの実証データ優先 |
| API バージョニング戦略(/v1 vs 互換性維持) | backend-engineer ↔ backend-lead | technology-director | クライアントへの破壊的変更可否 |
| テストカバレッジ目標(80% vs 60%) | qa-engineer ↔ backend-lead | technology-director | プロジェクト成熟度・ROI |

#### 11.4.2 Product ↔ Delivery の衝突

| 衝突パターン | 一次裁定者 | 最終裁定者 | 判断基準 |
|---|---|---|---|
| PMF gate での pivot 判断 vs 契約スコープ堅持 | product-director ↔ delivery-director | studio-director → Shin | クライアント案件は契約優先 / 自社プロダクトは PMF 優先 |
| 内部プロダクトの roadmap 拡大 vs 外部受注容量 | product-director ↔ delivery-director | studio-director → Shin | AILEAP 事業計画 |

### 11.5 B 系スプリント協調(週次)

```
[Day 1: スプリント計画 / 月曜]
  product-manager:
    1. backlog から候補ストーリー選定
    2. backend-lead に capacity サイン依頼(同期)
    3. backend-engineer / devops-engineer / qa-engineer 各位の容量バランス確認
    4. sprint-NN.md を Write
    5. product-director に「commit」承認依頼(quarter boundary 時のみ)

[Day 5: ミッドスプリントチェック / 金曜]
  product-manager:
    - 進捗確認 → スプリントファイル更新
    - ブロッカーの triage(devops-engineer による env 詰まり等)

[Day 10: スプリントレビュー + 振り返り]
  product-manager + backend-lead + 3 名の Tier 3:
    - 完了 / 未完了の事実記録
    - 次スプリントへの carry-over
    - velocity 計算 → 次スプリントの計画値を更新

[Day 11: 次スプリント計画]
  サイクル繰り返し
```

### 11.6 B 系プロジェクトのフェーズゲート責任者(追加)

| Gate | 主担当(追加) |
|---|---|
| Discovery → Strategy(B 系特殊) | product-director(プロダクト Discovery 完成) |
| Strategy → Sprint 0 | product-director(roadmap 確定) + product-manager(初期 backlog 整備) |
| Sprint N → Sprint N+1 | product-manager(retro 完了) |
| Quarter Boundary | product-director(roadmap 再評価) |
| 公開前 QA Gate | qa-engineer(QA レポート GO 判定) + backend-lead(技術ゲート) |
| Post-launch Week 4 PMF Gate | product-director(PMF レビュー) |

### 11.7 並列案件管理(B 系混在時の優先順位)

studio-director の並列案件優先順位 §7.2 に追記:

| 順位 | 条件 |
|---|---|
| 1 | 公開直前案件(launch ブロッカー) |
| 2 | 契約上の納期が近い案件(A 系・B 系問わず) |
| 3 | クライアント単価が高い案件 |
| 4 | **B 系の PMF gate 直前案件**(週 4 / quarter-end) — 新規 |
| 5 | 自社プロダクト案件は最低優先(B 系内部 / A 系内部いずれも) |

B 系の PMF gate を逃すと意思決定が次サイクルまで遅延するため、4 位の優先度を確保。

---

**本書は v0.3 エージェント協調マップの正本である。エージェント定義ファイル(`.claude/agents/*.md`)は本書の協調ラインと整合していること。B 系プロジェクトでは §11 を起点に、A 系プロジェクトでは §1-10 を起点に参照する。**
