#!/bin/zsh

# ============================================
# Cargador de Variables de Entorno
# ============================================
# Este archivo carga las variables de entorno desde .env
# para hacerlas disponibles en los scripts de zsh-functions

# Detectar la ruta del directorio de zsh-functions
typeset -g ZSH_FUNCTIONS_DIR="${0:A:h}"

# Ruta al archivo .env
typeset -g ZSH_FUNCTIONS_ENV_FILE="${ZSH_FUNCTIONS_DIR}/.env"

# Función para cargar variables de entorno desde .env
_load_env_file() {
  local env_file="$1"
  
  # Verificar si el archivo existe
  if [[ ! -f "$env_file" ]]; then
    return 1
  fi
  
  # Leer y exportar variables
  while IFS='=' read -r key value; do
    # Ignorar líneas vacías y comentarios
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
    
    # Eliminar espacios al inicio y final
    key="${key##*( )}"
    key="${key%%*( )}"
    value="${value##*( )}"
    value="${value%%*( )}"
    
    # Eliminar comillas del valor si existen
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    
    # Exportar la variable
    export "$key=$value"
  done < "$env_file"
  
  return 0
}

# Intentar cargar el archivo .env
if _load_env_file "$ZSH_FUNCTIONS_ENV_FILE"; then
  # Variables cargadas exitosamente
  typeset -g ZSH_FUNCTIONS_ENV_LOADED=true
else
  # No se pudo cargar el archivo .env
  typeset -g ZSH_FUNCTIONS_ENV_LOADED=false
  
  # Mostrar advertencia solo si no es la primera vez
  if [[ -f "${ZSH_FUNCTIONS_DIR}/.env.example" ]] && [[ ! -f "$ZSH_FUNCTIONS_ENV_FILE" ]]; then
    # Solo mostrar advertencia en sesiones interactivas
    if [[ -o interactive ]]; then
      echo "⚠️  Advertencia: No se encontró el archivo de configuración .env"
      echo "   Crea uno desde el ejemplo: cp ${ZSH_FUNCTIONS_DIR}/.env.example ${ZSH_FUNCTIONS_ENV_FILE}"
    fi
  fi
fi

# Limpiar función temporal
unfunction _load_env_file
