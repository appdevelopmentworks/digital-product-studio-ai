---
name: client-onboarding
description: Run the structured initial client hearing — agenda, stakeholder mapping, KGI/KPI capture, constraint discovery, asset checklist seeding, success criteria, communication preferences. Lead agent client-success-lead with ux-strategy-lead contributing constraint-discovery.
auto_trigger_keywords:
  - 新案件
  - 新規案件
  - クライアント案件
  - ヒアリング
  - onboarding
  - キックオフ
  - 案件開始
---

# /client-onboarding

## Purpose

Run the first major client interaction: a structured hearing that captures everything subsequent agents need (strategy, design, engineering, delivery). Output is a hearing record + initialized YAML files for stakeholders, assets, decisions.

## When to Use

- Right after `studio-director` receives `/handoff-from-strategy` from apex
- When initiating a project that did NOT come through apex (manual intake)
- When restarting a paused project (lighter rerun)

## Lead Agent

**client-success-lead** is the orchestrator. **ux-strategy-lead** contributes the constraint-discovery step.

## Inputs

- `projects/{id}/00-engagement/handoff-from-strategy.yaml` (if from apex)
- `projects/{id}/PROJECT.md` (basic metadata seeded by delivery-director)
- Live hearing transcript / notes / recording from Shin

## Process

Cover these 7 sections in order:

1. **Strategic context re-confirmation**
   - Re-state apex's strategic context (if applicable)
   - Get client's own framing of the project's role in their business
2. **Goals and KGI/KPI**
   - Specific quantitative goals
   - Time-frame
   - How they'll know they succeeded
3. **Stakeholder mapping**
   - Decision-maker (final-yes person)
   - Influencers (review/feedback)
   - End-users (the personas)
   - Communication preferences per stakeholder
4. **Constraint discovery (3 categories)** — ux-strategy-lead leads this step
   - Technical (existing systems, integration, hosting, browser support)
   - Organizational (decision cadence, internal review cycles, regulatory)
   - Budget / Timeline (hard deadline vs soft preference, contingency)
5. **Required assets capture** — seeds `assets-required.yaml`
   - Logo, photos, copy drafts, credentials (GA4, GSC, social, hosting), existing site export
   - Per-asset: deadline, blocker_for phase
6. **Success criteria post-launch**
   - 30-day, 90-day, 6-month indicators
   - Who measures (us / WMAO / client)
7. **Communication preferences**
   - Channel (email / Slack / chatwork / Zoom)
   - Frequency (weekly status / biweekly / on-demand)
   - Escalation path

## Outputs

Generated artifacts:

- `projects/{id}/00-engagement/onboarding-record.md` (Japanese, structured hearing record)
- `projects/{id}/00-engagement/stakeholders.yaml` (snake_case keys)
- `projects/{id}/00-engagement/constraints.yaml`
- `projects/{id}/01-discovery/assets-required.yaml` (initial seed; refined later via /asset-checklist)
- `projects/{id}/00-engagement/decisions.yaml` (any decisions captured during hearing)

## Example Output (Japanese excerpt)

```markdown
# キックオフヒアリング記録

**案件**: aileap_v2
**日時**: 2026-05-02
**参加者**: 決裁者 / Shin

## 1. 戦略的文脈

apex から受領した戦略レポートでは「日本の SME 向け AI コンサル」を主軸とし、
コーポレートサイトを信頼性強化チャネルとして位置づけ。クライアント側は同意。

## 2. ゴールと KGI/KPI

- KGI: 月間問い合わせ件数 30 件(現在 5 件)
- KPI:
  - オーガニック流入 1,000 UU/月(現在 100)
  - GEO 流入 50 UU/月(現在 0)
- タイムフレーム: 公開後 6 ヶ月で達成

## 3. ステークホルダー
...
```

## Boundary Notes

- Do NOT promise legal advice during hearing — refer to lawyer per `docs/legal-escalation-rules.md`
- Do NOT commit to pricing without `commercial-manager` running `/estimate`
- Do NOT promise v0.3+ capabilities (research / data analyst / motion design / B-series)

## Reference Documents

- `docs/requirements-v0.2.md` Section 13 (workflows per type)
- `docs/agent-coordination-map.md` Section 6 (team patterns)
- `docs/language-policy.md` (output in Japanese for SME clients in Japan)
