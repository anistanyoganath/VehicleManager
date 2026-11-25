
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vehiclemanager/main.dart';

import 'package:vehiclemanager/data/models/vehicle_model.dart';
import 'package:vehiclemanager/data/models/service_record_model.dart';
import 'package:vehiclemanager/data/models/fuel_log_model.dart';
import 'package:vehiclemanager/data/models/reminder_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Hive for testing.
    Hive.init('./test_hive');

    // Register Hive adapters only if not already registered.
    if (!Hive.isAdapterRegistered(VehicleModelAdapter().typeId)) {
      Hive.registerAdapter(VehicleModelAdapter());
    }

    if (!Hive.isAdapterRegistered(ServiceRecordModelAdapter().typeId)) {
      Hive.registerAdapter(ServiceRecordModelAdapter());
    }

    if (!Hive.isAdapterRegistered(FuelLogModelAdapter().typeId)) {
      Hive.registerAdapter(FuelLogModelAdapter());
    }

    if (!Hive.isAdapterRegistered(ReminderModelAdapter().typeId)) {
      Hive.registerAdapter(ReminderModelAdapter());
    }

    // Open boxes using their correct model types.
    await Hive.openBox<VehicleModel>('vehicles');
    await Hive.openBox<ServiceRecordModel>('services');
    await Hive.openBox<FuelLogModel>('fuels');
    await Hive.openBox<ReminderModel>('reminders');
    await Hive.openBox('settings');
  });

  tearDownAll(() async {
    await Hive.close();
    await Hive.deleteFromDisk();
  });

  testWidgets(
    'VehicleManager app launches successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pump();

      expect(find.byType(MyApp), findsOneWidget);
    },
  );
}
