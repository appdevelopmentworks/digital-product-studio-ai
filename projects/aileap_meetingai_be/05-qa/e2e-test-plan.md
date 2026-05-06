# E2E テスト計画 — AILEAP MeetingAI β版 BE

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15(計画)/ 2026-09-30(実行結果反映)
**作成者**: qa-engineer(B 系・新規)/ backend-lead と frontend-lead 横レビュー
**ステータス**: ✅ Pass(launch ゲート通過)

> /e2e-test-plan スキル(B 系新規)の動作検証。qa-engineer 主担当の中核ドキュメント。

---

## 0. サマリー

**判定**: ✅ **GO**

| 区分 | 結果 |
|---|---|
| Critical Journey 全 8 件 | **8 / 8 pass** |
| 統合テスト | **all pass** |
| ユニットテスト | 142 / 142 pass |
| Lighthouse(管理画面) | Performance 92 / A11y 100 / SEO 90(管理画面のため低め)/ BP 100 |
| API レイテンシ p95 | 280ms(目標 < 500ms)✅ |
| 録音処理 e2e p95(60 分音声) | 9 分(目標 < 30 分)✅ |
| Critical 問題 | 0 件 |
| High 問題 | 0 件 |
| Medium 問題 | 2 件(Phase 5 で対応) |

---

## 1. テスト戦略

### 1.1 テストピラミッド

```
        ┌──────────────────┐
        │   E2E (Playwright)  │ 8 critical journeys
        ├──────────────────┤
        │ Integration(API)   │ ~30 ケース
        ├──────────────────┤
        │ Unit(Vitest)       │ ~140 ケース(コア logic)
        └──────────────────┘
```

E2E は critical journey に絞り、unit / integration で広くカバー。

### 1.2 ツール

- E2E: Playwright(Chromium / Webkit / Firefox)
- Integration: Vitest + Supabase test DB
- Unit: Vitest
- a11y: @axe-core/playwright(全 critical journey で実行)

### 1.3 環境

- ローカル:Supabase ローカル + Inngest dev
- CI:Supabase Branch DB + Inngest 統合
- Staging:本番に近い環境(本番 DB の sandbox スキーマ)

---

## 2. Critical User Journeys(全 8 件)

| CJ | フロー | 期待結果 | テスト hours |
|---|---|---|---|
| CJ-001 | 招待発行 → メール受信 → magic link → 登録完了 | session 確立 | 4h |
| CJ-002 | 録音 upload → 進捗表示 → 完了通知 | recording.status='completed' + メール到達 | 4h |
| CJ-003 | 議事録閲覧 → PDF DL | PDF ダウンロード成功 | 2h |
| CJ-004 | 自分以外の録音にアクセス試行 | 404(RLS) | 1h |
| CJ-005 | 管理者:招待発行 + ユーザー一覧表示 | invitation 作成 + admin 権限確認 | 2h |
| CJ-006 | 管理者:利用統計 / LLM コスト表示 | /admin/stats 表示 | 2h |
| CJ-007 | 録音ファイル 1GB upload | 成功(or 適切なエラー)| 2h |
| CJ-008 | 録音処理 60 分音声 e2e | < 30 分で completed | 3h(nightly) |

CJ-008 は時間かかるため CI ではスキップ → ローカル + nightly + 公開前 1 回のみ実行。

---

## 3. テスト実装

### 3.1 ファイル構成

```
tests/
├── e2e/
│   ├── critical-journeys/
│   │   ├── cj-001-invite-and-login.spec.ts
│   │   ├── cj-002-upload-and-process.spec.ts
│   │   ├── cj-003-view-summary-and-pdf.spec.ts
│   │   ├── cj-004-rls-other-user.spec.ts
│   │   ├── cj-005-admin-invite.spec.ts
│   │   ├── cj-006-admin-stats.spec.ts
│   │   ├── cj-007-large-file-upload.spec.ts
│   │   └── cj-008-long-audio-e2e.spec.ts(nightly)
│   ├── a11y/
│   │   ├── login.spec.ts
│   │   ├── dashboard.spec.ts
│   │   ├── upload.spec.ts
│   │   └── admin.spec.ts
│   └── helpers/
│       ├── auth.ts
│       └── fixtures.ts
├── integration/
│   ├── api/
│   │   ├── recordings.test.ts
│   │   ├── auth.test.ts
│   │   └── admin.test.ts
│   └── inngest/
│       └── process-recording.test.ts
└── unit/
    ├── lib/
    │   ├── audit.test.ts
    │   ├── llm/
    │   │   ├── whisper.test.ts
    │   │   └── claude.test.ts
    │   └── pdf/
    │       └── render.test.ts
    └── components/
        └── ...
```

### 3.2 サンプル: CJ-002(録音 upload → 完了)

```typescript
test('CJ-002: 録音 upload → 完了通知', async ({ page }) => {
  // 1. ログイン(招待 → magic link を fixture で skip)
  await loginAsUser(page, 'test-user@example.com');

  // 2. /upload ページへ
  await page.goto('/upload');

  // 3. ファイル選択(15 分の音声 fixture)
  await page.locator('input[type="file"]').setInputFiles('fixtures/15min-jp.mp3');
  await page.locator('input[name="title"]').fill('Test 会議');
  await page.locator('button[type="submit"]').click();

  // 4. ダッシュボードへリダイレクト + 録音表示
  await expect(page).toHaveURL('/dashboard');
  const recordingCard = page.locator('[data-testid="recording-card"]').first();
  await expect(recordingCard).toContainText('Test 会議');

  // 5. ステータス遷移を polling(タイムアウト 10 分)
  await expect(recordingCard.locator('[data-testid="status"]'))
    .toContainText('completed', { timeout: 10 * 60 * 1000 });

  // 6. 完了通知メール到達確認(Resend テストモード)
  await expectEmailDelivered('test-user@example.com', 'MeetingAI 議事録');

  // 7. a11y 自動チェック
  const violations = await getAxeViolations(page);
  expect(violations.filter(v => v.impact === 'critical')).toHaveLength(0);
});
```

### 3.3 サンプル: CJ-004(RLS テスト)

```typescript
test('CJ-004: 他ユーザー録音にアクセス → 404', async ({ page }) => {
  // 別ユーザーの録音を fixture で作成
  const otherRecordingId = await createOtherUserRecording();

  // 自分のセッションで /recordings/<other-id> アクセス
  await loginAsUser(page, 'me@example.com');
  await page.goto(`/recordings/${otherRecordingId}`);

  // 404 表示
  await expect(page.locator('h1')).toContainText('Not Found');
});
```

---

## 4. パフォーマンステスト

### 4.1 API レイテンシ計測

CI の load test で:
- /api/v1/me: p95 < 200ms ✅(実測 80ms)
- /api/v1/recordings(GET 一覧): p95 < 200ms ✅(120ms)
- /api/v1/recordings(POST upload): p95 < 500ms ✅(280ms)
- /api/v1/admin/stats: p95 < 500ms ✅(180ms)

### 4.2 録音処理レイテンシ

| 音声長 | 期待処理時間 | 実測 | 判定 |
|---|---|---|---|
| 15 分 | < 5 分 | 3 分 20 秒 | ✅ |
| 30 分 | < 10 分 | 5 分 40 秒 | ✅ |
| 60 分 | < 30 分 | 9 分 10 秒 | ✅ |

p95 すべて目標を大幅にクリア。

---

## 5. アクセシビリティテスト(管理画面 + ユーザー UI)

aileap_v2 design-system 継承により WCAG 2.2 AA は基本達成。本案件特有のチェック:

| ページ | axe violations | 手動キーボード |
|---|---|---|
| /login | 0 | ✅ Tab 順序 OK |
| /dashboard | 0 | ✅ |
| /upload | 0 | ✅(ファイル選択も) |
| /recordings/:id | 0 | ✅ |
| /admin | 0 | ✅(サイドバーキーボード操作) |
| /admin/users | 0 | ✅ |
| /admin/invite | 0 | ✅(モーダルの focus trap) |

---

## 6. 検出された問題

### Critical / High: なし

### Medium

#### M-001: Sentry の error rate alert 閾値が厳しすぎ

- 症状: 公開直後にユーザーの誤操作(無効ファイル upload 等)で 4xx が頻発し alert noise
- 推奨: 4xx は alert から除外 / 5xx のみ閾値設定
- 影響度: 中(運用 noise)
- 対応者: devops-engineer
- 対応期日: Phase 5 内

#### M-002: 60 分音声テストの CI 実行時間

- 症状: nightly で 60 分音声 e2e が 12-15 分かかり CI コスト高
- 推奨: 通常 nightly では 15 分音声のみ + 週 1 で 60 分テスト
- 影響度: 中(CI コスト)
- 対応者: qa-engineer + devops-engineer

### Low: なし

---

## 7. 公開前の最終チェック(2026-10-04)

- [x] 全 critical journey pass(CJ-001 〜 CJ-008)
- [x] 全統合テスト pass
- [x] 全ユニットテスト pass(142/142)
- [x] axe-core a11y 違反 0 件
- [x] Lighthouse 管理画面 Performance 90+
- [x] API レイテンシ p95 全エンドポイント目標達成
- [x] 録音処理 e2e 30 分以内

---

## 8. WMAO への申し送り(B 系・none scope のため部分的)

B 系では WMAO 引継ぎが原則 none。集客 LP 側(aileap_meetingai_lp)経由でのみ部分的に関与。
本書は本組織内の qa-engineer の継続運用ドキュメントとして保持。

---

## 9. Sign-off

| 役割 | 名前 | 日付 |
|---|---|---|
| 監査者 | qa-engineer | 2026-09-30 |
| Backend 確認 | backend-lead | 2026-09-30 |
| Frontend 確認 | frontend-lead | 2026-09-30 |
| Product 確認 | product-director | 2026-10-04 |
| 最終承認 | delivery-director | 2026-10-04 |

**判定**: ✅ launch ゲート通過

---

## 10. 検証メモ(Phase I-B)

- /e2e-test-plan スキル(B 系新規)の動作検証
- qa-engineer の主担当ドキュメントとして、テストピラミッド + critical journey + パフォーマンス + a11y を統合的にカバー
- B 系特有の test type(API contract / DB migration dry-run / load test)が CI に組み込まれた

---

**Document Owner**: qa-engineer
**Last Updated**: 2026-10-04
**Version**: 1.0
