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

El instalador automáticamente:

- ✅ Clona el repositorio en `~/.config/zsh/mangoose`
- ✅ Crea el archivo `.env` desde `.env.example`
- ✅ Hace backup de tu `.zshrc`
- ✅ Agrega la configuración necesaria a `.zshrc`
- ✅ Respeta configuraciones existentes
- ✅ Permite actualizar si ya está instalado

### ⚙️ Configuración Post-Instalación

Después de instalar, **edita el archivo `.env` con tus valores reales**:

```zsh
nano ~/.config/zsh/mangoose/.env
# o con tu editor preferido
code ~/.config/zsh/mangoose/.env
```

#### 🔧 Variables Disponibles

##### Productivity

| Variable          | Descripción                                                     | Ejemplo |
| ----------------- | --------------------------------------------------------------- | ------- |
| `PACKAGE_MANAGER` | Gestor usado por las funciones Node.js (`pnpm`, `npm` o `yarn`) | `pnpm`  |

##### Deployment

| Variable              | Descripción                                                       | Ejemplo                                    |
| --------------------- | ----------------------------------------------------------------- | ------------------------------------------ |
| `DEPLOY_SERVER_URL`   | URL base del servidor de deployment                               | `https://deploy-server.example.com`        |
| `DEPLOY_APPS`         | Array de aplicaciones (formato: `ID_APP:NOMBRE_APP`)              | `("138:ods-pri" "140:ods-api")`            |
| `DEPLOY_SERVICES`     | Array de servicios disponibles (formato: `ID:NOMBRE:NOMBRE_APP`)  | `("1001:auth:ods-pri" "2001:api:ods-api")` |
| `DEPLOY_ENVIRONMENTS` | Array de entornos de deployment (formato: `ID:NOMBRE:NOMBRE_APP`) | `("1001:DEV:ods-pri" "2001:DEV:ods-api")`  |

**Formato de `DEPLOY_APPS`:**

```zsh
DEPLOY_APPS=(
  "138:ods-pri"
  "140:ods-api"
)
```

**Formato de `DEPLOY_SERVICES`:**

```zsh
DEPLOY_SERVICES=(
  "1001:auth:ods-pri"
  "1002:users:ods-pri"
  "2001:api-data:ods-api"
)
```

**Formato de `DEPLOY_ENVIRONMENTS`:**

```zsh
DEPLOY_ENVIRONMENTS=(
  "1001:DEVELOPMENT:ods-pri"
  "1002:DEVELOPMENT Contact Center:ods-pri"
  "2001:DEVELOPMENT:ods-api"
  "2002:DEVELOPMENT Contact Center:ods-api"
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

# Arrays (para DEPLOY_APPS, DEPLOY_SERVICES y DEPLOY_ENVIRONMENTS)
export DEPLOY_APPS=(
  "138:ods-pri"
  "140:ods-api"
)

export DEPLOY_SERVICES=(
  "1001:auth:ods-pri"
  "1002:users:ods-pri"
)

export DEPLOY_ENVIRONMENTS=(
  "1001:DEVELOPMENT:ods-pri"
  "1003:QA:ods-pri"
  "2001:DEVELOPMENT:ods-api"
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

**⚠️ Importante:** Después de la instalación, debes editar el `.env` con tus valores reales antes de usar comandos como `deploy`.

### Instalación Manual

Si prefieres clonar el repositorio en una ubicación específica:

```zsh
# Clonar el repositorio en la ubicación que prefieras
git clone https://github.com/elmango80/mangoose.git /tu/ruta/preferida/mangoose

# Ejecutar el script de instalación desde ese directorio
cd /tu/ruta/preferida/mangoose
./install.sh
```

El script detectará automáticamente que está en un repositorio clonado y usará esa ubicación.

**O completamente manual:**

```zsh
# Clonar el repositorio
git clone https://github.com/elmango80/mangoose.git ~/mi-ubicacion/mangoose

# Crear archivo de configuración desde el ejemplo
cp ~/mi-ubicacion/mangoose/.env.example ~/mi-ubicacion/mangoose/.env

# Editar con tus valores reales
nano ~/mi-ubicacion/mangoose/.env

# Agregar a tu .zshrc (reemplaza ~/mi-ubicacion/mangoose con tu ruta)
cat >> ~/.zshrc << 'EOF'
# Cargar Mangoose (orden de dependencias)
source ~/mangoose/core/env-loader.zsh
source ~/mangoose/core/colors.zsh
source ~/mangoose/core/utils.zsh
source ~/mangoose/core/print.zsh
source ~/mangoose/core/spinners.zsh
source ~/mangoose/git/git.zsh
source ~/mangoose/productivity/productivity.zsh
source ~/mangoose/deployment/deploy.zsh
source ~/mangoose/testing/wiremock.zsh
source ~/mangoose/aliases/aliases.zsh
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

Si instalaste con el script automático:

```zsh
# Volver a ejecutar el instalador, te dará opción de actualizar
curl -fsSL https://raw.githubusercontent.com/elmango80/mangoose/master/install.sh | zsh
```

O manualmente:

```zsh
cd ~/.config/zsh/mangoose  # o la ruta donde lo clonaste
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
