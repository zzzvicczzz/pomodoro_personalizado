import '../../domain/models/app_settings_model.dart';

/// DTO para [AppSettingsModel], responsable de manejar evoluciones de schema
/// sin impactar la capa de dominio.
class SettingsDTO {
  const SettingsDTO({
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.notificationsEnabled,
    required this.theme,
    required this.language,
    this.customDurations,
    this.alarmSound,
    this.colorTheme,
  });

  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool notificationsEnabled;
  final String theme;
  final String language;
  final Map<String, int>? customDurations;
  final String? alarmSound;
  final String? colorTheme;

  factory SettingsDTO.fromMap(Map<String, dynamic>? map) {
    final data = _ensureMap(map);
    return SettingsDTO(
      soundEnabled: _readBool(data, 'soundEnabled', true),
      vibrationEnabled: _readBool(data, 'vibrationEnabled', true),
      notificationsEnabled: _readBool(data, 'notificationsEnabled', true),
      theme: _readString(data, 'theme', 'light'),
      language: _readString(data, 'language', 'es'),
      customDurations: _readDurationMap(data['customDurations']),
      alarmSound: _readStringOrNull(data, 'alarmSound'),
      colorTheme: _readStringOrNull(data, 'colorTheme'),
    );
  }

  factory SettingsDTO.fromDomain(AppSettingsModel model) {
    return SettingsDTO(
      soundEnabled: model.soundEnabled,
      vibrationEnabled: model.vibrationEnabled,
      notificationsEnabled: model.notificationsEnabled,
      theme: model.theme,
      language: model.language,
    );
  }

  AppSettingsModel toDomain() {
    return AppSettingsModel(
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      notificationsEnabled: notificationsEnabled,
      theme: theme,
      language: language,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
      'language': language,
      if (customDurations != null) 'customDurations': customDurations,
      if (alarmSound != null) 'alarmSound': alarmSound,
      if (colorTheme != null) 'colorTheme': colorTheme,
    };
  }

  SettingsDTO copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    String? theme,
    String? language,
    Map<String, int>? customDurations,
    String? alarmSound,
    String? colorTheme,
  }) {
    return SettingsDTO(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      customDurations: customDurations ?? this.customDurations,
      alarmSound: alarmSound ?? this.alarmSound,
      colorTheme: colorTheme ?? this.colorTheme,
    );
  }

  static List<SettingsDTO> fromMapList(dynamic raw) {
    if (raw is Iterable) {
      return raw
          .map((entry) => SettingsDTO.fromMap(_ensureMap(entry)))
          .toList(growable: false);
    }
    return const <SettingsDTO>[];
  }

  static List<Map<String, dynamic>> toMapList(Iterable<SettingsDTO> list) {
    return list.map((dto) => dto.toMap()).toList(growable: false);
  }

  @override
  String toString() => 'SettingsDTO(theme: $theme, language: $language)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SettingsDTO &&
            other.soundEnabled == soundEnabled &&
            other.vibrationEnabled == vibrationEnabled &&
            other.notificationsEnabled == notificationsEnabled &&
            other.theme == theme &&
            other.language == language &&
            _mapEquals(other.customDurations, customDurations) &&
            other.alarmSound == alarmSound &&
            other.colorTheme == colorTheme);
  }

  @override
  int get hashCode => Object.hash(
    soundEnabled,
    vibrationEnabled,
    notificationsEnabled,
    theme,
    language,
    _mapHash(customDurations),
    alarmSound,
    colorTheme,
  );

  static Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, dynamic v) => MapEntry(key.toString(), v));
    }
    return <String, dynamic>{};
  }

  static String _readString(
    Map<String, dynamic> data,
    String key,
    String fallback,
  ) {
    final value = data[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    if (value != null) {
      return value.toString();
    }
    return fallback;
  }

  static String? _readStringOrNull(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return value.toString();
  }

  static bool _readBool(Map<String, dynamic> data, String key, bool fallback) {
    final value = data[key];
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return fallback;
  }

  static Map<String, int>? _readDurationMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((key, dynamic v) => MapEntry(key, _toInt(v)));
    }
    if (value is Map) {
      final result = <String, int>{};
      value.forEach((key, dynamic v) {
        result[key.toString()] = _toInt(v);
      });
      return result;
    }
    return null;
  }

  static bool _mapEquals(Map<String, int>? a, Map<String, int>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.length != b.length) {
      return false;
    }
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  static int _mapHash(Map<String, int>? map) {
    if (map == null) {
      return 0;
    }
    return Object.hashAll(map.entries);
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
