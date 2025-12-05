# Productivity Functions (productivity.zsh)

Funciones para mejorar la productividad en el desarrollo.

## 🔍 seek_and_destroy

Busca y elimina directorios específicos de forma recursiva.

### Uso

```bash
seek_and_destroy [OPTIONS]
```

### Opciones

- `--dir <nombre>` - **REQUERIDO** - Nombre del directorio a buscar y eliminar
- `--no-confirm` - Elimina sin confirmación
- `--verbose, -v` - Muestra información detallada
- `--help, -h` - Muestra ayuda

### Ejemplos

```bash
seek_and_destroy --dir node_modules              # Buscar y eliminar node_modules
seek_and_destroy --dir dist --no-confirm         # Eliminar dist sin preguntar
seek_and_destroy --dir .yalc --verbose           # Eliminar .yalc con detalles
```

### Aliases relacionados

```bash
sad                  # seek_and_destroy
sad:node_modules     # Eliminar node_modules (verbose)
sad:dist             # Eliminar dist (verbose)
sad:yalc             # Eliminar .yalc (verbose)
sad:all              # Eliminar node_modules, dist y .yalc
```

### Descripción

Busca recursivamente desde el directorio actual todos los directorios que coincidan con el nombre especificado y los elimina. Útil para limpiar dependencias, builds y cachés en proyectos.

## 📁 goto

Navegador interactivo de directorios con selector visual.

### Uso

```bash
goto [OPCIONES]
```

### Opciones

- `--base-dir <ruta>` - Directorio base desde donde buscar (default: directorio actual)
- `--depth <número>` - Profundidad máxima de búsqueda (default: 2)
- `--help, -h` - Muestra ayuda

### Ejemplos

```bash
goto                                # Navegar desde directorio actual
goto --base-dir ~/code              # Navegar desde ~/code
goto --depth 3                      # Buscar hasta 3 niveles de profundidad
goto --base-dir ~/projects --depth 4 # Personalizado
```

### Descripción

Muestra un selector interactivo de directorios usando `find` y permite navegar usando las flechas del teclado. Características:

- Búsqueda recursiva de directorios
- Selector visual con flechas ↑/↓
- Resaltado del directorio seleccionado
- Navegación instantánea al presionar Enter
- Excluye directorios ocultos y comunes como `node_modules`, `.git`, etc.

### Controles

- `↑` / `↓` - Navegar por la lista
- `Enter` - Ir al directorio seleccionado
- `Ctrl+C` - Cancelar

## 🔥 phoenix

Reinicia completamente un proyecto Node.js eliminando dependencias y reconstruyendo.

### Uso

```bash
phoenix [OPTIONS]
```

### Opciones

- `--hard` - Modo agresivo: elimina también yarn.lock, caché y enlaces yalc
- `--help, -h` - Muestra ayuda

### Ejemplos

```bash
phoenix              # Limpieza estándar
phoenix --hard       # Limpieza agresiva completa
```

### Descripción

Elimina dependencias y artefactos de build, luego reinstala todo desde cero. Útil cuando hay problemas de dependencias o builds corruptos.

#### Modo estándar

1. Elimina `node_modules`
2. Elimina `dist`
3. Elimina `.yalc`
4. Ejecuta `yarn install`

#### Modo `--hard`

1. Todo lo del modo estándar
2. Remueve todos los enlaces de yalc (`yalc remove --all`)
3. Limpia caché de yarn (`yarn cache clean`)
4. Elimina `yarn.lock`
5. Ejecuta `yarn install`

### Requisitos

- Debe existir `package.json` en el directorio actual
- Yarn debe estar instalado

### Mensaje de éxito

```
🔥 The phoenix has been reborn
```

## 📝 Notas

- Todas las funciones incluyen ayuda integrada con `--help`
- Los mensajes utilizan el sistema de colores e iconos de `msg`
- Las funciones destructivas solicitan confirmación (excepto con `--no-confirm`)
- Compatible con workspaces de Yarn
