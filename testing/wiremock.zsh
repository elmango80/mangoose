#!/bin/zsh

function wiremock_run_server() {
    local port=8000
    local jarWiremock="./src/main/resources/stubs/wiremock-standalone-3.9.2.jar"
    local stubsPath="./src/main/resources/stubs/"
    local reset=false

    # Procesar parámetros
    while [[ $# -gt 0 ]]; do
        case $1 in
        --port|-p)
            if port=$(extract_arg_value "--port" "$2"); then
                shift 2
            else
                return 1
            fi
            ;;
        --jar|-j)
            if jarWiremock=$(extract_arg_value "--jar" "$2"); then
                shift 2
            else
                return 1
            fi
            ;;
        --stubs|-s)
            if stubsPath=$(extract_arg_value "--stubs" "$2"); then
                shift 2
            else
                return 1
            fi
            ;;
        --reset|-r)
            reset=true
            shift
            ;;
        --help|-h)
            msg "Uso: wiremock_run_server [OPCIONES]"
            msg "Inicia un servidor WireMock standalone para mocking y testing de APIs."
            msg --blank
            msg "Opcional:"
            msg "  -p, --port PUERTO           Número de puerto para el servidor (por defecto: 8000)"
            msg "                              Debe estar entre 1 y 65535"
            msg "  -j, --jar RUTA              Ruta al archivo JAR standalone de WireMock"
            msg "                              Por defecto: ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar"
            msg "  -s, --stubs RUTA            Ruta al directorio que contiene los stubs de WireMock"
            msg "                              Por defecto: ./src/main/resources/stubs/"
            msg "  -r, --reset                 Reiniciar todos los stubs y logs de peticiones en el servidor"
            msg "  -h, --help                  Mostrar esta ayuda"
            msg --blank
            msg "Características del Servidor:"
            msg "  • Coincidencia de peticiones y generación de respuestas basadas en stubs"
            msg "  • Plantillas de respuesta globales habilitadas"
            msg "  • Soporte CORS para peticiones de origen cruzado"
            msg "  • Registro detallado para depuración"
            msg "  • API de administración para configuración en tiempo de ejecución"
            msg --blank
            msg "Rutas por Defecto:"
            msg "  Archivo JAR:  ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar"
            msg "  Dir. Stubs:   ./src/main/resources/stubs/"
            msg --blank
            msg "Endpoints de Administración (cuando el servidor está ejecutándose):"
            msg "  Salud:        GET  http://localhost:<puerto>/__admin/health"
            msg "  Mappings:     GET  http://localhost:<puerto>/__admin/mappings"
            msg "  Ajustes:      GET  http://localhost:<puerto>/__admin/settings"
            msg "  Reiniciar:    POST http://localhost:<puerto>/__admin/reset"
            msg "  Peticiones:   GET  http://localhost:<puerto>/__admin/requests"
            msg --blank
            msg "Ejemplos:"
            msg "  wiremock_run_server                    # Iniciar en puerto por defecto 8000"
            msg "  wiremock_run_server --port 9090        # Iniciar en puerto personalizado 9090"
            msg "  wiremock_run_server --help             # Mostrar esta ayuda"
            msg --blank
            msg "Notas:"
            msg "  • Requiere Java instalado y disponible en PATH"
            msg "  • El servidor se ejecuta en primer plano - usa Ctrl+C para detener"
            msg "  • Los stubs se cargan desde el directorio configurado al iniciar"
            return 0
            ;;
        *)
            msg "Argumento inesperado $1" --error --to-stderr
            return 1
            ;;
        esac
    done

    # Validar que el puerto sea un número
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        msg "El puerto debe ser un número entre 1 y 65535" --error
        return 1
    fi

    if [ ! -f "$jarWiremock" ]; then
        msg "Archivo JAR de WireMock no encontrado en $jarWiremock." --error
        return 1
    fi
    
    if [ ! -d "$stubsPath" ]; then
        msg "Directorio de stubs no encontrado en $stubsPath." --error
        return 1
    fi

    if [ "$reset" = true ]; then
        run_with_spinner --command "curl -X POST 'http://localhost:$port/__admin/reset'" \
            --message "Reiniciando stubs y peticiones del servidor WireMock..." \
            --model 'hamburger' \
            --delay 0.25
        return 0
    fi

    msg --blank
    msg "${CYAN}🚀 Iniciando Servidor Mock WireMock en puerto $port...${NC}"
    msg "${CYAN}🚀 Iniciando Servidor Mock WireMock...${NC}"
    msg "${YELLOW}   - Puerto: ${WHITE}$port${NC}"
    msg "${YELLOW}   - Directorio de stubs: ${WHITE}$stubsPath${NC}"
    msg "${YELLOW}   - JAR de WireMock: ${WHITE}$jarWiremock${NC}"
    msg --blank

    msg "${GREEN}✅ ¡Todos los archivos verificados exitosamente!${NC}"
    msg "${BLUE}Lanzando servidor WireMock...${NC}"
    msg --blank
    msg "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━ 📡 ENDPOINTS DEL SERVIDOR ━━━━━━━━━━━━━━━━━━━━━━${NC}"
    msg "${CYAN}Servidor Principal:   ${WHITE}curl -X GET http://localhost:$port${NC}"
    msg "${CYAN}Verificación Salud:   ${WHITE}curl -X GET http://localhost:$port/__admin/health${NC}"
    msg "${CYAN}Todos los Mappings:   ${WHITE}curl -X GET http://localhost:$port/__admin/mappings${NC}"
    msg "${CYAN}Configuración:        ${WHITE}curl -X GET http://localhost:$port/__admin/settings${NC}"
    msg "${CYAN}Reiniciar Servidor:   ${WHITE}curl -X POST http://localhost:$port/__admin/reset${NC}"
    msg "${CYAN}Log de Peticiones:    ${WHITE}curl -X GET http://localhost:$port/__admin/requests${NC}"
    msg "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    msg --blank

    # Ejecutar WireMock
    java -jar "$jarWiremock" \
        --disable-banner \
        --root-dir="$stubsPath" \
        --verbose \
        --global-response-templating \
        --enable-stub-cors \
        --port $port

    msg --blank
    msg "${YELLOW}👋 El servidor WireMock se ha detenido.${NC}"
}
