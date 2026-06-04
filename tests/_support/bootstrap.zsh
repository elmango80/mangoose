#!/usr/bin/env zsh
# Bootstrap compartido para los tests de mangoose.
#
# Define la variable MANGOOSE_ROOT apuntando a la raíz del proyecto y expone
# el helper `mangoose_source` para cargar módulos del repo desde cualquier test
# sin tener que repetir la ruta.

MANGOOSE_ROOT="${0:A:h:h:h}"
export MANGOOSE_ROOT

# Carga uno o varios ficheros del repo relativos a MANGOOSE_ROOT.
#
# Ejemplo:
#   mangoose_source core/colors.zsh core/print.zsh
function mangoose_source() {
  local relpath
  for relpath in "$@"
  do
    source "${MANGOOSE_ROOT}/${relpath}"
  done
}
