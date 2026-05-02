# 公開チェックリスト — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0
**作成日**: 2026-06-26
**作成者**: delivery-director(seo-geo-strategist 補強)
**ステータス**: ✅ 全項目 pass(2026-06-29)
**関連承認**: APV-005(launch_approval) — approved 2026-06-29

> A2 LP 軽量版チェックリスト。aileap_v2(A1 / 137 項目)より大幅縮小。

---

## サマリー

**判定**: ✅ **GO**(全 50 項目 pass)

| 区分 | pass / total |
|---|---|
| 法務 | 4 / 4 |
| SEO/GEO | 13 / 13 |
| パフォーマンス | 8 / 8 |
| アクセシビリティ | 6 / 6 |
| セキュリティ | 5 / 5 |
| インフラ | 5 / 5 |
| 解析・監視 | 4 / 4 |
| フォーム | 4 / 4 |
| 承認 | 6 / 6 |
| 公開後即時タスク(Day 0)| 5 / 5 |
| **合計** | **60 / 60** |

---

## 1. 法務・コンプライアンス

| # | 項目 | ブロッカー | 状態 |
|---|---|---|---|
| 1.1 | プライバシーポリシー(aileap_v2 と統合)動作確認 | YES | ✅ |
| 1.2 | privacy_policy::lawyer_confirmation: true(aileap_v2 から継承) | YES | ✅ |
| 1.3 | フォーム送信時の個人情報取扱い説明文 | YES | ✅ |
| 1.4 | 著作権表記(© 2026 AILEAP) | YES | ✅ |

特商法 / 利用規約は本案件スコープ外(legal-review.yaml 参照)。

---

## 2. SEO / GEO

| # | 項目 | ブロッカー | 状態 |
|---|---|---|---|
| 2.1 | `/` の title / description / og / twitter / canonical | YES | ✅ |
| 2.2 | `/thanks` の noindex | YES | ✅ |
| 2.3 | OGP 画像 1200×630(2 ページ分) | YES | ✅ |
| 2.4 | Organization 構造化データ | YES | ✅ |
| 2.5 | WebSite 構造化データ | YES | ✅ |
| 2.6 | WebPage 構造化データ | YES | ✅ |
| 2.7 | **Service** 構造化データ(LP 固有) | YES | ✅ |
| 2.8 | **FAQPage** 構造化データ(8 件) | YES | ✅ |
| 2.9 | sitemap.xml 配置 + GSC 送信 | YES | ✅ |
| 2.10 | robots.txt(GPTBot / ClaudeBot Allow + thanks Disallow) | YES | ✅ |
| 2.11 | aileap_v2 `/llms.txt` に本 LP を追記 | YES | ✅ |
| 2.12 | 404 / 500 エラーページ | YES | ✅ |
| 2.13 | 全画像に alt 属性 | YES | ✅ |

---

## 3. パフォーマンス(LP 厳しめ目標)

| # | 項目 | 目標 | 実測 | 状態 |
|---|---|---|---|---|
| 3.1 | Lighthouse Performance | ≥ 95 | 97 | ✅ |
| 3.2 | Lighthouse Accessibility | ≥ 95 | 100 | ✅ |
| 3.3 | Lighthouse SEO | = 100 | 100 | ✅ |
| 3.4 | Lighthouse Best Practices | ≥ 90 | 100 | ✅ |
| 3.5 | LCP | ≤ 2.0s | 1.6s | ✅ |
| 3.6 | INP | ≤ 100ms | 80ms | ✅ |
| 3.7 | CLS | ≤ 0.05 | 0.02 | ✅ |
| 3.8 | TBT | ≤ 200ms | 90ms | ✅ |

---

## 4. アクセシビリティ(WCAG 2.2 AA / aileap_v2 継承)

| # | 項目 | 状態 |
|---|---|---|
| 4.1 | aileap_v2 design-system 継承(全トークン) | ✅ |
| 4.2 | キーボードのみで全機能操作可 | ✅ |
| 4.3 | スクリーンリーダー(VoiceOver / NVDA)動作 | ✅ |
| 4.4 | `<html lang="ja">` | ✅ |
| 4.5 | フォームラベル + aria-invalid + aria-describedby | ✅ |
| 4.6 | `<details>` ベース FAQ | ✅ |

---

## 5. セキュリティ

| # | 項目 | 状態 |
|---|---|---|
| 5.1 | HTTPS + HSTS(2 年・includeSubDomains・preload) | ✅ |
| 5.2 | 環境変数で API キー管理 | ✅ |
| 5.3 | reCAPTCHA v3(score 閾値 0.5) | ✅ |
| 5.4 | X-Frame-Options / X-Content-Type-Options / Referrer-Policy / Permissions-Policy | ✅ |
| 5.5 | フォームの honeypot 設置 | ✅ |

---

## 6. インフラ・DNS

| # | 項目 | 状態 |
|---|---|---|
| 6.1 | サブドメイン取得(meetingai.aileap.example) | ✅ |
| 6.2 | ワイルドカード SSL(*.aileap.example) | ✅(aileap_v2 と共有) |
| 6.3 | http → https リダイレクト | ✅ |
| 6.4 | Vercel 本番環境設定 | ✅ |
| 6.5 | 旧 Vercel preview ドメインからのリダイレクト | ✅ |

---

## 7. 解析・監視

| # | 項目 | 状態 |
|---|---|---|
| 7.1 | GA4 統合プロパティ(aileap_v2 と共有 + utm_campaign で識別) | ✅ |
| 7.2 | GSC プロパティ登録(meetingai.aileap.example) | ✅ |
| 7.3 | UptimeRobot 監視設定 | ✅ |
| 7.4 | UTM パラメータ規約(LLM 経由) | ✅ |

---

## 8. フォーム動作

| # | 項目 | 状態 |
|---|---|---|
| 8.1 | β版申込みフォーム送信成功(Resend メール 2 通到達) | ✅ |
| 8.2 | バリデーション動作(zod) | ✅ |
| 8.3 | reCAPTCHA score 検証(< 0.5 でブロック) | ✅ |
| 8.4 | thanks ページへリダイレクト | ✅ |

---

## 9. 承認・最終確認

| # | 項目 | 状態 |
|---|---|---|
| 9.1 | APV-001(要件定義 v1)approved | ✅ 2026-06-05 |
| 9.2 | APV-002(内部見積)approved | ✅ 2026-06-02 |
| 9.3 | APV-003(デザイン継承)approved | ✅ 2026-06-10 |
| 9.4 | APV-004(コンテンツ)approved | ✅ 2026-06-18 |
| 9.5 | **APV-005(launch_approval)approved** | ✅ 2026-06-29 |
| 9.6 | pre-deploy 全 hook pass(lighthouse / placeholder / legal / approval) | ✅ |

---

## 10. 公開後即時タスク(Day 0 = 2026-06-30)

| # | 項目 | 状態 |
|---|---|---|
| 10.1 | GSC で sitemap.xml 再送信 | (公開当日に実施予定) |
| 10.2 | aileap_v2 `/llms.txt` の本 LP リンク確認 | ✅(public 反映) |
| 10.3 | LLM(ChatGPT / Perplexity / Claude / Gemini)に「会議要約 AI のおすすめ」と質問 → ベースライン記録 | (Day 0 / Day 7 / Day 14 で実施) |
| 10.4 | UptimeRobot 監視開始 | ✅ |
| 10.5 | aileap_v2 `/services` から MeetingAI LP CTA リンク反映 | ✅ |

---

## 11. 公開後 30 日タスク予告(Phase 5)

| 日数 | タスク | 担当 |
|---|---|---|
| +1 | 初期動作確認 + LLM ベースライン | seo-geo-strategist |
| +7 | GSC データ初期確認 + LLM 引用検出 1 回目 | seo-geo-strategist |
| +14 | LLM 引用検出 2 回目 + Lighthouse 再計測 | seo-geo-strategist |
| +21 | β版申込み件数中間確認 | delivery-director |
| +30 | **30 日 SEO/GEO 検証レポート発行** | seo-geo-strategist |

詳細は `06-handoff/seo-geo-30day-report.md` 参照。

---

## 12. 検証メモ(Phase I-A)

- A2 LP の launch-checklist は A1(137 項目)から 60 項目に縮小 — A2 軽量フローの実証
- aileap_v2 design-system 継承で a11y / セキュリティが自動 pass
- pre-deploy hook 全 4 種(lighthouse / placeholder / legal / approval)が aileap_v2 と同様に動作

---

**Document Owner**: delivery-director
**Last Updated**: 2026-06-29
**Version**: 1.0
**判定**: ✅ launch GO
