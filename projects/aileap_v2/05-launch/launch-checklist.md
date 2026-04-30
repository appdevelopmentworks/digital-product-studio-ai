# 公開チェックリスト — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-04-29
**作成者**: delivery-director(seo-geo-strategist 補強)
**ステータス**: 雛形(launch フェーズで確定)
**関連承認**: APV-005(launch_approval) — 公開直前に approved 必須

---

## 概要

公開直前に通すチェックリスト。本ファイルは雛形として discovery フェーズで作成し、
launch フェーズで実値を埋めて Shin の最終承認(APV-005)を受ける。

`pre-deploy-approval-check.sh` が APV-005 の status を確認し、approved でなければ
本番デプロイをブロックする。

---

## 1. 法務・コンプライアンス

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 1.1 | プライバシーポリシー掲載済 | YES | pending |
| 1.2 | プライバシーポリシー `lawyer_confirmation: true` | YES | pending |
| 1.3 | 利用規約掲載判定(任意) | NO | pending |
| 1.4 | 利用規約 `lawyer_confirmation: true`(掲載時) | NO | pending |
| 1.5 | 個人情報保護管理者の氏名・役職を確定 | YES | pending |
| 1.6 | フォーム送信時の個人情報取扱い説明文 | YES | pending |
| 1.7 | Cookie 同意バナー(必要時) | NO | pending |
| 1.8 | 著作権表記(© 2026 AILEAP) | YES | pending |

---

## 2. SEO / GEO

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 2.1 | 全ページに title / description | YES | pending |
| 2.2 | 全ページに canonical URL | YES | pending |
| 2.3 | 全ページに OG タグ + Twitter Card | YES | pending |
| 2.4 | OG 画像(1200×630) — 全主要ページ | YES | pending |
| 2.5 | Organization 構造化データ(全ページ) | YES | pending |
| 2.6 | WebSite 構造化データ(トップ) | YES | pending |
| 2.7 | BreadcrumbList(全階層ページ) | YES | pending |
| 2.8 | FAQPage(サービス詳細・記事) | YES | pending |
| 2.9 | Article(記事詳細) | YES | pending |
| 2.10 | sitemap.xml 配置 + GSC 送信 | YES | pending |
| 2.11 | robots.txt 配置(本番ドメイン用) | YES | pending |
| 2.12 | **llms.txt** 配置(GEO 必須) | YES | pending |
| 2.13 | hreflang(将来 en 用に枠だけ) | NO | pending |
| 2.14 | 404 / 500 エラーページ | YES | pending |
| 2.15 | 全画像に alt 属性 | YES | pending |

---

## 3. パフォーマンス

| # | 項目 | 目標 | 実測 | 状態 |
|---|---|---|---|---|
| 3.1 | Lighthouse Performance(モバイル) | ≥ 90 | — | pending |
| 3.2 | Lighthouse Accessibility | ≥ 95 | — | pending |
| 3.3 | Lighthouse SEO | = 100 | — | pending |
| 3.4 | Lighthouse Best Practices | ≥ 90 | — | pending |
| 3.5 | LCP | ≤ 2.5s | — | pending |
| 3.6 | CLS | ≤ 0.1 | — | pending |
| 3.7 | 画像 WebP/AVIF 化 | 全画像 | — | pending |
| 3.8 | LCP 画像に `fetchpriority="high"` | YES | — | pending |
| 3.9 | フォント `font-display: swap` | YES | — | pending |
| 3.10 | 不要 JS バンドル削減 | — | — | pending |

---

## 4. アクセシビリティ(WCAG 2.2 AA)

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 4.1 | コントラスト 4.5:1 以上(通常テキスト) | YES | pending |
| 4.2 | コントラスト 3:1 以上(大型/UI) | YES | pending |
| 4.3 | キーボードのみで全機能操作可 | YES | pending |
| 4.4 | フォーカスインジケーター可視 | YES | pending |
| 4.5 | 全フォーム入力にラベル | YES | pending |
| 4.6 | 見出し階層スキップなし | YES | pending |
| 4.7 | `<html lang="ja">` 設定 | YES | pending |
| 4.8 | スクリーンリーダー検証(VoiceOver) | YES | pending |
| 4.9 | スクリーンリーダー検証(NVDA) | YES | pending |
| 4.10 | タッチターゲット 44×44px 以上 | YES | pending |
| 4.11 | `prefers-reduced-motion` 対応 | YES | pending |

---

## 5. セキュリティ

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 5.1 | HTTPS 必須(HSTS 有効) | YES | pending |
| 5.2 | 環境変数で API キー管理(コミット禁止) | YES | pending |
| 5.3 | フォーム reCAPTCHA / hCaptcha | YES | pending |
| 5.4 | CSP(Content-Security-Policy)ヘッダ | NO | pending |
| 5.5 | X-Frame-Options / X-Content-Type-Options | YES | pending |
| 5.6 | Referrer-Policy 設定 | NO | pending |

---

## 6. インフラ・DNS

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 6.1 | 本番ドメイン取得(aileap.example) | YES | pending |
| 6.2 | DNS A レコード / CNAME 設定 | YES | pending |
| 6.3 | SSL 証明書(Let's Encrypt 自動更新) | YES | pending |
| 6.4 | www → ルートドメインリダイレクト | YES | pending |
| 6.5 | http → https リダイレクト | YES | pending |
| 6.6 | Vercel 本番環境設定 | YES | pending |
| 6.7 | 旧 vercel ドメインからのリダイレクト | NO | pending |

---

## 7. 解析・監視

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 7.1 | GA4 プロパティ作成 + 設置 | YES | pending |
| 7.2 | Google Search Console プロパティ登録 | YES | pending |
| 7.3 | UptimeRobot 監視設定 | YES | pending |
| 7.4 | Vercel Analytics 有効化 | NO | pending |
| 7.5 | Sentry / エラー追跡(任意) | NO | pending |
| 7.6 | UTM パラメータ(LLM 経由トラッキング) | YES | pending |

---

## 8. CMS

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 8.1 | microCMS 本番環境セットアップ | YES | pending |
| 8.2 | API キー(本番)を環境変数化 | YES | pending |
| 8.3 | カスタムオブジェクト 6 種(services / works / blog / careers / categories / authors) | YES | pending |
| 8.4 | 編集者権限の設定方針(WMAO 引継ぎ準備) | YES | pending |
| 8.5 | 初期コンテンツ投入(7 記事 + 4 サービス + 2 実績) | YES | pending |

---

## 9. コンテンツ

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 9.1 | トップ・会社概要・サービス・採用ページ完成 | YES | pending |
| 9.2 | 初期記事 7 本掲載 | YES | pending |
| 9.3 | 実績 1 件(AILEAP v2 自身) | YES | pending |
| 9.4 | お問い合わせフォーム動作確認 | YES | pending |
| 9.5 | 採用エントリーフォーム動作確認 | YES | pending |
| 9.6 | フォーム送信時の自動返信メール設定 | YES | pending |
| 9.7 | 全コピーが Shin 確認済み | YES | pending |

---

## 10. ブラウザ・デバイス対応

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 10.1 | Chrome 最新2バージョン | YES | pending |
| 10.2 | Edge 最新2バージョン | YES | pending |
| 10.3 | Safari 最新2バージョン | YES | pending |
| 10.4 | Firefox 最新2バージョン | YES | pending |
| 10.5 | iOS Safari 最新2バージョン | YES | pending |
| 10.6 | Android Chrome 最新2バージョン | YES | pending |

---

## 11. 承認・最終確認

| # | 項目 | ブロッキング | 状態 |
|---|---|---|---|
| 11.1 | APV-001 (要件定義 v1) approved | YES | pending |
| 11.2 | APV-002 (内部見積) approved | YES | pending |
| 11.3 | APV-003 (デザインシステム) approved | YES | pending |
| 11.4 | APV-004 (コンテンツ) approved | YES | pending |
| 11.5 | **APV-005 (launch_approval) approved** | YES | pending |
| 11.6 | pre-deploy-approval-check.sh パス | YES | pending |
| 11.7 | Shin 最終 GO サイン | YES | pending |

---

## 12. 公開後の即時タスク(launch+0)

公開当日に実施:

- [ ] GSC で sitemap.xml を再送信
- [ ] llms.txt が `https://example.com/llms.txt` で取得可能か確認
- [ ] 主要 KW で検索して順位確認(後の比較用ベースライン)
- [ ] LLM(ChatGPT / Perplexity)に「AILEAP とは」と質問してベースライン記録
- [ ] UptimeRobot 監視開始通知
- [ ] Slack / メールで関係者(Shin + 全エージェント)に公開完了通知

---

## 13. 検証項目(Phase D 特有)

本案件特有の Phase D 検証項目:

- [ ] **lighthouse-budget.sh** が公開前に正しく動作する
- [ ] **pre-deploy-approval-check.sh** が APV-005 を強制する
- [ ] **session-start hook** が新案件起動時にアクティブ案件を表示する
- [ ] **承認状態が approval-status コマンドで一覧表示できる**
- [ ] **言語ポリシー違反検出 hook**(あれば)が誤検知しない

---

## 14. 公開後 30 日(B-C1 境界)タスク予告

| 日数 | タスク | 担当 |
|---|---|---|
| +1 | 初期動作確認 | seo-geo-strategist |
| +7 | GSC データ初期確認 | seo-geo-strategist |
| +14 | Lighthouse 再測定(本番環境) | seo-geo-strategist |
| +21 | LLM 引用状況確認(ChatGPT / Perplexity) | seo-geo-strategist |
| +30 | **30 日 SEO/GEO 検証レポート発行** | seo-geo-strategist |
| +30 | WMAO 引継ぎ準備(APV-006 起案) | delivery-director |

詳細は `06-handoff/seo-geo-30day-report.md` 参照。

---

**Document Owner**: delivery-director
**Last Updated**: 2026-04-29
**Version**: 1.0(launch フェーズで実値埋め)
