// lib/features/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/core/utils/ads/banner_ad.dart';
import 'package:vehiclemanager/core/utils/ads/ads_manager.dart';
import 'package:vehiclemanager/features/service/service_controller.dart';
import '../vehicles/vehicle_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_outlined),
            onPressed: () {
              // Mark all as read functionality
            },
          ),
        ],
      ),
      body: Consumer2<VehicleController, ServiceController>(
        builder: (context, vehicleController, serviceController, child) {
          final vehicles = vehicleController.vehicles;
          final notifications = <Map<String, dynamic>>[];

          for (final vehicle in vehicles) {
            final services = serviceController.getServicesByVehicleId(
              vehicle.id,
            );

            if (services.isEmpty) {
              notifications.add({
                'type': 'info',
                'title': 'No service records',
                'subtitle':
                    '${vehicle.brand} ${vehicle.model}: add service history.',
                'vehicleId': vehicle.id,
                'vehicleName': '${vehicle.brand} ${vehicle.model}',
                'icon': Icons.info_outline,
                'color': AppColors.info,
              });
              continue;
            }

            final latestService = services.reduce(
              (a, b) => a.mileageAtService > b.mileageAtService ? a : b,
            );
            final dueKm =
                5000 -
                (vehicle.currentMileage - latestService.mileageAtService);

            if (dueKm <= 0) {
              notifications.add({
                'type': 'danger',
                'title': 'Service Overdue',
                'subtitle':
                    '${vehicle.brand} ${vehicle.model} is ${-dueKm} km overdue',
                'vehicleId': vehicle.id,
                'vehicleName': '${vehicle.brand} ${vehicle.model}',
                'icon': Icons.warning_amber_rounded,
                'color': AppColors.danger,
                'dueKm': dueKm,
              });
            } else if (dueKm <= 500) {
              notifications.add({
                'type': 'warning',
                'title': 'Service Due Soon',
                'subtitle':
                    '${vehicle.brand} ${vehicle.model} due in $dueKm km',
                'vehicleId': vehicle.id,
                'vehicleName': '${vehicle.brand} ${vehicle.model}',
                'icon': Icons.build_circle_outlined,
                'color': AppColors.warning,
                'dueKm': dueKm,
              });
            }
          }

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      size: 64,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'All caught up!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No notifications at this time.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return _buildNotificationCard(context, item);
            },
          );
        },
      ),
      bottomNavigationBar: const BannerAdvert(),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final Color color = item['color'];
    final IconData icon = item['icon'];
    final String title = item['title'];
    final String subtitle = item['subtitle'];
    final String type = item['type'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // Show a refresh / cross-promotional interstitial before navigation
            await AdsManager().showInterstitialAd();
            if (item.containsKey('vehicleId')) {
              // Navigate to vehicle detail
              // context.push('/vehicle/${item['vehicleId']}');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Time indicator (you can add actual time)
                          Text(
                            'now',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      // Action buttons based on notification type
                      if (type == 'danger' || type == 'warning')
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              _buildActionChip(
                                'Schedule Service',
                                Icons.calendar_today,
                                AppColors.primary,
                                () {
                                  // Navigate to add service
                                },
                              ),
                              const SizedBox(width: 8),
                              _buildActionChip(
                                'Dismiss',
                                Icons.close,
                                AppColors.textSecondary,
                                () {
                                  // Dismiss notification
                                },
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionChip(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isOutlined = false,
  }) {
    return Material(
      color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: isOutlined
                ? Border.all(color: AppColors.textHint.withOpacity(0.3))
                : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isOutlined ? AppColors.textSecondary : color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isOutlined ? AppColors.textSecondary : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
