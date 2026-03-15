import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/features/vehicles/vehicle_controller.dart';
import 'package:vehiclemanager/routes/app_routes.dart';
import '../../data/models/vehicle_model.dart';

class EditVehicleScreen extends StatefulWidget {
  final int vehicleId;

  const EditVehicleScreen({super.key, required this.vehicleId});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _mileageController = TextEditingController();
  String _selectedType = 'Motorcycle';
  late VehicleModel _vehicle;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final controller = Provider.of<VehicleController>(context, listen: false);
      final vehicle = controller.getVehicleById(widget.vehicleId);
      if (vehicle != null) {
        _vehicle = vehicle;
        _nameController.text = vehicle.name;
        _brandController.text = vehicle.brand;
        _modelController.text = vehicle.model;
        _mileageController.text = vehicle.currentMileage.toString();
        _selectedType = vehicle.type;
      }
      _loaded = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<VehicleController>(context, listen: false);
      final updated = _vehicle.copyWith(
        name: _nameController.text,
        brand: _brandController.text,
        model: _modelController.text,
        currentMileage: int.parse(_mileageController.text),
        type: _selectedType,
      );
      controller.updateVehicle(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle updated successfully')),
      );
      context.push(AppRoutes.vehicleDetailPath(widget.vehicleId.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Edit Vehicle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loaded
          ? Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Type',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Motorcycle', 'Car', 'Scooter'].map((type) {
                        final selected = _selectedType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: selected,
                          onSelected: (v) =>
                              setState(() => _selectedType = type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Vehicle Name', _nameController),
                    const SizedBox(height: 16),
                    _buildTextField('Brand', _brandController),
                    const SizedBox(height: 16),
                    _buildTextField('Model', _modelController),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Current Mileage',
                      _mileageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.trim().isEmpty)
              return 'Please enter $label';
            if (keyboardType == TextInputType.number &&
                int.tryParse(value) == null)
              return 'Please enter a valid number';
            return null;
          },
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
