/// Modelo que representa la configuración base de Pomodoro.
import 'package:hive/hive.dart';

part 'pomodoro_config_model.g.dart';

@HiveType(typeId: 4)
class PomodoroConfigModel {
  /// Duración de la sesión de estudio en minutos.
  @HiveField(0)
  final int studyMinutes;

  /// Duración del descanso corto en minutos.
  @HiveField(1)
  final int shortBreakMinutes;

  /// Duración del descanso largo en minutos.
  @HiveField(2)
  final int longBreakMinutes;

  /// Número de rondas por ciclo.
  @HiveField(3)
  final int rounds;

  /// Tipo de ciclo seleccionado (ej: clásico, personalizado).
  @HiveField(4)
  final String cycleType;

  /// Constructor inmutable.
  const PomodoroConfigModel({
    required this.studyMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.rounds,
    required this.cycleType,
  });

  /// Copia el modelo con cambios.
  PomodoroConfigModel copyWith({
    int? studyMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? rounds,
    String? cycleType,
  }) {
    return PomodoroConfigModel(
      studyMinutes: studyMinutes ?? this.studyMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      rounds: rounds ?? this.rounds,
      cycleType: cycleType ?? this.cycleType,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {
      'studyMinutes': studyMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'rounds': rounds,
      'cycleType': cycleType,
    };
  }

  /// Creación desde Map.
  factory PomodoroConfigModel.fromMap(Map<String, dynamic> map) {
    return PomodoroConfigModel(
      studyMinutes: map['studyMinutes'] as int,
      shortBreakMinutes: map['shortBreakMinutes'] as int,
      longBreakMinutes: map['longBreakMinutes'] as int,
      rounds: map['rounds'] as int,
      cycleType: map['cycleType'] as String,
    );
  }
}
