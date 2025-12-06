# Spinners (spinners.zsh)

Sistema de animaciones de carga con spinners.

## 🔄 turn_the_command

> _"So turn the page..."_ 🎸

Ejecuta un comando en segundo plano mientras muestra un spinner animado.

### Uso

```zsh
turn_the_command --command "tu_comando" --message "Mensaje..." [OPTIONS]
```

### Opciones Requeridas

- `--command CMD` - Comando a ejecutar en background

### Opciones

- `--message TEXT` - Mensaje a mostrar (default: "Waiting...")
- `--model MODEL` - Modelo de spinner (default: "dots")
- `--delay SECONDS` - Velocidad de animación (default: 0.125)
- `--tab N` - Número de tabulaciones antes del spinner (default: 0)
- `--line-offset N` - Offset de línea para el display (default: 0)
- `--no-newline` - No agregar salto de línea al final
- `--test` - Ejecutar demostración de diferentes spinners
- `--help, -h` - Muestra ayuda

### Modelos de Spinner Disponibles

| Modelo            | Animación    | Descripción                      |
| ----------------- | ------------ | -------------------------------- |
| `dots`            | ⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓   | Puntos braille (default)         |
| `balloon`         | .oO°Oo.      | Globo inflándose                 |
| `grow-vertical`   | ▁▃▄▅▆▇▆▅▄▃   | Barras creciendo verticalmente   |
| `grow-horizontal` | ▏▎▍▌▋▊▉▊▋▌▍▎ | Barras creciendo horizontalmente |
| `star`            | ✶✸✹✺✹✷       | Estrellas                        |
| `hamburger`       | ☱☲☴          | Líneas trigrama                  |
| `arc`             | ◜◠◝◞◡◟       | Arcos rotando                    |
| `circle`          | ◡⊙◠          | Círculo rotando                  |

### Ejemplos Básicos

```zsh
# Ejemplo simple
turn_the_command --command "sleep 3" --message "Procesando..."

# Con modelo personalizado
turn_the_command --command "npm install" --message "Instalando..." --model "balloon"

# Con tabulación
turn_the_command --command "yarn build" --message "Building..." --tab 2

# Sin salto de línea final
turn_the_command --command "sleep 2" --message "Cargando..." --no-newline
```

### Ejemplos Avanzados

```zsh
# Comando que puede fallar
turn_the_command \
  --command "npm test" \
  --message "Ejecutando tests..." \
  --model "grow-vertical"

# Múltiples spinners en secuencia
turn_the_command --command "sleep 2" --message "Paso 1..."
turn_the_command --command "sleep 2" --message "Paso 2..." --tab 1
turn_the_command --command "sleep 2" --message "Paso 3..." --tab 2

# Con comando complejo
turn_the_command \
  --command "curl -s https://api.example.com/data | jq '.results'" \
  --message "Fetching data..." \
  --model "arc" \
  --delay 0.1
```

### Comportamiento

#### Durante la Ejecución

1. Muestra el mensaje con el spinner animado
2. Ejecuta el comando en background
3. Mantiene el spinner girando
4. Captura stdout y stderr del comando

#### Al Completar

- **Éxito (exit code 0)**:

  - Muestra ✅ con el mensaje
  - Retorna el output del comando
  - Exit code 0

- **Error (exit code ≠ 0)**:
  - Muestra ❌ con el mensaje
  - Retorna el output y errores
  - Preserva el exit code del comando

### Salida de Ejemplo

```zsh
# Durante ejecución
  ⠋ Instalando dependencias...

# Al completar con éxito
  ✅ Instalando dependencias...

# Al completar con error
  ❌ Instalando dependencias...
```

### Función de Test

```zsh
# Ver demostración de spinners
turn_the_command --test
```

Esta función ejecuta 3 ejemplos:

1. Spinner básico con modelo "dots"
2. Spinner con tabulación y modelo "grow-vertical"
3. Spinner que falla con modelo "hamburger"

### Captura de Output

```zsh
# Capturar salida del comando
output=$(turn_the_command --command "ls -la" --message "Listando archivos...")
echo "$output"

# Verificar éxito/error
if turn_the_command --command "make build" --message "Building..."; then
  msg "Build successful!" --success
else
  msg "Build failed!" --error
fi
```

### Integración con Otras Funciones

Se usa extensivamente en:

- `deploy` - Para mostrar progreso de deployments
- `phoenix` - Durante limpieza y reinstalación
- `seek_and_destroy` - Al eliminar directorios
- Cualquier comando de larga duración

### Características Técnicas

- ✅ **No bloquea** - Comando corre en background
- ✅ **Captura completa** - Stdout y stderr capturados
- ✅ **Exit codes** - Preserva códigos de salida
- ✅ **Animación fluida** - Actualización configurable
- ✅ **Limpieza automática** - Cursor restaurado al finalizar
- ✅ **Tabulación** - Soporte para mensajes indentados

### Dependencias

- `extract_arg_value` - Para validación de argumentos
- `msg` - Para mensajes de éxito/error
- Secuencias ANSI para control de terminal

### 📝 Notas

- El spinner se actualiza cada `_delay` segundos (default: 0.125)
- Los caracteres Unicode requieren terminal con soporte UTF-8
- El comando se ejecuta en un subshell
- No apto para comandos interactivos (que requieren input)
- Perfecto para dar feedback en scripts automatizados
- El modelo "dots" funciona mejor en la mayoría de terminales

### Troubleshooting

#### Caracteres rotos/cuadrados

Tu terminal no soporta Unicode. Usa el modelo "simple" o actualiza tu terminal.

#### Spinner no se detiene

El comando puede estar esperando input. Usa solo con comandos no-interactivos.

#### Performance lento

Incrementa el `--delay` para reducir actualizaciones:

```zsh
turn_the_command --command "..." --message "..." --delay 0.2
```
