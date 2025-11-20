
## Informe de Progreso – Tarea 5.1

### 1. Resumen de avances
- Se creó la carpeta `lib/services/permissions/` con un servicio dedicado para solicitar/verificar permisos críticos (notificaciones y lectura de audio).
- Se expuso la interfaz `IPermissionsService`, modelos (`ManagedPermission`, `PermissionStatusResult`, `PermissionsSummary`) y una implementación con manejo multi-plataforma y mensajes de degradación.
- Se agregó `permission_handler` a las dependencias y se declararon los permisos de Android (`POST_NOTIFICATIONS`, `READ_MEDIA_AUDIO`).
- Se incorporaron pruebas unitarias (`test/permissions_service_test.dart`) y se corrió `flutter test` para validar toda la suite.

### 2. Código entregado
```dart
final summary = await _permissionsService.ensureCritical();
if (!summary.allGranted) {
	final notifications = summary[ManagedPermission.notifications];
	debugPrint(notifications.fallbackBehavior);
	if (notifications.isPermanentlyDenied) {
		await _permissionsService.openSystemSettings();
	}
}
```

### 3. Pendientes o limitaciones
- Integrar el servicio con los managers/providers cuando se construyan para decidir en tiempo real si se muestran notificaciones o se permiten sonidos personalizados.
- En plataformas sin soporte nativo (web/desktop) las notificaciones seguirán deshabilitadas y sólo se documenta la degradación.

### 4. Errores o bloqueos
- Ninguno. `flutter test` pasó correctamente tras añadir el servicio y las pruebas.

### 5. Recomendaciones o próximos pasos
- Inyectar `IPermissionsService` donde se necesiten permisos (por ejemplo, antes de programar notificaciones o reproducir audio externo).
- Mostrar al usuario los mensajes de degradación (`fallbackBehavior`) para guiarlo cuando los permisos estén denegados.
- Cuando se implemente el `SoundManager`, reutilizar `ManagedPermission.audio` para validar el acceso al sistema de archivos antes de permitir sonidos personalizados.
