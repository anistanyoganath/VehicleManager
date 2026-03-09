import 'package:flutter/material.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';

class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            true,
            child: _buildMileageSlider(),
          ),
          const SizedBox(height: 16),
          _buildReminderCard(
            'Service by Date',
            'Get notified based on time intervals',
            Icons.calendar_today,
            AppColors.accent,
            false,
            child: _buildDateIntervalPicker(),
          ),
          const SizedBox(height: 16),
          _buildReminderCard(
            'Insurance Expiry',
            'Get notified before insurance expires',
            Icons.security,
            AppColors.warning,
            true,
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
              Switch(value: value, onChanged: (val) {}, activeColor: color),
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
              '500 km',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: 500,
          min: 100,
          max: 5000,
          divisions: 10,
          onChanged: (val) {},
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
          Expanded(child: _buildIntervalOption('1 Month', true)),
          Expanded(child: _buildIntervalOption('3 Months', false)),
          Expanded(child: _buildIntervalOption('6 Months', false)),
        ],
      ),
    );
  }

  Widget _buildIntervalOption(String label, bool isSelected) {
    return Container(
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
    );
  }

  Widget _buildInsuranceSettings() {
    return Row(
      children: [
        Expanded(child: _buildInsuranceField('Days before', '30')),
        const SizedBox(width: 12),
        Expanded(child: _buildInsuranceField('Notify at', '09:00')),
      ],
    );
  }

  Widget _buildInsuranceField(String label, String value) {
    return Container(
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
          _buildNotificationOption('Push Notifications', true),
          const SizedBox(height: 12),
          _buildNotificationOption('Email Notifications', false),
          const SizedBox(height: 12),
          _buildNotificationOption('Sound', true),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(String title, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: AppColors.textPrimary)),
        Switch(
          value: value,
          onChanged: (val) {},
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
