# クイックスタートガイド

**バージョン**: 0.2
**作成日**: 2026-04-27
**対象読者**: digital-product-studio-ai を初めて使う Shin / 関係者
**前提**: [setup-requirements.md](setup-requirements.md) のセットアップが完了していること

---

## 0. 本書の目的

本書は v0.2 完成後に、digital-product-studio-ai を使って最初の案件を回すまでの最短ルートを示す。

各機能の詳細仕様は以下の文書を参照:
- 要件全体: [requirements-v0.2.md](requirements-v0.2.md)
- アーキテクチャ: [architecture.md](architecture.md)
- エージェント名簿: [agent-roster.md](agent-roster.md)
- ハンドオフプロトコル: [handoff-protocols.md](handoff-protocols.md)

---

## 1. 5 分でわかる digital-product-studio-ai

### 1.1 何ができるか

| やりたいこと | 起動するスキル(または team コマンド) |
|---|---|
| クライアント案件を新規起動(コーポレートサイト) | `/team-corporate-site` |
| クライアント案件を新規起動(ランディングページ) | `/team-landing-page` |
| クライアント案件を新規起動(メディアサイト) | `/team-mediasite` |
| クライアントヒアリング | `/client-onboarding` |
| 競合分析 | `/competitor-analysis` |
| 要件定義書作成 | `/requirements-gathering` |
| 見積作成(3 パターン提案) | `/estimate` |
| サイトマップ作成 | `/sitemap-design` |
| デザインシステム作成 | `/design-system` |
| コンテンツ戦略作成 | `/content-strategy` |
| SEO 監査 | `/seo-audit` |
| GEO 監査(LLM 引用最適化) | `/geo-audit` |
| アクセシビリティ監査 | `/accessibility-audit` |
| 公開チェックリスト | `/launch-checklist` |
| 納品パッケージ生成 | `/handoff-package` |
| WMAO へのハンドオフ | `/handoff-to-marketing` |

### 1.2 何ができないか(v0.2 段階の制約)

- B 系案件(SaaS MVP / 業務システム / AI プロダクト)→ v0.3 以降
- C 系案件(EC / プラットフォーム)→ v0.4 以降
- 全テンプレートの 4 言語化 → v0.3 以降
- 自動化されたハンドオフ → 別リポジトリへの手動コピーが必要
- PowerShell 版 hooks → v0.4 以降

詳細は [requirements-v0.2.md](requirements-v0.2.md) Section 19.2。

### 1.3 案件の標準フロー

```
[1] apex から /handoff-from-strategy 受領(または手動で案件起動)
[2] /team-{type} で案件起動
[3] /client-onboarding でヒアリング
[4] /competitor-analysis、/requirements-gathering、/estimate
[5] [契約締結]
[6] /sitemap-design、/design-system、/content-strategy
[7] [実装]
[8] /seo-audit、/geo-audit、/accessibility-audit
[9] /launch-checklist
[10] [公開]
[11] [Post-launch 30 日検証]
[12] /handoff-package → /handoff-to-marketing(WMAO へ)
```

---

## 2. 初回セットアップ確認

[setup-requirements.md](setup-requirements.md) の手順を完了している前提で、以下を確認する。

### 2.1 動作確認チェックリスト

```bash
# WSL2 / Git Bash でリポジトリのルートにいることを確認
pwd
# → /mnt/c/Users/hartm/Desktop/digital-product-studio-ai

# 必要ファイル群が揃っていることを確認
ls .claude/
# → agents/  hooks/  rules/  settings.json  skills/

ls docs/
# → 11 文書 + templates/ + 履歴文書 4 件

ls docs/templates/
# → 21 ファイル(.md)

# Claude Code が起動可能か
claude --version

# モデルが Opus 4.7(運用時の推奨は案件起動時 Opus、実装時 Sonnet)
claude --model opus-4-7
```

### 2.2 起動確認

Claude Code を起動して以下のコマンドが認識されることを確認:

```
> /client-onboarding
> /team-corporate-site
> /estimate
```

もし「unknown skill」と出た場合、`.claude/skills/` 配下が正しく配置されていない。[setup-requirements.md](setup-requirements.md) のトラブルシューティングを参照。

---

## 3. 最初の案件を起動する手順

ここでは Phase D の検証案件である「AILEAP 自社サイト改修」を例に、案件起動の最短手順を示す。

### 3.1 ステップ 1: 案件ディレクトリ初期化

Claude Code に以下を依頼:

```
新規案件を起動します。

  クライアント名: AILEAP
  案件タイプ: A1(コーポレートサイト)
  案件 ID: aileap_v2
  対応URL: https://aileap-hazel.vercel.app

projects/aileap_v2/ を初期化してください。
internal_client: true(自社プロダクト)で扱います。
```

studio-director が `projects/aileap_v2/` を生成し、PROJECT.md・各フェーズディレクトリ・session-state を初期化する。

### 3.2 ステップ 2: チーム起動

```
> /team-corporate-site project_id=aileap_v2
```

これで A1 タイプ用の動員エージェント群(strategy-director ほか 11 体)が割り当てられる。

### 3.3 ステップ 3: ヒアリング

```
> /client-onboarding project_id=aileap_v2 internal_client=true
```

通常は client-success-lead がクライアントとの対面ヒアリングを想定したフローだが、自社案件では Shin 自身がクライアント役となる。

ヒアリング項目:
- 事業目的・KGI/KPI
- ターゲット顧客
- 既存サイトの課題
- 必要アセット(ロゴ・写真・原稿・GA4/GSC 権限)
- 制約条件(技術・組織・予算)
- 多言語要件の有無

### 3.4 ステップ 4: 必要アセットチェックリスト生成

```
> /asset-checklist project_id=aileap_v2
```

`projects/aileap_v2/01-discovery/assets-required.yaml` が生成される。受領していないアセットがある場合、`/asset-status` で状況確認 + リマインドメール下書き生成。

### 3.5 ステップ 5: 競合分析と要件定義

```
> /competitor-analysis project_id=aileap_v2 industry="AI コンサル" competitors_count=5
> /requirements-gathering project_id=aileap_v2
```

成果物:
- `projects/aileap_v2/01-discovery/competitor-analysis.md`
- `projects/aileap_v2/01-discovery/persona.md`
- `projects/aileap_v2/01-discovery/user-journey-map.md`
- `projects/aileap_v2/00-engagement/requirements-v0.md`(クライアント版)

### 3.6 ステップ 6: 見積(3 パターン提案)

```
> /estimate project_id=aileap_v2
```

commercial-manager が必ず以下 3 パターンを提示する:

1. Time & Material(T&M)
2. Fixed Price
3. Retainer(月額保守 + 機能追加枠)

[pricing-strategy.md](pricing-strategy.md) のレンジに従って提案する。

### 3.7 ステップ 7: 提案承認

```
> /approval-request project_id=aileap_v2 type=proposal
```

`projects/aileap_v2/00-engagement/approvals.yaml` に提案承認イベントが記録される。
自社案件の場合、Shin 自身が承認者となる(internal_client=true のため簡易プロセス)。

### 3.8 ステップ 8: 戦略フェーズ

提案承認後、Strategy フェーズへ進む。

```
> /sitemap-design project_id=aileap_v2
> /content-strategy project_id=aileap_v2
> /seo-audit project_id=aileap_v2 phase=strategy   # 既存サイトの SEO 監査
> /geo-audit project_id=aileap_v2 phase=strategy   # 既存サイトの GEO 監査
> /i18n-strategy project_id=aileap_v2              # 多言語要件の場合のみ
```

### 3.9 ステップ 9: デザインフェーズ

```
> /design-system project_id=aileap_v2
> /approval-request project_id=aileap_v2 type=design
```

a11y 章を含むデザインシステムが完成し、デザイン承認が記録される。

### 3.10 ステップ 10: 実装フェーズ

実装は Claude Code 自身が `/code-review` を継続適用しながら進行する。Tech Stack Specialist は技術スタック選定後に動的呼出される。

```
> /code-review project_id=aileap_v2 path=src/components/
```

### 3.11 ステップ 11: QA フェーズ

```
> /seo-audit project_id=aileap_v2 phase=qa
> /geo-audit project_id=aileap_v2 phase=qa
> /accessibility-audit project_id=aileap_v2
```

すべての audit がパスしたら、QA → Launch のフェーズゲートを通過。

### 3.12 ステップ 12: ローンチ

```
> /approval-request project_id=aileap_v2 type=launch
> /launch-checklist project_id=aileap_v2
```

公開承認が記録され、`pre-deploy-approval-check.sh` フックを通過したらデプロイ実行。

### 3.13 ステップ 13: 公開後 30 日検証

```
[公開後 30 日経過まで待機]

> /handoff-package project_id=aileap_v2
```

seo-geo-strategist が `07-post-launch/30day-report.md` を作成。delivery-director が納品パッケージをまとめる。

### 3.14 ステップ 14: WMAO ハンドオフ

```
> /handoff-to-marketing project_id=aileap_v2
```

`08-handoff/handoff-to-marketing.yaml` が生成される。Shin が手動で WMAO リポジトリにコピーする(v0.2 では自動化しない)。

---

## 4. 並列案件管理

### 4.1 同時アクティブ案件の上限

**v0.2 段階での上限: 同時 2-3 案件**(context window 制約)。

3 案件を超える場合、studio-director が新規案件受注を拒否するか、既存案件の保守フェーズ移行を待つ。

### 4.2 案件切替のコマンド

```
> /switch-project to=aileap_v2     # 別案件に切替
```

studio-director が現在の案件 session-state を保存し、切替先の状態を復元する。

### 4.3 並列時のリソース調整

複数案件で同じエージェントが必要な場合、studio-director が以下優先順位で判定:

1. 公開直前案件(launch ブロッカー)
2. 契約上の納期が近い案件
3. クライアント単価が高い案件
4. 自社プロダクト案件は最低優先

---

## 5. よくある操作

### 5.1 案件一覧表示

```
> /list-projects
```

すべての案件 ID・現在フェーズ・最終更新日を一覧表示する。

### 5.2 承認状況確認

```
> /approval-status project_id=aileap_v2
```

該当案件の全承認イベントの状態を表示する。

### 5.3 アセット受領状況確認

```
> /asset-status project_id=aileap_v2
```

未受領アセットがある場合、リマインドメール下書きを生成する。

### 5.4 議事録作成

```
> /meeting-minutes project_id=aileap_v2 date=2026-05-02 topic=kickoff
```

`projects/aileap_v2/00-engagement/meetings/2026-05-02_kickoff.md` を生成する。録音や口頭メモを Claude Code に渡すと構造化議事録に変換する。

### 5.5 意思決定ログ記録

```
> /decision-log project_id=aileap_v2 title="技術スタック確定"
```

`decisions.yaml` に新規エントリを追加する。

### 5.6 変更注文

```
> /change-order project_id=aileap_v2 reason="クライアントから多言語追加要望"
```

スコープ変更を正式記録し、追加見積を生成する。

### 5.7 スコープ逸脱検出

```
> /scope-check project_id=aileap_v2
```

SOW と実装中の成果物を比較し、スコープ逸脱があれば警告を出す。

---

## 6. ハンドオフ運用

### 6.1 apex から受領するとき

apex リポジトリで生成された `handoff-from-strategy-HO-*.yaml` ファイルを、本リポジトリの該当案件にコピーする。

```bash
# 例: apex リポジトリから本リポジトリへ
cp /mnt/c/Users/hartm/Desktop/apex-consulting-ai/outbox/handoff-from-strategy-HO-20260501-001.yaml \
   /mnt/c/Users/hartm/Desktop/digital-product-studio-ai/inbox/

# Claude Code に通知
claude
> apex から HO-20260501-001 のハンドオフを受領しました。
> /handoff-from-strategy で受領処理を開始してください。
```

### 6.2 WMAO へ送るとき

```
> /handoff-to-marketing project_id=aileap_v2
```

生成された `08-handoff/wmao-package/` を WMAO リポジトリにコピー。

```bash
cp -r /mnt/c/Users/hartm/Desktop/digital-product-studio-ai/projects/aileap_v2/08-handoff/wmao-package \
      /mnt/c/Users/hartm/Desktop/web-marketing-ai-org/inbox/aileap_v2/
```

WMAO 側でハンドオフ受領処理が開始される。

### 6.3 apex に逆ハンドオフするとき

```
> /escalate-to-strategy project_id=<id> reason="<reason>"
```

Shin の最終承認後、生成された YAML を apex リポジトリへコピー。

### 6.4 WMAO から逆ハンドオフ受領するとき

WMAO リポジトリで生成された `handoff-back-to-production-HO-*.yaml` を本リポジトリにコピー。

```
> WMAO から HO-20271001-001 の逆ハンドオフを受領しました。
> 改修案件として処理してください。
```

---

## 7. トラブルシューティング

### 7.1 「unknown skill」エラー

`.claude/skills/` 配下が正しく配置されていない可能性。`.claude/settings.json` で skills の有効化を確認。

### 7.2 hook が動作しない

WSL2 / Git Bash で動作することが前提。hook ファイルに実行権限が付与されているか確認:

```bash
chmod +x .claude/hooks/*.sh
```

### 7.3 並列案件で context が混ざる

studio-director が案件切替時の context flush を実行できていない可能性。明示的に切替コマンドを発行:

```
> /switch-project to=<project-id>
```

### 7.4 ハンドオフ YAML スキーマエラー

[handoff-protocols.md](handoff-protocols.md) の各プロトコルセクションを参照し、必須フィールドが揃っているか確認。

### 7.5 言語ポリシー違反

エージェントが英語で出力した場合(本来日本語で出すべき)、明示的に日本語指定:

```
> 日本語で出力してください。([language-policy.md](language-policy.md) Section X 参照)
```

### 7.6 法務テンプレで弁護士確認ヘッダーが省略された

`legal-pages-check.sh` フックがブロックする。ヘッダーを必ず復元:

```markdown
> **⚠️ 法務確認必須**
> 本テンプレートはひな型であり、AILEAP は法的助言を行いません。
> 本番運用前に必ず弁護士による確認を受けてください。
> 本テンプレートの使用に起因する一切の損害について、
> AILEAP は責任を負いません。
```

詳細は [legal-escalation-rules.md](legal-escalation-rules.md) 参照。

---

## 8. モデル切替の運用

[v0.2-direction.md](v0.2-direction.md) Section に従って、Phase ごとに使うモデルを切替える(実装時のみ・運用時は通常 Opus 4.7)。

| 操作 | コマンド |
|---|---|
| Opus 4.7 起動 | `claude --model opus-4-7` |
| Sonnet 4.6 に切替 | `/model sonnet-4-6` |
| Opus 4.7 に戻す | `/model opus-4-7` |
| 現在のモデル確認 | `/model` |

実案件運用時は Opus 4.7 を推奨(品質優先)。サブタスク(コードレビュー等)で軽量化したい場合のみ Sonnet 4.6 に一時切替。

---

## 9. 参考リソース

- [requirements-v0.2.md](requirements-v0.2.md) — 要件全体
- [architecture.md](architecture.md) — アーキテクチャ詳細
- [agent-roster.md](agent-roster.md) — エージェント名簿
- [agent-coordination-map.md](agent-coordination-map.md) — 協調マップ
- [handoff-protocols.md](handoff-protocols.md) — ハンドオフプロトコル
- [setup-requirements.md](setup-requirements.md) — セットアップ手順
- [pricing-strategy.md](pricing-strategy.md) — 価格戦略
- [geo-implementation-spec.md](geo-implementation-spec.md) — GEO 仕様
- [legal-escalation-rules.md](legal-escalation-rules.md) — 法務エスカレーション
- [language-policy.md](language-policy.md) — 言語ポリシー

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。v0.1 では存在せず、v0.2 で新設。 |

---

**本書は実運用時の最初の参照ドキュメントとして機能する。詳細な仕様は各専門ドキュメントを参照。**
