# Sprint 01 — インフラ + 認証 + 基本 CRUD

**期間**: 2026-08-16(月)〜 2026-08-29(土)/ 2 週間
**Sprint Goal**: ユーザーがメールから magic link で login できる + 管理者が招待発行できる + 基本データモデル完成
**作成者**: product-manager
**版**: 1.0
**作成日**: 2026-08-16

---

## Sprint Capacity

| 担当 | 容量 | 関与レベル |
|---|---|---|
| backend-engineer | 32h | full |
| devops-engineer | 16h | full |
| frontend-engineer | 8h | partial(UI 整備のみ) |
| qa-engineer | 4h | preparation(E2E 準備) |
| **合計** | **60h** | (Sprint Capacity) |

実工数想定: 56h(余裕 4h で blockers 対応)

---

## 1. Sprint 01 Committed Stories

[backlog.yaml](../backlog.yaml) より:

| Story | Owner | Hours | DoD(Definition of Done)|
|---|---|---|---|
| STORY-001: Supabase project 初期化 + RLS 設計 | devops-engineer | 6h | RLS テスト pass |
| STORY-002: Next.js + Supabase Auth(magic link)| backend-engineer | 12h | Login → callback → session |
| STORY-003: 招待発行管理画面 | backend-engineer | 8h | /admin/invite で発行 → メール到達 |
| STORY-004: User / Invitation / Recording テーブル + 基本 CRUD | backend-engineer | 8h | DB schema 適用 + API 動作 |
| STORY-005: Vercel 本番環境設定 | devops-engineer | 4h | production / preview 環境変数分離 |
| STORY-006: CI/CD(GitHub Actions)| devops-engineer | 6h | PR で typecheck / build / test |
| **合計** | | **44h** | |

実装工数 44h + frontend 整備 4h + qa 準備 4h = **52h**(容量 60h 内)。

---

## 2. 依存関係

```
STORY-001(Supabase 初期化)
    ↓
STORY-004(テーブル + RLS)
    ↓
STORY-002(Auth)
    ↓
STORY-003(招待発行)

並列可能:
- STORY-005(Vercel 環境)
- STORY-006(CI/CD)
```

クリティカルパス: STORY-001 → 002 → 003

---

## 3. リスク + 緩和

| リスク | 緩和 |
|---|---|
| Supabase 初期化での schema 設計ミス | early review(Day 2 で backend-lead レビュー) |
| Magic link メール到達の遅延 | Resend を fallback 候補として準備 |
| CI/CD 環境変数設定漏れ | チェックリスト化 + devops が pair で確認 |

---

## 4. Definition of Done(全ストーリー共通)

- [ ] PR 作成 + backend-lead or technology-director レビュー
- [ ] typecheck / lint / build pass
- [ ] unit test 主要パス pass
- [ ] DB マイグレーションが staging で動作確認
- [ ] 環境変数 production / preview 分離
- [ ] audit_logs に主要アクション記録(該当ストーリーのみ)

---

## 5. Sprint Cadence

| 日 | 活動 |
|---|---|
| Day 1(月)| Sprint 計画 → 着手 |
| Day 5(金)| ミッドスプリントチェック(進捗確認 + ブロッカー triage) |
| Day 10(土)| Sprint Review + Demo |
| Day 10 | Sprint Retro(次スプリントへの改善) |
| Day 11(日)| Sprint 02 計画 |

---

## 6. Sprint Review(2026-08-29 完了報告)

### 6.1 完了ストーリー

| Story | Status | 所要 hours |
|---|---|---|
| STORY-001 | done | 6h |
| STORY-002 | done | 11h(-1h: Supabase 標準機能で簡素化) |
| STORY-003 | done | 8h |
| STORY-004 | done | 9h(+1h: RLS の調整) |
| STORY-005 | done | 4h |
| STORY-006 | done | 6h |
| **合計** | | **44h**(計画通り) |

### 6.2 Demo 内容(Shin 確認)

- 招待発行 → メール受信 → magic link クリック → ログイン
- /dashboard 表示(空状態)
- /admin/users で自分が表示

✅ Shin 確認済み。

### 6.3 ブロッカー

なし。

### 6.4 学び(Sprint Retro)

- **良かった**:Supabase Auth の magic link が標準機能で実装工数最小
- **改善点**:CI に lighthouse を追加すべき(Sprint 02 で対応)
- **継続**:RLS のテストパターンを早期に確立できた

---

## 7. 次スプリントへの carry-over

なし。全ストーリー完了。

---

## 8. 検証メモ(Phase I-B)

- /sprint-plan スキル(B 系新規)の動作確認
- product-manager が Sprint Capacity / Definition of Done / リスク / Cadence を定型化
- agent-coordination-map.md §11.5(B 系スプリント協調)の Day 1 / 5 / 10 / 11 サイクルが動作

---

**Document Owner**: product-manager
**Last Updated**: 2026-08-29
**Version**: 1.0
