# Sprint 03 — LLM 要約 + 議事録 PDF

**期間**: 2026-09-13(日)〜 2026-09-26(土)/ 2 週間
**Sprint Goal**: 文字起こしから構造化議事録 + PDF が自動生成される(完成 e2e)
**作成者**: product-manager
**版**: 1.0
**前提**: Week 4 PMF Gate **continue** 判断後の着手

---

## Sprint Capacity

| 担当 | 容量 | 関与レベル |
|---|---|---|
| backend-engineer | 36h | full(Claude + PDF 主役) |
| product-director | 4h | プロンプトチューニング監修 |
| frontend-engineer | 12h | 議事録閲覧 UI |
| qa-engineer | 8h | E2E 拡張 |
| **合計** | **60h** | |

---

## Committed Stories

| Story | Owner | Hours | DoD |
|---|---|---|---|
| STORY-012: Claude API 統合 + プロンプトチューニング | backend-engineer + product-director | 16h | 構造化議事録の安定生成 |
| STORY-013: 構造化議事録の保存(JSONB) | backend-engineer | 8h | summaries.content JSONB |
| STORY-014: 議事録 PDF 生成 | backend-engineer | 12h | react-pdf で完成版 PDF |
| STORY-015: 議事録閲覧 UI | frontend-engineer | 12h | /recordings/:id |
| STORY-016: 完了通知メール | backend-engineer | 4h | Resend で送信 |
| STORY-017: E2E テスト(録音 → 要約 → PDF)| qa-engineer | 8h | end-to-end 完走 |
| **合計** | | **60h** |

---

## 依存関係

```
STORY-012(Claude)→ STORY-013(JSONB 保存)→ STORY-014(PDF)→ STORY-016(完了通知)
                                                           ↘
                                                             STORY-015(UI)→ STORY-017(E2E)
```

クリティカルパス: STORY-012 → 013 → 014 → 015 → 017

---

## ★ プロンプトチューニング戦略(STORY-012)

product-director 監修で 4 種のプロンプトをテスト:

| プロンプト案 | 特徴 | 評価 |
|---|---|---|
| A: Single-shot | 「議事録を作って」と全文投げる | baseline |
| B: Sectioned | 「タイトル → 参加者 → アジェンダ → ...」と段階的に抽出 | A よりさらに正確 |
| C: Few-shot | 良い議事録例を 2 件示してから生成 | B + 形式の安定性 |
| D: CoT | 「重要度判定 → 抽出 → 整形」の Chain of Thought | 重要度判定が改善 |

最終採用:**B + 部分的 D**(段階抽出 + CoT で重要度)。

評価指標:
- accuracy_score(LLM 自己評価)4.0+
- Shin の人手評価 4.5+(Day 5 / Day 10 で実施)

---

## リスク + 緩和

| リスク | 緩和 |
|---|---|
| プロンプトチューニング工数超過 | Day 5 に Shin と中間レビュー / 4 案中 1 案で確定 |
| Claude API レート制限 | Tier 適切設定 + バックオフ retry |
| PDF レイアウトの調整 | react-pdf のテンプレート 1 種で確定(複雑化しない) |

---

## Sprint Review(2026-09-26 完了報告)

### 完了ストーリー

| Story | Status | hours |
|---|---|---|
| STORY-012 | done | 18h(+2h: プロンプト B + D の融合調整) |
| STORY-013 | done | 8h |
| STORY-014 | done | 12h |
| STORY-015 | done | 12h |
| STORY-016 | done | 4h |
| STORY-017 | done | 8h |
| **合計** | | **62h**(+2h は STORY-012 の延長分) |

### Demo(Shin 確認)

- Sprint 02 の 5 名テストユーザー録音(累計 17 件)を Claude 要約
- 平均 accuracy_score(LLM 自己評価): 4.3 / 5.0
- Shin 人手評価: 4.5 / 5.0
- PDF 生成・ダウンロード OK

✅ Shin 確認済み。

### ブロッカー

なし。プロンプトチューニング 2h 延長は capacity 内。

### 学び

- Claude のプロンプト B + D 融合は予想以上の精度
- react-pdf は十分・puppeteer は不要(複雑化回避)
- Shin の人手評価 4.5 は Sprint 02 のテストユーザー評価 4.2 より高い → **PMF 仮説維持**

---

## 次スプリントへの carry-over

なし。

---

**Document Owner**: product-manager
**Last Updated**: 2026-09-26
**Version**: 1.0
