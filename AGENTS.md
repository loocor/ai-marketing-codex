# Repository Instructions

## Purpose

This repository is a Codex adaptation of
`zubair-trabzada/ai-marketing-claude`.

Treat it as:

- upstream AI Marketing Suite content
- plus a small Codex adapter layer

Do not expand the fork-specific surface unless the change is clearly required
for Codex installation, Codex plugin metadata, Codex skill triggering, Codex
subagent/tool wording, or `uv`-based Python execution.

## Branch Model

Read `GIT_SYNC.md` before any upstream sync, branch maintenance, rebase, or
release work.

Expected long-lived branches:

- `upstream-main`: mirror of upstream `zubair-trabzada/ai-marketing-claude:main`
- `codex`: Codex adaptation branch
- `main`: stable install branch, fast-forwarded from `codex`

Rules:

- Never develop on `upstream-main`.
- Never push to upstream.
- Do Codex adapter work on `codex`.
- Keep `main` install-ready and fast-forward it from `codex`.
- Prefer upstream content by default during conflicts.

## Codex Adapter Boundary

Keep fork-specific changes limited to:

- `.codex-plugin/plugin.json`
- `AGENTS.md`
- `GIT_SYNC.md`
- `skills/*/SKILL.md` YAML frontmatter
- `skills/market/SKILL.md`
- `skills/market/agents/openai.yaml`
- `install.sh`
- `uninstall.sh`
- README sections for Codex installation, invocation, and maintenance
- Minimal runtime wording replacements for Codex tools and `uv`

If a change touches marketing methodology, templates, scoring logic, or script
behavior, assume it belongs upstream unless the user explicitly asks for a
Codex-specific fork behavior.

## Tooling

- Use `uv` for Python dependency execution.
- Do not introduce `pip` or `pip3` instructions.
- The scripts are intentionally mostly stdlib; `reportlab` is only needed for
  PDF report generation.

## Verification

After adapter or sync changes, run:

```bash
uv run --with pyyaml python ~/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py .
env CODEX_HOME=/tmp/ai-marketing-codex-install-test ./install.sh
find /tmp/ai-marketing-codex-install-test/skills -maxdepth 2 -name SKILL.md | wc -l
```

Expected:

- Plugin validation passes.
- Install script installs 15 skills.
- The main `market` skill contains `agent-references/`, `scripts/`, and
  `templates/`.

## Commit Style

Use Conventional Commits, for example:

- `feat: adapt marketing suite for codex`
- `fix: support remote installer execution`
- `docs: document codex sync branch model`
