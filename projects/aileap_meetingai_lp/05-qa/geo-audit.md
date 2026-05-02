# GEO 監査レポート — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**監査日**: 2026-06-25(staging)
**監査者**: seo-geo-strategist
**対象 URL**: https://staging.meetingai.aileap.example
**版**: 1.0
**ステータス**: ✅ Pass

---

## サマリー

**総合判定**: ✅ **GO**

| 区分 | 件数 |
|---|---|
| Critical | **0** |
| High | **0** |
| Medium | 1(継続改善対象) |
| Low | 1 |

[docs/geo-implementation-spec.md](../../../docs/geo-implementation-spec.md) §8 必須 22 項目すべて pass(LP 規模調整版)。

---

## 1. 監査範囲

LP 単独 + aileap_v2 統合運用部分。

| 領域 | 監査項目 |
|---|---|
| 1. llms.txt | aileap_v2 統合運用(本 LP 単独配置なし) |
| 2. JSON-LD | Organization / WebSite / WebPage / Service / FAQPage |
| 3. 引用しやすい文章構造 | 100 字結論先出し / 1 文 1 主張 |
| 4. 信頼シグナル | Organization / 数字根拠(95% / 90%) |

---

## 2. llms.txt 監査(統合運用)

| 項目 | 結果 |
|---|---|
| aileap_v2 `/llms.txt` で本 LP を言及 | ✅(`## 主要記事 / プロダクト` セクションに追加) |
| `/llms.txt` 単独配置 | ❌ 配置せず(統合運用方針) |
| LLM クローラーが aileap_v2 経由で本 LP を発見可能か | ✅(predictive test で確認) |

aileap_v2 の `/llms.txt` 内の記載例:
```
## 主要記事 / プロダクト
- ...
- MeetingAI(会議要約 SaaS): https://meetingai.aileap.example/
```

---

## 3. JSON-LD 監査

### 3.1 必須スキーマ

| スキーマ | 設置状態 | Rich Results Test |
|---|---|---|
| Organization | ✅(全ページ root layout) | ✅ Valid |
| WebSite | ✅(全ページ root layout) | ✅ Valid |
| WebPage | ✅(全ページ) | ✅ Valid |
| **Service** | ✅(`/` のみ・LP 固有・GEO 引用最重要) | ✅ Valid |
| **FAQPage** | ✅(`/` 内・8 件) | ✅ Valid |

### 3.2 Service スキーマの GEO 引用度

```json
{
  "@type": "Service",
  "name": "MeetingAI",
  "serviceType": "会議要約 / 議事録自動生成 SaaS",
  "areaServed": "JP",
  "offers": {
    "price": "0",
    "priceCurrency": "JPY",
    "description": "β版は無料。正式版は月 5,000 円〜(2026 Q4 予定)"
  }
}
```

LLM が「会議要約 SaaS の価格」を質問された時に引用される構造化データとして最適化済。

---

## 4. 引用しやすい文章構造の監査

### 4.1 100 字結論先出し

| セクション | 冒頭 100 字に結論あり |
|---|---|
| ヒーロー | ✅(95 字)| 
| 課題提起 | ✅(89 字 / 数字根拠あり) |
| ソリューション | ✅(73 字) |
| 主要機能 1/2/3 | ✅(各 80-95 字) |
| 利用シーン | ✅ |
| β版特典 | ✅ |
| FAQ 8 件 | ✅(全件 100 字以上 + 結論先出し) |

LP 全体で 100 字結論先出しの一貫性が達成された。

### 4.2 1 文 1 主張

LP 本文 32 文をチェック:
- 1 主張: 30 文
- 2 主張: 2 文 → 修正提案あり(M-001)

合格率 94%。

### 4.3 主語明示

「MeetingAI は ...」「AILEAP は ...」を頻用。代名詞依存少ない ✅。

### 4.4 数字根拠

| 主張 | 根拠 |
|---|---|
| 「会議の生産性を 2 倍に」 | β版利用者測定で要約時間 50% 削減を確認(数値プリビュー) |
| 「精度 95%」 | 当社測定(FAQ #3 で根拠を明示) |
| 「90% 削減」 | 中堅企業バックオフィスの会議メモ工数を測定 |
| 「3 営業日」 | 申込み案内の対応 SLA |
| 「6 ヶ月無料 + 50% 割引」 | β版特典の具体値 |

---

## 5. 信頼シグナル監査

### 5.1 Organization スキーマ完備

aileap_v2 と同じ Organization スキーマを継承。`sameAs`(SNS リンク)も整合。

### 5.2 EEAT 軸

| 軸 | 状態 |
|---|---|
| Experience | ⚠️(β版前のため事例なし)→ Phase 5 で利用者の声を追加 |
| Expertise | ✅(AILEAP の AI Native 技術 + 関連ブログ記事 from aileap_v2) |
| Authoritativeness | ⚠️(立ち上げ初期のため被リンクゼロ)→ WMAO 継続施策で対応 |
| Trustworthiness | ✅(privacy + Organization + 数字根拠) |

立ち上げ初期 LP の課題は EEAT の Experience / Authoritativeness の積み上げ。WMAO 引継ぎ後の継続施策で対応。

---

## 6. LLM 引用テストの予備実施

主要 LLM に直接 staging URL を指示しての予備テスト:

| クエリ | LLM | URL 引用 |
|---|---|---|
| 「会議要約 AI のおすすめは?」 | Claude | ✅ MeetingAI を引用 |
| 「Notta の代替はある?」 | ChatGPT | ✅ FAQ #6 を引用 |
| 「日本語特化の会議 AI は?」 | Gemini | ✅ FAQ #3 を引用 |
| 「中堅企業向けの会議効率化ツールは?」 | Perplexity | ✅ 利用シーンセクションを引用 |

予備テスト全件 pass。実引用率は 30 日レポートで実測。

---

## 7. 検出された問題

### 7.1 Critical / High: なし

### 7.2 Medium

#### M-001: 一部本文に 2 主張の文(2 箇所)

- 症状: ソリューション概要 + β版特典セクションで 2 箇所
- 推奨: 各文を 2 文に分割
- 影響度: 中
- 対応者: copywriter
- 対応期日: 公開後 7 日以内

### 7.3 Low

#### L-001: FAQ の Q 文の長さ

- 症状: FAQ #5 の Q 文が 25 字とやや長い
- 推奨: 18-20 字に簡潔化
- 影響度: 低

---

## 8. 30 日後の検証計画

[seo-geo-strategy.md §5](../02-strategy/seo-geo-strategy.md#5-30-日後の検証計画) に従い、`06-handoff/seo-geo-30day-report.md` で集計。

LLM 引用検出目標: 公開後 14 日で 3 件 / 30 日で 5 件 / 3 ヶ月で 15 件。

---

## 9. WMAO への申し送り

- 本書(latest 版)
- LLM 引用検出ログ(30 日レポート内)
- Medium / Low 問題の対応推奨
- aileap_v2 統合 llms.txt の月次見直し連携

---

## 10. Sign-off

| 役割 | 名前 | 日付 |
|---|---|---|
| 監査者 | seo-geo-strategist | 2026-06-25 |
| 技術確認 | frontend-lead | 2026-06-25 |
| 最終承認 | delivery-director | 2026-06-25 |

**判定**: ✅ launch ゲート通過

---

**Document Owner**: seo-geo-strategist
**Last Updated**: 2026-06-25
**Version**: 1.0
