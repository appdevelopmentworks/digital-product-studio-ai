# テンプレート間マッピング

**バージョン**: 0.3
**作成日**: 2026-05-01
**位置づけ**: [gap-analysis-v0.2.md](gap-analysis-v0.2.md) G-H2 解消 / 23 テンプレート間のフィールド継承を明示する正本
**対象**: `docs/templates/` 配下のすべてのテンプレート + 案件配下で生成される派生ファイル

---

## 0. 本書の目的

v0.2 段階で 23 テンプレートが整備されたが、テンプレート間のフィールド継承(例: `apex-to-dpsai-handoff.yaml::client.name` が `requirements-v0.md::クライアント情報` にどう反映されるか)は Claude の文脈推測に任されていた。本書はこのマッピングを構造化された表形式で明示し、以下を実現する。

1. **手戻り防止**: 上流テンプレートの変更が下流のどこに波及するかを一覧で確認できる
2. **整合性検証の根拠**: クロスリファレンスチェックの正本として scope-check / gate-check が参照できる
3. **エージェント引継ぎの明確化**: 委譲先のエージェントがどのフィールドを引き継ぐべきかを明示

---

## 1. テンプレート一覧と所属フェーズ

| # | テンプレート | フェーズ | 主担当 | 形式 |
|---|---|---|---|---|
| 1 | `project-md-template.md` | 全フェーズ | studio-director | Markdown(YAML frontmatter) |
| 2 | `apex-to-dpsai-handoff-template.yaml` | Engagement(着手前) | apex 側起動 / studio-director 受領 | YAML |
| 3 | `nda-template.md` | Engagement | commercial-manager | Markdown |
| 4 | `estimate-template.yaml` | Engagement | commercial-manager | YAML |
| 5 | `estimate-template.md` | Engagement | commercial-manager | Markdown |
| 6 | `retainer-template.yaml` | Engagement | commercial-manager | YAML |
| 7 | `retainer-template.md` | Engagement | commercial-manager | Markdown |
| 8 | `sow-template.md` | Engagement | delivery-director / commercial-manager | Markdown |
| 9 | `assets-required-template.yaml` | Engagement / Discovery | client-success-lead | YAML |
| 10 | `approvals-template.yaml` | 全フェーズ(gate) | client-success-lead | YAML |
| 11 | `decisions-template.yaml` | 全フェーズ(log) | client-success-lead | YAML |
| 12 | `meeting-minutes-template.md` | 全フェーズ | client-success-lead | Markdown |
| 13 | `requirements-v0-template.md` | Discovery | ux-strategy-lead | Markdown |
| 14 | `sitemap-template.md` | Strategy | ux-strategy-lead | Markdown |
| 15 | `content-strategy-template.md` | Strategy | content-strategy-lead | Markdown |
| 16 | `i18n-strategy-template.md` | Strategy | localization-specialist | Markdown |
| 17 | `design-system-template.md` | Design | art-direction-lead | Markdown |
| 18 | `privacy-policy-template.md` | Implementation | delivery-director(法務) | Markdown(法務) |
| 19 | `tokushoho-template.md` | Implementation | delivery-director(法務) | Markdown(法務) |
| 20 | `terms-of-service-template.md` | Implementation | delivery-director(法務) | Markdown(法務) |
| 21 | `change-order-template.md` | 進行中(変更時) | commercial-manager | Markdown |
| 22 | `handoff-package-template.md` | Launch | delivery-director | Markdown |
| 23 | `dpsai-to-wmao-handoff-template.yaml` | Post-launch(30 日後) | delivery-director | YAML |

---

## 2. フェーズ間マッピング(主要フィールドの継承)

### 2.1 Engagement(apex 受領 → 案件起動)

#### `apex-to-dpsai-handoff.yaml` → `PROJECT.md`

| 上流フィールド | 下流フィールド | 継承タイミング |
|---|---|---|
| `client.name` | `client_name` | studio-director の案件 ID 採番時 |
| `client.decision_maker.name` | `client_contact` | 同上 |
| `client.decision_maker.contact` | `client_email` | 同上 |
| `project_brief.project_type.primary` | `type` | 同上 |
| `project_brief.timeline.desired_launch` | `target_launch_at` | 同上 |
| `project_brief.kgi` | `kgi` | 同上 |
| `handoff_id` | `apex_handoff_ref` | 同上 |
| `from.organization` (apex-consulting-ai 固定) | (記録のみ) | 同上 |

#### `apex-to-dpsai-handoff.yaml` → `requirements-v0.md`

| 上流フィールド | 下流フィールド | 備考 |
|---|---|---|
| `client.industry` | 「クライアント情報 → 業界」 | 必須 |
| `client.size` | 「クライアント情報 → 規模」 | SME / mid-market / enterprise |
| `client.stakeholders[]` | 「主要関係者」 | 役割込みで全件転記 |
| `strategic_context.business_objective` | 「事業目的・背景」 | 1-2 文で要約 |
| `strategic_context.target_audience` | 「ターゲット顧客像」 | ペルソナ起点 |
| `strategic_context.competitive_position` | 「競合上の位置づけ」 | 競合分析の起点 |
| `strategic_context.digital_strategy` | 「デジタル戦略全体像」 | content-strategy の根拠 |
| `strategic_context.why_web` | 「なぜ Web か(本案件の意義)」 | 必須 |
| `project_brief.kgi` | 「KGI」 | PROJECT.md と二重記載 |
| `project_brief.constraints[]` | 「制約条件」 | sitemap / design に影響 |

#### `apex-to-dpsai-handoff.yaml` → `estimate.yaml`

| 上流フィールド | 下流フィールド | 備考 |
|---|---|---|
| `project_brief.budget_range.min` / `.max` | `patterns.fixed_price.total_jpy` の妥当性検証 | レンジ外なら commercial-manager がエスカレーション |
| `project_brief.timeline.desired_launch` | `valid_until`(逆算) | 通常は 30 日先 |
| `project_brief.constraints[]` | `scope_notes` | 工数算定の制約として転記 |
| `client.size` | 単価レンジ判定の補助情報 | SME = 標準レンジ |

#### `estimate.yaml` → `sow.md`

| 上流フィールド | 下流フィールド | 備考 |
|---|---|---|
| `patterns.fixed_price.total_jpy` | 「契約金額」 | 採用パターンに応じて転記 |
| `patterns.fixed_price.payment_schedule[]` | 「支払条件」 | 全件転記 |
| `patterns.fixed_price.scope_notes` | 「業務範囲」 | スコープ確定の根拠 |
| `patterns.retainer.monthly_fee_jpy` | 「保守(別契約)」セクション参照 | sow には金額のみ転記、詳細は retainer.md |
| `valid_until` | 「契約期日」 | sow 締結期限 |

#### `estimate.yaml` → `retainer.yaml`

| 上流フィールド | 下流フィールド | 備考 |
|---|---|---|
| `patterns.retainer.tier` | `tier` | 同名フィールド |
| `patterns.retainer.monthly_fee_jpy` | `monthly_fee_jpy` | 同 |
| `patterns.retainer.included_hours` | `included_hours` | 同 |
| `patterns.retainer.minimum_period_months` | `minimum_period_months` | 同 |
| `patterns.retainer.services` | `services` (内訳の hours 内訳) | 同 |

### 2.2 Discovery(要件 → 戦略の起点)

#### `requirements-v0.md` → `sitemap.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 「機能要件」 | サイトマップのページ列挙 | 各機能 = 最低 1 ページ |
| 「KPI」 | コンバージョンページの定義 | フォーム / CTA の配置点 |
| 「ターゲット顧客像」 | 情報設計の優先順位 | 主要ユーザー導線の起点 |
| 「制約条件」 | URL 構造の制約反映 | 例: 既存 URL 維持 → リダイレクトマップ |

#### `requirements-v0.md` → `content-strategy.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 「事業目的・背景」 | コンテンツピラー(4 柱)の根拠 | 戦略文脈の継承 |
| 「ターゲット顧客像」 | ペルソナドラフト | 別添ペルソナシート起点(v0.4 で正式テンプレ化) |
| 「競合上の位置づけ」 | tone of voice の差別化軸 | 競合と異なる声 |
| 「デジタル戦略全体像」 | エディトリアルカレンダー | コンテンツ発信頻度の根拠 |

#### `requirements-v0.md` → `i18n-strategy.md`(多言語案件のみ)

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 「対応言語」 | `target_languages[]` | 必須 |
| 「ターゲット顧客像」(国別) | `locale_consideration[]` | 文化的差異の検出 |
| 「制約条件」(SEO) | `hreflang_strategy` | 複数ドメイン or サブパス選定 |

### 2.3 Strategy(戦略 → デザイン)

#### `sitemap.md` → `design-system.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| ページ階層(3 層) | レイアウトテンプレート(top / category / detail) | 3 種が標準 |
| ナビゲーション構造 | `9.5 ナビゲーション` セクション | グローバル + ローカル |
| ページ数 | コンポーネント抽象度の判断 | 多ページ = atomic に倒す |

#### `content-strategy.md` → `design-system.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 4 ピラー | `1.1 ブランド方針` の各原則 | ピラーごとの視覚言語 |
| tone of voice | `1.4 Brand-specific design directives` | コピーと視覚の整合 |
| 引用しやすさ(GEO) | `9.6 フォーム` 等の構造化重視 | LLM 引用を意識した HTML 構造 |

#### `i18n-strategy.md` → `design-system.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 対応言語(en/zh/ko) | フォントスタック追加 | 各言語のフォールバック |
| 文字組(漢字 vs 英数) | タイポトラッキング(`font.tracking`) | en は wide / ja は normal |
| 言語切替 UI | `9.5 ナビゲーション` の言語切替 | hreflang と整合 |

### 2.4 Design → Implementation

#### `design-system.md` → `src/components/**` `app/**`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| カラートークン | `tailwind.config.js` / CSS 変数 | `12.1 / 12.2` 実装ガイドに従う |
| タイポスケール | `font-size-*` ユーティリティ | rem ベース |
| `9. コンポーネント仕様` | `atoms/` `molecules/` 実装 | Atomic Design に展開 |
| `7. フォーカスインジケーター` | 全インタラクティブ要素の `:focus-visible` | rules/components.md で強制 |
| `1.4 Brand-specific directives` | コンポーネント実装時の MUST 制約 | art-direction-lead がレビュー |

#### `i18n-strategy.md` → `messages/{locale}.json`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 対応言語 | 各 JSON ファイルの存在 | ja, en は v0.3 必須 |
| 翻訳パイプライン | コミットフロー | DeepL / Claude / GPT-4 + native review |

### 2.5 Implementation → Launch

#### 全成果物 → `launch-checklist.md`

`launch-checklist` は 12 セクションすべてのチェック項目を生成する起点として:

- 「1. 承認」← `approvals.yaml` 全件参照
- 「3. SEO/GEO」← `02-strategy/seo-geo-strategy.md`
- 「7. 法的」← `00-engagement/legal-review.yaml`
- 「9. CMS」← `cms-manual.md`
- 「10. リダイレクト」← `redirect-map.md`(改修案件)

#### Implementation 全成果物 → `placeholder-check` レポート

`placeholder-check` は `05-launch/`、`06-handoff/`、サイトソース(`src/` `app/` `pages/` `content/`)を再帰スキャン。これらの上流テンプレート(法務 / sow / handoff-package 等)で `<<...>>` を残さないことが必須。

### 2.6 Launch → Post-launch

#### `launch-checklist.md` → `handoff-package.md`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 「2. DNS / SSL / Hosting」 | 「インフラ詳細」 | 認証情報を別経路で渡す |
| 「6. Analytics」 | 「アクセス解析設定」 | GA4 / GSC アクセス権 |
| 「9. CMS」 | 「CMS マニュアル別添」 | `cms-manual.md` 参照 |
| 「11. 監視」 | 「SLA・SLO」 | Retainer 契約と整合 |

### 2.7 Post-launch → WMAO 引継ぎ

#### `seo-geo-30day-report.md` → `dpsai-to-wmao-handoff.yaml`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| 「30 日インプレッション」 | `baseline_metrics.impressions_30d` | 数値転記 |
| 「30 日クリック」 | `baseline_metrics.clicks_30d` | 同 |
| 「Lighthouse 30 日後」 | `baseline_lighthouse_scores` | 各指標 |
| 「LLM 引用検出」 | `baseline_metrics.geo_citations` | GEO 監視の起点 |
| 「次の 90 日推奨アクション」 | `expected_wmao_actions.immediate[]` | WMAO への申し送り |

#### `handoff-package.md` → `dpsai-to-wmao-handoff.yaml`

| 上流の起点 | 下流での反映 | 備考 |
|---|---|---|
| `delivered_assets[]` | `delivered_assets[]` | 全件転記 |
| `cms_credentials` | `cms_credentials_path`(暗号化) | 別経路で渡す |
| 「初期コンテンツ N 本」 | `initial_content.count` | B-C2 境界の根拠 |
| 「保守 SLA」 | `maintenance.sla` | Retainer 契約 |

---

## 3. 横断マッピング(全フェーズ共通)

### 3.1 ID の継承(プロジェクト全体で一意性を保つ)

| ID 形式 | 起点テンプレート | 引用先 | 命名規則 |
|---|---|---|---|
| `<CLIENT_ABBR>-<YYYYMMDD>-<NNN>` | `PROJECT.md::id` | 全成果物の冒頭 | project-scaffold.md |
| `APV-NNN` | `approvals.yaml` | meeting-minutes / decisions / handoff | yaml-schema-conventions.md |
| `DEC-NNN` | `decisions.yaml` | meeting-minutes / その他成果物 | 同上 |
| `AST-NNN` | `assets-required.yaml` | asset-status / handoff | 同上 |
| `EST-NNN` | `estimate.yaml::estimate_id` | sow / proposal | 同上 |
| `RTN-NNN` | `retainer.yaml::retainer_id` | sow(別契約) | 同上 |
| `CO-NNN` | `change-order.md` | sow 改訂 / decisions | 同上 |
| `MTG-NNN` | `meeting-minutes.md` | decisions(議事録参照) | 同上 |
| `HO-NNN` | `apex-to-dpsai-handoff.yaml` / `dpsai-to-wmao-handoff.yaml` | PROJECT.md ハンドオフ参照欄 | handoff-protocols.md §0.5 |
| `PB-NNN` | `performance-bonus.yaml`(任意) | sow 別添 | pricing-strategy.md §5.5 |

**重要**: 同じ ID が複数の成果物に登場する場合、**起点テンプレートの値が正本**。下流で改変しない(改変は起点に対して行う)。

### 3.2 状態管理フィールドの集約

| 状態フィールド | 起点 | 参照する hook / スキル | gate 効果 |
|---|---|---|---|
| `approvals.yaml::status` | client → client-success-lead が記録 | `pre-deploy-approval-check.sh` / `/approval-status` | Phase 進行 / deploy ゲート |
| `legal-review.yaml::lawyer_confirmation` | 弁護士 → `/legal-review-record` 経由 | `legal-pages-check.sh` | deploy ゲート |
| `assets-required.yaml::status` | client-success-lead | `/asset-status` | Phase 進行参考 |
| `PROJECT.md::phase` | studio-director / delivery-director | `/gate-check` / session-start hook | 全フェーズ判定 |
| `PROJECT.md::status` | 同上 | session-start hook | session 表示 |
| `retainer.yaml::status` | commercial-manager | (運用中) | 月次レビュー |

### 3.3 ログ系の連携

```
meeting-minutes.md ─[D{n} → DEC-NNN mirror]→ decisions.yaml
                    (G-H5 で承認プロンプト経由)

decisions.yaml ───[DEC-NNN 引用]→ 全成果物の脚注 / 注釈
                  (削除しない・追記のみ)

approvals.yaml ──[APV-NNN 引用]→ launch-checklist / handoff-package

change-order.md ──[CO-NNN]→ sow.md 改訂 / decisions.yaml DEC エントリ
```

---

## 4. 矛盾検出ルール(scope-check / gate-check が参照)

### 4.1 必須整合ペア(矛盾していたら警告)

| ペア A | ペア B | 整合条件 |
|---|---|---|
| `PROJECT.md::client_name` | `apex-to-dpsai-handoff.yaml::client.name` | 完全一致 |
| `PROJECT.md::type` | `estimate.yaml::project.type` | 完全一致 |
| `estimate.yaml::patterns.fixed_price.total_jpy` | `sow.md::契約金額` | 完全一致(採用パターン時) |
| `i18n-strategy.yaml::target_languages` | `PROJECT.md::target_languages` | A ⊆ B |
| `legal-review.yaml::pages_reviewed[].page` | `privacy-policy.md` 等の存在 | required: true なら対応ファイル必須 |
| `decisions.yaml::DEC-NNN` | meeting-minutes.md 内の同 ID | 双方向で一致 |

### 4.2 disallowed パターン(検出したら block)

| 状況 | block 対象 |
|---|---|
| `lawyer_confirmation: true` だが `lawyer_name: null` | legal-review.yaml の手書き編集を検出 → `/legal-review-record` 経由を要求 |
| `<<...>>` が `05-launch/` `06-handoff/` 配下に残置 | placeholder-detection.sh が deploy block |
| `approvals.yaml::status: approved` から `pending` への戻り | approval-gate.md で禁止 |
| `decisions.yaml` の DEC エントリの削除 | 追記のみ許可 |

---

## 5. データフロー詳細(主要キーフィールド単位)

### 5.1 KGI/KPI

```
apex-to-dpsai-handoff.yaml::project_brief.kgi
       │
       ├─ PROJECT.md::kgi                       (案件起動時に転記)
       ├─ requirements-v0.md::「KGI/KPI」      (Discovery で詳細化)
       ├─ measurement-plan.md::measurement_kgi (測定計画に展開)
       └─ dpsai-to-wmao-handoff.yaml::post_launch_targets.kgi (WMAO 申し送り)
```

### 5.2 法務(privacy_policy)

```
docs/templates/privacy-policy-template.md
       │  (instantiate で複製)
       ▼
projects/{id}/00-engagement/legal-review.yaml::pages_reviewed[].privacy_policy
       │  (lawyer_confirmation: false で初期化)
       │
       │ /legal-review-record 経由
       ▼
projects/{id}/00-engagement/legal-review.yaml::lawyer_confirmation: true
       │
       ▼
legal-pages-check.sh が deploy 許可
       │
       ▼
projects/{id}/05-launch/launch-checklist.md::「7. 法的」 = ✅
```

### 5.3 デザインシステム

```
content-strategy.md (4 ピラー / tone of voice)
       │
sitemap.md (3 層階層)
       │
i18n-strategy.md (多言語要件)
       │
       ▼
design-system.md (カラー / タイポ / 1.4 Brand-specific / 9.x コンポーネント)
       │
       ▼
src/components/**/*.tsx (atoms → organisms)
       │
       ▼
launch-checklist.md::「4. アクセシビリティ」 / 「5. パフォーマンス」 = ✅
```

---

## 6. テンプレート間で発生しがちな整合性ミス

| 症状 | よくある原因 | 検出方法 |
|---|---|---|
| `client_name` が PROJECT.md と sow.md で違う | sow をテンプレから初期化したまま `<<COMPANY_NAME>>` 残置 | `placeholder-detection.sh` |
| `kgi` の数値が requirements-v0 と measurement-plan で食い違う | Discovery で詳細化した時に同期し忘れ | scope-check / gate-check の整合検証 |
| `lawyer_confirmation: true` なのに `lawyer_name: null` | 手書きで true にした(NG パターン) | `legal-pages-check.sh` |
| `target_languages` が PROJECT.md と i18n-strategy で違う | 後追いで言語追加した時の漏れ | scope-check |
| `DEC-NNN` の番号が重複 | 議事録から手動転記時の番号衝突 | decisions.yaml の id ユニーク検証(yaml-schema-conventions.md) |

---

## 7. 改訂運用

### 7.1 上流テンプレートを変更したとき

`docs/templates/` 配下のテンプレートを変更した場合、本書の該当マッピング表を必ず更新する。更新を怠ると、既存案件の整合性が壊れていることに気付けなくなる。

更新手順:
1. テンプレート変更
2. 本書の該当マッピング行を更新(影響先フィールドを追加 / 削除)
3. 既存案件への影響を `decisions.yaml::DEC-NNN` で記録
4. 必要なら `/scope-check` で全案件への影響をスキャン

### 7.2 新規テンプレートを追加したとき

1. テンプレートを `docs/templates/` に追加
2. 本書 §1 のテンプレート一覧に追加
3. §2 のフェーズ間マッピング、§3 の横断マッピングに該当行を追加
4. §4 の必須整合ペアに該当ルールを追加(あれば)

---

## 8. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.3 | 2026-05-01 | 初版。v0.2 時点で 23 テンプレートが整備済の状態を起点に、テンプレート間マッピングを構造化した正本として新設(G-H2 解消)。 |

---

**本書は v0.3 以降、テンプレート間整合性の正本である。テンプレート変更時は本書を必ず同時に更新すること。`scope-check` / `gate-check` / `placeholder-check` / `legal-pages-check` の各エージェント・スキル・hook は本書の §4 矛盾検出ルールを正本として参照する。**
