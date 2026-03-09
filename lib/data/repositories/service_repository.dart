import 'package:hive/hive.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';
import '../models/service_record_model.dart';

class ServiceRepository {
  late Box<ServiceRecordModel> _serviceBox;

  ServiceRepository() {
    _serviceBox = Hive.box<ServiceRecordModel>(HiveService.serviceBox);
  }

  List<ServiceRecordModel> getAllServices() {
    return _serviceBox.values.toList();
  }

  List<ServiceRecordModel> getServicesByVehicleId(int vehicleId) {
    return _serviceBox.values
        .where((service) => service.vehicleId == vehicleId)
        .toList();
  }

  ServiceRecordModel? getServiceById(int id) {
    return _serviceBox.get(id);
  }

  Future<void> addService(ServiceRecordModel service) async {
    await _serviceBox.put(service.id, service);
  }

  Future<void> updateService(ServiceRecordModel service) async {
    await _serviceBox.put(service.id, service);
  }

  Future<void> deleteService(int id) async {
    await _serviceBox.delete(id);
  }

  int getNextId() {
    if (_serviceBox.isEmpty) return 1;
    return _serviceBox.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1;
  }
}
