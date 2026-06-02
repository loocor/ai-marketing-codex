#!/bin/bash
# AI Marketing Suite — Codex Skills Installer
# Installs marketing skills, agent references, scripts, and templates into Codex.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║    AI Marketing Suite — Codex Skills         ║${NC}"
echo -e "${CYAN}║    15 Skills · 5 Agent Refs · 4 Scripts      ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

if [ -n "$BASH_SOURCE" ] && [ "$BASH_SOURCE" != "bash" ] && [ -f "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
else
    SCRIPT_DIR=""
fi

if [ -z "$SCRIPT_DIR" ] || [ ! -f "$SCRIPT_DIR/skills/market/SKILL.md" ]; then
    echo -e "${YELLOW}Running remote install — cloning repository...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/loocor/ai-marketing-codex.git "$TEMP_DIR/ai-marketing-codex" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to clone repository.${NC}"
        exit 1
    fi
    SCRIPT_DIR="$TEMP_DIR/ai-marketing-codex"
fi

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
UV_CACHE_DIR="${UV_CACHE_DIR:-${TMPDIR:-/tmp}/uv-cache}"
export UV_CACHE_DIR

echo -e "${BLUE}Source:${NC}  $SCRIPT_DIR"
echo -e "${BLUE}Target:${NC}  $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

install_skill_dir() {
    local source_dir="$1"
    local target_name="$2"
    local target_dir="$SKILLS_DIR/$target_name"

    if [ ! -f "$source_dir/SKILL.md" ]; then
        echo -e "  ${YELLOW}⚠${NC} $target_name (missing SKILL.md, skipping)"
        return
    fi

    rm -rf "$target_dir"
    mkdir -p "$target_dir"
    cp "$source_dir/SKILL.md" "$target_dir/SKILL.md"
    echo -e "  ${GREEN}✓${NC} $target_name"
}

echo -e "${BLUE}Installing main Codex skill...${NC}"
rm -rf "$SKILLS_DIR/market"
mkdir -p "$SKILLS_DIR/market"
cp "$SCRIPT_DIR/skills/market/SKILL.md" "$SKILLS_DIR/market/SKILL.md"

if [ -d "$SCRIPT_DIR/skills/market/agents" ]; then
    cp -R "$SCRIPT_DIR/skills/market/agents" "$SKILLS_DIR/market/agents"
fi
if [ -d "$SCRIPT_DIR/agents" ]; then
    cp -R "$SCRIPT_DIR/agents" "$SKILLS_DIR/market/agent-references"
fi
if [ -d "$SCRIPT_DIR/scripts" ]; then
    cp -R "$SCRIPT_DIR/scripts" "$SKILLS_DIR/market/scripts"
    chmod +x "$SKILLS_DIR/market/scripts"/*.py 2>/dev/null || true
fi
if [ -d "$SCRIPT_DIR/templates" ]; then
    cp -R "$SCRIPT_DIR/templates" "$SKILLS_DIR/market/templates"
fi
echo -e "  ${GREEN}✓${NC} market"

echo -e "\n${BLUE}Installing workflow skills...${NC}"
SKILLS=(
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
    install_skill_dir "$SCRIPT_DIR/skills/$skill" "$skill"
done

echo -e "\n${BLUE}Checking Python tooling...${NC}"
if command -v uv &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} uv detected"
    echo -e "    PDF reports can run with: ${CYAN}uv run --with reportlab python <script>${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} uv not found (needed for PDF dependency execution)"
    echo -e "    Install uv: ${CYAN}https://docs.astral.sh/uv/getting-started/installation/${NC}"
fi

if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Installation Complete!             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Available workflows:${NC}"
echo "  market audit <url>        Full marketing audit"
echo "  market quick <url>        60-second marketing snapshot"
echo "  market copy <url>         Generate optimized copy"
echo "  market emails <topic>     Generate email sequences"
echo "  market social <topic>     Social media content calendar"
echo "  market ads <url>          Ad creative and copy"
echo "  market funnel <url>       Sales funnel analysis"
echo "  market competitors <url>  Competitive intelligence"
echo "  market landing <url>      Landing page CRO"
echo "  market launch <product>   Client launch playbook"
echo "  market proposal <client>  Client proposal generator"
echo "  market report <url>       Marketing report (Markdown)"
echo "  market report-pdf <url>   Marketing report (PDF)"
echo "  market seo <url>          SEO content audit"
echo "  market brand <url>        Brand voice analysis"
echo ""
echo -e "  ${YELLOW}Restart Codex to pick up new skills.${NC}"
echo ""
