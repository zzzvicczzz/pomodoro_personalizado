/// Modelo que representa las métricas y estadísticas del usuario.
import 'package:hive/hive.dart';

part 'user_stats_model.g.dart';

@HiveType(typeId: 7)
class UserStatsModel {
  /// Total de sesiones completadas.
  @HiveField(0)
  final int totalSessions;

  /// Total de minutos acumulados.
  @HiveField(1)
  final int totalMinutes;

  /// Historial compacto de sesiones (por fecha).
  @HiveField(2)
  final Map<String, int> sessionsByDate;

  /// Constructor inmutable.
  const UserStatsModel({
    required this.totalSessions,
    required this.totalMinutes,
    required this.sessionsByDate,
  });

  /// Copia el modelo con cambios.
  UserStatsModel copyWith({
    int? totalSessions,
    int? totalMinutes,
    Map<String, int>? sessionsByDate,
  }) {
    return UserStatsModel(
      totalSessions: totalSessions ?? this.totalSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      sessionsByDate: sessionsByDate ?? this.sessionsByDate,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'sessionsByDate': sessionsByDate,
    };
  }

  /// Creación desde Map.
  factory UserStatsModel.fromMap(Map<String, dynamic> map) {
    return UserStatsModel(
      totalSessions: map['totalSessions'] as int,
      totalMinutes: map['totalMinutes'] as int,
      sessionsByDate: Map<String, int>.from(map['sessionsByDate'] as Map),
    );
  }
}
