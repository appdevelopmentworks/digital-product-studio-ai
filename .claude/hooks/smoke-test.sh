#!/usr/bin/env bash
# =============================================================================
# smoke-test.sh — AILEAP digital-product-studio-ai v0.3
# Validates that every hook script in .claude/hooks/ runs without crashing
# when invoked with empty stdin. NOT registered in settings.json — invoke
# manually as part of /setup-requirements §1.7 verification.
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# Language: English (Layer 2 — AI-internal config)
# =============================================================================

# Resolve hooks directory and source shared lib for log helper
DPSAI_HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_lib.sh
source "$DPSAI_HOOKS_DIR/_lib.sh"

# Skip these — not invokable by smoke test
SKIP_FILES=("_lib.sh" "smoke-test.sh")

# Exit codes considered acceptable when invoked with empty stdin:
#   0 — normal completion
#   2 — PreToolUse intentional block (e.g., legal-pages-check.sh blocks
#       deploy when no active project exists; this is correct behavior)
ACCEPTABLE_EXIT_CODES=(0 2)

# Color/format helpers (no-op outside TTY)
if [ -t 1 ]; then
  C_OK=$'\033[32m'
  C_WARN=$'\033[33m'
  C_ERR=$'\033[31m'
  C_DIM=$'\033[2m'
  C_BOLD=$'\033[1m'
  C_RST=$'\033[0m'
else
  C_OK=""; C_WARN=""; C_ERR=""; C_DIM=""; C_BOLD=""; C_RST=""
fi

is_acceptable_exit() {
  local code="$1"
  for ok in "${ACCEPTABLE_EXIT_CODES[@]}"; do
    [ "$code" = "$ok" ] && return 0
  done
  return 1
}

is_skipped() {
  local fname="$1"
  for skip in "${SKIP_FILES[@]}"; do
    [ "$fname" = "$skip" ] && return 0
  done
  return 1
}

main() {
  printf "\n%s================================================================%s\n" "$C_BOLD" "$C_RST"
  printf "  hook smoke-test  (v%s)\n" "$DPSAI_VERSION"
  printf "  hooks dir: %s%s%s\n" "$C_DIM" "$DPSAI_HOOKS_DIR" "$C_RST"
  printf "%s================================================================%s\n\n" "$C_BOLD" "$C_RST"

  local total=0 passed=0 failed=0
  local failures=()

  # Collect hook files (sorted)
  local hooks=()
  while IFS= read -r f; do
    hooks+=("$f")
  done < <(find "$DPSAI_HOOKS_DIR" -maxdepth 1 -type f -name "*.sh" 2>/dev/null | sort)

  if [ "${#hooks[@]}" -eq 0 ]; then
    printf "%s[error]%s no .sh files found under %s\n" "$C_ERR" "$C_RST" "$DPSAI_HOOKS_DIR"
    exit 1
  fi

  for hook_path in "${hooks[@]}"; do
    local fname
    fname="$(basename "$hook_path")"

    if is_skipped "$fname"; then
      printf "  %s[skip]%s %s %s(library / self)%s\n" "$C_DIM" "$C_RST" "$fname" "$C_DIM" "$C_RST"
      continue
    fi

    total=$((total + 1))

    # Verify executable bit (warn but proceed — bash will still run it)
    if [ ! -x "$hook_path" ]; then
      printf "  %s[warn]%s %s missing +x bit (run: chmod +x %s)\n" \
        "$C_WARN" "$C_RST" "$fname" ".claude/hooks/$fname"
    fi

    # Capture stdout+stderr; pass empty JSON to mimic real hook invocation
    local output exit_code
    output=$(printf '{}' | CLAUDE_PROJECT_DIR="$DPSAI_PROJECT_DIR" \
      bash "$hook_path" 2>&1)
    exit_code=$?

    if is_acceptable_exit "$exit_code"; then
      passed=$((passed + 1))
      if [ "$exit_code" = "2" ]; then
        printf "  %s[pass]%s %s %s(exit 2 = intentional block — OK)%s\n" \
          "$C_OK" "$C_RST" "$fname" "$C_DIM" "$C_RST"
      else
        printf "  %s[pass]%s %s\n" "$C_OK" "$C_RST" "$fname"
      fi
    else
      failed=$((failed + 1))
      failures+=("$fname (exit=$exit_code)")
      printf "  %s[fail]%s %s %s(exit %s)%s\n" \
        "$C_ERR" "$C_RST" "$fname" "$C_DIM" "$exit_code" "$C_RST"
      # Indent each failure line for readability
      printf "%s" "$output" | sed 's/^/        /' >&2
      printf "\n"
    fi
  done

  printf "\n%s----------------------------------------------------------------%s\n" "$C_BOLD" "$C_RST"
  printf "  total: %d   passed: %s%d%s   failed: %s%d%s\n" \
    "$total" "$C_OK" "$passed" "$C_RST" \
    "$([ "$failed" -gt 0 ] && printf '%s' "$C_ERR" || printf '%s' "$C_DIM")" \
    "$failed" "$C_RST"
  printf "%s================================================================%s\n\n" "$C_BOLD" "$C_RST"

  if [ "$failed" -gt 0 ]; then
    printf "%s失敗した hook:%s\n" "$C_ERR" "$C_RST"
    for f in "${failures[@]}"; do
      printf "  - %s\n" "$f"
    done
    printf "\n対応: setup-requirements.md §7.2 を参照してください\n\n"
    hook_log "smoke-test" "failed" "$failed/$total hooks failed"
    exit 1
  fi

  printf "全 %d hook が空入力で正常終了しました(意図的ブロック含む)\n\n" "$total"
  hook_log "smoke-test" "passed" "$passed/$total"
  exit 0
}

main "$@"
