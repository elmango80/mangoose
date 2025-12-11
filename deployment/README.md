# Deployment Functions

Sistema de deployment automatizado.

## Archivos

### deploy.zsh

Sistema completo de deployment a múltiples entornos.

## Función Principal

### deploy

Realiza deployment de servicios a múltiples entornos de forma secuencial.

```zsh
deploy <service>[@version] [OPTIONS]
```

## Opciones

| Opción                  | Descripción                                     |
| ----------------------- | ----------------------------------------------- |
| `--dry-run`             | Modo simulación sin ejecutar deployments reales |
| `--description "texto"` | Descripción personalizada para el deployment    |
| `-l, --list-services`   | Lista todos los servicios disponibles           |
| `-h, --help`            | Muestra la ayuda                                |

## Servicios Disponibles

> **Nota:** Los servicios deben configurarse en tu archivo `.env` en la variable `DEPLOY_SERVICES`.  
> Los servicios listados a continuación son ejemplos ficticios a modo informativo.

| Servicio | Descripción               |
| -------- | ------------------------- |
| `auth`   | Servicio de autenticación |
| `users`  | Servicio de usuarios      |
| `data`   | Servicio de datos         |

Para listar los servicios realmente configurados, ejecuta:

```zsh
deploy --list-services
```

## Entornos de Despliegue

> **Nota:** Los entornos deben configurarse en tu archivo `.env` en la variable `DEPLOY_ENVIRONMENTS`.  
> Los entornos listados a continuación son ejemplos ficticios a modo informativo.

Los deployments se ejecutan en este orden:

1. Development
2. Development Contact Center
3. Quality Assurance
4. Quality Assurance Contact Center
5. Staging
6. Staging Contact Center

## Modos de Uso

### Selector Interactivo

```zsh
deploy auth
```

### Última Versión

```zsh
deploy auth@latest
deploy users@latest
```

### Versión Específica

```zsh
deploy auth@0.52.1
deploy users@1.0.0
```

### Modo Dry-Run

```zsh
deploy auth@0.52.1 --dry-run
```

### Descripción Personalizada

```zsh
# Con descripción personalizada
deploy auth@1.0.0 --description "Hotfix crítico - Issue #123"

# Combinar con dry-run
deploy users@2.0.0 --description "Release Q4" --dry-run
```

> **Nota:** Si no se especifica `--description`, se usa la descripción predeterminada: `deploy vX.Y.Z`

## Autenticación

Requiere tokens de autenticación:

- **CSRF Token** - Token de seguridad del servidor
- **Session ID** - ID de sesión del usuario

**Cómo obtener tokens:**

1. Ejecuta `qs-login`
2. Inicia sesión con tus credenciales
3. DevTools → Application → Cookies
4. Copia `csrftoken` y `sessionid`
5. Los tokens se solicitan al ejecutar el comando

## Manejo de Errores

- **401/403** - Token expirado (aborta)
- **000** - Sin conexión (aborta)
- **Otros** - Continúa con siguiente entorno

## Dependencias

### Scripts

- `core/print.zsh` - Para mensajes
- `core/spinners.zsh` - Para feedback
- `core/utils.zsh` - Para select_option
- `curl` - Para API calls

### Variables de Entorno

Deben configurarse en tu archivo `.env`:

- `DEPLOY_SERVER_URL` - URL del servidor de deployment
- `DEPLOY_APP_ID` - ID de la aplicación
- `DEPLOY_SERVICES` - Array de servicios disponibles (formato: `"nombre:id"`)
- `DEPLOY_ENVIRONMENTS` - Array de entornos de deployment (formato: `"id:nombre"`)

## Uso

Este módulo se carga automáticamente si instalaste con el script de instalación.

Para uso manual:

```zsh
source ~/mangoose/deployment/deploy.zsh
```

## Alias Relacionado

```zsh
deploy    # Definido en aliases/aliases.zsh
```

## Ejemplo Completo

```zsh
# Ver ayuda
deploy --help

# Listar servicios disponibles
deploy --list-services

# Deploy interactivo (selecciona versión de una lista)
deploy auth

# Deploy automático de última versión
deploy auth@latest

# Deploy de versión específica a todos los entornos
deploy users@1.2.3

# Deploy con descripción personalizada
deploy auth@1.0.0 --description "Hotfix producción"

# Simulación sin cambios reales
deploy auth@latest --dry-run

# Combinando opciones
deploy users@2.0.0 --description "Release Q4 2025" --dry-run
```

## Resumen de Deployment

Al finalizar muestra:

```
Resumen de Deployments
==========================
Exitosos: 6
  - Development
  - Development Contact Center
  ...

Fallidos: 0
========================================
```

## Configuración

### Formato del Payload

El payload enviado al servidor:

```json
{
  "application": 100,
  "service": <SERVICE_ID>,
  "environment": <ENV_ID>,
  "version": "<VERSION>",
  "description": "<DESCRIPTION>",
  "flyway_mode": "disabled",
  "form_kind": "StepFunctions"
}
```

### Descripciones

- **Predeterminada**: `deploy vX.Y.Z` (e.g., `deploy v1.0.0`)
- **Latest**: `deploy latest version`
- **Personalizada**: El texto proporcionado con `--description`

## Características

- ✅ Soporte para múltiples servicios (configurables)
- ✅ Deployment secuencial a múltiples entornos
- ✅ Selector interactivo de versiones
- ✅ Modo dry-run para pruebas
- ✅ Descripciones personalizadas
- ✅ Validación de servicios configurados
- ✅ Manejo robusto de errores
- ✅ Feedback visual con spinners
- ✅ Resumen detallado al finalizar
  "service": <SERVICE_ID>,
  "environment": <ENV_ID>,
  "version": "<VERSION>",
  "description": "deploy v<VERSION>",
  "flyway_mode": "disabled",
  "form_kind": "StepFunctions"
  }

```

```
