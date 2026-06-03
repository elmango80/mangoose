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

function git_worktree_goto() {
  local target="$1"

  if [[ "$target" == "--help" || "$target" == "-h" ]]
  then
    msg "Uso: gowt [OPCIÓN | NOMBRE]"
    msg --blank
    msg "Navega entre los worktrees del repositorio git actual."
    msg --blank
    msg "Argumentos:"
    msg "  NOMBRE                  Nombre del worktree (carpeta o rama) al que saltar"
    msg "  root                    Salta al worktree principal del repositorio"
    msg --blank
    msg "Opciones:"
    msg "  -ls, --list             Lista todos los worktrees del repositorio"
    msg "  -h,  --help             Muestra esta ayuda"
    msg --blank
    msg "Ejemplos:"
    msg "  gowt --list             # Lista los worktrees disponibles"
    msg "  gowt root               # Va al worktree principal"
    msg "  gowt maintenance        # Va al worktree 'maintenance'"
    return 0
  fi

  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1
  then
    msg "No estás dentro de un repositorio git" --error --to-stderr
    return 1
  fi
  local worktrees_raw
  worktrees_raw=$(git worktree list --porcelain 2>/dev/null)

  if [[ -z "$worktrees_raw" ]]
  then
    msg "No se pudieron listar los worktrees" --error --to-stderr
    return 1
  fi

  local -a paths branches
  local current_path="" current_branch=""

  while IFS= read -r line
  do
    if [[ "$line" == worktree\ * ]]
    then
      current_path="${line#worktree }"
      current_branch=""
    elif [[ "$line" == branch\ refs/heads/* ]]
    then
      current_branch="${line#branch refs/heads/}"
    elif [[ "$line" == "detached" ]]
    then
      current_branch="(detached)"
    elif [[ -z "$line" && -n "$current_path" ]]
    then
      paths+=("$current_path")
      branches+=("$current_branch")
      current_path=""
      current_branch=""
    fi
  done <<< "$worktrees_raw"

  if [[ -n "$current_path" ]]
  then
    paths+=("$current_path")
    branches+=("$current_branch")
  fi

  local total=${#paths}

  if [[ "$target" == "-ls" || "$target" == "--list" ]]
  then
    msg "Worktrees disponibles:"
    local root="${paths[1]}"
    local root_name="${root:t}"
    local i
    for (( i=1; i<=total; i++ ))
    do
      local name=""
      if [[ $i -eq 1 ]]
      then
        name="root"
      else
        name="${paths[$i]:t}"
      fi
      local branch="${branches[$i]:-(sin rama)}"
      local relpath="${paths[$i]#$root}"
      relpath="${root_name}${relpath}"
      msg "  ${GREEN}[${name}]${NC} ${CYAN}${relpath}${NC} en ${PURPLE}"$'\ue0a0'" ${branch}${NC}"
    done
    return 0
  fi

  if [[ -z "$target" ]]
  then
    msg "Uso: gowt <nombre-worktree> | root | -ls | --list" --error --to-stderr
    return 1
  fi

  if [[ "$target" == "root" ]]
  then
    cd "${paths[1]}"
    return $?
  fi

  local i
  for (( i=1; i<=total; i++ ))
  do
    local base="${paths[$i]:t}"
    if [[ "$base" == "$target" || "${branches[$i]}" == "$target" ]]
    then
      cd "${paths[$i]}"
      return $?
    fi
  done

  msg "No se encontró un worktree que coincida con ${BOLD}${target}${NC}" --error --to-stderr
  return 1
}

function no_branch_for_old_refs() {
  local dry_run=0
  local demo_mode=0
  local all_repos=0
  local verbose=0

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
      --verbose|-v)
        verbose=1
        ;;
      --help|-h)
        msg "${GREEN}no_branch_for_old_refs${NC} - Limpia ramas locales que ya no son necesarias"
        msg --blank
        msg "${BOLD}USO:${NC}"
        msg "  no_branch_for_old_refs [OPCIONES]"
        msg --blank
        msg "${BOLD}OPCIONES:${NC}"
        msg "  ${YELLOW}--dry-run${NC}    Muestra qué ramas se eliminarían sin eliminarlas realmente"
        msg "  ${YELLOW}--demo, -d${NC}   Simula la eliminación de ramas con pausa (para pruebas)"
        msg "  ${YELLOW}--verbose, -v${NC} Muestra resumen detallado de ramas clasificadas y pide confirmación"
        msg "  ${YELLOW}--all, -a${NC}    Ejecuta la limpieza en todos los repositorios del directorio actual"
        msg "  ${YELLOW}--help, -h${NC}   Muestra este mensaje de ayuda"
        msg --blank
        msg "${BOLD}DESCRIPCIÓN:${NC}"
        msg "  Identifica y elimina ramas locales que ya no son necesarias:"
        msg "  • Actualiza y limpia referencias remotas (fetch --prune)"
        msg "  • Elimina ramas ya mergeadas en main/master"
        msg "  • Elimina ramas cuyo remoto fue eliminado (gone)"
        msg "  • Conserva ramas nunca publicadas y ramas con remoto activo"
        msg "  • Excluye siempre: main/master y patrones de GIT_BRANCH_EXCLUSIONS"
        msg "  • Pregunta antes de eliminar la rama actual si está obsoleta"
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


  # Mostrar mensaje informativo en modo demo
  if [[ $demo_mode -eq 1 ]]; then
    msg "Ejecutando en ${YELLOW}MODO DEMO${NC} - las ramas no se eliminarán realmente" --warning
  fi

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
      [[ $verbose -eq 1 ]] && params+=(--verbose)
      
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
    turn_the_command --command "git fetch --prune origin" --message "Actualizando referencias remotas"

    # Clasificar ramas en 4 categorías
    local -a merged_branches=()
    local -a gone_branches=()
    local -a never_pushed_branches=()
    local -a kept_branches=()
    local current_branch_is_stale=0
    local current_branch_reason=""

    while IFS= read -r line; do
      local branch=$(echo "$line" | sed 's/^\* //' | xargs)
      [[ -z "$branch" ]] && continue

      # Excluir main/master
      [[ "$branch" == "$git_master_branch" ]] && continue

      # Excluir ramas que coincidan con patrones de GIT_BRANCH_EXCLUSIONS
      local excluded=0
      if [[ -n "${GIT_BRANCH_EXCLUSIONS}" ]] && [[ ${#GIT_BRANCH_EXCLUSIONS[@]} -gt 0 ]]; then
        for pattern in "${GIT_BRANCH_EXCLUSIONS[@]}"; do
          if [[ "$branch" == ${~pattern} ]]; then
            excluded=1
            break
          fi
        done
      fi
      [[ $excluded -eq 1 ]] && { kept_branches+=("$branch"); continue; }

      # Obtener info de tracking con git for-each-ref (más robusto que parsear git branch -vv)
      local tracking_info=$(git for-each-ref --format='%(upstream:short) %(upstream:track)' "refs/heads/$branch" 2>/dev/null)
      local upstream=$(echo "$tracking_info" | awk '{print $1}')
      local track_status=$(echo "$tracking_info" | grep -o '\[gone\]' || true)

      # Verificar si está mergeada en la rama principal
      local is_merged=$(git branch --merged "$git_master_branch" 2>/dev/null | grep -E "^\s+${branch}$" || true)

      if [[ -n "$is_merged" ]]; then
        if [[ "$branch" == "$current_branch" ]]; then
          current_branch_is_stale=1
          current_branch_reason="mergeada"
        else
          merged_branches+=("$branch")
        fi
      elif [[ -z "$upstream" ]]; then
        never_pushed_branches+=("$branch")
      elif [[ -n "$track_status" ]]; then
        if [[ "$branch" == "$current_branch" ]]; then
          current_branch_is_stale=1
          current_branch_reason="gone"
        else
          gone_branches+=("$branch")
        fi
      else
        kept_branches+=("$branch")
      fi
    done < <(git branch --no-color | sed 's/^\*//')

    # Combinar ramas a eliminar
    local -a to_delete=("${merged_branches[@]}" "${gone_branches[@]}")

    # Si no hay nada que eliminar
    if [[ ${#to_delete[@]} -eq 0 ]] && [[ $current_branch_is_stale -eq 0 ]]; then
      msg "No hay ramas para eliminar. Todo limpio." --success
      return 0
    fi

    # Resumen detallado solo en modo verbose
    if [[ $verbose -eq 1 ]]; then
      msg "Ramas mergeadas en ${GREEN}$git_master_branch${NC} (se eliminarán):" --success
      if [[ ${#merged_branches[@]} -eq 0 ]]; then
        msg "  (ninguna)" --dim
      else
        for b in "${merged_branches[@]}"; do msg "  - $b"; done
      fi

      msg "Ramas eliminadas del remoto (se eliminarán):" --error
      if [[ ${#gone_branches[@]} -eq 0 ]]; then
        msg "  (ninguna)" --dim
      else
        for b in "${gone_branches[@]}"; do msg "  - $b"; done
      fi

      msg "Ramas nunca publicadas (se conservarán):" --warning
      if [[ ${#never_pushed_branches[@]} -eq 0 ]]; then
        msg "  (ninguna)" --dim
      else
        for b in "${never_pushed_branches[@]}"; do msg "  - $b"; done
      fi

      msg "Ramas con remoto activo (se conservarán):" --info
      if [[ ${#kept_branches[@]} -eq 0 ]]; then
        msg "  (ninguna)" --dim
      else
        for b in "${kept_branches[@]}"; do msg "  - $b"; done
      fi
    fi

    if [[ $current_branch_is_stale -eq 1 ]]; then
      msg "Tu rama actual ${YELLOW}$current_branch${NC} también será eliminada ($current_branch_reason)" --warning
    fi

    # Modo dry-run: mostrar qué se eliminaría
    if [[ $dry_run -eq 1 ]]; then
      msg "Ramas que se eliminarían:" --info
      for b in "${to_delete[@]}"; do
        msg "  ${RED}- $b${NC}"
      done
      if [[ $current_branch_is_stale -eq 1 ]]; then
        msg "  ${YELLOW}- $current_branch (rama actual, $current_branch_reason)${NC}"
      fi
      msg "${YELLOW}(dry-run) No se eliminó ninguna rama.${NC}" --warning
      return 0
    fi

    # Confirmación antes de eliminar (solo en modo verbose)
    if [[ $verbose -eq 1 ]] && [[ $demo_mode -eq 0 ]]; then
      msg "¿Continuar? (s/N): " --no-newline
      local answer=$(read_single_char)
      if [[ "$answer" != "s" ]] && [[ "$answer" != "y" ]]; then
        msg "Operación cancelada."
        return 0
      fi
    fi

    # Eliminar ramas
    local deleted=0
    local failed=0
    for branch in "${to_delete[@]}"; do
      if [[ $demo_mode -eq 1 ]]; then
        turn_the_command --command "sleep 0.25" --message "Eliminando rama ${RED}$branch${NC}" --no-newline
      else
        turn_the_command --command "git branch -D \"$branch\"" --message "Eliminando rama ${RED}$branch${NC}" --no-newline
      fi
      if [[ $? -eq 0 ]]; then
        msg "\r${GREEN}✓ Rama eliminada ${RED}$branch${NC} "
        ((deleted++))
      else
        msg "\r${RED}✗ Error al eliminar ${RED}$branch${NC} "
        ((failed++))
      fi
    done

    # Manejar la rama actual si también está obsoleta
    if [[ $current_branch_is_stale -eq 1 ]]; then
      msg "¿Eliminar la rama actual y cambiar a ${GREEN}${ITALIC}$git_master_branch${NC}? (s/N): " --no-newline
      
      local answer=$(read_single_char)
      
      if [[ "$answer" == "s" ]] || [[ "$answer" == "y" ]]; then
        if [[ $demo_mode -eq 0 ]]; then
          msg "  Cambiando a la rama ${GREEN}$git_master_branch${NC}"
          git switch $git_master_branch > /dev/null 2>&1
        fi

        if [[ $demo_mode -eq 1 ]]; then
          turn_the_command --command "sleep 0.25" --message "Eliminando rama ${RED}$current_branch${NC}" --no-newline
        else
          turn_the_command --command "git branch -D \"$current_branch\"" --message "Eliminando rama ${RED}$current_branch${NC}" --no-newline
        fi
        msg "\r${GREEN}✓ Rama eliminada ${RED}$current_branch${NC} "
        ((deleted++))
      fi
    fi

    msg "Resultado: ${GREEN}${deleted} eliminada(s)${NC}, ${RED}${failed} error(es)${NC}" --success
  fi
}

function paranoid_sync() {
  local all_repos=0
  
  # Procesar parámetros
  while [[ $# -gt 0 ]]; do
    case $1 in
      --all|-a)
        all_repos=1
        ;;
      --help|-h)
        msg "${GREEN}paranoid_sync${NC} - Actualiza la rama principal del repositorio"
        msg --blank
        msg "${BOLD}USO:${NC}"
        msg "  paranoid_sync [OPCIONES]"
        msg --blank
        msg "${BOLD}OPCIONES:${NC}"
        msg "  ${YELLOW}--all, -a${NC}    Ejecuta la sincronización en todos los repositorios del directorio actual"
        msg "  ${YELLOW}--help, -h${NC}   Muestra este mensaje de ayuda"
        msg --blank
        msg "${BOLD}DESCRIPCIÓN:${NC}"
        msg "  Esta función actualiza la rama principal (main/master) del repositorio,"
        msg "  preservando tu rama actual y cambios sin confirmar. Hará lo siguiente:"
        msg "  • Detecta si hay cambios remotos en la rama principal"
        msg "  • Guarda cambios sin confirmar (stash)"
        msg "  • Cambia a la rama principal si no estás en ella"
        msg "  • Obtiene y aplica los cambios remotos"
        msg "  • Vuelve a tu rama original"
        msg "  • Restaura los cambios sin confirmar"
        msg --blank
        msg "${BOLD}EJEMPLOS:${NC}"
        msg "  paranoid_sync                  # Actualiza el repositorio actual"
        msg "  paranoid_sync --all            # Actualiza todos los repositorios del directorio actual"
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
    msg "${CYAN}Actualizando repositorios${NC}"
    local processed_count=0
    for d in */
    do
      cd "$d"
      if is_git_repository 2>/dev/null
      then
        paranoid_sync
        ((processed_count++))
      fi
      cd ..
    done
    
    if [[ $processed_count -eq 0 ]]; then
      msg "No se encontraron repositorios en el directorio actual" --warning
    else
      msg "🎉 Todos los repositorios actualizados" --success --no-icon
    fi
    return 0
  fi

  local git_master_branch=$(git_main_branch)
  local repository_name=$(is_git_repository)

  if is_git_repository; then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    msg "🚀 Iniciando actualización de master en ${GREEN}$repo_name${NC}"

    git fetch origin $git_master_branch > /dev/null 2>&1
    local has_remote_changes=$(git diff $git_master_branch origin/$git_master_branch --quiet || echo "changes")
    if [[ -n $has_remote_changes ]]
    then
      local current_branch=$(git branch --show-current)
      msg "   Rama actual ${GREEN}$current_branch${NC}"

      local has_uncommitted_changes=$(git status --porcelain)
      if [[ -n $has_uncommitted_changes ]]
      then
        msg "  • ${YELLOW}Guardando cambios sin confirmar${NC}"
        git stash > /dev/null 2>&1
      fi
      
      if [[ "$current_branch" != $git_master_branch ]]
      then
        msg "  • Cambiando a la rama ${GREEN}$git_master_branch${NC}"
        git switch $git_master_branch > /dev/null 2>&1
      fi

      msg "  • Obteniendo cambios de la rama remota"
      git pull origin $git_master_branch > /dev/null 2>&1

      if [[ "$current_branch" != $git_master_branch ]]
      then
        msg "  • Cambiando a la rama ${GREEN}$current_branch${NC}"
        git switch "$current_branch" > /dev/null 2>&1
      fi

      if [[ -n $has_uncommitted_changes ]]
      then
        msg "  • Restaurando cambios sin confirmar."
        git stash pop > /dev/null 2>&1
      fi
    fi

    msg "  ✅ Rama ${GREEN}$git_master_branch${NC} actualizada"
    msg --blank
  fi
}
