// lib/features/fuel/presentation/add_fuel_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';
import 'package:vehiclemanager/core/utils/date_utils.dart';
import 'package:vehiclemanager/data/models/fuel_log_model.dart';
import 'package:vehiclemanager/features/fuel/fuel_controller.dart';
import 'package:vehiclemanager/features/vehicles/vehicle_controller.dart';
import 'package:vehiclemanager/widgets/custom_text_field.dart';
import 'package:vehiclemanager/widgets/custom_button.dart';

class AddFuelScreen extends StatefulWidget {
  final int vehicleId;
  final FuelLogModel? fuelLog; // Optional for editing

  const AddFuelScreen({super.key, required this.vehicleId, this.fuelLog});

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _fuelAmountController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();

  // State variables
  DateTime _selectedDate = DateTime.now();
  String _selectedFuelType = 'Pertamax';

  // Fuel type options
  final List<String> _fuelTypes = [
    'Pertamax',
    'Pertalite',
    'Pertamax Turbo',
    'Dexlite',
    'Pertamina Dex',
    'Bio Solar',
    'Shell Super',
    'Shell V-Power',
    'Shell V-Power Nitro',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    final vehicleController = Provider.of<VehicleController>(
      context,
      listen: false,
    );
    final vehicle = vehicleController.getVehicleById(widget.vehicleId);

    if (widget.fuelLog != null) {
      // Editing existing fuel log
      _selectedDate = widget.fuelLog!.date;
      _selectedFuelType = widget.fuelLog!.fuelType;
      _fuelAmountController.text = widget.fuelLog!.amountOfFuel.toString();
      _priceController.text = widget.fuelLog!.price.toString();
      _mileageController.text = widget.fuelLog!.mileage.toString();
    } else if (vehicle != null) {
      // New fuel log - prefill current mileage
      _mileageController.text = vehicle.currentMileage.toString();
    }
  }

  @override
  void dispose() {
    _fuelAmountController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveFuelEntry() async {
    if (_formKey.currentState!.validate()) {
      final fuelController = Provider.of<FuelController>(
        context,
        listen: false,
      );

      if (widget.fuelLog != null) {
        // Update existing fuel log
        final updatedLog = widget.fuelLog!.copyWith(
          date: _selectedDate,
          amountOfFuel: double.parse(_fuelAmountController.text),
          price: double.parse(_priceController.text),
          mileage: int.parse(_mileageController.text),
          fuelType: _selectedFuelType,
        );
        await fuelController.updateFuelLog(updatedLog);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Fuel entry updated successfully!'),
            backgroundColor: AppColors.completed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // Create new fuel log
        final fuelLog = FuelLogModel(
          id: fuelController.getNextId(),
          vehicleId: widget.vehicleId,
          date: _selectedDate,
          amountOfFuel: double.parse(_fuelAmountController.text),
          price: double.parse(_priceController.text),
          mileage: int.parse(_mileageController.text),
          fuelType: _selectedFuelType,
        );

        await fuelController.addFuelLog(fuelLog);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Fuel entry added successfully!'),
            backgroundColor: AppColors.completed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      // Navigate back
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.fuelLog != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Fuel Entry' : 'Add Fuel Entry',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Info Card
              _buildVehicleInfoCard(),

              const SizedBox(height: 24),

              // Fuel Type Selection
              _buildFuelTypeSection(),

              const SizedBox(height: 24),

              // Date Selection
              _buildDateSection(),

              const SizedBox(height: 24),

              // Fuel Amount
              CustomTextField(
                controller: _fuelAmountController,
                label: 'Fuel Amount (Liters)',
                // hint: 'e.g., 12.5',
                // prefixIcon: Icons.local_gas_station,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fuel amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price
              CustomTextField(
                controller: _priceController,
                label: 'Total Price (Rp)',
                // hint: 'e.g., 150000',
                // prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mileage
              CustomTextField(
                controller: _mileageController,
                label: 'Current Mileage (km)',
                // hint: 'e.g., 12450',
                // prefixIcon: Icons.speed,
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

              const SizedBox(height: 24),

              // Price Summary Card
              _buildPriceSummary(),

              const SizedBox(height: 24),

              // Save Button
              CustomButton(
                text: isEditing ? 'Update Fuel Entry' : 'Save Fuel Entry',
                onPressed: _saveFuelEntry,
                icon: isEditing ? Icons.update : Icons.save,
              ),

              // Delete button for editing
              if (isEditing) ...[
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Delete Entry',
                  onPressed: () => _confirmDelete(context),
                  icon: Icons.delete_outline,
                  isOutlined: true,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.danger,
                ),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
    final vehicleController = Provider.of<VehicleController>(context);
    final vehicle = vehicleController.getVehicleById(widget.vehicleId);

    if (vehicle == null) return const SizedBox();

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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              vehicle.type == 'Motorcycle'
                  ? Icons.motorcycle
                  : Icons.directions_car,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.brand} ${vehicle.model}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Current: ${vehicle.currentMileage} km',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fuel Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedFuelType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: _fuelTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFuelType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateUtil.formatDate(_selectedDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    if (_fuelAmountController.text.isEmpty || _priceController.text.isEmpty) {
      return const SizedBox();
    }

    try {
      final amount = double.parse(_fuelAmountController.text);
      final price = double.parse(_priceController.text);
      final pricePerLiter = price / amount;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Price per Liter:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            Text(
              'Rp ${pricePerLiter.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this fuel entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.fuelLog != null) {
      final fuelController = Provider.of<FuelController>(
        context,
        listen: false,
      );
      await fuelController.deleteFuelLog(widget.fuelLog!.id);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }
}
