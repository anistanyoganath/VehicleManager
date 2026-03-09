import 'package:hive/hive.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  late Box<ReminderModel> _reminderBox;

  ReminderRepository() {
    _reminderBox = Hive.box<ReminderModel>(HiveService.reminderBox);
  }

  List<ReminderModel> getAllReminders() {
    return _reminderBox.values.toList();
  }

  List<ReminderModel> getRemindersByVehicleId(int vehicleId) {
    return _reminderBox.values
        .where((reminder) => reminder.vehicleId == vehicleId)
        .toList();
  }

  ReminderModel? getReminderById(int id) {
    return _reminderBox.get(id);
  }

  Future<void> addReminder(ReminderModel reminder) async {
    await _reminderBox.put(reminder.id, reminder);
  }

  Future<void> updateReminder(ReminderModel reminder) async {
    await _reminderBox.put(reminder.id, reminder);
  }

  Future<void> deleteReminder(int id) async {
    await _reminderBox.delete(id);
  }

  int getNextId() {
    if (_reminderBox.isEmpty) return 1;
    return _reminderBox.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1;
  }
}
