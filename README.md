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

## 📁 Estructura del Proyecto

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

**Documentación detallada:**

- [ALIASES](./docs/ALIASES.md)
- [COLORS](./docs/COLORS.md)
- [DEPLOY](./docs/DEPLOY.md)
- [GIT](./docs/GIT.md)
- [PRINT](./docs/PRINT.md)
- [PRODUCTIVITY](./docs/PRODUCTIVITY.md)
- [SPINNERS](./docs/SPINNERS.md)
- [UTILS](./docs/UTILS.md)
- [WIREMOCK](./docs/WIREMOCK.md)
- [CONFIGURACIÓN](./docs/configuration.md) - Variables de entorno y configuración

## 📦 Instalación

### Instalación Automática (Recomendado)

```zsh
# Descargar e instalar con un comando
curl -fsSL https://raw.githubusercontent.com/elmango80/zsh-functions/master/install.sh | zsh
```

### ⚙️ Configuración Post-Instalación

Después de instalar, **edita el archivo `.env` con tus valores reales**:

```zsh
nano ~/.config/zsh/functions/.env
# o con tu editor preferido
```

Ver [Guía de Configuración](./docs/configuration.md) para más detalles.

O descarga primero y luego ejecuta:

```zsh
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

```zsh
# Clonar el repositorio
git clone https://github.com/elmango80/zsh-functions.git ~/.config/zsh/functions

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

### Instalación con Loop (Alternativa)

```zsh
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

```zsh
cd ~/.config/zsh/functions
git pull
source ~/.zshrc
```

## 🔒 Seguridad e Información Sensible

Este proyecto utiliza un sistema de configuración local para proteger información sensible:

- **✅ `.env`** - Archivo local con tus credenciales (NO se sube al repo, está en `.gitignore`)
- **📄 `.env.example`** - Plantilla con valores dummy (incluida en el repo como referencia)
- **🔐 Variables protegidas**:
  - URLs de servidores
  - IDs de aplicaciones y servicios
  - IDs de entornos de deployment
  - Cualquier información específica de tu organización

**Importante:**

- ⚠️ NUNCA hagas commit del archivo `.env`
- ⚠️ NUNCA compartas tu archivo `.env` con otros
- ✅ Siempre usa `.env.example` como referencia
- ✅ Cada instalación debe tener su propio `.env` configurado

Ver [Guía de Configuración](./docs/configuration.md) para más detalles sobre seguridad.

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
run_with_spinner --test         # Ver demo de spinners
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
- [COLORS.md](./docs/COLORS.md) - Guía completa de colores
- [DEPLOY.md](./docs/DEPLOY.md) - Sistema de deployment completo
- [GIT.md](./docs/GIT.md) - Funciones Git avanzadas
- [PRINT.md](./docs/PRINT.md) - Sistema de mensajes
- [PRODUCTIVITY.md](./docs/PRODUCTIVITY.md) - Herramientas de productividad
- [SPINNERS.md](./docs/SPINNERS.md) - Animaciones y spinners
- [UTILS.md](./docs/UTILS.md) - Utilidades de bajo nivel
- [WIREMOCK.md](./docs/WIREMOCK.md) - Servidor de mocking

---

## 📄 Licencia

Este proyecto está licenciado bajo la [Licencia MIT](LICENSE) - consulta el archivo LICENSE para más detalles.

---

**¿Preguntas o sugerencias?** Abre un issue en GitHub.
