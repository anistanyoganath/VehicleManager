// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelLogModelAdapter extends TypeAdapter<FuelLogModel> {
  @override
  final int typeId = 2;

  @override
  FuelLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelLogModel(
      id: fields[0] as int,
      vehicleId: fields[1] as int,
      date: fields[2] as DateTime,
      amountOfFuel: fields[3] as double,
      price: fields[4] as double,
      mileage: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FuelLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vehicleId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.amountOfFuel)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.mileage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
