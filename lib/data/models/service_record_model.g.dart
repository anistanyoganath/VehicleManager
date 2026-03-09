// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceRecordModelAdapter extends TypeAdapter<ServiceRecordModel> {
  @override
  final int typeId = 1;

  @override
  ServiceRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceRecordModel(
      id: fields[0] as int,
      vehicleId: fields[1] as int,
      serviceType: fields[2] as String,
      serviceDate: fields[3] as DateTime,
      mileageAtService: fields[4] as int,
      cost: fields[5] as double,
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceRecordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vehicleId)
      ..writeByte(2)
      ..write(obj.serviceType)
      ..writeByte(3)
      ..write(obj.serviceDate)
      ..writeByte(4)
      ..write(obj.mileageAtService)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
