## Informe de Progreso – Tarea 5

### 1. Resumen de avances
- Se reescribió `INotificationService` y `NotificationService` respetando el alcance limitado: Android/iOS con stub web.
- Se implementaron inicialización, permisos mínimos, `show`, `schedule` básico en memoria, `cancel`, `cancelAll` y `pending` (delegado al plugin nativo cuando aplique).
- Se removieron usos de `timezone`, `flutter_native_timezone`, exact alarms y callbacks de background avanzados.
- Se validó el proyecto con `flutter test` tras la reescritura.

### 2. Código entregado
```dart
// lib/services/notification_service.dart (fragmento)
abstract class INotificationService {
	Future<void> initialize({
		NotificationTapCallback? onTap,
		AppSettingsModel? initialSettings,
		bool requestPermissionsOnInit,
	});
	Future<NotificationPermissionStatus> requestPermissions({
		bool alert,
		bool sound,
		bool badge,
	});
	Future<void> show(NotificationRequest request);
	Future<void> schedule(NotificationScheduleRequest request);
	Future<void> cancel(int notificationId);
	Future<void> cancelAll();
	Future<List<PendingNotificationRequest>> pending();
	Future<void> dispose();
}

class NotificationService implements INotificationService {
	@override
	Future<void> schedule(NotificationScheduleRequest request) async {
		final delay = request.scheduledDate.difference(DateTime.now());
		if (delay.isNegative) {
			await show(request);
			return;
		}
		_timers[request.id]?.cancel();
		_timers[request.id] = Timer(delay, () async {
			await show(request);
			_timers.remove(request.id);
		});
	}

	@override
	Future<void> cancel(int notificationId) async {
		_timers.remove(notificationId)?.cancel();
		await _plugin.cancel(notificationId);
	}
}
```

### 3. Pendientes o limitaciones
- La programación depende de la app en ejecución (temporizador en memoria); si la app se cierra, la notificación no se dispara.
- Falta integración con managers/providers y pruebas específicas del servicio.

### 4. Errores o bloqueos
- Ninguno. `flutter test` pasó correctamente tras los cambios.

### 5. Recomendaciones o próximos pasos
- Evaluar más adelante un mecanismo persistente para scheduling cuando se cubran permisos ampliados (Tarea 5.1 o posteriores).
- Integrar el servicio en los managers una vez disponibles, añadiendo pruebas unitarias dirigidas.
- Ajustar canales o acciones personalizados cuando el PRD lo requiera.
