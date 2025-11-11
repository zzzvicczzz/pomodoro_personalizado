
# 🧠 Plan de Desarrollo — Proyecto Pomodoro Personalizado

## 🧩 Estructura General
El proyecto sigue una arquitectura modular y escalable. Cada tarea es una unidad de trabajo independiente con reporte obligatorio.  
El objetivo es construir paso a paso un **Pomodoro personalizable**, con persistencia local, estadísticas y categorías.

---

## ⚙️ TAREA 1 — CREACIÓN DEL PROYECTO

- **Objetivo:** Crear el proyecto Flutter inicial.
- **Pasos:**
  1. Crear el proyecto con `flutter create pomodoro_personalizado`.
  2. Abrir el proyecto en VS Code o Android Studio.
  3. Eliminar comentarios innecesarios de `main.dart`.
  4. Ejecutar `flutter pub get`.
  5. Crear y subir repositorio a GitHub.

- **Dependencias previas:** Ninguna.
- **Criterio de éxito:** Proyecto creado, compilado y subido correctamente a GitHub.

---

## ⚙️ TAREA 1.1 — VERIFICACIÓN DE ESTRUCTURA Y CARPETAS CRÍTICAS

- **Objetivo:** Confirmar que la estructura base del proyecto está lista.
- **Carpetas requeridas:** `lib/config/`, `lib/models/`, `lib/providers/`, `lib/managers/`, `lib/services/`, `lib/repositories/`, `lib/screens/`, `hive_data/`, `docs/progress/`.
- **Criterio de éxito:** Todas las carpetas existen y contienen al menos un archivo `.gitkeep` o `.md`.
- **Dependencias previas:** Tarea 1.

---

## ⚙️ TAREA 1.2 — CONFIGURACIÓN Y PRUEBA DE HIVE LOCAL

- **Objetivo:** Inicializar Hive y establecer el directorio base `hive_data/`.
- **Archivos/Módulos:** `lib/services/local_storage_service.dart`, `main.dart`.
- **Criterio de éxito:** Hive se inicializa sin errores y guarda un valor de prueba.
- **Dependencias previas:** Tarea 1.1.

---

## ⚙️ TAREA 1.3 — VERIFICACIÓN DE IMPORTS Y RUTAS ABSOLUTAS

- **Objetivo:** Asegurar consistencia en los imports (`import 'package:pomodoro_personalizado/...';`).
- **Criterio de éxito:** Ningún error de importación durante la compilación.
- **Dependencias previas:** Tarea 1.2.

---

## ⚙️ TAREA 2 — CONFIGURACIÓN DE DEPENDENCIAS

- **Objetivo:** Agregar librerías necesarias en `pubspec.yaml`.
- **Dependencias a instalar:**
- `provider`
- `hive`
- `hive_flutter`
- `path_provider`
- `intl`
- `flutter_slidable`
- `fl_chart`


- **Comando:**  
```bash
flutter pub add provider hive hive_flutter path_provider intl flutter_slidable fl_chart
flutter pub get
- **Criterio de éxito:** Todas las dependencias instaladas sin errores.
```

## ⚙️ TAREA 3 — MODELADO DE DATOS

- **Objetivo:** Definir las clases base y estructura de datos para el sistema Pomodoro.
- **Modelos:**
	- Category
	- Session
	- Cycle
	- Stats
- **Ubicación:** `lib/models/`
- **Dependencias previas:** Tarea 2.
- **Criterio de éxito:** Modelos definidos y documentados, listos para persistencia y lógica de negocio.


## ⚙️ TAREA 3.6 — CONFIGURACIÓN DE ADAPTADORES HIVE

- **Objetivo:** Registrar adaptadores Hive para los modelos creados.
- **Archivos/Módulos:** `lib/models/*.dart`, `main.dart`, `lib/services/local_storage_service.dart`
- **Dependencias previas:** Tarea 3.
- **Criterio de éxito:** Todos los adaptadores registrados y funcionales.


## ⚙️ TAREA 3.7 — PRUEBA UNITARIA DE PERSISTENCIA BASE

- **Objetivo:** Crear test mínimo que valide guardado y lectura con Hive.
- **Archivo/Módulo:** `test/local_storage_test.dart`
- **Dependencias previas:** Tarea 3.6.
- **Criterio de éxito:** Test pasa exitosamente.


## ⚙️ TAREA 4 — SERVICIOS DE DATOS (REPOSITORY)

- **Objetivo:** Implementar la capa de acceso a datos para categorías y sesiones.
- **Archivos/Módulos:**
	- `lib/repositories/category_repository.dart`
	- `lib/repositories/session_repository.dart`
- **Dependencias previas:** Tarea 3.7.
- **Criterio de éxito:** Lectura y escritura funcional de datos.


## ⚙️ TAREA 5 — PROVIDERS Y MANAGERS

- **Objetivo:** Crear Providers para manejar el estado global de la aplicación.
- **Providers:**
	- CategoryProvider
	- TimerProvider
	- StatsProvider
- **Ubicación:** `lib/providers/`
- **Dependencias previas:** Tarea 4.
- **Criterio de éxito:** Providers funcionales y conectados a la lógica de negocio.


## ⚙️ TAREA 6 — MANEJO DE CICLOS (LÓGICA DEL TEMPORIZADOR)

- **Objetivo:** Implementar la clase `CycleManager` que controle los tiempos Pomodoro.
- **Archivo/Módulo:** `lib/managers/cycle_manager.dart`
- **Dependencias previas:** Tarea 5.
- **Criterio de éxito:** Ciclos gestionados correctamente y lógica de temporizador funcional.


## ⚙️ TAREA 7 — PERSISTENCIA DE ESTADÍSTICAS

- **Objetivo:** Guardar duración de ciclos completados y sesiones.
- **Archivo/Módulo:** `lib/services/stats_service.dart`
- **Dependencias previas:** Tarea 6.
- **Criterio de éxito:** Estadísticas guardadas y recuperadas correctamente.


## ⚙️ TAREA 8 — CONFIGURACIÓN DE TEMA Y ESTILO GLOBAL

- **Objetivo:** Definir `ThemeData`, colores, tipografía y estilo global de la app.
- **Archivo/Módulo:** `lib/config/theme.dart`
- **Dependencias previas:** Tarea 7.
- **Criterio de éxito:** Tema global aplicado correctamente en la app.


## ⚙️ TAREA 9 — INTERFAZ DE USUARIO (UI)

### 🔹 TAREA 9.1 — DISEÑO BASE DE HOMESCREEN
	- **Objetivo:** Crear estructura general de pantalla principal.
	- **Archivo/Módulo:** `lib/screens/home_screen.dart`
	- **Dependencias previas:** Tarea 8.
	- **Criterio de éxito:** Pantalla principal funcional y visualmente clara.

### 🔹 TAREA 9.2 — IMPLEMENTACIÓN DEL TEMPORIZADOR
	- **Objetivo:** Añadir lógica visual del temporizador.
	- **Archivo/Módulo:** `lib/screens/home_screen.dart`
	- **Dependencias previas:** Tarea 9.1.
	- **Criterio de éxito:** Temporizador visual y funcional en la UI.

### 🔹 TAREA 9.3 — SELECTOR DE CATEGORÍAS
	- **Objetivo:** Añadir lista de categorías con selección dinámica.
	- **Archivo/Módulo:** `lib/screens/home_screen.dart`
	- **Dependencias previas:** Tarea 9.2.
	- **Criterio de éxito:** Selector de categorías funcional y conectado a la lógica.

### 🔹 TAREA 9.4 — CONEXIÓN CON PROVIDERS
	- **Objetivo:** Conectar interfaz con lógica de estado.
	- **Dependencias previas:** Tarea 9.3.
	- **Criterio de éxito:** UI actualizada dinámicamente según el estado global.

### 🔹 TAREA 9.5 — ANIMACIONES Y DETALLES VISUALES
	- **Objetivo:** Mejorar UX/UI (animaciones, transiciones, efectos).
	- **Dependencias previas:** Tarea 9.4.
	- **Criterio de éxito:** Experiencia visual mejorada y fluida.


## ⚙️ TAREA 10 — PANTALLA DE ESTADÍSTICAS

- **Objetivo:** Mostrar gráficos y resumen de productividad.
- **Archivo/Módulo:** `lib/screens/stats_screen.dart`
- **Dependencias previas:** Tarea 9.5.
- **Criterio de éxito:** Estadísticas visualizadas correctamente en la UI.


## ⚙️ TAREA 11 — CONFIGURACIÓN DE NAVEGACIÓN

- **Objetivo:** Implementar Navigator o BottomNavigationBar para la navegación entre pantallas.
- **Archivo/Módulo:** `lib/config/router.dart`
- **Dependencias previas:** Tarea 10.
- **Criterio de éxito:** Navegación funcional y sin errores.


## ⚙️ TAREA 12 — PANTALLA DE CONFIGURACIÓN

- **Objetivo:** Permitir personalizar tiempos Pomodoro y temas.
- **Archivo/Módulo:** `lib/screens/settings_screen.dart`
- **Dependencias previas:** Tarea 11.
- **Criterio de éxito:** Configuración personalizada guardada y aplicada correctamente.


## ⚙️ TAREA 13 — OPTIMIZACIÓN FINAL Y LIMPIEZA

- **Objetivo:** Limpiar imports, eliminar código no usado y optimizar rendimiento.
- **Dependencias previas:** Tarea 12.
- **Criterio de éxito:** Proyecto optimizado, sin warnings ni código innecesario.


## ⚙️ TAREA 14 — AUDITORÍA INTERNA

- **Objetivo:** Verificar arquitectura, consistencia, dependencias y documentación.
- **Criterio de éxito:**
	- El proyecto compila sin errores.
	- No hay warnings ni imports redundantes.
	- `README.md` actualizado y coherente.
- **Dependencias previas:** Tarea 13.

---

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