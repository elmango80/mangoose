#!/usr/bin/env zsh
# Script de instalación para Zsh Functions Collection

set -e

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin Color

# Obtener el directorio donde se encuentra este script
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"

# Directorio de instalación por defecto
DEFAULT_INSTALL_DIR="${HOME}/.config/zsh/functions"
ZSHRC="${HOME}/.zshrc"
BACKUP_SUFFIX=".zsh-functions-backup-$(date +%Y%m%d-%H%M%S)"

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}  Instalador de Zsh Functions Collection${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar si zsh está disponible
if ! command -v zsh &> /dev/null; then
  echo "${RED}✗ Error: Zsh no está instalado${NC}"
  echo "  Por favor instala Zsh primero"
  exit 1
fi

echo "${GREEN}✓${NC} Zsh encontrado: $(zsh --version)"

# Determinar el directorio de instalación
if [ -d "$SCRIPT_DIR/.git" ]; then
  # Ejecutándose desde el repositorio clonado
  INSTALL_DIR="$SCRIPT_DIR"
  echo "${BLUE}Ejecutando desde repositorio:${NC} $INSTALL_DIR"
else
  # Ejecutándose desde curl/wget (script descargado)
  INSTALL_DIR="$DEFAULT_INSTALL_DIR"
  
  # Verificar si ya está instalado
  if [ -d "$INSTALL_DIR/.git" ]; then
    echo "${YELLOW}⚠ Ya instalado en:${NC} $INSTALL_DIR"
    echo "Opciones:"
    echo "  1. Actualizar (git pull)"
    echo "  2. Reinstalar (respaldar y clonar de nuevo)"
    echo "  3. Cancelar"
    echo ""
    read "choice?Elige [1-3]: "
    
    case $choice in
      1)
        echo "${BLUE}Actualizando...${NC}"
        cd "$INSTALL_DIR"
        git pull
        echo "${GREEN}✓ Actualizado${NC}"
        ;;
      2)
        echo "${YELLOW}Respaldando...${NC}"
        mv "$INSTALL_DIR" "${INSTALL_DIR}${BACKUP_SUFFIX}"
        echo "${BLUE}Clonando...${NC}"
        git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
        echo "${GREEN}✓ Reinstalado${NC}"
        ;;
      3)
        echo "Cancelado"
        exit 0
        ;;
      *)
        echo "${RED}Opción inválida${NC}"
        exit 1
        ;;
    esac
  else
    # Instalación nueva
    echo "${BLUE}Instalando en:${NC} $INSTALL_DIR"
    mkdir -p "$(dirname "$INSTALL_DIR")"
    echo "${BLUE}Clonando repositorio...${NC}"
    git clone https://github.com/elmango80/zsh-functions.git "$INSTALL_DIR"
    echo "${GREEN}✓ Clonado${NC}"
  fi
fi

echo "${BLUE}Configurando archivo de entorno (.env)${NC}"

# Verificar si existe .env
if [ ! -f "$INSTALL_DIR/.env" ]; then
  if [ -f "$INSTALL_DIR/.env.example" ]; then
    echo "${YELLOW}Creando .env desde .env.example...${NC}"
    cp "$INSTALL_DIR/.env.example" "$INSTALL_DIR/.env"
    echo "${GREEN}✓ Archivo .env creado${NC}"
    echo ""
    echo "${YELLOW}⚠️  IMPORTANTE: Edita el archivo .env con tus valores reales:${NC}"
    echo "   ${BLUE}$INSTALL_DIR/.env${NC}"
    echo ""
  else
    echo "${YELLOW}⚠️  No se encontró .env.example${NC}"
  fi
else
  echo "${GREEN}✓ Archivo .env ya existe${NC}"
fi

echo ""
echo "${BLUE}Configurando .zshrc${NC}"

# Verificar si ya está configurado
if grep -q "zsh-functions" "$ZSHRC" 2>/dev/null; then
  echo "${YELLOW}⚠ .zshrc ya está configurado${NC}"
  echo "¿Saltar? [S/n]: "
  read skip_config
  if [[ "$skip_config" =~ ^[Nn]$ ]]; then
    echo "${YELLOW}Respaldando .zshrc...${NC}"
    cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
  else
    echo "${BLUE}Saltado${NC}"
    echo "${GREEN}✓ ¡Listo!${NC}"
    echo "${BLUE}Recargando .zshrc...${NC}"
    source "$ZSHRC"
    echo "${GREEN}✓ Recargado${NC}"
    exit 0
  fi
fi

# Respaldar .zshrc
if [ -f "$ZSHRC" ] && [ ! -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  echo "${YELLOW}Respaldando .zshrc...${NC}"
  cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
  echo "${GREEN}✓ Respaldado${NC}"
fi

# Agregar configuración
echo ""
echo "${BLUE}Agregando a .zshrc...${NC}"

cat >> "$ZSHRC" << EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zsh Functions Collection
# https://github.com/elmango80/zsh-functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Cargar en orden de dependencias
source ${INSTALL_DIR}/core/env-loader.zsh
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

echo "${GREEN}✓ Configurado${NC}"

echo ""
echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}  ¡Instalación Completa!${NC}"
echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "${BLUE}Recargando .zshrc...${NC}"
source "$ZSHRC"
echo "${GREEN}✓ Recargado${NC}"
echo ""
echo "Prueba algunos comandos:"
echo "  ${BLUE}phoenix --help${NC}"
echo "  ${BLUE}deploy --help${NC}"
echo ""
echo "Instalado en: ${BLUE}${INSTALL_DIR}${NC}"
echo ""
if [ -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  echo "Respaldo: ${YELLOW}${ZSHRC}${BACKUP_SUFFIX}${NC}"
  echo ""
fi
