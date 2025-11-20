// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroConfigModelAdapter extends TypeAdapter<PomodoroConfigModel> {
  @override
  final int typeId = 4;

  @override
  PomodoroConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroConfigModel(
      studyMinutes: fields[0] as int,
      shortBreakMinutes: fields[1] as int,
      longBreakMinutes: fields[2] as int,
      rounds: fields[3] as int,
      cycleType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroConfigModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.studyMinutes)
      ..writeByte(1)
      ..write(obj.shortBreakMinutes)
      ..writeByte(2)
      ..write(obj.longBreakMinutes)
      ..writeByte(3)
      ..write(obj.rounds)
      ..writeByte(4)
      ..write(obj.cycleType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
