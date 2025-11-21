import '../../models/session.dart';

/// Data Transfer Object para serializar y deserializar instancias de [Session].
///
/// Mantiene el contrato con el almacenamiento basado en `Map<String, dynamic>`
/// sin modificar el modelo de dominio. Incluye campos opcionales para
/// extensiones futuras como duraciones planificadas o notas adicionales.
class SessionDTO {
  const SessionDTO({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.categoryId,
    required this.completed,
    this.plannedDuration,
    this.actualElapsed,
    this.status,
    this.note,
  });

  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String categoryId;
  final bool completed;
  final int? plannedDuration;
  final int? actualElapsed;
  final String? status;
  final String? note;

  /// Crea un [SessionDTO] a partir de un mapa tolerante a nulls y tipos.
  factory SessionDTO.fromMap(Map<String, dynamic>? map) {
    final data = _ensureMap(map);
    return SessionDTO(
      id: _readString(data, 'id', _kFallbackId),
      startTime: _readDate(data, 'startTime'),
      endTime: _readDate(data, 'endTime'),
      duration: _readInt(data, 'duration'),
      categoryId: _readString(data, 'categoryId', _kUnknownCategory),
      completed: _readBool(data, 'completed'),
      plannedDuration: _readIntOrNull(data, 'plannedDuration'),
      actualElapsed: _readIntOrNull(data, 'actualElapsed'),
      status: _readStringOrNull(data, 'status'),
      note: _readStringOrNull(data, 'note'),
    );
  }

  /// Crea un DTO a partir del modelo de dominio.
  factory SessionDTO.fromDomain(Session session) {
    return SessionDTO(
      id: session.id,
      startTime: session.startTime,
      endTime: session.endTime,
      duration: session.duration,
      categoryId: session.categoryId,
      completed: session.completed,
      actualElapsed: session.duration,
    );
  }

  /// Convierte el DTO al modelo de dominio.
  Session toDomain() {
    return Session(
      id: id,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      categoryId: categoryId,
      completed: completed,
    );
  }

  /// Conversión a mapa listo para almacenamiento.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'categoryId': categoryId,
      'completed': completed,
      if (plannedDuration != null) 'plannedDuration': plannedDuration,
      if (actualElapsed != null) 'actualElapsed': actualElapsed,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
    };
  }

  /// Retorna una copia con los valores proporcionados.
  SessionDTO copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? categoryId,
    bool? completed,
    int? plannedDuration,
    int? actualElapsed,
    String? status,
    String? note,
  }) {
    return SessionDTO(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      completed: completed ?? this.completed,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualElapsed: actualElapsed ?? this.actualElapsed,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  /// Lista segura de DTOs a partir de datos dinámicos.
  static List<SessionDTO> fromMapList(dynamic raw) {
    if (raw is Iterable) {
      return raw
          .map((entry) => SessionDTO.fromMap(_ensureMap(entry)))
          .toList(growable: false);
    }
    return const <SessionDTO>[];
  }

  /// Serializa una lista de DTOs a mapas.
  static List<Map<String, dynamic>> toMapList(Iterable<SessionDTO> list) {
    return list.map((dto) => dto.toMap()).toList(growable: false);
  }

  @override
  String toString() {
    return 'SessionDTO(id: $id, categoryId: $categoryId, duration: $duration, '
        'completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SessionDTO &&
            other.id == id &&
            other.startTime == startTime &&
            other.endTime == endTime &&
            other.duration == duration &&
            other.categoryId == categoryId &&
            other.completed == completed &&
            other.plannedDuration == plannedDuration &&
            other.actualElapsed == actualElapsed &&
            other.status == status &&
            other.note == note);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      startTime,
      endTime,
      duration,
      categoryId,
      completed,
      plannedDuration,
      actualElapsed,
      status,
      note,
    );
  }

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

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
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

  static int? _readIntOrNull(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool _readBool(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  static DateTime _readDate(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? _kEpoch;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true).toLocal();
    }
    return _kEpoch;
  }

  static const String _kFallbackId = 'session_undefined';
  static const String _kUnknownCategory = 'category_unknown';
  static final DateTime _kEpoch = DateTime.fromMillisecondsSinceEpoch(
    0,
    isUtc: true,
  ).toLocal();
}
