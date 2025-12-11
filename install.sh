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

ZSHRC="${HOME}/.zshrc"
BACKUP_SUFFIX=".mangoose-backup-$(date +%Y%m%d-%H%M%S)"
CLONE_DIR="${HOME}/.config/zsh/mangoose"

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}  Instalador de Mangoose${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar si zsh está disponible
if ! command -v zsh &> /dev/null; then
  echo "${RED}✗ Error: Zsh no está instalado${NC}"
  echo "  Por favor instala Zsh primero"
  exit 1
fi

echo "${GREEN}✓${NC} Zsh encontrado: $(zsh --version)"

# Determinar el directorio de instalación
if [ -d "$SCRIPT_DIR/core" ] && [ -d "$SCRIPT_DIR/git" ]; then
  # Ejecutándose desde el repositorio clonado localmente
  INSTALL_DIR="$SCRIPT_DIR"
  echo "${BLUE}Usando repositorio local:${NC} $INSTALL_DIR"
else
  # Script ejecutado remotamente (curl | zsh)
  # Necesitamos clonar el repositorio primero
  
  if [ -d "$CLONE_DIR/.git" ]; then
    echo "${YELLOW}⚠ Repositorio ya existe en:${NC} $CLONE_DIR"
    echo "¿Deseas actualizarlo? [S/n]: "
    read update_repo
    if [[ ! "$update_repo" =~ ^[Nn]$ ]]; then
      echo "${BLUE}Actualizando repositorio...${NC}"
      cd "$CLONE_DIR"
      git pull
      echo "${GREEN}✓ Actualizado${NC}"
    fi
  else
    echo "${BLUE}Clonando repositorio en:${NC} $CLONE_DIR"
    mkdir -p "$(dirname "$CLONE_DIR")"
    git clone https://github.com/elmango80/mangoose.git "$CLONE_DIR"
    echo "${GREEN}✓ Repositorio clonado${NC}"
  fi
  
  # Ahora ejecutar el script de instalación desde el repositorio clonado
  echo ""
  echo "${BLUE}Ejecutando instalación desde el repositorio...${NC}"
  exec "$CLONE_DIR/install.sh"
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
if grep -q "mangoose" "$ZSHRC" 2>/dev/null; then
  echo "${YELLOW}⚠ .zshrc ya está configurado${NC}"
  echo "¿Saltar? [S/n]: "
  read skip_config
  if [[ "$skip_config" =~ ^[Nn]$ ]]; then
    echo "${YELLOW}Respaldando .zshrc...${NC}"
    cp "$ZSHRC" "${ZSHRC}${BACKUP_SUFFIX}"
  else
    echo "${BLUE}Saltado${NC}"
    echo "${GREEN}✓ ¡Listo!${NC}"
    echo ""
    echo "${YELLOW}⚠️  Recuerda recargar tu shell:${NC}"
    echo "   ${BLUE}source ~/.zshrc${NC}"
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
# https://github.com/elmango80/mangoose
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
echo "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "   1. Edita el archivo .env con tus valores reales:"
echo "      ${BLUE}${INSTALL_DIR}/.env${NC}"
echo ""
echo "   2. Recarga tu shell para aplicar los cambios:"
echo "      ${BLUE}source ~/.zshrc${NC}"
echo "      o abre una nueva terminal"
echo ""
echo "Instalado en: ${BLUE}${INSTALL_DIR}${NC}"
echo ""
if [ -f "${ZSHRC}${BACKUP_SUFFIX}" ]; then
  echo "Respaldo: ${YELLOW}${ZSHRC}${BACKUP_SUFFIX}${NC}"
  echo ""
fi
echo "Prueba algunos comandos después de recargar:"
echo "  ${BLUE}deploy --help${NC}"
echo "  ${BLUE}cdw${NC}  # ir al directorio de trabajo"
echo ""
