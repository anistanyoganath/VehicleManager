import 'package:flutter/material.dart';
import '../data/models/service_record_model.dart';
import '../core/utils/date_utils.dart';

class ServiceTile extends StatelessWidget {
  final ServiceRecordModel service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(service.serviceType),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateUtil.formatDate(service.serviceDate)}'),
            Text('Mileage: ${service.mileageAtService} km'),
            Text('Cost: \$${service.cost.toStringAsFixed(2)}'),
            if (service.notes.isNotEmpty) Text('Notes: ${service.notes}'),
          ],
        ),
      ),
    );
  }
}
