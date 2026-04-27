class AppRoutes {
  // Base routes without parameters
  static const String home = '/';
  static const String vehicles = '/vehicles';
  static const String addVehicle = '/add-vehicle';
  static const String reminders = '/reminders';

  // Routes with parameters - these are the path patterns
  static const String vehicleDetail = '/vehicle/:id';
  static const String addService = '/add-service/:vehicleId';
  static const String serviceHistory = '/service-history/:vehicleId';
  static const String fuelLog = '/fuel-log/:vehicleId';
  static const String addFuel = '/add-fuel/:vehicleId';
  static const String notifications = '/notifications';
  static const String editVehicle = '/edit-vehicle/:vehicleId';

  // Helper methods to build paths with parameters
  static String vehicleDetailPath(int vehicleId) => '/vehicle/$vehicleId';
  static String editVehiclePath(int vehicleId) => '/edit-vehicle/$vehicleId';
  static String addServicePath(int vehicleId) => '/add-service/$vehicleId';
  static String serviceHistoryPath(int vehicleId) =>
      '/service-history/$vehicleId';
  static String fuelLogPath(int vehicleId) => '/fuel-log/$vehicleId';
  static String addFuelPath(int vehicleId) => '/add-fuel/$vehicleId';
  static String notificationsPath() => '/notifications';
}
