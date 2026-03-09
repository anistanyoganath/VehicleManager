import 'package:hive/hive.dart';

part 'fuel_log_model.g.dart';

@HiveType(typeId: 2)
class FuelLogModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int vehicleId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final double amountOfFuel;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int mileage;

  FuelLogModel({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.amountOfFuel,
    required this.price,
    required this.mileage,
  });

  FuelLogModel copyWith({
    int? id,
    int? vehicleId,
    DateTime? date,
    double? amountOfFuel,
    double? price,
    int? mileage,
  }) {
    return FuelLogModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      amountOfFuel: amountOfFuel ?? this.amountOfFuel,
      price: price ?? this.price,
      mileage: mileage ?? this.mileage,
    );
  }
}
