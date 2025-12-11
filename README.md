# Mangoose

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

## 📁 Estructura del Proyecto

```
mangoose/
├── core/           # Funciones base y configuración
│   ├── env-loader.zsh  # Cargador de variables de entorno
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
├── docs/           # Documentación detallada
│   ├── ALIASES.md
│   ├── COLORS.md
│   ├── DEPLOY.md
│   ├── GIT.md
│   ├── PRINT.md
│   ├── PRODUCTIVITY.md
│   ├── SPINNERS.md
│   ├── UTILS.md
│   ├── WIREMOCK.md
│   └── configuration.md
├── .env.example    # Plantilla de configuración (incluida en repo)
├── .env            # Tu configuración local (NO se sube al repo)
├── .gitignore      # Protege .env de commits accidentales
└── install.sh      # Script de instalación automática
```

## 📚 Documentación por Módulo

Cada módulo tiene su propia documentación detallada:

| Módulo           | Ubicación                        | Descripción                                        |
| ---------------- | -------------------------------- | -------------------------------------------------- |
| **Core**         | [core/](./core/)                 | Funciones base: colores, mensajes, utils, spinners |
| **Git**          | [git/](./git/)                   | Limpieza de ramas, sincronización de repos         |
| **Productivity** | [productivity/](./productivity/) | seek_and_destroy, phoenix, goto                    |
| **Deployment**   | [deployment/](./deployment/)     | Sistema de deployment a Quicksilver                |
| **Testing**      | [testing/](./testing/)           | Servidor WireMock para mocking de APIs             |
| **Aliases**      | [aliases/](./aliases/)           | Más de 90 aliases para npm, yarn, git, etc.        |

## 📦 Instalación

### Instalación Automática (Recomendado)

```zsh
# Descargar e instalar con un comando
curl -fsSL https://raw.githubusercontent.com/elmango80/mangoose/master/install.sh | zsh
```

### ⚙️ Configuración Post-Instalación

Después de instalar, **edita el archivo `.env` con tus valores reales**:

```zsh
nano ~/functions/.env
# o con tu editor preferido
code ~/functions/.env
```

#### 🔧 Variables Disponibles

##### Deployment

| Variable              | Descripción                                            | Ejemplo                             |
| --------------------- | ------------------------------------------------------ | ----------------------------------- |
| `DEPLOY_SERVER_URL`   | URL base del servidor de deployment                    | `https://deploy-server.example.com` |
| `DEPLOY_APP_ID`       | ID de la aplicación                                    | `100`                               |
| `DEPLOY_SERVICES`     | Array de servicios disponibles (formato: `NOMBRE:ID`)  | `("auth:1001" "users:1002")`        |
| `DEPLOY_ENVIRONMENTS` | Array de entornos de deployment (formato: `ID:NOMBRE`) | `("1001:DEVELOPMENT" "1003:QA")`    |

**Formato de `DEPLOY_SERVICES`:**

```zsh
DEPLOY_SERVICES=(
  "auth:1001"
  "users:1002"
  "data:1003"
)
```

**Formato de `DEPLOY_ENVIRONMENTS`:**

```zsh
DEPLOY_ENVIRONMENTS=(
  "1001:DEVELOPMENT"
  "1002:DEVELOPMENT Contact Center"
  "1003:QUALITY ASSURANCE"
)
```

##### Variables de Directorios

| Variable   | Descripción                                    | Ejemplo       |
| ---------- | ---------------------------------------------- | ------------- |
| `CODE_DIR` | Directorio base de código (relativo a `$HOME`) | `code`        |
| `WORK_DIR` | Directorio de trabajo (relativo a `$CODE_DIR`) | `my-projects` |

##### Wiremock

| Variable              | Descripción               | Ejemplo                 |
| --------------------- | ------------------------- | ----------------------- |
| `WIREMOCK_SERVER_URL` | URL del servidor Wiremock | `http://localhost:8080` |

#### 📝 Formato del archivo .env

El archivo `.env` debe seguir este formato:

```zsh
# Comentarios empiezan con #
export VARIABLE_NAME="valor"
export OTRA_VARIABLE="valor_sin_comillas"

# Arrays (para DEPLOY_SERVICES y DEPLOY_ENVIRONMENTS)
export DEPLOY_SERVICES=(
  "auth:1001"
  "users:1002"
)

export DEPLOY_ENVIRONMENTS=(
  "1001:DEVELOPMENT"
  "1003:QA"
)
```

**IMPORTANTE:**

- ✅ Todas las variables deben tener `export` al inicio
- ❌ NO uses espacios alrededor del `=`: `VARIABLE = valor`
- ❌ NO uses comillas mixtas: `VARIABLE='valor"`

#### 🔄 Recarga de Configuración

Si modificas el archivo `.env`, recarga tu sesión:

```zsh
source ~/.zshrc
# o simplemente abre una nueva terminal
```

O descarga primero y luego ejecuta:

```zsh
curl -fsSL https://raw.githubusercontent.com/elmango80/mangoose/master/install.sh -o /tmp/install-mangoose.sh
chmod +x /tmp/install-mangoose.sh
/tmp/install-mangoose.sh
```

El instalador:

- ✅ Clona el repositorio en `~/.config/zsh/functions`
- ✅ Crea el archivo `.env` desde `.env.example`
- ✅ Hace backup de tu `.zshrc`
- ✅ Agrega la configuración necesaria
- ✅ Respeta configuraciones existentes
- ✅ Permite actualizar o reinstalar

**⚠️ Importante:** Después de la instalación, debes editar el `.env` con tus valores reales antes de usar comandos como `deploy`.

### Instalación Manual

```zsh
# Clonar el repositorio
git clone https://github.com/elmango80/mangoose.git ~/.config/zsh/functions

# Crear archivo de configuración desde el ejemplo
cp ~/.config/zsh/functions/.env.example ~/.config/zsh/functions/.env

# Editar con tus valores reales
nano ~/.config/zsh/functions/.env

# Agregar a tu .zshrc (carga en orden correcto)
cat >> ~/.zshrc << 'EOF'
# Cargar Zsh Functions (orden de dependencias)
source ~/.config/zsh/functions/core/env-loader.zsh
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

### ⚠️ Orden de Carga Importante

Es crucial cargar en este orden debido a dependencias:

1. **core/env-loader.zsh** - PRIMERO (carga variables de entorno desde `.env`)
2. **core/** - Funciones base
   - `colors.zsh` → `utils.zsh` → `print.zsh` → `spinners.zsh`
3. **git/** - Depende de core
4. **productivity/** - Depende de core
5. **deployment/** - Depende de core y variables de entorno
6. **testing/** - Depende de core
7. **aliases/** - ÚLTIMO (usa funciones de otros módulos y variables de entorno)

### Actualizar

```zsh
cd ~/.config/zsh/functions
git pull
source ~/.zshrc
```

## 🔒 Seguridad e Información Sensible

Este proyecto utiliza un sistema de configuración local para proteger información sensible:

### Archivos de Configuración

- **✅ `.env`** - Archivo local con tus credenciales (NO se sube al repo, está en `.gitignore`)
- **📄 `.env.example`** - Plantilla con valores dummy (incluida en el repo como referencia)

### Variables Protegidas

El archivo `.env` contiene información sensible como:

- URLs de servidores
- IDs de aplicaciones y servicios
- IDs de entornos de deployment
- Cualquier información específica de tu organización

## ⚡ Inicio Rápido

```zsh
# Ver ayuda de cualquier función
deploy --help
phoenix --help
wiremock_run_server --help

# Ejemplos rápidos
phoenix                          # Limpiar y reinstalar proyecto Node.js
goto --depth 3                   # Navegar interactivamente por directorios
gcls                            # Limpiar ramas Git huérfanas
deploy security@latest          # Deploy de última versión a todos los entornos
turn_the_command --test         # Ver demo de spinners
```

## 📋 Resumen de Comandos por Categoría

### 🔧 Productividad

- `phoenix` - Reiniciar proyecto Node.js
- `goto` - Navegador de directorios
- `seek_and_destroy` - Eliminar directorios recursivamente
- `zre` - Recargar configuración zsh

### 🚀 Deployment

- `deploy` - Deployment a Quicksilver

### 🌲 Git

- `no_branch_for_old_refs` - Limpiar ramas huérfanas en el repositorio
- `paranoid_sync` - Actualizar rama principal
- `paranoid_sync --all` - Actualizar múltiples repos

### 💬 UI/Output

- `msg` - Mensajes con formato
- `turn_the_command` - Spinners animados
- `select_option` - Selector interactivo
- `test_colors` - Ver paleta de colores

### 🎭 Testing

- `wiremock_run_server` - Servidor WireMock

### 🔍 Utilidades

- `extract_arg_value` - Validar argumentos
- `read_single_char` - Leer un carácter
- `print_indentation` - Imprimir indentación

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

## 🐛 Reportar Incidencias

Si encuentras un bug o tienes una sugerencia:

1. Verifica que no exista ya un issue similar
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Versión de Zsh y sistema operativo

## 📝 Licencia

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
- [COLORS.md](./core/COLORS.md) - Guía completa de colores
- [DEPLOY.md](./docs/DEPLOY.md) - Sistema de deployment completo
- [GIT.md](./docs/GIT.md) - Funciones Git avanzadas
- [PRINT.md](./core/PRINT.md) - Sistema de mensajes
- [PRODUCTIVITY.md](./docs/PRODUCTIVITY.md) - Herramientas de productividad
- [SPINNERS.md](./core/SPINNERS.md) - Animaciones y spinners
- [UTILS.md](./core/UTILS.md) - Utilidades de bajo nivel
- [WIREMOCK.md](./docs/WIREMOCK.md) - Servidor de mocking

---

## 📄 Licencia

Este proyecto está licenciado bajo la [Licencia MIT](LICENSE) - consulta el archivo LICENSE para más detalles.

---

**¿Preguntas o sugerencias?** Abre un issue en GitHub.
