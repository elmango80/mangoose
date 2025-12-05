# Zsh Functions Collection

Colección de funciones útiles para Zsh que mejoran la productividad y experiencia en la terminal.

## 📦 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/TU_USUARIO/zsh-functions.git ~/.config/zsh/functions

# Agregar a tu .zshrc
echo 'source ~/.config/zsh/functions/aliases.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/colors.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/deploy.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/git.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/print.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/productivity.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/spinners.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/utils.zsh' >> ~/.zshrc
echo 'source ~/.config/zsh/functions/wiremock.zsh' >> ~/.zshrc

# Recargar la configuración
source ~/.zshrc
```

## 🚀 Funciones Disponibles

### Productividad

#### `phoenix`
Reinicia completamente un proyecto Node.js eliminando dependencias y reconstruyendo.

```bash
phoenix                 # Limpieza estándar
phoenix --hard          # Limpieza agresiva completa
phoenix --help          # Muestra ayuda
```

**Características:**
- Elimina `node_modules`, `dist`, y `.yalc`
- Modo `--hard`: elimina también `yarn.lock`, limpia caché de yarn y remueve enlaces yalc
- Reinstala automáticamente las dependencias

### Deployment

#### `deploy`
Realiza deployment en Quicksilver de servicios a múltiples entornos.

```bash
deploy security                        # Lista versiones y selecciona interactivamente
deploy security@latest                 # Despliega última versión disponible
deploy security@0.52.1                 # Despliega versión específica
deploy login@0.52.1 --dry-run          # Simula deployment sin ejecutar
deploy --help                          # Muestra ayuda
```

**Entornos soportados:**
- DEVELOPMENT
- DEVELOPMENT Contact Center
- QUALITY ASSURANCE
- QUALITY ASSURANCE Contact Center
- STAGING
- STAGING Contact Center

### Spinners y UI

#### `run_with_spinner`
Ejecuta comandos mostrando un spinner animado mientras se procesan.

```bash
run_with_spinner --command "sleep 3" --message "Procesando..."
run_with_spinner --command "npm install" --message "Instalando dependencias" --spinner dots
run_with_spinner --help
```

**Spinners disponibles:**
- dots, balloon, grow-vertical, grow-horizontal
- line, pipe, simpleDots, simpleDotsScrolling
- star, star2, flip, hamburger
- growVertical, growHorizontal, noise, bounce
- boxBounce, boxBounce2, triangle, arc
- circle, squareCorners, circleQuarters, circleHalves
- squish, toggle, toggle2, toggle3, toggle4, toggle5
- toggle6, toggle7, toggle8, toggle9, toggle10, toggle11
- toggle12, toggle13, arrow, arrow2, arrow3, bouncingBar
- bouncingBall, smiley, monkey, hearts, clock, earth, moon, runner, pong, shark, dqpb

### Git

Funciones útiles para trabajar con Git (ver `git.zsh`).

### WireMock

Funciones para trabajar con WireMock (ver `wiremock.zsh`).

### Colores y Mensajes

#### Sistema de colores
Definiciones de colores y utilidades para output en terminal (ver `colors.zsh`).

#### `msg`
Sistema de mensajes con soporte para colores, iconos y formato.

```bash
msg "Mensaje normal"
msg "Mensaje de éxito" --success
msg "Mensaje de error" --error
msg "Mensaje de advertencia" --warning
msg "Mensaje informativo" --info
msg "Mensaje sin icono" --no-icon
msg "Mensaje con tabulación" --tab 2
msg --blank  # Línea en blanco
```

## 📋 Requisitos

- Zsh shell
- Git
- Node.js y Yarn (para funciones de productividad)
- curl (para funciones de deployment)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## ✨ Autor

Tu nombre - [@tu_usuario](https://github.com/TU_USUARIO)

## 🙏 Agradecimientos

- Inspirado en la comunidad de Zsh
- Diseñado para mejorar la productividad diaria en el desarrollo
