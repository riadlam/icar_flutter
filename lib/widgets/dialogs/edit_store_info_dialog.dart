import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
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
  String? _selectedCity;
  bool _isLoading = false;
  final SparePartsService _sparePartsService = ServiceLocator().sparePartsService;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController(text: widget.initialStoreName);
    _mobileController = TextEditingController(text: widget.initialMobile);
    // Only set _selectedCity if the initial city is in the garageCities list
    _selectedCity = FilterConstants.garageCities.contains(widget.initialCity) 
        ? widget.initialCity 
        : null;
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _mobileController.dispose();

    super.dispose();
  }

  Future<void> _updateStoreInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _sparePartsService.updateStoreInfo(
        storeName: _storeNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        city: _selectedCity ?? '',
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
            content: Text('failed_to_update_store_info'.tr(args: [e.toString()])), 
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
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
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'edit_store_information'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.loginbg,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildTextField(
              controller: _storeNameController,
              label: 'store_name'.tr(),
              icon: Icons.store,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please_enter_store_name'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _mobileController,
              label: 'mobile_number'.tr(),
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please_enter_mobile_number'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'city'.tr(),
                prefixIcon: Icon(Icons.location_city, color: AppColors.loginbg),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              items: FilterConstants.garageCities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please_select_a_city'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.loginbg),
                    ),
                    child: Text(
                      'cancel'.tr(),
                      style: TextStyle(
                        color: AppColors.loginbg,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateStoreInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.loginbg,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'update'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
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
