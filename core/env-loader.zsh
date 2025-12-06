#!/bin/zsh

# ============================================
# Cargador de Variables de Entorno
# ============================================
# Este archivo carga las variables de entorno desde .env
# para hacerlas disponibles en los scripts de zsh-functions

# Detectar la ruta del directorio de zsh-functions
# Este script está en core/env-loader.zsh
# Obtenemos la ruta real de este archivo y subimos al directorio padre
typeset -g ZSH_FUNCTIONS_DIR="${${(%):-%x}:A:h:h}"

# Ruta al archivo .env
typeset -g ZSH_FUNCTIONS_ENV_FILE="${ZSH_FUNCTIONS_DIR}/.env"

# Cargar el archivo .env si existe
if [[ -f "$ZSH_FUNCTIONS_ENV_FILE" ]]; then
  # Cargar el archivo directamente con source
  # Las variables deben tener export en el archivo .env
  source "$ZSH_FUNCTIONS_ENV_FILE"
  
  typeset -g ZSH_FUNCTIONS_ENV_LOADED=true
else
  # No se pudo cargar el archivo .env
  typeset -g ZSH_FUNCTIONS_ENV_LOADED=false
  
  # Mostrar advertencia solo en sesiones interactivas
  if [[ -f "${ZSH_FUNCTIONS_DIR}/.env.example" ]] && [[ -o interactive ]]; then
    echo "⚠️  Advertencia: No se encontró el archivo de configuración .env"
    echo "   Crea uno desde el ejemplo: cp ${ZSH_FUNCTIONS_DIR}/.env.example ${ZSH_FUNCTIONS_ENV_FILE}"
  fi
fi
