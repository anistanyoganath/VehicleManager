import 'package:flutter/material.dart';
import '../data/models/fuel_log_model.dart';
import '../core/utils/date_utils.dart';

class FuelLogCard extends StatelessWidget {
  final FuelLogModel fuelLog;

  const FuelLogCard({super.key, required this.fuelLog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Date: ${DateUtil.formatDate(fuelLog.date)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${fuelLog.amountOfFuel} L'),
            Text('Price: \$${fuelLog.price.toStringAsFixed(2)}'),
            Text('Mileage: ${fuelLog.mileage} km'),
          ],
        ),
      ),
    );
  }
}
