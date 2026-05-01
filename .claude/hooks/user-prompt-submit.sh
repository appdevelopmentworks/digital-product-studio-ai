#!/usr/bin/env bash
# =============================================================================
# user-prompt-submit.sh — AILEAP digital-product-studio-ai v0.3
# Hook: UserPromptSubmit (matcher: *)
# Purpose: Read each skill's `auto_trigger_keywords` (frontmatter) and surface
#   relevant skill suggestions when the user's prompt matches one or more
#   keywords. Pure suggestion — never blocks the prompt, never injects
#   commands. The user retains full control to invoke or ignore the hint.
#
# This resolves G-C1 (gap-analysis-v0.2.md §3.1):
#   "Skill auto-trigger guidance is too weak — Shin needs to remember skill
#    names. Add a keyword-detection layer to user-prompt-submit hook."
#
# Detection algorithm:
#   1. Collect all .claude/skills/*/SKILL.md files
#   2. Parse frontmatter `auto_trigger_keywords:` array (YAML list of strings)
#   3. Lowercase the user's prompt and each keyword
#   4. If any keyword is a substring of the lowercased prompt, suggest the skill
#   5. De-duplicate and rank by match count (descending)
#   6. Surface the top 5 suggestions to stderr (user-visible)
#
# Exit: 0 always (non-blocking)
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# Language: English (Layer 2 — AI-internal config). User-visible output is
#   Japanese (Layer 3) per docs/language-policy.md.
# =============================================================================

# shellcheck source=_lib.sh
source "$(dirname "$0")/_lib.sh"

# ── Read user prompt from hook stdin ──────────────────────────────────────
HOOK_JSON=$(hook_stdin)
USER_PROMPT=$(json_get "$HOOK_JSON" "prompt")

# Empty prompt or non-string — nothing to do
if [ -z "$USER_PROMPT" ] || [ "$USER_PROMPT" = "null" ]; then
  exit 0
fi

# Skip if user is invoking a slash command directly (already explicit)
case "$USER_PROMPT" in
  /*) exit 0 ;;
esac

SKILLS_DIR="$DPSAI_PROJECT_DIR/.claude/skills"
if [ ! -d "$SKILLS_DIR" ]; then
  hook_log "user-prompt-submit" "skip" "skills dir missing"
  exit 0
fi

# Lowercase the user prompt for case-insensitive matching
PROMPT_LOWER=$(printf '%s' "$USER_PROMPT" | tr '[:upper:]' '[:lower:]')

# ── Helper: extract `auto_trigger_keywords` array from a SKILL.md ─────────
# Returns one keyword per line (stripped of leading dash + spaces + quotes).
extract_keywords() {
  local skill_md="$1"
  awk '
    BEGIN { in_fm = 0; reading = 0 }
    /^---[[:space:]]*$/ {
      if (in_fm) { in_fm = 0; exit }
      in_fm = 1; next
    }
    !in_fm { next }
    /^auto_trigger_keywords:[[:space:]]*$/ { reading = 1; next }
    reading && /^[a-zA-Z_][a-zA-Z0-9_]*:/ { reading = 0 }
    reading && /^[[:space:]]*-[[:space:]]*/ {
      gsub(/^[[:space:]]*-[[:space:]]*/, "")
      gsub(/^"|"$/, "")
      gsub(/^'\''|'\''$/, "")
      print
    }
  ' "$skill_md" 2>/dev/null
}

# ── Match each skill ──────────────────────────────────────────────────────
# We accumulate (skill_name, hit_count) pairs in a single string, sorted later
SUGGESTIONS_RAW=""

for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$skill_md" ] || continue

  skill_name=$(basename "$(dirname "$skill_md")")

  hits=0
  while IFS= read -r kw; do
    [ -z "$kw" ] && continue
    kw_lower=$(printf '%s' "$kw" | tr '[:upper:]' '[:lower:]')
    # Use grep -F for fixed-string substring match (avoids regex surprises)
    if printf '%s' "$PROMPT_LOWER" | grep -qF -- "$kw_lower" 2>/dev/null; then
      hits=$((hits + 1))
    fi
  done < <(extract_keywords "$skill_md")

  if [ "$hits" -gt 0 ]; then
    SUGGESTIONS_RAW="${SUGGESTIONS_RAW}${hits}|${skill_name}"$'\n'
  fi
done

# No matches — silent exit
if [ -z "$SUGGESTIONS_RAW" ]; then
  hook_log "user-prompt-submit" "no-match" ""
  exit 0
fi

# ── Rank, deduplicate, and trim to top 5 ──────────────────────────────────
# Sort numerically descending by hit count, take top 5
TOP=$(printf '%s' "$SUGGESTIONS_RAW" | sort -t'|' -k1,1nr -k2,2 | head -5)
TOTAL=$(printf '%s' "$SUGGESTIONS_RAW" | grep -c . 2>/dev/null || echo 0)

# ── Surface to user (stderr — visible without polluting Claude's input) ──
echo "" >&2
echo "  💡 関連スキル候補(キーワード一致): /skill 名で起動できます" >&2
while IFS='|' read -r hit_count skill_name; do
  [ -z "$skill_name" ] && continue
  printf "     /%s    (%s 件一致)\n" "$skill_name" "$hit_count" >&2
done <<< "$TOP"
if [ "$TOTAL" -gt 5 ]; then
  printf "     ... ほか %s 件\n" "$((TOTAL - 5))" >&2
fi
echo "" >&2

hook_log "user-prompt-submit" "matched" "total=${TOTAL} top=$(printf '%s' "$TOP" | tr '\n' ',' | sed 's/,$//')"
exit 0
