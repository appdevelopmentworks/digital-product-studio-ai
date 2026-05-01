#!/usr/bin/env bash
# =============================================================================
# placeholder-detection.sh — AILEAP digital-product-studio-ai v0.3
# Hook: PreToolUse (matcher: Bash)
# Purpose: Before a deploy command, scan publish-target files in the active
#   project for unreplaced template placeholders matching `<<...>>`. Aborts
#   the deploy if any are found.
#
# Scan targets (relative to active project dir):
#   05-launch/**, 06-handoff/**           — final deliverables
#   src/**, app/**, pages/**              — site source
#   content/**, public/**                 — content + static
#
# Exclusions:
#   node_modules / .git / _archive / dist / build / .next / .vercel
#   docs/templates/**                     — template originals are exempt
#
# Detection regex: `<<[^<>\n]{1,80}>>`
#   Matches placeholders like `<<COMPANY_NAME>>`, `<<未確定>>`, `<<TBD>>`,
#   `<<EMAIL_ADDRESS>>`. Length capped at 80 chars to avoid false positives
#   on `<<` style markup that spans many lines.
#
# Override: set DPSAI_PLACEHOLDER_SKIP=1 to bypass (use with caution; logged).
#
# Exit: 0 = proceed | 2 = block deploy
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# This hook resolves G-C2 (gap-analysis-v0.2.md §3.1).
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

# Optional escape hatch (logged for audit)
if [ "${DPSAI_PLACEHOLDER_SKIP:-0}" = "1" ]; then
  hook_log "placeholder-detection" "skipped" "DPSAI_PLACEHOLDER_SKIP=1 set by user"
  echo "" >&2
  echo "  [placeholder-detection] ⚠️  DPSAI_PLACEHOLDER_SKIP=1 によりスキップしました" >&2
  echo "" >&2
  exit 0
fi

hook_log "placeholder-detection" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Find active project ───────────────────────────────────────────────────
ACTIVE_DIR=$(find_active_project)

if [ -z "$ACTIVE_DIR" ]; then
  hook_log "placeholder-detection" "skip" "no active project found"
  exit 0
fi

PID=$(basename "$ACTIVE_DIR")

# ── Build scan path list ──────────────────────────────────────────────────
# Only scan paths that exist under the active project
SCAN_PATHS=()
for sub in "05-launch" "06-handoff" "src" "app" "pages" "content" "public"; do
  candidate="$ACTIVE_DIR/$sub"
  [ -d "$candidate" ] && SCAN_PATHS+=("$candidate")
done

if [ "${#SCAN_PATHS[@]}" -eq 0 ]; then
  # Nothing publish-targetable under this project — skip
  hook_log "placeholder-detection" "skip" "no scan dirs in ${PID}"
  exit 0
fi

# ── Scan ──────────────────────────────────────────────────────────────────
# Use grep -rEn to recursively search with line numbers. Exclude paths via
# --exclude-dir and limit to text-likely extensions via --include.
INCLUDE_EXT=(
  "*.md" "*.mdx" "*.html" "*.htm"
  "*.yaml" "*.yml" "*.json"
  "*.tsx" "*.jsx" "*.ts" "*.js"
  "*.astro" "*.vue" "*.svelte"
  "*.css" "*.scss"
  "*.txt"
)

EXCLUDE_DIRS=(
  "node_modules" ".git" "_archive" "dist" "build"
  ".next" ".vercel" ".turbo" ".cache"
  "coverage"
)

# Build grep arguments
GREP_ARGS=("-rEn" "--color=never")
for ext in "${INCLUDE_EXT[@]}"; do
  GREP_ARGS+=("--include=$ext")
done
for d in "${EXCLUDE_DIRS[@]}"; do
  GREP_ARGS+=("--exclude-dir=$d")
done

# The detection regex — quote heavy because of the angle brackets
PATTERN='<<[^<>'$'\n'']{1,80}>>'

# Execute grep across scan paths; capture matches
MATCHES=$(grep "${GREP_ARGS[@]}" "$PATTERN" "${SCAN_PATHS[@]}" 2>/dev/null || true)

# ── Pass ──────────────────────────────────────────────────────────────────
if [ -z "$MATCHES" ]; then
  hook_log "placeholder-detection" "pass" "no placeholders found in ${PID}"
  exit 0
fi

# ── Fail — block deploy ───────────────────────────────────────────────────
# Count matches and unique files for the summary
MATCH_COUNT=$(printf '%s\n' "$MATCHES" | wc -l | tr -d ' ')
FILE_COUNT=$(printf '%s\n' "$MATCHES" | awk -F: '{print $1}' | sort -u | wc -l | tr -d ' ')

# Trim project-dir prefix from output paths for readability
PRETTY=$(printf '%s\n' "$MATCHES" | sed "s|^$DPSAI_PROJECT_DIR/||")

# Limit displayed matches to first 30 to keep output digestible
DISPLAY=$(printf '%s\n' "$PRETTY" | head -30)
TOTAL_LINES=$(printf '%s\n' "$PRETTY" | wc -l | tr -d ' ')

echo "" >&2
echo "================================================================" >&2
echo "  [placeholder-detection] ❌ 公開対象に未置換の placeholder があります" >&2
printf "  案件: %s\n" "$PID" >&2
printf "  検出: %s 件 (%s ファイル)\n" "$MATCH_COUNT" "$FILE_COUNT" >&2
echo "----------------------------------------------------------------" >&2
echo "$DISPLAY" | sed 's/^/  /' >&2
if [ "$TOTAL_LINES" -gt 30 ]; then
  printf "  ... ほか %s 行省略\n" "$((TOTAL_LINES - 30))" >&2
fi
echo "----------------------------------------------------------------" >&2
echo "  対応:" >&2
echo "    1. 各ファイルの <<...>> を実値に置換してください" >&2
echo "    2. 残置が意図的な場合は別ディレクトリ(_archive/ 等)に退避" >&2
echo "    3. 緊急デプロイが必要な場合のみ DPSAI_PLACEHOLDER_SKIP=1 を設定" >&2
echo "       (本番案件では非推奨。decisions.yaml に DEC エントリを追加して根拠を残す)" >&2
echo "  参照: /placeholder-check スキル / docs/gap-analysis-v0.2.md G-C2" >&2
echo "================================================================" >&2
echo "" >&2

hook_log "placeholder-detection" "blocked" "${MATCH_COUNT} placeholders in ${FILE_COUNT} files (${PID})"
exit 2
