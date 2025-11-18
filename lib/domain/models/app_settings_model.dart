/// Modelo que representa la configuración general de la app.
import 'package:hive/hive.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 6)
class AppSettingsModel {
  /// Sonido de alarma activado.
  @HiveField(0)
  final bool soundEnabled;

  /// Vibración activada.
  @HiveField(1)
  final bool vibrationEnabled;

  /// Notificaciones activadas.
  @HiveField(2)
  final bool notificationsEnabled;

  /// Tema visual (claro/oscuro).
  @HiveField(3)
  final String theme;

  /// Idioma seleccionado.
  @HiveField(4)
  final String language;

  /// Constructor inmutable.
  const AppSettingsModel({
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.notificationsEnabled,
    required this.theme,
    required this.language,
  });

  /// Copia el modelo con cambios.
  AppSettingsModel copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    String? theme,
    String? language,
  }) {
    return AppSettingsModel(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
      'language': language,
    };
  }

  /// Creación desde Map.
  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      soundEnabled: map['soundEnabled'] as bool,
      vibrationEnabled: map['vibrationEnabled'] as bool,
      notificationsEnabled: map['notificationsEnabled'] as bool,
      theme: map['theme'] as String,
      language: map['language'] as String,
    );
  }
}
