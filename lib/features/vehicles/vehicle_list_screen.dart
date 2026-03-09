// lib/features/vehicles/presentation/vehicle_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehiclemanager/routes/app_routes.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF1E293B)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Vehicles',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildVehicleCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add vehicle screen
          context.push(AppRoutes.addVehicle);
        },
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add),
        label: const Text('Add Vehicle'),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, int index) {
    final vehicleId = 'vehicle-${index + 1}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to vehicle detail
            context.push(AppRoutes.vehicleDetailPath(vehicleId));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 40,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Honda CB150R',
                        style: TextStyle(
                          color: const Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2023 • 12,450 km',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatusChip('Active', const Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            'Service Soon',
                            const Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: const Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
