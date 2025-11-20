import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:pomodoro_personalizado/services/permissions/permissions_service.dart';

void main() {
  group('PermissionsService', () {
    test(
      'request notifications returns granted result when gateway grants',
      () async {
        final gateway = _FakeGateway(
          requestResponses: {
            ph.Permission.notification: ph.PermissionStatus.granted,
          },
        );
        final service = PermissionsService(gateway: gateway);

        final result = await service.request(ManagedPermission.notifications);

        expect(result.permission, ManagedPermission.notifications);
        expect(result.isGranted, isTrue);
        expect(result.details, contains('notificaciones'));
      },
    );

    test('ensureCritical aggregates statuses without requesting', () async {
      final gateway = _FakeGateway(
        statusResponses: {
          ph.Permission.notification: ph.PermissionStatus.denied,
          ph.Permission.audio: ph.PermissionStatus.permanentlyDenied,
        },
      );
      final service = PermissionsService(gateway: gateway);

      final summary = await service.ensureCritical(requestIfNeeded: false);

      expect(summary[ManagedPermission.notifications].isDenied, isTrue);
      expect(summary[ManagedPermission.audio].isPermanentlyDenied, isTrue);
      expect(summary.allGranted, isFalse);
    });

    test('openSystemSettings defers to gateway', () async {
      final gateway = _FakeGateway(openSettingsValue: true);
      final service = PermissionsService(gateway: gateway);

      expect(await service.openSystemSettings(), isTrue);
    });
  });
}

class _FakeGateway implements PermissionGateway {
  _FakeGateway({
    Map<ph.Permission, ph.PermissionStatus>? statusResponses,
    Map<ph.Permission, ph.PermissionStatus>? requestResponses,
    bool openSettingsValue = false,
  }) : statusResponses = statusResponses ?? const {},
       requestResponses = requestResponses ?? const {},
       openSettingsValue = openSettingsValue;

  final Map<ph.Permission, ph.PermissionStatus> statusResponses;
  final Map<ph.Permission, ph.PermissionStatus> requestResponses;
  final bool openSettingsValue;

  @override
  Future<ph.PermissionStatus> request(ph.Permission permission) async {
    return requestResponses[permission] ?? ph.PermissionStatus.denied;
  }

  @override
  Future<ph.PermissionStatus> status(ph.Permission permission) async {
    return statusResponses[permission] ?? ph.PermissionStatus.denied;
  }

  @override
  Future<bool> openSystemSettings() async => openSettingsValue;
}
