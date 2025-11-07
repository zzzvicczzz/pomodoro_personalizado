# MVP Técnico – Pomodoro Personalizado

Este documento define el MVP técnico basado en el PRD, detallando las pantallas, clases, modelos y componentes mínimos necesarios para la primera versión funcional de la app Flutter.

## Pantallas (Screens)

1. **Pantalla Principal (HomeScreen)**
   - Visualización de temporizador Pomodoro
   - Botón para iniciar/detener sesión
   - Selección rápida de categoría
   - Acceso a modo enfoque
   - Acceso a estadísticas

2. **Pantalla de Configuración de Sesión (SessionConfigScreen)**
   - Configuración de tiempos de estudio y descanso
   - Configuración de ciclos compuestos
   - Selección de sonidos de alarma

3. **Pantalla de Selección/Categorías (CategoryScreen)**
   - Listado de categorías
   - Crear, editar y eliminar categorías
   - Selección de color y nombre

4. **Pantalla de Estadísticas (StatsScreen)**
   - Gráficas de barras, pastel y líneas
   - Resumen de tiempo por categoría y periodo
   - Visualización de notas de sesiones

5. **Pantalla de Resumen de Sesión (SessionSummaryScreen)**
   - Resumen de tiempo acumulado
   - Categorías más activas del día
   - Campo para nota textual
## Modelos (Models)

- **Category**
  - id
  - color

- **Session**
  - id
  - categoryId
  - startTime
    - duration (minutos)
    - isCompleted (booleano)
  - endTime
  - note (opcional)

- **Cycle**
    - *Nota: En el MVP, la gestión de ciclos es manual. Se recomienda dejar la estructura preparada pero no implementar lógica avanzada hasta futuras versiones.*
  - id
  - customConfig (estructura de tiempos)

- **Stats**
  - totalStudyTime
  ## Configuración Global

  - Crear archivo `lib/config/constants.dart` para definir valores por defecto, colores base, textos, límites, etc. Evita números mágicos y facilita cambios futuros.
  - sessionsByCategory
  - sessionsByPeriod
## Clases y Componentes Mínimos

- **TimerController**
  - Gestión de avance manual entre sesiones/ciclos

  - Notificaciones locales (sonido, visual, vibración)

  - Persistencia de datos (SQLite/Hive)

  - CRUD de categorías

  - Cálculo y visualización de estadísticas

  - Registro y gestión de sesiones

  - Gestión de sonidos personalizados

  ## Providers / Controllers (Gestión de Estado)

  - Usar ChangeNotifier (nativo) o Riverpod para crear Providers que gestionen el estado de temporizador, categorías, sesiones y estadísticas.
  - Ejemplo: `TimerProvider`, `CategoryProvider`, `StatsProvider`, etc.
  - Permite que la UI se actualice automáticamente y desacopla la lógica de negocio de los widgets.

  ## Data Layer (Futura Escalabilidad)

  - Sugerencia: Preparar carpeta `lib/repositories/` con interfaces para acceso a datos (por ejemplo, `SessionRepository`, `CategoryRepository`).
  - En el MVP puede ser opcional, pero facilita migrar a arquitecturas más robustas en el futuro.

- **FocusModeController**
- Lista de categorías
  ## Flujo de Navegación entre Pantallas

  1. **HomeScreen** → Selección de categoría / Inicio rápido / Acceso a configuración y estadísticas
  2. **SessionConfigScreen** ←→ HomeScreen (configuración previa a iniciar sesión)
  3. **CategoryScreen** ←→ HomeScreen (gestión de categorías)
  4. **StatsScreen** ←→ HomeScreen (consulta de estadísticas)
  5. **SessionSummaryScreen** ← HomeScreen (al finalizar sesión)

  *Recomendación: Usar rutas nombradas en MaterialApp y mantener el flujo simple y claro.*
- Formulario de configuración de sesión
- Campo de nota textual

  ## Notas
  - Todos los datos se almacenan localmente.
  - No se requiere autenticación ni conexión a internet.
  - Interfaz minimalista, colores pastel amarillo.
  - No incluye tareas/subtareas ni exportación de datos.

  ---
  Este MVP cubre las funcionalidades mínimas para una primera versión usable y alineada con el PRD.
  Las mejoras propuestas permiten mantener el proyecto limpio, escalable y profesional, listo para producción y fácil de mantener a largo plazo.
- No se requiere autenticación ni conexión a internet.
- Interfaz minimalista, colores pastel amarillo.
- No incluye tareas/subtareas ni exportación de datos.

---
Este MVP cubre las funcionalidades mínimas para una primera versión usable y alineada con el PRD.