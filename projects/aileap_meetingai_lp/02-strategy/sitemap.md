# サイトマップ — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0
**作成日**: 2026-06-03
**作成者**: client-success-lead(A2 では UX 系兼任)
**ステータス**: 承認済(APV-001 内に含む)

> A2 LP のため非常に簡素なサイトマップ(2 ページのみ)。
> 詳細は requirements-v0.md §3.1 参照。

---

## 1. ページ構成(2 ページ)

```
[流入元]
  ├─ aileap_v2 /services → CTA「MeetingAI を試す」
  ├─ オーガニック検索(GSC)
  ├─ LLM 引用(ChatGPT / Perplexity)
  └─ 直接訪問
       ↓
   ┌─────────────────────────────┐
   │  /                          │  ← LP 本体(申込みフォーム含む)
   │  (MeetingAI 紹介 LP)        │
   └────────────┬────────────────┘
                │  フォーム送信成功
                ▼
   ┌─────────────────────────────┐
   │  /thanks                    │  ← 申込み完了ページ
   │  (next steps + AILEAP CTA)  │
   └─────────────────────────────┘
                │
                └─→ aileap_v2(関連サービス紹介)
```

## 2. ページ詳細

### 2.1 `/`(LP 本体)

| 項目 | 内容 |
|---|---|
| URL | `https://meetingai.aileap.example/` |
| 主目的 | β版申込み獲得 |
| メイン KPI | フォーム CV 率 5%、平均滞在 60 秒以上 |
| SEO 重要度 | ★★★★★ |
| GEO 重要度 | ★★★★★(FAQPage 構造化データ + 100 字結論先出し) |
| 構造化データ | Organization, WebSite, WebPage, Service, FAQPage |
| 主要セクション | 9 セクション(requirements-v0 §3.1) |
| 推定文字数 | 1,500-2,000 字 |

### 2.2 `/thanks`(thank you ページ)

| 項目 | 内容 |
|---|---|
| URL | `https://meetingai.aileap.example/thanks` |
| 主目的 | 申込み完了 + 次アクション提示 |
| メイン KPI | aileap_v2 への遷移率 30% |
| SEO 重要度 | ★(noindex 設定) |
| GEO 重要度 | — |
| 構造化データ | WebPage |
| 主要セクション | 完了メッセージ / next steps / aileap_v2 関連サービス CTA |
| 推定文字数 | 300-500 字 |

## 3. URL 命名規則(aileap_v2 と整合)

- 小文字英数字・ハイフン区切り
- 末尾スラッシュなし
- 動的セグメントなし(LP は静的のみ)

## 4. ナビゲーション設計

LP のため最小ナビ:

### 4.1 ヘッダー

```
[AILEAP ロゴ]                    [→ AILEAP 公式サイト(aileap_v2)]
                                 [β版申込み(CTA ボタン)]
```

### 4.2 フッター(最小)

```
[AILEAP コーポレート]  [プライバシーポリシー(aileap_v2 と統合)]  [© 2026 AILEAP]
```

A1(aileap_v2)のような豊富なフッターは LP では不要。

### 4.3 LP 内アンカーナビ

LP 内のスクロール誘導用にアンカーリンク:

```
[ヒーロー] → [課題] → [機能] → [β版特典] → [FAQ] → [申込みフォーム]
```

## 5. SEO/GEO 戦略との整合

### 5.1 SEO

- 単一ページ最適化(LP のため内部リンク戦略は限定的)
- aileap_v2 からの被リンク獲得(`/services` ページから「MeetingAI」CTA 経由)
- llms.txt は aileap_v2 と統合(本 LP も `https://aileap.example/llms.txt` で言及)

### 5.2 GEO

- FAQPage 構造化データ(LP 内 FAQ 8 件)
- 100 字結論先出し徹底
- `/llms.txt` で「主要記事」セクションに本 LP を追加

## 6. 公開後の拡張計画

### 6.1 v0.4 で検討

- en 化(MeetingAI 海外展開時)
- ブログ記事連動(`/blog/meetingai-tutorial` 等を aileap_v2 側で増やす)
- 比較表ページ(競合 SaaS との比較)

### 6.2 別案件で実施

- A/B テスト導入(LP 改善施策)
- ウェビナー連動 LP

## 7. 検証メモ(Phase I-A)

A2 軽量フローのサイトマップは aileap_v2(11 ページ・3 階層)と比べて極端に小さい(2 ページ・1 階層)。
ux-strategy-lead 不在で client-success-lead が UX 系を兼任しても破綻なく作成可能 — A2 で UX 専任不要が実証された。

---

**Document Owner**: client-success-lead
**Last Updated**: 2026-06-03
**Version**: 1.0
