#!/usr/bin/env zsh
# Installer script for Zsh Functions Collection

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"

# Default installation directory
DEFAULT_INSTALL_DIR="${HOME}/.config/zsh/functions"
ZSHRC="${HOME}/.zshrc"
BACKUP_SUFFIX=".zsh-functions-backup-$(date +%Y%m%d-%H%M%S)"

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}  Zsh Functions Collection Installer${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if zsh is available
if ! command -v zsh &> /dev/null; then
  echo "${RED}✗ Error: Zsh is not installed${NC}"
  echo "  Please install Zsh first"
  exit 1
fi

echo "${GREEN}✓${NC} Zsh found: $(zsh --version)"

# Determine installation directory
if [ -d "$SCRIPT_DIR/.git" ]; then
  # Running from cloned repository
  INSTALL_DIR="$SCRIPT_DIR"
  echo "${BLUE}Running from repository:${NC} $INSTALL_DIR"
else
  # Running from curl/wget (downloaded script)
  INSTALL_DIR="$DEFAULT_INSTALL_DIR"
  
  # Check if already installed
  if [ -d "$INSTALL_DIR/.git" ]; then
    echo "${YELLOW}⚠ Already installed at:${NC} $INSTALL_DIR"
    echo "Options:"
    echo "  1. Update (git pull)"
    echo "  2. Reinstall (backup and clone again)"
    echo "  3. Cancel"
    echo ""
    read "choice?Choose [1-3]: "
    
    case $choice in
      1)
        echo "${BLUE}Updating...${NC}"
        cd "$INSTALL_DIR"
        git pull
        echo "${GREEN}✓ Updated${NC}"
        ;;
      2)
        echo "${YELLOW}Backing up...${NC}"
        mv "$INSTALL_DIR" "${INSTALL_DIR}${BACKUP_SUFFIX}"
        echo "${BLUE}Cloning...${NC}"
        git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
        echo "${GREEN}✓ Reinstalled${NC}"
        ;;
      3)
        echo "Cancelled"
        exit 0
        ;;
      *)
        echo "${RED}Invalid option${NC}"
        exit 1
        ;;
    esac
  else
    # Fresh installation
    echo "${BLUE}Installing to:${NC} $INSTALL_DIR"
    mkdir -p "$(dirname "$INSTALL_DIR")"
    echo "${BLUE}Cloning repository...${NC}"
    git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
    echo "${GREEN}✓ Cloned${NC}"
  fi
fi

echo "${BLUE}Configuring .zshrc${NC}"

# Check if already configured
if grep -q "zsh-functions" "$ZSHRC" 2>/dev/null; then
  echo "${YELLOW}⚠ .zshrc already configured${NC}"
  echo "Skip? [Y/n]: "
  read skip_config
  if [[ "$skip_config" =~ ^[Nn]$ ]]; then
    echo "${YELLOW}Backing up .zshrc...${NC}"
    cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
  else
    echo "${BLUE}Skipped${NC}"
    echo "${GREEN}✓ Done!${NC}"
    echo "${BLUE}Reloading .zshrc...${NC}"
    source "$ZSHRC"
    echo "${GREEN}✓ Reloaded${NC}"
    exit 0
  fi
fi

# Backup .zshrc
if [ -f "$ZSHRC" ] && [ ! -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  echo "${YELLOW}Backing up .zshrc...${NC}"
  cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
  echo "${GREEN}✓ Backed up${NC}"
fi

# Add configuration
echo ""
echo "${BLUE}Adding to .zshrc...${NC}"

cat >> "$ZSHRC" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zsh Functions Collection
# https://github.com/elmango80/zsh-functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Load in dependency order
source ${INSTALL_DIR}/core/colors.zsh
source ${INSTALL_DIR}/core/utils.zsh
source ${INSTALL_DIR}/core/print.zsh
source ${INSTALL_DIR}/core/spinners.zsh
source ${INSTALL_DIR}/git/git.zsh
source ${INSTALL_DIR}/productivity/productivity.zsh
source ${INSTALL_DIR}/deployment/deploy.zsh
source ${INSTALL_DIR}/testing/wiremock.zsh
source ${INSTALL_DIR}/aliases/aliases.zsh

EOF

echo "${GREEN}✓ Configured${NC}"
echo "${BLUE}Reloading .zshrc...${NC}"
source "$ZSHRC"
echo "${GREEN}✓ Reloaded${NC}"
echo ""
echo "Try some commands:"
echo "  ${BLUE}phoenix --help${NC}"
echo "  ${BLUE}deploy --help${NC}"
echo ""
echo "Installed at: ${BLUE}${INSTALL_DIR}${NC}"
if [ -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  echo "Backup: ${YELLOW}${ZSHRC}${BACKUP_SUFFIX}${NC}"
fi
