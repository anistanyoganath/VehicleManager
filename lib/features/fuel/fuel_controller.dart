import 'package:flutter/material.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/models/fuel_log_model.dart';

class FuelController with ChangeNotifier {
  final FuelRepository _repository = FuelRepository();
  List<FuelLogModel> _fuelLogs = [];

  List<FuelLogModel> get fuelLogs => _fuelLogs;

  FuelController() {
    loadFuelLogs();
  }

  void loadFuelLogs() {
    _fuelLogs = _repository.getAllFuelLogs();
    notifyListeners();
  }

  List<FuelLogModel> getFuelLogsByVehicleId(int vehicleId) {
    return _repository.getFuelLogsByVehicleId(vehicleId);
  }

  Future<void> addFuelLog(FuelLogModel fuelLog) async {
    await _repository.addFuelLog(fuelLog);
    loadFuelLogs();
  }

  Future<void> updateFuelLog(FuelLogModel fuelLog) async {
    await _repository.updateFuelLog(fuelLog);
    loadFuelLogs();
  }

  Future<void> deleteFuelLog(int id) async {
    await _repository.deleteFuelLog(id);
    loadFuelLogs();
  }

  int getNextId() {
    return _repository.getNextId();
  }
}
