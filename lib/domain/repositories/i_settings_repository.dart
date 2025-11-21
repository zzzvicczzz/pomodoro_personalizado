/// Contrato (interfaz) para el repositorio de configuración de la app.
///
/// Define únicamente los métodos necesarios para acceder y modificar
/// el `AppSettingsModel` en la capa de dominio. No contiene implementaciones.
import '../models/app_settings_model.dart';

abstract class SettingsRepository {
  /// Carga la configuración de la aplicación.
  Future<AppSettingsModel?> loadSettings();

  /// Guarda la configuración de la aplicación.
  Future<void> saveSettings(AppSettingsModel model);
}
