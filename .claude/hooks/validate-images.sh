#!/usr/bin/env bash
# =============================================================================
# validate-images.sh — AILEAP digital-product-studio-ai v0.2
# Hook: PostToolUse (matcher: Write|Edit)
# Purpose: After Write or Edit on image files or component files, verify:
#   - Image files: are WebP or AVIF format (not JPEG/PNG in production paths)
#   - Component/HTML files: all <img> elements have non-empty alt attributes
# Exit: Always 0 (non-blocking — warnings only)
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

# ── Parse hook input ──────────────────────────────────────────────────────
HOOK_JSON=$(hook_stdin)
TOOL_NAME=$(json_get "$HOOK_JSON" "tool_name")
FILE_PATH=$(json_get "$HOOK_JSON" "tool_input.file_path")

# Only proceed for Write or Edit events with a file path
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# ── Normalize path ────────────────────────────────────────────────────────
# On Windows Git Bash, file paths may be Windows or POSIX — normalize to be safe
NORMALIZED_PATH="$FILE_PATH"

hook_log "validate-images" "triggered" "tool=${TOOL_NAME} file=${FILE_PATH##*/}"

# ── Check 1: Image file format (WebP / AVIF preferred) ───────────────────
case "${FILE_PATH,,}" in
  *.jpg|*.jpeg|*.png)
    # Only warn if file is in a production-path (public/, static/, assets/, src/)
    # Ignore: design source files, sketch files, reference images
    if echo "$FILE_PATH" | grep -qiE "/(public|static|assets|src|images|img)/"; then
      # Exception: logo.png, favicon.ico, og-image.png are acceptable
      BASENAME=$(basename "$FILE_PATH")
      if ! echo "$BASENAME" | grep -qiE "^(logo|favicon|og-image|apple-touch|thumbnail-default)"; then
        warn_output "validate-images" \
          "$(basename "$FILE_PATH"): JPEG/PNG を検出。WebP/AVIF への変換を検討してください（Lighthouse パフォーマンス向上）"
        echo "  参照: docs/requirements-v0.2.md Section 7 — 画像最適化要件" >&2
      fi
    fi
    ;;
  *.webp|*.avif|*.svg|*.gif|*.ico)
    # WebP/AVIF/SVG/GIF/ICO are all acceptable — no warning
    hook_log "validate-images" "pass-format" "$(basename "$FILE_PATH")"
    ;;
esac

# ── Check 2: Component/HTML files — <img> alt attribute ──────────────────
case "${FILE_PATH,,}" in
  *.tsx|*.jsx|*.html|*.htm|*.astro|*.vue|*.mdx)
    ;;
  *)
    # Not an HTML/component file — skip alt check
    exit 0
    ;;
esac

[ -f "$FILE_PATH" ] || exit 0

CONTENT=$(cat "$FILE_PATH" 2>/dev/null || true)
[ -z "$CONTENT" ] && exit 0

# Find <img tags missing alt or with empty alt
# Pattern 1: <img without any alt attribute
# Pattern 2: <img with alt="" or alt=''
IMG_ISSUES=()

# Use grep to find line numbers of problematic img tags
LINE_NUM=0
while IFS= read -r line; do
  LINE_NUM=$((LINE_NUM + 1))

  # Skip lines that are comments
  echo "$line" | grep -qE "<!--.*-->" && continue
  echo "$line" | grep -qE "{/\*.*\*/}" && continue

  # Check for <img without alt
  if echo "$line" | grep -qiE "<img[^>]+>" 2>/dev/null; then
    if ! echo "$line" | grep -qiE "alt="; then
      IMG_ISSUES+=("L${LINE_NUM}: <img> に alt 属性がありません")
    elif echo "$line" | grep -qiE 'alt=["\s]*["\s]|alt=\{["\s]*\}|alt=""'; then
      IMG_ISSUES+=("L${LINE_NUM}: <img> の alt が空文字です（装飾画像なら alt=\"\" は意図的か確認）")
    fi
  fi

  # Check for Next.js <Image without alt
  if echo "$line" | grep -qE "<Image[^>]+(/>|>)" 2>/dev/null; then
    if ! echo "$line" | grep -qiE "alt="; then
      IMG_ISSUES+=("L${LINE_NUM}: <Image> に alt 属性がありません（next/image）")
    fi
  fi
done < "$FILE_PATH"

if [ "${#IMG_ISSUES[@]}" -gt 0 ]; then
  echo "" >&2
  printf "  [validate-images] a11y 警告 — %s:\n" "$(basename "$FILE_PATH")" >&2
  for issue in "${IMG_ISSUES[@]}"; do
    printf "    ⚠️  %s\n" "$issue" >&2
  done
  echo "" >&2
  echo "  参照: WCAG 2.2 AA 1.1.1 — すべての非装飾画像に alt テキストが必要" >&2
  echo "" >&2
  hook_log "validate-images" "warn-alt" "${#IMG_ISSUES[@]} missing-alt in $(basename "$FILE_PATH")"
else
  hook_log "validate-images" "pass-alt" "$(basename "$FILE_PATH")"
fi

exit 0
