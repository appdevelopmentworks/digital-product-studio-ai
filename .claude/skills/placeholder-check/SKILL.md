---
name: placeholder-check
description: Detect unreplaced template placeholders (`<<...>>`) across the active project's publish-target files. Designed to catch leftover values like `<<COMPANY_NAME>>`, `<<未確定>>`, or `<<TBD>>` before launch. Lead agent client-success-lead with delivery-director gating.
auto_trigger_keywords:
  - placeholder
  - 未置換
  - 残置
  - 公開前
  - launch チェック
  - 公開ブロック
  - placeholder check
  - <<
---

# /placeholder-check

## Purpose

Scan the active project's publish-target files for unreplaced template placeholders matching `<<...>>`. Catches values left over from `docs/templates/**` instantiation that would otherwise leak into the production deploy (e.g., `<<COMPANY_NAME>>` shipped on a live page).

This skill exposes the same detection logic as `placeholder-detection.sh` (PreToolUse hook) but is callable on demand for QA passes and ad-hoc verification.

## When to Use

- Before requesting `launch_approval` from the client (manual sweep)
- After every `docs/templates/**` instantiation into the project tree
- During `/launch-checklist` execution (item 7 — Legal pages)
- When `placeholder-detection.sh` blocks deploy (to confirm fixes before retry)
- Whenever Shin or the client asks "公開前の placeholder は残ってないか?"

## Lead Agent

**client-success-lead** orchestrates the scan and translates findings for the client. **delivery-director** owns the gate decision (block / waive). **frontend-engineer** / **cms-engineer** are the implementers who fix the leftover placeholders.

## Inputs

- Active project (auto-detected via `_lib.sh::find_active_project` — `PROJECT.md` with `status: active`)
- Optional scope override:
  - `scope=active` (default) — only the active project's publish-target dirs
  - `scope=path:<relative_path>` — restrict scan to a specific subtree
  - `scope=all-projects` — every project under `projects/` (audit / inventory mode)

## Process

### 1. Resolve scan target

| Scope | Directories scanned (relative to project) |
|---|---|
| Final deliverables | `05-launch/**`, `06-handoff/**` |
| Site source | `src/**`, `app/**`, `pages/**` |
| Content & static | `content/**`, `public/**` |

Excluded: `node_modules`, `.git`, `_archive`, `dist`, `build`, `.next`, `.vercel`, `.turbo`, `.cache`, `coverage`, and anything under `docs/templates/` (template originals are exempt by design).

### 2. Run the detection regex

Pattern: `<<[^<>\n]{1,80}>>`

Captures the canonical placeholder forms:

- `<<COMPANY_NAME>>`, `<<COMPANY_ADDRESS>>`, `<<EMAIL_ADDRESS>>`
- `<<未確定>>`, `<<TBD>>`, `<<未定>>`
- `<<SERVICE_NAME>>`, `<<DOMAIN>>`, `<<PAGE_TITLE>>`

Length-capped at 80 chars to avoid false positives on `<<` markup that legitimately spans many lines.

### 3. Classify each hit

| Severity | Criterion | Gate behavior |
|---|---|---|
| Critical | `<<COMPANY_NAME>>` / `<<EMAIL_ADDRESS>>` / `<<COMPANY_ADDRESS>>` in legal pages, footer, or contact pages | Block launch |
| High | Any `<<...>>` in `05-launch/`, `06-handoff/`, or any HTML/MDX route file | Block launch |
| Medium | `<<...>>` in `01-discovery/`, `02-strategy/`, `03-design/` (planning docs) | Warn — placeholders here may be intentional placeholders for client confirmation |
| Low | `<<...>>` inside fenced ` ``` ` code blocks of Markdown (documentation example) | Note — usually intentional |

### 4. Produce report

Write `projects/{id}/05-launch/placeholder-check.md` (Japanese) with:

- Date / scope / project
- Summary: total hits, files affected, severity breakdown
- Per-severity tables: `path:line — placeholder text — recommended replacement source`
- Gate decision (Pass / Conditional / Block) with rationale

### 5. Hand off

If Block: notify the responsible agent (`frontend-engineer` for source code, `cms-engineer` for CMS content, `copywriter` for copy, `client-success-lead` for client-supplied data placeholders) and append a `DEC-NNN` entry if a waiver is granted.

## Outputs

- `projects/{id}/05-launch/placeholder-check.md` (Japanese, structured)
- Optional: `decisions.yaml` entry if any waiver is granted (delivery-director only)

## Example Output (Japanese excerpt)

```markdown
# placeholder 検出レポート

**案件**: AILEAP-20260429-001
**実行日**: 2026-06-08
**実行者**: client-success-lead
**判定**: ❌ ブロック(High 4 件)

## サマリー

| 重要度 | 件数 | ファイル数 |
|---|---|---|
| Critical | 0 | 0 |
| High | 4 | 2 |
| Medium | 7 | 4 |
| Low | 2 | 1 |

## High(launch ブロック)

| パス:行 | placeholder | 推奨置換元 |
|---|---|---|
| 05-launch/launch-checklist.md:42 | `<<COMPANY_ADDRESS>>` | PROJECT.md → クライアント確認 |
| 05-launch/launch-checklist.md:55 | `<<EMAIL_ADDRESS>>` | apex-to-dpsai-handoff.yaml |
| src/app/contact/page.tsx:18 | `<<PHONE_NUMBER>>` | クライアント確認 |
| src/components/Footer.tsx:24 | `<<COMPANY_NAME>>` | PROJECT.md `client_name` |

## 対応

1. 上記 4 件を実値に置換
2. 再度 `/placeholder-check` を実行して 0 件確認
3. `pre-deploy-approval-check` 含む全 hook が通ったら launch 再開
```

## Boundary Notes

- This skill is **read-only audit**. Do NOT auto-replace placeholders — placeholders need real client-supplied values, and silent replacement creates worse failure modes than visible blocks.
- Findings under `docs/templates/**` are NEVER reported (template originals must keep their `<<...>>` intact).
- Findings under `projects/_archive/**` are NEVER reported (archived projects are out of scope).
- The pre-deploy hook (`placeholder-detection.sh`) shares this logic but runs only on deploy commands; this skill runs on demand.
- Emergency override: `DPSAI_PLACEHOLDER_SKIP=1` bypasses the pre-deploy hook. The override must be paired with a `decisions.yaml` entry justifying the exception.

## Reference Documents

- `.claude/hooks/placeholder-detection.sh` (sibling implementation)
- `docs/gap-analysis-v0.2.md` G-C2 (this skill resolves the gap)
- `docs/templates/legal-privacy-policy.md` (canonical placeholder list)
- `.claude/rules/legal-templates.md` (placeholder format definition `<<...>>`)
