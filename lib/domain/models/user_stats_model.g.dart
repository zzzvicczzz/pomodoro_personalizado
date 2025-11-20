// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsModelAdapter extends TypeAdapter<UserStatsModel> {
  @override
  final int typeId = 7;

  @override
  UserStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatsModel(
      totalSessions: fields[0] as int,
      totalMinutes: fields[1] as int,
      sessionsByDate: (fields[2] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStatsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalSessions)
      ..writeByte(1)
      ..write(obj.totalMinutes)
      ..writeByte(2)
      ..write(obj.sessionsByDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
