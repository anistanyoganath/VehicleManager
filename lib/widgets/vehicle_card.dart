import 'package:flutter/material.dart';
import '../data/models/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const VehicleCard({super.key, required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(vehicle.name),
        subtitle: Text(
          '${vehicle.brand} ${vehicle.model} - ${vehicle.currentMileage} km',
        ),
        onTap: onTap,
      ),
    );
  }
}
