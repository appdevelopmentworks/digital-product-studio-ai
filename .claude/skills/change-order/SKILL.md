---
name: change-order
description: Document scope/timeline/price changes mid-project as a formal change order. Lead agent commercial-manager with client-success-lead handling client communication.
---

# /change-order

## Purpose

Capture scope/timeline/price changes that occur after SOW signing — formally, in writing, before work proceeds. Verbal agreements on scope changes are forbidden.

## When to Use

- Client requests something not in SOW
- `/scope-check` detects creep that needs formalization
- Timeline shifts due to client-side delays affecting AILEAP work
- Additional language scope, additional pages, additional integrations

## Lead Agent

**commercial-manager** authors the change order. **client-success-lead** handles client communication and approval recording.

## Inputs

- Original SOW
- Recent meeting minutes / correspondence describing the change
- Current `decisions.yaml` and `approvals.yaml`
- Standard change-order unit prices from `docs/pricing-strategy.md`

## Process

1. **Identify the change**:
   - Added page (1 page = ¥50,000-100,000 per `docs/pricing-strategy.md` Section 2.3)
   - Added language (+20-50% per `docs/pricing-strategy.md`)
   - Added feature (custom estimate)
   - Additional design revision rounds beyond contracted
   - Timeline extension request
2. **Quote additional cost / time**:
   - Use Fixed-Price-style line items
   - Or hourly basis if T&M
3. **Identify impacted phases / deliverables**
4. **Save change order**: `projects/{id}/00-engagement/change-orders/CO-YYYYMMDD-NNN.md`
5. **Coordinate client approval**: client-success-lead generates approval-request mail
6. **Approval recorded**: in `approvals.yaml` with `type: change_order` and `target_artifact: change-orders/CO-...`
7. **Do NOT proceed with the changed work until approval is recorded**

## Outputs

- `projects/{id}/00-engagement/change-orders/CO-YYYYMMDD-NNN.md` (Japanese, client-facing)

## Example Output (Japanese excerpt)

```markdown
# 変更注文書 CO-20260620-001

**案件**: <project-id>
**作成日**: 2026-06-20
**作成者**: commercial-manager

## 変更内容

クライアントより 6/15 の打合せにて、英語版ページ追加のご要望をいただきました。

| # | 項目 | 詳細 |
|---|---|---|
| 1 | 英語版追加 | 既存 7 ページの英語版 |
| 2 | 多言語切替 UI | グローバルヘッダーに言語切替を実装 |
| 3 | hreflang 設定 | 7 ページ全てに hreflang 設定 |

## スコープ追加

- 翻訳ワークフロー設計(localization-specialist 動員)
- 翻訳実施(機械翻訳 → Shin によるネイティブレビュー)
- 多言語切替 UI 実装(frontend-engineer)
- hreflang 実装(frontend-engineer + seo-geo-strategist)

## 追加見積

| 項目 | 工数 | 単価 | 小計 |
|---|---|---|---|
| 翻訳設計 | 8h | 10,000 | 80,000 |
| 翻訳・レビュー | 16h | 10,000 | 160,000 |
| 多言語切替 UI 実装 | 8h | 10,000 | 80,000 |
| hreflang 実装 | 4h | 10,000 | 40,000 |
| QA(GEO 監査再実施) | 4h | 10,000 | 40,000 |
| **合計(税抜)** | | | **400,000** |

## 納期影響

ローンチ予定日: 2026-08-01 → 2026-08-15(2 週間延伸)

## 承認方法

本変更注文書をご確認のうえ、別途お送りするメールへのご返信をもって
ご承認とさせていただきます。承認確認後、追加作業に着手いたします。

ご承認なきまま追加作業を進めることはございません。

---
お問合せ: shin@aileap.example
```

## Boundary Notes

- **Never proceed without recorded approval** — protects both AILEAP and client
- Original SOW remains the baseline; change orders are appended, not edited into SOW
- For high-value changes (> 30% of original SOW), recommend lawyer review per `docs/legal-escalation-rules.md`
- Internal AILEAP projects: simplified internal change-order memo (no client approval cycle)

## Reference Documents

- `docs/templates/change-order.md`
- `docs/pricing-strategy.md` Section 2.3 (adjustment factors)
