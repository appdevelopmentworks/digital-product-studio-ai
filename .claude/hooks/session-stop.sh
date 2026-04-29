#!/usr/bin/env bash
# =============================================================================
# session-stop.sh — AILEAP digital-product-studio-ai v0.2
# Hook: Stop
# Purpose: Log session end and show a brief uncommitted-changes summary
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# Language: Japanese (user-facing output) / English (internal logs)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

TODAY=$(date +%Y-%m-%d 2>/dev/null || echo "----")
NOW=$(date +%H:%M 2>/dev/null || echo "--:--")

echo ""
echo "  ── セッション終了 ──────────────────────────────────"
printf "  終了: %s %s\n" "$TODAY" "$NOW"

# ── Git status summary ────────────────────────────────────────────────────
if command -v git &>/dev/null && git -C "$DPSAI_PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  MODIFIED=$(git -C "$DPSAI_PROJECT_DIR" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  STAGED=$(git -C "$DPSAI_PROJECT_DIR" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  UNTRACKED=$(git -C "$DPSAI_PROJECT_DIR" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  BRANCH=$(git -C "$DPSAI_PROJECT_DIR" branch --show-current 2>/dev/null || echo "detached")

  echo ""
  printf "  Branch        : %s\n" "$BRANCH"
  printf "  ステージ済   : %s 件\n" "${STAGED:-0}"
  printf "  未ステージ   : %s 件\n" "${MODIFIED:-0}"
  printf "  未追跡       : %s 件\n" "${UNTRACKED:-0}"

  TOTAL_PENDING=$((${STAGED:-0} + ${MODIFIED:-0}))
  if [ "$TOTAL_PENDING" -gt 0 ]; then
    echo ""
    echo "  ℹ️  未コミットの変更があります。"
    echo "     必要に応じて git add / git commit を実行してください。"
  fi
else
  echo "  (git リポジトリなし)"
fi

# ── Active project quick status ───────────────────────────────────────────
ACTIVE_DIR=$(find_active_project)
if [ -n "$ACTIVE_DIR" ] && [ -f "$ACTIVE_DIR/PROJECT.md" ]; then
  PID=$(basename "$ACTIVE_DIR")
  PHASE=$(grep -m1 "^phase:" "$ACTIVE_DIR/PROJECT.md" 2>/dev/null | awk '{print $2}' || echo "—")
  echo ""
  printf "  アクティブ案件 : %s  phase: %s\n" "$PID" "${PHASE:-—}"
fi

echo ""

# ── Log session stop ──────────────────────────────────────────────────────
hook_log "session-stop" "stopped" "branch=${BRANCH:-unknown} staged=${STAGED:-0} modified=${MODIFIED:-0}"
