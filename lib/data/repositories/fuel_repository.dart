import 'package:hive/hive.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';
import '../models/fuel_log_model.dart';

class FuelRepository {
  late Box<FuelLogModel> _fuelBox;

  FuelRepository() {
    _fuelBox = Hive.box<FuelLogModel>(HiveService.fuelBox);
  }

  List<FuelLogModel> getAllFuelLogs() {
    return _fuelBox.values.toList();
  }

  List<FuelLogModel> getFuelLogsByVehicleId(int vehicleId) {
    return _fuelBox.values
        .where((fuel) => fuel.vehicleId == vehicleId)
        .toList();
  }

  FuelLogModel? getFuelLogById(int id) {
    return _fuelBox.get(id);
  }

  Future<void> addFuelLog(FuelLogModel fuelLog) async {
    await _fuelBox.put(fuelLog.id, fuelLog);
  }

  Future<void> updateFuelLog(FuelLogModel fuelLog) async {
    await _fuelBox.put(fuelLog.id, fuelLog);
  }

  Future<void> deleteFuelLog(int id) async {
    await _fuelBox.delete(id);
  }

  int getNextId() {
    if (_fuelBox.isEmpty) return 1;
    return _fuelBox.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1;
  }
}
