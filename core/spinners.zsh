#!/bin/zsh
# Funciones para spinners y animaciones

function test_spinner() {
  run_with_spinner --command "sleep 3" --message "Task 1..."
  run_with_spinner --command "sleep 3" --message "Task 2..." --model "grow-vertical" --tab 1
  run_with_spinner --command "sleep 3 && ls /some/path" --message "Task 3 (with error)..." --model "hamburger"
}

function run_with_spinner() {
  local -A _revolver_spinners=(
    'dots' '⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓'
    'balloon' ' .oO°Oo. '
    'grow-vertical' '▁▃▄▅▆▇▆▅▄▃'
    'grow-horizontal' '▏▎▍▌▋▊▉▊▋▌▍▎'
    'star' '✶✸✹✺✹✷'
    'hamburger' '☱☲☴'
    'arc' '◜◠◝◞◡◟'
    'circle' '◡⊙◠'
  );
  local _spinner=${_revolver_spinners[dots]};
  local _delay=.125;
  local _message='Waiting...'
  local _command=""
  local _line_offset=0
  local _tabs=0
  local _no_newline=0

  while [[ $# -gt 0 ]]; do
    case $1 in
      --test)
        test_spinner
        return 0
        ;;
      --command)
        if _command=$(extract_arg_value "--command" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --delay)
        if _delay=$(extract_arg_value "--delay" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --message)
        if _message=$(extract_arg_value "--message" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --model)
        if _model=$(extract_arg_value "--model" "$2"); then
          if [[ -n ${_revolver_spinners[$_model]} ]]; then
            _spinner=${_revolver_spinners[$_model]}
          else
            msg --title "Invalid model '$_model'. Using default 'dots'." --error --to-stderr
          fi
          shift 2
        else
          return 1
        fi
        ;;
      --line-offset)
        if _line_offset=$(extract_arg_value "--line-offset" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --tab)
        if _tabs=$(extract_arg_value "--tab" "$2"); then
          shift 2
        else
          return 1
        fi
        ;;
      --no-newline)
        _no_newline=1
        shift
        ;;
      --help|-h)
        msg "Uso: run_with_spinner [OPCIONES]"
        msg "Ejecuta un comando con un indicador de animación giratorio."
        msg --blank
        msg "Requerido:"
        msg "  --command CMD           Comando a ejecutar en segundo plano"
        msg --blank
        msg "Opcional:"
        msg "  --delay SEGUNDOS        Retraso de animación (por defecto: 0.125)"
        msg "  --message TEXTO         Mensaje a mostrar (por defecto: 'Esperando...')"
        msg "  --model MODELO          Modelo de spinner (por defecto: 'dots')"
        msg "  --line-offset N         Desplazamiento de línea para mostrar (por defecto: 0)"
        msg "  --tab N                 Número de tabulaciones antes del spinner (por defecto: 0)"
        msg "  --no-newline            No agregar salto de línea al final del mensaje final"
        msg "  --test                  Ejecutar demostración de prueba con diferentes spinners"
        msg "  -h, --help              Mostrar esta ayuda"
        msg --blank
        msg "Modelos de spinner disponibles:"
        msg "  dots, balloon, grow-vertical, grow-horizontal,"
        msg "  star, hamburger, arc, circle"
        msg --blank
        msg "Ejemplos:"
        msg "  run_with_spinner --test"
        msg "  run_with_spinner --command \"sleep 5\" --message \"Procesando...\""
        msg "  run_with_spinner --command \"npm install\" --model arc"
        msg "  run_with_spinner --command \"make build\" --tab 2 --message \"Compilando...\""
        msg "  run_with_spinner --command \"sleep 2\" --message \"Cargando...\" --no-newline"
        return 0
        ;;
      *)
        msg "Argumento inesperado $1" --error --to-stderr
        return 1
        ;;
    esac
  done

  if [[ -z "$_command" ]]; then
    msg "No command provided. Use --command to specify the command to run." --error --to-stderr
    return 1
  fi

  # Crear archivo temporal para capturar la salida
  local _output_file=$(mktemp)
  
  # Desactivar notificaciones de jobs para evitar output del PID
  setopt local_options no_notify no_monitor
  
  # Ejecutar el comando en segundo plano capturando stdout y stderr
  eval "$_command" > "$_output_file" 2>&1 &
  local _pid=$! # Process Id of the previous running command

  local _index=0
  local _tab_string=""
  
  # Generar string de tabulaciones (cada tab = 2 espacios)
  for ((i=0; i<_tabs; i++)); do
    _tab_string="${_tab_string}  "
  done

  # Spinner y mensaje van a stderr para que no se capturen con $()
  while kill -0 $_pid 2>/dev/null # Verifica si el proceso ha muerto
  do
    _index=$(((_index + 1) % ${#_spinner}))
    printf "\r${_tab_string}${GREEN}${_spinner:$_index:1}${NC} $_message" >&2
    sleep $_delay
  done
  
  # Esperar a que el proceso termine y capturar su exit code
  wait $_pid
  local _exit_code=$?
  
  # Determinar ícono según el resultado
  local _icon="✓"
  local _color="$GREEN"
  
  if [[ $_exit_code -ne 0 ]]; then
    _icon="✗"
    _color="$RED"
  fi
  
  # Mensaje final también a stderr
  if [[ $_no_newline -eq 1 ]]; then
    printf "\r${_tab_string}${_color}${_icon} $_message${NC}" >&2
  else
    printf "\r${_tab_string}${_color}${_icon} $_message${NC}\n" >&2
  fi
  
  # Mostrar la salida capturada en stdout (será la respuesta del método)
  cat "$_output_file"
  rm -f "$_output_file"
  
  # Retornar el exit code del comando
  return $_exit_code
}
