# Deployment Functions

Sistema de deployment automatizado para Quicksilver.

## Archivos

### deploy.zsh

Sistema completo de deployment a múltiples entornos.

**Ver documentación completa:** [DEPLOY.md](../docs/DEPLOY.md)

## Función Principal

### deploy

Realiza deployment de servicios en Quicksilver a múltiples entornos de forma secuencial.

```zsh
deploy <service>[@version] [OPTIONS]
```

## Servicios Disponibles

| Servicio   | ID   | Descripción           |
| ---------- | ---- | --------------------- |
| `security` | 2701 | Servicio de seguridad |
| `login`    | 2700 | Servicio de login     |

## Entornos de Despliegue

Los deployments se ejecutan en este orden:

1. DEVELOPMENT (1858)
2. DEVELOPMENT Contact Center (1906)
3. QUALITY ASSURANCE (1891)
4. QUALITY ASSURANCE Contact Center (1907)
5. STAGING (1892)
6. STAGING Contact Center (1909)

## Modos de Uso

### Selector Interactivo

```zsh
deploy security
```

### Última Versión

```zsh
deploy security@latest
deploy login@latest
```

### Versión Específica

```zsh
deploy security@0.52.1
deploy login@1.0.0
```

### Modo Dry-Run

```zsh
deploy security@0.52.1 --dry-run
```

## Autenticación

Requiere tokens de Quicksilver:

- CSRF Token
- Session ID

Los tokens están configurados en el script y deben actualizarse periódicamente.

**Cómo obtener tokens:**

1. Ejecuta `qs-login`
2. Inicia sesión
3. DevTools → Application → Cookies
4. Copia `csrftoken` y `sessionid`
5. Actualiza variables en el script

## Manejo de Errores

- **401/403** - Token expirado (aborta)
- **000** - Sin conexión (aborta)
- **Otros** - Continúa con siguiente entorno

## Dependencias

Requiere:

- `core/print.zsh` - Para mensajes
- `core/spinners.zsh` - Para feedback
- `core/utils.zsh` - Para select_option
- `curl` - Para API calls

## Uso

```zsh
# Cargar módulo Deployment
source ~/.config/zsh/functions/deployment/deploy.zsh
```

## Alias Relacionado

```zsh
deploy    # Definido en aliases/aliases.zsh
```

## Ejemplo Completo

```zsh
# Ver ayuda
deploy --help

# Deploy interactivo
deploy security

# Deploy automático de última versión
deploy security@latest

# Deploy de versión específica a todos los entornos
deploy login@1.2.3

# Simulación sin cambios reales
deploy security@latest --dry-run
```

## Resumen de Deployment

Al finalizar muestra:

```
Resumen de Deployments
==========================
Exitosos: 6
  - DEVELOPMENT
  - DEVELOPMENT Contact Center
  ...

Fallidos: 0
========================================
```

## Configuración

El payload enviado:

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
