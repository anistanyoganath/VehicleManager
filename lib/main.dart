import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/utils/ads/ad_consent.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/local_db/hive_service.dart';
import 'features/vehicles/vehicle_controller.dart';
import 'features/service/service_controller.dart';
import 'features/fuel/fuel_controller.dart';
import 'features/reminders/reminder_controller.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  consenting.updateConsent();

  MobileAds.instance.initialize();

  await HiveService.init();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleController()),
        ChangeNotifierProvider(create: (_) => ServiceController()),
        ChangeNotifierProvider(create: (_) => FuelController()),
        ChangeNotifierProvider(create: (_) => ReminderController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Vehicle Manager',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
