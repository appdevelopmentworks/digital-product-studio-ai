#!/usr/bin/env bash
# =============================================================================
# lighthouse-budget.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PreToolUse (matcher: Bash)
# Purpose: Before a deploy command executes, verify the project has a
#          lighthouse-scores.json file and that all 4 scores meet budgets.
#
# Budget defaults (from settings.json env block):
#   Performance  : DPSAI_LIGHTHOUSE_PERFORMANCE_MIN   = 90
#   Accessibility: DPSAI_LIGHTHOUSE_ACCESSIBILITY_MIN = 95
#   SEO          : DPSAI_LIGHTHOUSE_SEO_MIN           = 100
#   Best Practices: DPSAI_LIGHTHOUSE_BEST_PRACTICES_MIN = 90
#
# Score file locations checked (first match wins):
#   <project_dir>/lighthouse-scores.json
#   <active_project>/.lighthouse-scores.json
#   $DPSAI_PROJECT_DIR/lighthouse-scores.json
#
# To generate the score file, run in the active project:
#   npx @lhci/cli collect --url=http://localhost:3000
#   npx @lhci/cli assert
# Or manually create lighthouse-scores.json with format:
#   { "performance": 92, "accessibility": 98, "seo": 100, "best-practices": 93 }
#
# Exit: 0 = proceed | 2 = block deploy
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

# ── Parse hook input ──────────────────────────────────────────────────────
HOOK_JSON=$(hook_stdin)
TOOL_CMD=$(json_get "$HOOK_JSON" "tool_input.command")

# Early exit: only gate on deploy commands
if ! is_deploy_cmd "${TOOL_CMD:-}"; then
  exit 0
fi

hook_log "lighthouse-budget" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Locate lighthouse scores file ─────────────────────────────────────────
SCORES_FILE=""
ACTIVE_DIR=$(find_active_project)

# Priority order: active project > root
for candidate in \
  "${ACTIVE_DIR:+$ACTIVE_DIR/lighthouse-scores.json}" \
  "${ACTIVE_DIR:+$ACTIVE_DIR/.lighthouse-scores.json}" \
  "$DPSAI_PROJECT_DIR/lighthouse-scores.json" \
  "$DPSAI_PROJECT_DIR/.lighthouse-scores.json"
do
  [ -z "$candidate" ] && continue
  if [ -f "$candidate" ]; then
    SCORES_FILE="$candidate"
    break
  fi
done

# ── No scores file found ──────────────────────────────────────────────────
if [ -z "$SCORES_FILE" ]; then
  echo "" >&2
  echo "================================================================" >&2
  echo "  [lighthouse-budget] ⚠️  スコアファイル未検出" >&2
  echo "----------------------------------------------------------------" >&2
  echo "  デプロイ前に Lighthouse スコアを生成してください:" >&2
  echo "" >&2
  echo "  1. 開発サーバーを起動:" >&2
  echo "     pnpm dev  (または npm run dev)" >&2
  echo "" >&2
  echo "  2. スコアを生成:" >&2
  echo "     npx @lhci/cli collect --url=http://localhost:3000" >&2
  echo "     npx @lhci/cli assert" >&2
  echo "" >&2
  echo "  または手動で lighthouse-scores.json を作成:" >&2
  echo "  { \"performance\": 92, \"accessibility\": 98," >&2
  echo "    \"seo\": 100, \"best-practices\": 93 }" >&2
  echo "" >&2
  echo "  予算: Performance≥${LH_PERF_MIN} / Accessibility≥${LH_A11Y_MIN}" >&2
  echo "       SEO≥${LH_SEO_MIN} / Best Practices≥${LH_BP_MIN}" >&2
  echo "================================================================" >&2
  echo "" >&2
  # Warn but do NOT block — scores file may not exist in all projects
  hook_log "lighthouse-budget" "warn-no-file" "no lighthouse-scores.json found before deploy"
  exit 0
fi

hook_log "lighthouse-budget" "checking" "scores_file=${SCORES_FILE##*/}"

# ── Parse scores ──────────────────────────────────────────────────────────
SCORES_JSON=$(cat "$SCORES_FILE" 2>/dev/null || echo "{}")

get_score() {
  local key="$1"
  local val

  if command -v node &>/dev/null; then
    val=$(printf '%s' "$SCORES_JSON" | node -e "
var d='';
process.stdin.on('data',function(c){d+=c});
process.stdin.on('end',function(){
  try{var v=JSON.parse(d);process.stdout.write(String(v['${key}']||0));}
  catch(e){process.stdout.write('0');}
});
" 2>/dev/null || echo "0")
  elif command -v jq &>/dev/null; then
    val=$(printf '%s' "$SCORES_JSON" | jq -r ".\"${key}\" // 0" 2>/dev/null || echo "0")
  elif command -v python3 &>/dev/null; then
    val=$(printf '%s' "$SCORES_JSON" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(int(d.get('${key}', 0)))
except:
    print(0)
" 2>/dev/null || echo "0")
  else
    # Grep fallback — handles simple numeric values
    val=$(printf '%s' "$SCORES_JSON" \
      | grep -o "\"${key}\"[[:space:]]*:[[:space:]]*[0-9][0-9]*" \
      | head -1 | grep -o "[0-9][0-9]*$" || echo "0")
  fi
  echo "${val:-0}"
}

PERF=$(get_score "performance")
A11Y=$(get_score "accessibility")
SEO=$(get_score "seo")
BP=$(get_score "best-practices")

# Handle Lighthouse CI format (0.0-1.0) vs integer format (0-100)
# If all scores are ≤ 1, multiply by 100
if [ "${PERF:-0}" -le 1 ] && [ "${A11Y:-0}" -le 1 ] 2>/dev/null; then
  PERF=$(echo "$PERF * 100" | awk '{printf "%d", $0 * 100}' 2>/dev/null || echo "$PERF")
  A11Y=$(echo "$A11Y * 100" | awk '{printf "%d", $0 * 100}' 2>/dev/null || echo "$A11Y")
  SEO=$(echo "$SEO * 100" | awk '{printf "%d", $0 * 100}' 2>/dev/null || echo "$SEO")
  BP=$(echo "$BP * 100" | awk '{printf "%d", $0 * 100}' 2>/dev/null || echo "$BP")
fi

# ── Validate against budgets ──────────────────────────────────────────────
FAILURES=()

if [ "${PERF:-0}" -lt "${LH_PERF_MIN:-90}" ] 2>/dev/null; then
  FAILURES+=("Performance: ${PERF} < ${LH_PERF_MIN} (目標 ${LH_PERF_MIN})")
fi
if [ "${A11Y:-0}" -lt "${LH_A11Y_MIN:-95}" ] 2>/dev/null; then
  FAILURES+=("Accessibility: ${A11Y} < ${LH_A11Y_MIN} (目標 ${LH_A11Y_MIN})")
fi
if [ "${SEO:-0}" -lt "${LH_SEO_MIN:-100}" ] 2>/dev/null; then
  FAILURES+=("SEO: ${SEO} < ${LH_SEO_MIN} (目標 ${LH_SEO_MIN})")
fi
if [ "${BP:-0}" -lt "${LH_BP_MIN:-90}" ] 2>/dev/null; then
  FAILURES+=("Best Practices: ${BP} < ${LH_BP_MIN} (目標 ${LH_BP_MIN})")
fi

# ── Pass ──────────────────────────────────────────────────────────────────
if [ "${#FAILURES[@]}" -eq 0 ]; then
  echo "" >&2
  echo "  [lighthouse-budget] ✅ Lighthouse スコア — 予算内" >&2
  printf "    Performance: %s  Accessibility: %s  SEO: %s  BP: %s\n" \
    "$PERF" "$A11Y" "$SEO" "$BP" >&2
  echo "" >&2
  hook_log "lighthouse-budget" "pass" "P=${PERF} A=${A11Y} S=${SEO} BP=${BP}"
  exit 0
fi

# ── Fail — block deploy ───────────────────────────────────────────────────
MSG="Lighthouse 予算違反 — デプロイをブロックします"$'\n\n'
MSG+="  現在スコア:"$'\n'
MSG+="    Performance  : ${PERF}  (目標 ≥ ${LH_PERF_MIN})"$'\n'
MSG+="    Accessibility: ${A11Y}  (目標 ≥ ${LH_A11Y_MIN})"$'\n'
MSG+="    SEO          : ${SEO}  (目標 ≥ ${LH_SEO_MIN})"$'\n'
MSG+="    Best Practices: ${BP}  (目標 ≥ ${LH_BP_MIN})"$'\n\n'
MSG+="  未達項目:"$'\n'
for f in "${FAILURES[@]}"; do
  MSG+="    ❌ ${f}"$'\n'
done
MSG+=$'\n'"  スコアを改善してから再デプロイしてください。"
MSG+=$'\n'"  参照: docs/requirements-v0.2.md Section 7"

echo "" >&2
echo "================================================================" >&2
echo "  [lighthouse-budget] ❌ Lighthouse 予算違反" >&2
echo "----------------------------------------------------------------" >&2
for f in "${FAILURES[@]}"; do
  printf "    ❌ %s\n" "$f" >&2
done
echo "" >&2
printf "  現在: P=%s A=%s S=%s BP=%s\n" "$PERF" "$A11Y" "$SEO" "$BP" >&2
printf "  目標: P≥%s A≥%s S≥%s BP≥%s\n" \
  "$LH_PERF_MIN" "$LH_A11Y_MIN" "$LH_SEO_MIN" "$LH_BP_MIN" >&2
echo "================================================================" >&2
echo "" >&2

hook_log "lighthouse-budget" "blocked" "P=${PERF} A=${A11Y} S=${SEO} BP=${BP}"
exit 2
