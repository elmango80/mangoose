#!/usr/bin/env zsh
# Helpers para mockear el comando `git` dentro de los tests.
#
# Limitación conocida de zunit: las líneas en blanco dentro del cuerpo de un
# `@test` se eliminan al parsear el fichero, por lo que no se puede usar
# `cat <<EOF` con separadores en blanco entre entradas. Estas funciones generan
# el output con `\n\n` explícitos para sortear esa limitación.
#
# Limitación de zsh: como las funciones no capturan closure sobre variables
# locales, persistimos el porcelain construido en una variable global
# `_MOCK_GIT_PORCELAIN` que el mock lee cuando se invoca.

# Construye un bloque porcelain (`git worktree list --porcelain`) a partir
# de pares "path:branch" separados por `:`. Usa el sentinel `DETACHED`
# (sin paréntesis para evitar que zsh lo interprete como subshell) para
# marcar un worktree en estado detached.
#
# Uso:
#   git_porcelain /tmp/repo:master /tmp/repo/wt1:feature/foo /tmp/repo/wt2:DETACHED
function git_porcelain() {
  local entry path branch
  local out=""
  for entry in "$@"
  do
    path="${entry%%:*}"
    branch="${entry#*:}"
    out+="worktree ${path}\nHEAD 0000000000000000000000000000000000000000\n"
    if [[ "$branch" == "DETACHED" ]]
    then
      out+="detached\n"
    else
      out+="branch refs/heads/${branch}\n"
    fi
    out+="\n"
  done
  printf "$out"
}

# Instala una función `git` global que responde a:
#   - `git rev-parse --is-inside-work-tree` → exit 0
#   - `git worktree list --porcelain`       → emite el porcelain construido
#
# Acepta los mismos argumentos que `git_porcelain` y guarda el resultado en
# `_MOCK_GIT_PORCELAIN` para que el mock pueda leerlo aunque el llamador ya
# haya salido de su scope.
#
# Uso (dentro de un @test):
#   mock_git /tmp/repo:master /tmp/repo/wt1:feature/foo
function mock_git() {
  typeset -g _MOCK_GIT_PORCELAIN
  _MOCK_GIT_PORCELAIN="$(git_porcelain "$@")"

  function git() {
    case "$1" in
      rev-parse) return 0 ;;
      worktree)  printf '%s\n' "$_MOCK_GIT_PORCELAIN" ;;
      *)         return 1 ;;
    esac
  }
}
