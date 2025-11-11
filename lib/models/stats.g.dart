// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatsAdapter extends TypeAdapter<Stats> {
  @override
  final int typeId = 3;

  @override
  Stats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stats(
      totalSessions: fields[0] as int,
      totalCycles: fields[1] as int,
      productiveMinutes: fields[2] as int,
      totalBreaks: fields[3] as int,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Stats obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalSessions)
      ..writeByte(1)
      ..write(obj.totalCycles)
      ..writeByte(2)
      ..write(obj.productiveMinutes)
      ..writeByte(3)
      ..write(obj.totalBreaks)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
