---
name: api-design
description: Author API specification and contract for a B-series project — endpoints, request/response shapes, error envelope, auth requirements, idempotency, versioning. Lead agent backend-engineer (Tier 3, new in v0.3) with backend-lead architectural review. Outputs both human-readable spec and shared TypeScript types.
auto_trigger_keywords:
  - API 設計
  - api design
  - API スキーマ
  - エンドポイント設計
  - REST API
  - tRPC
  - GraphQL
  - API 仕様
  - api spec
---

# /api-design

## Purpose

Produce the API specification and TypeScript type contract for a B-series project (or for a non-trivial A-series backend like contact form + CRM webhook). The output drives backend implementation, frontend consumption, and qa-engineer's integration tests.

The API design is **co-owned by backend-engineer and frontend-engineer** for the contract surface. backend-engineer drives the spec; frontend-engineer reviews for consumption ergonomics.

## When to Use

- Before implementing a new API endpoint
- When extending an existing endpoint (breaking change requires new design)
- When versioning a public API (v1 → v2)
- When the contract between frontend and backend needs to be re-aligned

## Lead Agent

**backend-engineer** authors the spec. **backend-lead** reviews architecture (REST vs. tRPC vs. GraphQL choice, error envelope, auth strategy). **frontend-engineer** reviews for consumption (type ergonomics, request flow). **qa-engineer** reviews for testability.

## Inputs

- Story / epic acceptance criteria (from `backlog.yaml`)
- Existing API spec if extending (`projects/{id}/04-implementation/api-spec.md`)
- Auth strategy from `02-strategy/product-strategy.md` (or backend-lead's stack notes)
- Database schema (`db/schema.ts`) — to validate that the API surface aligns with data layer

## Process

### 1. Choose the right shape

| Shape | Use when |
|---|---|
| REST | Public-facing API, third-party integrators, broad client diversity |
| tRPC | Internal-first, single TS client (Next.js + same monorepo), type-safe end-to-end |
| GraphQL | Multiple clients with different field needs, strong contract requirements |
| Server Actions (Next.js) | Form-shaped interactions, no public client outside the app |

For B1 SaaS MVP default: **tRPC** (fastest type-safe path). For B-series with mobile or third-party API, REST. Document the choice in the spec.

### 2. Enumerate endpoints (or procedures)

Group by resource:

```
auth.signUp           — POST /api/auth/sign-up      | tRPC: auth.signUp
auth.signIn           — POST /api/auth/sign-in      | tRPC: auth.signIn
auth.verifyEmail      — POST /api/auth/verify-email | tRPC: auth.verifyEmail
projects.list         — GET  /api/projects          | tRPC: projects.list
projects.create       — POST /api/projects          | tRPC: projects.create
projects.get          — GET  /api/projects/:id      | tRPC: projects.get
```

For each, specify:
- HTTP method + path (REST) or namespace.procedure (tRPC)
- Auth requirement (public / authenticated / role-gated)
- Idempotent? (write endpoints usually need idempotency keys)
- Rate-limited? (auth + write endpoints typically yes)

### 3. Define request schema (zod)

```typescript
// src/types/api/auth.ts
import { z } from 'zod';

export const SignUpInput = z.object({
  email: z.string().email().toLowerCase(),
  password: z.string().min(8).regex(/[0-9]/, 'must contain a digit'),
  display_name: z.string().min(1).max(100).optional(),
});
export type SignUpInput = z.infer<typeof SignUpInput>;
```

Rules:
- Email: lowercased server-side
- Password: enforce strength at validation, not silently weaken
- Optional fields explicit (`.optional()`)
- Numeric IDs: `z.coerce.number().int().positive()` (URL params come as string)
- Dates: ISO string at API boundary; convert to Date in business logic

### 4. Define response schema (zod)

```typescript
export const SignUpOutput = z.object({
  id: z.string(),
  email: z.string().email(),
  email_verified: z.boolean(),
  created_at: z.string().datetime(),
});
export type SignUpOutput = z.infer<typeof SignUpOutput>;
```

Rules:
- Never include sensitive fields (password hash, raw tokens)
- Dates as ISO datetime strings
- Snake_case fields if matching DB; camelCase only if frontend prefers (but consistency over either choice)

### 5. Define error envelope

Apply the project's standard error envelope (define once in `src/types/api/_error.ts`):

```typescript
export const ApiError = z.object({
  error: z.object({
    code: z.string(),  // e.g., "AUTH_INVALID_CREDENTIALS", "VALIDATION_FAILED"
    message: z.string(),  // human-friendly message in user's language
    details: z.record(z.any()).optional(),
  }),
});
```

Per endpoint, list the error codes that endpoint can produce:

```
auth.signUp errors:
- VALIDATION_FAILED (400) — input did not pass schema
- EMAIL_ALREADY_EXISTS (409) — email is already registered
- RATE_LIMITED (429) — too many sign-ups from this IP
- SERVER_ERROR (500) — unhandled exception
```

### 6. Define auth and rate-limit policy

Per endpoint:

| Aspect | Specification |
|---|---|
| Auth | none / session / role:admin / api-key |
| Rate limit | 5 requests / 15 min / IP for sign-up; 100 / 1 min for read |
| Idempotency | Required for: sign-up, payment, email-send. Not for: read, idempotent updates by ID |

### 7. Versioning policy

For public APIs:
- URL path versioning: `/api/v1/...` (default)
- Breaking change requires a new version path
- Deprecation: 90 days notice in response headers + docs

For internal-only tRPC: no version path; breaking changes coordinated via PR review.

### 8. Write the spec document

Output `projects/{id}/04-implementation/api-spec.md`:

```markdown
# API 仕様 — v1

**案件**: {project-id}
**形式**: tRPC(同一 Next.js モノレポ内の type-safe 通信)
**作成者**: backend-engineer
**承認**: backend-lead

## 認証戦略

Auth.js v5(Email + Password、 OAuth 後発展)
セッション: HTTP-only cookie / SameSite=Lax / Secure (production)

## エラー枠

(zod スキーマ + error code 一覧)

## エンドポイント一覧

### auth.signUp

| 項目 | 値 |
|---|---|
| 認証 | 不要 |
| HTTP(REST 等価) | POST /api/auth/sign-up |
| Rate limit | 5 / 15 min / IP |
| Idempotent | No(idempotency key で対応) |

#### 入力スキーマ

(zod 定義の貼り付け)

#### 出力スキーマ

(zod 定義の貼り付け)

#### エラーコード

- VALIDATION_FAILED (400)
- EMAIL_ALREADY_EXISTS (409)
- RATE_LIMITED (429)

#### 例

(curl + tRPC client の両方)

### auth.signIn
...
```

### 9. Generate / update shared types

Place final zod schemas in `src/types/api/{resource}.ts`. backend-engineer imports for server-side validation; frontend-engineer imports for client-side type-checking.

## Outputs

- `projects/{id}/04-implementation/api-spec.md` (Japanese for documentation, English for code blocks)
- `src/types/api/{resource}.ts` (shared zod + TypeScript types)
- Optional: OpenAPI 3.x export for public REST APIs (generate from zod via `zod-to-openapi`)

## Boundary Notes

- B-series primary; A-series only when backend is non-trivial (contact form alone does not warrant a full spec)
- `database-schema` skill is co-owned with this skill — design DB and API together for B-series; do not skew one ahead of the other
- Frontend-engineer's review is non-optional: if the consumption ergonomics are bad, change before implementing
- Breaking changes require a new version (REST) or coordinated PR with frontend (tRPC)

## Reference Documents

- `.claude/agents/tier3-backend-engineer.md` (lead agent definition)
- `.claude/agents/tier2-backend-lead.md` (architectural review)
- `.claude/rules/api.md` (path-scoped rule for `src/api/**`)
