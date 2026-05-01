---
name: e2e-test-plan
description: Author the E2E (and overall test pyramid) plan for a B-series project — critical user journeys, test pyramid balance, accessibility checks, CI integration, regression strategy. Lead agent qa-engineer (Tier 3, new in v0.3) with backend-lead and frontend-lead horizontal review.
auto_trigger_keywords:
  - E2E
  - e2e test
  - テスト計画
  - テスト戦略
  - test plan
  - test strategy
  - 自動テスト
  - regression
  - リグレッション
  - critical journey
---

# /e2e-test-plan

## Purpose

Produce the test plan for a B-series project: which tests at which layer, which user journeys are critical, how CI runs them, when regression suite is updated. The plan is the authoritative source for qa-engineer's daily work and the gate for launch QA reports.

For A-series projects, the skill produces a lighter "QA gate" version with a small set of E2E critical journeys + Lighthouse + axe-core.

## When to Use

- B-series project initialization (sprint 0 / 1)
- Pre-launch QA readiness check
- After a major refactor that may have invalidated the test pyramid
- Quarterly review of regression suite health

## Lead Agent

**qa-engineer** is the sole owner. **backend-lead** reviews API integration test scope. **frontend-lead** reviews UI E2E selectors and visual regression scope. **product-manager** reviews acceptance-criteria coverage.

## Inputs

- `projects/{id}/04-implementation/backlog.yaml` — story list (drives critical journey identification)
- `projects/{id}/04-implementation/api-spec.md` — API surface (drives integration test scope)
- `projects/{id}/02-strategy/product-strategy.md` — KGI / user-flow priority
- `projects/{id}/02-strategy/sitemap.md` (if A-series) — page list

## Process

### 1. Identify critical user journeys

From the backlog and product-strategy, distill 5-10 critical journeys for B-series, 3-5 for A-series:

```yaml
# projects/{id}/05-qa/critical-journeys.yaml
journeys:
  - id: CJ-001
    name: 新規ユーザー登録 → 初回ログイン → ダッシュボード到達
    user_role: anonymous
    priority: P0       # P0 = launch blocker, P1 = high, P2 = medium
    api_endpoints_touched:
      - auth.signUp
      - auth.verifyEmail
      - auth.signIn
      - dashboard.get
    ui_pages_touched:
      - /sign-up
      - /sign-up/check-email
      - /sign-in
      - /dashboard
    acceptance_criteria:
      - 登録フォーム送信 → 確認メール受信
      - 確認メール内リンク押下 → 検証完了
      - パスワードでログイン成功
      - ダッシュボード初期表示完了
    e2e_test_path: tests/e2e/auth/full-signup-flow.spec.ts

  - id: CJ-002
    name: お問い合わせフォーム送信(認証不要)
    ...
```

Rule: each P0 journey must be E2E-covered. P1/P2 may rely on integration / manual testing.

### 2. Define test pyramid

Allocate test count by tier:

```
B-series default target (12-month maturity):
- Unit:        ~150-300 tests (60-70%)
- Integration: ~50-100 tests  (20-30%)
- E2E:         ~10-20 tests   (10%)

A-series target:
- Unit:        ~10-30 tests (utilities only)
- Integration: ~5-15 tests (form submission, search)
- E2E:         ~3-5 tests (critical journeys only)
```

Document ownership:
- Unit: backend-engineer (business logic), frontend-engineer (component utilities)
- Integration: backend-engineer (API + DB)
- E2E: qa-engineer (primary), frontend-engineer (UI selector strategy)

### 3. Tooling

| Layer | Tool | Reason |
|---|---|---|
| Unit | Vitest | Fast, modern, native ESM, good DX |
| Integration | Vitest + supertest / fetch | Same runner; less context switch |
| E2E | Playwright | Multi-browser, modern, good DX, cheap on CI |
| A11y | @axe-core/playwright + Pa11y CI | Layered: axe in E2E, Pa11y on static render |
| Visual regression | Chromatic (optional, B-series with brand-sensitive UI) | Storybook-native |
| Lighthouse | Lighthouse CI on PR | Per-page thresholds |

### 4. Test data strategy

```
Test users:
  e2e+admin@aileap.test    — admin role
  e2e+user@aileap.test     — standard user
  e2e+guest@aileap.test    — limited role (if applicable)
Password (all): EUTest!2026

Database state:
  - Reset between E2E tests via DB transaction rollback
  - Or: truncate + seed with test fixtures (slower but reliable)

Fixtures location: tests/fixtures/
Factory functions: tests/factories/{entity}.factory.ts
```

### 5. CI integration

```yaml
# .github/workflows/test.yml — qa-engineer's portion (joint with devops-engineer)
test:
  - pnpm test:unit       (every PR + every push to main)
  - pnpm test:integration (every PR)
  - pnpm test:e2e:critical (PR with @e2e label OR push to main)
  - pnpm a11y            (every PR)
  - pnpm lighthouse      (PR only — comment delta to PR)
```

Approximate CI time budget:
- Unit: <60 seconds
- Integration: <3 min
- E2E (critical): <10 min
- A11y: <2 min
- Lighthouse: <5 min

If approaches the budget, parallelize across runners or split critical-journey suite into shards.

### 6. Regression strategy

`projects/{id}/05-qa/regression-suite.md` lists:
- Every fixed defect with the regression test that prevents recurrence
- Every critical journey that has E2E
- Every API endpoint that has integration test coverage

Update procedure:
- Bug fixed → qa-engineer adds regression test in same PR
- New feature → qa-engineer adds critical journey if user-visible

### 7. Pre-launch QA gate

Before launch:

```
QA Gate Checklist:
[x] All P0 critical journeys: E2E green
[x] All API endpoints with mutation: integration test coverage
[x] Lighthouse Performance ≥ 90 on all key pages
[x] Lighthouse Accessibility ≥ 95 on all key pages
[x] axe-core: 0 Critical, 0 Serious findings
[x] Manual smoke-test of 3 critical journeys on production-like environment
[x] Regression suite: all green
```

If any item fails: launch is **blocked**; produce defect list and triage with backend-lead + product-manager.

### 8. Write the plan

Output `projects/{id}/05-qa/test-strategy.md`:

```markdown
# テスト戦略 — v1

**案件**: {project-id}
**作成者**: qa-engineer
**承認**: backend-lead, frontend-lead, product-manager

## クリティカルジャーニー

(critical-journeys.yaml の summary 表)

## テストピラミッド

(layer ごとの test 件数目標 + 担当)

## ツーリング

(stack list)

## テストデータ

(test users + fixtures + factories)

## CI 統合

(workflow YAML 抜粋)

## リグレッション戦略

(regression-suite.md の運用ルール)

## 公開前 QA ゲート

(check list)
```

## Outputs

- `projects/{id}/05-qa/test-strategy.md` (Japanese)
- `projects/{id}/05-qa/critical-journeys.yaml` (machine-readable)
- `projects/{id}/05-qa/regression-suite.md` (Japanese)
- Test code scaffolding under `tests/` (unit / integration / e2e directories)
- Updates to `.github/workflows/test.yml` (joint with devops-engineer)

## Boundary Notes

- B-series primary; A-series uses lighter "QA gate" version
- E2E for **critical journeys only** — over-investing in E2E creates flaky CI and slows feedback
- qa-engineer does NOT gate code review (backend-lead / frontend-lead do)
- Regression suite is **append-only** — never delete, only mark obsolete
- Test data must be anonymized — even fixtures use `e2e+...@aileap.test` patterns

## Reference Documents

- `.claude/agents/tier3-qa-engineer.md` (lead agent definition)
- `.claude/agents/tier2-backend-lead.md` (test pyramid review)
- `.claude/agents/tier2-frontend-lead.md` (UI E2E selector strategy)
- `.claude/skills/sprint-plan/SKILL.md` (acceptance criteria source)
- `.claude/hooks/lighthouse-budget.sh` (budget enforcement)
