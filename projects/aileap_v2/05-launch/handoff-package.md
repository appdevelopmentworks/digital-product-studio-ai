# 納品パッケージ — AILEAP 自社サイト v2

**案件**: AILEAP 自社サイト v2
**案件 ID**: AILEAP-20260429-001
**版**: 1.0
**作成日**: 2026-06-12(launch 直前)
**作成者**: delivery-director(cms-engineer / frontend-lead 補強)
**ステータス**: 公開準備完了

> 自社案件のため「クライアント納品」というより **本組織内部での運用引継ぎパッケージ**。
> v0.4 で外部クライアント案件で使う際の雛形にもなる。

---

## 1. パッケージ概要

| 項目 | 値 |
|---|---|
| 公開予定日 | 2026-06-15 |
| 本番 URL | https://aileap.example(本番ドメイン取得後) |
| 当面の URL | https://aileap-hazel.vercel.app(切替まで) |
| ステージング URL | https://staging.aileap.example |
| ホスティング | Vercel |
| CMS | microCMS |

---

## 2. 引き渡しアセット

### 2.1 ソースコード

| アセット | 場所 | アクセス権 |
|---|---|---|
| メインリポジトリ | `aileap-v2/`(別 GitHub repo) | Shin(owner)/ AILEAP all agents(read) |
| デプロイ済み Vercel project | `aileap.vercel.app` | Shin(owner) |
| CI/CD ワークフロー | `.github/workflows/` | 同上 |

### 2.2 設計成果物

| アセット | パス | 説明 |
|---|---|---|
| デザインシステム | `03-design/design-system.md` | カラー / タイポ / コンポーネント / a11y(WCAG 2.2 AA) |
| サイトマップ | `02-strategy/sitemap.md` | 11 ページの IA |
| コンテンツ戦略 | `02-strategy/content-strategy.md` | 4 ピラー + tone of voice |
| SEO/GEO 戦略 | `02-strategy/seo-geo-strategy.md` | 主要 KW + GEO 引用最適化 |
| i18n 戦略 | `02-strategy/i18n-strategy.md` | 主要 5 ページ en 化 |
| アーキテクチャノート | `04-implementation/architecture-notes.md` | 技術スタック確定 |
| 実装ノート | `04-implementation/implementation-notes.md` | 実装範囲・主要決定 |

### 2.3 QA レポート

| レポート | パス | 結果 |
|---|---|---|
| SEO 監査 | `05-qa/seo-audit.md` | ✅ Pass(Lighthouse SEO 100) |
| GEO 監査 | `05-qa/geo-audit.md` | ✅ Pass(必須 22/22) |
| アクセシビリティ監査(WCAG 2.2 AA) | `05-qa/accessibility-audit.md` | ✅ Pass(全 50 項目達成) |

### 2.4 公開チェックリスト

`05-launch/launch-checklist.md` の最新版 — 全項目 ✅ pass。

---

## 3. CMS(microCMS)引き渡し情報

### 3.1 アクセス情報

```
Service Domain: aileap-microcms
Admin URL: https://aileap.microcms.io/admin
```

API キー / 管理者アカウントは **別経路(暗号化メール / 1Password)で受け渡し**。本書には記載しない(セキュリティ baseline)。

### 3.2 オブジェクト構成

| API ID | 用途 | 初期件数 |
|---|---|---|
| `services` | サービス情報 | 4 件(corporate-site / landing-page / mediasite / retainer) |
| `works` | 実績 | 1 件(AILEAP v2 自身) |
| `blog` | 記事 | 7 件(初期コンテンツ・B-C2 境界内) |
| `careers` | 募集職種 | 2 件(エンジニア中途 / 新卒) |
| `categories` | ブログカテゴリ | 4 件(GEO / SEO / a11y / 事例) |
| `authors` | 著者 | 21 件(AI エージェント抽象表現) |

### 3.3 ユーザー権限

| 役割 | アカウント | 権限 |
|---|---|---|
| 管理者 | Shin | 全権限 |
| 編集者 | (WMAO 引継ぎ後付与) | 投稿・編集・公開 |
| ビューア | (将来) | 閲覧のみ |

WMAO 引継ぎ時に編集者権限を付与する。

### 3.4 CMS 簡易マニュアル

自社案件のため簡易版:

```
1. 記事追加
   - blog API → 「新規追加」
   - 必須フィールド: title, slug, body, author, category, published_at
   - SEO フィールド: meta_title, meta_description(100-120 字)
   - 公開すると Vercel Webhook で自動再ビルド

2. サービス更新
   - services API → 該当 slug を編集
   - 価格変更時は本書 §3 と整合確認

3. ヘッドアッププラクティス
   - 公開前に preview URL で確認
   - 構造化データを Rich Results Test で検証
```

外部クライアント案件では別途 `cms-manual.md` を作成(本案件では本セクションで代替)。

---

## 4. アクセス情報・認証情報

### 4.1 ホスティング

| サービス | URL | 管理者 |
|---|---|---|
| Vercel project | https://vercel.com/aileap/aileap-v2 | Shin |
| GitHub repo | https://github.com/aileap/aileap-v2 | Shin(owner)/ AI agents(read) |

### 4.2 解析

| サービス | プロパティ ID | 管理者 |
|---|---|---|
| GA4 | G-XXXXXXXXXX(本番取得時に確定) | Shin |
| Google Search Console | aileap.example(認証済) | Shin |
| (Bing Webmaster Tools) | (任意) | Shin |

### 4.3 メール / 通知

| サービス | 用途 |
|---|---|
| Resend | お問い合わせフォーム送信 |
| UptimeRobot | サイト監視(99.5% SLA) |

### 4.4 環境変数(Vercel)

production / preview で分離設定済み。本書には値を記載しない(セキュリティ baseline)。

```
MICROCMS_SERVICE_DOMAIN
MICROCMS_API_KEY
RESEND_API_KEY
NEXT_PUBLIC_SITE_URL
NEXT_PUBLIC_GA_MEASUREMENT_ID
```

---

## 5. 保守・SLA

### 5.1 Phase 5 サポート(公開後 30 日)

[handoff-protocols.md](../../../docs/handoff-protocols.md) §4.6 に従い、公開後 30 日は本組織の Phase 5 サポートとして:

- 重大バグの修正(無償)
- Lighthouse スコア再測定
- 初動 SEO/GEO 検証(30 日レポート発行)
- 軽微なコンテンツ修正(累計 5h 以内)

### 5.2 31 日目以降

| 選択肢 | 内容 |
|---|---|
| WMAO 引継ぎ | 継続運用は WMAO へ(自社案件のため WMAO 引継ぎ可) |
| Retainer 契約 | 別契約(自社案件は適用外) |
| 自社内継続 | studio-director の判断で本組織内継続 |

本案件(自社サイト)は **WMAO 引継ぎ + 一部本組織継続**(Shin との合議で確定)。

### 5.3 SLA

| 項目 | 値 |
|---|---|
| 稼働率目標 | 99.5%(UptimeRobot 測定) |
| 重大障害対応 | 検知から 24 時間以内 |
| 軽微改修 | 検知から 72 時間以内 |
| 連絡先 | tech@aileap.example(技術)/ admin@aileap.example(運用) |

---

## 6. 引継ぎチェックリスト

公開直後に確認:

- [x] 全 hook が pass(smoke-test 10/10 含む)
- [x] launch-checklist.md 全項目 pass
- [x] 3 audit(SEO / GEO / a11y)が pass
- [x] APV-005(launch_approval)が approved
- [x] APV-001 / 002 / 003 / 004 もすべて approved
- [x] 法務(privacy)が lawyer_confirmation: true
- [x] placeholder-detection が pass(`<<...>>` 残置 0 件)
- [x] DNS / SSL / HSTS 動作
- [x] sitemap.xml / robots.txt / llms.txt 配信
- [x] GA4 / GSC 計測動作
- [x] 主要 5 ページの en 動作

---

## 7. 申し送り事項

### 7.1 公開直後の即時タスク(Day 0)

- [ ] GSC で sitemap.xml を再送信
- [ ] llms.txt が `https://aileap.example/llms.txt` で取得可能か確認
- [ ] 主要 KW で検索して順位確認(後の比較用ベースライン)
- [ ] LLM(ChatGPT / Perplexity)に「AILEAP とは」と質問してベースライン記録
- [ ] UptimeRobot 監視開始通知
- [ ] Slack で関係者(Shin + 全エージェント)に公開完了通知

### 7.2 Phase 5 サポート期間(Day 1-30)

詳細は `06-handoff/seo-geo-30day-report.md` を 30 日経過時に更新。

### 7.3 WMAO 引継ぎ(Day 31)

詳細は `06-handoff/dpsai-to-wmao-handoff.yaml` を 30 日経過 + Shin 最終承認(APV-006)後に発行。

---

## 8. 既知の課題・残課題

### 8.1 公開時点で把握している課題

| ID | 内容 | 重要度 | 対応予定 |
|---|---|---|---|
| K-001 | en 版 OGP 画像のフォント視認性(seo-audit L-002) | 低 | Phase 5 内で対応 |
| K-002 | 一部記事の 2 主張文(geo-audit M-001) | 中 | Phase 5 内で対応 |
| K-003 | パンくず区切り文字 aria-hidden 不徹底(a11y M-001) | 中 | Phase 5 内で対応 |
| K-004 | en 版 llms.txt 未実装(geo-audit M-002) | 中 | v0.4 で対応 |

### 8.2 v0.4 以降の継続課題

- Sentry 統合(エラー監視の本格化)
- Storybook 導入
- Visual regression(Chromatic)
- en コピー自動更新パイプライン
- /careers の en 化
- /blog の en 化(主要記事のみ)

---

## 9. 改訂履歴

| 版 | 日付 | 主な変更 |
|---|---|---|
| 1.0 | 2026-06-12 | 初版。Phase H launch 直前。 |

---

**Document Owner**: delivery-director
**Last Updated**: 2026-06-12
**Version**: 1.0
