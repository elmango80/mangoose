# Colors (colors.zsh)

Sistema de definiciones de colores y estilos para terminal.

## 🎨 Colores Básicos ANSI

### Colores Estándar

```bash
BLACK    RED      GREEN    YELLOW
BLUE     PURPLE   CYAN     WHITE
```

### Ejemplo de Uso

```bash
echo -e "${RED}Texto en rojo${NC}"
echo -e "${GREEN}Texto en verde${NC}"
echo -e "${BLUE}Texto en azul${NC}"
```

## ✨ Colores Brillantes/Intensos

### Colores Light

```bash
LIGHT_BLACK    # Gris oscuro
LIGHT_RED      LIGHT_GREEN    LIGHT_YELLOW
LIGHT_BLUE     LIGHT_PURPLE   LIGHT_CYAN
LIGHT_WHITE
```

### Aliases

```bash
GRAY    # Alias para LIGHT_BLACK
GREY    # Alias para LIGHT_BLACK
```

### Ejemplo

```bash
echo -e "${LIGHT_RED}Rojo brillante${NC}"
echo -e "${GRAY}Texto gris${NC}"
```

## 🔥 Colores en Negrita

### Bold Colors

```bash
BOLD_BLACK     BOLD_RED       BOLD_GREEN     BOLD_YELLOW
BOLD_BLUE      BOLD_PURPLE    BOLD_CYAN      BOLD_WHITE
```

### Ejemplo

```bash
echo -e "${BOLD_RED}Error crítico${NC}"
echo -e "${BOLD_GREEN}✓ Éxito${NC}"
```

## 📝 Estilos de Texto

### Estilos Disponibles

| Variable         | Efecto               |
| ---------------- | -------------------- |
| `BOLD`           | **Texto en negrita** |
| `DIM`            | Texto atenuado       |
| `ITALIC`         | _Texto en cursiva_   |
| `UNDERLINE`      | Texto subrayado      |
| `BLINK`          | Texto parpadeante    |
| `REVERSE`        | Invierte fg/bg       |
| `STRIKE_THROUGH` | ~~Texto tachado~~    |

### Ejemplo

```bash
echo -e "${BOLD}Negrita${NC}"
echo -e "${ITALIC}Cursiva${NC}"
echo -e "${UNDERLINE}Subrayado${NC}"
echo -e "${DIM}Atenuado${NC}"
```

### Combinación de Estilos

```bash
echo -e "${BOLD}${RED}Rojo en negrita${NC}"
echo -e "${ITALIC}${BLUE}Azul en cursiva${NC}"
echo -e "${UNDERLINE}${GREEN}Verde subrayado${NC}"
```

## 🌈 Colores Extendidos (256 colores)

### Paleta Extendida

```bash
BLUE_DODGER    # Azul dodger
CORAL          # Coral
GOLD           # Dorado
LIME           # Lima
ORANGE         # Naranja
PINK           # Rosa
RED_BRIGHT     # Rojo brillante
SALMON         # Salmón
TURQUOISE      # Turquesa
VIOLET         # Violeta
```

### Ejemplo

```bash
echo -e "${ORANGE}Texto naranja${NC}"
echo -e "${TURQUOISE}Texto turquesa${NC}"
echo -e "${PINK}Texto rosa${NC}"
```

## 🎨 RGB True Color

### Colores RGB Personalizados

```bash
RGB_CORAL      # rgb(255, 127, 80)
RGB_FOREST     # rgb(34, 139, 34) - Verde bosque
RGB_GOLD       # rgb(255, 215, 0)
RGB_LAVENDER   # rgb(230, 230, 250)
RGB_SKY        # rgb(135, 206, 235) - Azul cielo
RGB_SUNSET     # rgb(255, 94, 77) - Naranja atardecer
```

### Sintaxis RGB Custom

```bash
# Formato: \033[38;2;R;G;Bm
CUSTOM_COLOR='\033[38;2;100;200;150m'
echo -e "${CUSTOM_COLOR}Color personalizado${NC}"
```

### Ejemplo

```bash
echo -e "${RGB_SUNSET}Atardecer naranja${NC}"
echo -e "${RGB_SKY}Cielo azul${NC}"
echo -e "${RGB_FOREST}Bosque verde${NC}"
```

## 🔄 Reset

### Variables de Reset

```bash
NC      # No Color - Reset to default
RESET   # Alias para NC
```

### Uso

```bash
# Siempre resetear después de aplicar color
echo -e "${RED}Rojo${NC} Normal ${BLUE}Azul${NC}"

# Al final de cada línea coloreada
echo -e "${BOLD}${GREEN}Texto importante${NC}"
```

## 🧪 Función de Test

### test_colors

Función para visualizar todos los colores disponibles.

```bash
test_colors
```

### Salida

Muestra secciones organizadas de:

1. Colores básicos ANSI
2. Colores brillantes/intensos
3. Aliases de colores
4. Colores en negrita
5. Estilos de texto
6. Colores extendidos (256)
7. Colores RGB True Color

## 📋 Guía Rápida de Uso

### Estructura Básica

```bash
echo -e "${COLOR}texto${NC}"
```

### Ejemplos Prácticos

```bash
# Mensajes de estado
echo -e "${GREEN}✓${NC} Operación exitosa"
echo -e "${RED}✗${NC} Error encontrado"
echo -e "${YELLOW}⚠${NC} Advertencia"

# Headers
echo -e "${BOLD}${BLUE}=== Sección Principal ===${NC}"

# Código inline
echo -e "Ejecuta ${CYAN}npm install${NC} para instalar"

# Destacar información
echo -e "Usuario: ${BOLD}${GREEN}admin${NC}"
echo -e "Puerto: ${YELLOW}8080${NC}"

# Combinaciones avanzadas
echo -e "${BOLD}${UNDERLINE}${BLUE}Título Importante${NC}"
```

## 🎯 Mejores Prácticas

### 1. Siempre Resetear

```bash
# ✅ Correcto
echo -e "${RED}Error${NC}"

# ❌ Incorrecto (afecta texto siguiente)
echo -e "${RED}Error"
```

### 2. Usar Variables Semánticas

```bash
# ✅ Mejor
SUCCESS_COLOR="${GREEN}"
ERROR_COLOR="${RED}"
echo -e "${SUCCESS_COLOR}Éxito${NC}"

# ⚠️ Funcional pero menos mantenible
echo -e "${GREEN}Éxito${NC}"
```

### 3. Compatibilidad

```bash
# Verificar soporte de color
if [[ -t 1 ]]; then
  # Terminal interactiva - usar colores
  echo -e "${GREEN}Coloreado${NC}"
else
  # Pipe o redirección - texto plano
  echo "Sin colores"
fi
```

### 4. Legibilidad

```bash
# ✅ Clara separación
echo -e "${BOLD}${RED}Error:${NC} ${DIM}Descripción del error${NC}"

# ❌ Difícil de leer
echo -e "${BOLD}${RED}Error:Descripcióndeleerror${NC}"
```

## 📝 Notas

- Requiere terminal con soporte ANSI
- No todos los terminales soportan todos los colores/estilos
- `NC` (No Color) es esencial para evitar "bleeding" de colores
- True Color (RGB) requiere terminal moderno
- Los colores 256 son más compatibles que RGB
- Algunos estilos (BLINK, por ejemplo) pueden no funcionar en todos los terminales

## 🔗 Integración

Estas variables se usan en:

- `msg` - Sistema de mensajes
- `run_with_spinner` - Feedback visual
- `deploy` - Estados de deployment
- Todas las funciones que producen output coloreado

## 🧪 Testing

```bash
# Probar todos los colores
test_colors

# Probar color específico
echo -e "${RGB_SUNSET}Probando sunset${NC}"

# Verificar soporte terminal
echo -e "${BOLD}Negrita${NC} ${ITALIC}Cursiva${NC} ${UNDERLINE}Subrayado${NC}"
```
