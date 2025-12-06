#!/bin/zsh
# Funciones de Git para gestión de repositorios

function is_git_repository() {
  if [[ ! -d ".git" ]]
  then
    msg "No se encontró un repositorio git en ${BOLD}${ITALIC}$(pwd)${NC}" --error --to-stderr
    return 1
  fi

  return 0
}

function no_branch_for_old_refs() {
  local dry_run=0
  local demo_mode=0
  local all_repos=0

  # Procesar parámetros
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        dry_run=1
        ;;
      --demo|-d)
        demo_mode=1
        ;;
      --all|-a)
        all_repos=1
        ;;
      --help|-h)
        msg "${GREEN}no_branch_for_old_refs${NC} - Limpia ramas obsoletas que han sido eliminadas del remoto"
        msg --blank
        msg "${BOLD}USO:${NC}"
        msg "  no_branch_for_old_refs [OPCIONES]"
        msg --blank
        msg "${BOLD}OPCIONES:${NC}"
        msg "  ${YELLOW}--dry-run${NC}    Muestra qué ramas se eliminarían sin eliminarlas realmente"
        msg "  ${YELLOW}--demo, -d${NC}   Simula la eliminación de ramas con pausa (para pruebas)"
        msg "  ${YELLOW}--all, -a${NC}    Ejecuta la limpieza en todos los repositorios del directorio actual"
        msg "  ${YELLOW}--help, -h${NC}   Muestra este mensaje de ayuda"
        msg --blank
        msg "${BOLD}DESCRIPCIÓN:${NC}"
        msg "  Esta función identifica ramas locales que han sido eliminadas del repositorio"
        msg "  remoto y las elimina de tu repositorio local. Hará lo siguiente:"
        msg "  • Actualiza y limpia referencias remotas"
        msg "  • Identifica ramas con estado de seguimiento 'gone'"
        msg "  • Elimina ramas obsoletas (excepto la rama actual)"
        msg "  • Pregunta antes de eliminar la rama actual si también está obsoleta"
        msg --blank
        msg "${BOLD}EJEMPLOS:${NC}"
        msg "  no_branch_for_old_refs                  # Limpia ramas obsoletas del repositorio actual"
        msg "  no_branch_for_old_refs --dry-run        # Previsualiza qué se eliminaría"
        msg "  no_branch_for_old_refs --demo           # Simula eliminación para pruebas"
        msg "  no_branch_for_old_refs --all            # Limpia todos los repositorios del directorio actual"
        msg "  no_branch_for_old_refs --all --dry-run  # Previsualiza todos los repositorios"
        return 0
        ;;
      *)
        msg "Argumento inesperado $1" --error --to-stderr
        msg "Usa --help para información de uso" --info
        return 1
        ;;
    esac
    shift
  done

  # Si se especifica --all, ejecutar recursivamente en todos los repositorios
  if [[ $all_repos -eq 1 ]]; then
    local processed_count=0
    for d in */
    do
      cd "$d"
      # Reconstruir los parámetros sin --all
      local params=()
      [[ $dry_run -eq 1 ]] && params+=(--dry-run)
      [[ $demo_mode -eq 1 ]] && params+=(--demo)
      
      no_branch_for_old_refs "${params[@]}"
      ((processed_count++))
      cd ..
    done
    
    if [[ $processed_count -eq 0 ]]; then
      msg "No se encontraron repositorios en el directorio actual" --warning
    else
      msg --blank
      msg "🎉 Todos los repositorios limpiados" --success
    fi
    return 0
  fi

  if is_git_repository
  then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    local current_branch=$(git branch --show-current)
    local git_master_branch=$(git_main_branch)
    
    msg "Iniciando limpieza en ${GREEN}$repo_name${NC}"

    # Actualizar referencias remotas
    git fetch --prune > /dev/null 2>&1

    # Obtener todas las ramas eliminadas del remoto
    local all_stale_branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')
    
    # Separar la rama actual de las demás
    local other_stale_branches=""
    local current_branch_is_stale=0
    
    while IFS= read -r branch; do
      if [[ -n "$branch" ]]; then
        if [[ "$branch" == "*" ]]; then
          current_branch_is_stale=1
        else
          if [[ -n "$other_stale_branches" ]]; then
            other_stale_branches="$other_stale_branches\n$branch"
          else
            other_stale_branches="$branch"
          fi
        fi
      fi
    done <<< "$all_stale_branches"
    
    # Si no hay ramas para eliminar
    if [[ -z "$all_stale_branches" ]]; then
      msg "No se encontraron ramas obsoletas" --success
      return 0
    fi

    if [[ $dry_run -eq 1 ]]; then
      msg "Ramas que se eliminarían en ${ITALIC}$repo_name${NC}" --info
      if [[ $current_branch_is_stale -eq 1 ]]; then
        msg "La rama actual ha sido eliminada del remoto" --warning 
        msg "${YELLOW}$current_branch${NC}" --tab 1
        msg --blank
      fi
      if [[ -n "$other_stale_branches" ]]; then
        echo -e "$other_stale_branches" | while read branch; do
          if [[ -n "$branch" ]]; then
            msg "  ${RED}- $branch${NC}"
          fi
        done
      fi
      return 0
    fi

    # Mostrar mensaje informativo en modo demo
    if [[ $demo_mode -eq 1 ]]; then
      msg "Ejecutando en ${YELLOW}MODO DEMO${NC} - las ramas no se eliminarán realmente" --warning
      msg --blank
    fi

    # Eliminar primero las otras ramas
    if [[ -n "$other_stale_branches" ]]; then
      msg "🗑️ Eliminando ramas obsoletas en ${GREEN}$repo_name${NC}"
      echo -e "$other_stale_branches" | while read branch; do
        if [[ -n "$branch" ]]; then
          if [[ $demo_mode -eq 1 ]]; then
            turn_the_command --command "sleep 3" --message "Eliminando rama ${RED}$branch${NC}" --no-newline
          else
            turn_the_command --command "git branch -D \"$branch\"" --message "Eliminando rama ${RED}$branch${NC}" --no-newline
          fi
          msg "\r${GREEN}✓ Rama eliminada ${RED}$branch${NC} "
        fi
      done
    fi

    # Manejar la rama actual si también está eliminada del remoto
    if [[ $current_branch_is_stale -eq 1 ]]; then
      msg --blank
      msg "${YELLOW}Advertencia: Tu rama actual también ha sido eliminada del remoto.${NC}" --warning
      msg "¿Quieres eliminar la rama actual y cambiar a ${GREEN}${ITALIC}$git_master_branch${NC}? (s/N): "
      
      answer=$(read_single_char)
      
      if [[ $answer == "s" ]] || [[ $answer == "y" ]]; then
        if [[ $demo_mode -eq 0 ]]; then
          msg "  • Cambiando a la rama ${GREEN}$git_master_branch${NC}"
          git switch $git_master_branch > /dev/null 2>&1
        fi

        if [[ $demo_mode -eq 1 ]]; then
          turn_the_command --command "sleep 3" --message "Eliminando rama ${RED}$current_branch${NC}" --no-newline
        else
          turn_the_command --command "git branch --delete --force \"$current_branch\"" --message "Eliminando rama ${RED}$current_branch${NC}" --no-newline
        fi
        msg "\r${GREEN}✓ Rama eliminada ${RED}$current_branch${NC} "
      fi
    fi

    if [[ -n "$other_stale_branches" || $current_branch_is_stale -eq 1 ]]; then
      msg "Limpieza completada en ${BOLD_CYAN}$repo_name${NC}" --success
    fi
  fi
}

function update_master_repo() {
  local git_master_branch=$(git_main_branch)
  local repository_name=$(is_git_repository)

  if is_git_repository; then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    printf "🚀 Iniciando actualización de master en ${GREEN}$repo_name${NC}\n"

    git fetch origin $git_master_branch > /dev/null 2>&1
    local has_remote_changes=$(git diff $git_master_branch origin/$git_master_branch --quiet || echo "changes")
    if [[ -n $has_remote_changes ]]
    then
      local current_branch=$(git branch --show-current)
      printf "   Rama actual ${GREEN}$current_branch${NC}\n"

      local has_uncommitted_changes=$(git status --porcelain)
      if [[ -n $has_uncommitted_changes ]]
      then
        printf "  • ${YELLOW}Guardando cambios sin confirmar${NC}\n"
        git stash > /dev/null 2>&1
      fi
      
      if [[ "$current_branch" != "master" && "$current_branch" != "main" ]]
      then
        printf "  • Cambiando a la rama ${GREEN}master${NC}\n"
        git switch $git_master_branch > /dev/null 2>&1
      fi

      printf "  • Obteniendo cambios de la rama master remota\n"
      git pull origin $git_master_branch > /dev/null 2>&1

      if [[ "$current_branch" != $git_master_branch ]]
      then
        printf "  • Cambiando a la rama ${GREEN}$current_branch${NC}\n"
        git switch "$current_branch" > /dev/null 2>&1
      fi

      if [[ -n $has_uncommitted_changes ]]
      then
        printf "  • Restaurando cambios sin confirmar.\n"
        git stash pop > /dev/null 2>&1
      fi
    fi

    printf "  ✅ Rama master ya actualizada\n"
    printf "\n"
  fi
}

function update_master_repos() {
  printf "🔄 ${CYAN}Actualizando repositorios...${NC}\n"
  for d in */
  do
    cd "$d"
    update_master_repo
    cd ..
  done
  printf "🎉 Todos los repositorios actualizados\n"
}
