# Print Functions (print.zsh)

Sistema de mensajes con formato, colores e iconos.

## 💬 msg

Función principal para mostrar mensajes con formato, colores e iconos.

### Uso

```zsh
msg "Mensaje" [TIPO] [OPCIONES]
msg [TIPO] "Mensaje" [OPCIONES]
```

### Tipos de Mensaje

| Tipo            | Icono | Color      | Descripción          |
| --------------- | ----- | ---------- | -------------------- |
| `--error`       | ❌    | Rojo       | Mensajes de error    |
| `--warning, -w` | ⚠️    | Amarillo   | Advertencias         |
| `--info, -i`    | ℹ️    | Azul claro | Información          |
| `--success, -s` | ✅    | Verde      | Operaciones exitosas |
| `--debug`       | 🐛    | Púrpura    | Mensajes de debug    |
| `--notice, -n`  | 📋    | Cyan       | Notificaciones       |
| `--dim`         | -     | Atenuado   | Texto secundario     |
| (ninguno)       | -     | Normal     | Texto plano          |

### Opciones

- `--tab N` - Nivel de indentación (2 espacios por nivel)
- `--to-stderr` - Enviar a stderr en lugar de stdout
- `--no-newline` - No agregar salto de línea al final
- `--no-icon` - No mostrar icono (solo color)
- `--blank` - Imprimir línea en blanco
- `--help, -h` - Mostrar ayuda

### Ejemplos Básicos

```zsh
# Mensaje simple
msg "Iniciando proceso..."

# Mensajes con tipo
msg "Operación completada" --success
msg "Advertencia importante" --warning
msg "Error al conectar" --error
msg "Información útil" --info

# Orden flexible
msg --error "Error al conectar"
msg "Error al conectar" --error
```

### Ejemplos con Opciones

```zsh
# Con indentación
msg "Nivel 1"
msg "Nivel 2" --tab 1
msg "Nivel 3" --tab 2

# Sin salto de línea
msg "Cargando..." --no-newline
sleep 2
msg " ✓ Listo" --success

# Sin icono
msg "Error sin icono" --error --no-icon

# A stderr
msg "Error crítico" --error --to-stderr

# Línea en blanco
msg "Antes"
msg --blank
msg "Después"
```

### Ejemplos Avanzados

```zsh
# Progreso indentado
msg "Iniciando deployment" --info
msg "Verificando conexión..." --tab 1
msg "Conectado" --success --tab 2
msg "Desplegando archivos..." --tab 1
msg "Completado" --success --tab 2

# Mensajes de debug
msg "Debug: valor=$valor" --debug --to-stderr

# Mensajes sin nueva línea para prompts
msg "¿Continuar? (y/n): " --no-newline
read respuesta

# Combinación de estilos
msg "===============" --dim
msg "Título Principal" --info --no-icon
msg "===============" --dim
msg --blank
msg "Descripción del proceso..." --dim
```

### Uso en Scripts

```zsh
# Función de validación
validate_input() {
  if [[ -z "$1" ]]; then
    msg "Entrada vacía" --error --to-stderr
    return 1
  fi
  msg "Entrada válida" --success
  return 0
}

# Proceso con feedback
process_files() {
  msg "Procesando archivos..." --info

  for file in *.txt; do
    msg "Procesando: $file" --tab 1
    if process_file "$file"; then
      msg "✓ Completado" --success --tab 2 --no-icon
    else
      msg "✗ Falló" --error --tab 2 --no-icon
    fi
  done

  msg --blank
  msg "Proceso finalizado" --success
}

# Headers de secciones
show_section() {
  msg --blank
  msg "================================" --dim
  msg "$1" --info --no-icon
  msg "================================" --dim
  msg --blank
}
```

### Comportamiento de Salida

#### stdout (default)

- Mensajes normales, success, warning, info, notice, dim
- Usado para output normal del programa

#### stderr (automático o con --to-stderr)

- Mensajes de error (automático)
- Mensajes de debug (automático)
- Cualquier mensaje con `--to-stderr`
- No contamina pipes ni redirecciones

### Indentación

La opción `--tab N` aplica `N` niveles de indentación:

```zsh
msg "Nivel 0"
msg "Nivel 1" --tab 1    # 2 espacios
msg "Nivel 2" --tab 2    # 4 espacios
msg "Nivel 3" --tab 3    # 6 espacios
```

### Validación

La función valida:

- ✅ Texto del mensaje requerido (excepto con `--blank`)
- ✅ Argumentos desconocidos producen error
- ✅ Ayuda con `--help`

### Mensajes de Error

```zsh
# Sin texto
msg --error
# ❌ Error: Message text is required

# Argumento desconocido
msg "texto" --unknown
# ❌ Error: Unknown argument '--unknown'
```

## 🖨️ print_indentation

Función auxiliar para imprimir espacios de indentación.

### Uso

```zsh
print_indentation [N]
```

### Parámetros

- `N` - Número de niveles de tabulación (default: 0)
- Cada nivel = 2 espacios

### Ejemplo

```zsh
print_indentation 0    # "" (sin espacios)
print_indentation 1    # "  " (2 espacios)
print_indentation 2    # "    " (4 espacios)
print_indentation 3    # "      " (6 espacios)
```

### Uso Directo

```zsh
# Imprimir con indentación
print_indentation 2
echo "Texto indentado"

# En un loop
for i in {1..3}; do
  print_indentation $i
  echo "Nivel $i"
done
```

## 🔧 \_output_message

Función auxiliar interna para manejar stdout/stderr.

### Uso Interno

```zsh
_output_message "mensaje" 0    # a stdout
_output_message "mensaje" 1    # a stderr
```

### Parámetros

- `$1` - Mensaje a imprimir
- `$2` - Flag stderr (0=stdout, 1=stderr)

### Nota

Esta es una función interna. Usa `msg` para uso normal.

## 📋 Patrones Comunes

### Progress Report

```zsh
msg "==========================" --dim
msg "Iniciando proceso" --info --no-icon
msg "==========================" --dim
msg --blank

msg "Paso 1: Preparación" --tab 1
msg "Verificando requisitos..." --tab 2
msg "OK" --success --tab 3

msg "Paso 2: Ejecución" --tab 1
msg "Procesando datos..." --tab 2
msg "OK" --success --tab 3

msg --blank
msg "Proceso completado exitosamente" --success
```

### Error Handling

```zsh
if ! command; then
  msg "Error ejecutando comando" --error --to-stderr
  msg "Detalles del error:" --tab 1 --dim
  msg "$error_details" --tab 2 --error --no-icon
  return 1
fi
```

### Interactive Prompts

```zsh
msg "¿Desea continuar? (y/n): " --no-newline
read answer
if [[ "$answer" == "y" ]]; then
  msg "Continuando..." --success
else
  msg "Cancelado" --warning
fi
```

### Logging Levels

```zsh
# Según nivel de verbosidad
VERBOSE=2

[[ $VERBOSE -ge 1 ]] && msg "Info general" --info
[[ $VERBOSE -ge 2 ]] && msg "Detalles adicionales" --debug
[[ $VERBOSE -ge 3 ]] && msg "Trace completo" --dim
```

## 📝 Notas

- Requiere `colors.zsh` para definiciones de colores
- Requiere `utils.zsh` para `print_indentation` y `extract_arg_value`
- Los iconos requieren terminal con soporte UTF-8
- Los mensajes de error/debug van automáticamente a stderr
- Compatible con pipes y redirecciones
- Soporta orden flexible de argumentos

## 🎨 Personalización

```zsh
# Crear funciones wrapper personalizadas
err() { msg "$@" --error; }
warn() { msg "$@" --warning; }
info() { msg "$@" --info; }
success() { msg "$@" --success; }

# Uso simplificado
err "Algo salió mal"
success "Todo bien"
info "Procesando..."
```

## 🔗 Integración

Esta función es usada por:

- Todas las funciones del proyecto
- `deploy` - Mensajes de deployment
- `phoenix` - Feedback de operaciones
- `seek_and_destroy` - Confirmaciones
- `run_with_spinner` - Estados finales
- `clean_repository` - Reportes de limpieza

## 🧪 Testing

```zsh
# Probar todos los tipos
msg "Normal message"
msg "Success message" --success
msg "Error message" --error
msg "Warning message" --warning
msg "Info message" --info
msg "Debug message" --debug
msg "Notice message" --notice
msg "Dimmed message" --dim

# Probar opciones
msg "Indented" --tab 2
msg "No icon" --error --no-icon
msg "No newline" --no-newline
msg --blank
```
