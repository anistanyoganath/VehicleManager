import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/service_record_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../core/utils/date_utils.dart';
import 'service_controller.dart';

class AddServiceScreen extends StatefulWidget {
  final int vehicleId;

  const AddServiceScreen({super.key, required this.vehicleId});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeController = TextEditingController();
  final _mileageController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _mileageController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final vehicleId = widget.vehicleId;
      final serviceController = Provider.of<ServiceController>(
        context,
        listen: false,
      );
      final service = ServiceRecordModel(
        id: serviceController.getNextId(),
        vehicleId: vehicleId,
        serviceType: _serviceTypeController.text,
        serviceDate: _selectedDate,
        mileageAtService: int.parse(_mileageController.text),
        cost: double.parse(_costController.text),
        notes: _notesController.text,
      );
      serviceController.addService(service);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Service Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: _serviceTypeController,
                  label: 'Service Type',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${DateUtil.formatDate(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _mileageController,
                  label: 'Mileage at Service',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mileage';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _costController,
                  label: 'Cost',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _notesController,
                  label: 'Notes',
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                CustomButton(text: 'Save Service', onPressed: _saveService),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
