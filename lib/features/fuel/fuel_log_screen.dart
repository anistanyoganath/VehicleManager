import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/core/utils/ads/banner_ad.dart';
import 'package:vehiclemanager/features/fuel/fuel_controller.dart';
import 'package:vehiclemanager/routes/app_routes.dart';
import '../../data/models/fuel_log_model.dart';

class FuelLogScreen extends StatelessWidget {
  final int vehicleId;

  const FuelLogScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FuelController>(context);

    final fuelLogs = controller.getFuelLogsByVehicleId(vehicleId);

    final totalSpent = fuelLogs.fold<double>(0, (sum, e) => sum + e.totalPrice);

    final totalLiters = fuelLogs.fold<double>(0, (sum, e) => sum + e.liters);

    final double avgPrice = totalLiters == 0 ? 0 : (totalSpent / totalLiters);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
        title: Text(
          'Fuel Log',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSummaryCard(totalSpent, avgPrice, totalLiters),

          Expanded(
            child: fuelLogs.isEmpty
                ? const Center(child: Text("No fuel logs yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fuelLogs.length,
                    itemBuilder: (context, index) {
                      final log = fuelLogs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: _buildFuelEntry(log),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.push(AppRoutes.addFuelPath(vehicleId));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BannerAdvert(),
    );
  }

  // ✅ Summary with REAL values
  Widget _buildSummaryCard(
    double totalSpent,
    double avgPrice,
    double totalLiters,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            'Total Spent',
            _formatCurrency(totalSpent),
            Icons.money,
          ),
          _buildSummaryItem(
            'Avg Price',
            _formatCurrency(avgPrice),
            Icons.trending_up,
          ),
          _buildSummaryItem(
            'Total Ltr',
            '${totalLiters.toStringAsFixed(1)} L',
            Icons.local_gas_station,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  // ✅ Dynamic entry
  Widget _buildFuelEntry(FuelLogModel log) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_gas_station,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 Fuel type + price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.fuelType,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatCurrency(log.totalPrice),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 🔥 Mileage + liters
                Row(
                  children: [
                    Icon(Icons.speed, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      '${log.mileage} km',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.local_fire_department,
                      size: 12,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${log.liters} L',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 🔥 Date
                Text(
                  _timeAgo(log.date),
                  style: TextStyle(color: AppColors.textHint, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helpers
  String _formatCurrency(double value) {
    return 'Rs ${value.toStringAsFixed(0)}';
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "$diff days ago";
  }
}
