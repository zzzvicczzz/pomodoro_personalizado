/// Modelo que representa una sesión Pomodoro.
import 'package:hive/hive.dart';

part 'session.g.dart';

/// Adaptador Hive y modelo que representa una sesión Pomodoro.
@HiveType(typeId: 1)
class Session {
  /// Identificador único de la sesión.
  @HiveField(0)
  final String id;

  /// Fecha y hora de inicio de la sesión.
  @HiveField(1)
  final DateTime startTime;

  /// Fecha y hora de fin de la sesión.
  @HiveField(2)
  final DateTime endTime;

  /// Duración total de la sesión en minutos.
  @HiveField(3)
  final int duration;

  /// Categoría asociada a la sesión.
  @HiveField(4)
  final String categoryId;

  /// Indica si la sesión fue completada exitosamente.
  @HiveField(5)
  final bool completed;

  /// Constructor de la clase Session.
  Session({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.categoryId,
    required this.completed,
  });

  /// Método para copiar la sesión con cambios.
  Session copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? categoryId,
    bool? completed,
  }) {
    return Session(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      categoryId: categoryId ?? this.categoryId,
      completed: completed ?? this.completed,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'categoryId': categoryId,
      'completed': completed,
    };
  }

  /// Creación desde Map (persistencia).
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      duration: map['duration'] as int,
      categoryId: map['categoryId'] as String,
      completed: map['completed'] as bool,
    );
  }
}
