import 'package:flutter/material.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../data/models/reminder_model.dart';

class ReminderController with ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();
  List<ReminderModel> _reminders = [];

  List<ReminderModel> get reminders => _reminders;

  ReminderController() {
    loadReminders();
  }

  void loadReminders() {
    _reminders = _repository.getAllReminders();
    notifyListeners();
  }

  List<ReminderModel> getRemindersByVehicleId(int vehicleId) {
    return _repository.getRemindersByVehicleId(vehicleId);
  }

  Future<void> addReminder(ReminderModel reminder) async {
    await _repository.addReminder(reminder);
    loadReminders();
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await _repository.updateReminder(reminder);
    loadReminders();
  }

  Future<void> deleteReminder(int id) async {
    await _repository.deleteReminder(id);
    loadReminders();
  }

  int getNextId() {
    return _repository.getNextId();
  }
}
