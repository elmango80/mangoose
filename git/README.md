# Git Functions

Funciones para gestión y mantenimiento de repositorios Git.

## Archivos

### git.zsh

Funciones avanzadas para limpieza de ramas y sincronización de repositorios.

**Ver documentación completa:** [GIT.md](../docs/GIT.md)

## Funciones Principales

### no_branch_for_old_refs (alias: gcls)

Limpia ramas locales que han sido eliminadas del remoto.

> _"No Country for Old Men - There's no place here for old refs."_

```zsh
no_branch_for_old_refs              # Limpiar ramas huérfanas
no_branch_for_old_refs --dry-run    # Vista previa
no_branch_for_old_refs --demo       # Simulación con delay
```

### update_master_repo (alias: gmup)

Actualiza la rama principal (master/main) desde el remoto.

```zsh
update_master_repo            # Actualizar master/main
```

### update_master_repos (alias: gmup:all)

Ejecuta `update_master_repo` en múltiples repositorios.

```zsh
update_master_repos           # Actualizar todos los repos
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
gmup         # update_master_repo
gmup:all     # update_master_repos
gce          # git commit --allow-empty
gmomn        # git merge origin/main --no-edit
gmn          # git merge --no-edit
gswz         # Switch branch con fzf
```
