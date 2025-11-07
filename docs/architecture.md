# Arquitectura Base – Pomodoro Personalizado

Este documento describe la arquitectura técnica recomendada para la app Flutter "Pomodoro Personalizado", alineada con el PRD y el MVP técnico.

## 1. Patrón de Arquitectura
├── core/   # Utilidades compartidas (helpers, extensiones, temas, validaciones)

Se propone una **Clean Architecture simplificada**, separando la app en capas:
- **Presentación (UI):** Widgets y pantallas.
- **Gestión de Estado:** Providers/Controllers (Riverpod o ChangeNotifier).
- **Dominio:** Modelos y lógica de negocio.
- **Datos:** Persistencia local (Hive/SQLite), servicios y repositorios.

Esta estructura promueve bajo acoplamiento, alta cohesión y facilidad de mantenimiento.

## 2. Estructura de Carpetas

```plaintext
lib/
├── main.dart
├── config/
│   └── constants.dart
├── models/
│   ├── category.dart
│   ├── session.dart
│   ├── cycle.dart
│   └── stats.dart
├── providers/
│   ├── timer_provider.dart
│   ├── category_provider.dart
│   ├── session_provider.dart
│   └── stats_provider.dart
├── managers/
│   ├── timer_controller.dart
│   ├── category_manager.dart
│   ├── session_manager.dart
│   ├── stats_manager.dart
│   └── focus_mode_controller.dart
├── services/
│   ├── notification_service.dart
│   ├── local_storage_service.dart
│   └── sound_manager.dart
├── repositories/
│   ├── session_repository.dart
│   └── category_repository.dart
├── screens/
│   ├── home_screen.dart
│   ├── pomodoro_timer.dart
│   ├── category_selector.dart
│   ├── stats_chart.dart
│   └── ...
```

## 3. Flujo de Datos

```ascii
[UI Widgets] <--> [Providers/Controllers] <--> [Managers/Services] <--> [Repositories] <--> [Hive]
```
- Repositories gestionan persistencia local (Hive).
- Cambios en Hive actualizan Providers, que notifican la UI.

## 4. Manejo de Estado

 - `fl_chart` o `syncfusion_flutter_charts` (gráficas interactivas para estadísticas)
 - `wakelock_plus` (mantener la pantalla encendida durante el modo enfoque)

- Usar **Hive** para almacenamiento rápido y sin dependencias nativas.

## 6. Notificaciones Locales

- NotificationService gestiona alarmas sonoras, visuales y vibración.
- Configurar canales y permisos según Android.

## 7. Dependencias Recomendadas

- `flutter_riverpod` o `provider` (gestión de estado)
- `hive` y `hive_flutter` (persistencia)
- `flutter_local_notifications` (notificaciones)
- `intl` (formato de fechas)
- `uuid` (IDs únicos)

## 8. Buenas Prácticas

- Seguir principios **SOLID** en clases y servicios.
- Usar nombres descriptivos y consistentes.
- Documentar clases, métodos y modelos con comentarios `///`.
- Evitar lógica en Widgets; delegar a Providers/Managers.
- Centralizar constantes y colores en `config/constants.dart`.
- Mantener tests unitarios para lógica y modelos.

## 9. Futuras Extensiones (Consistentes con PRD)

- Añadir más tipos de gráficas en estadísticas.
- Mejorar la modularidad de la capa de datos (repositorios).
- Permitir configuración avanzada de sonidos y notificaciones.
- Optimizar la gestión de ciclos Pomodoro para mayor flexibilidad.

---
Esta arquitectura garantiza una app mantenible, escalable y alineada con los objetivos de privacidad, simplicidad y personalización definidos en el PRD.