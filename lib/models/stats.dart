/// Modelo que representa las estadísticas generales del usuario en Pomodoro.
class Stats {
  /// Total de sesiones completadas.
  final int totalSessions;

  /// Total de ciclos completados.
  final int totalCycles;

  /// Total de minutos productivos.
  final int productiveMinutes;

  /// Total de descansos realizados.
  final int totalBreaks;

  /// Fecha de última actualización de estadísticas.
  final DateTime lastUpdated;

  /// Constructor de la clase Stats.
  Stats({
    required this.totalSessions,
    required this.totalCycles,
    required this.productiveMinutes,
    required this.totalBreaks,
    required this.lastUpdated,
  });

  /// Método para copiar las estadísticas con cambios.
  Stats copyWith({
    int? totalSessions,
    int? totalCycles,
    int? productiveMinutes,
    int? totalBreaks,
    DateTime? lastUpdated,
  }) {
    return Stats(
      totalSessions: totalSessions ?? this.totalSessions,
      totalCycles: totalCycles ?? this.totalCycles,
      productiveMinutes: productiveMinutes ?? this.productiveMinutes,
      totalBreaks: totalBreaks ?? this.totalBreaks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'totalSessions': totalSessions,
      'totalCycles': totalCycles,
      'productiveMinutes': productiveMinutes,
      'totalBreaks': totalBreaks,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Creación desde Map (persistencia).
  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      totalSessions: map['totalSessions'] as int,
      totalCycles: map['totalCycles'] as int,
      productiveMinutes: map['productiveMinutes'] as int,
      totalBreaks: map['totalBreaks'] as int,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }
}
