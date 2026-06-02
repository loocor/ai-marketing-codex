# Git Sync Guide

This file is the source of truth for keeping this fork close to the upstream
AI Marketing Suite while preserving the Codex adaptation layer.

## Branch Model

- `upstream/main`
  Official upstream source of truth:
  `zubair-trabzada/ai-marketing-claude`
- `origin/upstream-main`
  Published mirror branch for upstream content. Do not develop here.
- local `upstream-main`
  Local mirror that tracks `upstream/main`.
- `origin/codex`
  Long-lived Codex adaptation branch.
- `origin/main`
  Published stable branch. Keep it fast-forwarded from `codex`.

Rules:

- Never develop on `upstream-main`.
- Never push to `upstream`.
- Keep Codex-specific work on `codex`.
- Keep `main` as the install-ready published branch.
- Prefer upstream content by default during conflicts.
- Reapply the smallest Codex adapter patch needed after upstream changes.

## Expected Local Git Config

Check with:

```bash
git branch -vv
git remote -v
git config --get-regexp '^(remote\.pushDefault|branch\.(main|codex|upstream-main)\.(pushRemote|remote|merge)|push\.default|rerere\.enabled)$'
```

Expected intent:

- `main -> origin/main`
- `codex -> origin/codex`
- `upstream-main -> upstream/main`
- `remote.pushDefault = origin`
- `push.default = simple`
- `rerere.enabled = true`

## Standard Sync Flow

Save current work first. Do not sync with uncommitted changes:

```bash
git status --short
```

Refresh the upstream mirror:

```bash
git fetch upstream
git switch upstream-main
git merge --ff-only upstream/main
git push origin upstream-main
```

Move the Codex adaptation branch onto the latest upstream:

```bash
git switch codex
git rebase upstream-main
```

Resolve conflicts with this policy:

- Prefer upstream marketing content, scoring methodology, templates, and script
  behavior by default.
- Preserve Codex plugin metadata and installability.
- Preserve `uv` dependency instructions.
- Preserve Codex subagent/tool wording where upstream references runtime-specific
  Claude Code tools.
- Keep changes minimal and easy to diff against upstream.

Continue the rebase:

```bash
git add <resolved-files>
git rebase --continue
```

Publish the updated Codex branch:

```bash
git push origin codex --force-with-lease
```

Publish the stable install branch:

```bash
git switch main
git merge --ff-only codex
git push origin main
```

## Codex Delta Boundary

Keep fork-specific changes limited to:

- `.codex-plugin/plugin.json`
- `GIT_SYNC.md`
- `skills/*/SKILL.md` YAML frontmatter
- `skills/market/SKILL.md`
- `skills/market/agents/openai.yaml`
- `install.sh`
- `uninstall.sh`
- README sections that describe Codex installation and invocation
- Minimal runtime wording replacements:
  - Claude Code -> Codex
  - Claude-specific fetch/search tools -> Codex web/browser/search tools
  - pip instructions -> uv instructions

If this list grows, stop and reconsider whether the change belongs in the Codex
adapter or should be proposed upstream.

## Verification After Sync

Run:

```bash
uv run --with pyyaml python ~/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py .
env CODEX_HOME=/tmp/ai-marketing-codex-install-test ./install.sh
```

Then confirm:

```bash
find /tmp/ai-marketing-codex-install-test/skills -maxdepth 2 -name SKILL.md | wc -l
find /tmp/ai-marketing-codex-install-test/skills/market -maxdepth 2 -type f | sort
```

Expected:

- Plugin validation passes.
- Install script installs 15 skills.
- The main `market` skill includes `agent-references/`, `scripts/`, and
  `templates/`.

## Common Pitfall

Do not rebase `codex` onto `origin/main` or `origin/codex` when syncing
upstream. That only restacks the adaptation branch on top of the fork's previous
state.

Correct base:

```bash
git fetch upstream
git rebase upstream/main
```

or:

```bash
git switch upstream-main
git merge --ff-only upstream/main
git switch codex
git rebase upstream-main
```
