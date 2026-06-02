---
name: market
description: Use when Codex needs to run marketing workflows such as website audits, quick marketing snapshots, copywriting, email sequences, social calendars, ad campaigns, funnel analysis, competitor intelligence, landing page CRO, launch plans, client proposals, SEO audits, brand voice guides, Markdown reports, or PDF marketing reports.
---

# AI Marketing Suite for Codex

This is the Codex adapter for the upstream AI Marketing Suite. Keep upstream
marketing guidance mostly unchanged; use this file as the Codex-native entry
point and routing layer.

## Codex Invocation

Users may ask in natural language instead of slash commands:

- `market audit <url>` or "audit this website"
- `market quick <url>`
- `market copy <url>`
- `market emails <topic/url>`
- `market social <topic/url>`
- `market ads <url>`
- `market funnel <url>`
- `market competitors <url>`
- `market landing <url>`
- `market launch <product>`
- `market proposal <client>`
- `market report <url>`
- `market report-pdf <url>`
- `market seo <url>`
- `market brand <url>`

Slash-style `/market ...` wording is still acceptable when a user writes it,
but Codex should treat it as a natural-language request, not as a shell command.

## Compatibility Rules

- Use Codex web, browser, shell, and file tools for page retrieval and search.
- Use Codex subagents for the five audit dimensions when subagent tools are
  available and current tool instructions allow delegation. Otherwise perform
  the same dimensions sequentially.
- Use `uv` for Python dependency execution or installation. Prefer
  `uv run --with reportlab ...` for PDF generation.
- Surface errors directly. Do not silently substitute fallback data.

## Routing

Load the corresponding upstream skill file when a workflow is requested:

| Workflow | Upstream file |
|---|---|
| Full audit | `../market-audit/SKILL.md` |
| Copy | `../market-copy/SKILL.md` |
| Emails | `../market-emails/SKILL.md` |
| Social calendar | `../market-social/SKILL.md` |
| Ads | `../market-ads/SKILL.md` |
| Funnel | `../market-funnel/SKILL.md` |
| Competitors | `../market-competitors/SKILL.md` |
| Landing CRO | `../market-landing/SKILL.md` |
| Launch | `../market-launch/SKILL.md` |
| Proposal | `../market-proposal/SKILL.md` |
| Markdown report | `../market-report/SKILL.md` |
| PDF report | `../market-report-pdf/SKILL.md` |
| SEO | `../market-seo/SKILL.md` |
| Brand voice | `../market-brand/SKILL.md` |

For full audit work, the five analysis references are in `agents/` when this
skill is installed by `install.sh`, and at repository root `agents/` when used
as a plugin from the source tree.

Scripts and templates are installed under this skill folder:

- `scripts/analyze_page.py`
- `scripts/competitor_scanner.py`
- `scripts/social_calendar.py`
- `scripts/generate_pdf_report.py`
- `templates/*.md`

When running from the source repository, the same resources also exist at the
repository root.
