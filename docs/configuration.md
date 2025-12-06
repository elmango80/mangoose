# Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para mantener información sensible fuera del control de versiones.

## 📁 Archivos

- **`.env.example`** - Plantilla con valores de ejemplo (incluida en el repositorio)
- **`.env`** - Archivo real con tus valores (NO incluido en el repositorio, en `.gitignore`)

## 🚀 Configuración Inicial

### Instalación Automática

Durante la instalación con `install.sh`, el archivo `.env` se creará automáticamente desde `.env.example`:

```zsh
./install.sh
```

### Configuración Manual

Si necesitas crear o recrear el archivo `.env`:

```zsh
cd ~/.config/zsh/functions
cp .env.example .env
```

Luego edita `.env` con tus valores reales:

```zsh
nano .env
# o
code .env
# o tu editor preferido
```

## 🔧 Variables Disponibles

### Deployment

| Variable              | Descripción                                            | Ejemplo                             |
| --------------------- | ------------------------------------------------------ | ----------------------------------- |
| `DEPLOY_SERVER_URL`   | URL base del servidor de deployment                    | `https://deploy-server.example.com` |
| `DEPLOY_APP_ID`       | ID de la aplicación                                    | `100`                               |
| `DEPLOY_SERVICES`     | Array de servicios disponibles (formato: `NOMBRE:ID`)  | `("auth:1001" "users:1002")`        |
| `DEPLOY_ENVIRONMENTS` | Array de entornos de deployment (formato: `ID:NOMBRE`) | `("1001:DEVELOPMENT" "1003:QA")`    |

**Nota sobre `DEPLOY_SERVICES`:**

- Formato: Array de strings con formato `"NOMBRE:ID"`
- Define todos los servicios que pueden ser desplegados
- Ejemplo completo:
  ```zsh
  DEPLOY_SERVICES=(
    "auth:1001"
    "users:1002"
    "data:1003"
  )
  ```

**Nota sobre `DEPLOY_ENVIRONMENTS`:**

- Formato: Array de strings con formato `"ID:NOMBRE"`
- El orden de los elementos define el orden de deployment
- Ejemplo completo:
  ```zsh
  DEPLOY_ENVIRONMENTS=(
    "1001:DEVELOPMENT"
    "1002:DEVELOPMENT Contact Center"
    "1003:QUALITY ASSURANCE"
  )
  ```

### Variables de Directorios

| Variable   | Descripción                                    | Ejemplo       |
| ---------- | ---------------------------------------------- | ------------- |
| `CODE_DIR` | Directorio base de código (relativo a `$HOME`) | `code`        |
| `WORK_DIR` | Directorio de trabajo (relativo a `$CODE_DIR`) | `my-projects` |

Estas variables se usan en los aliases de navegación (`cdc`, `cdw`).

### Wiremock

| Variable              | Descripción               | Ejemplo                 |
| --------------------- | ------------------------- | ----------------------- |
| `WIREMOCK_SERVER_URL` | URL del servidor Wiremock | `http://localhost:8080` |

## 📝 Uso en Scripts

Las variables se cargan automáticamente al iniciar zsh. Puedes usarlas en tus scripts:

```zsh
# Usar con valor por defecto
local SERVER="${DEPLOY_SERVER_URL:-https://default-server.com}"

# Usar directamente (asegúrate de que esté definida)
echo "Servidor: $DEPLOY_SERVER_URL"
```

## 🔒 Seguridad

- ✅ **`.env`** está en `.gitignore` y **NUNCA** se subirá al repositorio
- ✅ **`.env.example`** contiene solo valores dummy/de ejemplo

## 🔄 Actualización

Si se añaden nuevas variables en `.env.example`:

1. Compara tu `.env` con `.env.example`:

   ```zsh
   diff .env .env.example
   ```

2. Añade las nuevas variables a tu `.env`

3. Configura los valores apropiados

## ⚡ Recarga

Si modificas el archivo `.env`, recarga tu sesión de zsh:

```zsh
source ~/.zshrc
```

O simplemente abre una nueva terminal.

## 🆘 Troubleshooting

### Variables no cargadas

Si las variables no están disponibles:

1. Verifica que `.env` existe:

   ```zsh
   ls -la ~/.config/zsh/functions/.env
   ```

2. Verifica que el cargador está en `.zshrc`:

   ```zsh
   grep "env-loader.zsh" ~/.zshrc
   ```

3. Verifica el contenido del `.env`:
   ```zsh
   cat ~/.config/zsh/functions/.env
   ```

### Formato incorrecto

El archivo `.env` debe seguir este formato:

```zsh
# Comentarios empiezan con #
export VARIABLE_NAME="valor"
export OTRA_VARIABLE="valor_sin_comillas"

# Líneas vacías están bien

export OTRA_MAS="valor con espacios"

# Arrays (para DEPLOY_ENVIRONMENTS)
export MI_ARRAY=(
  "valor1"
  "valor2"
)
```

**IMPORTANTE:** Todas las variables deben tener `export` al inicio para estar disponibles en la shell.

**NO uses:**

- Sin `export`: `VARIABLE=valor` ❌ (no estará disponible)
- Espacios alrededor del `=`: `VARIABLE = valor` ❌
- Comillas mixtas: `VARIABLE='valor"` ❌

## 📚 Más Información

- [Documentación Principal](../README.md)
- [Guía de Deploy](../docs/modules/deployment.md)
