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

## Lista Detallada de Tareas

### Tarea 1 – Configuración Inicial del Proyecto
- **Objetivo:** Crear el proyecto Flutter, configurar dependencias y estructura de carpetas según la arquitectura.
- **Archivos/Módulos:** `main.dart`, carpetas `lib/`, `config/`, `models/`, `providers/`, `managers/`, `services/`, `repositories/`, `screens/`.
- **Dependencias previas:** Ninguna.
- **Criterio de éxito:** Proyecto Flutter funcional, estructura de carpetas creada, dependencias instaladas.

### Tarea 2 – Definición de Modelos Base
- **Objetivo:** Implementar los modelos principales: categoría, sesión, ciclo y estadísticas.
- **Archivos/Módulos:** `models/category.dart`, `models/session.dart`, `models/cycle.dart`, `models/stats.dart`.
- **Dependencias previas:** Tarea 1.
- **Criterio de éxito:** Modelos definidos con atributos y métodos necesarios, documentados con comentarios `///`.

### Tarea 3 – Configuración de Constantes y Temas
- **Objetivo:** Centralizar constantes, colores y configuraciones globales.
- **Archivos/Módulos:** `config/constants.dart`.
- **Dependencias previas:** Tarea 1.
- **Criterio de éxito:** Archivo de constantes creado, accesible y documentado.

### Tarea 4 – Implementación de Servicios de Persistencia Local
- **Objetivo:** Crear servicios para almacenamiento local usando Hive.
- **Archivos/Módulos:** `services/local_storage_service.dart`.
- **Dependencias previas:** Tareas 2, 3.
- **Criterio de éxito:** Servicio funcional para guardar y recuperar datos de modelos.

### Tarea 5 – Implementación de Servicios de Notificaciones y Sonido
- **Objetivo:** Crear servicios para notificaciones locales y gestión de sonidos.
- **Archivos/Módulos:** `services/notification_service.dart`, `services/sound_manager.dart`.
- **Dependencias previas:** Tarea 1.
- **Criterio de éxito:** Servicios capaces de enviar notificaciones y reproducir sonidos según eventos.

### Tarea 6 – Creación de Repositorios
- **Objetivo:** Implementar repositorios para la gestión de sesiones y categorías.
- **Archivos/Módulos:** `repositories/session_repository.dart`, `repositories/category_repository.dart`.
- **Dependencias previas:** Tareas 2, 4.
- **Criterio de éxito:** Repositorios funcionales, integrados con servicios de persistencia.

### Tarea 7 – Implementación de Managers y Controladores
- **Objetivo:** Crear managers/controladores para timer, categorías, sesiones, estadísticas y modo enfoque.
- **Archivos/Módulos:** `managers/timer_controller.dart`, `managers/category_manager.dart`, `managers/session_manager.dart`, `managers/stats_manager.dart`, `managers/focus_mode_controller.dart`.
- **Dependencias previas:** Tareas 2, 4, 6.
- **Criterio de éxito:** Managers con lógica de negocio, documentados y probados.

### Tarea 8 – Implementación de Providers
- **Objetivo:** Crear providers para gestión de estado de timer, categorías, sesiones y estadísticas.
- **Archivos/Módulos:** `providers/timer_provider.dart`, `providers/category_provider.dart`, `providers/session_provider.dart`, `providers/stats_provider.dart`.
- **Dependencias previas:** Tareas 2, 7.
- **Criterio de éxito:** Providers funcionales, conectados a managers y actualizando la UI.

### Tarea 9 – Desarrollo de Pantallas y Widgets Principales
- **Objetivo:** Implementar las pantallas y widgets definidos en la arquitectura.
- **Archivos/Módulos:** `screens/home_screen.dart`, `screens/pomodoro_timer.dart`, `screens/category_selector.dart`, `screens/stats_chart.dart`.
- **Dependencias previas:** Tareas 2, 8.
- **Criterio de éxito:** Pantallas funcionales, conectadas a providers y managers, siguiendo la arquitectura.

### Tarea 10 – Integración de Gráficas y Estadísticas
- **Objetivo:** Implementar gráficas interactivas para estadísticas usando las dependencias recomendadas.
- **Archivos/Módulos:** `screens/stats_chart.dart`, dependencias `fl_chart` o `syncfusion_flutter_charts`.
- **Dependencias previas:** Tareas 2, 8, 9.
- **Criterio de éxito:** Gráficas funcionales, datos correctos y visualización adecuada.

### Tarea 11 – Implementación de Modo Enfoque
- **Objetivo:** Integrar wakelock para mantener la pantalla encendida durante el modo enfoque.
- **Archivos/Módulos:** `managers/focus_mode_controller.dart`, dependencias `wakelock_plus`.
- **Dependencias previas:** Tareas 7, 9.
- **Criterio de éxito:** Modo enfoque funcional, pantalla permanece activa durante la sesión.

### Tarea 12 – Pruebas Unitarias de Modelos y Lógica
- **Objetivo:** Implementar pruebas unitarias para modelos y lógica de negocio.
- **Archivos/Módulos:** Carpeta de tests, archivos de prueba para modelos y managers.
- **Dependencias previas:** Tareas 2, 7.
- **Criterio de éxito:** Pruebas ejecutadas y aprobadas, cobertura suficiente.

### Tarea 13 – Pruebas de Integración y Refinamiento Final
- **Objetivo:** Realizar pruebas de integración, corregir errores y refinar la app.
- **Archivos/Módulos:** Todos los módulos y pantallas.
- **Dependencias previas:** Todas las tareas anteriores.
- **Criterio de éxito:** App estable, sin errores críticos, lista para entrega.

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