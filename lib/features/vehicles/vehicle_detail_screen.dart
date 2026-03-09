// lib/features/vehicles/presentation/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehiclemanager/routes/app_routes.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF2563EB),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          'Honda CB150R',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2023 • 12,450 km',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // Navigate to edit vehicle
                  // context.push('/edit-vehicle/$vehicleId');
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildServiceSchedule(context),
                const SizedBox(height: 24),
                _buildRecentActivity(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Service',
            Icons.build,
            const Color(0xFF2563EB),
            () => context.push(AppRoutes.addServicePath(vehicleId)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'Fuel',
            Icons.local_gas_station,
            const Color(0xFF10B981),
            () => context.push(AppRoutes.fuelLogPath(vehicleId)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'History',
            Icons.history,
            const Color(0xFFF59E0B),
            () => context.push(AppRoutes.serviceHistoryPath(vehicleId)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceSchedule(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Schedule',
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to reminder settings with this vehicle
                  context.push(AppRoutes.reminders);
                },
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildScheduleItem(
            'Oil Change',
            'Every 3,000 km',
            0.7,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 12),
          _buildScheduleItem(
            'Air Filter',
            'Every 6,000 km',
            0.3,
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String title,
    String interval,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              interval,
              style: TextStyle(color: const Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full service history
                context.push(AppRoutes.serviceHistoryPath(vehicleId));
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Navigate to service detail (if you have that screen)
          },
          child: _buildActivityItem(
            'Oil Change',
            '2 weeks ago • 10,450 km',
            Icons.build,
            const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Navigate to fuel log
            context.push(AppRoutes.fuelLogPath(vehicleId));
          },
          child: _buildActivityItem(
            'Fuel Fill',
            '3 days ago • 12,450 km',
            Icons.local_gas_station,
            const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
