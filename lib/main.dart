
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:vehiclemanager/core/utils/ads/ad_consent.dart';
import 'package:vehiclemanager/core/utils/iap_manager.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/local_db/hive_service.dart';
import 'features/vehicles/vehicle_controller.dart';
import 'features/service/service_controller.dart';
import 'features/fuel/fuel_controller.dart';
import 'features/reminders/reminder_controller.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads only on Android and iOS.
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
       defaultTargetPlatform == TargetPlatform.iOS)) {
    consenting.updateConsent();
    MobileAds.instance.initialize();
  }

  // Initialize local database.
  await HiveService.init();

  // Initialize in-app purchases only on Android and iOS.
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
       defaultTargetPlatform == TargetPlatform.iOS)) {
    await IAPManager().init();
  }

  // Initialize notifications on supported platforms.
  if (!kIsWeb) {
    await NotificationService.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VehicleController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FuelController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderController(),
        ),
        ChangeNotifierProvider(
          create: (_) => IAPManager(),
        ),
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
