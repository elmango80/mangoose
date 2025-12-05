# Zsh Functions Collection

Colección completa de funciones y utilidades para Zsh organizadas por módulos que mejoran significativamente la productividad en desarrollo, automatización de deployments, gestión de repositorios Git y mucho más.

## 🌟 Características Principales

- 🚀 **Deployment automatizado** a múltiples entornos (Quicksilver)
- 🔥 **Gestión de proyectos Node.js** con limpieza y reinicio completo
- 🌲 **Utilidades Git avanzadas** para limpieza de ramas y sincronización
- 🎨 **Sistema de mensajes con colores** e iconos para mejor UX
- ⚡ **Spinners animados** para feedback visual de procesos
- 📁 **Navegación inteligente** de directorios
- 🎭 **Servidor WireMock** para mocking de APIs
- 🔍 **Búsqueda y destrucción** recursiva de directorios
- 💯 **+90 aliases** para comandos comunes

## � Estructura del Proyecto

```
zsh-functions/
├── core/           # Funciones base (colors, print, utils, spinners)
│   ├── colors.zsh
│   ├── print.zsh
│   ├── utils.zsh
│   └── spinners.zsh
├── git/            # Funciones relacionadas con Git
│   └── git.zsh
├── productivity/   # Funciones de productividad
│   └── productivity.zsh
├── deployment/     # Sistema de deployment
│   └── deploy.zsh
├── testing/        # WireMock y testing
│   └── wiremock.zsh
├── aliases/        # Aliases
│   └── aliases.zsh
└── docs/           # Documentación detallada
    ├── ALIASES.md
    ├── COLORS.md
    ├── DEPLOY.md
    ├── GIT.md
    ├── PRINT.md
    ├── PRODUCTIVITY.md
    ├── SPINNERS.md
    ├── UTILS.md
    └── WIREMOCK.md
```

## �📚 Documentación por Módulo

Cada módulo tiene su propia documentación detallada:

| Módulo           | Ubicación                        | Descripción                                        |
| ---------------- | -------------------------------- | -------------------------------------------------- |
| **Core**         | [core/](./core/)                 | Funciones base: colores, mensajes, utils, spinners |
| **Git**          | [git/](./git/)                   | Limpieza de ramas, sincronización de repos         |
| **Productivity** | [productivity/](./productivity/) | seek_and_destroy, phoenix, goto                    |
| **Deployment**   | [deployment/](./deployment/)     | Sistema de deployment a Quicksilver                |
| **Testing**      | [testing/](./testing/)           | Servidor WireMock para mocking de APIs             |
| **Aliases**      | [aliases/](./aliases/)           | Más de 90 aliases para npm, yarn, git, etc.        |

**Documentación detallada:**

- [ALIASES.md](./docs/ALIASES.md)
- [COLORS.md](./docs/COLORS.md)
- [DEPLOY.md](./docs/DEPLOY.md)
- [GIT.md](./docs/GIT.md)
- [PRINT.md](./docs/PRINT.md)
- [PRODUCTIVITY.md](./docs/PRODUCTIVITY.md)
- [SPINNERS.md](./docs/SPINNERS.md)
- [UTILS.md](./docs/UTILS.md)
- [WIREMOCK.md](./docs/WIREMOCK.md)

## 📦 Instalación

### Instalación Automática (Recomendado)

```bash
# Descargar e instalar con un comando
curl -fsSL https://raw.githubusercontent.com/elmango80/zsh-functions/master/install.sh | zsh
```

O descarga primero y luego ejecuta:

```bash
curl -fsSL https://raw.githubusercontent.com/elmango80/zsh-functions/master/install.sh -o /tmp/install-zsh-functions.sh
chmod +x /tmp/install-zsh-functions.sh
/tmp/install-zsh-functions.sh
```

El instalador:

- ✅ Clona el repositorio en `~/.config/zsh/functions`
- ✅ Hace backup de tu `.zshrc`
- ✅ Agrega la configuración necesaria
- ✅ Respeta configuraciones existentes
- ✅ Permite actualizar o reinstalar

### Instalación Manual

```bash
# Clonar el repositorio
git clone https://github.com/elmango80/zsh-functions.git ~/.config/zsh/functions

# Agregar a tu .zshrc (carga en orden correcto)
cat >> ~/.zshrc << 'EOF'
# Cargar Zsh Functions (orden de dependencias)
source ~/.config/zsh/functions/core/colors.zsh
source ~/.config/zsh/functions/core/utils.zsh
source ~/.config/zsh/functions/core/print.zsh
source ~/.config/zsh/functions/core/spinners.zsh
source ~/.config/zsh/functions/git/git.zsh
source ~/.config/zsh/functions/productivity/productivity.zsh
source ~/.config/zsh/functions/deployment/deploy.zsh
source ~/.config/zsh/functions/testing/wiremock.zsh
source ~/.config/zsh/functions/aliases/aliases.zsh
EOF

# Recargar la configuración
source ~/.zshrc
```

### Instalación con Loop (Alternativa)

```bash
# Cargar todos los módulos automáticamente
cat >> ~/.zshrc << 'EOF'
# Cargar Zsh Functions en orden
for module_dir in core git productivity deployment testing aliases; do
  for func_file in ~/.config/zsh/functions/$module_dir/*.zsh(N); do
    source "$func_file"
  done
done
EOF
```

### ⚠️ Orden de Carga Importante

Es crucial cargar en este orden debido a dependencias:

1. **core/** - Primero (base para todo)
   - `colors.zsh` → `utils.zsh` → `print.zsh` → `spinners.zsh`
2. **git/** - Depende de core
3. **productivity/** - Depende de core
4. **deployment/** - Depende de core
5. **testing/** - Depende de core
6. **aliases/** - Último (usa funciones de otros módulos)

### Actualizar

```bash
cd ~/.config/zsh/functions
git pull
source ~/.zshrc
```

## ⚡ Inicio Rápido

```bash
# Ver ayuda de cualquier función
deploy --help
phoenix --help
wiremock_run_server --help

# Ejemplos rápidos
phoenix                          # Limpiar y reinstalar proyecto Node.js
goto --depth 3                   # Navegar interactivamente por directorios
gcls                            # Limpiar ramas Git huérfanas
deploy security@latest          # Deploy de última versión a todos los entornos
run_with_spinner --test         # Ver demo de spinners
```

## 🎯 Funciones Destacadas

### 🔥 phoenix

Reinicia proyectos Node.js eliminando dependencias y reconstruyendo desde cero.

```bash
phoenix              # Limpieza estándar
phoenix --hard       # Limpieza profunda con yarn.lock y caché
```

### 🚀 deploy

Sistema completo de deployment a Quicksilver con soporte multi-entorno.

```bash
deploy security                # Selector interactivo de versiones
deploy security@latest         # Deploy última versión
deploy security@0.52.1         # Deploy versión específica
deploy login@1.0.0 --dry-run  # Simulación sin cambios reales
```

### 🌲 clean_repository (gcls)

Limpia ramas locales que fueron eliminadas del remoto.

```bash
clean_repository           # Limpiar ramas huérfanas
clean_repository --dry-run # Vista previa sin eliminar
gcls                       # Alias corto
```

### 📁 goto

Navegador interactivo de directorios con selector visual.

```bash
goto                         # Desde directorio actual
goto --base-dir ~/projects   # Desde directorio específico
goto --depth 4               # Buscar hasta 4 niveles
```

### 🔍 seek_and_destroy (sad)

Busca y elimina directorios específicos recursivamente.

```bash
seek_and_destroy --dir node_modules
sad:all                      # Elimina node_modules, dist y .yalc
```

### 💬 msg

Sistema de mensajes con colores, iconos y formato.

```bash
msg "Operación exitosa" --success
msg "Advertencia importante" --warning
msg "Error crítico" --error --to-stderr
msg "Información" --info --tab 2
```

### 🎭 wiremock_run_server

Servidor WireMock standalone para mocking de APIs.

```bash
wiremock_run_server                # Puerto 8000 por defecto
wiremock_run_server --port 9090    # Puerto personalizado
run:wiremock                       # Alias
```

### 🔄 run_with_spinner

Ejecuta comandos mostrando spinner animado.

```bash
run_with_spinner --command "npm install" --message "Instalando..."
run_with_spinner --command "yarn build" --message "Building..." --model "balloon"
```

## 📋 Resumen de Comandos por Categoría

### 🔧 Productividad

- `phoenix` - Reiniciar proyecto Node.js
- `goto` - Navegador de directorios
- `seek_and_destroy` (sad) - Eliminar directorios recursivamente
- `zre` - Recargar configuración zsh

### 🚀 Deployment

- `deploy` - Deployment a Quicksilver

### 🌲 Git

- `clean_repository` (gcls) - Limpiar ramas huérfanas
- `clean_repositories` (gcls:all) - Limpiar múltiples repos
- `update_master_repo` (gmup) - Actualizar rama principal
- `update_master_repos` (gmup:all) - Actualizar múltiples repos

### 💬 UI/Output

- `msg` - Mensajes con formato
- `run_with_spinner` - Spinners animados
- `select_option` - Selector interactivo
- `test_colors` - Ver paleta de colores

### 🎭 Testing

- `wiremock_run_server` - Servidor WireMock

### 🔍 Utilidades

- `extract_arg_value` - Validar argumentos
- `read_single_char` - Leer un carácter
- `print_indentation` - Imprimir indentación

## 📝 Aliases Destacados

### NPM/Yarn

```bash
yi    # yarn install
ya    # yarn add
yad   # yarn add --dev
ni    # npm install
na    # npm add
```

### Git

```bash
gcls       # clean_repository
gcls:all   # clean_repositories
gmup       # update_master_repo
gmup:all   # update_master_repos
gswz       # Switch branch con fzf
```

### Limpieza

```bash
sad              # seek_and_destroy
sad:node_modules # Eliminar node_modules
sad:dist         # Eliminar dist
sad:yalc         # Eliminar .yalc
sad:all          # Eliminar todo
```

### Navegación

```bash
cdh    # cd $HOME
cdc    # cd $HOME/code
cdw    # cd $HOME/code/grupo-santander-ods
```

## 📋 Requisitos

- **Zsh** - Shell principal
- **Git** - Para funciones de Git
- **Node.js y Yarn** - Para funciones de productividad Node.js
- **curl** - Para funciones de deployment
- **Java** - Para WireMock (opcional)
- **fzf** - Para selector de ramas Git (opcional)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## � Reportar Issues

Si encuentras un bug o tienes una sugerencia:

1. Verifica que no exista ya un issue similar
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Versión de Zsh y sistema operativo

## �📝 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## ✨ Autor

Creado con ❤️ para mejorar la productividad en la terminal.

## 🙏 Agradecimientos

- Inspirado en la comunidad de Zsh
- Diseñado para mejorar la productividad diaria en el desarrollo
- Construido con feedback de uso real en proyectos

## 📖 Más Información

Para documentación detallada de cada módulo:

### Por Módulo

- [core/](./core/) - README del módulo Core
- [git/](./git/) - README del módulo Git
- [productivity/](./productivity/) - README del módulo Productivity
- [deployment/](./deployment/) - README del módulo Deployment
- [testing/](./testing/) - README del módulo Testing
- [aliases/](./aliases/) - README del módulo Aliases

### Documentación Completa

- [ALIASES.md](./docs/ALIASES.md) - Todos los aliases disponibles
- [COLORS.md](./docs/COLORS.md) - Guía completa de colores
- [DEPLOY.md](./docs/DEPLOY.md) - Sistema de deployment completo
- [GIT.md](./docs/GIT.md) - Funciones Git avanzadas
- [PRINT.md](./docs/PRINT.md) - Sistema de mensajes
- [PRODUCTIVITY.md](./docs/PRODUCTIVITY.md) - Herramientas de productividad
- [SPINNERS.md](./docs/SPINNERS.md) - Animaciones y spinners
- [UTILS.md](./docs/UTILS.md) - Utilidades de bajo nivel
- [WIREMOCK.md](./docs/WIREMOCK.md) - Servidor de mocking

---

**¿Preguntas o sugerencias?** Abre un issue en GitHub.
