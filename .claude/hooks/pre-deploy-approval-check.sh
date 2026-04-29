#!/usr/bin/env bash
# =============================================================================
# pre-deploy-approval-check.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PreToolUse (matcher: Bash)
# Purpose: Before a deploy command, verify that required client approvals
#          are recorded as approved in the active project's approvals.yaml
#
# Required approvals before deploy:
#   - design_approval     : status must be "approved"
#   - content_approval    : status must be "approved"
#   - launch_approval     : status must be "approved"
#
# approvals.yaml location: <active_project>/00-engagement/approvals.yaml
#
# approvals.yaml schema (per /approval-record skill):
#   approvals:
#     - id: APV-001
#       type: design_approval
#       status: approved        # pending | approved | rejected
#       approved_by: 田中 太郎
#       approved_at: 2026-06-15
#       ...
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

hook_log "pre-deploy-approval-check" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Find active project ───────────────────────────────────────────────────
ACTIVE_DIR=$(find_active_project)

if [ -z "$ACTIVE_DIR" ]; then
  hook_log "pre-deploy-approval-check" "skip" "no active project found"
  exit 0
fi

PID=$(basename "$ACTIVE_DIR")

# ── Locate approvals.yaml ─────────────────────────────────────────────────
APPROVALS_FILE=""
for candidate in \
  "$ACTIVE_DIR/00-engagement/approvals.yaml" \
  "$ACTIVE_DIR/approvals.yaml"
do
  [ -f "$candidate" ] && APPROVALS_FILE="$candidate" && break
done

# ── No approvals.yaml — warn and block ───────────────────────────────────
if [ -z "$APPROVALS_FILE" ]; then
  echo "" >&2
  echo "================================================================" >&2
  echo "  [pre-deploy-approval-check] ❌ approvals.yaml が存在しません" >&2
  printf "  案件: %s\n" "$PID" >&2
  echo "----------------------------------------------------------------" >&2
  echo "  デプロイ前にクライアント承認を記録してください。" >&2
  echo "" >&2
  echo "  必要な承認:" >&2
  echo "    1. design_approval  — デザイン確認承認" >&2
  echo "    2. content_approval — コンテンツ確認承認" >&2
  echo "    3. launch_approval  — ローンチ承認" >&2
  echo "" >&2
  echo "  スキル: /approval-record  /approval-status" >&2
  echo "  ファイル: 00-engagement/approvals.yaml" >&2
  echo "================================================================" >&2
  echo "" >&2
  hook_log "pre-deploy-approval-check" "blocked" "no approvals.yaml for ${PID}"
  exit 2
fi

APPROVALS_CONTENT=$(cat "$APPROVALS_FILE" 2>/dev/null || echo "")

# ── Check required approval types ────────────────────────────────────────
# Required approval types and their Japanese labels
declare -A REQUIRED_APPROVALS
REQUIRED_APPROVALS["design_approval"]="デザイン承認"
REQUIRED_APPROVALS["content_approval"]="コンテンツ承認"
REQUIRED_APPROVALS["launch_approval"]="ローンチ承認"

MISSING_APPROVALS=()
PENDING_APPROVALS=()
REJECTED_APPROVALS=()

check_approval_status() {
  local approval_type="$1"

  # Check if the type appears in the file
  if ! echo "$APPROVALS_CONTENT" | grep -q "type:[[:space:]]*${approval_type}"; then
    return 1  # Not found
  fi

  # Extract the status following this type (within same approval block)
  # YAML block: find type: X then look for status: in nearby lines
  # Use awk to find the block containing type: approval_type and extract status
  local status
  status=$(awk "
    /type:[[:space:]]*${approval_type}/ { found=1 }
    found && /status:[[:space:]]*/ {
      match(\$0, /status:[[:space:]]*/);
      print substr(\$0, RSTART + RLENGTH);
      found=0
    }
    /^  - / && found { found=0 }
  " "$APPROVALS_FILE" 2>/dev/null | head -1 | tr -d ' \r\n')

  echo "${status:-unknown}"
}

for atype in "design_approval" "content_approval" "launch_approval"; do
  label="${REQUIRED_APPROVALS[$atype]}"
  status=$(check_approval_status "$atype")

  case "${status:-missing}" in
    approved)
      # Good — nothing to do
      ;;
    pending)
      PENDING_APPROVALS+=("$label ($atype): status=pending — 承認待ち")
      ;;
    rejected)
      REJECTED_APPROVALS+=("$label ($atype): status=rejected — 却下されています")
      ;;
    *)
      MISSING_APPROVALS+=("$label ($atype): 記録なし")
      ;;
  esac
done

ALL_ISSUES=("${MISSING_APPROVALS[@]}" "${PENDING_APPROVALS[@]}" "${REJECTED_APPROVALS[@]}")

# ── Pass ──────────────────────────────────────────────────────────────────
if [ "${#ALL_ISSUES[@]}" -eq 0 ]; then
  echo "" >&2
  echo "  [pre-deploy-approval-check] ✅ 必要な承認がすべて確認されました" >&2
  printf "  案件: %s | ファイル: %s\n" "$PID" "${APPROVALS_FILE#$DPSAI_PROJECT_DIR/}" >&2
  echo "" >&2
  hook_log "pre-deploy-approval-check" "pass" "all approvals confirmed for ${PID}"
  exit 0
fi

# ── Fail — block deploy ───────────────────────────────────────────────────
echo "" >&2
echo "================================================================" >&2
echo "  [pre-deploy-approval-check] ❌ 承認確認失敗" >&2
printf "  案件: %s\n" "$PID" >&2
echo "----------------------------------------------------------------" >&2

if [ "${#MISSING_APPROVALS[@]}" -gt 0 ]; then
  echo "  承認記録なし:" >&2
  for m in "${MISSING_APPROVALS[@]}"; do
    printf "    ❌ %s\n" "$m" >&2
  done
fi

if [ "${#PENDING_APPROVALS[@]}" -gt 0 ]; then
  echo "" >&2
  echo "  承認待ち (pending):" >&2
  for p in "${PENDING_APPROVALS[@]}"; do
    printf "    ⏳ %s\n" "$p" >&2
  done
fi

if [ "${#REJECTED_APPROVALS[@]}" -gt 0 ]; then
  echo "" >&2
  echo "  却下された承認:" >&2
  for r in "${REJECTED_APPROVALS[@]}"; do
    printf "    ✗  %s\n" "$r" >&2
  done
fi

echo "" >&2
echo "  クライアント承認を取得してから再デプロイしてください。" >&2
echo "  スキル: /approval-record  /approval-request  /approval-status" >&2
echo "  ファイル: ${APPROVALS_FILE#$DPSAI_PROJECT_DIR/}" >&2
echo "================================================================" >&2
echo "" >&2

DETAIL="${#MISSING_APPROVALS[@]} missing, ${#PENDING_APPROVALS[@]} pending, ${#REJECTED_APPROVALS[@]} rejected for ${PID}"
hook_log "pre-deploy-approval-check" "blocked" "$DETAIL"
exit 2
