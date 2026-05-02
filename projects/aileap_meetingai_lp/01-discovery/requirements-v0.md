# 要件定義書 v0 — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**バージョン**: v0(初期草案)
**作成日**: 2026-06-02
**作成者**: client-success-lead(A2 では UX 系兼任)
**ステータス**: 承認済(APV-001 / 2026-06-05)

---

## 1. プロジェクト目的

### 1.1 ビジネスゴール(KGI)

公開後 3 ヶ月以内に **MeetingAI β版申込み件数 50 件** を達成する。

### 1.2 主要 KPI

| 指標 | 現状 | 目標 | 計測方法 |
|---|---|---|---|
| LP 流入 UU | 0 | 月 2,000 | GA4 |
| β版申込みフォーム CV 率 | — | 5%(月 100 件) | GA4 イベント |
| 平均ページ滞在時間 | — | 60 秒以上 | GA4 |
| LLM 引用検出 | — | 公開後 14 日で 3 件 | 手動モニタリング |

### 1.3 想定読者・ターゲット

- **主読者**: 中堅企業(従業員 50-300 名)の経営企画 / バックオフィス
  - 課題: 会議メモの工数、議事録共有の遅さ
  - 検索行動: 「会議要約 AI」「議事録自動生成」「Notta 代替」
- **副読者**: 個人事業主・スタートアップ初期メンバー(10 名以下)
  - 課題: 会議録音はあるが整理する時間がない
- **想定流入元**:
  - aileap_v2 → `/services` → MeetingAI LP(35%)
  - オーガニック検索(40%)
  - LLM 引用経由(15%)
  - 直接訪問(10%)

---

## 2. スコープ

### 2.1 対象範囲

- 案件タイプ: A2 ランディングページ
- ページ数: **2 ページ**(LP 本体 / thank you ページ)
- 主要機能:
  - β版申込みフォーム(name / email / company / 利用規模 / 同意)
  - お問い合わせ CTA(aileap_v2 contact ページへリンク)
  - LP 内 FAQ(GEO 引用最適化)
- 言語: ja のみ
- レスポンシブ: PC / タブレット / SP

### 2.2 対象外

- 多言語(en)対応(MeetingAI 国内開始)
- ブログ機能
- ユーザー登録 / ログイン(β版はメール経由でアクセス案内)
- 決済機能(β版は無料)

---

## 3. 機能要件

### 3.1 ページ一覧

| # | ページ名 | URL | 主目的 | 主要 CTA |
|---|---|---|---|---|
| 1 | LP 本体 | `/` | β版申込み獲得 + プロダクト訴求 | β版申込みフォーム |
| 2 | thank you | `/thanks` | 申込み完了 + 次アクション提示 | aileap_v2 サービス紹介 |

LP 本体のセクション構成:

1. ヒーロー(コアメッセージ + 主要 CTA)
2. 課題提起(会議の工数問題)
3. ソリューション(MeetingAI の機能)
4. 主要機能 3 つ(録音 → 要約 / 議事録共有 / 検索)
5. 利用シーン(中堅企業 / スタートアップ)
6. β版特典(無料 + 早期割引案内)
7. FAQ(8 件・GEO 観点)
8. β版申込みフォーム(再 CTA)
9. フッター(AILEAP リンク + プライバシーポリシー)

### 3.2 フォーム要件

| フィールド | 必須 | 検証 |
|---|---|---|
| 氏名 | ✅ | 1-100 字 |
| 会社名 | 任意 | 1-200 字 |
| メールアドレス | ✅ | 形式チェック |
| 利用規模 | ✅ | 4 区分(1-10 / 11-50 / 51-300 / 300+) |
| 利用目的(自由記述) | 任意 | 0-500 字 |
| プライバシーポリシー同意 | ✅ | チェックボックス必須 |
| reCAPTCHA v3 | ✅ | スコア 0.5 以上 |

送信後: thank you ページへリダイレクト + Resend で AILEAP 内部に通知メール。

### 3.3 CMS

LP は静的(microCMS 不使用)。コピーは Next.js の messages/ja.json で管理。
将来 microCMS 化する場合は別案件として実施。

---

## 4. 非機能要件

### 4.1 パフォーマンス

- Lighthouse Performance: 95+(LP は Lighthouse スコアが命)
- LCP: 2.0 秒以内
- CLS: 0.05 以下
- 画像: WebP / AVIF 標準

### 4.2 アクセシビリティ

- WCAG 2.2 Level AA 準拠(aileap_v2 design-system 継承)

### 4.3 SEO / GEO

- Lighthouse SEO: 100
- 構造化データ: Organization / WebSite / WebPage / FAQPage / Service
- llms.txt は aileap_v2 と統合(本 LP も `/llms.txt` で言及)
- メタディスクリプション 100-120 字(結論先出し)

### 4.4 セキュリティ

- HTTPS 必須(HSTS 有効)
- フォームに reCAPTCHA v3
- 環境変数で API キー管理

---

## 5. デザイン要件

### 5.1 トーン・キーワード

- ブランドキーワード:
  - **会議の生産性を 2 倍に**(プロダクト訴求)
  - **AILEAP の AI Native 技術**(信頼性訴求)
  - **β版無料**(申込み誘導)
- トーン:
  - 信頼感(企業向け)
  - 直接的(LP 特性 — 装飾を抑える)
  - 親しみやすさ(技術用語の咀嚼)

### 5.2 デザインシステム

`aileap_v2/03-design/design-system.md` を継承。差分は `03-design/design-notes.md` に記録。

### 5.3 提供素材

`00-engagement/assets-required.yaml` 参照。8 件すべて受領済。

---

## 6. 制約事項

- aileap_v2 と同じスタック(Next.js 14 + Vercel + Resend)
- 公開期日 2026-06-30 必達(MeetingAI β版開始タイミングに合わせる)
- 自社案件のため Shin がクライアント役

---

## 7. 進行計画

| フェーズ | 期間 | 主成果物 |
|---|---|---|
| Engagement | 2026-06-01 ~ 06-02(2 日) | apex-handoff / requirements / 見積 |
| Strategy | 2026-06-03 ~ 06-05(3 日) | sitemap / content-strategy / seo-geo |
| Design | 2026-06-06 ~ 06-10(5 日) | design-notes(差分) |
| Implementation | 2026-06-11 ~ 06-22(2 週) | 実装 + フォーム |
| QA | 2026-06-23 ~ 06-25(3 日) | 3 audit |
| Launch | 2026-06-26 ~ 06-30 | 公開 |
| Post-Launch | 2026-07-01 ~ 07-30(30 日) | SEO/GEO 検証 + WMAO 引継ぎ準備 |

---

## 8. 想定リスクと対応

| リスク | 影響 | 対応 |
|---|---|---|
| MeetingAI β版開始タイミングの遅延 | LP 公開後にプロダクト未提供 | β版開始は LP 公開と同時(6/30 同日) |
| aileap_v2 デザイン継承での視覚不調和 | UX 品質低下 | art-direction-lead 主導で差分検証 |
| LP 単発で SEO 流入が薄い | KPI 未達 | aileap_v2 から内部リンク強化(`/services` から CTA) |

---

## 9. 別添

- `00-engagement/apex-to-dpsai-handoff.yaml`
- `00-engagement/estimate.yaml`
- `00-engagement/sow.md`
- `00-engagement/assets-required.yaml`
- `00-engagement/legal-review.yaml`
- `01-discovery/onboarding-notes.md`
- `aileap_v2/03-design/design-system.md`(継承元)

---

**Document Owner**: client-success-lead
**Last Updated**: 2026-06-02
**Version**: v0
**承認**: APV-001(2026-06-05 / Shin)
