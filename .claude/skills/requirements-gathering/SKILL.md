---
name: requirements-gathering
description: Produce the client-facing requirements draft (要件定義書) integrating onboarding output, constraints, and project type. Lead agent ux-strategy-lead with client-success-lead and seo-geo-strategist contributing.
---

# /requirements-gathering

## Purpose

Produce the structured requirements draft that the client reviews and approves before SOW finalization. This is the document everyone — both AILEAP and client — agrees to before design starts.

## When to Use

- After `/client-onboarding` completes
- After `/competitor-analysis` is available (informs differentiation)
- Before `/estimate` (estimate references the requirements scope)

## Lead Agent

**ux-strategy-lead** is the primary author. Contributors:
- **client-success-lead**: hearing-record translation
- **seo-geo-strategist**: SEO/GEO scope and KPI tie-in
- **art-direction-lead**: design-scope sketch
- **content-strategy-lead**: content-scope sketch

## Inputs

- `projects/{id}/00-engagement/onboarding-record.md`
- `projects/{id}/00-engagement/constraints.yaml`
- `projects/{id}/00-engagement/stakeholders.yaml`
- `projects/{id}/01-discovery/competitor-analysis.md` (if available)
- `projects/{id}/PROJECT.md`

## Process

Build the requirements doc using template `docs/templates/requirements-v0.md`:

1. **Background & Objectives** (from onboarding)
2. **Target Audience** (initial persona sketch — full persona via /sitemap-design or separate skill)
3. **Project Type** (A1 / A2 / A3) and rationale
4. **Scope**
   - Pages / sections (for A1, A3)
   - Features (forms, search, members, etc.)
   - Multi-language (if scope)
   - CMS (if scope)
   - Integrations (analytics, CRM, etc.)
5. **Out-of-Scope** (explicitly listed — important for change-order discipline)
6. **Success Criteria & KPI**
7. **Constraints** (technical / organizational / budget)
8. **Standard Quality Floors** (Lighthouse, WCAG 2.2 AA, GEO defaults — not negotiable)
9. **Timeline** (phases per `docs/requirements-v0.2.md` Section 13)
10. **Required Assets** (reference `assets-required.yaml`)
11. **Approvals Required** (proposal / requirements / design / launch)
12. **Open Questions** (parking-lot items for next discussion)

## Outputs

- `projects/{id}/00-engagement/requirements-v0.md` (Japanese, client-facing)
- `projects/{id}/00-engagement/requirements-v0.yaml` (machine-readable summary for downstream agents)

## Example Output (Japanese excerpt)

```markdown
# 要件定義書 v0(ドラフト)

**クライアント**: 〇〇株式会社
**案件 ID**: <project-id>
**作成日**: 2026-05-04
**対象案件タイプ**: A1 コーポレートサイト

## 1. 背景と目的

御社はこれまで紙媒体中心の営業を行ってきたが、AI 検索経由の問合せが
増加していることを受け、デジタル接点を強化する。

## 2. ターゲット

中小企業の経営層(40-60 代)、月間 50 名程度の意思決定者。
詳細ペルソナは Discovery フェーズで策定。

## 3. 案件タイプ判定: A1 コーポレートサイト

7-10 ページ規模、ブランド表現と問合せ獲得を両立する構成。

## 4. スコープ
...
```

## Boundary Notes

- Mark as **v0 draft** — this is for client review, not the final-state requirements
- After client review and approval → renamed to `requirements-v1.md` and locked
- Pricing is NOT in this document — that's `/estimate`'s scope
- SOW is NOT this document — that comes after estimate is approved

## Reference Documents

- `docs/templates/requirements-v0.md`
- `docs/requirements-v0.2.md` Section 13 (workflows)
- `docs/agent-roster.md` Section 4-1 (ux-strategy-lead role)
