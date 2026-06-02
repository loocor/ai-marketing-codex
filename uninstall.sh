#!/bin/bash
# AI Marketing Suite — Codex Uninstaller
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}Uninstalling AI Marketing Suite for Codex...${NC}"
echo ""

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"

SKILLS=(
    "market"
    "market-audit"
    "market-copy"
    "market-emails"
    "market-social"
    "market-ads"
    "market-funnel"
    "market-competitors"
    "market-landing"
    "market-launch"
    "market-proposal"
    "market-report"
    "market-report-pdf"
    "market-seo"
    "market-brand"
)

for skill in "${SKILLS[@]}"; do
    if [ -d "$SKILLS_DIR/$skill" ]; then
        rm -rf "$SKILLS_DIR/$skill"
        echo -e "  ${GREEN}✓${NC} Removed skill: $skill"
    fi
done

echo ""
echo -e "${GREEN}AI Marketing Suite for Codex uninstalled.${NC}"
echo ""
