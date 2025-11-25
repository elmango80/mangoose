#!/bin/zsh
# Funciones de productividad para desarrollo

function seek_and_destroy() {
  local dir_name=()
  local no_confirm=0
  local verbose=0
  local confirmation="y"

  for arg in "$@"
  do
    case $arg in
      --dir)
        current_args=dir_name
        ;;
      --no-confirm)
        no_confirm=1
        ;;
      --verbose)
        verbose=1
        ;;
      *)
        if [[ -n $current_args ]]
        then
          eval "${current_args}+=(\"$arg\")"
          current_args=""
        else
          msg "Unexpected value $arg" --error
          return 1
        fi
        ;;
    esac
  done

  while [[ -z $dir_name ]]; do
    msg "Please enter the target directory: "
    read dir_name
    if [[ -z $dir_name ]]
    then
      return
    fi
  done

  tempfile=$(mktemp)

  find . -name "$dir_name" -maxdepth 2 -type d | while IFS= read -r dir
  do
    size=$(du -sm "$dir" | cut -f1)
    human_readable_size=$(du -sh "$dir" | cut -f1)

    if (( verbose == 1 ))
    then
      if (( size > 1000 ))
      then
        msg "${RED}${human_readable_size}${NC}\t$dir"
      elif (( size >= 256 && size <= 1000 ))
      then
        msg "${YELLOW}${human_readable_size}${NC}\t$dir"
      elif (( size < 256 ))
      then
        msg "${GREEN}${human_readable_size}${NC}\t$dir"
      else
        msg "$human_readable_size\t$dir"
      fi
    fi
    
    printf "%s\n" "$dir" >> "$tempfile"
  done

  if [[ ! -s "$tempfile" ]]
  then
    if (( verbose == 1 ))
    then
      msg "No such '$dir_name' directory." --error
    fi

    return 0
  fi


  if (( no_confirm == 0 ))
  then
    printf "Delete the found directories? (Y/n): "
    confirmation=$(read_single_char)
  fi
  
  if [[ $confirmation == "y" ]]; then
    while IFS= read -r dir
    do
      run_with_spinner --command "rm -rf $dir" --message "Deleting $dir"
    done < "$tempfile"
  else
    rm "$tempfile"
    return 0
  fi

  rm "$tempfile"
}

function goto() {
  local work_path="$HOME/$CODE_DIR/$WORK_DIR"
  local target_path=""
  local repository=""
  local subdir=""
  local vertical=$(echo $1 | cut -d':' -f1)
  local project=$(echo $1 | cut -d':' -f2)
  shift                                       # Elimina el primer argumento para procesar los siguientes
  local params=("$@")                         # Captura todos los parámetros restantes
  for param in "${params[@]}"                 # Examina los parámetros
  do
    case $param in
      --app)
        subdir="app"
        ;;
      *)
        msg "Unknown parameter: $param" --error
        ;;
    esac
  done

  case $project in
    *base)
      repository="ods-dcw-ui-${vertical}-base"
      ;;
    *mc)
      repository="ods-dcw-ods-ui-${vertical}-mc"
      ;;
    *)
      msg "Please specify the repository you want to go to" --error
      return 1
      ;;
  esac

  target_path="${work_path}/${repository}"

  if [[ ! -d "$target_path" ]]
  then
    msg "Repository ${repository} does not exist" --error
    return 1
  fi

  if [[ -n "$subdir" ]]
  then
    target_path="${target_path}/${subdir}"

    if [[ ! -d "$target_path" ]]
    then
      msg "Subdirectory ${subdir} does not exist in repository ${repository}" --error
      return 1
    fi
  fi

  cd "$target_path"
}

function phoenix() {
  local hard_mode=0

  # Procesar parámetros
  while [[ $# -gt 0 ]]; do
    case $1 in
      --hard)
        hard_mode=1
        ;;
      *)
        msg "Unexpected argument $1" --error
        return 1
        ;;
    esac
    shift
  done

  if [[ ! -f "package.json" ]]
  then
    msg "The package.json file was not found in the current folder." --error
    return 1
  fi

  if [[ $hard_mode -eq 1 ]]; then
    msg --blank
    msg "${RED_BRIGHT}============================${NC}"
    msg "${RED_BRIGHT}*   RUNNING IN HARD MODE   *${NC}"
    msg "${RED_BRIGHT}============================${NC}"
    msg --blank
  fi

  seek_and_destroy --dir node_modules --no-confirm
  seek_and_destroy --dir dist --no-confirm
  seek_and_destroy --dir .yalc --no-confirm
  
  # Si está en modo hard, limpiar también la caché de yarn
  if [[ $hard_mode -eq 1 ]]; then
    msg "Removing all linked projects" --warning
    yalc remove --all
    msg "Cleaning yarn cache" --warning
    yarn cache clean
    msg "Deleting yarn.lock" --warning
    rm -f yarn.lock
  fi
  
  yarn install

  msg "${RGB_SUNSET}🔥  The phoenix has been reborn${NC}"
}
