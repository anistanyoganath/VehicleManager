// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehiclemanager/features/dashboard/home_screen.dart';
import 'package:vehiclemanager/features/fuel/fuel_log_screen.dart';
import 'package:vehiclemanager/features/reminders/reminder_settings_screen.dart';
import 'package:vehiclemanager/features/notifications/notifications_screen.dart';
import 'package:vehiclemanager/features/service/add_service_screen.dart';
import 'package:vehiclemanager/features/vehicles/edit_vehicle_screen.dart';
import 'package:vehiclemanager/features/service/service_history_screen.dart';
import 'package:vehiclemanager/features/vehicles/add_vehicle_screen.dart';
import 'package:vehiclemanager/features/vehicles/vehicle_detail_screen.dart';
import 'package:vehiclemanager/features/vehicles/vehicle_list_screen.dart';
import 'package:vehiclemanager/routes/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Home Screen
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Vehicle List Screen
      GoRoute(
        path: AppRoutes.vehicles,
        name: 'vehicles',
        builder: (context, state) => const VehicleListScreen(),
      ),

      // Add Vehicle Screen
      GoRoute(
        path: AppRoutes.addVehicle,
        name: 'addVehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),

      // Vehicle Detail Screen with parameter
      GoRoute(
        path: AppRoutes.vehicleDetail,
        name: 'vehicleDetail',
        builder: (context, state) {
          final vehicleId = state.pathParameters['id'];
          if (vehicleId == null) {
            return const Scaffold(
              body: Center(child: Text('Vehicle ID not found')),
            );
          }
          return VehicleDetailScreen(vehicleId: vehicleId);
        },
      ),

      // Add Service Screen with vehicleId parameter
      GoRoute(
        path: AppRoutes.addService,
        name: 'addService',
        builder: (context, state) {
          final vehicleIdStr = state.pathParameters['vehicleId'];
          final vehicleId = int.tryParse(vehicleIdStr ?? '');
          if (vehicleId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid Vehicle ID')),
            );
          }
          return AddServiceScreen(vehicleId: vehicleId);
        },
      ),

      // Service History Screen with vehicleId parameter
      GoRoute(
        path: AppRoutes.serviceHistory,
        name: 'serviceHistory',
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'];
          if (vehicleId == null) {
            return const Scaffold(
              body: Center(child: Text('Vehicle ID not found')),
            );
          }
          return ServiceHistoryScreen(vehicleId: vehicleId);
        },
      ),

      // Fuel Log Screen with vehicleId parameter
      GoRoute(
        path: AppRoutes.fuelLog,
        name: 'fuelLog',
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'];
          if (vehicleId == null) {
            return const Scaffold(
              body: Center(child: Text('Vehicle ID not found')),
            );
          }
          return FuelLogScreen(vehicleId: vehicleId);
        },
      ),

      // Reminder Settings Screen
      GoRoute(
        path: AppRoutes.reminders,
        name: 'reminders',
        builder: (context, state) => const ReminderSettingsScreen(),
      ),

      // Notifications Screen
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Edit Vehicle Screen
      GoRoute(
        path: AppRoutes.editVehicle,
        name: 'editVehicle',
        builder: (context, state) {
          final vehicleIdStr = state.pathParameters['vehicleId'];
          final vehicleId = int.tryParse(vehicleIdStr ?? '');
          if (vehicleId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid Vehicle ID')),
            );
          }
          return EditVehicleScreen(vehicleId: vehicleId);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.error}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Extension for easier navigation
extension GoRouterExtension on GoRouter {
  String get location => routerDelegate.currentConfiguration.fullPath;
}
