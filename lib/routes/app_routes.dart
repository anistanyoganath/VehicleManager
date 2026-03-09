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

  // Helper methods to build paths with parameters
  static String vehicleDetailPath(String vehicleId) => '/vehicle/$vehicleId';
  static String addServicePath(String vehicleId) => '/add-service/$vehicleId';
  static String serviceHistoryPath(String vehicleId) =>
      '/service-history/$vehicleId';
  static String fuelLogPath(String vehicleId) => '/fuel-log/$vehicleId';
}
