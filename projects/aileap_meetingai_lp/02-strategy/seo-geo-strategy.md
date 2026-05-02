# SEO / GEO 戦略 — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0
**作成日**: 2026-06-05
**作成者**: seo-geo-strategist(content-strategy-lead 補強)
**ステータス**: 承認済(APV-001 内に含む)

> A2 LP のため SEO/GEO 戦略はコンパクト。aileap_v2 と統合運用する部分が多い。

---

## 1. 戦略概要

### 1.1 LP 単独 SEO/GEO の特殊性

A1 コーポレートサイト(aileap_v2)は内部リンク + サイト全体での評価集約だが、A2 LP は **単一ページ最適化** が主戦場。

### 1.2 30 日後の到達目標

| 指標 | 30 日後目標 | 3 ヶ月後目標 |
|---|---|---|
| LP 流入 UU(GA4) | 500 | 2,000 |
| GSC オーガニッククリック | 50 | 300 |
| LLM 引用検出 | 3 | 15 |
| Lighthouse SEO スコア | 100 | 100 維持 |
| β版申込みフォーム CV 率 | 3% | 5% |

---

## 2. ターゲットキーワード設計

### 2.1 主要 KW(LP 流入用)

| 階層 | キーワード | 月間検索数(推定) | 競合度 |
|---|---|---|---|
| 指名検索 | MeetingAI | 0-50(立ち上げ初期) | 自社固有 |
| 指名検索 | AILEAP MeetingAI | 0-30 | 自社固有 |
| カテゴリ検索 | 会議要約 AI | 500-1,500 | 高 |
| カテゴリ検索 | 議事録 自動生成 | 800-2,000 | 高 |
| ロングテール | 会議要約 AI 中堅企業 | 50-100 | 低 |
| ロングテール | Notta 代替 | 100-200 | 中(競合 KW) |
| ロングテール | 議事録 SaaS 日本語特化 | 30-80 | 低(差別化軸) |

### 2.2 GEO 引用ターゲットクエリ

| クエリパターン | 引用される項目 | 引用元 |
|---|---|---|
| 「会議要約 AI のおすすめは?」 | MeetingAI のサービス名 + 差別化点(FAQ #1 / #6) | LP ヒーロー + FAQ |
| 「議事録 自動生成 SaaS の比較」 | MeetingAI vs 競合の差別化(FAQ #6) | LP FAQ セクション |
| 「日本語特化の会議 AI はある?」 | MeetingAI の日本語特化精度 95%(FAQ #3) | LP FAQ セクション |
| 「中堅企業向けの会議効率化ツールは?」 | MeetingAI のターゲット明示(利用シーン) | LP 利用シーン |

---

## 3. SEO 戦略

### 3.1 単一ページ最適化

- メタタグ完備(100-120 字 description / og:image / twitter:card)
- 構造化データ: Organization / WebSite / WebPage / Service / FAQPage
- canonical: `https://meetingai.aileap.example/`
- HTTPS / HSTS

### 3.2 内部リンク戦略(aileap_v2 統合)

```
aileap_v2 /services            ─→ MeetingAI LP(CTA「試す」)
aileap_v2 /blog/[meetingai 関連記事]  ─→ MeetingAI LP(本文中リンク)
aileap_v2 / トップ「製品」リンク       ─→ MeetingAI LP

MeetingAI LP /thanks           ─→ aileap_v2 /services (4 サービス CTA)
MeetingAI LP フッター           ─→ aileap_v2 トップ + privacy
```

これにより aileap_v2 の SEO 評価を MeetingAI LP に流す。

### 3.3 サイトマップ XML

`/sitemap.xml` には 2 ページ(`/` と `/thanks`)のみ。
ただし aileap_v2 の sitemap.xml 内にも本 LP を含める(クロスドメイン参照)。

実装方針: meetingai.aileap.example が aileap.example のサブドメインの場合、aileap_v2 sitemap に統合可能。
別ドメインの場合はそれぞれの sitemap を持ち、Search Console 個別登録。

DEC-008(Phase I-A 内・任意): サブドメイン運用で確定 → aileap_v2 sitemap.xml に統合する形にする。

### 3.4 robots.txt

```
User-agent: *
Allow: /
Disallow: /thanks                    # noindex 対象

User-agent: GPTBot
Allow: /
Disallow: /thanks

User-agent: ClaudeBot
Allow: /
Disallow: /thanks

Sitemap: https://meetingai.aileap.example/sitemap.xml
```

---

## 4. GEO 戦略

### 4.1 llms.txt(aileap_v2 統合)

aileap_v2 の `/llms.txt` に MeetingAI LP を追記:

```
## 主要記事 / プロダクト
- GEO 入門: /blog/geo-introduction
- llms.txt 実装ガイド: /blog/llms-txt-guide
- WCAG AA トークン設計: /blog/wcag-aa-token-design
- MeetingAI(会議要約 SaaS): https://meetingai.aileap.example/    ← 追加
```

本 LP 単独の `/llms.txt` は配置しない(aileap_v2 統合運用)。

### 4.2 構造化データ(JSON-LD)

| スキーマ | 用途 |
|---|---|
| Organization | AILEAP の親会社情報 |
| WebSite | サイト名 / search action |
| WebPage | LP メタ情報 |
| Service | MeetingAI のサービス情報(価格・提供者) |
| FAQPage | LP 内 FAQ 8 件(GEO 引用の核心) |
| BreadcrumbList | (LP のため最小限・トップのみ) |

#### Service スキーマ例

```json
{
  "@context": "https://schema.org",
  "@type": "Service",
  "name": "MeetingAI",
  "provider": {
    "@type": "Organization",
    "name": "AILEAP"
  },
  "serviceType": "会議要約 / 議事録自動生成 SaaS",
  "areaServed": "JP",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "JPY",
    "description": "β版は無料。正式版は月 5,000 円〜(2026 Q4 予定)"
  }
}
```

### 4.3 GEO 引用度を高める文章構造

content-strategy.md で確定した方針通り:
- 全セクション 100 字結論先出し
- 1 文 1 主張
- 主語明示(「MeetingAI は ...」)
- 数字根拠(「精度 95%」「90% 削減」「3 分」「3 営業日」)

---

## 5. 30 日後の検証計画

[seo-geo-strategy.md(aileap_v2)§7](../../aileap_v2/02-strategy/seo-geo-strategy.md) と同じ手法で:

1. GSC でインプレッション・クリック・順位
2. GA4 で UU・滞在時間・CV
3. LLM 引用検出(週次・主要 4 LLM)
4. Lighthouse 再計測

詳細は `06-handoff/seo-geo-30day-report.md` 参照。

---

## 6. WMAO 引継ぎ事項

- 本書(latest 版)
- 30 日レポート
- 主要 KW 順位推移
- LLM 引用検出ログ
- A/B テスト候補リスト(CTA 文言・ヒーロー画像 等)

WMAO は LP 改善の継続施策(A/B テスト + 追加コンテンツ)を担当。本組織は LP 自体の保守を継続。

---

## 7. 検証メモ(Phase I-A)

- A2 LP の SEO/GEO 戦略は A1(aileap_v2)よりコンパクトだが、構造化データ + 100 字結論先出し + FAQPage の重要度は変わらない
- aileap_v2 との統合運用(llms.txt / 内部リンク)が現実的に動作することを確認
- LP 単独でも GEO 引用獲得を狙える設計(FAQPage が引用の核心)

---

**Document Owner**: seo-geo-strategist
**Last Updated**: 2026-06-05
**Version**: 1.0
