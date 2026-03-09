import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 3)
class ReminderModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int vehicleId;

  @HiveField(2)
  final String type; // 'date' or 'mileage'

  @HiveField(3)
  final DateTime? expiryDate; // for date-based reminders

  @HiveField(4)
  final int? nextMileage; // for mileage-based reminders

  @HiveField(5)
  final int reminderBeforeDays;

  @HiveField(6)
  final String description;

  ReminderModel({
    required this.id,
    required this.vehicleId,
    required this.type,
    this.expiryDate,
    this.nextMileage,
    required this.reminderBeforeDays,
    required this.description,
  });

  ReminderModel copyWith({
    int? id,
    int? vehicleId,
    String? type,
    DateTime? expiryDate,
    int? nextMileage,
    int? reminderBeforeDays,
    String? description,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      nextMileage: nextMileage ?? this.nextMileage,
      reminderBeforeDays: reminderBeforeDays ?? this.reminderBeforeDays,
      description: description ?? this.description,
    );
  }
}
