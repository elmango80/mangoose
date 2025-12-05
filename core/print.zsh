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
        printf "Usage: msg [MESSAGE] [OPTIONS]\n"
        printf "\n"
        printf "Arguments:\n"
        printf "  MESSAGE                 The text message to display (REQUIRED)\n"
        printf "\n"
        printf "Message Types (optional):\n"
        printf "      --error             Error message with ❌ icon\n"
        printf "  -w, --warning           Warning message with ⚠️ icon\n"
        printf "  -i, --info              Info message with ℹ️ icon\n"
        printf "  -s, --success           Success message with ✅ icon\n"
        printf "      --debug             Debug message with 🐛 icon\n"
        printf "  -n, --notice            Notice message with 📋 icon\n"
        printf "      --dim               Dimmed text message\n"
        printf "      (default)           Plain text message\n"
        printf "\n"
        printf "Optional:\n"
        printf "      --tab N             Number of indentation levels (2 spaces each)\n"
        printf "      --to-stderr         Send output to stderr instead of stdout\n"
        printf "      --no-newline        Don't add newline at end of message\n"
        printf "      --no-icon           Don't show icon for message types\n"
        printf "      --blank             Print a blank line (no message needed)\n"
        printf "  -h, --help              Show this help\n"
        printf "\n"
        printf "Examples:\n"
        printf "  msg \"Simple message\"\n"
        printf "  msg \"Connection failed\" --error\n"
        printf "  msg --error \"Connection failed\"\n"
        printf "  msg \"Task completed\" --success\n"
        printf "  msg \"Warning message\" --warning --to-stderr\n"
        printf "  msg --dim \"This is dimmed text\"\n"
        printf "  msg --tab 2 \"Indented message\"\n"
        printf "  msg \"Loading...\" --no-newline\n"
        printf "  msg \"Error occurred\" --error --no-icon\n"
        printf "  msg --blank\n"
        return 0
        ;;
      *)
        # Si no es una opción conocida, debe ser el texto del mensaje
        if [[ -z "$text" ]]; then
          text="$1"
        else
          printf "%b\n" "${RED}❌ Error: Unknown argument '$1'${NC}" >&2
          printf "Use --help for usage information\n" >&2
          return 1
        fi
        shift
        ;;
    esac
  done
  
  # Validar que se proporcione el texto del mensaje
  if [[ -z "$text" ]]; then
    printf "%b\n" "${RED}❌ Error: Message text is required${NC}" >&2
    printf "Use --help for usage information\n" >&2
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
