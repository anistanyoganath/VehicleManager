import 'package:flutter/material.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/models/service_record_model.dart';

class ServiceController with ChangeNotifier {
  final ServiceRepository _repository = ServiceRepository();
  List<ServiceRecordModel> _services = [];

  List<ServiceRecordModel> get services => _services;

  ServiceController() {
    loadServices();
  }

  void loadServices() {
    _services = _repository.getAllServices();
    notifyListeners();
  }

  List<ServiceRecordModel> getServicesByVehicleId(int vehicleId) {
    return _repository.getServicesByVehicleId(vehicleId);
  }

  Future<void> addService(ServiceRecordModel service) async {
    await _repository.addService(service);
    loadServices();
  }

  Future<void> updateService(ServiceRecordModel service) async {
    await _repository.updateService(service);
    loadServices();
  }

  Future<void> deleteService(int id) async {
    await _repository.deleteService(id);
    loadServices();
  }

  int getNextId() {
    return _repository.getNextId();
  }
}
