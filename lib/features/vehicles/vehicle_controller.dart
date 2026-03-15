import 'package:flutter/material.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/models/vehicle_model.dart';

class VehicleController with ChangeNotifier {
  final VehicleRepository _repository = VehicleRepository();
  List<VehicleModel> _vehicles = [];

  List<VehicleModel> get vehicles => _vehicles;

  VehicleController() {
    loadVehicles();
  }

  void loadVehicles() {
    _vehicles = _repository.getAllVehicles();
    notifyListeners();
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    await _repository.addVehicle(vehicle);
    loadVehicles();
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    await _repository.updateVehicle(vehicle);
    loadVehicles();
  }

  Future<void> deleteVehicle(int id) async {
    await _repository.deleteVehicle(id);
    loadVehicles();
  }

  int getNextId() {
    return _repository.getNextId();
  }

  VehicleModel? getVehicleById(int id) {
    return _repository.getVehicleById(id);
  }
}
