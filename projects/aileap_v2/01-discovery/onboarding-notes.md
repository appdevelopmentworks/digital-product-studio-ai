---
meeting_id: MTG-20260429-001
project_id: AILEAP-20260429-001
date: 2026-04-29
start_time: "11:30"
end_time: "13:00"
duration_minutes: 90
type: kickoff
location: AILEAP 内部(Claude Code セッション)
recording_url: null
chair: delivery-director
minutes_taker: client-success-lead
status: final
distributed_at: 2026-04-29
---

# キックオフ議事録: AILEAP 自社サイト v2

## 1. 会議概要

| 項目 | 内容 |
|---|---|
| 会議名 | AILEAP 自社サイト v2 キックオフ |
| 開催日時 | 2026-04-29(水)11:30 - 13:00 |
| 場所 | AILEAP 内部(Claude Code セッション) |
| 案件 | AILEAP 自社サイト v2 改修 |
| 案件 ID | AILEAP-20260429-001 |
| フェーズ | discovery 起動時 |

## 2. 出席者

### 2.1 クライアント側(AILEAP)

| 役職 | 氏名 | 出席状況 |
|---|---|---|
| 決裁者 / 代表 | Shin | 出席 |

### 2.2 受託者側(digital-product-studio-ai)

| 役職 | 氏名 | 出席状況 |
|---|---|---|
| Studio Director | studio-director | 出席 |
| Delivery Director | delivery-director | 出席 |
| Strategy Director | strategy-director | 出席 |
| UX Strategy Lead | ux-strategy-lead | 出席 |
| Content Strategy Lead | content-strategy-lead | 出席 |
| SEO/GEO Strategist | seo-geo-strategist | 出席 |
| Client Success Lead(議事録) | client-success-lead | 出席 |

> **注**: 本案件は Phase D 検証案件のため、起動時に主要エージェントが揃って参加した。
> 後続フェーズでは art-direction-lead / ui-designer / frontend-lead / cms-engineer 等が
> 順次参加する。

---

## 3. 議題(アジェンダ)

1. apex ハンドオフの確認(15分)
2. AILEAP の事業戦略・3組織アーキテクチャの再確認(20分)
3. 既存サイトの課題棚卸し(15分)
4. v2 の方針・スコープ仮決め(20分)
5. 検証目的(Phase D)としての位置づけ(15分)
6. 次フェーズ(strategy)への申し送り(5分)

---

## 4. 議事内容

### 4.1 apex ハンドオフの確認

`apex-to-dpsai-handoff.yaml`(APX-20260429-001)を delivery-director が読み上げ。
全フィールドが充足していることを確認。

**Shin コメント**: 「自社案件のため apex 役を Shin が兼務する形だが、
スキーマ通りに記録することで他案件と同じワークフロー検証ができる」

### 4.2 AILEAP の事業戦略・3組織アーキテクチャ

studio-director が `docs/architecture.md` を引用し、3組織の役割を再確認:

- **apex-consulting-ai**: 上流戦略コンサル
- **digital-product-studio-ai**(本組織): 中流 Web 制作
- **web-marketing-ai-org / WMAO**: 下流マーケ・継続運用

3組織は受け渡し境界(B-C1: 公開後 30 日 / B-C2: 初期 10 記事)を持つ。

**strategy-director コメント**: 「v2 サイトでは 3 組織連携をクライアントに分かりやすく
伝える必要がある。「AI Native」「同等品質を半額」「WCAG + GEO 標準装備」を 3 本柱で訴求」

### 4.3 既存サイトの課題棚卸し

seo-geo-strategist が `aileap-hazel.vercel.app` を分析:

| 観点 | 課題 | 重要度 |
|---|---|---|
| 情報量 | 1 ページ LP 相当、サービス・実績・採用が不在 | 高 |
| SEO | 構造化データなし、メタ description が短い | 高 |
| GEO | llms.txt 未配置、FAQPage なし | 高 |
| アクセシビリティ | 一部のコントラスト比が AA 未達 | 中 |
| ブランド | 「AI Native」訴求が弱い | 高 |
| 採用 | 採用ページなし | 中 |

**Shin コメント**: 「すべて改善対象。A1 として本格化する方針で進めて欲しい」

### 4.4 v2 の方針・スコープ

ux-strategy-lead がスコープ案を提示:

- **案件タイプ**: A1 コーポレートサイト
- **ページ数**: 11 ページ(トップ / about / services / works / careers / contact / blog 一覧 / blog 詳細 / blog category / privacy / terms)
- **CMS**: microCMS(Headless 検証も兼ねる)
- **言語**: ja のみ(en は v0.3 で別案件として検証)
- **多言語スコープ**: i18n-strategy.md は将来の en 化準備として作成
- **特商法ページ**: 任意(商品販売なしのため)

content-strategy-lead がコンテンツ戦略案:

- **4柱**:
  1. 業界専門性(AI 活用 Web 制作・GEO 解説等)
  2. ハウツー(中小企業 DX 失敗パターン等)
  3. 実績(検証案件として AILEAP 自社改修ストーリーを記事化)
  4. 採用・カルチャー(エンジニア紹介)
- **初期記事**: 7 本(B-C2 上限 10 から検証スコープ縮小)

**Shin 決定事項**:
- 案件タイプ A1 で確定 → DEC-001
- 多言語(en)は本案件スコープ外 → DEC-002
- 内部見積モード採用 → DEC-003
- 法務 3 点の確認方針 → DEC-004
- 初期記事 7 本に縮小 → DEC-005

### 4.5 検証目的(Phase D)としての位置づけ

studio-director が検証観点を整理:

1. **エージェント起動率**: 21体中 18 体以上(target)
2. **スキル発火率**: 28 個中 22 個以上(target)
3. **hook 動作**: 8 個全件
4. **テンプレート利用**: 21 個中 18 個以上
5. **発見 gap**: 10 件以上を `validation-notes.md` に記録
6. **言語ポリシー**: Layer 1/2/3 分離が現実的に維持されるか
7. **承認ゲート**: approvals.yaml がフェーズ進行をゲートするか

**Shin コメント**: 「サイトとしての成功と、検証としての成功を両立させたい。
ただし、検証結果が悪くてもそれは v0.2 の限界として gap-analysis-v0.2.md に書けばよい」

### 4.6 次フェーズへの申し送り

ux-strategy-lead を次フェーズの主担当として、以下の 1 週間で完成させる:

- 競合分析(5社)
- ペルソナ設計(2-3名)
- サイトマップ v1
- コンテンツ戦略 v1
- 要件定義 v1

その後 art-direction-lead に Phase 2 を引き継ぐ。

---

## 5. 決定事項

| # | 決定内容 | 決定者 | 関連 DEC |
|---|---|---|---|
| 1 | 案件タイプを A1 に確定 | Shin + studio-director | DEC-001 |
| 2 | 多言語(en)を本案件スコープ外に | Shin + strategy-director + localization-specialist | DEC-002 |
| 3 | commercial-manager を internal mode で動作 | Shin + commercial-manager | DEC-003 |
| 4 | 法務 3 点の弁護士確認方針 | Shin + delivery-director | DEC-004 |
| 5 | 初期記事を 7 本に縮小 | Shin + content-strategy-lead | DEC-005 |
| 6 | apex ハンドオフ受領完了 | delivery-director | (apex-to-dpsai-handoff.yaml に記録) |

---

## 6. アクションアイテム

| # | 内容 | 担当 | 期限 | 状態 |
|---|---|---|---|---|
| AI-001 | 競合 Web サイト分析(5社)実施 | content-strategy-lead | 2026-05-03 | 未着手 |
| AI-002 | ペルソナ設計(2-3名) | ux-strategy-lead | 2026-05-03 | 未着手 |
| AI-003 | サイトマップ v1 作成 | ux-strategy-lead | 2026-05-05 | 未着手 |
| AI-004 | コンテンツ戦略 v1 作成 | content-strategy-lead | 2026-05-06 | 未着手 |
| AI-005 | 要件定義 v1 起案 | ux-strategy-lead | 2026-05-06 | 未着手 |
| AI-006 | 内部見積 v1(参考値) | commercial-manager | 2026-05-03 | 未着手 |
| AI-007 | assets-required.yaml の各素材担当割当 | client-success-lead | 2026-04-30 | 未着手 |
| AI-008 | i18n-strategy.md 作成(将来 en 化準備) | localization-specialist | 2026-05-06 | 未着手 |
| AI-009 | validation-notes.md 初期化 | client-success-lead | 2026-04-30 | 未着手 |
| AI-010 | Shin 弁護士事務所選定開始 | Shin | 2026-05-13 | 未着手 |

---

## 7. 保留事項(Parking Lot)

- 多言語対応(en) → v0.3 で検証案件として独立(DEC-002)
- メディアサイト化(A3)転換 → 公開後 6 ヶ月で再評価
- B 系プロダクト連携(MeetingAI 等)→ v0.3 以降
- A4 大規模リブランド → 不要(現状は A1 で十分)

---

## 8. 次回会議

| 項目 | 内容 |
|---|---|
| 会議名 | 戦略フェーズ完了 + デザイン着手判定 |
| 開催日時 | 2026-05-06(水) 14:00-15:00(暫定) |
| 場所 | AILEAP 内部 |
| アジェンダ | 要件定義 v1 確認 / サイトマップ確認 / コンテンツ戦略確認 / デザイン着手判定 |
| 必要参加者 | Shin / delivery-director / ux-strategy-lead / content-strategy-lead / art-direction-lead |

---

## 9. 検証メモ(Phase D 特有)

本キックオフで検証された項目:

- ✅ apex-to-dpsai-handoff.yaml の全フィールドが充足された
- ✅ studio-director / delivery-director / strategy-director の階層構造が機能
- ✅ DEC-001 ～ DEC-005 が decisions.yaml に正しく記録された
- ✅ 言語ポリシー Layer 1(議事録 = 日本語)が維持された
- ⚠️ /client-onboarding スキルの自動起動は未検証(手動でフロー再現)
- ⚠️ apex ハンドオフ受領 hook(あれば)の動作未確認

→ validation-notes.md AI-009 で順次追記。

---

**議事録作成**: client-success-lead
**作成日**: 2026-04-29 13:30
**Version**: 1.0(final)
