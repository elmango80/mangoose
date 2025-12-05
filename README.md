# Zsh Functions Collection

Colección completa de funciones y utilidades para Zsh que mejoran significativamente la productividad en desarrollo, automatización de deployments, gestión de repositorios Git y mucho más.

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

## 📚 Documentación por Módulo

Cada módulo tiene su propia documentación detallada:

| Módulo           | Archivo                              | Descripción                                             |
| ---------------- | ------------------------------------ | ------------------------------------------------------- |
| **Aliases**      | [ALIASES.md](./ALIASES.md)           | Más de 90 aliases para npm, yarn, git, navegación y más |
| **Colors**       | [COLORS.md](./COLORS.md)             | Sistema completo de colores ANSI, 256 y RGB             |
| **Deploy**       | [DEPLOY.md](./DEPLOY.md)             | Sistema de deployment a Quicksilver (multi-entorno)     |
| **Git**          | [GIT.md](./GIT.md)                   | Limpieza de ramas, sincronización de repos              |
| **Print**        | [PRINT.md](./PRINT.md)               | Sistema de mensajes con formato e iconos                |
| **Productivity** | [PRODUCTIVITY.md](./PRODUCTIVITY.md) | seek_and_destroy, phoenix, goto                         |
| **Spinners**     | [SPINNERS.md](./SPINNERS.md)         | Animaciones y spinners para procesos                    |
| **Utils**        | [UTILS.md](./UTILS.md)               | Funciones utilitarias de bajo nivel                     |
| **WireMock**     | [WIREMOCK.md](./WIREMOCK.md)         | Servidor WireMock para mocking de APIs                  |

## 📦 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/TU_USUARIO/zsh-functions.git ~/.config/zsh/functions

# Agregar a tu .zshrc (o crear un archivo de carga)
cat >> ~/.zshrc << 'EOF'
# Cargar Zsh Functions
for func_file in ~/.config/zsh/functions/*.zsh; do
  source "$func_file"
done
EOF

# Recargar la configuración
source ~/.zshrc
```

### Instalación Manual

Si prefieres cargar archivos específicos:

```bash
echo 'source ~/.config/zsh/functions/colors.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/print.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/utils.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/spinners.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/git.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/productivity.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/deploy.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/wiremock.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/aliases.zsh' >> ~/.zshrc
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

Para documentación detallada de cada módulo, consulta los archivos individuales:

- [ALIASES.md](./ALIASES.md) - Todos los aliases disponibles
- [COLORS.md](./COLORS.md) - Guía completa de colores
- [DEPLOY.md](./DEPLOY.md) - Sistema de deployment completo
- [GIT.md](./GIT.md) - Funciones Git avanzadas
- [PRINT.md](./PRINT.md) - Sistema de mensajes
- [PRODUCTIVITY.md](./PRODUCTIVITY.md) - Herramientas de productividad
- [SPINNERS.md](./SPINNERS.md) - Animaciones y spinners
- [UTILS.md](./UTILS.md) - Utilidades de bajo nivel
- [WIREMOCK.md](./WIREMOCK.md) - Servidor de mocking

---

**¿Preguntas o sugerencias?** Abre un issue en GitHub.
