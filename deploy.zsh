#!/bin/zsh

# Función para desplegar servicios en Quicksilver a múltiples entornos
function deploy() {
  local VERSION=""
  local SERVICE=""
  local SERVICE_ID=""
  local DRY_RUN=false
  local SPECIFIC_VERSION=""
  
  # Función interna para mostrar ayuda
  show_help() {
    msg "Usage: deploy <service>[@version] [OPTIONS]"
    msg "Realiza deployment en Quicksilver de servicios a múltiples entornos."
    msg --blank
    msg "Argumentos:"
    msg "  <service>                   Servicio a desplegar"
    msg "  [@version]                  (Opcional) Versión específica o 'latest'"
    msg --blank
    msg "Opciones:"
    msg "  --dry-run                   Modo simulación sin ejecutar deployments reales"
    msg "  -h, --help                  Muestra esta ayuda"
    msg --blank
    msg "Servicios disponibles:"
    msg "  security                    Servicio de seguridad"
    msg "  login                       Servicio de login"
    msg --blank
    msg "Entornos de despliegue:"
    msg "  1. DEVELOPMENT"
    msg "  2. DEVELOPMENT Contact Center"
    msg "  3. QUALITY ASSURANCE"
    msg "  4. QUALITY ASSURANCE Contact Center"
    msg "  5. STAGING"
    msg "  6. STAGING Contact Center"
    msg --blank
    msg "Ejemplos:"
    msg "  deploy security                        # Lista versiones y selecciona interactivamente"
    msg "  deploy security@latest                 # Despliega última versión disponible"
    msg "  deploy security@0.52.1                 # Despliega versión específica"
    msg "  deploy login@0.52.1 --dry-run          # Simula deployment sin ejecutar"
    msg "  deploy --help                          # Muestra esta ayuda"
    msg --blank
    msg "Notas:"
    msg "  • Sin @version: Muestra selector interactivo de versiones"
    msg "  • Con @latest: Despliega automáticamente la última versión"
    msg "  • Con @version específica: Valida y despliega esa versión"
    msg "  • Modo --dry-run: Simula el proceso sin hacer cambios reales"
    msg --blank
    msg "Cómo obtener el token CSRF:"
    msg "  1. Ejecuta: qs-login (abre Quicksilver en el navegador)"
    msg "  2. Inicia sesión con tus credenciales"
    msg "  3. Abre DevTools (Cmd+Option+I) > Application > Cookies"
    msg "  4. Copia el valor de 'csrftoken'"
  }
  
  # Verificar --help como primer argumento (sin servicio)
  if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_help
    return 0
  fi
  
  # Verificar que se pasó al menos un argumento
  if [ $# -eq 0 ]; then
    msg "Se requiere especificar el servicio" --error
    msg "Usa 'deploy --help' para más información"
    return 1
  fi
  
  # Parsear el primer argumento (service[@version])
  local SERVICE_ARG="$1"
  shift
  
  # Extraer servicio y versión (si existe)
  if [[ "$SERVICE_ARG" == *"@"* ]]; then
    SERVICE="${SERVICE_ARG%%@*}"
    SPECIFIC_VERSION="${SERVICE_ARG##*@}"
  else
    SERVICE="$SERVICE_ARG"
    SPECIFIC_VERSION=""
  fi
  
  # Validar el servicio
  case "$SERVICE" in
    security)
      SERVICE_ID=2701
      ;;
    login)
      SERVICE_ID=2700
      ;;
    *)
      msg "Error: Servicio desconocido '$SERVICE'" --error
      msg "Usa 'deploy --help' para ver los servicios disponibles"
      return 1
      ;;
  esac
  
  # Parsear flags adicionales
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --help|-h)
        show_help
        return 0
        ;;
      *)
        msg "Parámetro desconocido: $1" --error
        msg "Usa 'deploy --help' para más información"
        return 1
        ;;
    esac
  done
  
  local QUICKSILVER_URL="https://quicksilver-es.prod.ok-cloud.net/login/?next=/cd/react-api/check-auth-status/"
  local CSRF_TOKEN=""
  local SESSION_ID=""

  msg "Abriendo Quicksilver en el navegador..." --info
  msg --blank
  msg "Pasos para obtener tus tokens:" --dim
  msg "1. Inicia sesión con tus credenciales de Santander" --dim --tab 1
  msg "2. Una vez autenticado, abre las DevTools (Cmd+Option+I)" --dim --tab 1
  msg "3. Ve a la pestaña 'Application' > 'Cookies'" --dim --tab 1
  msg "4. Busca y copia estos valores:" --dim --tab 1
  msg "   • csrftoken" --dim --tab 2
  msg "   • sessionid" --dim --tab 2
  msg --blank
  
  # Abrir en el navegador predeterminado
  open "$QUICKSILVER_URL"

  # Solicitar cookies al usuario
  msg "Token: " --no-newline
  read CSRF_TOKEN
  
  msg "ID de la sesión: " --no-newline
  read SESSION_ID

  if [[ -z "$CSRF_TOKEN" ]] || [[ -z "$SESSION_ID" ]]; then
    msg "Error: Debes proporcionar ambos datos" --error
    return 1
  fi

  # Array asociativo de entornos a desplegar
  declare -A ENVIRONMENTS=(
    [1858]="DEVELOPMENT"
    [1906]="DEVELOPMENT Contact Center"
    [1891]="QUALITY ASSURANCE"
    [1907]="QUALITY ASSURANCE Contact Center"
    [1892]="STAGING"
    [1909]="STAGING Contact Center"
  )
  
  # Orden de despliegue (IDs de entorno)
  local DEPLOYMENT_ORDER=(1858 1906 1891 1907 1892 1909)
  
  # Determinar el modo de operación según si se especificó versión
  if [ -n "$SPECIFIC_VERSION" ]; then
    # Modo con versión específica: service@latest o service@0.52.1
    if [ "$SPECIFIC_VERSION" = "latest" ]; then
      VERSION="latest"
      local DESCRIPTION="deploy latest version"
    else
      VERSION="$SPECIFIC_VERSION"
      local DESCRIPTION="deploy v$VERSION"
    fi
  else
    # Modo sin versión: security (listar y seleccionar)
    # Obtener versiones disponibles (usando el primer entorno como referencia)
    local FIRST_ENV="${DEPLOYMENT_ORDER[1]}"
    local VERSIONS_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "https://quicksilver-es.prod.ok-cloud.net/cd/api/versions/$SERVICE_ID/$FIRST_ENV" \
      -H 'accept: application/json, text/plain, */*' \
      -H 'accept-language: en-US,en;q=0.9,es;q=0.8' \
      -H 'priority: u=1, i' \
      -b "csrftoken=$CSRF_TOKEN; sessionid=$SESSION_ID")

    # Extraer el código HTTP
    local VERSIONS_HTTP_STATUS=$(echo "$VERSIONS_RESPONSE" | grep "HTTP_STATUS" | cut -d: -f2)
    local VERSIONS_BODY=$(echo "$VERSIONS_RESPONSE" | sed '/HTTP_STATUS/d')

    # Verificar si la llamada fue exitosa
    if [ "$VERSIONS_HTTP_STATUS" = "000" ]; then
      msg "Error de conexión" --error
      msg "No se pudo conectar al servidor de Quicksilver." --error --no-icon
      msg "Verifica que estas conectado a la VPN y que el servidor esta accesible" --dim
      return 1
    elif [ "$VERSIONS_HTTP_STATUS" = "401" ] || [ "$VERSIONS_HTTP_STATUS" = "403" ]; then
      msg "Token CSRF inválido o expirado" --error
      msg "El token de autenticación ha expirado o es inválido." --dim
      msg "Por favor, obtén un nuevo token CSRF y actualiza el script." --dim
      return 1
    elif [ "$VERSIONS_HTTP_STATUS" != "200" ]; then
      msg "Error al obtener versiones disponibles" --error
      msg "Status: $VERSIONS_HTTP_STATUS" --dim
      return 1
    fi

    # Extraer el array de versiones y convertirlo a lista
    local -a VERSIONS
    VERSIONS=($(echo "$VERSIONS_BODY" | grep -o '"versions":\s*\[[^]]*\]' | sed 's/"versions":\s*\[//g' | sed 's/\]//g' | tr ',' '\n' | sed 's/"//g' | sed 's/^ *//g' | head -10))

    if [ ${#VERSIONS[@]} -eq 0 ]; then
      msg "No se encontraron versiones disponibles" --warning
      msg --blank
      msg "Response recibido:"
      msg "$VERSIONS_BODY"
      return 1
    fi

    # Usar la función select_option para elegir la versión
    msg "Versiones más recientes disponibles:"
    select_option "${VERSIONS[@]}"
    local SELECTED=$?
    
    # Obtener la versión seleccionada
    VERSION="${VERSIONS[$SELECTED]}"
    local DESCRIPTION="deploy -v$VERSION"
  fi

  if [ "$DRY_RUN" = true ]; then
    msg "=======================================" --warning --no-icon
    msg "Iniciando deployment (MODO DRY-RUN)" --warning --tab 1 --no-icon
    msg "=======================================" --warning --no-icon
  else
    msg "============================" --info --no-icon
    msg "Iniciando deployment" --info --tab 2 --no-icon
    msg "============================" --info --no-icon
  fi
  msg "Servicio: $SERVICE"
  msg "Versión seleccionada: $VERSION"
  msg "Descripción: $DESCRIPTION"
  msg --blank

  # Iterar sobre cada entorno en el orden especificado
  local -a FAILED_DEPLOYMENTS
  local -a SUCCESSFUL_DEPLOYMENTS
  local ABORT_DEPLOY=false
  FAILED_DEPLOYMENTS=()
  SUCCESSFUL_DEPLOYMENTS=()

  for ENV_ID in "${DEPLOYMENT_ORDER[@]}"; do
    local ENV_NAME="${ENVIRONMENTS[$ENV_ID]}"
    if [ "$DRY_RUN" = true ]; then
      run_with_spinner --command "sleep 1" --message "Desplegando en $ENV_NAME"
      # Modo dry-run: solo mostrar lo que se haría
      msg "Payload: {" --tab 1 --dim
      msg "application: 138" --tab 2 --dim 
      msg "service: $SERVICE_ID" --tab 2 --dim
      msg "environment: $ENV_ID" --tab 2 --dim
      msg "version: $VERSION" --tab 2 --dim
      msg "description: $DESCRIPTION" --tab 2 --dim
      msg "}" --tab 1 --dim
      SUCCESSFUL_DEPLOYMENTS+=("$ENV_NAME (dry-run)")
    else
      # Modo normal: ejecutar el deployment real
      local RESPONSE=$(run_with_spinner \
        --message "Desplegando en $ENV_NAME" \
        --command "curl -s -w '\nHTTP_STATUS:%{http_code}' 'https://quicksilver-es.prod.ok-cloud.net/cd/api/deployment/new' \
          -H 'accept-language: en-US,en;q=0.9,es;q=0.8' \
          -H 'accept: application/json, text/plain, */*' \
          -H 'content-type: application/json' \
          -H 'origin: https://quicksilver-es.prod.ok-cloud.net' \
          -H 'priority: u=1, i' \
          -H 'referer: https://quicksilver-es.prod.ok-cloud.net/deployment/new' \
          -H 'x-csrftoken: $CSRF_TOKEN' \
          -b 'csrftoken=$CSRF_TOKEN; sessionid=$SESSION_ID' \
          --data-raw '{\"application\":138,\"service\":$SERVICE_ID,\"environment\":$ENV_ID,\"version\":\"$VERSION\",\"description\":\"$DESCRIPTION\",\"flyway_mode\":\"disabled\",\"form_kind\":\"StepFunctions\"}'")
      
      # Extraer el código HTTP
      local HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS" | cut -d: -f2)
      local BODY=$(echo "$RESPONSE" | sed '/HTTP_STATUS/d')

      # Analizar el tipo de error
      if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
        SUCCESSFUL_DEPLOYMENTS+=("$ENV_NAME")
      elif [ "$HTTP_STATUS" = "000" ]; then
        ABORT_DEPLOY=true
        FAILED_DEPLOYMENTS+=("$ENV_NAME")
        msg "No se pudo conectar al servidor de Quicksilver." --error --no-icon --tab 1
        msg "Verifica que estas conectado a la VPN y que el servidor esta accesible" --dim --tab 1
        break
      else
        FAILED_DEPLOYMENTS+=("$ENV_NAME")
        # Detectar errores específicos
        if [ "$HTTP_STATUS" = "401" ] || [ "$HTTP_STATUS" = "403" ]; then
          ABORT_DEPLOY=true
          msg "Token CSRF inválido o expirado" --error
          msg "El token de autenticación ha expirado o es inválido." --dim
          msg "Por favor, obtén un nuevo token CSRF y actualiza el script." --dim
          break
        else
          msg "Error en deployment en $ENV_NAME" --error
          msg "Status: $HTTP_STATUS" --dim
        fi
      fi
      
      # Si hubo un error crítico (401/403), no continuar
      if [[ $ABORT_DEPLOY = true ]]; then
        break
      fi
    fi
  done

  if [[ $ABORT_DEPLOY = true ]]; then
    return 1
  fi

  msg --blank
  msg "Resumen de Deployments" --tab 1
  msg "=========================="
  msg "Exitosos: ${#SUCCESSFUL_DEPLOYMENTS[@]}" --success
  if [ ${#SUCCESSFUL_DEPLOYMENTS[@]} -gt 0 ]; then
    for ENV in "${SUCCESSFUL_DEPLOYMENTS[@]}"; do
      msg "  - $ENV"
    done
  fi
  msg --blank
  msg "Fallidos: ${#FAILED_DEPLOYMENTS[@]}" --error
  if [ ${#FAILED_DEPLOYMENTS[@]} -gt 0 ]; then
    for ENV in "${FAILED_DEPLOYMENTS[@]}"; do
      msg "  - $ENV"
    done
  fi
  msg "========================================"
}
