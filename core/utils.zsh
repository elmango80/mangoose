#!/bin/zsh
# Funciones utilitarias generales

# Función para extraer y validar el valor de un argumento
function extract_arg_value() {
  local arg_name="$1"
  local value="$2"

  # Verificar que el valor no esté vacío
  if [[ -z "$value" || "$value" =~ ^- ]]; then
    printf "%b\n" "${RED}❌ Error: $arg_name requires a value${NC}" >&2
    return 1
  fi
  
  printf "%s\n" "$value"
  return 0
}

# Función para leer un solo carácter sin necesidad de presionar Enter
function read_single_char() {
  local prompt_text="$1"
  local answer
  local old_stty_cfg

  # Mostrar el prompt si se proporciona
  # if [[ -n "$prompt_text" ]]; then
  #   printf "%s" "$prompt_text"
  # fi

  old_stty_cfg=$(stty -g)
  stty raw -echo
  answer=$(head -c 1)
  stty $old_stty_cfg
  
  echo "${answer:l}"
}

function zre() {
  local zsh_file=".${1:-"zshrc"}"
  local dest="$HOME/$zsh_file"

  if [ -f $dest ]
  then
    printf "♻ zsh reload %s file...\n" "$zsh_file"
    source $dest || return 1
  else
    printf "zconfig: no such file: %s\n" "$dest"
    return 1
  fi
}

# Función de selector interactivo con flechas
# Uso: select_option "opción1" "opción2" "opción3"
# Retorna: índice seleccionado (1-based)
function select_option {
  local -a VERSIONS
  VERSIONS=("$@")
  
  SELECTED=1  # En zsh los arrays empiezan en 1
  TOTAL=${#VERSIONS[@]}
  
  # Ocultar el cursor
  tput civis
  
  # Mostrar menú inicial
  for ((i=1; i<=$TOTAL; i++)); do
    if [ $i -eq $SELECTED ]; then
      printf "  \033[1;32m➜ %-50s\033[0m\n" "${VERSIONS[$i]}"
    else
      printf "    %-50s\n" "${VERSIONS[$i]}"
    fi
  done
  
  # Función para redibujar el menú
  draw_menu() {
    # Mover cursor arriba al inicio del menú
    for ((i=1; i<=$TOTAL; i++)); do
      tput cuu1
    done
    
    # Redibujar cada línea
    for ((i=1; i<=$TOTAL; i++)); do
      tput el  # Limpiar la línea
      if [ $i -eq $SELECTED ]; then
        printf "  \033[1;32m➜ %-50s\033[0m\n" "${VERSIONS[$i]}"
      else
        printf "    %-50s\n" "${VERSIONS[$i]}"
      fi
    done
  }
  
  # Leer input del usuario
  while true; do
    # Leer una tecla sin procesar
    read -r -s -k 1 key
    
    case "$key" in
      $'\x1b')  # ESC - inicio de secuencia de escape
        read -r -s -k 2 -t 0.1 key  # Leer los siguientes caracteres con timeout
        case "$key" in
          '[A')  # Flecha arriba
            if [ $SELECTED -gt 1 ]; then
              SELECTED=$((SELECTED - 1))
              draw_menu
            fi
            ;;
          '[B')  # Flecha abajo
            if [ $SELECTED -lt $TOTAL ]; then
              SELECTED=$((SELECTED + 1))
              draw_menu
            fi
            ;;
        esac
        ;;
      $'\n'|$'\r')  # Enter (newline o carriage return)
        break
        ;;
    esac
  done
  
  # Mostrar el cursor de nuevo
  tput cnorm
  
  echo ""
  
  return $SELECTED
}
