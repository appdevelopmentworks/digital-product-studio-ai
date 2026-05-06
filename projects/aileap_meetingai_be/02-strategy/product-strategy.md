# プロダクト戦略 — AILEAP MeetingAI β版

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: product-director(B 系・本格起動)
**ステータス**: 承認済(APV-001 内 / 2026-08-15)

> B 系の中核戦略文書。product-director 主担当。

---

## 1. ビジョン

**会議の生産性を 2 倍に**(LP コピーと整合)

中堅企業のバックオフィス担当者が「会議の録音を投げるだけで議事録ができる」体験を提供し、会議メモ作成の工数を 90% 削減する。

## 2. ターゲットユーザー

[product-discovery.md §1](../01-discovery/product-discovery.md#1-ターゲットユーザー) を参照。

- プライマリ:中堅企業(50-300 名)バックオフィス担当
- セカンダリ:スタートアップ初期メンバー

## 3. JTBD

[product-discovery.md §2](../01-discovery/product-discovery.md#2-jtbdjobs-to-be-done) を参照。

メイン: 録音 → 議事録 → 共有 → 検索 を一気通貫で自動化したい。

## 4. Value Hypothesis(価値仮説)

[product-discovery.md §3](../01-discovery/product-discovery.md#3-value-hypothesis価値仮説) を参照。

**3 つの差別化軸**:
1. 日本語の会議要約品質(Whisper + Claude チューニング)
2. 中堅企業向けの即実用性(機能を絞る)
3. AILEAP の AI Native 運用ノウハウ

## 5. MVP スコープ(本案件)

[product-discovery.md §5](../01-discovery/product-discovery.md#5-mvp-範囲desired-mvp-scope) を参照。

最小学習可能範囲:招待制 + 録音 + 要約 + PDF + 利用統計。

## 6. 成功 metrics

[product-discovery.md §7](../01-discovery/product-discovery.md#7-成功の定義success-metrics) を参照。

PMF 判断材料:
- WAU 20+ / Week 4
- 録音 → 要約完了率 90%+
- 平均要約精度 4.0/5.0+
- 月 1 回以上継続利用率 30%+

## 7. リスク

### 7.1 技術リスク

| リスク | 想定影響 | 緩和策 |
|---|---|---|
| Whisper の日本語精度問題 | 要約品質低下 | プロンプトチューニング + 後処理で訂正 |
| LLM API コスト超過 | 月 5 万 → 10 万 | Tier 適切設定 + usage cap |
| 60 分音声処理の時間 | UX 悪化 | 非同期処理 + 進捗バー UI |

### 7.2 市場リスク

| リスク | 想定影響 | 緩和策 |
|---|---|---|
| 競合(Notta)の機能追加 | 差別化薄れ | 中堅企業特化のフォーカスを維持 |
| ユーザーが個人向け機能を要求 | セグメント誤り(pivot) | Anti-hypothesis として早期検出 |

### 7.3 PMF リスク

[product-discovery.md §4](../01-discovery/product-discovery.md#4-anti-hypothesis反仮説--棄却条件) の Hard kill / Soft pivot 条件を参照。

## 8. Anti-Hypothesis(反仮説)

[product-discovery.md §4](../01-discovery/product-discovery.md#4-anti-hypothesis反仮説--棄却条件) を参照。

主要な棄却条件:
- 実利用 10 件未満(Week 4)→ kill
- 要約精度 4.0/5.0 未達(2 週連続)→ pivot or kill
- 個人向け機能要求が支配的 → pivot

## 9. ロードマップ

詳細は `product-roadmap.md` 参照。要点:

- **β版(本案件 / 2026-08-01 ~ 10-04)**: MVP 機能 + 50 ユーザー検証
- **正式版(2026 Q4 / 別案件)**: チーム機能 + Slack/Teams 連携 + 課金機能
- **拡張版(2027 Q1+)**: SSO + API 公開 + 海外展開検討

## 10. 検証メモ(Phase I-B)

- product-director の Strategy 文書として、product-discovery.md からの構造化された継承を実証
- /pmf-validation スキルの実行に必要なすべての要素(hypothesis / anti-hypothesis / metrics)が本書に集約
- 本書の各セクションが「PMF 判断時の評価基準」として機能することを Week 4 で確認予定

---

**Document Owner**: product-director
**Last Updated**: 2026-08-15
**Version**: 1.0
