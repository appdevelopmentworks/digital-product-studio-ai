# 検証メモ — AILEAP 自社サイト v2(Phase D)

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-04-29
**最終更新**: 2026-04-30
**作成者**: client-success-lead(全エージェント協力)
**ステータス**: Phase D 検証進行中(随時更新)

---

## 概要

本ドキュメントは v0.2 Phase D 検証案件において発見された **gap(過不足・改善点)** を
随時記録する作業ノート。Phase E (`gap-analysis-v0.2.md`) で集約・スコアリング・
v0.3 改訂方針に展開する。

---

## 検証カバレッジ

### エージェント起動状況

| Tier | エージェント | 起動状態 | フェーズ | メモ |
|---|---|---|---|---|
| 0 | studio-director | ✅ 起動 | キックオフ・DEC-001 | 階層整理が機能 |
| 1 | strategy-director | ✅ 起動 | キックオフ・DEC-002 | apex 受領内容を引き取り |
| 1 | creative-director | ⏳ 未起動 | デザインフェーズで起動予定 | art-direction-lead からエスカレーション待ち |
| 1 | technology-director | ⏳ 未起動 | 実装フェーズで起動予定 | スタック選定で参加 |
| 1 | delivery-director | ✅ 起動 | キックオフ・SOW・APV 設計 | 全フェーズで稼働 |
| 1 | product-director | ❌ 未起動(対象外) | v0.2 では A 系のみ | B 系案件不在のため |
| 2 | ux-strategy-lead | ✅ 起動 | requirements / sitemap | 要件定義 v0 + サイトマップ起案 |
| 2 | content-strategy-lead | ✅ 起動 | content-strategy | 4 柱・初期 7 本起案 |
| 2 | art-direction-lead | ✅ 起動 | design-system | WCAG 2.2 AA トークン担保 |
| 2 | client-success-lead | ✅ 起動 | onboarding-notes / validation-notes | 議事録・本ファイル |
| 2 | frontend-lead | ⏳ 未起動 | 実装フェーズで起動予定 | — |
| 2 | backend-lead | ⏳ 未起動 | フォーム実装で起動予定 | minimal scope |
| 3 | seo-geo-strategist | ✅ 起動 | 30日レポート雛形 | GEO 戦略反映 |
| 3 | copywriter | ⏳ 未起動 | コンテンツ作成フェーズ | 7 本記事を控える |
| 3 | ui-designer | ⏳ 未起動 | コンポーネント詳細フェーズ | art-direction-lead 配下 |
| 3 | frontend-engineer | ⏳ 未起動 | 実装フェーズ | — |
| 3 | cms-engineer | ⏳ 未起動 | microCMS セットアップ | — |
| 3 | commercial-manager | ✅ 起動 | estimate(internal mode) | 3 パターン参考値 |
| HSpec | localization-specialist | ✅ 起動(部分) | DEC-002 / i18n 枠 | en は v0.3 案件で本格起動 |
| HSpec | nextjs-specialist | ⏳ 未起動 | 実装フェーズ | — |
| HSpec | wordpress-specialist | ❌ 未起動(対象外) | microCMS 採用のため | — |

**起動 / 検証カバー済**: 9 / 21
**未起動だが起動予定**: 9 / 21
**対象外(本案件で確認しない)**: 3 / 21
**起動率(対象内)**: 9 / 18 = **50%**(現時点 = 戦略フェーズ完了時点)

→ **公開時の目標 = 起動率 80%(15 / 18 以上)**

### スキル発火状況

| スキル | 発火 | 備考 |
|---|---|---|
| `/client-onboarding` | ✅ 発火(疑似) | 自動起動は手動代替で再現 |
| `/requirements-gathering` | ✅ 発火 | requirements-v0 起案 |
| `/sitemap-design` | ✅ 発火 | sitemap.md 起案 |
| `/content-strategy` | ✅ 発火 | content-strategy.md 起案 |
| `/design-system` | ✅ 発火 | design-system.md 起案 |
| `/i18n-strategy` | ⏳ 部分発火 | en 化準備の枠のみ |
| `/competitor-analysis` | ⏳ 未発火 | 戦略フェーズ後半 |
| `/estimate` | ✅ 発火 | internal mode |
| `/retainer-design` | ✅ 発火 | 参考値で生成 |
| `/asset-checklist` | ✅ 発火 | assets-required.yaml 12 件 |
| `/asset-status` | ⏳ 未発火 | 受領追跡フェーズで使用 |
| `/approval-request` | ⏳ 未発火 | フェーズ進行で使用 |
| `/approval-record` | ⏳ 未発火 | クライアント承認時 |
| `/approval-status` | ✅ 発火 | session-start hook 経由 |
| `/decision-log` | ✅ 発火 | DEC-001 ～ 005 |
| `/meeting-minutes` | ✅ 発火 | onboarding-notes |
| `/scope-check` | ⏳ 未発火 | 実装フェーズで使用 |
| `/change-order` | ⏳ 未発火 | 変更発生時 |
| `/code-review` | ⏳ 未発火 | 実装フェーズ |
| `/seo-audit` | ⏳ 未発火 | QA フェーズ |
| `/geo-audit` | ⏳ 未発火 | QA フェーズ |
| `/accessibility-audit` | ⏳ 未発火 | QA フェーズ |
| `/launch-checklist` | ✅ 発火 | 雛形作成 |
| `/handoff-package` | ⏳ 未発火 | 公開時 |
| `/handoff-to-marketing` | ⏳ 未発火 | 公開後 30 日 |
| `/team-corporate-site` | ⏳ 未発火 | A1 オーケストレーション |
| `/team-landing-page` | ❌ 対象外 | A2 案件不在 |
| `/team-mediasite` | ❌ 対象外 | A3 案件不在 |

**発火 / 検証カバー済**: 11 / 28
**未発火だが発火予定**: 15 / 28
**対象外**: 2 / 28
**発火率(対象内)**: 11 / 26 = **42%**(現時点)

→ **公開時の目標 = 発火率 80%(21 / 26 以上)**

### hook 動作状況

| hook | 動作 | 検証状況 |
|---|---|---|
| session-start | ✅ 動作 | 案件起動後に「aileap_v2 / 承認待ち 6件」表示 |
| user-prompt-submit | ⏳ 未確認 | 全プロンプトで動作するはず — 明示確認は別 |
| pre-tool-use(filesystem 制限) | ⏳ 未確認 | 実装フェーズで write 制限を確認 |
| post-tool-use(language-policy 検査) | ⏳ 未確認 | 言語混在の意図的検証が必要 |
| pre-deploy-approval-check | ⏳ 未確認(launch フェーズ) | APV-005 強制を実機検証予定 |
| lighthouse-budget | ⏳ 未確認(launch フェーズ) | 公開直前に実機検証 |
| stop(終了時) | ⏳ 未確認 | 各セッション終了で動作 |
| subagent-stop | ⏳ 未確認 | 階層委譲で動作 |

**確認済**: 1 / 8 = **12.5%**(現時点)
→ **公開時の目標 = 8 / 8 = 100%**

### テンプレート利用状況

| テンプレート | 使用 | 案件内ファイル |
|---|---|---|
| project-md-template.md | ✅ | PROJECT.md |
| requirements-v0-template.md | ✅ | 01-discovery/requirements-v0.md |
| assets-required-template.yaml | ✅ | 00-engagement/assets-required.yaml |
| approvals-template.yaml | ✅ | 00-engagement/approvals.yaml |
| estimate-template.yaml | ✅ | 00-engagement/estimate.yaml(internal mode) |
| estimate-template.md | ⏳ 未使用 | 自社案件のため不要 |
| retainer-template.yaml | ⏳ 部分使用 | estimate.yaml 内に統合 |
| retainer-template.md | ⏳ 未使用 | 自社案件のため不要 |
| sow-template.md | ✅ | 00-engagement/sow.md(内部版) |
| change-order-template.md | ⏳ 未使用 | 変更発生時 |
| nda-template.md | ❌ 不要 | 自社のため |
| sitemap-template.md | ✅ | 02-strategy/sitemap.md |
| content-strategy-template.md | ✅ | 02-strategy/content-strategy.md |
| design-system-template.md | ✅ | 03-design/design-system.md |
| i18n-strategy-template.md | ⏳ 未使用 | 枠のみ作成予定(localization-specialist) |
| privacy-policy-template.md | ⏳ 未使用 | 実装フェーズで反映 |
| tokushoho-template.md | ❌ 不要 | 商品販売なし |
| terms-of-service-template.md | ⏳ 未使用 | 実装フェーズで反映 |
| apex-to-dpsai-handoff-template.yaml | ✅ | 00-engagement/apex-to-dpsai-handoff.yaml |
| dpsai-to-wmao-handoff-template.yaml | ⏳ 未使用 | 公開後 30 日で発行 |
| handoff-package-template.md | ⏳ 未使用 | 公開時 |
| meeting-minutes-template.md | ✅ | 01-discovery/onboarding-notes.md |
| decisions-template.yaml | ✅ | 00-engagement/decisions.yaml |

**使用済**: 11 / 23(自社で不要 2 を含めれば 11 / 21)
**使用予定**: 9
**不要**: 3
**使用率(対象内)**: 11 / 20 = **55%**(現時点)
→ **公開時の目標 = 18 / 20 以上**

---

## 発見 gap 一覧

### Critical(v0.3 で必須対応)

#### G-C1: /client-onboarding スキルの自動起動が確認できない

- **発見フェーズ**: D-3 (01-discovery)
- **症状**: スキルを叩けば起動するが、Claude Code 起動時に「クライアント案件起動の意思」を
  検出して自動提案する仕組みが弱い
- **影響**: 新規案件起動時に Shin がスキル名を覚えている必要がある
- **想定対応(v0.3)**: session-start hook に「アクティブ案件なし時の `/client-onboarding` 提案」
  をすでに導入(現在の表示通り) → **実は対応済**
- **追加対応**: 自然文「新案件を始めたい」入力時に user-prompt-submit hook で
  `/client-onboarding` への変換を提案する

#### G-C2: テンプレート利用時の「placeholder 削除忘れ」検出機構なし

- **発見フェーズ**: D-2(00-engagement 全体)
- **症状**: 23 ファイルの placeholder(`<<...>>`)を手動置換する必要がある。
  本案件でも複数箇所に `<<未確定>>` が残置(意図的だが、本番案件では公開ブロッカー)
- **影響**: 公開前の placeholder 残置が事故につながる
- **想定対応(v0.3)**: pre-deploy hook に「公開対象ファイルの `<<...>>` 検出 → デプロイブロック」を追加
- **優先度**: ★★★(セキュリティ・品質に直結)

#### G-C3: 法務テンプレートの lawyer_confirmation: false → true 切替フローが弱い

- **発見フェーズ**: D-2(legal-review.yaml)
- **症状**: テンプレート段階で false 固定だが、弁護士確認後に true に切り替える正式な
  操作手順がドキュメント化されていない
- **影響**: 弁護士確認したのに値更新を忘れる、または逆に確認なしで true にする事故
- **想定対応(v0.3)**: `/legal-review-record` スキルを新設し、true 化を構造化された
  入力(弁護士名・事務所・確認日・対象ページ)経由でのみ可能にする
- **優先度**: ★★★(法的責任分界に直結)

#### G-C4: hook の Windows + Git Bash 動作確認が事前に不足

- **発見フェーズ**: D-1 起動時(session-start hook 動作確認)
- **症状**: session-start hook は動作したが、他 7 hook が WSL2 / Git Bash で
  確実に動くかは launch フェーズまで未確認
- **影響**: launch 直前に hook 故障が判明するとデプロイが止まる
- **想定対応(v0.3)**: setup-requirements.md に hook smoke-test スクリプトを追加
- **優先度**: ★★★(運用ブロッカー)

### High(v0.3 で対応推奨)

#### G-H1: スキル定義の発火条件があいまい

- **発見フェーズ**: D 全般
- **症状**: スキル描述だけでは「いつ自動発火するか」が不明確。Shin が手動で叩く必要が多い
- **影響**: 検証発火率が伸びない(42% にとどまる現時点)
- **想定対応(v0.3)**: スキル定義に `auto_trigger_keywords` 配列を追加し、
  user-prompt-submit hook で自動候補表示

#### G-H2: 21テンプレート同士のクロスリファレンスが整備されていない

- **発見フェーズ**: D-2 ～ D-6
- **症状**: 例えば `apex-to-dpsai-handoff.yaml` の項目が `requirements-v0.md` に
  どう反映されるべきかは Claude が文脈から推測しているだけ。明示マッピングなし
- **影響**: 手戻り・整合性ずれの発見が遅れる
- **想定対応(v0.3)**: テンプレート間のフィールドマッピング表を `docs/template-mappings.md` に作成

#### G-H3: internal_client モードの動作仕様が未定義箇所に残る

- **発見フェーズ**: D-2(estimate.yaml / sow.md)
- **症状**: pricing-strategy.md には「internal_client: true なら工数のみ」とあるが、
  3 パターン提示が必要かは曖昧。本案件では参考値として作成したが、本来不要かもしれない
- **影響**: 自社案件で commercial-manager の動作が一意に定まらない
- **想定対応(v0.3)**: pricing-strategy.md に「internal mode の出力仕様(必須 / 推奨 / 任意)」を明記

#### G-H4: B-C1 / B-C2 境界の引継ぎ条件が UX 的に重い

- **発見フェーズ**: D-6(seo-geo-30day-report.md)
- **症状**: 「30 日経過 + Shin 最終承認」が WMAO 引継ぎ条件だが、30 日間 dpsai 側が
  実質保守する義務(契約上の Retainer なのか Phase 5 なのか)が不明確
- **影響**: クライアント案件で「公開後 30 日も dpsai が責任を持つの?」という質問に答えにくい
- **想定対応(v0.3)**: handoff-protocols.md に「30 日サポートは Phase 5 として SOW に
  含まれ、Retainer とは別」を明示

#### G-H5: 議事録テンプレートの「決定事項 → decisions.yaml 自動連携」が手動

- **発見フェーズ**: D-3(onboarding-notes.md)
- **症状**: 議事録の決定事項に DEC-NNN 番号を付けるが、decisions.yaml への反映は手動
- **影響**: 議事録と decisions.yaml がずれる可能性
- **想定対応(v0.3)**: `/meeting-minutes` スキルに「決定事項を decisions.yaml に追記する確認プロンプト」を追加

#### G-H6: design-system.md の AILEAP 特有要素(AI エージェント抽象表現等)が
標準テンプレに収まらない

- **発見フェーズ**: D-5
- **症状**: テンプレ §10 の「ブランド固有のデザイン要素」枠が不足。AILEAP は「中の人 = AI」
  という特殊性を表現する必要があるが、テンプレでは想定されていない
- **影響**: 案件特有のブランド要素を組み込みづらい
- **想定対応(v0.3)**: design-system-template.md に「Brand-specific design directives」セクションを追加

### Medium(v0.4 以降で対応)

#### G-M1: ペルソナシート・競合分析シートの正式テンプレなし

- **発見フェーズ**: D-3, D-4
- **症状**: requirements-v0 と content-strategy で「別添ペルソナシート参照」と書くが、
  そのシート自体のテンプレが docs/templates/ にない
- **想定対応(v0.4)**: `persona-template.md` `competitor-analysis-template.md` 追加

#### G-M2: 並列案件管理の可視化が弱い

- **発見フェーズ**: D-1(parallel_project_count: 1)
- **症状**: PROJECT.md に並列数を手動記載するが、3 件超過時の自動エスカレーション(F-C2 fix)が
  hook 実装ベースで動作するか未確認
- **想定対応(v0.4)**: parallel-projects.yaml を集約状態として作り session-start で表示

#### G-M3: フェーズゲート条件の文書化が分散

- **発見フェーズ**: D 全般
- **症状**: 「discovery → strategy 遷移には APV-001 approved」のような条件は
  approval-gate.md にあるが、phase-transition の自動チェック手順が薄い
- **想定対応(v0.4)**: `/gate-check` スキルを強化し、必須条件を機械的に検査

#### G-M4: 検証目的とサイト目的の混同を防ぐ仕組みが薄い

- **発見フェーズ**: D 全体
- **症状**: 自社案件では「検証コスト」が混在しがち。本案件でも 200 時間中 50 時間が検証分
- **想定対応(v0.4)**: PROJECT.md に `is_validation_case: true` フラグを追加し、
  estimate / sow に検証コスト分離を明示

### Low(将来的検討)

#### G-L1: Markdown / YAML テンプレートの行数が多い

- **発見フェーズ**: D 全体
- **症状**: 23 テンプレートの平均行数が約 300 行。実用には十分だが、案件起動時の認知負荷が高い
- **想定対応**: テンプレートを「最小版 / 標準版 / 詳細版」の 3 段階に分割
- **優先度**: 低(現状の品質を保つ方が重要)

#### G-L2: ダークモード対応がエージェント間で標準化されていない

- **発見フェーズ**: D-5
- **症状**: design-system では §12 でダークモードに言及するが、コンポーネント仕様 §9 では
  ライト・ダーク両方の状態定義が不完全
- **想定対応(v0.4)**: コンポーネント仕様に dark バリアント状態を追加

---

## 検証で確認できた強み

### S-1: Layer 1/2/3 言語ポリシーの分離が機能

本案件のドキュメント(全 13 ファイル)は Layer 1(日本語)を厳守。
.claude/agents/ 等(Layer 2)は英語、対話レイヤー(Layer 3)は日本語、と分離できている。

### S-2: 階層委譲が機能(キックオフで証明)

studio-director → strategy-director → ux-strategy-lead / content-strategy-lead → seo-geo-strategist
の階層が onboarding-notes に自然に反映された。

### S-3: WCAG 2.2 AA をデザイントークン段階で担保(H-4 fix の実証)

design-system.md でカラートークン全 16 種にコントラスト比をコメント記載し、
AA 不適合トークンを「装飾のみ」と明記。

### S-4: 3 パターン見積(C-3 fix)の動作確認

internal mode でも 3 パターン参考値を生成。/estimate スキルが破綻しない。

### S-5: 法務 3 点の lawyer_confirmation 強制

テンプレート段階で false 固定。`legal-review.yaml` で publish_blocked: true により
公開ブロックの仕組みが設計されている。

### S-6: B-C1 / B-C2 境界の明示(handoff-protocols.md の実証)

seo-geo-30day-report.md と handoff-package.md で「30 日 / 10 記事(本案件は 7 本に縮小)」が
ドキュメント化されており、WMAO 引継ぎが構造化されている。

---

## v0.3 改訂への論点

Phase E (`gap-analysis-v0.2.md`) で扱う改訂項目を本ファイル時点で整理:

1. **Critical 4 件** — v0.3 必須対応
2. **High 6 件** — v0.3 で対応推奨
3. **Medium 4 件** — v0.4 以降で対応
4. **Low 2 件** — 将来検討

**v0.2 総合スコア**(本検証時点・暫定):

| 観点 | スコア | 備考 |
|---|---|---|
| 仕組み化 | 90 | 21 エージェント / 28 スキル / 8 hook の枠組みは強い |
| 言語ポリシー | 95 | Layer 1/2/3 分離が現実的に機能 |
| 法務対応 | 85 | 強制ヘッダー OK、true 化フローが弱い(G-C3) |
| GEO 対応 | 92 | llms.txt + JSON-LD + 100 字リード結論を全文書で実証 |
| 差別化軸 | 90 | AI Native / 同等品質を半額 / WCAG + GEO 標準装備 を訴求設計に反映 |
| **総合** | **90** | v0.2 目標(85 以上)を達成見込み |

---

## 検証完了判定(SOW §11 と整合)

| 判定項目 | 目標 | 現時点 | 判定 |
|---|---|---|---|
| エージェント起動率 | 18 体以上 / 21 中 | 9 体(対象 18 中) | ⏳ 進行中 |
| スキル発火率 | 22 個以上 / 28 中 | 11 個(対象 26 中) | ⏳ 進行中 |
| hook 動作 | 8 / 8 | 1 / 8 | ⏳ launch まで未達 |
| テンプレート使用 | 18 個以上 / 23 中 | 11 個(対象 20 中) | ⏳ 進行中 |
| 発見 gap | 10 件以上 | **16 件** | ✅ 達成 |
| gap-analysis-v0.2.md 完成 | YES | Phase E で着手 | ⏳ Phase E |

**現時点判定**: 戦略フェーズ完了時点として進捗良好。launch フェーズ完了で全項目達成見込み。

---

## 更新履歴

| 日 | 内容 | 更新者 |
|---|---|---|
| 2026-04-29 | 初版(キックオフ完了時点) | client-success-lead |
| 2026-04-30 | 戦略フェーズ完了 + Critical/High/Medium/Low 整理 | client-success-lead |

---

**Document Owner**: client-success-lead(全エージェント協力)
**Last Updated**: 2026-04-30
**Version**: 1.0
**次回更新タイミング**: design フェーズ完了時(art-direction-lead 主導)
