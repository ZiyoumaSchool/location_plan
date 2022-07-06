// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationMapAdapter extends TypeAdapter<LocationMap> {
  @override
  final int typeId = 1;

  @override
  LocationMap read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationMap(
      name: fields[0] as String?,
      surname: fields[1] as String?,
      phone: fields[2] as String?,
      describe: fields[3] as String?,
      lat: fields[4] as double?,
      lng: fields[5] as double?,
      path: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationMap obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.describe)
      ..writeByte(4)
      ..write(obj.lat)
      ..writeByte(5)
      ..write(obj.lng)
      ..writeByte(6)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationMapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
