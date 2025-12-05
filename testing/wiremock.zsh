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
            msg "Usage: wiremock_run_server [OPTIONS]"
            msg "Start a WireMock standalone server for API mocking and testing."
            msg --blank
            msg "Optional:"
            msg "  -p, --port PORT             Port number for the server (default: 8000)"
            msg "                              Must be between 1 and 65535"
            msg "  -j, --jar PATH              Path to the WireMock standalone JAR file"
            msg "                              Default: ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar"
            msg "  -s, --stubs PATH            Path to the directory containing WireMock stubs"
            msg "                              Default: ./src/main/resources/stubs/"
            msg "  -r, --reset                 Reset all stubs and request logs on the server"
            msg "  -h, --help                  Show this help"
            msg --blank
            msg "Server Features:"
            msg "  • Stub-based request matching and response generation"
            msg "  • Global response templating enabled"
            msg "  • CORS support for cross-origin requests"
            msg "  • Verbose logging for debugging"
            msg "  • Admin API for runtime configuration"
            msg --blank
            msg "Default Paths:"
            msg "  JAR File:     ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar"
            msg "  Stubs Dir:    ./src/main/resources/stubs/"
            msg --blank
            msg "Admin Endpoints (when server is running):"
            msg "  Health:       GET  http://localhost:<port>/__admin/health"
            msg "  Mappings:     GET  http://localhost:<port>/__admin/mappings"
            msg "  Settings:     GET  http://localhost:<port>/__admin/settings"
            msg "  Reset:        POST http://localhost:<port>/__admin/reset"
            msg "  Requests:     GET  http://localhost:<port>/__admin/requests"
            msg --blank
            msg "Examples:"
            msg "  wiremock_run_server                    # Start on default port 8000"
            msg "  wiremock_run_server --port 9090        # Start on custom port 9090"
            msg "  wiremock_run_server --help             # Show this help"
            msg --blank
            msg "Notes:"
            msg "  • Requires Java to be installed and available in PATH"
            msg "  • Server runs in foreground - use Ctrl+C to stop"
            msg "  • Stubs are loaded from the configured directory on startup"
            return 0
            ;;
        *)
            msg "Unexpected argument $1" --error --to-stderr
            return 1
            ;;
        esac
    done

    # Validate that the port is a number
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        msg "Port must be a number between 1 and 65535" --error
        return 1
    fi

    if [ ! -f "$jarWiremock" ]; then
        msg "WireMock JAR file not found at $jarWiremock." --error
        return 1
    fi
    
    if [ ! -d "$stubsPath" ]; then
        msg "Stubs directory not found at $stubsPath." --error
        return 1
    fi

    if [ "$reset" = true ]; then
        run_with_spinner --command "curl -X POST 'http://localhost:$port/__admin/reset'" \
            --message "Resetting WireMock server stubs and requests..." \
            --model 'hamburger' \
            --delay 0.25
        return 0
    fi

    msg --blank
    msg "${CYAN}🚀 Starting WireMock Mock Server on port $port...${NC}"
    msg "${CYAN}🚀 Starting WireMock Mock Server...${NC}"
    msg "${YELLOW}   - Port: ${WHITE}$port${NC}"
    msg "${YELLOW}   - Stubs directory: ${WHITE}$stubsPath${NC}"
    msg "${YELLOW}   - WireMock JAR: ${WHITE}$jarWiremock${NC}"
    msg --blank

    msg "${GREEN}✅ All files verified successfully!${NC}"
    msg "${BLUE}Launching WireMock server...${NC}"
    msg --blank
    msg "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━ 📡 SERVER ENDPOINTS ━━━━━━━━━━━━━━━━━━━━━━${NC}"
    msg "${CYAN}Main Server:    ${WHITE}curl -X GET http://localhost:$port${NC}"
    msg "${CYAN}Health Check:   ${WHITE}curl -X GET http://localhost:$port/__admin/health${NC}"
    msg "${CYAN}All Mappings:   ${WHITE}curl -X GET http://localhost:$port/__admin/mappings${NC}"
    msg "${CYAN}Settings:       ${WHITE}curl -X GET http://localhost:$port/__admin/settings${NC}"
    msg "${CYAN}Reset Server:   ${WHITE}curl -X POST http://localhost:$port/__admin/reset${NC}"
    msg "${CYAN}Request Log:    ${WHITE}curl -X GET http://localhost:$port/__admin/requests${NC}"
    msg "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    msg --blank

    # Run WireMock
    java -jar "$jarWiremock" \
        --disable-banner \
        --root-dir="$stubsPath" \
        --verbose \
        --global-response-templating \
        --enable-stub-cors \
        --port $port

    msg --blank
    msg "${YELLOW}👋 WireMock server has stopped.${NC}"
}
