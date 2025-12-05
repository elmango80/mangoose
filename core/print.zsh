#!/bin/zsh
# Funciones para mostrar mensajes con formato y colores

# Función auxiliar para enviar salida a stdout o stderr
function _output_message() {
  local message="$1"
  local use_stderr="$2"
  
  if [[ $use_stderr -eq 1 ]]; then
    printf "%b\n" "$message" >&2
  else
    printf "%b\n" "$message"
  fi
}

function print_indentation() {
  local tabs=0
  
  if [[ $# -gt 0 ]]; then
    tabs="$1"
  fi
  
  local tab_string=""
  for ((i=0; i<tabs; i++)); do
    tab_string="${tab_string}  "
  done
  
  printf "%s" "$tab_string"
}

function msg() {
  local text=""
  local type="none"
  local use_stderr=0
  local tabs=0
  local no_newline=0
  local no_icon=0
  
  # Procesar argumentos
  while [[ $# -gt 0 ]]; do
    case $1 in
      --error)
        type="error"
        shift
        ;;
      --warning|-w)
        type="warning"
        shift
        ;;
      --info|-i)
        type="info"
        shift
        ;;
      --success|-s)
        type="success"
        shift
        ;;
      --debug)
        type="debug"
        shift
        ;;
      --notice|-n)
        type="notice"
        shift
        ;;
      --dim)
        type="dim"
        shift
        ;;
      --tab)
        if tabs=$(extract_arg_value "--tab" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --to-stderr)
        use_stderr=1
        shift
        ;;
      --no-newline)
        no_newline=1
        shift
        ;;
      --no-icon)
        no_icon=1
        shift
        ;;
      --blank)
        printf "\n"
        return 0
        ;;
      --help|-h)
        printf "Uso: msg [MENSAJE] [OPCIONES]\n"
        printf "\n"
        printf "Argumentos:\n"
        printf "  MENSAJE                 El texto del mensaje a mostrar (REQUERIDO)\n"
        printf "\n"
        printf "Tipos de Mensaje (opcional):\n"
        printf "      --error             Mensaje de error con ícono ❌\n"
        printf "  -w, --warning           Mensaje de advertencia con ícono ⚠️\n"
        printf "  -i, --info              Mensaje informativo con ícono ℹ️\n"
        printf "  -s, --success           Mensaje de éxito con ícono ✅\n"
        printf "      --debug             Mensaje de depuración con ícono 🐛\n"
        printf "  -n, --notice            Mensaje de aviso con ícono 📋\n"
        printf "      --dim               Texto atenuado\n"
        printf "      (por defecto)       Mensaje de texto simple\n"
        printf "\n"
        printf "Opcional:\n"
        printf "      --tab N             Número de niveles de indentación (2 espacios cada uno)\n"
        printf "      --to-stderr         Enviar salida a stderr en lugar de stdout\n"
        printf "      --no-newline        No agregar salto de línea al final del mensaje\n"
        printf "      --no-icon           No mostrar ícono para tipos de mensaje\n"
        printf "      --blank             Imprimir una línea en blanco (no se necesita mensaje)\n"
        printf "  -h, --help              Mostrar esta ayuda\n"
        printf "\n"
        printf "Ejemplos:\n"
        printf "  msg \"Mensaje simple\"\n"
        printf "  msg \"Conexión fallida\" --error\n"
        printf "  msg --error \"Conexión fallida\"\n"
        printf "  msg \"Tarea completada\" --success\n"
        printf "  msg \"Mensaje de advertencia\" --warning --to-stderr\n"
        printf "  msg --dim \"Este es un texto atenuado\"\n"
        printf "  msg --tab 2 \"Mensaje indentado\"\n"
        printf "  msg \"Cargando...\" --no-newline\n"
        printf "  msg \"Ocurrió un error\" --error --no-icon\n"
        printf "  msg --blank\n"
        return 0
        ;;
      *)
        # Si no es una opción conocida, debe ser el texto del mensaje
        if [[ -z "$text" ]]; then
          text="$1"
        else
          printf "%b\n" "${RED}❌ Error: Argumento desconocido '$1'${NC}" >&2
          printf "Usa --help para información de uso\n" >&2
          return 1
        fi
        shift
        ;;
    esac
  done
  
  # Validar que se proporcione el texto del mensaje
  if [[ -z "$text" ]]; then
    printf "%b\n" "${RED}❌ Error: Se requiere el texto del mensaje${NC}" >&2
    printf "Usa --help para información de uso\n" >&2
    return 1
  fi

  print_indentation "$tabs"
  
  # Determinar el formato de salida según no_newline
  local format_with_newline="%b\n"
  local format_no_newline="%b"
  local format="$format_with_newline"
  
  if [[ $no_newline -eq 1 ]]; then
    format="$format_no_newline"
  fi
  
  # Mostrar mensaje según el tipo
  case $type in
    "error")
      local icon="❌ "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      if [[ $use_stderr -eq 1 ]]; then
        printf "$format" "${RED}${icon}$text${NC}" >&2
      else
        printf "$format" "${RED}${icon}$text${NC}"
      fi
      ;;
    "warning")
      local icon="⚠️ "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      printf "$format" "${YELLOW}${icon}$text${NC}"
      ;;
    "info")
      local icon="ℹ️ "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      printf "$format" "${LIGHT_BLUE}${icon}$text${NC}"
      ;;
    "success")
      local icon="✅ "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      printf "$format" "${GREEN}${icon}$text${NC}"
      ;;
    "debug")
      local icon="🐛 "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      printf "$format" "${PURPLE}${icon}$text${NC}" >&2
      ;;
    "notice")
      local icon="📋 "
      if [[ $no_icon -eq 1 ]]; then icon=""; fi
      printf "$format" "${CYAN}${icon}$text${NC}"
      ;;
    "dim")
      printf "$format" "${DIM}$text${NC}"
      ;;
    "none"|*)
      printf "$format" "$text"
      ;;
  esac
}
