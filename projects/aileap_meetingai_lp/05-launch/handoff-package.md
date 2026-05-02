# 納品パッケージ — AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0
**作成日**: 2026-06-29
**作成者**: delivery-director
**ステータス**: 公開準備完了

> 自社案件のため内部運用引継ぎパッケージ。aileap_v2 と同パターン。

---

## 1. パッケージ概要

| 項目 | 値 |
|---|---|
| 公開予定日 | 2026-06-30 |
| 本番 URL | https://meetingai.aileap.example/ |
| ステージング URL | https://staging.meetingai.aileap.example/ |
| ホスティング | Vercel(aileap_v2 と同一プロジェクト集合) |
| CMS | 不使用(messages/ja.json のみ) |
| 親プロジェクト | aileap_v2(統合運用) |

---

## 2. 引き渡しアセット

### 2.1 ソースコード

| アセット | 場所 | アクセス権 |
|---|---|---|
| メインリポジトリ | `aileap-meetingai-lp/`(別 GitHub repo) | Shin / AILEAP all agents(read) |
| Vercel project | `aileap-meetingai-lp.vercel.app` | Shin |
| サブドメイン | meetingai.aileap.example(ワイルドカード SSL) | Shin |

### 2.2 設計成果物

| アセット | パス |
|---|---|
| サイトマップ | `02-strategy/sitemap.md`(2 ページのみ) |
| コンテンツ戦略 | `02-strategy/content-strategy.md` |
| SEO/GEO 戦略 | `02-strategy/seo-geo-strategy.md` |
| デザインノート(差分) | `03-design/design-notes.md` |
| アーキテクチャ | `04-implementation/architecture-notes.md` |
| 実装ノート | `04-implementation/implementation-notes.md` |
| **継承元 design-system** | `../aileap_v2/03-design/design-system.md` |

### 2.3 QA レポート

| レポート | 結果 |
|---|---|
| SEO 監査 | ✅ Pass(Lighthouse SEO 100) |
| GEO 監査 | ✅ Pass(必須 22/22) |
| アクセシビリティ監査 | ✅ Pass(WCAG 2.2 AA 全達成) |

### 2.4 公開チェックリスト

`05-launch/launch-checklist.md` 全 60 項目 pass。

---

## 3. 認証情報・アクセス情報

### 3.1 ホスティング

| サービス | URL | 管理者 |
|---|---|---|
| Vercel | https://vercel.com/aileap/aileap-meetingai-lp | Shin |
| GitHub | https://github.com/aileap/aileap-meetingai-lp | Shin |
| ドメイン | meetingai.aileap.example(aileap.example のサブドメイン)| Shin |

### 3.2 解析

aileap_v2 と統合プロパティ:
- GA4: aileap_v2 と同じプロパティ + `utm_campaign=meetingai-lp` で識別
- GSC: meetingai.aileap.example を独立プロパティとして登録

### 3.3 メール / 通知

| サービス | 用途 |
|---|---|
| Resend | β版申込み通知 + 自動返信 |
| UptimeRobot | サイト監視(99.5% SLA) |

### 3.4 環境変数(Vercel)

aileap_v2 と一部共有(Resend API key / GA4 ID):

```
MICROCMS_*           不使用
RESEND_API_KEY       (aileap_v2 と共有)
RECAPTCHA_SECRET_KEY (本 LP 専用 / フォーム保護)
NEXT_PUBLIC_RECAPTCHA_SITE_KEY (本 LP 専用)
NEXT_PUBLIC_SITE_URL https://meetingai.aileap.example
NEXT_PUBLIC_GA_MEASUREMENT_ID (aileap_v2 と統合)
```

別経路(1Password)で受け渡し。

---

## 4. 保守・SLA

### 4.1 Phase 5 サポート(公開後 30 日)

[handoff-protocols.md §4.6](../../../docs/handoff-protocols.md) に従い、公開後 30 日:

- 重大バグ修正(無償)
- Lighthouse 再測定
- 初動 SEO/GEO 検証(30 日レポート)
- アクセス解析ベースライン記録
- 軽微なコンテンツ修正(累計 3h 以内・LP は規模小)

### 4.2 31 日目以降

- WMAO 引継ぎ: SEO/GEO 月次改善 + LP 流入分析
- 本組織内継続: LP 自体の保守 / プロダクト訴求内容更新 / A/B テスト実施

[06-handoff/dpsai-to-wmao-handoff.yaml](../06-handoff/dpsai-to-wmao-handoff.yaml) で partial scope 引継ぎ。

### 4.3 SLA

| 項目 | 値 |
|---|---|
| 稼働率目標 | 99.5%(UptimeRobot 測定) |
| 重大障害対応 | 24h 以内 |
| 軽微改修 | 72h 以内 |
| 連絡先 | meetingai-tech@aileap.example / meetingai-beta@aileap.example |

---

## 5. 引継ぎチェックリスト

公開直後に確認:

- [x] 全 hook が pass
- [x] launch-checklist 全項目 pass
- [x] 3 audit pass
- [x] APV-005 approved
- [x] APV-001 / 002 / 003 / 004 すべて approved
- [x] 法務(privacy)が aileap_v2 から継承 + lawyer_confirmation: true
- [x] placeholder-detection pass
- [x] サブドメイン DNS / SSL 動作
- [x] sitemap.xml / robots.txt 配信
- [x] aileap_v2 `/llms.txt` に本 LP リンク反映
- [x] GA4 / GSC 計測動作
- [x] β版申込みフォーム動作確認

---

## 6. 既知の課題(Phase 5 内対応)

| ID | 内容 | 重要度 | 対応予定 |
|---|---|---|---|
| K-001 | OGP 画像のサブテキスト視認性(seo-audit M-001) | 中 | Phase 5 内 |
| K-002 | アンカーリンクの scroll-margin-top 微調整(seo-audit L-001) | 低 | Phase 5 内 |
| K-003 | 一部本文の 2 主張文(geo-audit M-001) | 中 | Phase 5 内 |
| K-004 | スキップリンクスタイル(a11y L-001 / aileap_v2 と共通) | 低 | aileap_v2 と一括対応 |

---

## 7. v0.4 以降の継続課題

- A/B テスト導入(Vercel Edge Config + 簡易フラグ)
- ブログ連動(aileap_v2 側で MeetingAI 関連記事を増やす)
- en 化(海外展開時)
- 比較表ページの追加
- ウェビナー連動 LP

---

**Document Owner**: delivery-director
**Last Updated**: 2026-06-29
**Version**: 1.0
