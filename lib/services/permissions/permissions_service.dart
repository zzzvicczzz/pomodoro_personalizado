import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Permisos críticos que la app necesita gestionar en runtime.
enum ManagedPermission { notifications, audio }

/// Estados simplificados para exponer al resto de la app.
enum PermissionState { granted, denied, permanentlyDenied }

/// Resultado estandarizado de una consulta/solicitud de permiso.
class PermissionStatusResult {
  const PermissionStatusResult({
    required this.permission,
    required this.state,
    required this.details,
    required this.fallbackBehavior,
  });

  final ManagedPermission permission;
  final PermissionState state;
  final String details;
  final String fallbackBehavior;

  bool get isGranted => state == PermissionState.granted;
  bool get isDenied => state == PermissionState.denied;
  bool get isPermanentlyDenied => state == PermissionState.permanentlyDenied;
}

/// Resultado agregado para los permisos fundamentales.
class PermissionsSummary {
  const PermissionsSummary(this.results);

  final Map<ManagedPermission, PermissionStatusResult> results;

  bool get allGranted =>
      results.values.every((result) => result.state == PermissionState.granted);

  PermissionStatusResult operator [](ManagedPermission permission) =>
      results[permission]!;
}

/// Contrato para solicitar y verificar permisos críticos de la app.
abstract class IPermissionsService {
  Future<PermissionStatusResult> status(ManagedPermission permission);

  Future<PermissionStatusResult> request(ManagedPermission permission);

  Future<PermissionsSummary> ensureCritical({bool requestIfNeeded = true});

  Future<bool> openSystemSettings();
}

/// Abstracción mínima para facilitar pruebas.
abstract class PermissionGateway {
  Future<ph.PermissionStatus> status(ph.Permission permission);

  Future<ph.PermissionStatus> request(ph.Permission permission);

  Future<bool> openSystemSettings();
}

class PermissionHandlerGateway implements PermissionGateway {
  const PermissionHandlerGateway();

  @override
  Future<ph.PermissionStatus> status(ph.Permission permission) =>
      permission.status;

  @override
  Future<ph.PermissionStatus> request(ph.Permission permission) =>
      permission.request();

  @override
  Future<bool> openSystemSettings() => ph.openAppSettings();
}

/// Servicio concreto que encapsula la lógica multi-plataforma de permisos.
class PermissionsService implements IPermissionsService {
  PermissionsService({PermissionGateway? gateway})
    : _gateway = gateway ?? const PermissionHandlerGateway();

  final PermissionGateway _gateway;

  @override
  Future<PermissionStatusResult> status(ManagedPermission permission) async {
    if (!_supports(permission)) {
      return _unsupported(permission);
    }

    final rawStatus = await _gateway.status(_map(permission));
    return _toResult(permission, rawStatus);
  }

  @override
  Future<PermissionStatusResult> request(ManagedPermission permission) async {
    if (!_supports(permission)) {
      return _unsupported(permission);
    }

    final rawStatus = await _gateway.request(_map(permission));
    return _toResult(permission, rawStatus);
  }

  @override
  Future<PermissionsSummary> ensureCritical({
    bool requestIfNeeded = true,
  }) async {
    final Map<ManagedPermission, PermissionStatusResult> aggregated = {};

    for (final permission in ManagedPermission.values) {
      aggregated[permission] = requestIfNeeded
          ? await request(permission)
          : await status(permission);
    }

    return PermissionsSummary(aggregated);
  }

  @override
  Future<bool> openSystemSettings() => _gateway.openSystemSettings();

  bool _supports(ManagedPermission permission) {
    if (kIsWeb) {
      return false;
    }

    switch (permission) {
      case ManagedPermission.notifications:
        return defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;
      case ManagedPermission.audio:
        return defaultTargetPlatform == TargetPlatform.android;
    }
  }

  ph.Permission _map(ManagedPermission permission) {
    switch (permission) {
      case ManagedPermission.notifications:
        return ph.Permission.notification;
      case ManagedPermission.audio:
        return ph.Permission.audio;
    }
  }

  PermissionStatusResult _unsupported(ManagedPermission permission) {
    if (permission == ManagedPermission.audio) {
      return _buildResult(
        permission,
        PermissionState.denied,
        details:
            'La plataforma ${_platformLabel()} no expone permisos para leer '
            'archivos de audio del sistema.',
        fallback:
            'Sólo se reproducirán los sonidos empacados con la app en esta '
            'plataforma.',
      );
    }

    return _buildResult(
      permission,
      PermissionState.denied,
      details:
          'La plataforma ${_platformLabel()} no soporta notificaciones '
          'locales con permisos dedicados.',
      fallback:
          'Los recordatorios se limitarán a vibración o a la UI visible '
          'mientras la app esté abierta.',
    );
  }

  PermissionStatusResult _toResult(
    ManagedPermission permission,
    ph.PermissionStatus raw,
  ) {
    final state = _mapState(raw);
    return _buildResult(permission, state);
  }

  PermissionState _mapState(ph.PermissionStatus status) {
    if (status == ph.PermissionStatus.granted ||
        status == ph.PermissionStatus.limited ||
        status == ph.PermissionStatus.provisional) {
      return PermissionState.granted;
    }
    if (status == ph.PermissionStatus.permanentlyDenied) {
      return PermissionState.permanentlyDenied;
    }
    return PermissionState.denied;
  }

  PermissionStatusResult _buildResult(
    ManagedPermission permission,
    PermissionState state, {
    String? details,
    String? fallback,
  }) {
    final detailMessage = details ?? _defaultDetail(permission, state);
    final fallbackMessage = fallback ?? _fallback(permission, state);
    return PermissionStatusResult(
      permission: permission,
      state: state,
      details: detailMessage,
      fallbackBehavior: fallbackMessage,
    );
  }

  String _defaultDetail(ManagedPermission permission, PermissionState state) {
    switch (permission) {
      case ManagedPermission.notifications:
        return switch (state) {
          PermissionState.granted =>
            'Las notificaciones locales pueden mostrarse con sonido y vibración.',
          PermissionState.denied =>
            'Sin permiso de notificaciones no se mostrarán alertas de inicio/fin.',
          PermissionState.permanentlyDenied =>
            'Las notificaciones se encuentran bloqueadas por el sistema.',
        };
      case ManagedPermission.audio:
        return switch (state) {
          PermissionState.granted =>
            'Podrás reproducir sonidos personalizados almacenados en el dispositivo.',
          PermissionState.denied =>
            'El acceso a audio del sistema está bloqueado temporalmente.',
          PermissionState.permanentlyDenied =>
            'El sistema bloqueó permanentemente el acceso a archivos de audio.',
        };
    }
  }

  String _fallback(ManagedPermission permission, PermissionState state) {
    switch (permission) {
      case ManagedPermission.notifications:
        return switch (state) {
          PermissionState.granted => 'Experiencia completa sin degradación.',
          PermissionState.denied =>
            'La app continuará con alertas visuales mientras esté en primer plano.',
          PermissionState.permanentlyDenied =>
            'El usuario debe abrir Ajustes del sistema para restablecer las notificaciones.',
        };
      case ManagedPermission.audio:
        return switch (state) {
          PermissionState.granted =>
            'Se habilitan sonidos embebidos y personalizados.',
          PermissionState.denied =>
            'Sólo se reproducirán sonidos empacados; no se podrá leer audio externo.',
          PermissionState.permanentlyDenied =>
            'El usuario debe habilitar el permiso en Ajustes para elegir sonidos externos.',
        };
    }
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }
}
