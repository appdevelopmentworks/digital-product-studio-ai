# Claude Code 初回指示文

このファイルは Claude Code に渡す最初のプロンプトをまとめたものです。
用途に応じて使い分けてください。

---

## 推奨: 標準版(これを使ってください)

以下をそのままコピーして Claude Code に貼り付けてください。

---

```
あなたは「digital-product-studio-ai」プロジェクトの実装担当です。

# プロジェクト概要

このリポジトリは AILEAP(Shin が運営する AI コンサル・教育・マーケ事業)の
中流組織「digital-product-studio-ai」です。

AILEAP は 3 組織のエージェント・アーキテクチャで構成されています:

  apex-consulting-ai          上流(経営戦略・業務改革)— 既存
       ↓ ハンドオフ
  digital-product-studio-ai   中流(制作 + 開発 + 納品)— 本リポジトリ
       ↓ ハンドオフ
  web-marketing-ai-org        下流(マーケ・運用・成長)— 既存

本組織のミッションは、SME クライアントのデジタルプロダクト案件
(コーポレートサイト〜SaaS 開発まで)をヒアリングから保守運用まで
AI エージェント中心で遂行することです。

# 最初に読むべき文書(順番厳守)

以下の順で必ず読んでください。読み終わるまで実装に着手しないでください。

  1. docs/v0.2-direction.md     ← Claude Code 向け公式指示書(最重要)
  2. docs/requirements-v0.1.md  ← v0.1 要件定義書
  3. docs/gap-analysis-v0.1.md  ← v0.1 自己批判分析

v0.2-direction.md は私(Shin)と前任の Claude(チャットUI)が合意した
v0.2 改訂方針の正式な指示書です。実装中に v0.1 文書と矛盾がある場合は
v0.2-direction.md を優先してください。

# 言語ポリシー(必ず厳守)

v0.2-direction.md Section 3 に詳細がありますが、原則は以下です:

  - 私(Shin)とのやり取り、私が読む文書(docs/ 配下、README、CLAUDE.md
    の Shin 向け部分)は **必ず日本語**
  - クライアント向けテンプレート(docs/templates/)も **必ず日本語**
  - AI が読むだけの内部定義ファイル(.claude/agents/、.claude/skills/、
    .claude/hooks/、.claude/rules/、.claude/settings.json)は **英語**
  - エージェントプロンプトは英語だが、出力時は必ずユーザーの母国語に
    合わせる(私への出力は日本語、日本の SME クライアント向けも日本語)

# 動作環境

  - プライマリ: Windows 11 + WSL2 + Git Bash(私の作業環境)
  - セカンダリ: macOS / Linux(best-effort、動作未保証)

bash hooks は WSL2 / Git Bash で動作する形で実装してください。
PowerShell 版は v0.4 以降で検討します。

# モデル選択ポリシー(品質最優先・パターン2)

各フェーズで以下のモデルを使用してください。フェーズ移行時に
私から明示的にモデル切替を指示します。あなたから「次フェーズに
入る前に Opus / Sonnet どちらで進めますか?」と確認してください。

  Phase A(文書整備11個):              Opus 4.7
  Phase B1(settings.json):              Opus 4.7
  Phase B2(agents 20体):                Opus 4.7
  Phase B3(skills 28個):                Opus 4.7(通常)
  Phase B4(hooks 8個):                  Sonnet 4.6
  Phase B5(rules 10個):                 Sonnet 4.6
  Phase C(templates 21個):              Opus 4.7(通常)
  Phase D(AILEAP 自社サイト検証):       Opus 4.7
  Phase E(gap-analysis-v0.2 作成):      Opus 4.7

理由:
  - 設計判断と日本語品質が重要なフェーズ(A / B1-B2 / D / E)は Opus 4.7
  - パターン化された定義ファイル(B3 / C)は Opus 4.7 通常で十分
  - 短い bash / rules 定義(B4 / B5)は Sonnet 4.6 で品質損失なし

エージェント実行時のモデル割当(別件):
  これは v0.2-direction.md Section 6.1 で定義済みです。実装時に
  各エージェント定義ファイルの frontmatter に書き込んでください:
    Tier 0(studio-director):              Opus
    Tier 1(Practice Directors 5体):       Opus
    Tier 2(Discipline Leads 6体):         Sonnet
    Tier 3(Specialists 6体):              Sonnet
    Tech Stack Specialists(3体):          Sonnet

  この割当は「実装時に作るあなた自身のモデル」とは別物です。
  混同しないでください。

# 実装の進め方(重要)

v0.2-direction.md Section 9 に Phase A〜E のタスクリストがあります。

**Phase A から順番に進めてください。各フェーズで一気に全ファイルを
作るのではなく、以下の段階的アプローチで進めてください**:

  1. まず v0.2-direction.md を熟読し、全体像を把握する
  2. Phase A1(requirements-v0.2.md)に着手する前に、
     私に「これから A1 に着手します。論点は X, Y, Z です。
     方針確認したい点はありますか?」と確認する
  3. 各文書/ファイル群が完成したら、私の確認を待ってから次へ進む
  4. 確認待ちの間は、ファイルの差分や設計判断のサマリーを
     箇条書きで提示する

理由: v0.1 と gap 分析で 64KB 以上の設計議論を経ています。
各実装判断には背景があり、私との確認なしに先走ると手戻りが大きくなります。

# 段階展開戦略(必ず守ってください)

v0.2 は **20 エージェントで完結** させます。
v0.3 / v0.4 のエージェントを先取り実装しないでください。
段階ごとに実案件で検証する設計のためです。

20 エージェントの正式構成は v0.2-direction.md Section 6.1 にあります。

# 完了条件

v0.2 が完成したと判断する条件は v0.2-direction.md Section 11 の
Definition of Done にあります。Phase E(gap-analysis-v0.2.md 作成)
まで完了して初めて v0.2 完成とします。

# 最初のアクション

まず以下を実行してください:

  1. docs/v0.2-direction.md を読む
  2. docs/requirements-v0.1.md を読む
  3. docs/gap-analysis-v0.1.md を読む
  4. 全体像を把握したら、私に以下を報告:
     a) 3 文書の理解サマリー(各 5 行程度)
     b) Phase A1 着手前に確認したい論点(あれば)
     c) 想定される実装順序と所要見積もり
     d) 現在のあなた(Claude Code)が動作しているモデルの確認
        (Opus 4.7 で動いているか?もし違うなら Phase A は
         Opus 4.7 への切替を私に提案してください)

報告を受けてから Phase A1 に着手します。準備ができたら開始してください。
```

---

## 短縮版(慣れた後の再開時に使う)

2 回目以降のセッション再開時など、Claude Code が既に文脈を把握している
場合に使う短縮版です。

```
digital-product-studio-ai プロジェクトの続きを再開します。

docs/v0.2-direction.md と最新の進捗状況(.claude/ 配下と docs/ 配下の
ファイル)を確認して、現在の進行フェーズを報告してください。

その後、次に着手すべきタスクと、その実装方針を提示してから着手してください。

言語ポリシー: Shin 向け文書は日本語、AI 内部ファイルは英語、
エージェント出力は日本語(v0.2-direction.md Section 3 参照)。

モデル選択: docs/claude-code-handoff.md「モデル選択ポリシー」に従って
現フェーズに応じたモデルを使用してください。フェーズが変わる場合は
私に切替を提案してください。
```

---

## 緊急対応版(問題発生時)

実装中に問題が発生し、原因究明から始める場合に使います。

```
digital-product-studio-ai プロジェクトで問題が発生しています。

【発生した問題】
(ここに問題の症状を記載)

【私が試したこと】
(ここに試行内容を記載)

まず以下を実行してください:

  1. docs/v0.2-direction.md を読み、設計意図を把握
  2. 問題の発生箇所を特定
  3. 原因を仮説 2〜3 個提示(根拠付き)
  4. 各仮説の検証方法と修正方針を提示

修正に着手する前に必ず私の確認を取ってください。

なお原因究明・設計判断は Opus 4.7 を推奨します。現在のモデルが
Sonnet なら Opus 4.7 への切替を提案してください。
```

---

## 補足: Claude Code 起動コマンド

### WSL2 / Git Bash の場合

```bash
cd /mnt/c/Users/hartm/Desktop/digital-product-studio-ai
claude --model opus-4-7
```

### PowerShell の場合

```powershell
cd C:\Users\hartm\Desktop\digital-product-studio-ai
claude --model opus-4-7
```

Phase A から開始するため、最初は Opus 4.7 で起動するのが効率的です。
Phase B4(hooks)に入る時に `/model sonnet-4-6` で切替してください。

---

## 補足: 起動後の動作確認

Claude Code が起動したら、まず以下を確認してください:

1. プロンプト表示が正常か
2. リポジトリのルートディレクトリにいるか
3. `ls docs/` で 4 ファイル(v0.2-direction.md、requirements-v0.1.md、
   gap-analysis-v0.1.md、claude-code-handoff.md)が見えるか
4. 現在のモデルが Opus 4.7 か(`/model` コマンドで確認可能)

確認できたら標準版プロンプトをコピペして開始してください。

---

## 補足: モデル切替タイミング表

実装が進むにつれて以下のタイミングでモデルを切替えます。

| 移行タイミング | 切替コマンド | 移行先モデル |
|---|---|---|
| Phase A 開始時(初回起動時) | (起動時に opus-4-7 指定) | Opus 4.7 |
| Phase B1〜B3 開始時 | (継続) | Opus 4.7 |
| Phase B4(hooks)開始時 | `/model sonnet-4-6` | Sonnet 4.6 |
| Phase B5(rules)開始時 | (継続) | Sonnet 4.6 |
| Phase C(templates)開始時 | `/model opus-4-7` | Opus 4.7 |
| Phase D(検証)開始時 | (継続) | Opus 4.7 |
| Phase E(gap分析)開始時 | (継続) | Opus 4.7 |

切替を忘れがちなのは Phase B4 開始時(Opus → Sonnet)と Phase C 開始時
(Sonnet → Opus)です。Claude Code 自身に「次フェーズに入る前に
モデル切替の必要性を確認してください」と指示してあるので、提案を
受けたら速やかに切替してください。

---

## 補足: トラブルシューティング

### Claude Code が古い情報で動こうとする場合

「v0.2-direction.md を再度確認してください」と促すと最新方針に戻ります。

### 言語ポリシーを破った場合

「言語ポリシー違反です。v0.2-direction.md Section 3 を再確認してください」
と指摘してください。docs/ 配下に英語で書こうとしたり、エージェント
プロンプトを日本語で書こうとした時に発生します。

### 段階展開を破ろうとした場合

「v0.2 は 20 エージェント上限です。それは v0.3 / v0.4 の領域です」
と指摘してください。

### 確認なしに先走った場合

「先走らずに確認を取ってください。v0.2-direction.md Section 9 の
段階的アプローチを再確認してください」と指摘してください。

### モデル切替を忘れた場合

「現在 Phase X です。モデル選択ポリシーでは Y を使うはずです。
切替てください」と指摘してください。
