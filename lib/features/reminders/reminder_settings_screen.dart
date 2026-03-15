import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import '../../data/local_db/hive_service.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  late Box _settingsBox;
  bool _serviceByKmEnabled = true;
  double _serviceByKmDistance = 500;
  bool _serviceByDateEnabled = false;
  String _serviceByDateInterval = '1 Month';
  bool _insuranceEnabled = true;
  int _insuranceDaysBefore = 30;
  TimeOfDay _insuranceTime = const TimeOfDay(hour: 9, minute: 0);
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box(HiveService.settingsBox);
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _serviceByKmEnabled = _settingsBox.get(
        'serviceByKmEnabled',
        defaultValue: true,
      );
      _serviceByKmDistance = _settingsBox.get(
        'serviceByKmDistance',
        defaultValue: 500.0,
      );
      _serviceByDateEnabled = _settingsBox.get(
        'serviceByDateEnabled',
        defaultValue: false,
      );
      _serviceByDateInterval = _settingsBox.get(
        'serviceByDateInterval',
        defaultValue: '1 Month',
      );
      _insuranceEnabled = _settingsBox.get(
        'insuranceEnabled',
        defaultValue: true,
      );
      _insuranceDaysBefore = _settingsBox.get(
        'insuranceDaysBefore',
        defaultValue: 30,
      );
      final String timeString = _settingsBox.get(
        'insuranceTime',
        defaultValue: '09:00',
      );
      final parts = timeString.split(':');
      _insuranceTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 9,
        minute: int.tryParse(parts[1]) ?? 0,
      );
      _pushEnabled = _settingsBox.get('pushEnabled', defaultValue: true);
      _emailEnabled = _settingsBox.get('emailEnabled', defaultValue: false);
      _soundEnabled = _settingsBox.get('soundEnabled', defaultValue: true);
    });
  }

  void _setSetting(String key, dynamic value) {
    _settingsBox.put(key, value);
  }

  Future<void> _pickInsuranceTime(BuildContext context) async {
    final result = await showTimePicker(
      context: context,
      initialTime: _insuranceTime,
    );
    if (result != null) {
      setState(() {
        _insuranceTime = result;
        _setSetting(
          'insuranceTime',
          '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Reminders',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReminderCard(
            'Service by KM',
            'Get notified when service is due by mileage',
            Icons.speed,
            AppColors.primary,
            _serviceByKmEnabled,
            onChanged: (val) {
              setState(() {
                _serviceByKmEnabled = val;
                _setSetting('serviceByKmEnabled', val);
              });
            },
            child: _buildMileageSlider(),
          ),
          const SizedBox(height: 16),
          _buildReminderCard(
            'Service by Date',
            'Get notified based on time intervals',
            Icons.calendar_today,
            AppColors.accent,
            _serviceByDateEnabled,
            onChanged: (val) {
              setState(() {
                _serviceByDateEnabled = val;
                _setSetting('serviceByDateEnabled', val);
              });
            },
            child: _buildDateIntervalPicker(),
          ),
          const SizedBox(height: 16),
          _buildReminderCard(
            'Insurance Expiry',
            'Get notified before insurance expires',
            Icons.security,
            AppColors.warning,
            _insuranceEnabled,
            onChanged: (val) {
              setState(() {
                _insuranceEnabled = val;
                _setSetting('insuranceEnabled', val);
              });
            },
            child: _buildInsuranceSettings(),
          ),
          const SizedBox(height: 24),
          _buildNotificationSettings(),
        ],
      ),
    );
  }

  Widget _buildReminderCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value, {
    required ValueChanged<bool> onChanged,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged, activeColor: color),
            ],
          ),
          if (child != null) ...[const SizedBox(height: 16), child],
        ],
      ),
    );
  }

  Widget _buildMileageSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reminder at',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              '${_serviceByKmDistance.toInt()} km',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _serviceByKmDistance,
          min: 100,
          max: 5000,
          divisions: 49,
          onChanged: _serviceByKmEnabled
              ? (val) {
                  setState(() {
                    _serviceByKmDistance = val;
                    _setSetting('serviceByKmDistance', val);
                  });
                }
              : null,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDateIntervalPicker() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildIntervalOption('1 Month')),
          Expanded(child: _buildIntervalOption('3 Months')),
          Expanded(child: _buildIntervalOption('6 Months')),
        ],
      ),
    );
  }

  Widget _buildIntervalOption(String label) {
    final isSelected = _serviceByDateInterval == label;
    return GestureDetector(
      onTap: _serviceByDateEnabled
          ? () {
              setState(() {
                _serviceByDateInterval = label;
                _setSetting('serviceByDateInterval', label);
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceSettings() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Days before',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: _insuranceEnabled
                          ? () {
                              setState(() {
                                _insuranceDaysBefore =
                                    (_insuranceDaysBefore - 1).clamp(1, 365);
                                _setSetting(
                                  'insuranceDaysBefore',
                                  _insuranceDaysBefore,
                                );
                              });
                            }
                          : null,
                    ),
                    Expanded(
                      child: Text(
                        '$_insuranceDaysBefore days',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: _insuranceEnabled
                          ? () {
                              setState(() {
                                _insuranceDaysBefore =
                                    (_insuranceDaysBefore + 1).clamp(1, 365);
                                _setSetting(
                                  'insuranceDaysBefore',
                                  _insuranceDaysBefore,
                                );
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInsuranceField(
            'Notify at',
            _insuranceTime.format(context),
            onTap: _insuranceEnabled ? () => _pickInsuranceTime(context) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceField(
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Settings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildNotificationOption('Push Notifications', _pushEnabled, (val) {
            setState(() {
              _pushEnabled = val;
              _setSetting('pushEnabled', val);
            });
          }),
          const SizedBox(height: 12),
          _buildNotificationOption('Email Notifications', _emailEnabled, (val) {
            setState(() {
              _emailEnabled = val;
              _setSetting('emailEnabled', val);
            });
          }),
          const SizedBox(height: 12),
          _buildNotificationOption('Sound', _soundEnabled, (val) {
            setState(() {
              _soundEnabled = val;
              _setSetting('soundEnabled', val);
            });
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: AppColors.textPrimary)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
