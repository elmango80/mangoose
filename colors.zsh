#!/bin/zsh
# Color definitions - Basic ANSI
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bright/Intense colors
LIGHT_BLACK='\033[0;90m'      # Gris oscuro
LIGHT_RED='\033[0;91m'
LIGHT_GREEN='\033[0;92m'
LIGHT_YELLOW='\033[0;93m'
LIGHT_BLUE='\033[0;94m'
LIGHT_PURPLE='\033[0;95m'
LIGHT_CYAN='\033[0;96m'
LIGHT_WHITE='\033[0;97m'

# Color aliases for better readability
GRAY='\033[0;90m'             # Alias para LIGHT_BLACK (gris)
GREY='\033[0;90m'             # Alias para LIGHT_BLACK (gris)

# Bold colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Text styles
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
STRIKE_THROUGH='\033[9m'

# Reset
NC='\033[0m'
RESET='\033[0m'

# Extended colors (256-bit examples)
BLUE_DODGER='\033[38;5;33m'
CORAL='\033[38;5;203m'
GOLD='\033[38;5;220m'
LIME='\033[38;5;82m'
ORANGE='\033[38;5;208m'
PINK='\033[38;5;213m'
RED_BRIGHT='\033[38;5;196m'
SALMON='\033[38;5;209m'
TURQUOISE='\033[38;5;80m'
VIOLET='\033[38;5;93m'

# RGB True Color examples
RGB_CORAL='\033[38;2;255;127;80m'     # Coral
RGB_FOREST='\033[38;2;34;139;34m'     # Verde bosque
RGB_GOLD='\033[38;2;255;215;0m'       # Dorado
RGB_LAVENDER='\033[38;2;230;230;250m' # Lavanda
RGB_SKY='\033[38;2;135;206;235m'      # Azul cielo
RGB_SUNSET='\033[38;2;255;94;77m'     # Naranja atardecer

# Función de prueba de colores
function test_colors() {
  echo "=== Basic ANSI Colors ==="
  echo -e "${BLACK}Black${NC} ${RED}Red${NC} ${GREEN}Green${NC} ${YELLOW}Yellow${NC}"
  echo -e "${BLUE}Blue${NC} ${PURPLE}Purple${NC} ${CYAN}Cyan${NC} ${WHITE}White${NC}"
  
  echo -e "\n=== Bright/Intense Colors ==="
  echo -e "${LIGHT_BLACK}Light Black${NC} ${LIGHT_RED}Light Red${NC} ${LIGHT_GREEN}Light Green${NC} ${LIGHT_YELLOW}Light Yellow${NC}"
  echo -e "${LIGHT_BLUE}Light Blue${NC} ${LIGHT_PURPLE}Light Purple${NC} ${LIGHT_CYAN}Light Cyan${NC} ${LIGHT_WHITE}Light White${NC}"
  
  echo -e "\n=== Color Aliases ==="
  echo -e "${GRAY}Gray${NC} ${GREY}Grey${NC}"
  
  echo -e "\n=== Bold Colors ==="
  echo -e "${BOLD_BLACK}Bold Black${NC} ${BOLD_RED}Bold Red${NC} ${BOLD_GREEN}Bold Green${NC} ${BOLD_YELLOW}Bold Yellow${NC}"
  echo -e "${BOLD_BLUE}Bold Blue${NC} ${BOLD_PURPLE}Bold Purple${NC} ${BOLD_CYAN}Bold Cyan${NC} ${BOLD_WHITE}Bold White${NC}"
  
  echo -e "\n=== Text Styles ==="
  echo -e "${BOLD}Bold${NC} ${DIM}Dim${NC} ${ITALIC}Italic${NC} ${UNDERLINE}Underline${NC}"
  echo -e "${BLINK}Blink${NC} ${REVERSE}Reverse${NC} ${STRIKE_THROUGH}Strike Through${NC}"
  
  echo -e "\n=== Extended Colors (256-bit) ==="
  echo -e "${BLUE_DODGER}Blue Dodger${NC} ${CORAL}Coral${NC} ${GOLD}Gold${NC} ${LIME}Lime${NC} ${ORANGE}Orange${NC}"
  echo -e "${PINK}Pink${NC} ${RED_BRIGHT}Red Bright${NC} ${SALMON}Salmon${NC} ${TURQUOISE}Turquoise${NC} ${VIOLET}Violet${NC}"
  
  echo -e "\n=== RGB True Colors ==="
  echo -e "${RGB_CORAL}RGB Coral${NC} ${RGB_FOREST}RGB Forest${NC} ${RGB_GOLD}RGB Gold${NC}"
  echo -e "${RGB_LAVENDER}RGB Lavender${NC} ${RGB_SKY}RGB Sky${NC} ${RGB_SUNSET}RGB Sunset${NC}"
}
