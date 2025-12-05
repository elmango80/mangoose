# Core Functions

Funciones base y utilidades fundamentales que son usadas por otros módulos.

## Archivos

### colors.zsh

Sistema completo de definiciones de colores ANSI, 256 colores y RGB True Color.

**Ver documentación completa:** [COLORS.md](../docs/COLORS.md)

**Incluye:**

- Colores básicos ANSI
- Colores brillantes/intensos
- Bold colors
- Estilos de texto (bold, italic, underline, etc.)
- Colores extendidos (256)
- RGB True Color
- Función `test_colors` para visualización

### print.zsh

Sistema de mensajes con formato, colores e iconos.

**Ver documentación completa:** [PRINT.md](../docs/PRINT.md)

**Funciones principales:**

- `msg` - Mensajes con colores e iconos
- `print_indentation` - Manejo de indentación
- `_output_message` - Salida a stdout/stderr

### utils.zsh

Funciones utilitarias de bajo nivel.

**Ver documentación completa:** [UTILS.md](../docs/UTILS.md)

**Funciones principales:**

- `extract_arg_value` - Validación de argumentos
- `read_single_char` - Leer un carácter sin Enter
- `zre` - Recargar configuración Zsh
- `select_option` - Selector interactivo con flechas

### spinners.zsh

Sistema de animaciones y spinners para feedback visual.

**Ver documentación completa:** [SPINNERS.md](../docs/SPINNERS.md)

**Funciones principales:**

- `run_with_spinner` - Ejecutar comandos con spinner animado
- `test_spinner` - Demostración de spinners

**Modelos disponibles:**
dots, balloon, grow-vertical, grow-horizontal, star, hamburger, arc, circle

## Dependencias

Estos módulos son fundamentales y son usados por:

- git/
- productivity/
- deployment/
- testing/
- aliases/

## Orden de Carga

Es importante cargar estos archivos en este orden:

1. `colors.zsh` - Define variables de colores
2. `utils.zsh` - Funciones utilitarias básicas
3. `print.zsh` - Usa colors y utils
4. `spinners.zsh` - Usa colors, utils y print

## Uso

```zsh
# Cargar todo el módulo core
source ~/.config/zsh/functions/core/colors.zsh
source ~/.config/zsh/functions/core/utils.zsh
source ~/.config/zsh/functions/core/print.zsh
source ~/.config/zsh/functions/core/spinners.zsh
```
