import 'package:hive_flutter/hive_flutter.dart';
import '../models/vehicle_model.dart';
import '../models/service_record_model.dart';
import '../models/fuel_log_model.dart';
import '../models/reminder_model.dart';

class HiveService {
  static const String vehicleBox = 'vehicles';
  static const String serviceBox = 'services';
  static const String fuelBox = 'fuels';
  static const String reminderBox = 'reminders';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(VehicleModelAdapter());
    Hive.registerAdapter(ServiceRecordModelAdapter());
    Hive.registerAdapter(FuelLogModelAdapter());
    Hive.registerAdapter(ReminderModelAdapter());

    // Open boxes
    await Hive.openBox<VehicleModel>(vehicleBox);
    await Hive.openBox<ServiceRecordModel>(serviceBox);
    await Hive.openBox<FuelLogModel>(fuelBox);
    await Hive.openBox<ReminderModel>(reminderBox);
    await Hive.openBox(settingsBox);
  }
}
