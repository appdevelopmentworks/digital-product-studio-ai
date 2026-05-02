# 業務範囲合意書(SOW)— AILEAP MeetingAI 紹介 LP

**案件**: AILEAP MeetingAI 紹介 LP
**案件 ID**: AILEAP-MTG-20260601-001
**版**: 1.0(internal)
**作成日**: 2026-06-01
**作成者**: delivery-director / commercial-manager
**ステータス**: 承認済(APV-002・自社内部)

> 自社案件のため通常の SOW より簡素化。internal mode。

---

## 1. 業務範囲

### 1.1 対象スコープ

- LP 1 ページ(`/`)+ thank you ページ(`/thanks`)の制作・公開
- お問い合わせ / β版申込みフォーム実装
- aileap_v2 のデザインシステム継承による視覚一貫性確保
- SEO / GEO 標準対応(llms.txt は aileap_v2 と統合)
- 公開後 30 日サポート(Phase 5)

### 1.2 対象外

- 多言語(en)対応(MeetingAI 国内開始のため)
- 大規模カスタムデザイン(aileap_v2 design-system 継承)
- ブログ機能(LP 単発)
- 法務:利用規約・特商法(privacy のみ対応)

---

## 2. フェーズ構成

| フェーズ | 期間 | 主成果物 |
|---|---|---|
| Engagement | 2026-06-01 ～ 06-02(2 日) | apex-handoff / 要件確定 / 見積 |
| Strategy | 2026-06-03 ～ 06-05(3 日) | LP 構成 / コピー戦略 |
| Design | 2026-06-06 ～ 06-10(5 日) | LP デザイン(aileap_v2 継承+差分) |
| Implementation | 2026-06-11 ～ 06-22(2 週) | 実装 + フォーム |
| QA | 2026-06-23 ～ 06-25(3 日) | 3 audit |
| Launch | 2026-06-26 ～ 06-30(5 日) | 公開 |
| Phase 5 | 2026-07-01 ～ 07-30(30 日) | post-launch サポート |

合計: 約 4 週間 + 公開後 30 日

---

## 3. 第5フェーズ:公開後サポート(Phase 5・含む)

期間: 公開日 + 30 日

含む業務:
- 公開直後の重大バグ修正(無償)
- Lighthouse スコア再測定 + 必要に応じた最小チューニング
- 初動 SEO/GEO 検証レポート発行(30 日後)
- アクセス解析ベースライン記録
- 軽微なコンテンツ修正(本フェーズ累計 3 時間以内・LP は規模小)

本フェーズの工数は内部見積(60h)に含まれます。
公開 31 日目以降の継続運用は WMAO 引継ぎまたは本組織内継続。

---

## 4. 主要承認(approvals.yaml)

| マイルストーン | 承認 ID | 承認者 |
|---|---|---|
| 要件定義 v1 確定 | APV-001 | Shin |
| 内部見積 | APV-002 | Shin |
| デザイン(aileap_v2 継承+差分) | APV-003 | Shin |
| コンテンツ承認 | APV-004 | Shin |
| 公開判定 | APV-005 | Shin |
| WMAO 引継ぎ判定 | APV-006 | Shin |

---

## 5. 工数(internal mode)

| フェーズ | 想定工数 |
|---|---|
| Engagement | 5h |
| Strategy | 8h |
| Design | 12h(aileap_v2 継承で軽量化) |
| Implementation | 18h |
| QA / Launch | 8h |
| Post-launch(30 日) | 9h |
| **合計** | **60h** |

外部委託していたら相当の額(参考値): 350,000 円(A2 標準レンジ 20-50 万円の中央付近)

---

## 6. 関連文書

- `00-engagement/apex-to-dpsai-handoff.yaml`(自社内部疑似ハンドオフ)
- `00-engagement/estimate.yaml`(internal mode)
- `00-engagement/approvals.yaml`(6 件の APV)
- `01-discovery/requirements-v0.md`
- `aileap_v2/03-design/design-system.md`(継承元)

---

**Document Owner**: delivery-director / commercial-manager
**Last Updated**: 2026-06-01
**Version**: 1.0
