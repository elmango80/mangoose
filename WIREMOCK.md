# WireMock Functions (wiremock.zsh)

Funciones para gestionar servidores WireMock para mocking de APIs.

## 🎭 wiremock_run_server

Inicia un servidor WireMock standalone para mocking y testing de APIs.

### Uso

```bash
wiremock_run_server [OPTIONS]
```

### Opciones

- `-p, --port PORT` - Puerto del servidor (default: 8000)
- `-j, --jar PATH` - Ruta al JAR de WireMock standalone
- `-s, --stubs PATH` - Ruta al directorio de stubs
- `-r, --reset` - Resetear stubs y logs en el servidor
- `-h, --help` - Muestra ayuda

### Configuración por Defecto

```bash
Puerto:     8000
JAR:        ./src/main/resources/stubs/wiremock-standalone-3.9.2.jar
Stubs Dir:  ./src/main/resources/stubs/
```

### Ejemplos

```bash
# Iniciar en puerto por defecto
wiremock_run_server

# Puerto personalizado
wiremock_run_server --port 9090

# JAR y stubs personalizados
wiremock_run_server --jar /path/to/wiremock.jar --stubs /path/to/stubs

# Con reset de stubs
wiremock_run_server --reset

# Ver ayuda
wiremock_run_server --help
```

### Características del Servidor

El servidor WireMock se inicia con:

- ✅ **Response Templating** - Plantillas globales habilitadas
- ✅ **CORS Support** - Soporte para peticiones cross-origin
- ✅ **Verbose Logging** - Logging detallado para debugging
- ✅ **Admin API** - API de administración en runtime
- ✅ **Stub Matching** - Matching basado en stubs y generación de respuestas

### Admin Endpoints

Una vez el servidor está corriendo, puedes usar estos endpoints de administración:

| Endpoint            | Método | Descripción                |
| ------------------- | ------ | -------------------------- |
| `/__admin/health`   | GET    | Estado del servidor        |
| `/__admin/mappings` | GET    | Listado de mappings        |
| `/__admin/settings` | GET    | Configuración del servidor |
| `/__admin/reset`    | POST   | Resetear stubs y requests  |
| `/__admin/requests` | GET    | Historial de requests      |

### Ejemplos de Endpoints Admin

```bash
# Verificar salud del servidor
curl http://localhost:8000/__admin/health

# Ver todos los mappings
curl http://localhost:8000/__admin/mappings

# Resetear el servidor
curl -X POST http://localhost:8000/__admin/reset

# Ver requests recibidos
curl http://localhost:8000/__admin/requests
```

### Estructura de Stubs

Los stubs deben estar en el directorio especificado (por defecto `./src/main/resources/stubs/`) en formato JSON:

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

### Validaciones

La función valida:

- ✅ Puerto válido (1-65535)
- ✅ Existencia del archivo JAR
- ✅ Existencia del directorio de stubs

### Mensajes de Error

#### JAR no encontrado

```
WireMock JAR file not found at <path>
```

#### Directorio de stubs no encontrado

```
Stubs directory not found at <path>
```

#### Puerto inválido

```
Port must be a number between 1 and 65535
```

### Alias

```bash
run:wiremock    # Atajo para wiremock_run_server
```

### Requisitos

- **Java** - Debe estar instalado y disponible en PATH
- **WireMock JAR** - Archivo standalone de WireMock
- **Stubs** - Directorio con definiciones de stubs (opcional)

### Control del Servidor

- **Iniciar**: Ejecuta el comando
- **Detener**: Presiona `Ctrl+C`
- **Logs**: Se muestran en la terminal (verbose)

### 📝 Notas

- El servidor corre en **foreground** - usa `Ctrl+C` para detenerlo
- Los stubs se cargan automáticamente al iniciar
- Los cambios en stubs requieren reiniciar el servidor
- Útil para desarrollo local sin dependencias de servicios externos
- Perfecto para testing de integración
- Los logs verbose ayudan en debugging de requests/responses

### Versión de WireMock

La configuración por defecto usa **WireMock 3.9.2**. Puedes usar otras versiones especificando la ruta al JAR con `--jar`.

### Recursos

- [WireMock Documentation](http://wiremock.org/docs/)
- [WireMock Admin API](http://wiremock.org/docs/api/)
- [Request Matching](http://wiremock.org/docs/request-matching/)
- [Response Templating](http://wiremock.org/docs/response-templating/)
