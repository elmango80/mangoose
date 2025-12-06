# Git Functions

Funciones para gestión y mantenimiento de repositorios Git.

## Archivos

### git.zsh

Funciones avanzadas para limpieza de ramas y sincronización de repositorios.

### no_branch_for_old_refs

Limpia ramas locales que han sido eliminadas del remoto.

> _"No Country for Old Men - There's no place here for old refs."_

```zsh
no_branch_for_old_refs              # Limpiar ramas huérfanas
no_branch_for_old_refs --dry-run    # Vista previa
no_branch_for_old_refs --demo       # Simulación con delay
```

### paranoid_sync

Actualiza la rama principal (main/master) preservando tu rama actual y cambios sin confirmar.

_"Finished with my woman 'cause she couldn't help me with my mind..."_

```zsh
paranoid_sync                 # Actualizar master/main
paranoid_sync --all           # Actualizar todos los repos
```

### is_git_repository

Función auxiliar que verifica si el directorio actual es un repositorio Git.

```zsh
if is_git_repository; then
  # Código que requiere Git
fi
```

## Dependencias

Requiere:

- `core/print.zsh` - Para mensajes con formato
- `core/colors.zsh` - Para colores

## Uso

```zsh
# Cargar módulo Git
source ~/.config/zsh/functions/git/git.zsh
```

## Aliases Relacionados

Definidos en `aliases/aliases.zsh`:

```zsh
gcls         # no_branch_for_old_refs
gcls:all     # no_branch_for_old_refs --all
gmup         # paranoid_sync
gmup:all     # paranoid_sync --all
gce          # git commit --allow-empty
gmomn        # git merge origin/main --no-edit
gmn          # git merge --no-edit
gswz         # Switch branch con fzf
```
