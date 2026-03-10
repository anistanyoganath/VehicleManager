import 'package:flutter/material.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGreetingSection(),
                  const SizedBox(height: 20),
                  _buildAlertSection(),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildVehicleSummary(context),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Vehicle Service',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textSecondary,
          onPressed: () {
            context.push(AppRoutes.reminders);
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          color: AppColors.textSecondary,
          onPressed: () {
            context.push(AppRoutes.reminders);
          },
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Rider!',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Ready for a ride?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.motorcycle, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildAlertSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Alerts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAlertItem(
            'Service Due',
            'Honda CB150R - 500 km overdue',
            AppColors.warning,
          ),
          const SizedBox(height: 8),
          _buildAlertItem(
            'Insurance Expiry',
            'Yamaha NMAX - 5 days left',
            AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                () => context.push(AppRoutes.fuelLog),
                'Add Fuel',
                Icons.local_gas_station,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                () => context.push(AppRoutes.addService),
                'Add Service',
                Icons.build,
                AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    VoidCallback onTap,
    String label,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Vehicles',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppRoutes.vehicles);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildVehicleCard(
          'Honda CB150R',
          'Motorcycle',
          '12,450 km',
          'Service in 500 km',
          'assets/honda.png',
        ),
        const SizedBox(height: 8),
        _buildVehicleCard(
          'Yamaha NMAX',
          'Scooter',
          '8,230 km',
          'Service due',
          'assets/yamaha.png',
        ),
      ],
    );
  }

  Widget _buildVehicleCard(
    String name,
    String type,
    String mileage,
    String serviceStatus,
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.speed, size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      mileage,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: serviceStatus.contains('due')
                  ? AppColors.danger.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              serviceStatus,
              style: TextStyle(
                color: serviceStatus.contains('due')
                    ? AppColors.danger
                    : AppColors.warning,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
