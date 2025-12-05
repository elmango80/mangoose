# Aliases

Colección de más de 90 aliases para mejorar la productividad.

## Archivos

### aliases.zsh

Aliases organizados por categoría.

**Ver documentación completa:** [ALIASES.md](../docs/ALIASES.md)

## Categorías de Aliases

### 📂 Navegación

```bash
cdh              # cd $HOME
cdc              # cd $HOME/code
cdw              # cd $HOME/code/grupo-santander-ods
ls               # ls -GA
```

### 📦 NPM

```bash
na    ni    nig   nins   nip   nid
nie   nide  nipe  nu     nr
```

### 🧶 Yarn

```bash
y     yi    ya    yad    yap   yag
yre   yreg  yl    yu     yw    ywi   yx
```

### 🔀 Git

```bash
gcls         # clean_repository
gcls:all     # clean_repositories
gmup         # update_master_repo
gmup:all     # update_master_repos
gce          # git commit --allow-empty
gmomn        # git merge origin/main --no-edit
gmn          # git merge --no-edit
gswz         # Switch branch con fzf
```

### 🧹 Limpieza

```bash
sad              # seek_and_destroy
sad:node_modules # Eliminar node_modules
sad:dist         # Eliminar dist
sad:yalc         # Eliminar .yalc
sad:all          # Eliminar todo
```

### ⚙️ ZSH

```bash
zrc              # Editar .zshrc
zp               # Editar .zprofile
```

### 🍺 Homebrew

```bash
brew:cask:on     # Configurar casks en ~/Applications
brew:cask:off    # Desactivar configuración
```

### 🏢 Grupo Santander

```bash
eth0mtu          # Configurar MTU
app              # cd app
example          # cd example
transfers:base   # Navegar a transfers base
transfers:example # Navegar a example
run:base         # Ejecutar base
run:dev          # yarn dev:nodemon
run:start        # yarn start
run:start:cc     # yarn start:cc
run:wiremock     # Servidor WireMock
npm:jfrog        # npm login jfrog
```

### 🔍 FZF

```bash
gswz             # Git switch con selector fzf
```

### 🛠️ Utilidades

```bash
goto             # Navegador de directorios
deploy           # Sistema de deployment
sudo             # sudo (con soporte para aliases)
```

## Dependencias

Algunos aliases requieren:

- Funciones de otros módulos (git/, productivity/, deployment/, testing/)
- Variables de entorno específicas
- Herramientas externas (fzf, yalc, etc.)

## Uso

```bash
# Cargar módulo Aliases
source ~/.config/zsh/functions/aliases/aliases.zsh
```

## Personalización

Puedes sobrescribir aliases en tu `.zshrc`:

```bash
# Cargar aliases del proyecto
source ~/.config/zsh/functions/aliases/aliases.zsh

# Sobrescribir o agregar tus propios aliases
alias cdw="cd ~/my-custom-path"
alias myalias="my-command"
```

## Nota sobre `sudo`

El alias `sudo` con espacio al final permite usar sudo con otros aliases:

```bash
# Sin el alias especial, esto no funcionaría
sudo yi    # sudo yarn install

# El espacio hace que bash/zsh expanda el siguiente alias
alias sudo="sudo "
```

## Configuración de Directorios

Algunas variables de entorno usadas:

```bash
CODE_DIR="code"
WORK_DIR="grupo-santander-ods"
TRANSFERS_BASE_DIR="..."
TRANSFERS_EXAMPLE_DIR="..."
```

Ajústalas según tu estructura de directorios.
