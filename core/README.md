# Core Functions

Funciones base y utilidades del sistema.

## 📚 Documentación Completa

Cada módulo tiene su documentación detallada:

- **[COLORS.md](COLORS.md)** - Sistema de colores (ANSI, 256, RGB)
- **[PRINT.md](PRINT.md)** - Sistema de mensajes con formato e íconos
- **[SPINNERS.md](SPINNERS.md)** - Animaciones de carga y spinners
- **[UTILS.md](UTILS.md)** - Utilidades generales (selector, readline, etc.)

## 🎨 colors.zsh

Sistema completo de colores para la terminal.

**Principales características:**

- Colores ANSI básicos (16 colores)
- Paleta de 256 colores
- Soporte RGB (TrueColor)
- Estilos de texto (bold, italic, dim, etc.)
- Función `test_colors` para visualizar paletas

📖 **[Ver documentación completa →](COLORS.md)**

## 💬 print.zsh

Sistema de mensajes con formato, íconos y colores.

**Principales características:**

- Función `msg` con múltiples tipos (success, error, warning, info)
- Íconos automáticos según tipo de mensaje
- Tabulación y formato
- Redirección a stderr
- Sin saltos de línea opcionales

📖 **[Ver documentación completa →](PRINT.md)**

## ⏳ spinners.zsh

Animaciones de carga y feedback visual.

**Principales características:**

- Función `turn_the_command` para ejecutar comandos con animación
- Múltiples estilos de spinners
- Integración con sistema de mensajes
- Manejo de errores visual

📖 **[Ver documentación completa →](SPINNERS.md)**

## 🛠️ utils.zsh

Utilidades generales del sistema.

**Principales características:**

- `select_option` - Selector interactivo de opciones
- `read_single_char` - Lectura de un solo caracter
- Funciones auxiliares de validación

📖 **[Ver documentación completa →](UTILS.md)**

## 🔧 env-loader.zsh

Cargador de variables de entorno desde `.env`.

**Funcionalidad:**

- Carga automática de archivo `.env`
- Validación de existencia
- Mensajes de error si falta configuración

📖 **Ver:** [configuration.md](../docs/configuration.md) para detalles de configuración

## 📦 Uso

```zsh
# Cargar todos los módulos core
source ~/.config/zsh/functions/core/colors.zsh
source ~/.config/zsh/functions/core/print.zsh
source ~/.config/zsh/functions/core/spinners.zsh
source ~/.config/zsh/functions/core/utils.zsh
source ~/.config/zsh/functions/core/env-loader.zsh
```

## 🔗 Dependencias

- **colors.zsh** - Base para todos los demás módulos
- **print.zsh** - Requiere colors.zsh
- **spinners.zsh** - Requiere colors.zsh y print.zsh
- **utils.zsh** - Independiente
- **env-loader.zsh** - Independiente

## 🧪 Testing

```zsh
# Ver paleta de colores
test_colors

# Probar mensajes
msg "Test message" --success
msg "Error message" --error

# Probar spinner
turn_the_command --command "sleep 2" --message "Procesando..."

# Probar selector
select_option "Opción 1" "Opción 2" "Opción 3"
```
