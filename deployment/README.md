# Deployment Functions

Sistema de deployment automatizado.

## Archivos

### deploy.zsh

Sistema completo de deployment a múltiples entornos.

**Ver documentación completa:** [DEPLOY.md](../docs/DEPLOY.md)

## Función Principal

### deploy

Realiza deployment de servicios a múltiples entornos de forma secuencial.

```zsh
deploy <service>[@version] [OPTIONS]
```

## Servicios Disponibles

> **Nota:** Los servicios deben configurarse en `~/functions/.env` en la variable `DEPLOY_SERVICES`.  
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

> **Nota:** Los entornos deben configurarse en `~/functions/.env` en la variable `DEPLOY_ENVIRONMENTS`.  
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

Deben configurarse en `~/functions/.env`:

- `DEPLOY_SERVER_URL` - URL del servidor de deployment
- `DEPLOY_APP_ID` - ID de la aplicación
- `DEPLOY_SERVICES` - Array de servicios disponibles (formato: `"nombre:id"`)
- `DEPLOY_ENVIRONMENTS` - Array de entornos de deployment (formato: `"id:nombre"`)

## Uso

```zsh
# Cargar módulo Deployment
source ~/functions/deployment/deploy.zsh
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

# Deploy interactivo
deploy api-auth

# Deploy automático de última versión
deploy api-auth@latest

# Deploy de versión específica a todos los entornos
deploy api-users@1.2.3

# Simulación sin cambios reales
deploy api-auth@latest --dry-run
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

El payload enviado:

```json
{
  "application": 100,
  "service": <SERVICE_ID>,
  "environment": <ENV_ID>,
  "version": "<VERSION>",
  "description": "deploy v<VERSION>",
  "flyway_mode": "disabled",
  "form_kind": "StepFunctions"
}
```
