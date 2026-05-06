# Sprint 02 — 録音 upload + Whisper 統合

**期間**: 2026-08-30(日)〜 2026-09-12(土)/ 2 週間
**Sprint Goal**: ユーザーが録音をアップロードすると Whisper で文字起こしされる(end-to-end)
**作成者**: product-manager
**版**: 1.0

---

## Sprint Capacity

| 担当 | 容量 | 関与レベル |
|---|---|---|
| backend-engineer | 32h | full(Whisper 統合・主役) |
| devops-engineer | 12h | Inngest 設定 |
| frontend-engineer | 12h | upload UI |
| qa-engineer | 8h | E2E 基盤 |
| **合計** | **64h** | |

---

## Committed Stories

| Story | Owner | Hours | DoD |
|---|---|---|---|
| STORY-007: 録音アップロード API | backend-engineer | 12h | POST /api/v1/recordings 動作 + Storage upload |
| STORY-008: Inngest ジョブキュー設定 | devops-engineer + backend-engineer | 8h | event 発火 → worker 実行 |
| STORY-009: Whisper API 統合 + 文字起こし保存 | backend-engineer | 16h | Whisper → transcripts 保存 |
| STORY-010: ユーザー UI(録音 upload + 進捗表示) | frontend-engineer | 12h | /upload + 進捗バー |
| STORY-011: E2E テスト基盤 | qa-engineer | 8h | Playwright + critical journey 1 件 |
| **合計** | | **56h** |

---

## 依存関係

```
STORY-007(API + Storage)→ STORY-009(Whisper)→ STORY-011(E2E)
                       ↘
                         STORY-008(Inngest)→ STORY-009
                       ↘
                         STORY-010(UI)
```

---

## リスク + 緩和

| リスク | 緩和 |
|---|---|
| Whisper の日本語精度不足 | プロンプトチューニング + 後処理で訂正 |
| 60 分音声処理での timeout | 非同期処理(Inngest)で根本解決 |
| ファイル 1GB upload での network タイムアウト | resumable upload は v1.5・本案件は単発 |

---

## Sprint Review(2026-09-12 完了報告)

### 完了ストーリー

| Story | Status | hours |
|---|---|---|
| STORY-007 | done | 12h |
| STORY-008 | done | 8h |
| STORY-009 | done | 17h(+1h: Whisper retry ロジック追加) |
| STORY-010 | done | 12h |
| STORY-011 | done | 8h |
| **合計** | | **57h** |

### Demo(Shin 確認)

- 5 名の社内ユーザーで録音 upload テスト(15-30 分音声 × 5 件)
- Whisper 文字起こし完了率 100%(5/5)
- 平均処理時間 4 分 / 録音(60 分音声で約 8 分の見込み)

✅ Shin 確認済み。**APV-004(Sprint 02 完了レビュー)approved**。

### ブロッカー

なし(retry ロジックは予想通り追加対応で吸収)。

### 学び

- Whisper-large-v3 の日本語精度は予想以上(95% 程度)
- Inngest の Step ベース実装が retry / 再開を非常にシンプルにする
- E2E テストの 60 分音声テストケースは時間かかるため CI ではスキップ(ローカル + nightly)

---

## ★ 次の重要マイルストーン: Week 4 PMF Gate(2026-09-13)

Sprint 02 完了直後に **product-director 主担当の PMF Gate** を実施:

- [pmf-validation-week-4.md](../../06-handoff/pmf-validation-week-4.md)
- evidence: 5 名のテストユーザー文字起こし結果
- decision: continue / pivot / kill
- approved by: Shin

DEC-008 で記録予定。Sprint 03 着手は PMF Gate 通過後。

---

**Document Owner**: product-manager
**Last Updated**: 2026-09-12
**Version**: 1.0
