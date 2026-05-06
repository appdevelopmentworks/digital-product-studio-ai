# API 設計 — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: backend-engineer(backend-lead レビュー / product-director の product-fit 確認)
**ステータス**: 承認済(APV-003 / 2026-08-15)

> /api-design スキル(B 系新規)の動作検証。backend-engineer 主担当の中核ドキュメント。

---

## 1. 設計方針

### 1.1 アーキテクチャ

- REST API(GraphQL は MVP では過剰)
- Edge Runtime ファースト(認証 / 軽量 read 系)
- Node Runtime(録音 upload / Inngest worker 系)
- 認証: Supabase Auth(magic link)→ JWT → API ガード

### 1.2 命名規則

- リソース名:複数形 lowercase(`/api/recordings`)
- ID パラメータ:UUID v4(Supabase 標準)
- 動詞:HTTP メソッドで表現(POST = create / PATCH = partial update)

### 1.3 共通エラーエンベロープ

```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "title is required",
    "details": [
      { "path": ["title"], "message": "Required" }
    ]
  }
}
```

### 1.4 idempotency

POST /api/recordings は `Idempotency-Key` ヘッダーで重複登録を防止(再送対応)。

### 1.5 versioning

URL ベースバージョニング:`/api/v1/recordings`(本案件は v1 のみ)。
v2 は破壊的変更時(SSO 対応 / API 公開)。

---

## 2. エンドポイント一覧

### 2.1 認証系

| メソッド | パス | 用途 | Auth |
|---|---|---|---|
| POST | /api/v1/auth/magic-link | magic link 送信 | none(招待されたメールのみ送信) |
| POST | /api/v1/auth/callback | magic link コールバック(Supabase Auth ベース) | token |
| POST | /api/v1/auth/logout | ログアウト | session |

### 2.2 ユーザー側

| メソッド | パス | 用途 | Auth |
|---|---|---|---|
| GET | /api/v1/me | 自分の情報 | session |
| GET | /api/v1/recordings | 自分の録音一覧 | session |
| POST | /api/v1/recordings | 録音アップロード | session |
| GET | /api/v1/recordings/:id | 録音 + 議事録の状態 | session(自分の録音のみ・RLS) |
| GET | /api/v1/recordings/:id/pdf | 議事録 PDF DL | session(同上) |
| DELETE | /api/v1/recordings/:id | 録音削除(自分のみ) | session(同上) |

### 2.3 管理者側

| メソッド | パス | 用途 | Auth |
|---|---|---|---|
| GET | /api/v1/admin/users | 全ユーザー一覧 | admin role |
| POST | /api/v1/admin/users/invite | 招待発行 | admin role |
| GET | /api/v1/admin/stats | 利用統計 | admin role |
| GET | /api/v1/admin/recordings | 全録音メタデータ(本文は不可・privacy) | admin role |

### 2.4 内部 webhook(Inngest)

| メソッド | パス | 用途 |
|---|---|---|
| POST | /api/v1/webhook/whisper-completed | Whisper 処理完了 |
| POST | /api/v1/webhook/claude-completed | Claude 処理完了 |
| POST | /api/v1/webhook/pdf-generated | PDF 生成完了 |

webhook は HMAC 署名で検証(`X-Inngest-Signature` ヘッダー)。

---

## 3. 主要エンドポイント詳細

### 3.1 POST /api/v1/recordings

**用途**: 録音アップロード(非同期処理を開始)

**Request**(multipart/form-data):
```
file:        File (required, .mp3 | .m4a | .wav, max 1GB)
title:       string (required, 1-200 chars)
notes:       string (optional, 0-1000 chars)
```

**Idempotency-Key Header**: 同じキーでの再送は同じ結果を返す(24h 有効)

**Response 201**:
```json
{
  "recording": {
    "id": "8f7c2a13-1234-...",
    "title": "2026-08-30 経営会議",
    "status": "uploaded",
    "duration_seconds": null,
    "estimated_completion_minutes": 8,
    "created_at": "2026-08-30T10:00:00Z"
  }
}
```

**Response 422**(バリデーション失敗):上記エラーエンベロープ

**Response 413**(ファイルサイズ超過):
```json
{
  "error": {
    "code": "FILE_TOO_LARGE",
    "message": "File size exceeds 1GB limit"
  }
}
```

### 3.2 GET /api/v1/recordings/:id

**Response 200**:
```json
{
  "recording": {
    "id": "8f7c2a13-1234-...",
    "title": "2026-08-30 経営会議",
    "status": "completed",
    "duration_seconds": 3600,
    "transcript": {
      "id": "...",
      "content": "(文字起こし全文)",
      "created_at": "..."
    },
    "summary": {
      "id": "...",
      "content": {
        "title": "2026-08-30 経営会議",
        "participants": ["田中", "佐藤"],
        "agenda": ["第3四半期売上", "新規事業"],
        "decisions": [{ "topic": "...", "decision": "..." }],
        "action_items": [{ "owner": "佐藤", "task": "...", "due": "2026-09-15" }]
      },
      "pdf_url": "/api/v1/recordings/8f7c.../pdf",
      "accuracy_score": 4.3,
      "created_at": "..."
    },
    "created_at": "..."
  }
}
```

**status 値の遷移**:
```
uploaded → transcribing → transcribed → summarizing → summarized → generating_pdf → completed
                                                                                   → failed
```

**Response 404**:他ユーザーの recording へのアクセスも 404(privacy)。

### 3.3 POST /api/v1/admin/users/invite

**Request**:
```json
{
  "email": "user@example.com",
  "note": "テストユーザー(LP 申込者・8/15)"
}
```

**Response 201**:
```json
{
  "invitation": {
    "id": "...",
    "email": "user@example.com",
    "expires_at": "2026-09-13T10:00:00Z",
    "magic_link_url": null
  }
}
```

magic link URL 自体はレスポンスに含めず、Resend 経由でユーザーへ直接送信。

---

## 4. 認証 / 認可

### 4.1 認証フロー(magic link)

```
[1] User → POST /api/v1/auth/magic-link { email }
[2] Server: invitations テーブルで email 確認(招待されてないなら 403)
[3] Server: Supabase Auth で OTP / magic link 発行
[4] Resend で送信
[5] User がリンクをクリック → /auth/callback?token=...
[6] Server: token を Supabase Auth で検証 → セッション確立
[7] Cookie に session 保存(httpOnly + secure + sameSite=lax)
```

### 4.2 認可

- session ベース:Supabase JWT を Cookie で保持
- API は middleware で session 検証
- admin role:Supabase users.app_metadata.role = 'admin' で識別
- RLS:Supabase 側で row level security 設定(他ユーザーの record にアクセス不可)

### 4.3 セッション有効期間

- Access token:1 時間
- Refresh token:30 日(自動更新)

---

## 5. レート制限

Vercel Edge Config + 簡易 KV で実装:

| エンドポイント | 制限 |
|---|---|
| POST /api/v1/auth/magic-link | 5 req / 15 min(IP ベース)|
| POST /api/v1/recordings | 10 req / hour(user ベース)|
| POST /api/v1/admin/users/invite | 50 req / day(admin ベース)|

---

## 6. データ保護

- HTTPS 必須
- Supabase Storage:AES-256 自動暗号化
- 録音ファイル:解析後 30 日で auto delete(プライバシー観点)
- 文字起こし / 議事録:ユーザーが削除するまで保持
- LLM API:Claude / Whisper の "Train on customer data: false" 確認済
- audit_logs にユーザーアクションを記録(誰が何をいつ)

---

## 7. パフォーマンス目標

| エンドポイント | p95 目標 |
|---|---|
| GET /api/v1/me / recordings 一覧 | < 200ms(Edge Runtime) |
| POST /api/v1/recordings(upload + ジョブ登録)| < 500ms(Node Runtime) |
| 録音処理 end-to-end(60 分音声)| < 30 分 |

---

## 8. エラーコード一覧

| code | HTTP | 用途 |
|---|---|---|
| VALIDATION_FAILED | 422 | リクエスト validation 失敗 |
| FILE_TOO_LARGE | 413 | ファイルサイズ超過 |
| UNAUTHORIZED | 401 | 認証なし |
| FORBIDDEN | 403 | 権限不足(admin role 必須等) |
| NOT_FOUND | 404 | リソースが存在しない |
| RATE_LIMIT_EXCEEDED | 429 | レート制限 |
| INTERNAL_ERROR | 500 | 予期しないエラー(Sentry に記録) |
| LLM_API_FAILED | 502 | Claude / Whisper API エラー(再送可) |

---

## 9. zod スキーマ(主要)

`src/lib/schemas.ts` に集約:

```typescript
export const RecordingUploadSchema = z.object({
  title: z.string().min(1).max(200),
  notes: z.string().max(1000).optional(),
});

export const InviteUserSchema = z.object({
  email: z.string().email(),
  note: z.string().max(500).optional(),
});

export const RecordingStatusEnum = z.enum([
  'uploaded', 'transcribing', 'transcribed',
  'summarizing', 'summarized',
  'generating_pdf', 'completed', 'failed',
]);
```

クライアント / サーバー両方で同じスキーマを使用(型共有)。

---

## 10. 検証メモ(Phase I-B)

- /api-design スキル(B 系新規)の動作確認
- backend-engineer 主担当 / backend-lead レビュー / product-director の product-fit 確認のフロー OK
- zod 型共有パターンが aileap_v2 / aileap_meetingai_lp と整合
- API 設計時点で RLS / authorization / rate limit が明示されているため、Sprint 01 着手時に手戻りなし

---

**Document Owner**: backend-engineer
**Last Updated**: 2026-08-15
**Version**: 1.0
