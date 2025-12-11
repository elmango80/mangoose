# Testing Functions

Funciones para testing y mocking de APIs.

## Archivos

### wiremock.zsh

Gestión de servidor WireMock para mocking de APIs.

## Función Principal

### wiremock_run_server (alias: run:wiremock)

Inicia un servidor WireMock standalone para mocking y testing de APIs.

```zsh
wiremock_run_server [OPTIONS]
```

## Opciones

```zsh
-p, --port PORT      # Puerto del servidor (default: 8000)
-j, --jar PATH       # Ruta al JAR de WireMock
-s, --stubs PATH     # Ruta al directorio de stubs
-r, --reset          # Resetear stubs y logs
-h, --help           # Mostrar ayuda
```

## Configuración por Defecto

```zsh
Puerto:     8000
JAR:        ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar
Stubs Dir:  ./src/main/resources/stubs/
```

## Ejemplos de Uso

```zsh
# Puerto por defecto
wiremock_run_server

# Puerto personalizado
wiremock_run_server --port 9090

# JAR y stubs personalizados
wiremock_run_server \
  --jar /path/to/wiremock.jar \
  --stubs /path/to/stubs

# Con reset de stubs
wiremock_run_server --reset

# Usando alias
run:wiremock
```

## Admin API Endpoints

Una vez corriendo, disponibles en:

| Endpoint            | Método | Descripción           |
| ------------------- | ------ | --------------------- |
| `/__admin/health`   | GET    | Estado del servidor   |
| `/__admin/mappings` | GET    | Listado de mappings   |
| `/__admin/settings` | GET    | Configuración         |
| `/__admin/reset`    | POST   | Resetear stubs        |
| `/__admin/requests` | GET    | Historial de requests |

### Ejemplos de Admin API

```zsh
# Verificar salud
curl http://localhost:8000/__admin/health

# Ver mappings
curl http://localhost:8000/__admin/mappings

# Resetear servidor
curl -X POST http://localhost:8000/__admin/reset

# Ver requests recibidos
curl http://localhost:8000/__admin/requests
```

## Estructura de Stubs

Los stubs en formato JSON:

```json
{
  "request": {
    "method": "GET",
    "url": "/api/users"
  },
  "response": {
    "status": 200,
    "body": "{\"users\": []}",
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

## Características del Servidor

- ✅ Response Templating habilitado
- ✅ CORS Support
- ✅ Verbose Logging
- ✅ Admin API
- ✅ Stub Matching

## Dependencias

Requiere:

- `core/print.zsh` - Para mensajes
- `core/utils.zsh` - Para validación
- Java - Instalado en PATH
- WireMock JAR - Standalone

## Uso

Este módulo se carga automáticamente si instalaste con el script de instalación.

Para uso manual:

```zsh
source ~/mangoose/testing/wiremock.zsh
```

## Alias Relacionado

Definido en `aliases/aliases.zsh`:

```zsh
run:wiremock    # wiremock_run_server
```

## Control del Servidor

- **Iniciar**: Ejecutar comando
- **Detener**: `Ctrl+C`
- **Logs**: Verbose en terminal

## Validaciones

- ✅ Puerto válido (1-65535)
- ✅ Existencia del JAR
- ✅ Existencia del directorio de stubs

## Casos de Uso

### Desarrollo Local

```zsh
# Iniciar mock server para desarrollo
wiremock_run_server --port 8080

# Tu app apunta a http://localhost:8080
```

### Testing de Integración

```zsh
# Iniciar con stubs específicos
wiremock_run_server \
  --stubs ./test/fixtures/stubs \
  --port 9000

# Ejecutar tests
npm test
```

### Debugging

```zsh
# Ver todos los requests recibidos
curl http://localhost:8000/__admin/requests | jq

# Ver mappings activos
curl http://localhost:8000/__admin/mappings | jq
```

## Recursos

- [WireMock Documentation](http://wiremock.org/docs/)
- [Admin API Reference](http://wiremock.org/docs/api/)
- [Request Matching](http://wiremock.org/docs/request-matching/)
- [Response Templating](http://wiremock.org/docs/response-templating/)
