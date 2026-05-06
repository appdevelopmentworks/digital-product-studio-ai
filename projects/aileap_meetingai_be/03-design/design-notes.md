# デザインノート — AILEAP MeetingAI β版 管理画面 + ユーザー UI

**案件**: AILEAP MeetingAI β版 BE + 管理画面
**案件 ID**: AILEAP-MTG-BE-20260801-001
**版**: 1.0
**作成日**: 2026-08-15
**作成者**: art-direction-lead(ui-designer 補強・B 系では UI を最低限化)
**ステータス**: 承認済(APV-003 内 / 2026-08-15)

> **継承元**: [aileap_v2/03-design/design-system.md](../../aileap_v2/03-design/design-system.md)
> SaaS の管理画面 + ユーザー UI のため、aileap_v2 のコーポレートサイト UI と差別化が必要な部分のみ記録。

---

## 1. 継承宣言(aileap_v2 から)

| 継承項目 | 継承元参照 |
|---|---|
| カラートークン | aileap_v2 §2(全 16 種・WCAG 2.2 AA) |
| タイポグラフィ | aileap_v2 §3 |
| スペーシング | aileap_v2 §4(base-4 / タッチターゲット 44×44px) |
| フォーカスインジケーター | aileap_v2 §7 |
| アクセシビリティ要件 | aileap_v2 §10(WCAG 2.2 AA) |

WCAG 2.2 AA トークン段階担保を継承。

---

## 2. SaaS 管理画面 / ユーザー UI 固有差分(Brand-specific design directives)

### 2.1 ダッシュボード型レイアウト(管理画面)

- **目的**: SaaS 管理画面として情報密度を高める(コーポレートサイトとは逆方向)
- **適用範囲**: `/admin/*` 全ページ
- **必須 / 推奨**: MUST
- **具体指示**:
  - サイドバー型レイアウト(左固定 240px ナビ + メインコンテンツ)
  - ヘッダー高さ 56px(aileap_v2 64px より低め・情報密度優先)
  - max-width 制限なし(画面いっぱい使う)
  - パディング SP 16px / PC 24px(aileap_v2 PC 48px より狭い)

### 2.2 ユーザー UI の最低限主義

- **目的**: B1 MVP のためユーザー UI は機能性のみ(装飾なし)
- **適用範囲**: `/dashboard` `/upload` `/recordings/:id`
- **必須 / 推奨**: MUST
- **具体指示**:
  - シングルカラム + max-width 720px(読みやすさ優先)
  - 装飾的な背景画像なし
  - ヒーロー画像なし(ダッシュボード = 機能起点画面)
  - フッターは「ログアウト」と「設定」のみ

### 2.3 ステータス可視化

- **目的**: 録音処理が複数ステータスを遷移するため進捗を明示
- **適用範囲**: `/dashboard` `/recordings/:id` `/admin/recordings`
- **必須 / 推奨**: MUST
- **具体指示**:
  - ステータスバッジ:7 種(uploaded / transcribing / transcribed / summarizing / summarized / generating_pdf / completed / failed)
  - 色分け:processing 系 = bg.brand-light(青)/ completed = bg.success-light(緑)/ failed = bg.error-light(赤)
  - 進捗バー:status に応じて 0-100% 表示
  - 推定残り時間:transcribing → "残り約 5 分" 等

### 2.4 議事録閲覧 UI(構造化表示)

- **目的**: summaries.content(JSONB)を読みやすく表示
- **適用範囲**: `/recordings/:id`
- **必須 / 推奨**: MUST
- **具体指示**:
  - セクション区切り:タイトル / 参加者 / アジェンダ / 決定事項 / アクションアイテム / 重要発言
  - 決定事項は太字 + 左ボーダー強調
  - アクションアイテムは担当者 + 期日を明示
  - 「PDF をダウンロード」ボタンを上部右に固定配置
  - 「議事録を編集」ボタンは disabled(v1.5)

### 2.5 ローディング / 空状態

- **目的**: 非同期処理の UX を補完
- **適用範囲**: 全画面
- **具体指示**:
  - スケルトンローダー(grayplaceholder)で読み込み中表現
  - 空状態(録音 0 件)時:イラストなし + シンプルメッセージ + 「アップロード」CTA

---

## 3. 主要画面ワイヤーフレーム

### 3.1 ユーザー UI: `/dashboard`

```
┌──────────────────────────────────────────────────┐
│ MeetingAI [logo]              [user@ex.com ▼]   │
├──────────────────────────────────────────────────┤
│                                                  │
│  あなたの録音                  [+ 新規アップロード] │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │ 2026-08-30 経営会議    [completed]   →     │ │
│  │ 60 分 / 議事録あり                         │ │
│  └────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────┐ │
│  │ 2026-08-28 営業 MTG  [summarizing 73%]  →  │ │
│  │ 45 分 / 処理中                             │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 3.2 ユーザー UI: `/recordings/:id`(議事録閲覧)

```
┌──────────────────────────────────────────────────┐
│ MeetingAI [logo]              [user@ex.com ▼]   │
├──────────────────────────────────────────────────┤
│  ← Dashboard                  [📄 PDF DL]       │
│                                                  │
│  2026-08-30 経営会議                             │
│  duration 60min / accuracy 4.3 / completed       │
│                                                  │
│  ## 参加者                                        │
│  田中, 佐藤, 鈴木                                │
│                                                  │
│  ## 決定事項                                      │
│  ▎第3四半期売上目標: 1.2 億円                    │
│  ▎新規事業 X: 着手承認(Q4 開始)                 │
│                                                  │
│  ## アクションアイテム                            │
│  □ 佐藤: 売上分析資料(2026-09-15)              │
│  □ 鈴木: X 案件 PJ 立ち上げ(2026-10-01)         │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 3.3 管理画面: `/admin`

```
┌──────────────────────────────────────────────────┐
│ MeetingAI Admin              [admin ▼]          │
├────────────┬─────────────────────────────────────┤
│ Dashboard  │ 利用統計サマリー                     │
│ Users      │                                     │
│ Invite     │  WAU(直近 7d): 8 名                │
│ Recordings │  録音件数(直近 7d): 23 件          │
│ Stats      │  完了率: 91%                        │
│ Audit Log  │  LLM コスト(直近 7d): ¥12,450     │
│            │                                     │
│            │ [グラフ:録音件数推移]              │
│            │                                     │
└────────────┴─────────────────────────────────────┘
```

---

## 4. レスポンシブ対応

| ブレークポイント | レイアウト |
|---|---|
| 〜 640px(SP) | サイドバー → ハンバーガーメニュー / 1 カラム |
| 640px-1023px(タブレット) | サイドバー固定 / メインコンテンツ |
| 1024px+(PC) | サイドバー 240px + メインコンテンツ |

ユーザー UI(/dashboard 等)は SP 対応必須(録音アップロードは PC が多いが、議事録閲覧は SP も)。
管理画面は PC 優先(SP 対応は最低限)。

---

## 5. アニメーション(最低限)

- ステータス変化時のフェード(opacity 0 → 1 / 200ms)
- ローディングスケルトン(pulse animation)
- prefers-reduced-motion: reduce 対応(継承)

パララックス禁止 / 自動再生動画なし(SaaS 管理画面のため不要)。

---

## 6. アクセシビリティ(継承 + B 系特殊事項)

aileap_v2 の WCAG 2.2 AA を継承。B 系特殊事項:

- データテーブル(管理画面ユーザー一覧等):`<table>` セマンティック + caption + scope 属性
- フォームエラー:aria-invalid + aria-describedby(継承)
- 動的更新(ステータス変化):aria-live="polite"
- ファイルアップロード:`<input type="file">` の native ラベル
- モーダル(招待発行など):focus trap + Esc で閉じる

---

## 7. コンポーネント新規(本案件で追加)

aileap_v2 の atoms / molecules を流用 + 以下を新規追加:

| コンポーネント | 役割 |
|---|---|
| StatusBadge | 7 種ステータス表示 |
| ProgressBar | 録音処理進捗表示 |
| RecordingCard | 録音一覧の各行 |
| SummaryViewer | summaries.content JSONB を整形表示 |
| FileUploader | ドラッグ&ドロップ + 進捗バー |
| AdminSidebar | 管理画面サイドナビ |
| StatsCard | ダッシュボードの統計カード |
| StatsChart | recharts ベースのグラフ |

各コンポーネントの状態(default / hover / focus / active / disabled / error)を実装。

---

## 8. 検証メモ(Phase I-B)

- art-direction-lead が SaaS 案件で aileap_v2 design-system を継承する流れの動作確認
- B 系は UI 装飾より機能性 / 情報密度を優先するため、§1.4(Brand-specific design directives)で「最低限主義」を明示
- StatusBadge / ProgressBar 等の SaaS 特有コンポーネントを Atomic Design に組み込めるか確認(動作 OK)

---

**Document Owner**: art-direction-lead
**Last Updated**: 2026-08-15
**Version**: 1.0
**継承元**: aileap_v2/03-design/design-system.md
