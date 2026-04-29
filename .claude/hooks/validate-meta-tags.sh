#!/usr/bin/env bash
# =============================================================================
# validate-meta-tags.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PostToolUse (matcher: Bash)
# Purpose: After git commit/push, verify that changed HTML/component files
#          contain required meta tags: <title>, description, og:title,
#          og:description, og:image
# Exit: Always 0 (non-blocking — warnings only)
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

# ── Parse hook input ──────────────────────────────────────────────────────
HOOK_JSON=$(hook_stdin)
TOOL_CMD=$(json_get "$HOOK_JSON" "tool_input.command")

# Early exit: only run after git commit or git push
if ! is_git_commit_cmd "${TOOL_CMD:-}"; then
  exit 0
fi

hook_log "validate-meta-tags" "triggered" "cmd=${TOOL_CMD:0:80}"

# ── Determine changed files ───────────────────────────────────────────────
# After a commit, check files changed in HEAD vs HEAD~1
# On first commit, fall back to files in HEAD
CHANGED_FILES=""
if git -C "$DPSAI_PROJECT_DIR" rev-parse HEAD~1 &>/dev/null; then
  CHANGED_FILES=$(git -C "$DPSAI_PROJECT_DIR" diff --name-only HEAD~1 HEAD 2>/dev/null || true)
else
  CHANGED_FILES=$(git -C "$DPSAI_PROJECT_DIR" show --name-only --format="" HEAD 2>/dev/null || true)
fi

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

# ── Filter to HTML/component files ───────────────────────────────────────
# Target: .html, .htm, .tsx, .jsx, .astro, .vue, .mdx
mapfile -t TARGET_FILES < <(echo "$CHANGED_FILES" \
  | grep -E '\.(html|htm|tsx|jsx|astro|vue|mdx)$' 2>/dev/null || true)

if [ "${#TARGET_FILES[@]}" -eq 0 ]; then
  exit 0
fi

ISSUES=()

# ── Check each file ───────────────────────────────────────────────────────
for rel in "${TARGET_FILES[@]}"; do
  fp="$DPSAI_PROJECT_DIR/$rel"
  [ -f "$fp" ] || continue

  # Skip test files and storybook files
  echo "$rel" | grep -qE "(\.test\.|\.spec\.|\.stories\.|__tests__)" && continue

  # Skip layout/template files where meta is intentionally partial
  echo "$rel" | grep -qiE "(layout|_app|_document|root)" && continue

  content=$(cat "$fp" 2>/dev/null || true)

  # 1. <title> tag
  if ! echo "$content" | grep -qiE "<title[^>]*>[^<]+</title>|useHead|<Head|Metadata|generateMetadata|title:"; then
    ISSUES+=("$rel: <title> が見つかりません")
  fi

  # 2. meta description
  if ! echo "$content" | grep -qiE "name=['\"]description['\"]|description:[[:space:]]*['\"]"; then
    ISSUES+=("$rel: meta description が見つかりません")
  fi

  # 3. og:title
  if ! echo "$content" | grep -qiE "property=['\"]og:title['\"]|og_title|openGraph.*title"; then
    ISSUES+=("$rel: og:title が見つかりません")
  fi

  # 4. og:description
  if ! echo "$content" | grep -qiE "property=['\"]og:description['\"]|og_description|openGraph.*description"; then
    ISSUES+=("$rel: og:description が見つかりません")
  fi

  # 5. og:image (warn only — may be set globally)
  if ! echo "$content" | grep -qiE "property=['\"]og:image['\"]|og_image|openGraph.*image"; then
    ISSUES+=("$rel: og:image が見つかりません（グローバル設定確認を）")
  fi
done

# ── Output ────────────────────────────────────────────────────────────────
if [ "${#ISSUES[@]}" -gt 0 ]; then
  echo "" >&2
  echo "  [validate-meta-tags] メタタグ未設定の警告:" >&2
  for issue in "${ISSUES[@]}"; do
    printf "    ⚠️  %s\n" "$issue" >&2
  done
  echo "" >&2
  echo "  参照: docs/geo-implementation-spec.md — メタタグ要件" >&2
  echo "" >&2
  hook_log "validate-meta-tags" "warn" "${#ISSUES[@]} issues in ${#TARGET_FILES[@]} files"
else
  hook_log "validate-meta-tags" "pass" "${#TARGET_FILES[@]} files checked"
fi

exit 0
