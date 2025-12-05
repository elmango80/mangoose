# Deploy Functions (deploy.zsh)

Sistema de deployment automatizado para Quicksilver.

## ⚙️ Configuración Requerida

Antes de usar este módulo, debes configurar las variables de entorno en `~/.config/zsh/functions/.env`:

```zsh
# URL del servidor de deployment
DEPLOY_SERVER_URL="https://your-server.example.com"

# ID de la aplicación
DEPLOY_APP_ID="138"

# IDs de servicios
DEPLOY_SERVICE_SECURITY_ID="2701"
DEPLOY_SERVICE_LOGIN_ID="2700"

# Entornos de deployment (orden de ejecución)
DEPLOY_ENVIRONMENTS=(
  "1858:DEVELOPMENT"
  "1906:DEVELOPMENT Contact Center"
  "1891:QUALITY ASSURANCE"
  "1907:QUALITY ASSURANCE Contact Center"
  "1892:STAGING"
  "1909:STAGING Contact Center"
)
```

📖 Ver [Guía de Configuración](./configuration.md) para más detalles.

## 🚀 deploy

Realiza deployment de servicios en Quicksilver a múltiples entornos de forma secuencial.

### Uso

```zsh
deploy <service>[@version] [OPTIONS]
```

### Argumentos

- `<service>` - **REQUERIDO** - Servicio a desplegar (`security`, `login`)
- `[@version]` - **OPCIONAL** - Versión específica o `latest`

### Opciones

- `--dry-run` - Modo simulación sin ejecutar deployments reales
- `-h, --help` - Muestra ayuda

### Servicios Disponibles

Los servicios y sus IDs se configuran en el archivo `.env`:

| Servicio   | Variable                     | Descripción           |
| ---------- | ---------------------------- | --------------------- |
| `security` | `DEPLOY_SERVICE_SECURITY_ID` | Servicio de seguridad |
| `login`    | `DEPLOY_SERVICE_LOGIN_ID`    | Servicio de login     |

### Entornos de Despliegue

Los entornos y el orden de deployment se configuran en `DEPLOY_ENVIRONMENTS` en el archivo `.env`.

El deployment se ejecuta secuencialmente en el orden definido en la configuración.

### Modos de Operación

#### Sin versión especificada

Muestra un selector interactivo con las últimas versiones disponibles:

```zsh
deploy security
```

El sistema:

1. Consulta las versiones disponibles
2. Muestra un selector visual
3. Permite elegir con flechas ↑/↓
4. Despliega la versión seleccionada a todos los entornos

#### Con `@latest`

Despliega automáticamente la última versión disponible:

```zsh
deploy security@latest
deploy login@latest
```

#### Con versión específica

Despliega una versión concreta:

```zsh
deploy security@0.52.1
deploy login@1.0.0
```

### Modo Dry-Run

Simula el proceso sin hacer cambios reales:

```zsh
deploy security@0.52.1 --dry-run
```

En este modo:

- Muestra los payloads que se enviarían
- No ejecuta deployments reales
- Útil para validar configuración

### Autenticación

El script solicita tokens de autenticación interactivamente cada vez que se ejecuta:

1. **CSRF Token** - Para protección CSRF
2. **Session ID** - Para autenticación de sesión

#### Cómo obtener los tokens:

1. El script abre automáticamente Quicksilver en tu navegador
2. Inicia sesión con tus credenciales
3. Abre DevTools (Cmd+Option+I en Mac, F12 en Windows/Linux)
4. Ve a la pestaña **Application** > **Cookies**
5. Busca y copia los valores de:
   - `csrftoken`
   - `sessionid`
6. Pega cada uno cuando el script te lo solicite

**Nota:** Los tokens expiran, por lo que debes obtenerlos nuevos en cada sesión de deployment.

#### Cómo obtener tokens

1. Ejecuta `qs-login` (abre Quicksilver en el navegador)
2. Inicia sesión con tus credenciales
3. Abre DevTools (Cmd+Option+I) → Application → Cookies
4. Copia los valores de:
   - `csrftoken`
   - `sessionid`
5. Actualiza las variables en el script

### Ejemplos

```zsh
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

#### Variables de Entorno No Configuradas

```
Error: Variable DEPLOY_SERVER_URL no configurada
Por favor, configura el archivo .env con la URL del servidor
Ver: ~/.config/zsh/functions/.env
```

**Solución**: Edita el archivo `.env` y configura todas las variables necesarias. Ver [Guía de Configuración](./configuration.md).

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

## 🔒 Seguridad

- **Información Sensible**: URLs, IDs de servicios y entornos se almacenan en `.env` (NO se sube al repositorio)
- **Tokens de Sesión**: Se solicitan interactivamente, no se almacenan
- **Configuración Local**: El archivo `.env` debe crearse manualmente en cada instalación
- **Git Ignore**: El archivo `.env` está en `.gitignore` y nunca se versionará

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
