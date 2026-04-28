# 価格戦略・収益モデル

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [requirements-v0.2.md](requirements-v0.2.md) Section 15 / [gap-analysis-v0.1.md](gap-analysis-v0.1.md) C-3 対応の独立文書
**対象**: digital-product-studio-ai の価格設計・収益モデル
**重要**: 本書は AILEAP 内部資料。クライアントには直接共有しない(該当部分は提案書・見積で抽出)

---

## 0. 本書の目的

[gap-analysis-v0.1.md](gap-analysis-v0.1.md) C-3 で指摘された「価格戦略・収益モデルが要件レベルに入っていない」問題を解消する。

具体的に本書は以下を定義する:

1. 案件タイプ別の単価レンジ
2. 3 パターン提案(T&M / Fixed Price / Retainer)の標準フォーマット
3. リテイナー(月額保守)の設計指針
4. 成果報酬の発動条件
5. LTV(Lifetime Value)戦略
6. 自社プロダクト案件の内部見積方針

`commercial-manager` エージェントは本書を必須参照として、`/estimate` および `/retainer-design` の生成に反映する。

---

## 1. 価格戦略の基本思想

### 1.1 労働集約からの脱却

AILEAP の事業目標(野心的な年間売上目標)を達成するには、digital-product-studio-ai が「制作」だけで売っていると労働集約に陥る。具体的な脱却方針:

- **すべての受注時に Retainer 提案を必須化**
- **制作後 3 ヶ月以内に Retainer 移行率 50% 以上を目標**
- **自社プロダクト(MeetingAI 等)の継続開発も Retainer 相当として位置づけ**
- **成果報酬型の補助的活用**(全案件には適用しない)

### 1.2 AI Native 制作会社としての価格優位

[requirements-v0.2.md](requirements-v0.2.md) Section 1.4 の差別化軸より:

| 軸 | 従来制作会社 | digital-product-studio-ai |
|---|---|---|
| 速度 | 提案書 1 週間 | 提案書 1 営業日 |
| 価格 | デザイン+実装 100-300 万 | 同等品質 50-150 万 |

「同等品質を半額」を訴求軸とする。価格を下げる手段は AI による工数削減であり、品質を下げてはいけない。

### 1.3 価格を下げない方針

以下の領域は価格圧縮しない:

- アクセシビリティ(WCAG 2.2 AA)
- パフォーマンス(Lighthouse 90+)
- 法務テンプレート(弁護士確認込で標準化)
- セキュリティ(CMS 採用時)

これらは AILEAP の品質シグナルなので、安価訴求に巻き込まない。

---

## 2. 案件タイプ別の単価レンジ

### 2.1 v0.2 対応案件タイプ

| 案件タイプ | 標準納期 | Fixed Price レンジ | T&M 単価レンジ | Retainer レンジ |
|---|---|---|---|---|
| A1. コーポレートサイト | 1 ヶ月 | 50-150 万円 | 1 万円/h × 100-200h | 5-15 万円/月 |
| A2. ランディングページ | 2 週間 | 20-50 万円 | 1 万円/h × 40-80h | 3-8 万円/月 |
| A3. メディアサイト | 1.5 ヶ月 | 80-200 万円 | 1 万円/h × 120-250h | 8-30 万円/月 |

(※ すべて税抜・予算規模の目安)

### 2.2 v0.3 / v0.4 対応案件タイプ(参考)

| 案件タイプ | 標準納期 | Fixed Price レンジ | Retainer レンジ |
|---|---|---|---|
| A4. リブランド改修 | 1.5 ヶ月 | 100-300 万円 | 10-30 万円/月 |
| B1. SaaS MVP | 3 ヶ月 | 300-800 万円 | 30-100 万円/月 |
| B2. SaaS スケール | 6 ヶ月+ | 800-2000 万円+ | 100-300 万円/月 |
| C1. EC 構築 | 2 ヶ月 | 150-500 万円 | 15-50 万円/月 |

### 2.3 単価決定の主要因子

| 因子 | 価格への影響 | 例 |
|---|---|---|
| ページ数 | +/- 20% | 5 ページ vs 30 ページ |
| デザイン難易度 | +/- 30% | テンプレベース vs フルカスタム |
| 多言語要件 | +20-50% | 1 言語追加で +20% |
| アニメーション | +10-30% | 静的 vs パララックス・GSAP |
| CMS カスタマイズ | +20-50% | 標準テーマ vs ACF 多用 |
| API 連携 | +30-100% | なし vs 複数外部 API |
| 撮影・特殊素材 | パススルー(外注実費) | 撮影・モデル撮影 |
| クライアント決裁スピード | -10% / +20% | 1 名決裁 vs 多段承認 |
| 既存システム制約 | +0-30% | なし vs レガシー連携必須 |

### 2.4 単価レンジを下回る案件への対応

提示レンジを下回る予算しか出ない案件は以下の選択肢:

1. **スコープを削減**(ページ数・機能を絞る)
2. **テンプレベースに移行**(フルカスタムをやめる)
3. **Fixed Price → T&M に切替**(段階的予算消化で受注)
4. **Retainer 込で受注**(初期コストを月額に分散)
5. **受注辞退**(品質確保が困難な場合)

選択肢 1-4 は studio-director / delivery-director / commercial-manager の合議で判断、選択肢 5 は studio-director → Shin の最終承認。

---

## 3. 3 パターン提案の標準フォーマット

### 3.1 必須提案(`/estimate` で必ず生成)

`commercial-manager` は見積生成時に必ず以下 3 パターンを提示する。1 パターンのみの提案は禁止。

#### パターン A: Fixed Price(固定価格 + 変更注文)

```
案件タイプ: A1. コーポレートサイト
ページ数: 10 ページ
デザイン: フルカスタム
多言語: なし

  Fixed Price: 980,000 円(税抜)
    内訳:
      - 戦略・要件定義: 150,000
      - デザイン: 350,000
      - 実装: 350,000
      - QA・公開: 130,000

  変更注文:
    - スコープ追加 1 ページにつき: 50,000-100,000
    - 多言語追加(1 言語): +200,000
    - 撮影手配(別途実費)

  納期: 契約締結から 1 ヶ月

  含まれるもの:
    - WCAG 2.2 AA 準拠
    - Lighthouse Performance 90+ 保証
    - 構造化データ・llms.txt 標準装備
    - 公開後 30 日の初動 SEO/GEO 検証

  含まれないもの:
    - 公開 31 日以降の継続運用 → Retainer 別途
    - 商用フォントライセンス費(クライアント負担)
    - 写真・動画素材費(別途実費)
```

#### パターン B: Time & Material(時間単価 × 工数)

```
T&M 単価: 10,000 円/h(税抜)

  推定工数: 100-200 時間
  推定総額: 1,000,000-2,000,000 円

  月次リミット: 80 時間まで(超過は事前承認)

  進行方式:
    - 2 週間ごとに進捗報告 + 工数報告
    - 月末締め、翌月末払い
    - SOW で目標機能を定義、完了したら次フェーズ

  メリット:
    - スコープ変更に柔軟
    - 仕様が固まらない領域に向く
    - クライアントが進捗を細かく確認可能

  デメリット:
    - 総額が読みづらい
    - クライアントの工数管理負担
```

#### パターン C: Retainer(月額保守 + 機能追加枠)

```
Retainer: 80,000 円/月(税抜)

  月次内訳:
    - 監視・バグ対応: 月 5h まで
    - コンテンツ更新: 月 5h まで
    - 機能追加・改善: 月 5h まで
    - SEO/GEO 改善: 月 3h まで(WMAO 連携前提)
    - 月次レポート発行

  超過分:
    - 単価 12,000 円/h(Retainer 単価より高い)

  契約期間:
    - 最低 6 ヶ月、以降 1 ヶ月単位で更新

  メリット:
    - 公開後の保守を確保
    - 機能追加を月内に消化
    - 関係継続で次案件の受注確率向上(LTV)

  初期構築費:
    - Fixed Price と組合せ可能
    - 例: 初期構築 980,000 + Retainer 80,000/月
```

### 3.2 提案順序の推奨

提案書(`/proposal-deck`)では以下の順序で提示する:

```
1. パターン C: Retainer(月額保守 + 機能追加)  ← 推奨枠として最初
2. パターン A: Fixed Price(固定価格)
3. パターン B: T&M(時間単価)
```

理由: 心理的アンカリングで Retainer に誘導し、LTV を最大化。

### 3.3 自社プロダクト案件の特殊扱い

AILEAP 自社プロダクト(MeetingAI / 自社サイト等)の場合:

- 外部請求書は発行しない
- 内部見積として工数のみ記録
- `commercial-manager` のプロンプトに `internal_client: true` を渡すと内部見積モード
- 工数は AILEAP の事業計画と照合して妥当性検証

---

## 4. Retainer(月額保守)の設計指針

### 4.1 Retainer の種類

| 種類 | 月額目安 | 含まれる作業 | 対象案件 |
|---|---|---|---|
| **Light** | 5-10 万円 | 監視・軽微更新のみ | A2(LP)・小規模 A1 |
| **Standard** | 10-20 万円 | 監視 + コンテンツ更新 + 軽微機能追加 | 標準的な A1・A3 |
| **Pro** | 20-50 万円 | 上記 + SEO/GEO 改善連携 + 月次戦略レビュー | 大規模 A1・A3、自社プロダクト |
| **Enterprise** | 50 万円+ | 上記 + 専属チーム稼働 + SLA 保証 | B 系(v0.3 以降) |

### 4.2 Retainer に含めない作業

以下は Retainer 内では実施せず、別途見積:

- 大規模リブランド改修(A4 案件として再受注)
- サイト全体のリニューアル
- 新機能追加で 20 時間超過する案件
- 撮影・動画制作の手配
- WMAO の領域(継続コンテンツ制作・広告運用・SNS 運用)

### 4.3 Retainer の更新条件

- 最低契約期間 6 ヶ月
- 6 ヶ月後は 1 ヶ月単位で更新
- 解約は 1 ヶ月前通知
- 月次レビューで「次月の工数枠調整」を相互合意

### 4.4 Retainer 提案を強制するルール

`commercial-manager` のプロンプトに以下を記述する(英語):

```
Mandatory: ALWAYS present a Retainer option in /estimate.
Even if the client states "we don't need maintenance",
present a "Light" tier (5-10万円/月) as a starting point.

Reasons:
- LTV maximization (AILEAP business goal)
- Quality maintenance (sites without maintenance degrade)
- Relationship continuity (next project win-back)
```

---

## 5. 成果報酬の発動条件

### 5.1 成果報酬の位置づけ

成果報酬は補助的に活用する。全案件には適用せず、以下の条件を満たす場合のみ。

### 5.2 発動条件

成果報酬を提案できるケース:

- KGI/KPI が明確で測定可能
- 測定の責任分界が明示できる(本組織 / WMAO / クライアント側の貢献を切り分け可能)
- クライアントが成果連動に積極的
- ベース料金 + 成果ボーナスの 2 階建が許容される

### 5.3 成果報酬の金額構造

```
ベース価格: Fixed Price レンジの 70-80%
成果ボーナス: ベース価格の 20-50%(KPI 達成時)

例:
  ベース: 700,000 円(本来 980,000 の 70%)
  成果ボーナス:
    - 公開後 6 ヶ月で月間問い合わせ 30 件達成: +200,000
    - 公開後 6 ヶ月でオーガニック流入 1,000 UU 達成: +100,000
  
  最大総額: 1,000,000 円(本来 980,000 を上回る可能性)
```

### 5.4 成果報酬を採用しないケース

- 短期 LP 案件(2 週間で完了するため成果測定期間が取れない)
- スコープが小規模(計算コスト > 期待リターン)
- WMAO の運用が未確定(成果は WMAO の貢献度合いに依存)
- クライアント側の運用体制が不明(成果がクライアント側要因で出ない場合の責任分界が困難)

### 5.5 成果報酬契約の YAML

`projects/{id}/00-engagement/performance-bonus.yaml` で記録:

```yaml
performance_bonus:
  base_price: 700000
  measurement_period: 6_months
  measurement_start: 2026-09-01
  measurement_end: 2027-02-28
  metrics:
    - id: PB-001
      kpi: 月間問い合わせ件数
      target: 30
      measurement_source: GA4 / お問合せフォーム
      bonus_amount: 200000
    - id: PB-002
      kpi: オーガニック流入(月間 UU)
      target: 1000
      measurement_source: GA4
      bonus_amount: 100000
  measurement_responsibility:
    digital-product-studio-ai: 公開時のサイト品質・初動 30 日のチューニング
    web-marketing-ai-org: 31 日以降の継続運用
    client: コンテンツ供給・予算執行
  payment_terms:
    - 達成時に翌月末払い
    - 部分達成は按分計算
```

---

## 6. LTV(Lifetime Value)戦略

### 6.1 LTV 最大化の構造

```
初回受注  →  納品  →  Retainer  →  追加案件  →  紹介
  ↓        ↓        ↓            ↓            ↓
50-150万  品質確保  5-30万/月    50-300万/件  別案件創出
                                              
1 顧客の累計売上目標(3 年): 500-1500 万円
```

### 6.2 LTV を伸ばす施策

| 施策 | 担当 |
|---|---|
| Retainer 移行率向上 | commercial-manager |
| 月次レポートで関係継続 | client-success-lead(WMAO 連携前) |
| 追加案件の早期検知 | client-success-lead |
| クライアント間紹介 | delivery-director、studio-director |
| 成果事例の `/proposal-deck` 反映 | content-strategy-lead、commercial-manager |

### 6.3 LTV 測定指標

| 指標 | 目標値(v0.2 段階) |
|---|---|
| 受注時の Retainer 同時提案率 | 100% |
| 公開後 3 ヶ月の Retainer 移行率 | 50% 以上 |
| Retainer 継続率(12 ヶ月) | 70% 以上 |
| 既存顧客からの追加案件率(24 ヶ月) | 30% 以上 |
| クライアントからの紹介発生率 | 20% 以上 |

---

## 7. 単価ガイドライン

### 7.1 工数単価(T&M)

| 役割 | 単価レンジ |
|---|---|
| 戦略・コンサル系(strategy-director / delivery-director の人間判断時間) | 15,000-30,000 円/h |
| デザイン系(art-direction-lead / ui-designer の判断時間) | 10,000-15,000 円/h |
| 実装系(frontend-engineer / cms-engineer の作業時間) | 8,000-12,000 円/h |
| プロジェクトマネジメント | 10,000-15,000 円/h |
| 標準ブレンド単価(混合) | 10,000 円/h |

「AI が自動生成する時間」と「Shin が判断・レビューする時間」を分けて計上する。クライアントには標準ブレンド単価で提示。

### 7.2 工数見積(案件タイプ別の参考値)

#### A1. コーポレートサイト(10 ページ・標準)

| フェーズ | 工数 | 内訳 |
|---|---|---|
| Engagement | 10-15h | ヒアリング・要件定義・見積 |
| Discovery | 15-25h | 競合分析・ペルソナ・サイトマップ |
| Strategy | 10-20h | コンテンツ戦略・SEO/GEO 戦略 |
| Design | 30-50h | デザインシステム・全画面デザイン |
| Implementation | 40-60h | 実装・CMS 構築 |
| QA | 5-15h | audit 群 |
| Launch | 5-10h | 公開・移行 |
| Post-launch | 5-15h | 30 日検証 |
| Handoff | 5-10h | パッケージング・WMAO 引継ぎ |
| **合計** | **125-220h** | — |

#### A2. ランディングページ(1 LP・標準)

| フェーズ | 工数 |
|---|---|
| Engagement | 5-10h |
| Strategy + Design | 15-25h(統合) |
| Implementation | 15-25h |
| QA + Launch | 5-15h |
| Post-launch | 5-10h |
| **合計** | **45-85h** |

#### A3. メディアサイト(中規模・初期コンテンツ 7 本)

| フェーズ | 工数 |
|---|---|
| Engagement | 10-15h |
| Discovery | 15-25h |
| Strategy(コンテンツ戦略・カテゴリ設計) | 25-35h |
| Design | 30-40h |
| Implementation(CMS 構築) | 40-60h |
| Content(初期 7 本制作) | 25-40h |
| QA | 10-15h |
| Launch | 5-10h |
| Post-launch | 10-20h |
| Handoff | 10-15h |
| **合計** | **180-275h** |

---

## 8. 価格交渉のフレームワーク

### 8.1 交渉時の選択肢提示

クライアントが提示価格を高いと感じた場合、`commercial-manager` は以下の順で対応:

1. **スコープ削減提案**: ページ数 / 機能を削って予算内に収める
2. **テンプレベース提案**: フルカスタムからテンプレ起点に変更
3. **Fixed → T&M 変更**: 段階的予算消化に切替
4. **Retainer での分散**: 初期費用を Retainer に部分組込
5. **品質ライン明示 + 受注辞退**: 「この価格では品質保証できない」と明示

選択肢 5 は studio-director / Shin の承認必須。

### 8.2 値引きを避ける表現

❌ 「○○ 円まで値引きします」
✅ 「○○ 円の予算枠であれば、スコープを XX に調整したパターンで対応可能です」

### 8.3 値引き上限

- Fixed Price レンジの下限から **-10% まで**(品質保証可能ライン)
- それ以下は受注辞退または Retainer 込で吸収

---

## 9. 通信フォーマット(YAML)

### 9.1 estimate.yaml スキーマ

`projects/{id}/00-engagement/estimate.yaml`:

```yaml
estimate_id: EST-20260501-001
project:
  id: <project-id>
  client: <name>
  type: A1
  scope_summary: <1 文>
created_by: commercial-manager
created_at: 2026-05-01
shin_approval: pending | approved | revised
patterns:
  fixed_price:
    total: 980000
    breakdown:
      strategy: 150000
      design: 350000
      implementation: 350000
      qa_launch: 130000
    timeline: 30_days
    change_order_unit_prices:
      additional_page: 50000-100000
      multilingual: 200000
  time_and_material:
    blended_rate: 10000
    estimated_hours_min: 100
    estimated_hours_max: 200
    monthly_cap: 80
  retainer:
    tier: standard
    monthly_fee: 80000
    minimum_period_months: 6
    included_hours: 18  # 18h/月
    overage_rate: 12000
performance_bonus:
  proposed: false  # この案件では提案しない
notes: |
  クライアント決裁スピード短縮要望あり、
  Retainer Standard を推奨枠として提示。
```

### 9.2 retainer-design.yaml スキーマ

`/retainer-design` で生成:

```yaml
retainer_id: RTN-20260901-001
project:
  id: <project-id>
  base_project_id: <original project>
tier: standard
monthly_fee: 80000
included_services:
  - monitoring: 5h
  - content_update: 5h
  - feature_addition: 5h
  - seo_geo_improvement: 3h
  - monthly_report: included
overage_rate: 12000
contract:
  start_date: 2026-09-01
  minimum_period_months: 6
  next_review_date: 2027-03-01
  termination_notice_days: 30
escalation_to_pro:
  trigger: "月平均 30h 超過 3 ヶ月連続"
  proposed_fee: 150000
```

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では存在せず、v0.2 で新設(C-3 対応)。 |

---

**本書は AILEAP 内部資料。クライアントに直接共有しない。`commercial-manager` エージェントは本書を必須参照として、提案書・見積書を生成する。実案件で得た知見は本書に随時反映する。**
