import 'package:hive/hive.dart';

part 'service_record_model.g.dart';

@HiveType(typeId: 1)
class ServiceRecordModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int vehicleId;

  @HiveField(2)
  final String serviceType;

  @HiveField(3)
  final DateTime serviceDate;

  @HiveField(4)
  final int mileageAtService;

  @HiveField(5)
  final double cost;

  @HiveField(6)
  final String notes;

  ServiceRecordModel({
    required this.id,
    required this.vehicleId,
    required this.serviceType,
    required this.serviceDate,
    required this.mileageAtService,
    required this.cost,
    required this.notes,
  });

  ServiceRecordModel copyWith({
    int? id,
    int? vehicleId,
    String? serviceType,
    DateTime? serviceDate,
    int? mileageAtService,
    double? cost,
    String? notes,
  }) {
    return ServiceRecordModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceType: serviceType ?? this.serviceType,
      serviceDate: serviceDate ?? this.serviceDate,
      mileageAtService: mileageAtService ?? this.mileageAtService,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
    );
  }
}
