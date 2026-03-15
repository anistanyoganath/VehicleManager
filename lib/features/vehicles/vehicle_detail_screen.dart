// lib/features/vehicles/presentation/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/routes/app_routes.dart';
import '../vehicles/vehicle_controller.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/models/service_record_model.dart';
import '../../features/service/service_controller.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final vehicleIdInt = int.tryParse(vehicleId);

    if (vehicleIdInt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vehicle Detail')),
        body: const Center(child: Text('Invalid vehicle ID')),
      );
    }

    return Consumer2<VehicleController, ServiceController>(
      builder: (context, vehicleController, serviceController, child) {
        final vehicle = vehicleController.vehicles.firstWhere(
          (v) => v.id == vehicleIdInt,
          orElse: () => VehicleModel(
            id: -1,
            name: '',
            brand: '',
            model: '',
            currentMileage: 0,
            type: '',
          ),
        );

        if (vehicle.id == -1) {
          return Scaffold(
            appBar: AppBar(title: const Text('Vehicle Detail')),
            body: const Center(child: Text('Vehicle not found')),
          );
        }

        final serviceRecords = serviceController.getServicesByVehicleId(
          vehicle.id,
        );
        final latestService = serviceRecords.isNotEmpty
            ? serviceRecords.reduce(
                (a, b) => a.serviceDate.isAfter(b.serviceDate) ? a : b,
              )
            : null;

        final nextServiceKm = latestService != null
            ? latestService.mileageAtService + 5000
            : vehicle.currentMileage + 5000;

        final kmLeft = nextServiceKm - vehicle.currentMileage;

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
                              '${vehicle.brand} ${vehicle.model}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.type} • ${vehicle.currentMileage} km',
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
                      context.push(
                        AppRoutes.editVehiclePath(vehicle.id.toString()),
                      );
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
                    _buildServiceSchedule(
                      context,
                      vehicle,
                      serviceRecords,
                      kmLeft,
                    ),
                    const SizedBox(height: 24),
                    _buildRecentActivity(context, serviceRecords),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildServiceSchedule(
    BuildContext context,
    VehicleModel vehicle,
    List<ServiceRecordModel> serviceRecords,
    int kmLeft,
  ) {
    final latestService = serviceRecords.isNotEmpty
        ? serviceRecords.reduce(
            (a, b) => a.serviceDate.isAfter(b.serviceDate) ? a : b,
          )
        : null;

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
                  context.push(AppRoutes.reminders);
                },
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Next Service'),
            subtitle: Text(
              latestService != null
                  ? 'In $kmLeft km (last @ ${latestService.mileageAtService} km)'
                  : 'No service history yet',
            ),
            leading: const Icon(Icons.build, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(height: 8),
          if (latestService != null)
            ListTile(
              title: const Text('Last Service'),
              subtitle: Text(
                '${latestService.serviceType} at ${latestService.mileageAtService} km on ${latestService.serviceDate.toLocal().toString().split(" ").first}',
              ),
              leading: const Icon(Icons.history, color: Color(0xFF10B981)),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    List<ServiceRecordModel> serviceRecords,
  ) {
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
                context.push(AppRoutes.serviceHistoryPath(vehicleId));
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (serviceRecords.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'No service activity yet.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          ...serviceRecords
              .toList()
              .reversed
              .take(2)
              .map(
                (record) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildActivityItem(
                    record.serviceType,
                    '${record.serviceDate.toLocal().toString().split(' ').first} • ${record.mileageAtService} km',
                    Icons.build,
                    const Color(0xFF2563EB),
                  ),
                ),
              )
              .toList(),
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
