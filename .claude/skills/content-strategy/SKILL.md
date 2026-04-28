---
name: content-strategy
description: Define content pillars, hierarchy mapping, tone of voice, editorial cadence, and CTA framework. Lead agent content-strategy-lead with copywriter and seo-geo-strategist contributing.
---

# /content-strategy

## Purpose

Define what stories the site will tell, how content is organized, what voice it carries, and how content production cadence will work post-launch. This is the upstream contract for `copywriter`'s execution.

## When to Use

- Strategy phase, after `/sitemap-design` is settled
- Re-do for major repositioning or A4 renewal projects

## Lead Agent

**content-strategy-lead** is the primary author. Contributors:
- **copywriter**: voice / register translation
- **seo-geo-strategist**: keyword integration plan
- **strategy-director**: direction approval

## Inputs

- `projects/{id}/01-discovery/persona.md`, `user-journey-map.md`
- `projects/{id}/01-discovery/competitor-analysis.md`
- `projects/{id}/02-strategy/sitemap.md`
- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (apex's positioning)

## Process

1. **Define content pillars** (3-5 themes the site owns)
2. **Map pillar → page → CTA**
3. **Define tone of voice register** (formal/casual, authority/peer, technical/accessible) per audience segment
4. **Define editorial cadence** (especially A3 mediasite — weekly/biweekly publication plan)
5. **Define CTA framework**:
   - Primary CTA pattern (action verb + benefit)
   - Secondary CTA pattern (low-commitment)
   - Microcopy library (form prompts, success/error messages)
   - Headline templates (for A3 article headlines)
6. **Define multi-language content treatment** (if i18n in scope) — coordinate with localization-specialist
7. **Define content governance** (who writes / who reviews / who approves post-launch — handed to WMAO at handoff)

## Outputs

- `projects/{id}/02-strategy/content-strategy.md` (Japanese, client deliverable)

## Example Output (Japanese excerpt)

```markdown
# コンテンツ戦略

**案件**: <project-id>
**作成日**: 2026-05-15
**作成者**: content-strategy-lead

## 1. コンテンツピラー(3 本柱)

1. **AI を経営の現場に落とし込む** — 抽象論ではなく具体施策
2. **数字で語る成果** — 案件ごとの定量変化(導入前後)
3. **AILEAP の専門領域** — Apex / 制作 / マーケの 3 組織連携の透明性

## 2. ピラー → ページ → CTA マッピング

| ピラー | 主要ページ | 主要 CTA |
|---|---|---|
| AI 経営落とし込み | /services/ai-consulting | 30 日無料相談 |
| 数字で成果 | /cases/{slug} | 同事例の資料 DL |
| 3 組織連携 | /about/team, /about/company | 問合せ |

## 3. トーン・オブ・ボイス

ターゲットペルソナ(中小企業経営者・40-60 代)に対して:

- 専門用語は最小限。使う場合は文脈で補足
- 上から目線にならない、実務に寄り添う書き方
- 数字とエビデンスを優先、抽象表現を避ける
- 敬語は丁寧語ベース(「ですます」)、過度な敬語は避ける

## 4. 編集カレンダー(公開後・WMAO 引継ぎまでの 30 日)

| 週 | 担当 | 本数 | テーマ |
|---|---|---|---|
| 1 | copywriter | 2 | AI 導入の最初の一歩 / 失敗事例 |
| 2 | copywriter | 2 | 業界別の活用例(2 業界) |
| 3 | copywriter | 2 | 経営者インタビュー(架空ではなく実例) |
| 4 | copywriter | 1 | 30 日サマリー記事 |

合計 7 本。11 本目以降は WMAO 引継ぎ。

## 5. CTA フレームワーク

### Primary
動詞 + 利益:「30 日無料で試す」「資料を 1 分でダウンロード」

### Secondary
低コミットメント:「事例集を見る」「30 秒の概要動画」

### マイクロコピー(フォーム)
プレースホルダー: 「example@company.com」(具体例)
個人情報同意: 「個人情報は安全に管理されます。詳細はプライバシーポリシーをご覧ください。」
送信ボタン: 「送信する」(動詞・敬語)
完了: 「ありがとうございました。担当より 1 営業日以内にご連絡いたします。」
エラー: 「メールアドレスをご確認ください。@ を含む形式でご記入ください。」

## 6. SEO/GEO 観点(seo-geo-strategist 補完)

主要キーワードは copywriter が記事ごとに反映。
記事構造は `docs/geo-implementation-spec.md` Section 5 の GEO 最適化ルールに従う。
```

## Boundary Notes

- Cadence post-handoff is WMAO's responsibility — this strategy provides the editorial calendar through the 30-day post-launch window only
- Tone-of-voice conflicts with brand-direction (creative-director's domain) → cross-consult, escalate to studio-director if irreconcilable
- Multi-language tone register may differ per locale — surface to localization-specialist

## Reference Documents

- `docs/templates/content-strategy.md`
- `docs/geo-implementation-spec.md` Section 5 (GEO-optimized writing)
