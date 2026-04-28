---
name: estimate
description: Generate a 3-pattern estimate (Fixed Price / Time & Material / Retainer) per docs/pricing-strategy.md. The Retainer pattern is mandatory — even when the client says they don't need maintenance, the Light tier must be presented. Lead agent commercial-manager.
---

# /estimate

## Purpose

Generate a structured estimate that ALWAYS presents three pricing patterns (Fixed Price, Time & Material, Retainer). This is mandatory per AILEAP business strategy — labor-intensive Fixed-only proposals are explicitly avoided.

## When to Use

- After `/requirements-gathering` is complete and approved (v0)
- When scope changes warrant a re-estimate (use `/change-order` for incremental changes)
- When transitioning from project to maintenance phase (Retainer-focused estimate)

## Lead Agent

**commercial-manager** is the sole owner. **technology-director** contributes effort estimation.

## Inputs

- `projects/{id}/00-engagement/requirements-v0.md`
- `projects/{id}/PROJECT.md` (project type, internal_client flag)
- `projects/{id}/00-engagement/handoff-from-strategy.yaml` budget hints
- `docs/pricing-strategy.md` (the price-range tables)

## Process

1. **Determine project type** and look up standard ranges from `docs/pricing-strategy.md` Section 2:
   - A1: 50-150 万円 / 100-200h / 5-15 万円/月
   - A2: 20-50 万円 / 40-80h / 3-8 万円/月
   - A3: 80-200 万円 / 120-250h / 8-30 万円/月
2. **Apply adjustment factors** per `docs/pricing-strategy.md` Section 2.3:
   - Page count, design difficulty, multi-language (+20-50%), animation (+10-30%), CMS customization, API integrations, etc.
3. **Build Fixed Price pattern**: total + 4-phase breakdown + change-order unit prices + included/excluded list
4. **Build T&M pattern**: blended rate, hour range, monthly cap, reporting cadence
5. **Build Retainer pattern**: tier (Light/Standard/Pro), monthly fee, included services, overage rate, minimum period
6. **Apply mandatory Retainer rule**: even if client said "no maintenance needed", present Light tier as starting point
7. **For internal AILEAP projects**: mark `internal_client: true`, no external invoicing, internal-effort tracking only
8. **Generate output**: YAML (machine) + Markdown (client-facing Japanese)

## Outputs

- `projects/{id}/00-engagement/estimate.yaml` (snake_case, full data)
- `projects/{id}/00-engagement/estimate.md` (Japanese, client-facing)

## Example Output (Japanese excerpt)

```markdown
# お見積り(3 パターン)

**案件**: <project-id>
**作成日**: 2026-05-10
**有効期限**: 2026-06-10

## ご提案の前提

御社のコーポレートサイト改修について、以下 3 つのパターンをご提案いたします。
ご予算・運用方針に応じてお選びください。

## パターン C: リテイナー(月額保守)— 推奨

```
月額: 80,000 円(税抜)
契約期間: 最低 6 ヶ月

含まれる作業:
  - 監視・バグ対応(月 5h まで)
  - コンテンツ更新(月 5h まで)
  - 機能追加・改善(月 5h まで)
  - SEO/GEO 改善(月 3h まで)
  - 月次レポート発行

超過分: 12,000 円/h
```

## パターン A: 固定価格

```
合計: 980,000 円(税抜)
内訳:
  戦略・要件定義: 150,000
  デザイン: 350,000
  実装: 350,000
  QA・公開: 130,000

納期: 契約締結から 1 ヶ月

変更注文単価:
  ページ追加 1 枚: 50,000-100,000
  多言語追加(1 言語): +200,000

含まれるもの: WCAG 2.2 AA 準拠 / Lighthouse Performance 90+ / 構造化データ標準装備 / 公開後 30 日 SEO/GEO 検証
```

## パターン B: T&M(時間単価)

```
単価: 10,000 円/h(税抜)
推定工数: 100-200h
推定総額: 1,000,000-2,000,000 円
月次リミット: 80h
```
```

## Boundary Notes

- **Mandatory 3-pattern presentation** — never present only Fixed or only T&M
- Retainer's Light tier is the floor — even if client refuses maintenance, present it once
- Lawyer review for SOW is recommended for high-value (>200 万円) projects per `docs/legal-escalation-rules.md`
- For internal AILEAP projects: `internal_client: true`, no external invoicing line items
- Currency: JPY only in v0.2; multi-currency is v0.4+

## Reference Documents

- `docs/pricing-strategy.md` — full pricing playbook
- `docs/templates/estimate.md` — client-facing template
- `docs/templates/sow.md` — for downstream contract step
