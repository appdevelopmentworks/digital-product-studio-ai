#!/usr/bin/env bash
# =============================================================================
# legal-pages-check.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PreToolUse (matcher: Bash)
# Purpose: Before a deploy command, verify:
#   1. Privacy policy page exists in the project source
#   2. Tokushoho (特定商取引法) page exists (for EC/service sites)
#   3. If legal-review.yaml exists, lawyer_confirmation must be true
#
# Page detection searches:
#   src/pages/privacy*          (Astro / Next.js Pages Router)
#   src/app/privacy*/page.*     (Next.js App Router)
#   content/pages/privacy*      (CMS-managed)
#   public/privacy*             (Static)
#   Similarly for: tokushoho / specified-commercial / 特定商取引
#
# The lawyer confirmation check only applies when legal-review.yaml declares
#   requires_lawyer_review: true (A3 / B-series / payment sites)
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

hook_log "legal-pages-check" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Find active project ───────────────────────────────────────────────────
ACTIVE_DIR=$(find_active_project)

if [ -z "$ACTIVE_DIR" ]; then
  # No active project context — skip check (not a client project deploy)
  hook_log "legal-pages-check" "skip" "no active project found"
  exit 0
fi

PID=$(basename "$ACTIVE_DIR")
FAILURES=()
WARNINGS=()

# ── Helper: search for page file ─────────────────────────────────────────
# Usage: find_page_file <project_dir> <pattern>
# Returns 0 (found) or 1 (not found)
find_page_file() {
  local proj_dir="$1"
  local pattern="$2"

  # Search common source directories
  for search_root in \
    "$proj_dir/src" \
    "$proj_dir/app" \
    "$proj_dir/pages" \
    "$proj_dir/content" \
    "$proj_dir/public"
  do
    [ -d "$search_root" ] || continue
    if find "$search_root" -maxdepth 4 -iname "$pattern" 2>/dev/null | grep -q .; then
      return 0
    fi
  done

  # Also check project root
  find "$proj_dir" -maxdepth 3 -iname "$pattern" 2>/dev/null | grep -q . && return 0

  return 1
}

# ── Check 1: Privacy policy page ─────────────────────────────────────────
PRIVACY_FOUND=false
for pat in "privacy*" "privacy-policy*" "プライバシー*"; do
  if find_page_file "$ACTIVE_DIR" "$pat"; then
    PRIVACY_FOUND=true
    break
  fi
done

if ! $PRIVACY_FOUND; then
  FAILURES+=("プライバシーポリシーページが見つかりません")
  FAILURES+=("  検索パターン: privacy* / privacy-policy* (src/, pages/, content/)")
  FAILURES+=("  テンプレート: docs/templates/privacy-policy-template.md")
fi

# ── Check 2: Project type — determine if Tokushoho required ──────────────
TOKUSHOHO_REQUIRED=false
if [ -f "$ACTIVE_DIR/PROJECT.md" ]; then
  PROJECT_TYPE=$(grep -m1 "^type:" "$ACTIVE_DIR/PROJECT.md" 2>/dev/null | awk '{print $2}' || echo "")
  case "${PROJECT_TYPE,,}" in
    a3|b*|ec*|ecommerce*|*media*|*shop*)
      TOKUSHOHO_REQUIRED=true
      ;;
  esac
fi

if $TOKUSHOHO_REQUIRED; then
  TOKUSHOHO_FOUND=false
  for pat in "tokushoho*" "specified-commercial*" "特定商取引*" "legal-notice*"; do
    if find_page_file "$ACTIVE_DIR" "$pat"; then
      TOKUSHOHO_FOUND=true
      break
    fi
  done

  if ! $TOKUSHOHO_FOUND; then
    FAILURES+=("特定商取引法に基づく表記ページが見つかりません (A3/EC必須)")
    FAILURES+=("  検索パターン: tokushoho* / specified-commercial*")
    FAILURES+=("  テンプレート: docs/templates/tokushoho-template.md")
  fi
fi

# ── Check 3: Lawyer confirmation (if required by legal-review.yaml) ───────
LEGAL_REVIEW_FILE=""
for candidate in \
  "$ACTIVE_DIR/00-engagement/legal-review.yaml" \
  "$ACTIVE_DIR/legal-review.yaml"
do
  [ -f "$candidate" ] && LEGAL_REVIEW_FILE="$candidate" && break
done

if [ -n "$LEGAL_REVIEW_FILE" ]; then
  REQUIRES_LAWYER=$(grep -m1 "requires_lawyer_review:" "$LEGAL_REVIEW_FILE" 2>/dev/null \
    | grep -i "true" | wc -l | tr -d ' ')
  CONFIRMED=$(grep -m1 "lawyer_confirmation:" "$LEGAL_REVIEW_FILE" 2>/dev/null \
    | grep -i "true" | wc -l | tr -d ' ')

  if [ "${REQUIRES_LAWYER:-0}" -gt 0 ] && [ "${CONFIRMED:-0}" -eq 0 ]; then
    FAILURES+=("弁護士確認が必要ですが lawyer_confirmation: true が未設定です")
    FAILURES+=("  ファイル: ${LEGAL_REVIEW_FILE#$DPSAI_PROJECT_DIR/}")
    FAILURES+=("  参照: docs/legal-escalation-rules.md")
  fi
elif [ -f "$ACTIVE_DIR/PROJECT.md" ]; then
  # Check for A3 type without any legal review file — warning
  case "${PROJECT_TYPE:-}" in
    A3|a3|B*|b*)
      WARNINGS+=("legal-review.yaml が存在しません。A3/B 系案件では法務確認ファイルを推奨します")
      ;;
  esac
fi

# ── Pass ──────────────────────────────────────────────────────────────────
if [ "${#FAILURES[@]}" -eq 0 ]; then
  if [ "${#WARNINGS[@]}" -gt 0 ]; then
    echo "" >&2
    echo "  [legal-pages-check] ⚠️  警告:" >&2
    for w in "${WARNINGS[@]}"; do
      printf "    %s\n" "$w" >&2
    done
    echo "" >&2
    hook_log "legal-pages-check" "pass-with-warnings" "${#WARNINGS[@]} warnings for ${PID}"
  else
    hook_log "legal-pages-check" "pass" "legal pages verified for ${PID}"
  fi
  exit 0
fi

# ── Fail — block deploy ───────────────────────────────────────────────────
echo "" >&2
echo "================================================================" >&2
echo "  [legal-pages-check] ❌ 法的ページ確認失敗" >&2
printf "  案件: %s\n" "$PID" >&2
echo "----------------------------------------------------------------" >&2
for f in "${FAILURES[@]}"; do
  printf "  %s\n" "$f" >&2
done
if [ "${#WARNINGS[@]}" -gt 0 ]; then
  echo "" >&2
  echo "  警告:" >&2
  for w in "${WARNINGS[@]}"; do
    printf "    ⚠️  %s\n" "$w" >&2
  done
fi
echo "" >&2
echo "  必要なページを追加してから再デプロイしてください。" >&2
echo "  参照: docs/legal-escalation-rules.md" >&2
echo "================================================================" >&2
echo "" >&2

hook_log "legal-pages-check" "blocked" "${#FAILURES[@]} failures for ${PID}"
exit 2
