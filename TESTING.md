# Tests

Tests unitarios para `mangoose` ejecutados con [zunit](https://github.com/zunit-zsh/zunit),
un framework de testing nativo de zsh.

## ¿Por qué zunit?

`mangoose` está escrito 100% en zsh y usa idioms propios del intérprete (arrays
1-indexados, expansiones como `:t`, scoping dinámico de `local`, sintaxis
`$'\uXXXX'`, etc.). zunit ejecuta cada test dentro de un proceso zsh real,
por lo que esos idioms se comportan exactamente igual que en runtime, a
diferencia de alternativas como `bats-core` que están pensadas para bash.

## Instalación de dependencias

zunit depende de [`revolver`](https://github.com/molovo/revolver). El script
`install-deps.zsh` se encarga de descargar, construir e instalar ambos en el
primer `bin/` con permisos de escritura (`/opt/homebrew/bin` en Apple Silicon,
`/usr/local/bin` en Intel/Linux, o `~/.local/bin` como fallback):

```zsh
./scripts/install-test-deps.zsh
```

Es idempotente: si ya están instalados, no hace nada.

## Ejecutar la suite

Desde la raíz del proyecto:

```zsh
zunit run                                     # toda la suite
zunit run tests/core                          # solo el módulo core
zunit run tests/git/git_worktree_goto.zunit   # un fichero
zunit --verbose run                           # salida detallada
```

## Estructura

```
tests/
├── _support/
│   ├── bootstrap.zsh        # helper compartido (MANGOOSE_ROOT + mangoose_source)
│   └── git_mock.zsh         # helpers `mock_git` / `git_porcelain` para tests de git
├── core/
│   ├── print.zunit          # tests de msg + print_indentation (incl. regresión)
│   └── utils.zunit          # tests de extract_arg_value
└── git/
    └── git_worktree_goto.zunit   # tests de gowt con git mockeado
```

El output transitorio de zunit se escribe en `tests/_output/` (gitignored).

## Escribir un test nuevo

1. Crea un fichero `.zunit` bajo `tests/<módulo>/`.
2. Carga el bootstrap y los módulos que necesites:

   ```zsh
   #!/usr/bin/env zunit

   @setup {
     load ../_support/bootstrap
     mangoose_source core/colors.zsh core/print.zsh
   }

   @test 'descripción del comportamiento esperado' {
     run mi_funcion arg1 arg2

     assert $state equals 0
     assert "$output" contains 'algo'
   }
   ```

3. Para funciones que llaman a comandos externos (p. ej. `git`), redefine la
   función dentro del test para devolver el output que necesites:

   ```zsh
   @test 'algo que usa git' {
     function git() {
       case "$1" in
         rev-parse) return 0 ;;
         worktree)  printf 'worktree /tmp/foo\nbranch refs/heads/main\n\n' ;;
       esac
     }

     run mi_funcion_que_usa_git
     assert $state equals 0
   }
   ```

## Asserts disponibles

zunit incluye una API expresiva, entre otras:

| Assert                                         | Uso                           |
| ---------------------------------------------- | ----------------------------- |
| `equals` / `not_equal_to`                      | comparación numérica          |
| `same_as` / `different_to`                     | comparación de strings exacta |
| `contains` / `does_not_contain`                | búsqueda de subcadena         |
| `matches` / `does_not_match`                   | expresión regular             |
| `is_empty` / `is_not_empty`                    | string vacía                  |
| `is_greater_than` / `is_less_than`             | numérico                      |
| `exists`, `is_file`, `is_dir`, `is_executable` | filesystem                    |
| `is_substring_of` / `in`                       | pertenencia                   |

Lista completa: <https://zunit.xyz/docs/assertions/>.
