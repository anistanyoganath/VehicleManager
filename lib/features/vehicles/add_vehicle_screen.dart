import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehiclemanager/core/theme/app_colors.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Vehicle',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleTypeSelector(),
            const SizedBox(height: 24),
            _buildTextField('Vehicle Name', 'e.g., My Bike'),
            const SizedBox(height: 16),
            _buildTextField('Brand', 'e.g., Honda'),
            const SizedBox(height: 16),
            _buildTextField('Model', 'e.g., CB150R'),
            const SizedBox(height: 16),
            _buildTextField(
              'Current Mileage',
              '12,450',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _buildImageUpload(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Save Vehicle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeChip('Motorcycle', Icons.motorcycle, true),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTypeChip('Car', Icons.directions_car, false)),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeChip('Scooter', Icons.electric_scooter, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : AppColors.textHint.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textHint.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 32, color: AppColors.textHint),
          const SizedBox(height: 8),
          Text(
            'Add Vehicle Photo',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Optional',
            style: TextStyle(color: AppColors.textHint, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
