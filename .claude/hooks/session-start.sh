#!/usr/bin/env bash
# =============================================================================
# session-start.sh — AILEAP digital-product-studio-ai v0.2
# Hook: SessionStart
# Purpose: Display project state summary when a Claude Code session begins
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# Language: Japanese (user-facing output) / English (internal logs)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

TODAY=$(date +%Y-%m-%d 2>/dev/null || echo "----")
NOW=$(date +%H:%M 2>/dev/null || echo "--:--")

# ── Banner ────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  digital-product-studio-ai  v${DPSAI_VERSION}  [AILEAP]         ║"
echo "╚══════════════════════════════════════════════════════╝"
printf "  開始: %s %s\n" "$TODAY" "$NOW"

# ── Git branch ────────────────────────────────────────────────────────────
BRANCH="(git なし)"
if command -v git &>/dev/null; then
  BRANCH=$(git -C "$DPSAI_PROJECT_DIR" branch --show-current 2>/dev/null \
    || git -C "$DPSAI_PROJECT_DIR" rev-parse --short HEAD 2>/dev/null \
    || echo "detached")
fi
printf "  Branch : %s\n" "$BRANCH"
echo ""

# ── Active projects ───────────────────────────────────────────────────────
if [ -d "$DPSAI_PROJECTS_DIR" ]; then
  mapfile -t PFILES < <(find "$DPSAI_PROJECTS_DIR" -maxdepth 2 -name "PROJECT.md" 2>/dev/null | sort)
  if [ "${#PFILES[@]}" -gt 0 ]; then
    echo "  ── アクティブ案件 ────────────────────────────────────"
    for pfile in "${PFILES[@]}"; do
      PID=$(basename "$(dirname "$pfile")")
      PHASE=$(grep -m1 "^phase:" "$pfile" 2>/dev/null | awk '{print $2}' || echo "—")
      STATUS=$(grep -m1 "^status:" "$pfile" 2>/dev/null | awk '{print $2}' || echo "—")
      printf "  • %-24s  phase: %-10s  status: %s\n" \
        "$PID" "${PHASE:-—}" "${STATUS:-—}"
    done

    # Parallel project count warning
    ACTIVE_CNT=$(grep -l "^status:[[:space:]]*active" "${PFILES[@]}" 2>/dev/null | wc -l | tr -d ' ')
    MAX_PARALLEL="${DPSAI_MAX_PARALLEL_PROJECTS:-3}"
    if [ "${ACTIVE_CNT:-0}" -gt "$MAX_PARALLEL" ]; then
      echo ""
      printf "  ⚠️  並列案件 %d 件（上限 %d 件）— studio-director 確認要\n" \
        "$ACTIVE_CNT" "$MAX_PARALLEL"
    fi
  else
    echo "  案件なし — /client-onboarding で新規案件を開始してください"
  fi
else
  echo "  案件なし — /client-onboarding で新規案件を開始してください"
fi

echo ""

# ── Pending approvals ─────────────────────────────────────────────────────
PENDING=0
if [ -d "$DPSAI_PROJECTS_DIR" ]; then
  while IFS= read -r afile; do
    CNT=$(grep -c "status:[[:space:]]*pending" "$afile" 2>/dev/null || echo 0)
    PENDING=$((PENDING + CNT))
  done < <(find "$DPSAI_PROJECTS_DIR" -name "approvals.yaml" 2>/dev/null)
fi
if [ "$PENDING" -gt 0 ]; then
  printf "  ⏳ 承認待ち: %d 件 — /approval-status で確認\n" "$PENDING"
  echo ""
fi

# ── Hook log summary (last 3 events) ─────────────────────────────────────
HOOKS_LOG="$DPSAI_STATE_DIR/hooks.jsonl"
if [ -f "$HOOKS_LOG" ]; then
  WARN_CNT=$(grep -c '"event":"blocked"\|"event":"warn"' "$HOOKS_LOG" 2>/dev/null || echo 0)
  if [ "${WARN_CNT:-0}" -gt 0 ]; then
    printf "  ⚠️  前回セッション: ブロック/警告 %d 件あり\n" "$WARN_CNT"
    printf "     詳細: .claude/state/hooks.jsonl\n"
    echo ""
  fi
fi

# ── Quick reference ───────────────────────────────────────────────────────
echo "  ── クイックリファレンス ─────────────────────────────"
echo "  新規案件 : /client-onboarding"
echo "  見積作成 : /estimate"
echo "  デザイン : /design-system"
echo "  多言語   : /i18n-strategy"
echo "  ゲート   : /gate-check"
echo ""

# ── Log session start ─────────────────────────────────────────────────────
hook_log "session-start" "started" "branch=${BRANCH}"
