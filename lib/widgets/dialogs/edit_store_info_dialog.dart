import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/providers/spare_parts_profile_provider.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/spare_parts_service.dart';

class EditStoreInfoDialog extends ConsumerStatefulWidget {
  final String initialStoreName;
  final String initialMobile;
  final String initialCity;

  const EditStoreInfoDialog({
    Key? key,
    required this.initialStoreName,
    required this.initialMobile,
    required this.initialCity,
  }) : super(key: key);

  @override
  ConsumerState<EditStoreInfoDialog> createState() => _EditStoreInfoDialogState();
}

class _EditStoreInfoDialogState extends ConsumerState<EditStoreInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _storeNameController;
  late TextEditingController _mobileController;
  late TextEditingController _cityController;
  bool _isLoading = false;
  final SparePartsService _sparePartsService = ServiceLocator().sparePartsService;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(text: widget.initialStoreName);
    _mobileController = TextEditingController(text: widget.initialMobile);
    _cityController = TextEditingController(text: widget.initialCity);
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _updateStoreInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _sparePartsService.updateStoreInfo(
        storeName: _storeNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        city: _cityController.text.trim(),
      );

      if (response['success'] == true && mounted) {
        // Invalidate the profile provider to refresh the data
        ref.invalidate(sparePartsProfileProvider);
        
        if (context.mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Store information updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Close the dialog
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update store info: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Store Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.loginbg,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _storeNameController,
              label: 'Store Name',
              icon: Icons.store,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter store name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _cityController,
              label: 'City',
              icon: Icons.location_city,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.loginbg),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.loginbg,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateStoreInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.loginbg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.loginbg),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.loginbg),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.loginbg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.loginbg, width: 2),
        ),
      ),
    );
  }
}
