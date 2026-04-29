---
description: All AI-internal configuration files (.claude/agents/, .claude/hooks/, .claude/skills/, .claude/rules/) must be written in English (Language Policy Layer 2).
globs:
  - ".claude/agents/**"
  - ".claude/hooks/**"
  - ".claude/skills/**"
  - ".claude/rules/**"
  - ".claude/settings.json"
alwaysApply: false
---

# Language Policy — Layer 2: English (AI-Internal Config)

Reference: `docs/language-policy.md`

## Scope

All agent definitions, hook scripts, skill definitions, and rule files are
**English-primary** (Layer 2). This config layer is consumed by Claude Code
and other AI agents — not by end clients.

## Requirements

### Agent files (.claude/agents/*.md)
- All prose in English
- `description:` frontmatter: English
- `## Responsibilities`, `## Domain Boundaries`, etc.: English prose
- `## Output Language Policy` section: English instructions about when to output
  Japanese vs English
- **Exception**: `## Example Output` sub-sections may show Japanese content to
  demonstrate what the agent will produce for clients

### Skill files (.claude/skills/*/SKILL.md)
- All structural sections in English (Purpose, When to Use, Process, Boundary Notes)
- `## Example Output` section content in Japanese (demonstrates client deliverable)
- YAML examples inside skills: follow same rule as agent files

### Hook scripts (.claude/hooks/*.sh)
- Code comments: English
- `echo` statements visible to Shin (user-facing): Japanese
  (e.g., `echo "  セッション開始: $DATE"`)
- Log entries to hooks.jsonl: English (machine-readable)

### Rule files (.claude/rules/*.md)
- All content in English (rules guide Claude's own behavior)

### settings.json
- All `_comment*` fields: English
- Hook command strings: English (shell syntax)

## Common Mistakes to Avoid

- ❌ Writing agent description in Japanese (`description: クライアント向け成果物...`)
- ✅ English description (`description: Owns client deliverable production...`)
- ❌ Mixing Japanese prose into rule bodies
- ✅ Japanese only in `## Example Output` sections of skills/agents
