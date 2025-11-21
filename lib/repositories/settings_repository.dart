import '../domain/models/app_settings_model.dart';
import '../domain/repositories/i_settings_repository.dart';
import '../infrastructure/serializers.dart';
import '../services/local_storage_service.dart';

/// Implementación concreta de [SettingsRepository] basada en
/// [ILocalStorageService]. Solo maneja la carga y persistencia del
/// `AppSettingsModel` sin lógica adicional.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this.storage);

  final ILocalStorageService<Map<String, dynamic>> storage;

  static const String _boxName = 'app_settings';
  static const String _entryKey = 'current';

  @override
  Future<AppSettingsModel?> loadSettings() async {
    final result = await storage.get(_boxName, _entryKey);
    if (!result.isSuccess) {
      return null;
    }

    return deserializeSettings(result.data);
  }

  @override
  Future<void> saveSettings(AppSettingsModel model) async {
    _validateSettings(model);
    await storage.put(
      _boxName,
      key: _entryKey,
      value: serializeSettings(model),
    );
  }

  void _validateSettings(AppSettingsModel model) {
    if (model.theme.trim().isEmpty) {
      throw ArgumentError('El tema configurado no puede estar vacío.');
    }
    if (model.language.trim().isEmpty) {
      throw ArgumentError('El idioma configurado no puede estar vacío.');
    }
  }
}
