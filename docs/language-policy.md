# 言語ポリシー

**バージョン**: 0.2
**作成日**: 2026-04-27
**位置づけ**: [v0.2-direction.md](v0.2-direction.md) Section 3 を独立文書化(B-H1 起源)
**対象**: digital-product-studio-ai のすべてのファイル・エージェント・スキル・出力
**重要**: 本書はすべてのエージェント・スキルが必須参照する正式な言語ポリシー

---

## 0. 本書の目的

[v0.2-direction.md](v0.2-direction.md) Section 3 で確定した言語ポリシーを独立文書化する。本書はすべてのエージェント・スキルが必須参照する正本となる。

具体的に本書は以下を定義する:

1. **日本語必須ファイル**(Shin / クライアント向け)
2. **英語推奨ファイル**(AI 内部処理ファイル)
3. **エージェント出力時の言語ルール**(母国語に合わせる)
4. **多言語対応案件での生成言語**(i18n プロジェクト)
5. **言語ポリシー違反の検出と修正**

---

## 1. 言語ポリシーの基本原則

### 1.1 三層分離の原則

```
[Layer 1: 人間が読む層]                  必ず日本語
  Shin 向け文書 / クライアント納品物
  例: docs/ 配下、README、CLAUDE.md の Shin 向け部分、
      docs/templates/ 配下のクライアント向けテンプレート

[Layer 2: AI が読む層]                   英語推奨
  エージェント定義 / スキル定義 / hooks / rules / 設定
  例: .claude/agents/、.claude/skills/、.claude/hooks/、
      .claude/rules/、.claude/settings.json

[Layer 3: AI が出力する層]               ユーザーの母国語
  AI が生成して人間に提示する出力
  ルール: 必ずユーザーの母国語に合わせる
  日本: 日本語、グローバル: 英語、その他: 該当言語
```

### 1.2 採用理由

- **Layer 1**: 読み手(Shin / クライアント)の認知負荷を最小化。日本語が母国語のため日本語で固定。
- **Layer 2**: AI(LLM)は英語で訓練されたデータが最も多く、英語のほうが推論精度が高い。技術用語・プログラミング用語は英語で書いた方が誤解が少ない。
- **Layer 3**: ユーザー体験の最適化。Layer 2 が英語でも、出力は必ず母国語にする(エージェントプロンプト末尾の Output Language Policy で強制)。

---

## 2. 日本語必須ファイル(Layer 1)

### 2.1 docs/ 配下(全文書)

```
docs/
├── requirements-v0.1.md               日本語(履歴)
├── gap-analysis-v0.1.md               日本語(履歴)
├── v0.2-direction.md                  日本語(履歴)
├── claude-code-handoff.md             日本語(履歴)
├── requirements-v0.2.md               日本語
├── architecture.md                    日本語
├── handoff-protocols.md               日本語
├── agent-roster.md                    日本語
├── agent-coordination-map.md          日本語
├── quick-start.md                     日本語
├── setup-requirements.md              日本語
├── pricing-strategy.md                日本語
├── geo-implementation-spec.md         日本語
├── legal-escalation-rules.md          日本語
├── language-policy.md                 日本語(本書)
└── templates/                         日本語(全 21 テンプレート)
    ├── proposal-deck.md               日本語
    ├── estimate.md                    日本語
    ├── sow.md                         日本語
    ├── change-order.md                日本語
    ├── requirements-v0.md             日本語
    ├── competitor-analysis.md         日本語
    ├── persona.md                     日本語
    ├── user-journey-map.md            日本語
    ├── sitemap.md                     日本語
    ├── measurement-plan.md            日本語
    ├── content-strategy.md            日本語
    ├── seo-geo-strategy.md            日本語
    ├── design-system.md               日本語
    ├── launch-checklist.md            日本語
    ├── redirect-map.md                日本語
    ├── handoff-package.md             日本語
    ├── cms-manual.md                  日本語
    ├── handoff-to-wmao.md             日本語
    ├── legal-privacy-policy.md        日本語
    ├── legal-terms.md                 日本語
    └── legal-tokushoho.md             日本語
```

### 2.2 ルートレベルの主要ファイル

```
README.md                              日本語(プロジェクト概要・Shin 向け)
CLAUDE.md                              ハイブリッド(Section 5 参照)
UPGRADING.md                           日本語(v0.2 完成後追加)
```

### 2.3 案件ファイル(projects/{id}/ 配下)

```
projects/{id}/                         日本語(クライアント向け成果物)
├── PROJECT.md                         日本語
├── 00-engagement/
│   ├── meetings/                      日本語(議事録)
│   ├── correspondence/                日本語(クライアント連絡)
│   ├── decisions.yaml                 日本語値(YAML キーは英語、値は日本語)
│   ├── approvals.yaml                 同上
│   ├── stakeholders.yaml              同上
│   └── proposal-deck.md, estimate.md  日本語
├── 01-discovery/                      日本語(クライアント納品物の元)
├── 02-strategy/                       日本語
├── 03-design/                         日本語
├── 06-launch/                         日本語
└── 08-handoff/                        日本語
```

YAML ファイルの扱い:
- **キー名**: 英語(snake_case)— AI と人間の両方が読むため
- **値**: 日本語可(自由記述部分)、ID 等は英語
- 例: `title: "技術スタック確定"`(キー英語、値日本語)

---

## 3. 英語推奨ファイル(Layer 2)

### 3.1 .claude/ 配下(全ファイル)

```
.claude/
├── settings.json                      英語(キー名・コメント)
├── agents/                            英語(全プロンプト本体)
│   ├── tier0-studio-director.md       英語
│   ├── tier1-strategy-director.md     英語
│   ├── tier1-creative-director.md     英語
│   ├── tier1-technology-director.md   英語
│   ├── tier1-product-director.md      英語
│   ├── tier1-delivery-director.md     英語
│   ├── tier2-ux-strategy-lead.md      英語
│   ├── tier2-content-strategy-lead.md 英語
│   ├── tier2-art-direction-lead.md    英語
│   ├── tier2-frontend-lead.md         英語
│   ├── tier2-backend-lead.md          英語
│   ├── tier2-client-success-lead.md   英語
│   ├── tier3-ui-designer.md           英語
│   ├── tier3-copywriter.md            英語
│   ├── tier3-frontend-engineer.md     英語
│   ├── tier3-cms-engineer.md          英語
│   ├── tier3-seo-geo-strategist.md    英語
│   ├── tier3-commercial-manager.md    英語
│   ├── stack-nextjs-specialist.md     英語
│   ├── stack-wordpress-specialist.md  英語
│   └── stack-localization-specialist.md 英語
├── skills/                            英語(全 SKILL.md)
│   └── */SKILL.md                     英語
├── hooks/                             英語(全 .sh、コメント含む)
│   └── *.sh                           英語
└── rules/                             英語(全 path-scoped rules)
    └── *.md                           英語
```

### 3.2 ハイブリッドファイル(英語 + 日本語例示)

以下のファイルは英語ベースだが、日本語の使用例を含める:

```
.claude/skills/proposal-deck/SKILL.md
  → 英語でスキル定義 + 日本語の出力例を併記

.claude/skills/client-onboarding/SKILL.md
  → 英語でスキル定義 + 日本語のヒアリング質問例を併記

.claude/skills/requirements-gathering/SKILL.md
  → 英語でスキル定義 + 日本語の要件定義書例を併記

.claude/skills/meeting-minutes/SKILL.md
  → 英語でスキル定義 + 日本語の議事録例を併記
```

英語と日本語の併記方法:

```markdown
# Skill Definition (English)

## Purpose
Generate proposal deck for client.

## Steps
1. Read project context from projects/{id}/00-engagement/
2. Read pricing-strategy.md for price ranges
3. Generate proposal sections:
   ...

## Example Output (Japanese)

> 以下は実際の出力例です:
>
> # ご提案書
>
> ## 1. 課題のご整理
> ...
```

---

## 4. エージェント出力時の言語ルール(Layer 3)

### 4.1 Output Language Policy(必須挿入文)

すべてのエージェントプロンプト末尾に以下を必ず含める:

```markdown
## Output Language Policy

**ALWAYS respond in the user's native language.** Detection rules:

- Internal team communication (with Shin / AILEAP): **Japanese**
- Client deliverables (proposals, requirements docs, presentations):
  Match the client's language. Default to **Japanese** for domestic SME
  clients in Japan unless otherwise specified.
- Multi-language sites (i18n projects): Generate content in all target
  languages as specified in the project's i18n configuration.
- Technical artifacts read only by other agents (intermediate YAML,
  internal logs): English is acceptable.

When in doubt, default to **Japanese**.
```

### 4.2 言語判定の優先順位

```
[1] 案件設定で言語が明示されているか?
    projects/{id}/PROJECT.md の output_language フィールドを参照
    → 該当言語で出力
    
[2] クライアントの主要事業地域は?
    handoff-from-strategy.yaml の client.region から推定
    → 主要事業地域の言語で出力
    
[3] Shin との内部対話か?
    → 日本語で出力(Shin の母国語)
    
[4] 案件文脈が不明な場合
    → 日本語をデフォルトとする
```

### 4.3 案件タイプ別の出力言語ガイド

| 案件タイプ | クライアント納品物 | 内部成果物(decisions.yaml 等) |
|---|---|---|
| 国内 SME 向け A1 / A2 / A3 | 日本語 | 日本語値 + 英語キー |
| 海外 SME 向け案件(英語圏) | 英語 | 英語 |
| 海外 SME 向け案件(中国・韓国) | 各言語 + 英語併記 | 日本語または英語(社内整合用) |
| 多言語サイト案件 | 設定された全言語 | 日本語または英語 |
| AILEAP 自社プロダクト案件 | 日本語(主要)+ 4 言語(将来) | 日本語 |

---

## 5. CLAUDE.md のハイブリッド構造

`CLAUDE.md` は AI エージェント全体への指示書。Shin 向け部分(運用説明)と AI 向け部分(行動指示)が混在するため、ハイブリッド構造を取る。

### 5.1 推奨構造

```markdown
# CLAUDE.md(プロジェクト全体指示書)

## このプロジェクトについて(Shin 向け・日本語)

<プロジェクト概要・運用ルール・段階展開戦略の概要を日本語で記述>

## Agent Instructions (For AI Agents・英語)

<エージェント全体への行動指示を英語で記述>

### Language Policy
See docs/language-policy.md for full policy.
TL;DR:
- Shin / client communication: Japanese
- Internal AI files: English
- Output: match user's native language

### Document References
- docs/requirements-v0.2.md (requirements)
- docs/architecture.md (architecture)
- docs/agent-roster.md (agents)
- docs/agent-coordination-map.md (coordination)
- docs/handoff-protocols.md (handoffs)
- docs/pricing-strategy.md (pricing)
- docs/geo-implementation-spec.md (GEO)
- docs/legal-escalation-rules.md (legal)
- docs/language-policy.md (language)
- docs/quick-start.md (operations)
- docs/setup-requirements.md (setup)

### Critical Rules

1. **Stage Gating**: v0.2 = 21 agents. Do NOT introduce v0.3/v0.4 agents.
2. **Approval Gate**: pre-deploy-approval-check.sh enforces approvals.yaml before deploy.
3. **Legal Header**: legal-pages-check.sh enforces lawyer-confirmation header on legal templates.
4. **Multi-tenant Isolation**: Respect projects/{id}/** path-scoped rule.
5. **Mode Switching**: Auto-detect production/development mode by project type.
```

---

## 6. 多言語対応案件での生成ルール

### 6.1 v0.2 段階の対応範囲

[requirements-v0.2.md](requirements-v0.2.md) Section 16 / [v0.2-direction.md](v0.2-direction.md) Q5 で確定:

- 対応言語: 日本語(ja)/ 英語(en)/ 中国語簡体字(zh-CN)/ 韓国語(ko)
- v0.2 では `localization-specialist` と `/i18n-strategy` のみ実装
- 全テンプレートの 4 言語化は v0.3 以降

### 6.2 多言語案件の生成フロー

```
[1] /client-onboarding で多言語要件をヒアリング
    → projects/{id}/PROJECT.md に target_languages を記録
    
[2] /i18n-strategy で多言語戦略文書生成
    → projects/{id}/02-strategy/i18n-strategy.md
    → URL 構造(/ja/、/en/、/zh-CN/、/ko/ または別ドメイン)
    → 翻訳ワークフロー(機械翻訳 → 人手レビュー)
    → hreflang 戦略
    
[3] copywriter が日本語版を作成
    
[4] localization-specialist が翻訳パイプラインを設計
    → 機械翻訳(DeepL / Claude / GPT-4)
    → 人手レビュー(Shin が日英中韓ネイティブまたは高度話者のため Shin 自身でレビュー可能)
    
[5] frontend-engineer が i18n 実装
    → next-intl(Next.js)/ Astro i18n / Polylang(WordPress)
```

### 6.3 生成成果物の言語要件

| 成果物 | 日本語 | 英語 | 中国語 | 韓国語 |
|---|---|---|---|---|
| 戦略文書(社内) | ✅ 必須 | (任意) | — | — |
| クライアント納品物(国内案件) | ✅ 必須 | — | — | — |
| クライアント納品物(海外案件) | (任意) | ✅ 必須 | (案件次第) | (案件次第) |
| サイトコンテンツ(多言語サイト) | ✅ 必須(主) | 必須 | 必須 | 必須 |
| メタデータ(多言語サイト) | ✅ | ✅ | ✅ | ✅ |

---

## 7. 言語ポリシー違反の検出と修正

### 7.1 違反パターン例

| 違反パターン | 検出方法 | 修正方法 |
|---|---|---|
| docs/ 配下に英語で書かれた | 目視レビュー | 日本語に翻訳 |
| .claude/agents/ 配下に日本語プロンプト | 目視レビュー | 英語に翻訳(Output Language Policy のみ多言語可) |
| エージェント出力が英語(Shin 対話時) | Shin が指摘 | 「日本語で出力してください」と指示 |
| エージェント出力が日本語(海外クライアント時) | client-success-lead が指摘 | 案件設定の output_language を確認 |
| 法務テンプレートの確認ヘッダー欠落 | legal-pages-check.sh 自動検出 | ヘッダー復元 |
| YAML 値が言語不適切(英語キー名は OK・値が日本語混在) | 目視・lint | 用途に応じて統一 |

### 7.2 違反検出時の標準対応

```
[1] 違反を検出(Shin / 他エージェント / フック)
[2] 違反箇所を特定
[3] language-policy.md の該当ルールを参照
[4] 適切な言語に修正
[5] decisions.yaml に「言語ポリシー違反検出 → 修正」を記録
```

### 7.3 violation.yaml(将来拡張)

v0.3 以降で言語ポリシー違反を自動検出するスクリプトを `validate-language-policy.sh` として実装予定。違反を `projects/{id}/00-engagement/violations.yaml` に記録する。

---

## 8. 用語の翻訳ガイド

### 8.1 専門用語の言語選択

技術用語・業界用語の表記:

| 概念 | 推奨表記 | 注意 |
|---|---|---|
| サイトマップ | サイトマップ(カタカナ) | "Sitemap" は技術ファイル名(.xml)を指す時のみ英語 |
| ペルソナ | ペルソナ | "Persona" は英語ファイル名のみ |
| カスタマージャーニー | カスタマージャーニー | "User Journey" は英語ファイル名のみ |
| アクセシビリティ | アクセシビリティ | "WCAG" は固有名詞として英語 |
| Lighthouse | Lighthouse(英語固有名詞) | カタカナにしない |
| Core Web Vitals | Core Web Vitals(英語固有名詞) | カタカナにしない |
| Atomic Design | Atomic Design(英語固有名詞) | 同上 |
| GEO / SEO | GEO / SEO(略語固有名詞) | 略さず書く時は「LLM 引用最適化」「検索エンジン最適化」 |
| API | API | カタカナ「エーピーアイ」は不可 |
| CMS | CMS | 略さず書く時は「コンテンツ管理システム」 |
| Retainer | リテイナー(月額保守) | 初出時にカッコ書きで補足 |

### 8.2 ブランド名

- AILEAP: 英語表記固定(全角化禁止)
- digital-product-studio-ai: 英語表記固定(本組織名)
- apex-consulting-ai: 英語表記固定(上流組織)
- web-marketing-ai-org / WMAO: 英語表記固定(下流組織)

### 8.3 数字・単位

- 金額: 「50 万円」「1,000 万円」(税抜・税込明示)
- 工数: 「100 時間」「1 ヶ月」
- パーセンテージ: 「50%」「+20%」
- 日付: ISO 8601(「2026-04-27」)推奨

---

## 9. 用語集の整合(将来)

### 9.1 3 組織共通用語集

[gap-analysis-v0.1.md](gap-analysis-v0.1.md) CO-M4 で指摘された「apex / WMAO の用語集と整合確認なし」問題は、v0.3 以降で 3 組織共通用語集として整備する。

v0.2 段階では本組織内の用語整合のみ([requirements-v0.2.md](requirements-v0.2.md) 付録 B 用語集を正本とする)。

### 9.2 言語ポリシーの 3 組織整合

- apex-consulting-ai: 英語ベース(MBB スタイルが英語慣習)
- digital-product-studio-ai: 上記三層分離(本書)
- web-marketing-ai-org: 日本語中心(運用がローカル言語前提)

3 組織でハンドオフ時は YAML 形式(キー英語・値ハイブリッド)で受け渡し([handoff-protocols.md](handoff-protocols.md))。

---

## 10. 改訂履歴

| バージョン | 日付 | 主な変更 |
|---|---|---|
| 0.2 | 2026-04-27 | 初版。[v0.2-direction.md](v0.2-direction.md) Section 3 を独立文書化。 |

---

**本書はすべてのエージェント・スキルが必須参照する正式な言語ポリシーである。実装時は本書のルールに従って Layer 1(日本語)/ Layer 2(英語)/ Layer 3(母国語)を厳格に分離すること。違反検出時は本書を参照して修正する。**
