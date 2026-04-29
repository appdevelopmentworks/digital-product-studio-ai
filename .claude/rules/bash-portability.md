---
description: All bash scripts (.claude/hooks/, project scripts) must run on Windows 11 + WSL2 + Git Bash (primary). Use node for JSON parsing (jq not guaranteed). Avoid Bash 5 features. Always chmod +x.
globs:
  - ".claude/hooks/**"
  - "projects/**/*.sh"
  - "scripts/**/*.sh"
alwaysApply: false
---

# Bash Portability — Windows + WSL2 + Git Bash

Reference: `docs/setup-requirements.md` (Q3 Windows primary)

## Shebang

Always use the env-resolved shebang:
```bash
#!/usr/bin/env bash   # ✅ Works on macOS (/usr/local/bin/bash), Linux, Git Bash
#!/bin/bash           # ❌ Fails on macOS Sonoma where bash is /usr/local/bin/bash
```

## Bash Version Constraint

Git Bash on Windows ships **Bash 4.x** (not Bash 5). Avoid:
- `${arr[@]@Q}` — Bash 5 quoting operators
- `declare -A` associative arrays with `-n` nameref — Bash 5 only  
- `@K` or `@V` array expansion operators
- `mapfile` is OK (Bash 4.0+); `readarray` is an alias for it

## Tool Availability — Always Check Before Use

Do NOT assume these tools are installed. Check first with `command -v`:

| Tool | Windows Git Bash | WSL2 | macOS |
|---|---|---|---|
| `jq` | ❌ not default | ✅ apt-installable | ✅ brew |
| `python3` | ❌ not default | ✅ available | ✅ available |
| `node` | ✅ via nvm/installer | ✅ | ✅ |
| `curl` | ✅ | ✅ | ✅ |
| `wget` | ❌ not default | ✅ | ❌ brew needed |
| `awk` | ✅ | ✅ | ✅ |
| `sed` | ✅ (GNU) | ✅ (GNU) | ⚠️ BSD sed |

**JSON parsing order of preference**: `node` → `jq` → `python3` → `grep` fallback.
Use `_lib.sh` `json_get()` function for all Claude hook JSON parsing.

## Path Handling

Use `$CLAUDE_PROJECT_DIR` for the project root — never hardcode paths:
```bash
# ✅ Correct
HOOKS_DIR="$CLAUDE_PROJECT_DIR/.claude/hooks"

# ❌ Wrong — hardcoded
HOOKS_DIR="/c/Users/hartm/Desktop/digital-product-studio-ai/.claude/hooks"
```

In Git Bash, Windows paths are automatically converted:
- `C:\Users\hartm\Desktop\project` → `/c/Users/hartm/Desktop/project`
- `$(pwd)` returns POSIX-style path

Use `$(dirname "$0")` to find the script's own directory (for sourcing `_lib.sh`).

## Error Handling

```bash
# ✅ Source _lib.sh to get shared helpers
source "$(dirname "$0")/_lib.sh"

# ✅ Graceful degradation — never abort on missing optional tool
if command -v jq &>/dev/null; then
  # use jq
else
  # fallback
fi

# ✅ || true prevents set -e from aborting on acceptable failures
BRANCH=$(git branch --show-current 2>/dev/null || true)
```

Avoid `set -e` (errexit) in hooks — it causes unexpected aborts when optional
commands fail (e.g., `git rev-parse HEAD~1` on a first commit).

## Stdin Handling for Hooks

Claude Code passes hook data as JSON on stdin. Always handle both piped and TTY:
```bash
if [ -t 0 ]; then
  HOOK_JSON="{}"   # Direct invocation (testing)
else
  HOOK_JSON=$(cat) # Piped from Claude Code
fi
```

## File Mode

All hook scripts must be executable:
```bash
chmod +x .claude/hooks/*.sh
```

Include this in project setup instructions.

## macOS `sed` Compatibility

macOS uses BSD `sed` (not GNU `sed`). Differences:
- In-place edit: `sed -i ''` (macOS) vs `sed -i` (Linux/Git Bash)
- Use `awk` for portable text transforms instead of `sed -i`
- Or detect OS: `if [[ "$OSTYPE" == "darwin"* ]]; then ...`

## Common Mistakes to Avoid

- ❌ `ls -la | head -5` — works, but use `find` for reliable file listing
- ❌ `$(cat file.json | jq ...)` — jq may not be installed
- ✅ `$(printf '%s' "$JSON" | node -e "...")`
- ❌ Assuming `/tmp` is writable on all Windows paths
- ✅ Use `$CLAUDE_PROJECT_DIR/.claude/state/` for temp files
- ❌ Hardcoded `\n` in echo — use `printf` for portability
- ✅ `printf '%s\n' "$var"` instead of `echo "$var"`
