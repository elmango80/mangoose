# Productivity Functions

Funciones para mejorar la productividad en el desarrollo.

## Archivos

### productivity.zsh

Herramientas para gestión de proyectos y navegación.

## Funciones Principales

### seek_and_destroy (alias: sad)

Busca y elimina directorios específicos de forma recursiva.

```zsh
seek_and_destroy --dir node_modules
seek_and_destroy --dir dist --no-confirm
seek_and_destroy --dir .yalc --verbose
```

**Aliases relacionados:**

- `sad` - seek_and_destroy
- `sad:node_modules` - Eliminar node_modules (verbose)
- `sad:dist` - Eliminar dist (verbose)
- `sad:yalc` - Eliminar .yalc (verbose)
- `sad:all` - Eliminar node_modules, dist y .yalc

### goto

Navegador interactivo de directorios con selector visual.

```zsh
goto                              # Desde directorio actual
goto --base-dir ~/code            # Desde directorio específico
goto --depth 3                    # Profundidad de búsqueda
```

**Características:**

- Selector visual con flechas ↑/↓
- Búsqueda recursiva
- Excluye directorios ocultos
- Navegación instantánea

### phoenix

Reinicia completamente un proyecto Node.js.

```zsh
phoenix              # Limpieza estándar
phoenix --hard       # Limpieza agresiva completa
```

**Configuración:**

El gestor de paquetes por defecto se configura mediante `PACKAGE_MANAGER` en el `.env` de Mangoose.
Admite `pnpm`, `npm` y `yarn`; si no se define, usa `pnpm`.

```zsh
export PACKAGE_MANAGER="pnpm"
```

Si el proyecto tiene la estructura `./.ci` y `./app`, y `phoenix` se ejecuta desde
`app`, se usa `PACKAGE_MANAGER` desde `../.ci/properties.env` cuando está definido.
Ese valor tiene prioridad sobre el valor configurado en Mangoose.

**Modo estándar:**

- Elimina node_modules, dist, .yalc
- Ejecuta `<gestor> install`

**Modo --hard:**

- Todo lo anterior +
- Remueve enlaces yalc
- Limpia la caché del gestor seleccionado
- Elimina el lockfile del gestor seleccionado

## Dependencias

Requiere:

- `core/print.zsh` - Para mensajes
- `core/spinners.zsh` - Para feedback visual
- `core/utils.zsh` - Para utilidades
- `core/colors.zsh` - Para colores

Herramientas externas:

- Node.js y pnpm, npm o Yarn (para phoenix)
- find (para goto y seek_and_destroy)

## Uso

Este módulo se carga automáticamente si instalaste con el script de instalación.

Para uso manual:

```zsh
source ~/mangoose/productivity/productivity.zsh
```

## Casos de Uso

### Limpieza de Proyecto

```zsh
# Limpiar dependencias
phoenix

# Limpieza profunda con problemas de caché
phoenix --hard

# Limpiar solo node_modules en todo el workspace
sad:all
```

### Navegación Rápida

```zsh
# Navegar a un proyecto
goto --base-dir ~/code/projects --depth 3

# Seleccionar y entrar al directorio
```

### Mantenimiento

```zsh
# Eliminar builds antiguos
seek_and_destroy --dir dist --verbose

# Limpiar caché de yalc
seek_and_destroy --dir .yalc --no-confirm
```
