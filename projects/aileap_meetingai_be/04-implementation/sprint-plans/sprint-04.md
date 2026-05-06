# Sprint 04 — 管理画面 + 利用統計(短縮スプリント)

**期間**: 2026-09-27(日)〜 2026-09-29(火)/ 3 日(短縮)
**Sprint Goal**: 管理画面ダッシュボード + 利用統計 + 監視が動作 → 公開準備完了
**作成者**: product-manager
**版**: 1.0
**注**: 8 週間スケジュールで PMF gate 後に Sprint 03 が予定通り進んだため、Sprint 04 は短縮(3 日)

---

## Sprint Capacity

| 担当 | 容量 | 関与レベル |
|---|---|---|
| backend-engineer | 16h | 統計 API |
| frontend-engineer | 12h | 管理画面 UI |
| devops-engineer | 8h | 監視 / アラート |
| qa-engineer | 4h | リグレッション |
| **合計** | **40h** |

---

## Committed Stories

| Story | Owner | Hours | DoD |
|---|---|---|---|
| STORY-018: 管理画面ダッシュボード | frontend-engineer + backend-engineer | 12h | /admin 表示 |
| STORY-019: 利用統計 API + UI | backend-engineer + frontend-engineer | 12h | /api/admin/stats + recharts |
| STORY-020: LLM コスト集計 | backend-engineer | 4h | audit_logs ベース集計 |
| STORY-021: 監視 / アラート | devops-engineer | 8h | Sentry / UptimeRobot / Slack 通知 |
| STORY-022: 公開前最終 E2E + リグレッション | qa-engineer | 4h | 全 critical journey pass |
| **合計** | | **40h** |

---

## 依存関係

```
STORY-019(API)→ STORY-018(UI)
              ↘
                STORY-020(コスト集計)

STORY-021(監視)は並列
STORY-022(QA)は STORY-018 + 019 完了後
```

---

## リスク + 緩和

| リスク | 緩和 |
|---|---|
| 短縮スプリント(3 日)で時間不足 | scope を「管理画面 MVP + 監視のみ」に厳格に絞る |
| recharts 学習コスト | aileap_v2 で前例なし → 簡素なライブラリで代替可(victory chart など) |
| Sentry alert noise | 初期は warning のみ Slack / error は admin email |

---

## Sprint Review(2026-09-29 完了報告)

### 完了ストーリー

| Story | Status | hours |
|---|---|---|
| STORY-018 | done | 12h |
| STORY-019 | done | 12h |
| STORY-020 | done | 4h |
| STORY-021 | done | 8h |
| STORY-022 | done | 4h |
| **合計** | | **40h**(計画通り) |

### Demo(Shin 確認)

- 管理画面 /admin で利用統計表示
- LLM コストグラフ(直近 7 日 ¥3,500・想定内)
- Sentry / UptimeRobot 動作確認
- 全 critical journey E2E pass

✅ Shin 確認済み。**Sprint 04 完了 → QA 着手**。

### 次へ:QA + Launch

- 2026-09-30: 全監査(SEO / a11y / E2E)
- 2026-10-04: APV-006(launch_approval)
- 2026-10-05: β版公開

---

## Sprint Retro(全 Sprint 通算 / 4 スプリント運営の振り返り)

### 良かった

- B 系新規エージェント 5 体の役割が明確(product-director / product-manager / backend-engineer / devops-engineer / qa-engineer)
- スプリントごとの DoD が機能した
- PMF Gate を Week 4 に置いたのが正解(Sprint 03 着手前に判断できた)
- aileap_v2 / aileap_meetingai_lp のスタック流用で初期立ち上げが速かった

### 改善点

- Sprint 04 の 3 日短縮は PMF Gate を移動させない限り発生 → 8 週間に納める計画自体は妥当
- プロンプトチューニング(STORY-012)は initial estimate より時間かかる傾向 → 次回はバッファを多めに
- E2E テストの 60 分音声テストは ローカル + nightly に分離する運用が早期確立できた

### 継続

- agent-coordination-map.md §11.5 の Day 1 / 5 / 10 / 11 サイクル
- product-director の Quarter Boundary review(本案件は β版完走でゲート達成)

---

## 4 スプリント全体集計

| Sprint | 計画 hours | 実 hours | 計画 stories | 完了 stories |
|---|---|---|---|---|
| Sprint 01 | 44 | 44 | 6 | 6 |
| Sprint 02 | 56 | 57 | 5 | 5 |
| Sprint 03 | 60 | 62 | 6 | 6 |
| Sprint 04 | 40 | 40 | 5 | 5 |
| **合計** | **200h** | **203h** | **22 stories** | **22 / 22** |

実工数 203h は計画 200h の +1.5%(許容範囲内)。

PROJECT.md::estimate.yaml の Sprint 工数想定 220h(Sprint 全体 + α)— 17h の余裕を持って完走。

---

**Document Owner**: product-manager
**Last Updated**: 2026-09-29
**Version**: 1.0
