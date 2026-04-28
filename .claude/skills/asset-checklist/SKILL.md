---
name: asset-checklist
description: Generate the per-project required-asset list (logos, photos, copy drafts, credentials) based on project type and case-specific requirements. Lead agent client-success-lead.
---

# /asset-checklist

## Purpose

Capture all assets the client must provide before AILEAP can complete the project — logos, photos, copy drafts, credentials, existing site exports, etc. The checklist is the input for `/asset-status` (tracking).

## When to Use

- During or right after `/client-onboarding`
- When project type changes (regenerate to fit new scope)
- When new asset needs surface mid-project (incremental update)

## Lead Agent

**client-success-lead** is the sole owner.

## Inputs

- `00-engagement/onboarding-record.md` (initial mention of assets)
- `PROJECT.md` (project type)
- `00-engagement/handoff-from-strategy.yaml` (existing-systems clues)

## Process

1. Identify asset categories per project type:

### A1 corporate / A3 mediasite
- Brand: logo (SVG / PNG transparent), brand guidelines
- Imagery: hero photos, team photos, office photos, product shots
- Copy: existing site export, key service descriptions, case studies
- Credentials: hosting account, domain registrar, GA4, GSC, social accounts (if integrating)
- Structured data: organization details (address, phone, hours), executive bios

### A2 LP
- Brand: logo
- Imagery: hero / OG image, supporting photos (3-5)
- Copy: campaign offer, testimonials (with permissions), product/service descriptions
- Credentials: hosting / analytics

### Multi-language (any type)
- Reference translations or terminology glossary (if client has)
- Native review reviewer designation (or use Shin's review)

2. Set per-asset metadata:
   - `id` (AST-NNN)
   - `name` (human-readable)
   - `category` (brand / imagery / copy / credentials)
   - `received: false` (initial state)
   - `deadline` (date — usually beginning of phase that needs the asset)
   - `blocker_for` (which phase blocks if not received)

3. Save to `01-discovery/assets-required.yaml`

## Outputs

- `01-discovery/assets-required.yaml` (snake_case)

## Example Output (YAML excerpt)

```yaml
required_assets:
  - id: AST-001
    name: ロゴ(SVG / PNG 透過版)
    category: brand
    received: false
    deadline: 2026-05-10
    blocker_for: 03-design
    notes: SVG 推奨、最小サイズ表示用に PNG 透過版も

  - id: AST-002
    name: 既存サイトの GA4 / GSC アクセス権
    category: credentials
    received: false
    deadline: 2026-05-05
    blocker_for: 02-strategy
    notes: |
      shin@aileap.example をエディタ権限で追加いただきたい。
      手順は別途お送りいたします。

  - id: AST-003
    name: チームメンバー写真(5 名分)
    category: imagery
    received: false
    deadline: 2026-06-01
    blocker_for: 04-implementation
    notes: |
      横向き 1:1 推奨、自然光の屋外 / 屋内のいずれか。
      撮影パートナーをご紹介可能(別途実費)。

  - id: AST-004
    name: 既存お問合せフォーム送信先設定
    category: credentials
    received: false
    deadline: 2026-07-15
    blocker_for: 06-launch
    notes: 送信先メールアドレス、HubSpot 等の CRM 連携の有無

  - id: AST-005
    name: プライバシーポリシー素案 / 既存版
    category: copy
    received: false
    deadline: 2026-06-20
    blocker_for: 06-launch
    notes: |
      既存版があれば現行のものを共有ください。
      新規の場合、AILEAP のひな型をご提示します(弁護士確認必須)。
```

## Boundary Notes

- Credentials handling per `secrets.md` rule — never embedded in YAML, paths only
- For multi-language projects, asset list expands per language
- Asset list is iterative — update as Discovery surfaces new needs

## Reference Documents

- `docs/requirements-v0.2.md` Section 14.3 (asset coordination)
- `docs/templates/...` (project-type-specific templates as references)
