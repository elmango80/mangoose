#!/usr/bin/env zsh
# Installer script for Zsh Functions Collection

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="${HOME}/.config/zsh/functions"
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
echo ""

# Check if already installed
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "${YELLOW}⚠ Zsh Functions already installed at:${NC}"
  echo "  $INSTALL_DIR"
  echo ""
  echo "Options:"
  echo "  1) Update (git pull)"
  echo "  2) Reinstall (remove and clone again)"
  echo "  3) Cancel"
  echo ""
  read "choice?Choose option [1-3]: "
  
  case $choice in
    1)
      echo "${BLUE}Updating...${NC}"
      cd "$INSTALL_DIR"
      git pull
      echo "${GREEN}✓ Updated successfully${NC}"
      ;;
    2)
      echo "${YELLOW}Backing up current installation...${NC}"
      mv "$INSTALL_DIR" "${INSTALL_DIR}${BACKUP_SUFFIX}"
      echo "${BLUE}Cloning repository...${NC}"
      git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
      echo "${GREEN}✓ Reinstalled successfully${NC}"
      ;;
    3)
      echo "Installation cancelled"
      exit 0
      ;;
    *)
      echo "${RED}Invalid option${NC}"
      exit 1
      ;;
  esac
else
  # Fresh installation
  echo "${BLUE}Installing to: ${NC}$INSTALL_DIR"
  
  # Create parent directory if needed
  mkdir -p "$(dirname "$INSTALL_DIR")"
  
  # Clone repository
  echo "${BLUE}Cloning repository...${NC}"
  git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
  echo "${GREEN}✓ Repository cloned${NC}"
fi

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}  Configuring .zshrc${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if already configured
if grep -q "zsh-functions" "$ZSHRC" 2>/dev/null; then
  echo "${YELLOW}⚠ .zshrc already configured${NC}"
  echo "  Skip configuration? [Y/n]: "
  read skip_config
  if [[ "$skip_config" =~ ^[Nn]$ ]]; then
    # Backup .zshrc
    echo "${YELLOW}Backing up .zshrc...${NC}"
    cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
    echo "${GREEN}✓ Backup created: ${ZSHRC}${BACKUP_SUFFIX}${NC}"
  else
    echo "${BLUE}Skipping .zshrc configuration${NC}"
    echo ""
    echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "${GREEN}  Installation Complete!${NC}"
    echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "To apply changes, run:"
    echo "  ${BLUE}source ~/.zshrc${NC}"
    exit 0
  fi
fi

# Backup .zshrc if not already done
if [ ! -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  if [ -f "$ZSHRC" ]; then
    echo "${YELLOW}Backing up .zshrc...${NC}"
    cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
    echo "${GREEN}✓ Backup created: ${ZSHRC}${BACKUP_SUFFIX}${NC}"
  fi
fi

# Add configuration to .zshrc
echo ""
echo "${BLUE}Adding configuration to .zshrc...${NC}"

cat >> "$ZSHRC" << 'EOF'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zsh Functions Collection
# https://github.com/elmango80/zsh-functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Load in dependency order
source ~/.config/zsh/functions/core/colors.zsh
source ~/.config/zsh/functions/core/utils.zsh
source ~/.config/zsh/functions/core/print.zsh
source ~/.config/zsh/functions/core/spinners.zsh
source ~/.config/zsh/functions/git/git.zsh
source ~/.config/zsh/functions/productivity/productivity.zsh
source ~/.config/zsh/functions/deployment/deploy.zsh
source ~/.config/zsh/functions/testing/wiremock.zsh
source ~/.config/zsh/functions/aliases/aliases.zsh

EOF

echo "${GREEN}✓ Configuration added to .zshrc${NC}"

echo ""
echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}  Installation Complete!${NC}"
echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo "  1. Reload your shell:"
echo "     ${BLUE}source ~/.zshrc${NC}"
echo ""
echo "  2. Try some commands:"
echo "     ${BLUE}phoenix --help${NC}"
echo "     ${BLUE}deploy --help${NC}"
echo "     ${BLUE}gcls --help${NC}"
echo ""
echo "Documentation:"
echo "  ${BLUE}cat ~/.config/zsh/functions/README.md${NC}"
echo ""
echo "If you backed up your .zshrc, you can restore it with:"
echo "  ${YELLOW}cp ${ZSHRC}${BACKUP_SUFFIX} ~/.zshrc${NC}"
echo ""
