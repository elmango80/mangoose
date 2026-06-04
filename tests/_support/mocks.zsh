#!/usr/bin/env zsh
# Mocks compartidos para reemplazar dependencias externas durante los tests.
#
# Carga este helper desde @setup cuando un test necesita evitar invocar el
# binario real de `git`, las funciones de spinner (`turn_the_command`) o los
# helpers interactivos (`read_single_char`).

# ─── turn_the_command ──────────────────────────────────────────────────────────
# La versión real (`core/spinners.zsh`) muestra un spinner de revolver y
# ejecuta el comando capturado. Para los tests basta con extraer el flag
# `--command` y evaluarlo en el contexto actual (así los mocks de `git`,
# `rm -rf`, etc. se aplican normalmente).
function stub_turn_the_command() {
  function turn_the_command() {
    local cmd=""
    while [[ $# -gt 0 ]]
    do
      case "$1" in
        --command) cmd="$2"; shift 2 ;;
        --message|--model) shift 2 ;;
        --no-newline) shift ;;
        *) shift ;;
      esac
    done
    [[ -n "$cmd" ]] && eval "$cmd"
  }
}

# ─── git_main_branch ───────────────────────────────────────────────────────────
# `git_main_branch` viene de oh-my-zsh (no es parte del repo). Lo mockeamos a
# `master` por defecto; los tests pueden sobreescribirlo si necesitan otro.
function stub_git_main_branch() {
  local branch="${1:-master}"
  function git_main_branch() {
    print -- "$branch"
  }
}

# ─── read_single_char ──────────────────────────────────────────────────────────
# La versión real lee un carácter del TTY con `stty raw`. En tests devolvemos
# el carácter pasado (por defecto "n" para responder negativamente a prompts).
function stub_read_single_char() {
  local answer="${1:-n}"
  function read_single_char() {
    print -- "$answer"
  }
}

# ─── activar todos los stubs por defecto ───────────────────────────────────────
# Atajo cuando un test quiere bloquear todas las dependencias externas a la vez.
function install_default_stubs() {
  stub_turn_the_command
  stub_git_main_branch "${1:-master}"
  stub_read_single_char "${2:-n}"
}
