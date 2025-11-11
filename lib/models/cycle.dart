/// Modelo que representa un ciclo Pomodoro (conjunto de sesiones y descansos).
// import '../config/constants.dart';
import 'package:hive/hive.dart';

part 'cycle.g.dart';

/// Adaptador Hive y modelo que representa un ciclo Pomodoro (conjunto de sesiones y descansos).
@HiveType(typeId: 2)
class Cycle {
  /// Identificador único del ciclo.
  @HiveField(0)
  final String id;

  /// Lista de identificadores de sesiones que forman el ciclo.
  @HiveField(1)
  final List<String> sessionIds;

  /// Número total de sesiones en el ciclo.
  @HiveField(2)
  final int totalSessions;

  /// Número de descansos realizados en el ciclo.
  @HiveField(3)
  final int breaks;

  /// Fecha de creación del ciclo.
  @HiveField(4)
  final DateTime createdAt;

  /// Constructor de la clase Cycle.
  Cycle({
    required this.id,
    required this.sessionIds,
    required this.totalSessions,
    required this.breaks,
    required this.createdAt,
  });

  /// Método para copiar el ciclo con cambios.
  Cycle copyWith({
    String? id,
    List<String>? sessionIds,
    int? totalSessions,
    int? breaks,
    DateTime? createdAt,
  }) {
    return Cycle(
      id: id ?? this.id,
      sessionIds: sessionIds ?? this.sessionIds,
      totalSessions: totalSessions ?? this.totalSessions,
      breaks: breaks ?? this.breaks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionIds': sessionIds,
      'totalSessions': totalSessions,
      'breaks': breaks,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creación desde Map (persistencia).
  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      id: map['id'] as String,
      sessionIds: List<String>.from(map['sessionIds'] as List),
      totalSessions: map['totalSessions'] as int,
      breaks: map['breaks'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
