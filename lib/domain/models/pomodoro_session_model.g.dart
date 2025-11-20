// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroSessionModelAdapter extends TypeAdapter<PomodoroSessionModel> {
  @override
  final int typeId = 5;

  @override
  PomodoroSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSessionModel(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
      effectiveMinutes: fields[3] as int,
      sessionType: fields[4] as String,
      status: fields[5] as String,
      note: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSessionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.effectiveMinutes)
      ..writeByte(4)
      ..write(obj.sessionType)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
