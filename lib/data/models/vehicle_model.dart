import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 0)
class VehicleModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final String model;

  @HiveField(4)
  final int currentMileage;

  VehicleModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.currentMileage,
  });

  VehicleModel copyWith({
    int? id,
    String? name,
    String? brand,
    String? model,
    int? currentMileage,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      currentMileage: currentMileage ?? this.currentMileage,
    );
  }
}
