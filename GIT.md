# Git Functions (git.zsh)

Funciones para gestión y mantenimiento de repositorios Git.

## 🧹 clean_repository

Limpia ramas locales que han sido eliminadas del remoto.

### Uso

```bash
clean_repository [OPTIONS]
```

### Opciones

- `--dry-run` - Muestra qué ramas se eliminarían sin borrarlas
- `--demo, -d` - Simula la eliminación con delays (para testing)
- `--help, -h` - Muestra ayuda

### Descripción

Esta función:

- Hace fetch y prune de referencias remotas
- Identifica ramas con estado 'gone' (eliminadas del remoto)
- Elimina ramas huérfanas (excepto la rama actual)
- Solicita confirmación antes de eliminar la rama actual si también está huérfana

### Ejemplos

```bash
clean_repository                  # Limpiar ramas huérfanas
clean_repository --dry-run        # Ver qué se eliminaría
clean_repository --demo           # Simular eliminación
clean_repository --demo --dry-run # Preview y simulación
```

### Alias

```bash
gcls    # Atajo para clean_repository
```

## 🔄 clean_repositories

Ejecuta `clean_repository` en múltiples repositorios dentro de un directorio.

### Uso

```bash
clean_repositories [OPTIONS]
```

### Opciones

Acepta las mismas opciones que `clean_repository`: `--dry-run`, `--demo`, `--help`

### Ejemplos

```bash
clean_repositories                # Limpiar todos los repos
clean_repositories --dry-run      # Vista previa en todos los repos
```

### Alias

```bash
gcls:all    # Atajo para clean_repositories
```

## ⬆️ update_master_repo

Actualiza la rama principal (master/main) desde el remoto.

### Uso

```bash
update_master_repo
```

### Descripción

Esta función:

- Detecta automáticamente si la rama principal es `master` o `main`
- Hace stash de cambios locales si existen
- Cambia a la rama principal
- Hace pull desde origin
- Vuelve a la rama original
- Restaura cambios del stash si los había

### Ejemplos

```bash
update_master_repo    # Actualizar master/main
```

### Alias

```bash
gmup    # Atajo para update_master_repo
```

## 🔄 update_master_repos

Ejecuta `update_master_repo` en múltiples repositorios dentro de un directorio.

### Uso

```bash
update_master_repos
```

### Ejemplos

```bash
update_master_repos    # Actualizar master/main en todos los repos
```

### Alias

```bash
gmup:all    # Atajo para update_master_repos
```

## 🛠️ is_git_repository

Función auxiliar que verifica si el directorio actual es un repositorio Git.

### Uso

```bash
if is_git_repository; then
  # Código que requiere un repositorio Git
fi
```

### Retorno

- `0` si es un repositorio Git
- `1` si no lo es (muestra error)

## 📝 Notas

- Todas las funciones verifican si estás en un repositorio Git antes de ejecutarse
- Los mensajes de error se envían a stderr
- Las funciones con sufijo `_repos` buscan repositorios en subdirectorios del directorio actual
- Compatible con los comandos de Git de oh-my-zsh
