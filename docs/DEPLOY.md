# Deploy Functions (deploy.zsh)

Sistema de deployment automatizado para Quicksilver.

## 🚀 deploy

Realiza deployment de servicios en Quicksilver a múltiples entornos de forma secuencial.

### Uso

```bash
deploy <service>[@version] [OPTIONS]
```

### Argumentos

- `<service>` - **REQUERIDO** - Servicio a desplegar (`security`, `login`)
- `[@version]` - **OPCIONAL** - Versión específica o `latest`

### Opciones

- `--dry-run` - Modo simulación sin ejecutar deployments reales
- `-h, --help` - Muestra ayuda

### Servicios Disponibles

| Servicio   | ID   | Descripción           |
| ---------- | ---- | --------------------- |
| `security` | 2701 | Servicio de seguridad |
| `login`    | 2700 | Servicio de login     |

### Entornos de Despliegue

Los deployments se ejecutan en este orden:

1. DEVELOPMENT (ID: 1858)
2. DEVELOPMENT Contact Center (ID: 1906)
3. QUALITY ASSURANCE (ID: 1891)
4. QUALITY ASSURANCE Contact Center (ID: 1907)
5. STAGING (ID: 1892)
6. STAGING Contact Center (ID: 1909)

### Modos de Operación

#### Sin versión especificada

Muestra un selector interactivo con las últimas versiones disponibles:

```bash
deploy security
```

El sistema:

1. Consulta las versiones disponibles
2. Muestra un selector visual
3. Permite elegir con flechas ↑/↓
4. Despliega la versión seleccionada a todos los entornos

#### Con `@latest`

Despliega automáticamente la última versión disponible:

```bash
deploy security@latest
deploy login@latest
```

#### Con versión específica

Despliega una versión concreta:

```bash
deploy security@0.52.1
deploy login@1.0.0
```

### Modo Dry-Run

Simula el proceso sin hacer cambios reales:

```bash
deploy security@0.52.1 --dry-run
```

En este modo:

- Muestra los payloads que se enviarían
- No ejecuta deployments reales
- Útil para validar configuración

### Autenticación

El script requiere tokens de autenticación de Quicksilver:

1. **CSRF Token** - Para protección CSRF
2. **Session ID** - Para autenticación de sesión

Actualmente están hardcodeados en el script (líneas 116-117):

```bash
local CSRF_TOKEN="7JK57mHx2rLFtJALYYkRWCnT3Jiebyam"
local SESSION_ID="6r5oia4o917kdjuta94fg5vrz48nbmrs"
```

#### Cómo obtener tokens

1. Ejecuta `qs-login` (abre Quicksilver en el navegador)
2. Inicia sesión con tus credenciales
3. Abre DevTools (Cmd+Option+I) → Application → Cookies
4. Copia los valores de:
   - `csrftoken`
   - `sessionid`
5. Actualiza las variables en el script

### Ejemplos

```bash
# Selector interactivo
deploy security

# Deploy de última versión
deploy security@latest

# Deploy de versión específica
deploy login@0.52.1

# Simulación
deploy security@0.52.1 --dry-run

# Ver ayuda
deploy --help
```

### Manejo de Errores

El sistema maneja diferentes tipos de errores:

#### Error 401/403

```
Token CSRF inválido o expirado
El token de autenticación ha expirado o es inválido.
Por favor, obtén un nuevo token CSRF y actualiza el script.
```

**Solución**: Actualizar los tokens en el script.

#### Error de Conexión (000)

```
Error de conexión
No se pudo conectar al servidor de Quicksilver.
Verifica que estés conectado a la VPN y que el servidor esté accesible
```

**Solución**: Conectarse a la VPN corporativa.

#### Otros Errores HTTP

Muestra el código de estado HTTP y continúa o aborta según la severidad.

### Resumen de Deployment

Al finalizar, muestra un resumen:

```
Resumen de Deployments
==========================
Exitosos: 6
  - DEVELOPMENT
  - DEVELOPMENT Contact Center
  - QUALITY ASSURANCE
  - QUALITY ASSURANCE Contact Center
  - STAGING
  - STAGING Contact Center

Fallidos: 0
========================================
```

### Configuración

#### Payload del Deployment

```json
{
  "application": 138,
  "service": <SERVICE_ID>,
  "environment": <ENV_ID>,
  "version": "<VERSION>",
  "description": "deploy v<VERSION>",
  "flyway_mode": "disabled",
  "form_kind": "StepFunctions"
}
```

### Dependencias

- `curl` - Para llamadas HTTP
- `msg` - Sistema de mensajes del proyecto
- `run_with_spinner` - Para feedback visual
- `select_option` - Selector interactivo de opciones

### 📝 Notas

- Los deployments son **secuenciales**, no paralelos
- Si falla un deployment crítico (401/403/conexión), se abortan los siguientes
- Los tokens expiran periódicamente y deben renovarse
- Requiere conexión a la VPN corporativa
- El modo dry-run es útil para validar antes de desplegar
