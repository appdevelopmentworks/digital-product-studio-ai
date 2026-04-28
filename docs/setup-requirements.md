# セットアップ要件・環境構築手順

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: digital-product-studio-ai を初めて使うための環境構築手順
**対応 OS**: Windows 11 + WSL2(プライマリ)/ macOS / Linux(セカンダリ・best-effort)

---

## 0. 本書の目的

本書は digital-product-studio-ai を実行できる状態にするまでの環境構築手順を示す。

[v0.2-direction.md](v0.2-direction.md) Q3 で確定したとおり、**プライマリ環境は Windows 11 + WSL2 + Git Bash**。macOS / Linux は best-effort 対応(動作未保証)。PowerShell 版 hooks は v0.4 以降で検討する。

---

## 1. プライマリ環境(Windows 11 + WSL2)

### 1.1 必須要件

| ツール | バージョン | 用途 |
|---|---|---|
| Windows | 11 | OS |
| WSL2 | 最新 | Linux 環境 |
| Ubuntu | 22.04 LTS 推奨 | WSL2 上の Linux ディストリビューション |
| Git Bash | 最新 | Windows 側からの git 操作 |
| Node.js | 20.x LTS 以上 | JavaScript ランタイム |
| pnpm | 9.x 以上 | パッケージマネージャー |
| Git | 2.40 以上 | バージョン管理 |
| Claude Code | 最新 | AI エージェント実行環境 |

### 1.2 推奨環境

| ツール | バージョン | 用途 |
|---|---|---|
| VS Code | 最新 | エディタ |
| WSL 拡張機能 | 最新 | VS Code から WSL2 に接続 |
| Docker Desktop | 最新 | (B 系・v0.3 以降のみ)コンテナ環境 |
| GitHub CLI(gh) | 最新 | GitHub 操作 |
| jq | 最新 | JSON 操作 |
| yq | 最新 | YAML 操作(ハンドオフ YAML 検証用) |

### 1.3 WSL2 セットアップ手順

#### Step 1: WSL2 を有効化

PowerShell を管理者として起動:

```powershell
wsl --install
```

再起動後、Ubuntu 22.04 を選択してインストール:

```powershell
wsl --install -d Ubuntu-22.04
```

#### Step 2: Ubuntu の初期設定

WSL2 内で:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl wget git unzip jq
```

#### Step 3: Node.js + pnpm のインストール

```bash
# nvm 経由で Node.js 20.x LTS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
nvm alias default 20

# pnpm
npm install -g pnpm@latest
pnpm --version
```

#### Step 4: yq のインストール(YAML 検証用)

```bash
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
yq --version
```

#### Step 5: Git の設定

```bash
git config --global user.name "Shin"
git config --global user.email "shin@aileap.example"
git config --global init.defaultBranch main
```

#### Step 6: Claude Code のインストール

```bash
# Anthropic 公式インストール手順に従う
# (執筆時点での参考コマンド・実際は最新公式手順を参照)
npm install -g @anthropic-ai/claude-code
claude --version
```

API キーを設定:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
source ~/.bashrc
```

### 1.4 リポジトリのクローン

#### Windows 側のパス

リポジトリは Windows 側に配置することを推奨:

```
C:\Users\hartm\Desktop\digital-product-studio-ai\
```

WSL2 からは:

```
/mnt/c/Users/hartm/Desktop/digital-product-studio-ai/
```

#### クローン

```bash
cd /mnt/c/Users/hartm/Desktop/
git clone <repo-url> digital-product-studio-ai
cd digital-product-studio-ai
```

### 1.5 hook ファイルの実行権限

```bash
cd /mnt/c/Users/hartm/Desktop/digital-product-studio-ai
chmod +x .claude/hooks/*.sh
ls -la .claude/hooks/
```

すべての .sh ファイルに `x` 権限が付与されていることを確認。

### 1.6 Git Bash でも動作確認

Windows ネイティブ環境で hooks が動作するか確認(WSL2 と Git Bash 両方をプライマリとして扱う):

```bash
# Git Bash で
cd /c/Users/hartm/Desktop/digital-product-studio-ai
bash .claude/hooks/session-start.sh
```

エラーなく終了すれば OK。

---

## 2. セカンダリ環境(macOS)

### 2.1 必須要件

| ツール | バージョン | 用途 |
|---|---|---|
| macOS | 14 Sonoma 以上推奨 | OS |
| Homebrew | 最新 | パッケージマネージャー |
| zsh | 最新 | デフォルトシェル(bash でも可) |
| Node.js | 20.x LTS 以上 | JavaScript ランタイム |
| pnpm | 9.x 以上 | パッケージマネージャー |
| Git | 2.40 以上 | バージョン管理 |
| Claude Code | 最新 | AI エージェント実行環境 |

### 2.2 セットアップ手順

#### Step 1: Homebrew インストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Step 2: ツール群インストール

```bash
brew install node pnpm git jq yq gh
brew install --cask visual-studio-code
```

#### Step 3: 以下は WSL2 セットアップと同じ

Step 5(Git 設定) / Step 6(Claude Code)/ リポジトリクローンは WSL2 の手順と同じ。

### 2.3 macOS での既知の差分

- hook の bash バージョンが Linux と微妙に異なる(macOS は bash 3.2)
- 一部の `sed` / `grep` オプションが Linux と異なる
- v0.2 の hook は Linux/WSL2 をターゲットに書かれているため、macOS で動かない場合がある

回避策: macOS で bash 5.x を Homebrew でインストール:

```bash
brew install bash
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
```

それでも動作しない場合は GitHub issue を起票。v0.4 以降で macOS 公式対応を検討する。

---

## 3. セカンダリ環境(Linux)

### 3.1 必須要件

| ツール | バージョン |
|---|---|
| Ubuntu / Debian / Fedora | 最新 |
| Node.js | 20.x LTS 以上 |
| pnpm | 9.x 以上 |
| Git | 2.40 以上 |
| Claude Code | 最新 |

### 3.2 セットアップ手順

WSL2 セットアップ手順 Step 2 以降と同じ。

---

## 4. リポジトリ構造の確認

セットアップ後、以下の構造になっていることを確認:

```
digital-product-studio-ai/
├── README.md
├── CLAUDE.md
├── UPGRADING.md(v0.2 完成後に追加)
├── .gitignore
├── .claude/
│   ├── settings.json
│   ├── agents/         (21 ファイル・Phase B2 で追加)
│   ├── skills/         (28 ディレクトリ・Phase B3 で追加)
│   ├── hooks/          (8 ファイル・Phase B4 で追加)
│   └── rules/          (10 ファイル・Phase B5 で追加)
├── docs/
│   ├── requirements-v0.1.md
│   ├── gap-analysis-v0.1.md
│   ├── v0.2-direction.md
│   ├── claude-code-handoff.md
│   ├── requirements-v0.2.md
│   ├── architecture.md
│   ├── handoff-protocols.md
│   ├── agent-roster.md
│   ├── agent-coordination-map.md
│   ├── quick-start.md
│   ├── setup-requirements.md   (本書)
│   ├── pricing-strategy.md
│   ├── geo-implementation-spec.md
│   ├── legal-escalation-rules.md
│   ├── language-policy.md
│   └── templates/      (21 ファイル・Phase C で追加)
└── projects/           (案件ごとに追加)
```

### 4.1 ディレクトリ存在確認スクリプト

```bash
#!/bin/bash
required_dirs=(
  ".claude"
  ".claude/agents"
  ".claude/skills"
  ".claude/hooks"
  ".claude/rules"
  "docs"
  "docs/templates"
  "projects"
)

for dir in "${required_dirs[@]}"; do
  if [ -d "$dir" ]; then
    echo "✅ $dir"
  else
    echo "❌ $dir (missing)"
  fi
done
```

---

## 5. Claude Code の起動と動作確認

### 5.1 初回起動

```bash
cd /mnt/c/Users/hartm/Desktop/digital-product-studio-ai
claude --model opus-4-7
```

### 5.2 起動後の確認

Claude Code 起動後に以下を確認:

```
> /help
```

スキル一覧が表示され、本リポジトリのカスタムスキル(`/client-onboarding`、`/team-corporate-site` 等)が含まれていることを確認。

### 5.3 hook 動作確認

```
> session-start.sh が実行されたか確認してください
```

session-start.sh で生成されるログ(直近の案件状態・git 活動)が表示されればOK。

### 5.4 path-scoped rule 動作確認

```
> src/components/ に新規コンポーネントを作成してください(テスト用)
```

rules/components.md に従って Atomic Design 準拠・Props 型定義必須のコンポーネント雛形が生成されることを確認。

---

## 6. モデル選択

### 6.1 v0.2 実装フェーズでのモデル割当

[v0.2-direction.md](v0.2-direction.md) のモデル選択ポリシーに従う。

| Phase | 推奨モデル | 切替コマンド |
|---|---|---|
| Phase A(文書整備) | Opus 4.7 | `claude --model opus-4-7` |
| Phase B1(settings.json) | Opus 4.7 | (継続) |
| Phase B2(agents) | Opus 4.7 | (継続) |
| Phase B3(skills) | Opus 4.7 | (継続) |
| Phase B4(hooks) | Sonnet 4.6 | `/model sonnet-4-6` |
| Phase B5(rules) | Sonnet 4.6 | (継続) |
| Phase C(templates) | Opus 4.7 | `/model opus-4-7` |
| Phase D(検証) | Opus 4.7 | (継続) |
| Phase E(gap 分析) | Opus 4.7 | (継続) |

### 6.2 運用時のモデル選択

実案件運用時は **Opus 4.7 を推奨**(品質優先)。サブタスク(コードレビュー・誤字検出)で軽量化したい場合のみ Sonnet 4.6 に一時切替。

---

## 7. トラブルシューティング

### 7.1 Claude Code が起動しない

```bash
# Node.js バージョン確認
node --version  # v20.x 以上

# Claude Code 再インストール
npm uninstall -g @anthropic-ai/claude-code
npm install -g @anthropic-ai/claude-code

# API キー確認
echo $ANTHROPIC_API_KEY
```

### 7.2 hook が動作しない

```bash
# 実行権限確認
ls -la .claude/hooks/

# 権限が無い場合
chmod +x .claude/hooks/*.sh

# bash バージョン確認
bash --version  # 4.x 以上推奨
```

WSL2 環境であることを確認(Windows コマンドプロンプトや PowerShell では動作しない):

```bash
echo $WSL_DISTRO_NAME  # Ubuntu 等が表示されれば WSL2
```

### 7.3 「unknown skill」エラー

`.claude/skills/` 配下の SKILL.md が正しい形式か確認:

```bash
ls -la .claude/skills/client-onboarding/
# → SKILL.md が存在するか
```

### 7.4 path-scoped rule が適用されない

`.claude/rules/` 配下のファイルが `.claude/settings.json` で参照されているか確認:

```bash
cat .claude/settings.json | grep rules
```

### 7.5 git 操作で改行コードがおかしい

WSL2 と Windows の改行コード差異が原因。`.gitattributes` で統一:

```
* text=auto
*.sh text eol=lf
*.md text eol=lf
```

### 7.6 path-scoped rule `secrets.md` で `.env` を作成できない

これは仕様。`.env` はコミット禁止。`.env.example` を雛形として配置し、`.env` は各環境で個別作成する。

```bash
cp .env.example .env
# .env を編集
```

### 7.7 並列案件で動作が遅い

context window が逼迫している可能性。同時アクティブ案件を 2-3 件に減らす:

```
> /list-projects
> /switch-project to=<priority-project-id>
```

---

## 8. アップグレード手順(v0.1 → v0.2)

v0.1 から v0.2 への移行手順。詳細は `UPGRADING.md`(v0.2 完成後に追加)を参照。

### 8.1 概要

```
1. v0.1 のリポジトリをバックアップ
2. v0.2 ブランチに切替
3. .claude/ 配下を全置換
4. docs/ に新規 11 文書を追加(v0.1 文書は履歴として保持)
5. docs/templates/ を全置換(法務 3 個は弁護士確認ヘッダー強制)
6. projects/ 配下の既存案件は手動で構造を更新(meetings / approvals.yaml 等を追加)
7. AILEAP 自社サイト改修案件で動作確認
```

### 8.2 注意事項

- v0.1 でアクティブだった案件があれば、`projects/{id}/00-engagement/` に追加された新ファイル(decisions.yaml / approvals.yaml / meetings/ / correspondence/)を手動で生成
- v0.1 で 38 体だったエージェント割当を、v0.2 の 21 体にマッピング(対応のないものは v0.3 / v0.4 を待つ)
- v0.1 の Slash Commands 一部が削除されている(例: /sprint-plan は v0.3 以降)。代替コマンドの有無を確認

---

## 9. 関連ツール(任意)

### 9.1 設計補助ツール

- Figma / Penpot — デザインツール(art-direction-lead と連携)
- Notion / Obsidian — 個人メモ・案件管理(本リポジトリと別運用)
- Slack / Discord — クライアント連絡(WMAO は Slack-approval-gated 設計)

### 9.2 開発補助ツール

- VS Code(WSL 拡張)— エディタ
- Docker Desktop — (B 系・v0.3 以降のみ)コンテナ環境
- Postman / Insomnia — (B 系・v0.3 以降のみ)API テスト
- Lighthouse CLI — パフォーマンス計測

### 9.3 デプロイ先

| 案件タイプ | 推奨ホスティング |
|---|---|
| A1. コーポレートサイト | Vercel / Cloudflare Pages |
| A2. ランディングページ | Vercel / Cloudflare Pages |
| A3. メディアサイト | WordPress(レンタルサーバー) / Vercel(Headless) |
| 自社プロダクト | Vercel(現状の AILEAP サイトと同じ) |

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では存在せず、v0.2 で新設。Windows + WSL2 をプライマリ環境として明記。 |

---

**本書はセットアップの正本である。新しい環境で本リポジトリを動かす場合は本書に従うこと。トラブルシューティングで解決しない問題があれば、Phase D 検証時に発見次第本書を更新する。**
