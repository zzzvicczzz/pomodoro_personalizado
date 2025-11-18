import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_personalizado/domain/models/app_settings_model.dart';

/// Callback simple para manejar taps sobre notificaciones.
typedef NotificationTapCallback = void Function(String? payload);

/// Estado minimalista de permisos de notificaciones.
enum NotificationPermissionStatus { granted, denied }

/// Datos mínimos para mostrar una notificación inmediata.
class NotificationRequest {
  const NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.details,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final NotificationDetails? details;

  NotificationScheduleRequest schedule(DateTime date) =>
      NotificationScheduleRequest(
        id: id,
        title: title,
        body: body,
        payload: payload,
        details: details,
        scheduledDate: date,
      );
}

/// Datos para programar una notificación básica mientras la app está activa.
class NotificationScheduleRequest extends NotificationRequest {
  const NotificationScheduleRequest({
    required super.id,
    required super.title,
    required super.body,
    required this.scheduledDate,
    super.payload,
    super.details,
  });

  final DateTime scheduledDate;
}

/// Contrato reducido del servicio de notificaciones.
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

  Future<void> updateSettings(AppSettingsModel settings);

  Future<void> show(NotificationRequest request);

  Future<void> schedule(NotificationScheduleRequest request);

  Future<void> cancel(int notificationId);

  Future<void> cancelAll();

  Future<List<PendingNotificationRequest>> pending();

  Future<void> dispose();
}

/// Implementación para Android/iOS con stub web.
class NotificationService implements INotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final Map<int, Timer> _timers = <int, Timer>{};

  bool _initialized = false;
  bool _settingsAllowNotifications = true;
  NotificationTapCallback? _tapCallback;

  @override
  Future<void> initialize({
    NotificationTapCallback? onTap,
    AppSettingsModel? initialSettings,
    bool requestPermissionsOnInit = false,
  }) async {
    _tapCallback = onTap;
    _settingsAllowNotifications = initialSettings?.notificationsEnabled ?? true;

    if (kIsWeb) {
      _initialized = true;
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        _tapCallback?.call(response.payload);
      },
    );

    _initialized = true;

    if (requestPermissionsOnInit) {
      await requestPermissions(alert: true, sound: true, badge: true);
    }
  }

  @override
  Future<NotificationPermissionStatus> requestPermissions({
    bool alert = true,
    bool sound = true,
    bool badge = true,
  }) async {
    if (kIsWeb) {
      return NotificationPermissionStatus.granted;
    }

    var granted = true;

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      final result = await iosPlugin.requestPermissions(
        alert: alert,
        sound: sound,
        badge: badge,
      );
      granted = granted && (result ?? false);
    }

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final result = await androidPlugin.requestNotificationsPermission();
      if (result != null) {
        granted = granted && result;
      }
    }

    return granted
        ? NotificationPermissionStatus.granted
        : NotificationPermissionStatus.denied;
  }

  @override
  Future<void> updateSettings(AppSettingsModel settings) async {
    _settingsAllowNotifications = settings.notificationsEnabled;
  }

  @override
  Future<void> show(NotificationRequest request) async {
    await _ensureReady();
    if (!_settingsAllowNotifications || kIsWeb) return;

    await _plugin.show(
      request.id,
      request.title,
      request.body,
      request.details ?? _defaultDetails,
      payload: request.payload,
    );
  }

  @override
  Future<void> schedule(NotificationScheduleRequest request) async {
    await _ensureReady();
    if (!_settingsAllowNotifications || kIsWeb) return;

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
    if (kIsWeb) return;
    await _plugin.cancel(notificationId);
  }

  @override
  Future<void> cancelAll() async {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  @override
  Future<List<PendingNotificationRequest>> pending() async {
    if (kIsWeb) return const [];
    return _plugin.pendingNotificationRequests();
  }

  @override
  Future<void> dispose() async {
    await cancelAll();
    _tapCallback = null;
  }

  Future<void> _ensureReady() async {
    if (_initialized) return;
    throw StateError('NotificationService no ha sido inicializado.');
  }

  NotificationDetails get _defaultDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      'pomodoro_focus_channel',
      'Pomodoro Focus',
      channelDescription: 'Recordatorios de ciclos Pomodoro',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );
}
