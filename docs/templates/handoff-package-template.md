# 納品パッケージテンプレート（クライアント引渡し）

**用途**: 案件完了時にクライアントへ引き渡す成果物一式の構成
**配置先**: `projects/<project_id>/06-handoff/handoff-package.md`
**主担当**: `delivery-director`（`cms-engineer` が CMS 操作資料を補強）
**スキル**: `/handoff-package`
**言語層**: Layer 1（クライアント向け日本語）

---

## 使い方

1. 公開直前～公開直後に作成
2. 本書面と一緒に成果物 ZIP / Drive 共有
3. CMS 操作研修と並行で説明
4. 受領サインを `00-engagement/approvals.yaml` に `handoff_approval` として記録

---

## テンプレート本体

```markdown
# 納品パッケージ

**案件名**: <<株式会社サンプル コーポレートサイト>>
**案件 ID**: <<AXYZ-20260601-001>>
**納品日**: <<YYYY-MM-DD>>
**納品担当**: AILEAP / digital-product-studio-ai
**本書バージョン**: 1.0

---

## はじめに

このたびは AILEAP にコーポレートサイト制作をお任せいただき、誠にありがとうございました。
本書は、本案件で制作したすべての成果物・運用ドキュメント・認証情報をまとめた
**納品パッケージ** です。

本書を保管いただくことで、貴社単独でのサイト運用、または別の制作会社・WMAO 等の
連携先への引継ぎがスムーズに行えます。

---

## 1. 納品成果物一覧

### 1.1 Web サイト本体

| # | 項目 | 引渡し先 | 形式 |
|---|---|---|---|
| 1 | 本番サイト URL | https://<<example.com>> | 公開済み |
| 2 | DNS 設定 | <<クライアント保有レジストラ>> | 設定完了 |
| 3 | SSL 証明書 | Let's Encrypt（自動更新） | 設定完了 |

### 1.2 ソースコード

| # | 項目 | 引渡し先 | 備考 |
|---|---|---|---|
| 1 | フロントエンドリポジトリ | <<https://github.com/aileap/sample-corp-site>> | 招待済み |
| 2 | CMS テーマリポジトリ | <<https://github.com/aileap/sample-corp-theme>> | 招待済み |
| 3 | 主要設定ファイル一覧 | 別添「環境構築ガイド」参照 | — |

### 1.3 デザインアセット

| # | 項目 | 引渡し先 | 形式 |
|---|---|---|---|
| 1 | デザインシステム | <<03-design/design-system.md>> | Markdown |
| 2 | Figma ファイル | <<https://figma.com/...>> | 編集権限付与 |
| 3 | 主要画面デザイン | <<03-design/screens/>> | Figma + PNG |
| 4 | アイコンセット | <<assets/icons/>> | SVG |
| 5 | ロゴデータ | <<assets/logo/>> | AI / SVG / PNG（複数解像度）|
| 6 | OGP 画像（全サイズ）| <<assets/og/>> | PNG（1200×630）|

### 1.4 コンテンツ

| # | 項目 | 引渡し先 | 形式 |
|---|---|---|---|
| 1 | 全ページコピー | <<04-implementation/copy/>> | Markdown |
| 2 | 初期記事 1-<<7>> | CMS 投稿済み + Markdown 控え | — |
| 3 | コンテンツ戦略書 | <<02-strategy/content-strategy.md>> | Markdown |
| 4 | 用語集（Glossary）| <<06-handoff/glossary.csv>> | CSV |
| 5 | 法務ページ（プライバシーポリシー / 特商法 / 利用規約）| 公開済み | 弁護士確認済み |

### 1.5 認証情報・アクセス権限

> ⚠️ **機密情報のため、本書面には直接記載せず 1Password 共有 Vault 経由で引渡します。**

| # | 項目 | 引渡し方法 |
|---|---|---|
| 1 | CMS 管理者アカウント | 1Password 共有 Vault |
| 2 | ホスティング管理コンソール | 1Password 共有 Vault |
| 3 | DNS 管理コンソール | 既存クライアント保有のため、AILEAP は退出 |
| 4 | GA4 編集者権限 | クライアント・AILEAP 双方付与 |
| 5 | Google Search Console 権限 | クライアント・AILEAP 双方付与 |
| 6 | UptimeRobot 監視設定 | 1Password 共有 Vault |

### 1.6 運用ドキュメント

| # | 項目 | 引渡し先 |
|---|---|---|
| 1 | CMS 操作マニュアル | `06-handoff/cms-manual.md` |
| 2 | コンテンツ追加ガイド | `06-handoff/content-guide.md` |
| 3 | バックアップ・復元手順 | `06-handoff/backup-procedure.md` |
| 4 | 緊急障害対応フロー | `06-handoff/emergency-response.md` |
| 5 | SEO/GEO 30日検証レポート | `06-handoff/seo-geo-30day-report.md`（公開後30日に納品）|
| 6 | 環境構築ガイド | `06-handoff/dev-setup.md` |

### 1.7 CMS 操作研修

| # | 項目 | 詳細 |
|---|---|---|
| 1 | 研修日時 | <<YYYY-MM-DD HH:MM>> |
| 2 | 研修形式 | <<オンライン（Zoom）>> |
| 3 | 録画 | <<クライアント側保管 / Drive 共有>> |
| 4 | テキスト | 上記「CMS 操作マニュアル」 |
| 5 | 想定質問 FAQ | `06-handoff/cms-faq.md` |

---

## 2. 達成品質指標（公開時点）

### 2.1 Lighthouse スコア（公開時点）

| ページ | Performance | Accessibility | SEO | Best Practices |
|---|---|---|---|---|
| トップ | <<95>> | <<98>> | <<100>> | <<93>> |
| サービス一覧 | <<92>> | <<96>> | <<100>> | <<93>> |
| 記事詳細 | <<96>> | <<99>> | <<100>> | <<93>> |
| お問い合わせ | <<94>> | <<97>> | <<100>> | <<93>> |

### 2.2 アクセシビリティ準拠

- WCAG 2.2 Level AA 準拠
- 自動チェック: axe DevTools / Pa11y クリア
- 手動チェック: キーボードナビ、VoiceOver / NVDA 動作確認済み

### 2.3 SEO/GEO 対応

- 構造化データ（JSON-LD）: Organization / WebSite / WebPage / BreadcrumbList / FAQPage / Article
- メタタグ完備（title / description / OG / Twitter Card / canonical）
- llms.txt 配置済み（GEO 対策）
- sitemap.xml / robots.txt 配置済み

---

## 3. 公開後の保守・運用について

### 3.1 公開後30日間の保守（AILEAP スコープ）

公開日から30日間は AILEAP が以下を担当します。

- 軽微なバグ修正
- パフォーマンス監視
- SEO/GEO 初動検証 → 30日レポート発行
- 公開直後の質問対応

### 3.2 31日目以降の選択肢

公開後31日目以降は、以下のいずれかの形で運用を継続いただきます。

#### 選択肢 A: AILEAP との月額保守契約（Retainer）

技術保守 + 軽微改善 + 月次レポートのパッケージ。
詳細は `00-engagement/retainer.md` を参照。

#### 選択肢 B: WMAO（web-marketing-ai-org）への引継ぎ

継続的なコンテンツ制作 + SEO/GEO 改善 + 広告運用が必要な場合は、
AILEAP の関連組織である WMAO への引継ぎを推奨します。

引継ぎ済みの場合は `06-handoff/dpsai-to-wmao-handoff.yaml` を参照。

#### 選択肢 C: 自社運用

クライアント様の社内チームでの運用も可能です。
本書「CMS 操作マニュアル」「環境構築ガイド」をご活用ください。

### 3.3 緊急障害時の連絡先

公開後30日以内、または Retainer 契約期間中は以下にご連絡ください。

- メール: <<emergency@aileap.example>>
- 電話: <<03-XXXX-XXXX>>（営業時間内）
- 営業時間外: <<form-url>>（24時間受付フォーム）

応答時間:
- 営業時間内: 4時間以内に一次応答
- 営業時間外: 翌営業日24時間以内に一次応答

---

## 4. 知的財産・著作権

### 4.1 著作権の帰属

本案件で制作したすべての成果物（ソースコード・デザイン・コピー・画像）の
著作権は、契約金額の支払い完了をもって貴社に移転します。

### 4.2 第三者ライブラリ

本サイトでは以下の OSS / 第三者ライブラリを使用しています。
それぞれのライセンスを遵守してご利用ください。

| ライブラリ | バージョン | ライセンス | 用途 |
|---|---|---|---|
| Next.js | <<14.x>> | MIT | フレームワーク |
| React | <<18.x>> | MIT | UI ライブラリ |
| Tailwind CSS | <<3.x>> | MIT | スタイリング |
| Noto Sans JP | <<latest>> | OFL | 日本語フォント |
| <<その他>> | | | |

詳細は `06-handoff/oss-licenses.md` 参照。

### 4.3 AILEAP の留保事項

- 本案件で開発した汎用的な技法・コンポーネント・ノウハウについて、AILEAP は他案件への流用権を留保します。
- 本案件を AILEAP の制作実績として公表する権利を留保します（公表時は事前に貴社確認）。

---

## 5. データ保管・バックアップ

### 5.1 公開時のバックアップ

公開時点のフルバックアップを以下に保管しています。

- ソースコード: GitHub（公開リポジトリの v1.0.0 タグ）
- データベース: <<バックアップ場所>>
- アセット: <<バックアップ場所>>

### 5.2 自動バックアップ設定

- データベース: 毎日 03:00 自動バックアップ（過去30日保管）
- ファイル: 週次自動バックアップ
- 設定詳細: `06-handoff/backup-procedure.md`

---

## 6. お問い合わせ・ご相談

### 6.1 公開後30日以内・Retainer 契約期間中

- AILEAP 担当: <<delivery-director / 田中 太郎>>
- メール: <<contact@aileap.example>>
- 電話: <<03-XXXX-XXXX>>

### 6.2 30日経過後（Retainer 契約なし）

新規のご相談・追加開発は、上記窓口にて随時お受けいたします。

---

## 7. 受領確認

下記をご確認のうえ、ご署名をお願いいたします。

### 7.1 確認事項

- [ ] 1.1 ～ 1.7 の納品物をすべて受領した
- [ ] 認証情報（1Password Vault）にアクセスできることを確認した
- [ ] CMS 操作研修を受講した
- [ ] 公開後30日サポートおよびそれ以降の選択肢について理解した
- [ ] 知的財産権の帰属・OSS ライセンスについて確認した

### 7.2 ご署名

| 項目 | 内容 |
|---|---|
| 受領者氏名 | <<田中 太郎>> |
| 役職 | <<経営企画部 部長>> |
| 受領日 | <<YYYY-MM-DD>> |
| 署名 | __________________________ |

### 7.3 AILEAP 側

| 項目 | 内容 |
|---|---|
| 担当者 | <<delivery-director / 山田 一郎>> |
| 役職 | <<Delivery Director>> |
| 納品日 | <<YYYY-MM-DD>> |
| 署名 | __________________________ |

---

## 8. 別添資料

- `02-strategy/content-strategy.md` — コンテンツ戦略書
- `03-design/design-system.md` — デザインシステム
- `06-handoff/cms-manual.md` — CMS 操作マニュアル
- `06-handoff/seo-geo-30day-report.md` — SEO/GEO 30日レポート（公開30日後発行）
- `06-handoff/dpsai-to-wmao-handoff.yaml` — WMAO 引継ぎ書（該当時）
- `00-engagement/retainer.md` — 月額保守契約書（該当時）

---

**digital-product-studio-ai（AILEAP）**
**納品担当: <<delivery-director>>**
**Last Updated**: <<YYYY-MM-DD>>
**Version**: 1.0
```

---

## チェックリスト

- [ ] すべてのソースコードがリポジトリ化済み
- [ ] CMS / ホスティング / 解析の認証情報が 1Password 経由で引渡し可能
- [ ] DNS 管理がクライアント保有または引継ぎ完了
- [ ] Lighthouse スコアを実測値で記載
- [ ] 法務ページ（プライバシーポリシー等）が弁護士確認済み
- [ ] CMS 操作マニュアル・運用ドキュメント完備
- [ ] CMS 操作研修が完了
- [ ] OSS ライセンス一覧を別添
- [ ] 公開後30日サポートと31日目以降の選択肢を提示
- [ ] WMAO 引継ぎ書（該当時）が併送
- [ ] Retainer 契約書（該当時）が併送

---

## よくある間違い

| 誤り | 正しい書き方 |
|---|---|
| 認証情報を本書面に直接記載 | 1Password Vault 経由でのみ |
| Lighthouse スコアを「90+」と記載 | 実測値で記載 |
| OSS ライセンス一覧未添付 | 全使用ライブラリを記載 |
| 公開後の運用選択肢を提示せず | A/B/C の3択を必ず提示 |
| 受領サインなし | クライアント・AILEAP 双方の署名欄必須 |
