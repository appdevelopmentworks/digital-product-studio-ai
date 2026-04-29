#!/usr/bin/env bash
# =============================================================================
# _lib.sh — AILEAP digital-product-studio-ai v0.2
# Shared helper library sourced by all .claude/hooks/*.sh scripts
# NOT a hook — do not reference in settings.json
# Platform: Windows 11 + WSL2 + Git Bash (primary), macOS/Linux (best-effort)
# Language: English (Layer 2 — AI-internal config)
# =============================================================================

# ── Runtime constants (override via env vars) ─────────────────────────────
DPSAI_VERSION="${CLAUDE_CODE_PROJECT_VERSION:-0.2}"
DPSAI_HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DPSAI_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$DPSAI_HOOKS_DIR/../.." && pwd)}"
DPSAI_STATE_DIR="$DPSAI_PROJECT_DIR/.claude/state"
DPSAI_PROJECTS_DIR="$DPSAI_PROJECT_DIR/projects"

# Lighthouse budget defaults (set in settings.json env block)
LH_PERF_MIN="${DPSAI_LIGHTHOUSE_PERFORMANCE_MIN:-90}"
LH_A11Y_MIN="${DPSAI_LIGHTHOUSE_ACCESSIBILITY_MIN:-95}"
LH_SEO_MIN="${DPSAI_LIGHTHOUSE_SEO_MIN:-100}"
LH_BP_MIN="${DPSAI_LIGHTHOUSE_BEST_PRACTICES_MIN:-90}"

# Deploy command detection pattern
DEPLOY_PATTERN="(vercel[[:space:]]|netlify[[:space:]]deploy|git[[:space:]]push[[:space:]]|pnpm[[:space:]]run[[:space:]]deploy|npm[[:space:]]run[[:space:]]deploy|gh[[:space:]]release[[:space:]]create)"

# ── JSON field extraction ─────────────────────────────────────────────────
# Usage: json_get "$json_string" "tool_input.command"
# Parser priority: node (always available in JS dev env) → jq → python3 → grep
json_get() {
  local json="$1"
  local dotpath="$2"

  # node — primary parser (reliable in npm/pnpm development environments)
  if command -v node &>/dev/null; then
    printf '%s' "$json" | node -e "
var d='';
process.stdin.on('data',function(c){d+=c});
process.stdin.on('end',function(){
  try{
    var v=JSON.parse(d);
    var parts='${dotpath}'.split('.');
    for(var i=0;i<parts.length;i++){
      if(v!==null&&v!==undefined&&typeof v==='object'){v=v[parts[i]];}
      else{v=undefined;break;}
    }
    if(v!==null&&v!==undefined)process.stdout.write(String(v));
  }catch(e){}
});
" 2>/dev/null
    return 0
  fi

  # jq — optional enhancement
  if command -v jq &>/dev/null; then
    printf '%s' "$json" | jq -r ".${dotpath} // empty" 2>/dev/null
    return 0
  fi

  # python3 fallback
  if command -v python3 &>/dev/null; then
    printf '%s' "$json" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for k in '${dotpath}'.split('.'):
        d = d.get(k) if isinstance(d, dict) else None
    sys.stdout.write(str(d) if d is not None else '')
except Exception:
    pass
" 2>/dev/null
    return 0
  fi

  # Grep fallback — shallow, single-level keys only (last resort)
  local key="${dotpath##*.}"
  printf '%s' "$json" | grep -o "\"${key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' 2>/dev/null || true
}

# ── Read hook stdin safely ────────────────────────────────────────────────
# Handles both piped input (hook invocation) and TTY (direct test invocation)
hook_stdin() {
  if [ -t 0 ]; then
    printf '{}'
  else
    cat
  fi
}

# ── Deploy command detection ──────────────────────────────────────────────
# Returns 0 if $1 looks like a deploy command, 1 otherwise
is_deploy_cmd() {
  local cmd="$1"
  echo "$cmd" | grep -qE "$DEPLOY_PATTERN" 2>/dev/null
}

# ── Git commit command detection ──────────────────────────────────────────
is_git_commit_cmd() {
  local cmd="$1"
  echo "$cmd" | grep -qE "^git[[:space:]]+(commit|push)" 2>/dev/null
}

# ── Find active project directory ─────────────────────────────────────────
# Prints the project path (e.g. projects/ABC-001) or nothing if not found
find_active_project() {
  [ -d "$DPSAI_PROJECTS_DIR" ] || return 0

  # 1. Explicit env var override
  if [ -n "${DPSAI_ACTIVE_PROJECT:-}" ]; then
    local cand="$DPSAI_PROJECTS_DIR/$DPSAI_ACTIVE_PROJECT"
    [ -d "$cand" ] && echo "$cand" && return 0
  fi

  # 2. PROJECT.md with status: active
  local active_file
  active_file=$(find "$DPSAI_PROJECTS_DIR" -maxdepth 2 -name "PROJECT.md" \
    -exec grep -l "^status:[[:space:]]*active" {} \; 2>/dev/null | head -1)
  if [ -n "$active_file" ]; then
    dirname "$active_file"
    return 0
  fi

  # 3. Most recently modified PROJECT.md (fallback)
  local latest
  latest=$(find "$DPSAI_PROJECTS_DIR" -maxdepth 2 -name "PROJECT.md" \
    -printf '%T@ %p\n' 2>/dev/null \
    | sort -rn | head -1 | awk '{print $2}')
  if [ -n "$latest" ]; then
    dirname "$latest"
    return 0
  fi
}

# ── Structured hook log ───────────────────────────────────────────────────
# Usage: hook_log "hook-name" "event" "detail message"
hook_log() {
  local hook_name="$1"
  local event="$2"
  local detail="${3:-}"
  local ts
  ts=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo "1970-01-01T00:00:00Z")

  mkdir -p "$DPSAI_STATE_DIR" 2>/dev/null || true
  # Sanitize detail for JSON (replace double quotes with single)
  local safe_detail="${detail//\"/\'}"
  printf '{"ts":"%s","hook":"%s","event":"%s","detail":"%s"}\n' \
    "$ts" "$hook_name" "$event" "$safe_detail" \
    >> "$DPSAI_STATE_DIR/hooks.jsonl" 2>/dev/null || true
}

# ── Deploy block output (PreToolUse exit 2) ───────────────────────────────
# Usage: block_with_message "hook-name" "Japanese reason message"
block_with_message() {
  local hook_name="$1"
  local reason="$2"

  echo "" >&2
  echo "================================================================" >&2
  printf "  BLOCKED by %s\n" "$hook_name" >&2
  echo "----------------------------------------------------------------" >&2
  echo "  $reason" >&2
  echo "================================================================" >&2
  echo "" >&2

  hook_log "$hook_name" "blocked" "$reason"
  exit 2
}

# ── Warning output (PostToolUse — non-blocking) ───────────────────────────
# Usage: warn_output "hook-name" "message"
warn_output() {
  local hook_name="$1"
  local msg="$2"
  echo "" >&2
  printf "  [%s] WARN: %s\n" "$hook_name" "$msg" >&2
  hook_log "$hook_name" "warn" "$msg"
}
