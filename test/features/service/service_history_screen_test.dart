import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';
import 'package:vehiclemanager/data/models/service_record_model.dart';
import 'package:vehiclemanager/features/service/service_controller.dart';
import 'package:vehiclemanager/features/service/service_history_screen.dart';

void main() {
  late Directory testDirectory;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ServiceRecordModelAdapter());
    }
  });

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'vehicle_service_history_test',
    );
    Hive.init(testDirectory.path);
    await Hive.openBox<ServiceRecordModel>(HiveService.serviceBox);
  });

  tearDown(() async {
    await Hive.close();
    await testDirectory.delete(recursive: true);
  });

  testWidgets('service history updates when a service is added', (
    tester,
  ) async {
    final serviceController = ServiceController();
    addTearDown(serviceController.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<ServiceController>.value(
        value: serviceController,
        child: const MaterialApp(home: ServiceHistoryScreen(vehicleId: 7)),
      ),
    );
    expect(find.text('No service records yet'), findsOneWidget);

    await tester.runAsync(
      () => serviceController.addService(
        ServiceRecordModel(
          id: serviceController.getNextId(),
          vehicleId: 7,
          serviceType: 'Oil change',
          serviceDate: DateTime(2026, 11, 16),
          mileageAtService: 12500,
          cost: 4500,
          notes: 'Changed engine oil',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Oil change'), findsOneWidget);
    expect(find.textContaining('12500 km'), findsOneWidget);
    expect(find.text('Changed engine oil'), findsOneWidget);
  });
}
