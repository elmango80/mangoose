# Utility Functions (utils.zsh)

Funciones utilitarias generales de bajo nivel.

## 🔧 extract_arg_value

Extrae y valida el valor de un argumento de línea de comandos.

### Uso

```bash
if value=$(extract_arg_value "<nombre_arg>" "$2"); then
  # Usar $value
else
  return 1
fi
```

### Parámetros

- `$1` - Nombre del argumento (para mensajes de error)
- `$2` - Valor a extraer y validar

### Retorno

- Imprime el valor a stdout si es válido
- Retorna `0` si el valor es válido
- Retorna `1` si el valor es inválido o vacío
- Envía errores a stderr

### Validación

El valor se considera **inválido** si:

- Está vacío
- Comienza con `-` (es otro flag)

### Ejemplos

```bash
# En una función que procesa argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
    --port)
      if port=$(extract_arg_value "--port" "$2"); then
        shift 2
      else
        return 1
      fi
      ;;
  esac
done
```

### Mensaje de Error

```
❌ Error: <nombre_arg> requires a value
```

## 📝 read_single_char

Lee un solo carácter del teclado sin necesidad de presionar Enter.

### Uso

```bash
answer=$(read_single_char)
echo "Respuesta: $answer"
```

### Parámetros

- `$1` - **OPCIONAL** - Texto del prompt (actualmente comentado)

### Retorno

- Imprime el carácter leído en minúsculas
- No requiere presionar Enter
- Convierte automáticamente a lowercase

### Descripción

Utiliza `stty` para cambiar temporalmente el modo de terminal:

1. Guarda configuración actual de terminal
2. Cambia a modo raw sin echo
3. Lee un solo carácter
4. Restaura configuración original
5. Retorna el carácter en minúsculas

### Ejemplos

```bash
# Confirmación simple
msg "¿Continuar? (y/n): " --no-newline
answer=$(read_single_char)
if [[ "$answer" == "y" ]]; then
  # Continuar
fi

# Selector de opciones
msg "Selecciona (a/b/c): " --no-newline
choice=$(read_single_char)
case "$choice" in
  a) do_option_a ;;
  b) do_option_b ;;
  c) do_option_c ;;
esac
```

## 🔄 zre

Recarga archivos de configuración de Zsh.

### Uso

```bash
zre [archivo]
```

### Parámetros

- `$1` - **OPCIONAL** - Nombre del archivo a recargar (default: `zshrc`)

### Ejemplos

```bash
zre              # Recarga ~/.zshrc
zre zprofile     # Recarga ~/.zprofile
zre zshenv       # Recarga ~/.zshenv
```

### Descripción

1. Agrega el prefijo `.` al nombre del archivo
2. Busca el archivo en `$HOME`
3. Hace `source` del archivo
4. Muestra mensaje de éxito o error

### Mensajes

#### Éxito

```
♻ zsh reload zshrc file...
```

#### Error

```
zconfig: no such file: ~/.zshrc
```

### Retorno

- `0` si el archivo se recargó correctamente
- `1` si el archivo no existe o hubo error

## 🎯 select_option

Selector interactivo de opciones con navegación por flechas.

### Uso

```bash
select_option "opción1" "opción2" "opción3" "opción4"
selected_index=$?
selected_value="${options[$selected_index]}"
```

### Parámetros

- `$@` - Lista de opciones a mostrar (todas como strings)

### Retorno

Retorna el **índice** de la opción seleccionada (1-based en Zsh)

### Controles

- `↑` / `k` - Mover arriba
- `↓` / `j` - Mover abajo
- `Enter` - Seleccionar
- `q` - Salir sin seleccionar

### Características

- ✅ **Navegación visual** con flechas
- ✅ **Resaltado** de opción seleccionada (verde)
- ✅ **Cursor oculto** durante la selección
- ✅ **Restauración** automática del cursor
- ✅ **Soporte vim-like** (j/k para navegación)

### Ejemplo Completo

```bash
# Definir opciones
versions=("1.0.0" "1.1.0" "1.2.0" "2.0.0")

# Mostrar selector
msg "Selecciona una versión:"
select_option "${versions[@]}"
selected=$?

# Usar selección
chosen_version="${versions[$selected]}"
msg "Versión seleccionada: $chosen_version" --success
```

### Visualización

```
  ➜ opción1
    opción2
    opción3
    opción4
```

La flecha `➜` indica la opción seleccionada y está resaltada en verde.

### Implementación

Usa:

- `tput` para control del cursor
- Secuencias ANSI para colores
- `read -s -k` para captura de teclas
- Arrays de Zsh (1-indexed)

### 📝 Notas

- Todas estas funciones son de bajo nivel
- Son usadas por funciones de nivel superior
- No están diseñadas para uso directo por el usuario final
- Proporcionan bloques de construcción reutilizables
- Manejan entrada/salida de manera robusta
