# Historial de Cambios

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-05

### Agregado

- Lanzamiento inicial con funciones comprehensivas de Zsh
- **Utilidades Core**

  - Sistema de colores (ANSI, 256, RGB)
  - Sistema de mensajes con íconos
  - Animaciones de spinners
  - Funciones de utilidad

- **Funciones Git**

  - `no_branch_for_old_refs` - Limpia ramas obsoletas
  - `paranoid_sync` - Actualiza rama principal
  - Operaciones por lotes para múltiples repositorios

- **Herramientas de Productividad**

  - `phoenix` - Reinicia proyectos Node.js
  - `goto` - Navegador interactivo de directorios
  - `seek_and_destroy` - Limpieza recursiva de directorios

- **Sistema de Deployment**

  - Deployment multi-ambiente a Quicksilver
  - Selector interactivo de versiones
  - Modo dry-run
  - Manejo y reporte de errores

- **Utilidades de Testing**

  - Gestión de servidor WireMock
  - Soporte de API de administración

- **Más de 90 aliases**

  - Atajos para NPM y Yarn
  - Aliases de Git
  - Atajos de navegación
  - Aliases de limpieza

- **Documentación completa**
  - README principal
  - Documentación por módulo
  - Ejemplos y casos de uso
  - Mejores prácticas

---

## Soporte

- **Problemas**: [GitHub Issues](https://github.com/elmango80/zsh-functions/issues)
- **Documentación**: [README.md](./README.md)
- **Módulos**: Ver READMEs individuales de cada módulo
