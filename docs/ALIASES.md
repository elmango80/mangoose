# Aliases (aliases.zsh)

Colección de aliases útiles para mejorar la productividad en la terminal.

## 📂 Navegación

Los aliases de navegación usan las variables de entorno configuradas en `.env`:

```zsh
cdh              # cd $HOME
cdc              # cd $HOME/$CODE_DIR (configurable en .env)
cdw              # cd $HOME/$CODE_DIR/$WORK_DIR (configurable en .env)
ls               # ls -GA (con colores y sin . ni ..)
```

**Configuración:** Edita `CODE_DIR` y `WORK_DIR` en tu archivo `.env` para personalizar estos directorios.

## 📦 NPM

```zsh
na               # npm add
ni               # npm install
nig              # npm install --global
nins             # npm install --no-save
nip              # npm install --save-prod
nid              # npm install --save-dev
nie              # npm install --save-exact
nide             # npm install --save-dev --save-exact
nipe             # npm install --save-prod --save-exact
nu               # npm uninstall
nr               # npm remove
```

## 🧶 Yarn

```zsh
y                # yarn
yi               # yarn install
ya               # yarn add
yad              # yarn add --dev
yap              # yarn add --peer
yag              # yarn global add
yre              # yarn remove
yreg             # yarn global remove
yl               # yarn link
yu               # yarn unlink
yw               # yarn workspace
ywi              # yarn workspaces info
yx               # yarn dlx
```

## 🏢 Grupo Santander

```zsh
eth0mtu          # sudo ip link set dev eth0 mtu 1360
app              # cd app
example          # cd example
transfers:base   # Navegar a directorio base de transfers
transfers:example # Navegar a ejemplo de transfers
run:base         # Ejecutar base con argumentos
run:dev          # yarn dev:nodemon
run:start        # yarn start
run:start:cc     # yarn start:cc
run:wiremock     # Iniciar servidor WireMock
npm:jfrog        # npm login --auth-type=web
```

## 🔍 FZF

```zsh
gswz             # Selector interactivo de ramas con git switch
```

## ⚙️ ZSH

```zsh
zrc              # Editar .zshrc
zp               # Editar .zprofile
```

## 🍺 Homebrew

```zsh
brew:cask:on     # Configurar instalación de casks en ~/Applications
brew:cask:off    # Desactivar configuración de casks
```

## 🧹 Limpieza de Directorios

```zsh
sad              # seek_and_destroy
sad:node_modules # Buscar y eliminar node_modules (verbose)
sad:dist         # Buscar y eliminar dist (verbose)
sad:yalc         # Buscar y eliminar .yalc (verbose)
sad:all          # Eliminar node_modules, dist y .yalc (sin confirmación)
```

## 🔀 Git

```zsh
gcls             # clean_repository - Limpiar ramas huérfanas
gcls:all         # clean_repositories - Limpiar en todos los repos
gmup             # update_master_repo - Actualizar master/main
gmup:all         # update_master_repos - Actualizar en todos los repos
gce              # git commit --allow-empty -m 'empty commit'
gmomn            # git merge origin/main --no-edit
gmn              # git merge --no-edit
```

## 🛠️ Utilidades

```zsh
goto             # Navegador interactivo de directorios
deploy           # Sistema de deployment a Quicksilver
sudo             # sudo (con soporte para aliases)
```

## 📝 Notas

- Los aliases de directorios (`cdw`, `transfers:*`) dependen de variables de entorno configuradas
- Algunos aliases requieren herramientas específicas (fzf, yalc, etc.)
- El alias `sudo` con espacio permite usar sudo con otros aliases
