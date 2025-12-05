# Productivity Functions

Funciones para mejorar la productividad en el desarrollo.

## Archivos

### productivity.zsh

Herramientas para gestión de proyectos y navegación.

**Ver documentación completa:** [PRODUCTIVITY.md](../docs/PRODUCTIVITY.md)

## Funciones Principales

### seek_and_destroy (alias: sad)

Busca y elimina directorios específicos de forma recursiva.

```bash
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

```bash
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

```bash
phoenix              # Limpieza estándar
phoenix --hard       # Limpieza agresiva completa
```

**Modo estándar:**

- Elimina node_modules, dist, .yalc
- Ejecuta yarn install

**Modo --hard:**

- Todo lo anterior +
- Remueve enlaces yalc
- Limpia caché de yarn
- Elimina yarn.lock

## Dependencias

Requiere:

- `core/print.zsh` - Para mensajes
- `core/spinners.zsh` - Para feedback visual
- `core/utils.zsh` - Para utilidades
- `core/colors.zsh` - Para colores

Herramientas externas:

- Node.js y Yarn (para phoenix)
- find (para goto y seek_and_destroy)

## Uso

```bash
# Cargar módulo Productivity
source ~/.config/zsh/functions/productivity/productivity.zsh
```

## Casos de Uso

### Limpieza de Proyecto

```bash
# Limpiar dependencias
phoenix

# Limpieza profunda con problemas de caché
phoenix --hard

# Limpiar solo node_modules en todo el workspace
sad:all
```

### Navegación Rápida

```bash
# Navegar a un proyecto
goto --base-dir ~/code/projects --depth 3

# Seleccionar y entrar al directorio
```

### Mantenimiento

```bash
# Eliminar builds antiguos
seek_and_destroy --dir dist --verbose

# Limpiar caché de yalc
seek_and_destroy --dir .yalc --no-confirm
```
