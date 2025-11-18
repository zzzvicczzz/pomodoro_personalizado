# Plan de Desarrollo – Pomodoro Personalizado

Este documento detalla el roadmap técnico para la construcción incremental de la app Flutter "Pomodoro Personalizado", siguiendo estrictamente los requerimientos del PRD, el MVP técnico y la arquitectura base definida. Su propósito es dividir el desarrollo en tareas pequeñas, secuenciales y verificables, facilitando la colaboración con IA y garantizando calidad y mantenibilidad.

## Objetivo General del Plan

Asegurar que la aplicación se construya de forma ordenada, modular y libre de errores, respetando los requerimientos funcionales y técnicos definidos en los documentos base. El plan busca que cada tarea produzca código funcional y comprobable, permitiendo avanzar paso a paso hasta completar el MVP.

## Metodología de Desarrollo

- Se empleará una metodología incremental y modular.
- La IA desarrollará una sola tarea a la vez, en orden secuencial.
- Cada tarea debe generar código funcional y verificable antes de continuar.
- Se respetarán los nombres, estructuras y convenciones definidos en los documentos base.
- No se agregarán nuevas funcionalidades, pantallas ni dependencias externas no especificadas.

## Orden de Implementación (Visión General)

1. Configuración del proyecto base
2. Definición de modelos
3. Implementación de servicios
4. Creación de managers/controladores
5. Implementación de providers
6. Desarrollo de UI y widgets
7. Pruebas y refinamiento final

## Lista Detallada de Tareas (v2.0)

Convención: cada tarea incluye: objetivo, archivos, dependencias, subtareas numeradas, criterio de éxito y checklist de validación.

### Tarea 1 – Configuración Inicial del Proyecto (COMPLETA)
- **Objetivo:** Crear el proyecto Flutter, configurar dependencias y estructura de carpetas según la arquitectura.
- **Archivos/Módulos:** `main.dart`, carpetas `lib/`, `config/`, `models/`, `providers/`, `managers/`, `services/`, `repositories/`, `screens/`.
- **Dependencias previas:** Ninguna.
- **Criterio de éxito:** Proyecto Flutter funcional, estructura de carpetas creada, dependencias instaladas.

### Tarea 2 – Definición de Modelos Base (COMPLETA)
- **Objetivo:** Implementar los modelos principales: categoría, sesión, ciclo y estadísticas.
- **Archivos/Módulos:** `models/category.dart`, `models/session.dart`, `models/cycle.dart`, `models/stats.dart`.
- **Dependencias previas:** Tarea 1.
- **Criterio de éxito:** Modelos definidos con atributos y métodos necesarios, documentados con comentarios `///`.

### Tarea 3 – Configuración de Constantes y Temas (COMPLETA)
- **Objetivo:** Centralizar constantes, colores y configuraciones globales.
- **Archivos/Módulos:** `config/constants.dart`.
- **Dependencias previas:** Tarea 1.
- **Criterio de éxito:** Archivo de constantes creado, accesible y documentado.

### Tarea 3.5 – Integración de Constantes en Modelos (COMPLETA)
- **Objetivo:** Integrar el uso de las constantes globales definidas en `config/constants.dart` en los modelos principales (`Category`, `Session`, `Cycle`, `Stats`) para asegurar consistencia y facilitar el mantenimiento.
- **Archivos/Módulos:** `models/category.dart`, `models/session.dart`, `models/cycle.dart`, `models/stats.dart`.
- **Dependencias previas:** Tareas 2, 3.
- **Criterio de éxito:** Modelos actualizados para utilizar las constantes globales en atributos relevantes (colores, iconos, duraciones, nombres), con documentación y sin romper compatibilidad.

### Tarea 3.6 – Implementación y registro de adaptadores Hive (COMPLETA)
- **Objetivo:** Generar y registrar los adaptadores Hive para todos los modelos principales. Corregir errores de compilación relacionados con la persistencia.
- **Archivos/Módulos:** `models/*.dart`, archivos `.g.dart`, registro en `main.dart`.
- **Dependencias previas:** Tareas 2, 3, 3.5.
- **Criterio de éxito:** Adaptadores generados y registrados, compilación sin errores.

### Tarea 3.7 – Pruebas unitarias de persistencia Hive y exportación centralizada (COMPLETA)
- **Objetivo:** Crear pruebas unitarias para validar el guardado y lectura de modelos con Hive. Centralizar las exportaciones de modelos.
- **Archivos/Módulos:** `test/local_storage_test.dart`, `models/models.dart`.
- **Dependencias previas:** Tarea 3.6.
- **Criterio de éxito:** Pruebas ejecutadas y aprobadas, exportación centralizada funcional.

### Tarea 4 – Implementación de Servicios de Persistencia Local (REVISADA)
- **Objetivo:** Servicio genérico y robusto para persistencia con Hive, responsable de apertura/cierre de cajas, migraciones, transacciones y adaptadores previamente generados.
- **Archivos:** services/local_storage_service.dart, services/hive_init.dart
- **Dependencias previas:** INMUTABLES (T2, T3.6)
- **Subtareas:**
  1. Definir interfaz ILocalStorageService<T> genérica (openBox, put, get, delete, query, clear).
  2. Implementar HiveLocalStorageService con manejo seguro de cajas y migraciones.
  3. Implementar control de concurrencia (locks/asynchronous queue) para operaciones críticas.
  4. Integrar logs y manejo centralizado de errores.
  5. Documentar API pública del servicio.
  6. Escribir pruebas unitarias y tests de integración local (usando hive_test si aplica).
  7. Añadir validaciones de esquema (verificar fields requeridos).
- **Criterio de éxito:** Servicio probado, boxes accesibles, sin fugas de recursos y con tests aprobados.
- **Checklist rápido:** openBox ok, CRUD ok, migraciones testadas, errores controlados.

### Tarea 5 – Servicio de Notificaciones (separado)
- **Objetivo:** Servicio para gestionar notificaciones locales y programación (no contiene lógica de playback de audio).
- **Archivos:** services/notification_service.dart
- **Dependencias previas:** AppSettingsModel (T2)
- **Subtareas:**
  1. Definir interfaz INotificationService.
  2. Implementar adapter platform-specific (Android/iOS) con la librería recomendada (flutter_local_notifications) y stubs para web.
  3. Manejo de permisos (ver Tarea 5.1).
  4. Implementar scheduling, cancelación y callbacks (tap handlers).
  5. Documentar y probar con integración en emuladores.
- **Criterio de éxito:** Notificaciones programadas/mostradas/canceladas en plataformas soportadas.

### Tarea 5.1 – Gestión de permisos para notificaciones y audio (nuevo)
- **Objetivo:** Solicitar y verificar permisos necesarios en runtime.
- **Subtareas:** Solicitar permisos, manejar denegación, documentar experiencia degradada.
- **Criterio:** Permisos validados en tests manuales.

### Tarea 5b – Servicio de Sonido (separado)
- **Objetivo:** Playback local de efectos y sonidos de sesión.
- **Archivos:** services/sound_manager.dart
- **Dependencias previas:** AppSettingsModel (T2)
- **Subtareas:**
  1. Definir interface ISoundManager.
  2. Implementar driver basado en just_audio o similar, con fallback.
  3. Soportar volumen, mute, selección de archivos.
  4. Pruebas manuales y unitarias donde aplique.
- **Criterio de éxito:** Sonido reproducible, manejable y configurable.

### Tarea 6 – Repositorios (REVISADA)
- **Objetivo:** Puerta de dominio entre servicios y managers.
- **Archivos:** repositories/*.dart + interfaces repositories/i_*_repository.dart
- **Dependencias previas:** T2, T4
- **Subtareas:**
  1. Definir contratos (SessionRepository, CategoryRepository, SettingsRepository, StatsRepository).
  2. Implementaciones usando ILocalStorageService.
  3. Manejo de mapeo DTO↔Model (si requiere).
  4. Tests unitarios y de integración.
- **Criterio de éxito:** Repositorios entregan datos coerentes, paginados/filtrables.

### Tarea 7 – Managers / Controladores (REVISADA)
- **Objetivo:** Contener la lógica de negocio (timers, reglas de sesión, focus mode orchestration).
- **Archivos:** managers/*.dart
- **Dependencias previas:** T2, T4, T6
- **Subtareas:**
  1. Definir contratos y estados (TimerState, SessionState).
  2. Implementar TimerManager con separación clara entre cronómetro y persistencia.
  3. Implementar FocusModeManager (no duplicar lógica del Timer).
  4. Integrar eventos (start/pause/stop/complete) y manejo de errores.
  5. Documentar y probar.
- **Criterio de éxito:** Managers cubren casos de uso del PRD, no tienen lógica UI.

### Tarea 8 – Providers (State Layer)
- **Objetivo:** Exponer managers al UI de forma reactiva (Provider).
- **Archivos:** providers/*.dart
- **Dependencias previas:** T7
- **Subtareas:**
  1. Crear providers para Timer, Sessions, Categories, Settings y Stats.
  2. Proveer mecanismos de cache local y refresco controlado.
  3. Garantizar notificaciones a UI (notifyListeners / Stream).
  4. Documentar uso y comportamiento.

### Tarea 8.5 – Conexión Repos → Managers → Providers (INTEGRACIÓN)
- **Objetivo:** Flujo de datos verificado y reproducible.
- **Subtareas:** Tests de integración entre capas, verificar no hay acoplamiento circular.
- **Criterio:** Flujo end-to-end de lectura/escritura exitoso con mocks.

### Tarea 9 – UI: Pantallas y Widgets (REVISADA)
- **Objetivo:** Implementar pantallas según especificación, desacopladas de lógica.
- **Archivos:** screens/*.dart, widgets/*.dart
- **Dependencias previas:** T2, T8
- **Subtareas:**
  1. Estructura de navegación (Router).
  2. Home, Timer view, Category selector, Stats view.
  3. Widgets reutilizables (PillButton, CircularTimer, ChartCard).
  4. Tests de widgets y accesibilidad.
- **Criterio:** UI funcional, sin lógica de negocio incorporada.

### Tarea 10 – Integración de Gráficas y Estadísticas
- **Objetivo:** Visualización y transformación de datos para métricas.
- **Archivos:** screens/stats_chart.dart, services/stats_service.dart (si necesario)
- **Dependencias previas:** T2, T8, T9

### Tarea 11 – Modo Enfoque (Wakelock, Notificaciones especiales)
- **Objetivo:** Mantener pantalla activa y comportamiento especial de notificaciones.
- **Archivos:** managers/focus_mode_controller.dart
- **Dependencias previas:** T7, T5, T5b
- **Subtareas:** Implementar wakelock_plus, tests de integración y UX.

### Tarea 12 – Pruebas Unitarias de Modelos y Lógica
- **Objetivo:** Cobertura para modelos y managers.
- **Dependencias previas:** T2, T7

### Tarea 13 – Pruebas de Integración y Refinamiento Final
- **Objetivo:** Integración completa y correcciones.
- **Subtareas:** Escenarios E2E, pruebas de regresión.

### Tarea 14 – Auditoría Técnica Periódica (cada 3 tareas)
- **Objetivo:** Revisar consistencia de arquitectura, typeIds, duplicidades.
- **Subtareas:** Auditoría automatizable + checklist humano.

### Tarea 15 – CI/CD Básico y Gates Automáticos (nuevo)
- **Objetivo:** Pipeline mínimo que corra flutter analyze, flutter format --set-exit-if-changed, flutter test.
- **Subtareas:** Crear workflow en GitHub Actions / GitLab CI.

### Tarea 16 – Preparación para Release / Documentación Final
- **Objetivo:** Documentación técnica, changelog, guía de despliegue.

## Dependencias Recomendadas

| Paquete         | Uso                   | Versión mínima sugerida |
|-----------------|----------------------|-------------------------|
| hive_flutter    | Persistencia local    | ^1.1.0                  |
| fl_chart        | Gráficas estadísticas | ^0.68.0                 |
| wakelock_plus   | Modo enfoque          | ^1.1.1                  |
| provider        | Gestión de estado     | ^6.1.1                  |

## Convenciones de Desarrollo

- Usar nombres descriptivos y consistentes para archivos, clases y variables, siguiendo la arquitectura (`category_manager.dart`, `Session`, `statsProvider`, etc.).
- Documentar clases, métodos y modelos con comentarios `///`.
- Realizar commits frecuentes y descriptivos, siguiendo buenas prácticas de control de versiones.
- Aplicar principios SOLID y separación de responsabilidades en todas las capas.
- Evitar lógica en Widgets; delegar a Providers/Managers.
- Centralizar constantes y colores en `config/constants.dart`.
- Mantener tests unitarios actualizados.

## Reglas para Trabajar con IA

- La IA debe desarrollar una sola tarea a la vez, siguiendo el orden del plan.
- Cada entrega debe incluir código funcional y explicación breve.
- La IA no debe modificar tareas previas sin indicación explícita.
- Si algo no está especificado en el PRD, MVP o arquitectura, la IA debe preguntar antes de asumir o implementar.


Al finalizar cada tarea, la IA debe obligatoriamente generar el informe de progreso, aunque no haya sido solicitado explícitamente.

> **Nota:** Las secciones "Reglas para Trabajar con IA" y "Reglas de Informe de Progreso" son complementarias y obligatorias. Toda entrega debe cumplir ambas para considerarse válida.

---

Este plan permite avanzar paso a paso en el desarrollo de "Pomodoro Personalizado", asegurando calidad, orden y alineación con los objetivos definidos en los documentos base.

## Reglas de Informe de Progreso (para cada tarea)

Al finalizar cada tarea —incluso si no se completa por completo— la IA debe generar un **informe de progreso** que incluya los siguientes campos:

1. **Resumen de avances:**  
	Describir qué partes de la tarea fueron implementadas con éxito.

2. **Código entregado:**  
	Incluir el código funcional o los fragmentos relevantes generados en esta etapa.

3. **Pendientes o limitaciones:**  
	Especificar qué partes de la tarea aún no se completaron o requieren revisión manual.

4. **Errores o bloqueos:**  
	Detallar cualquier problema técnico encontrado (por ejemplo: dependencias no instaladas, clases aún no creadas, conflictos de tipo, etc.).

5. **Recomendaciones o próximos pasos:**  
	Indicar qué se debería hacer a continuación para cerrar la tarea o continuar con la siguiente.


El informe debe presentarse en formato markdown y al final de cada entrega.

### Formato estandarizado de informe de progreso

```markdown
## Informe de Progreso – Tarea X

### 1. Resumen de avances
Breve descripción de lo implementado.

### 2. Código entregado
```dart
// Fragmentos relevantes de código
```

### 3. Pendientes o limitaciones
Lista de aspectos no completados o que requieren revisión.

### 4. Errores o bloqueos
Descripción de problemas técnicos encontrados.

### 5. Recomendaciones o próximos pasos
Sugerencias para cerrar la tarea o continuar.
```
## Control de Versiones

Cada tarea completada debe corresponder a un commit con el formato:

feat(task-x): descripción breve

Ejemplo: feat(task-4): implementa servicio de persistencia local

Cada informe de progreso puede guardarse en /docs/progress/task-x.md.
---

> **Validación técnica:** Antes de marcar una tarea como completada, debe verificarse que el código compile, pase los tests básicos y que el informe de progreso haya sido revisado y aprobado.

---

> **Auditoría interna (opcional):**  
> Cada tres tareas completadas, realizar una breve revisión del progreso general (arquitectura, consistencia de código y cumplimiento del PRD) para detectar desvíos tempranos y optimizar el flujo.  
>  
> Esta auditoría puede incluir una verificación rápida de estructura de carpetas, nombres de clases, dependencias y estilo de documentación, asegurando que todo siga conforme al plan inicial.