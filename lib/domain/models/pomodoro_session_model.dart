/// Modelo que representa una sesión ejecutada de Pomodoro.
import 'package:hive/hive.dart';

part 'pomodoro_session_model.g.dart';

@HiveType(typeId: 5)
class PomodoroSessionModel {
  /// Identificador único de la sesión.
  @HiveField(0)
  final String id;

  /// Fecha y hora de inicio de la sesión.
  @HiveField(1)
  final DateTime startTime;

  /// Fecha y hora de fin de la sesión.
  @HiveField(2)
  final DateTime endTime;

  /// Duración efectiva en minutos.
  @HiveField(3)
  final int effectiveMinutes;

  /// Tipo de sesión (estudio, descanso corto, descanso largo).
  @HiveField(4)
  final String sessionType;

  /// Estado de la sesión (completada, cancelada, pausada).
  @HiveField(5)
  final String status;

  /// Nota opcional de la sesión.
  @HiveField(6)
  final String? note;

  /// Constructor inmutable.
  const PomodoroSessionModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.effectiveMinutes,
    required this.sessionType,
    required this.status,
    this.note,
  });

  /// Copia el modelo con cambios.
  PomodoroSessionModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? effectiveMinutes,
    String? sessionType,
    String? status,
    String? note,
  }) {
    return PomodoroSessionModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      effectiveMinutes: effectiveMinutes ?? this.effectiveMinutes,
      sessionType: sessionType ?? this.sessionType,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'effectiveMinutes': effectiveMinutes,
      'sessionType': sessionType,
      'status': status,
      'note': note,
    };
  }

  /// Creación desde Map.
  factory PomodoroSessionModel.fromMap(Map<String, dynamic> map) {
    return PomodoroSessionModel(
      id: map['id'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      effectiveMinutes: map['effectiveMinutes'] as int,
      sessionType: map['sessionType'] as String,
      status: map['status'] as String,
      note: map['note'] as String?,
    );
  }
}
