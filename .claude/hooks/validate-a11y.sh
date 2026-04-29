#!/usr/bin/env bash
# =============================================================================
# validate-a11y.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PostToolUse (matcher: Bash)
# Purpose: After git commit/push, scan changed HTML/component files for
#          basic WCAG 2.2 AA issues detectable via static analysis:
#   - <img> without alt (1.1.1)
#   - <input> without associated <label> or aria-label (1.3.1, 4.1.2)
#   - <button> without text content or aria-label (4.1.2)
#   - Heading level skips e.g. h1 → h3 (1.3.1)
#   - Missing lang attribute on <html> (3.1.1)
#   - Links with non-descriptive text "こちら" / "click here" (2.4.4)
# Exit: Always 0 (non-blocking — warnings only)
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

# ── Parse hook input ──────────────────────────────────────────────────────
HOOK_JSON=$(hook_stdin)
TOOL_CMD=$(json_get "$HOOK_JSON" "tool_input.command")

# Early exit: only run after git commit or push
if ! is_git_commit_cmd "${TOOL_CMD:-}"; then
  exit 0
fi

hook_log "validate-a11y" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Determine changed files ───────────────────────────────────────────────
CHANGED_FILES=""
if git -C "$DPSAI_PROJECT_DIR" rev-parse HEAD~1 &>/dev/null; then
  CHANGED_FILES=$(git -C "$DPSAI_PROJECT_DIR" diff --name-only HEAD~1 HEAD 2>/dev/null || true)
else
  CHANGED_FILES=$(git -C "$DPSAI_PROJECT_DIR" show --name-only --format="" HEAD 2>/dev/null || true)
fi

[ -z "$CHANGED_FILES" ] && exit 0

# ── Filter to HTML/component files ───────────────────────────────────────
mapfile -t TARGET_FILES < <(echo "$CHANGED_FILES" \
  | grep -E '\.(html|htm|tsx|jsx|astro|vue|mdx)$' 2>/dev/null \
  | grep -v -E '(\.test\.|\.spec\.|\.stories\.|__tests__)' || true)

[ "${#TARGET_FILES[@]}" -eq 0 ] && exit 0

TOTAL_ISSUES=0
ISSUE_SUMMARY=()

# ── Per-file checks ───────────────────────────────────────────────────────
for rel in "${TARGET_FILES[@]}"; do
  fp="$DPSAI_PROJECT_DIR/$rel"
  [ -f "$fp" ] || continue

  FILE_ISSUES=()
  content=$(cat "$fp" 2>/dev/null || true)

  # 1. WCAG 1.1.1 — <img> without alt
  if echo "$content" | grep -qiE "<img[^>]+>" 2>/dev/null; then
    missing_alt=$(echo "$content" | grep -iE "<img[^>]+>" 2>/dev/null \
      | grep -v -iE "alt=" | wc -l | tr -d ' ')
    if [ "${missing_alt:-0}" -gt 0 ]; then
      FILE_ISSUES+=("WCAG 1.1.1: <img> に alt 属性なし (${missing_alt}箇所)")
    fi
  fi

  # 2. WCAG 4.1.2 — <input> without label or aria-label
  if echo "$content" | grep -qiE "<input[^>]+type=['\"]?(text|email|tel|password|search|url|number)" 2>/dev/null; then
    # Simple check: count inputs and labels — rough heuristic
    input_cnt=$(echo "$content" | grep -ciE "<input[^>]+(type=['\"]?(text|email|tel|password|search|url|number))" || echo 0)
    label_cnt=$(echo "$content" | grep -ciE "<label|aria-label=|aria-labelledby=|htmlFor=" || echo 0)
    if [ "${input_cnt:-0}" -gt "${label_cnt:-0}" ]; then
      FILE_ISSUES+=("WCAG 4.1.2: <input> 数($input_cnt)にラベル($label_cnt)が不足している可能性")
    fi
  fi

  # 3. WCAG 4.1.2 — <button> without text content or aria-label
  # Look for <button> or <button ...> with no text before </button>
  if echo "$content" | grep -qiE "<button[^>]*>[[:space:]]*</button>" 2>/dev/null; then
    empty_buttons=$(echo "$content" | grep -cE "<button[^>]*>[[:space:]]*</button>" || echo 0)
    if [ "${empty_buttons:-0}" -gt 0 ]; then
      FILE_ISSUES+=("WCAG 4.1.2: テキストなし <button> が ${empty_buttons}箇所 (aria-label 確認を)")
    fi
  fi

  # 4. WCAG 1.3.1 — Heading level skip (h1→h3 without h2)
  # Collect heading levels used in the file
  if echo "$content" | grep -qiE "<h[1-6]" 2>/dev/null; then
    H_LEVELS=$(echo "$content" | grep -ioE "<h[1-6]" | grep -oE "[1-6]" | sort -n | uniq | tr '\n' ',')
    # Check for skip: if h1 and h3 present but not h2
    if echo "$H_LEVELS" | grep -q "1" && echo "$H_LEVELS" | grep -q "3" \
       && ! echo "$H_LEVELS" | grep -q "2"; then
      FILE_ISSUES+=("WCAG 1.3.1: 見出しレベルのスキップを検出 (h1→h3, h2 なし)")
    fi
    if echo "$H_LEVELS" | grep -q "2" && echo "$H_LEVELS" | grep -q "4" \
       && ! echo "$H_LEVELS" | grep -q "3"; then
      FILE_ISSUES+=("WCAG 1.3.1: 見出しレベルのスキップを検出 (h2→h4, h3 なし)")
    fi
  fi

  # 5. WCAG 3.1.1 — <html> without lang attribute (only in .html files)
  case "$fp" in
    *.html|*.htm)
      if echo "$content" | grep -qiE "<html" 2>/dev/null; then
        if ! echo "$content" | grep -qiE "<html[^>]+lang="; then
          FILE_ISSUES+=("WCAG 3.1.1: <html> に lang 属性がありません")
        fi
      fi
      ;;
  esac

  # 6. WCAG 2.4.4 — Non-descriptive link text
  BAD_LINK_TEXTS="こちら|詳しくは|click here|here|more|read more|続きを読む"
  if echo "$content" | grep -qiE "<a[^>]*>($BAD_LINK_TEXTS)</a>" 2>/dev/null; then
    FILE_ISSUES+=("WCAG 2.4.4: リンクテキストが非説明的です（「こちら」「click here」等）")
  fi

  # Output issues for this file
  if [ "${#FILE_ISSUES[@]}" -gt 0 ]; then
    TOTAL_ISSUES=$((TOTAL_ISSUES + ${#FILE_ISSUES[@]}))
    ISSUE_SUMMARY+=("$rel")
    echo "" >&2
    printf "  [validate-a11y] %s:\n" "$rel" >&2
    for issue in "${FILE_ISSUES[@]}"; do
      printf "    ⚠️  %s\n" "$issue" >&2
    done
  fi
done

# ── Summary ───────────────────────────────────────────────────────────────
if [ "$TOTAL_ISSUES" -gt 0 ]; then
  echo "" >&2
  printf "  [validate-a11y] 合計 %d 件の a11y 警告 (%d ファイル)\n" \
    "$TOTAL_ISSUES" "${#ISSUE_SUMMARY[@]}" >&2
  echo "  参照: docs/requirements-v0.2.md Section 7 — WCAG 2.2 AA 要件" >&2
  echo "" >&2
  hook_log "validate-a11y" "warn" "${TOTAL_ISSUES} issues in ${#TARGET_FILES[@]} files"
else
  hook_log "validate-a11y" "pass" "${#TARGET_FILES[@]} files checked"
fi

exit 0
