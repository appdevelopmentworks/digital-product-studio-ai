# データベース設計 — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: backend-engineer(backend-lead レビュー)
**ステータス**: 承認済(APV-003 / 2026-08-15)

---

## 1. データベース基盤

- **DBMS**: PostgreSQL 15(Supabase ホスト型)
- **拡張**: pgcrypto / uuid-ossp / pg_trgm(将来の検索用)
- **マイグレーション**: Supabase migrations(`supabase/migrations/*.sql`)
- **RLS**: 全主要テーブルで有効化

---

## 2. ER 図(概略)

```
┌─────────┐     ┌──────────────┐
│  users  │ 1—N │ invitations  │
└─────────┘     └──────────────┘
     │ 1
     │
     N
┌─────────────┐  1—1  ┌──────────────┐
│ recordings  │ ────── │ transcripts  │
└─────────────┘        └──────────────┘
     │ 1
     │
     1
┌─────────────┐
│  summaries  │
└─────────────┘

┌──────────────┐  (event log)
│  audit_logs  │
└──────────────┘
```

---

## 3. テーブル定義

### 3.1 users(Supabase Auth が管理)

```sql
-- Supabase Auth の auth.users を参照
-- 公開スキーマ側に拡張プロフィールを持つ:

CREATE TABLE public.user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS: 自分のプロフィール + admin が他者のを read
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile" ON public.user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Admins can read all profiles" ON public.user_profiles
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'admin')
  );
```

### 3.2 invitations

```sql
CREATE TABLE public.invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  token TEXT NOT NULL UNIQUE,           -- magic link token
  used_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL,
  created_by_user_id UUID NOT NULL REFERENCES auth.users(id),
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_invitations_email ON public.invitations(email);
CREATE INDEX idx_invitations_token ON public.invitations(token);

-- RLS: admin のみ
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage invitations" ON public.invitations
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'admin')
  );
```

### 3.3 recordings

```sql
CREATE TABLE public.recordings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  notes TEXT,
  file_path TEXT NOT NULL,              -- Supabase Storage path
  file_size_bytes BIGINT NOT NULL,
  duration_seconds INTEGER,             -- transcribed 後に充填
  status TEXT NOT NULL DEFAULT 'uploaded'
    CHECK (status IN ('uploaded', 'transcribing', 'transcribed',
                      'summarizing', 'summarized',
                      'generating_pdf', 'completed', 'failed')),
  failure_reason TEXT,
  idempotency_key TEXT,
  delete_at TIMESTAMPTZ,                -- auto-delete 30 days after status='completed'
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_recordings_user_id ON public.recordings(user_id);
CREATE INDEX idx_recordings_status ON public.recordings(status);
CREATE INDEX idx_recordings_created_at ON public.recordings(created_at DESC);
CREATE UNIQUE INDEX idx_recordings_idempotency
  ON public.recordings(user_id, idempotency_key)
  WHERE idempotency_key IS NOT NULL;

-- RLS: 自分の record + admin
ALTER TABLE public.recordings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own recordings" ON public.recordings
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Admin can view all metadata" ON public.recordings
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'admin')
  );
```

### 3.4 transcripts(文字起こし)

```sql
CREATE TABLE public.transcripts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recording_id UUID NOT NULL UNIQUE REFERENCES public.recordings(id) ON DELETE CASCADE,
  content TEXT NOT NULL,                -- Whisper 出力テキスト全文
  language TEXT NOT NULL DEFAULT 'ja',
  whisper_model TEXT NOT NULL,          -- whisper-large-v3 等
  whisper_token_count INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transcripts_recording_id ON public.transcripts(recording_id);

ALTER TABLE public.transcripts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own transcripts" ON public.transcripts
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.recordings
            WHERE id = recording_id AND user_id = auth.uid())
  );
```

### 3.5 summaries(要約 / 構造化議事録)

```sql
CREATE TABLE public.summaries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recording_id UUID NOT NULL UNIQUE REFERENCES public.recordings(id) ON DELETE CASCADE,
  content JSONB NOT NULL,               -- 構造化議事録(下記スキーマ)
  pdf_path TEXT,                        -- Supabase Storage path
  llm_model TEXT NOT NULL,              -- claude-sonnet-4-6 等
  llm_input_token_count INTEGER,
  llm_output_token_count INTEGER,
  accuracy_score NUMERIC(3,1),          -- LLM 自己評価 0.0-5.0
  user_rating INTEGER,                  -- ユーザー評価 1-5(別途実装)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_summaries_recording_id ON public.summaries(recording_id);

ALTER TABLE public.summaries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users see own summaries" ON public.summaries
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.recordings
            WHERE id = recording_id AND user_id = auth.uid())
  );
```

### 3.6 summaries.content JSONB スキーマ

```typescript
type SummaryContent = {
  title: string;
  meeting_date?: string;       // ISO date(LLM が抽出可能なら)
  participants?: string[];
  agenda?: string[];
  decisions: Array<{ topic: string; decision: string }>;
  action_items: Array<{ owner: string; task: string; due?: string }>;
  key_quotes?: Array<{ speaker: string; quote: string }>;
  open_questions?: string[];
  next_meeting?: string;
};
```

zod でも型定義(API 設計と整合)。

### 3.7 audit_logs

```sql
CREATE TABLE public.audit_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,                 -- 'recording.uploaded', 'admin.invited' 等
  resource_type TEXT,                   -- 'recording', 'invitation' 等
  resource_id UUID,
  payload JSONB,                        -- アクション固有データ
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON public.audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON public.audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON public.audit_logs(created_at DESC);
CREATE INDEX idx_audit_logs_resource ON public.audit_logs(resource_type, resource_id);

-- RLS: admin のみ
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can read audit logs" ON public.audit_logs
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'admin')
  );
```

---

## 4. データ保持ポリシー

| データ | 保持期間 | 理由 |
|---|---|---|
| 録音ファイル(Supabase Storage) | status='completed' から 30 日 | privacy(LLM 処理後は不要) |
| transcripts | ユーザー削除まで | ユーザーが議事録を後で参照 |
| summaries(JSONB)+ pdf | ユーザー削除まで | ユーザー資産 |
| audit_logs | 1 年 | コンプライアンス |
| invitations(used_at NOT NULL) | 6 ヶ月 | 監査用 |

`delete_at` カラム + Vercel Cron で日次自動削除。

---

## 5. インデックス戦略

[各テーブル定義] 参照。要点:
- user_id を頻繁に使う query → btree index
- created_at DESC で表示する query → btree index(時系列ソート)
- idempotency_key は partial unique index(NOT NULL のみ)

将来の検索機能(v1.5)用:
- transcripts.content に GIN index(pg_trgm)を追加(意味検索ではなく LIKE 検索)

---

## 6. マイグレーション運用

```
supabase/
├── migrations/
│   ├── 20260808000000_initial_schema.sql
│   ├── 20260815000000_add_invitations.sql
│   ├── 20260822000000_add_recordings.sql
│   ├── 20260830000000_add_transcripts.sql
│   ├── 20260906000000_add_summaries.sql
│   ├── 20260920000000_add_audit_logs.sql
│   └── 20260927000000_add_rls_policies.sql
└── seed.sql
```

各マイグレーションは PR で `supabase db diff` を実行 → migration ファイル生成 → CI で apply。

---

## 7. データ整合性 / 制約

- 外部キー:`ON DELETE CASCADE`(recording 削除 → transcripts / summaries も削除)
- status 遷移:アプリ側で enforce(transcribed → summarizing → summarized 等の制約)
- accuracy_score:0.0-5.0(CHECK)
- file_size_bytes:0 < x < 1073741824(1GB)

---

## 8. バックアップ

Supabase の自動バックアップ(daily)+ Point-in-Time Recovery(7 日)で対応。

---

## 9. 検証メモ(Phase I-B)

- backend-engineer 主担当の database-schema 文書として、RLS / 制約 / インデックス戦略を明示
- Supabase の標準機能(auth.users + RLS)を活用して実装工数を削減
- 録音 30 日 auto-delete のプライバシー設計が legal-review.yaml の privacy_policy 拡張条項と整合

---

**Document Owner**: backend-engineer
**Last Updated**: 2026-08-15
**Version**: 1.0
