import 'package:hive/hive.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';
import '../models/vehicle_model.dart';

class VehicleRepository {
  late Box<VehicleModel> _vehicleBox;

  VehicleRepository() {
    _vehicleBox = Hive.box<VehicleModel>(HiveService.vehicleBox);
  }

  List<VehicleModel> getAllVehicles() {
    return _vehicleBox.values.toList();
  }

  VehicleModel? getVehicleById(int id) {
    return _vehicleBox.get(id);
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle);
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    await _vehicleBox.put(vehicle.id, vehicle);
  }

  Future<void> deleteVehicle(int id) async {
    await _vehicleBox.delete(id);
  }

  int getNextId() {
    if (_vehicleBox.isEmpty) return 1;
    return _vehicleBox.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1;
  }
}
