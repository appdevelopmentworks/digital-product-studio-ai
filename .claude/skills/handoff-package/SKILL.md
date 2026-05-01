---
name: handoff-package
description: Generate the client-delivery package — what they receive when the project completes (URLs, credentials, manuals, SLA, contact). Lead agent delivery-director with cms-engineer providing CMS materials.
auto_trigger_keywords:
  - 納品パッケージ
  - handoff package
  - 納品物
  - 引継ぎ
  - 納品準備
---

# /handoff-package

## Purpose

Produce the structured delivery package that documents what the client receives — URLs, login credentials, CMS manual, SLA terms, post-launch contact, ownership statements.

This is the client-facing handoff, distinct from `/handoff-to-marketing` (which is the internal handoff to WMAO).

## When to Use

- After Launch phase completes
- Before transition to maintenance / Retainer phase
- For renewals (A4 / C3): generate updated package documenting what changed

## Lead Agent

**delivery-director** orchestrates. **cms-engineer** provides CMS materials. **client-success-lead** drafts client-facing language.

## Inputs

- All project deliverables across phases
- `approvals.yaml`, `decisions.yaml`
- CMS schemas / credentials structure
- SLA terms (from SOW or Retainer contract)

## Process

1. Compile delivery URL and staging URL
2. Compile credentials list (CMS, hosting, domain, analytics) — paths only, not actual secrets
3. Compile artifact list (final design system, sitemap, content strategy, audit reports, source code repo)
4. Generate CMS manual based on `cms-engineer`'s draft
5. State copyright transfer (per SOW per `docs/legal-escalation-rules.md` Section 7.2)
6. State maintenance terms (Retainer if any)
7. State post-launch contact info
8. State known issues / non-blocking items
9. Compile into client-facing package

## Outputs

- `projects/{id}/08-handoff/handoff-package.md` (Japanese, client deliverable)
- `projects/{id}/08-handoff/cms-manual.md` (Japanese)

## Example Output (Japanese excerpt)

```markdown
# 納品パッケージ

**案件**: <project-id>
**納品日**: 2026-08-05

## 1. 公開情報

- **本番 URL**: https://example.com
- **ステージング URL**: https://staging.example.com
- **公開日**: 2026-08-01

## 2. 納品物

### 2.1 サイト本体
ソースコード: GitHub `example-corp/website`(クライアント様アカウントへ移管済)

### 2.2 ドキュメント
- 要件定義書 v1
- サイトマップ
- デザインシステム
- コンテンツ戦略
- SEO/GEO 戦略
- 計測設計書
- 公開後 30 日レポート(8/31 提出予定)

## 3. 認証情報・アカウント

| 種別 | 場所 |
|---|---|
| WordPress 管理画面 | https://example.com/wp-admin |
| ドメイン管理 | お名前.com 御社アカウント |
| ホスティング | Vercel — 御社アカウント |
| GA4 | property ID: G-XXXXXX |
| GSC | ドメインプロパティ |

各アカウントの認証情報は別途暗号化メールでお送りいたします。

## 4. CMS 操作マニュアル

別添 `cms-manual.md` をご参照ください。
ログイン → 記事投稿 → 公開 までの基本操作を画面ショット付きで解説しています。

## 5. 著作権

本契約に基づき制作した成果物の著作権は、検収完了および対価の完済を
もって御社に譲渡されます(SOW 第 7 条)。

ただし AILEAP 既存資産(フレームワーク・テンプレート・ライブラリ等)は
AILEAP に留保され、御社へは非独占的・無償の利用許諾を付与します。

## 6. 保守体制

リテイナー契約: 月額 80,000 円(Standard tier)
- 監視・バグ対応(月 5h まで)
- コンテンツ更新(月 5h まで)
- 機能追加(月 5h まで)
- SEO/GEO 改善(月 3h まで)
- 月次レポート発行

契約期間: 6 ヶ月、以降 1 ヶ月単位で更新

## 7. 連絡窓口

- 技術: tech@aileap.example
- 経営・契約: shin@aileap.example
- 緊急対応: 別途 Slack ご招待

## 8. 既知の課題・残課題

- iOS 16 以下でのヒーローアニメーションが軽快さに欠ける
  → Reduce-Motion 検出時は静止画にフォールバック済み
- 中国語版は機械翻訳ベース、主要ページのみ Shin によるレビュー済
  → WMAO 運用フェーズで継続改善

## 9. 公開後 30 日後のフロー

8/31 に SEO/GEO 初動分析レポートを提出後、9/1 より WMAO への運用引継ぎを
開始いたします。詳細は別途打合せにてご相談させていただきます。
```

## Boundary Notes

- Credentials never embedded in this package — only paths and methods to retrieve them
- Copyright transfer language must match SOW (do NOT introduce new clauses here)
- For internal AILEAP projects: simplified handoff (no external invoicing, internal-only artifacts)
- The CMS manual is the basis; v0.4's `cms-trainer` will produce video versions

## Reference Documents

- `docs/templates/handoff-package.md`
- `docs/templates/cms-manual.md`
- `docs/legal-escalation-rules.md` Section 7.2
