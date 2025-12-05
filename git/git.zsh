#!/bin/zsh
# Funciones de Git para gestión de repositorios

function is_git_repository() {
  if [[ ! -d ".git" ]]
  then
    msg "Not found a git repository in ${BOLD}${ITALIC}$(pwd)${NC}" --error --to-stderr
    return 1
  fi

  return 0
}

function clean_repository() {
  local dry_run=0
  local demo_mode=0

  # Procesar parámetros
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        dry_run=1
        ;;
      --demo|-d)
        demo_mode=1
        ;;
      --help|-h)
        printf "${GREEN}clean_repository${NC} - Clean stale branches that have been deleted from remote\n"
        printf "\n"
        printf "${BOLD}USAGE:${NC}\n"
        printf "  clean_repository [OPTIONS]\n"
        printf "\n"
        printf "${BOLD}OPTIONS:${NC}\n"
        printf "  ${YELLOW}--dry-run${NC}    Show which branches would be deleted without actually deleting them\n"
        printf "  ${YELLOW}--demo, -d${NC}   Simulate branch deletion with sleep (for testing purposes)\n"
        printf "  ${YELLOW}--help, -h${NC}   Show this help message\n"
        printf "\n"
        printf "${BOLD}DESCRIPTION:${NC}\n"
        printf "  This function identifies local branches that have been deleted from the remote\n"
        printf "  repository and removes them from your local repository. It will:\n"
        printf "  • Fetch and prune remote references\n"
        printf "  • Identify branches with 'gone' tracking status\n"
        printf "  • Delete stale branches (except current branch)\n"
        printf "  • Prompt before deleting current branch if it's also stale\n"
        printf "\n"
        printf "${BOLD}EXAMPLES:${NC}\n"
        printf "  clean_repository                  # Clean stale branches\n"
        printf "  clean_repository --dry-run        # Preview what would be deleted\n"
        printf "  clean_repository --demo           # Simulate deletion for testing\n"
        printf "  clean_repository --demo --dry-run # Preview then simulate\n"
        return 0
        ;;
      *)
        msg "Unexpected argument $1" --error --to-stderr
        msg "Use --help for usage information" --info
        return 1
        ;;
    esac
    shift
  done

  if is_git_repository
  then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    local current_branch=$(git branch --show-current)
    local git_master_branch=$(git_main_branch)
    
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
      msg "No stale branches found in $repo_name" --success
      return 0
    fi

    if [[ $dry_run -eq 1 ]]; then
      msg "Branches that would be deleted in ${ITALIC}$repo_name${NC}" --info
      if [[ $current_branch_is_stale -eq 1 ]]; then
        msg "The current branch has been deleted from remote" --warning 
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
      msg "Running in ${YELLOW}DEMO MODE${NC} - branches will not be actually deleted" --warning
      msg --blank
    fi

    # Eliminar primero las otras ramas
    if [[ -n "$other_stale_branches" ]]; then
      msg "🗑️ Remove stale branches in ${GREEN}$repo_name${NC}"
      echo -e "$other_stale_branches" | while read branch; do
        if [[ -n "$branch" ]]; then
          if [[ $demo_mode -eq 1 ]]; then
            run_with_spinner --command "sleep 3" --message "Deleting branch ${RED}$branch${NC}" --no-newline
          else
            run_with_spinner --command "git branch -D \"$branch\"" --message "Deleting branch ${RED}$branch${NC}" --no-newline
          fi
          msg "\r${GREEN}✓ Deleted branch ${RED}$branch${NC} "
        fi
      done
    fi

    # Manejar la rama actual si también está eliminada del remoto
    if [[ $current_branch_is_stale -eq 1 ]]; then
      msg --blank
      msg "${YELLOW}Warning: Your current branch has also been deleted from remote.${NC}" --warning
      msg "Do you want to delete the current branch and switch to ${GREEN}${ITALIC}$git_master_branch${NC}? (y/N): "
      
      answer=$(read_single_char)
      
      if [[ $answer == "y" ]]; then
        if [[ $demo_mode -eq 0 ]]; then
          msg "  • Switching to ${GREEN}$git_master_branch${NC} branch"
          git switch $git_master_branch > /dev/null 2>&1
        fi

        if [[ $demo_mode -eq 1 ]]; then
          run_with_spinner --command "sleep 3" --message "Deleting branch ${RED}$current_branch${NC}" --no-newline
        else
          run_with_spinner --command "git branch --delete --force \"$current_branch\"" --message "Deleting branch ${RED}$current_branch${NC}" --no-newline
        fi
        msg "\r${GREEN}✓ Deleted branch ${RED}$current_branch${NC} "
      fi
    fi

    if [[ -n "$other_stale_branches" || $current_branch_is_stale -eq 1 ]]; then
      msg "Cleanup completed for ${BOLD_CYAN}$repo_name${NC}" --success
    fi
  fi
}

function clean_repositories() {
  printf "${GREEN}Cleaning repositories...${NC}\n"
  for d in */
  do
    if [[ -d "$d/.git" ]]
    then
      printf "Processing ${CYAN}$d${NC}\n"
      cd "$d"
      clean_repository
      cd ..
    fi
  done
  printf "🎉 All repositories cleaned\n"
}

function update_master_repo() {
  local git_master_branch=$(git_main_branch)
  local repository_name=$(is_git_repository)

  if is_git_repository; then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    printf "🚀 Star update master of ${GREEN}$repo_name${NC}\n"

    git fetch origin $git_master_branch > /dev/null 2>&1
    local has_remote_changes=$(git diff $git_master_branch origin/$git_master_branch --quiet || echo "changes")
    if [[ -n $has_remote_changes ]]
    then
      local current_branch=$(git branch --show-current)
      printf "   Current branch ${GREEN}$current_branch${NC}\n"

      local has_uncommitted_changes=$(git status --porcelain)
      if [[ -n $has_uncommitted_changes ]]
      then
        printf "  • ${YELLOW}Stashing uncommitted changes${NC}\n"
        git stash > /dev/null 2>&1
      fi
      
      if [[ "$current_branch" != "master" && "$current_branch" != "main" ]]
      then
        printf "  • Switch to ${GREEN}master${NC} branch\n"
        git switch $git_master_branch > /dev/null 2>&1
      fi

      printf "  • Pulling changes from remote master branch\n"
      git pull origin $git_master_branch > /dev/null 2>&1

      if [[ "$current_branch" != $git_master_branch ]]
      then
        printf "  • Switch to ${GREEN}$current_branch${NC} branch\n"
        git switch "$current_branch" > /dev/null 2>&1
      fi

      if [[ -n $has_uncommitted_changes ]]
      then
        printf "  • Restore uncommitted changes.\n"
        git stash pop > /dev/null 2>&1
      fi
    fi

    printf "  ✅ Master branch already updated\n"
    printf "\n"
  fi
}

function update_master_repos() {
  printf "🔄 ${CYAN}Updating repositories...${NC}\n"
  for d in */
  do
    cd "$d"
    update_master_repo
    cd ..
  done
  printf "🎉 All repositories updated\n"
}
