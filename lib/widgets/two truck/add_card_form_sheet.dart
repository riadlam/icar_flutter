import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class AddCardFormSheet extends StatefulWidget {
  final String? initialName;
  final String? initialCity;
  final String? initialPhone;
  final Function(String, String, String)? onSubmit;
  final Function()? onSuccess;

  const AddCardFormSheet({
    super.key,
    this.initialName = '',
    this.initialCity = '',
    this.initialPhone = '',
    this.onSubmit,
    this.onSuccess,
  });

  @override
  State<AddCardFormSheet> createState() => _AddCardFormSheetState();
}

class _AddCardFormSheetState extends State<AddCardFormSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _cityController = TextEditingController(text: widget.initialCity);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _getButtonText() {
    return widget.initialName?.isNotEmpty == true ? 'Update' : 'Submit';
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final towTruckService = serviceLocator.towTruckService;
      
      await towTruckService.createOrUpdateTowTruckProfile(
        businessName: _nameController.text.trim(),
        driverName: _nameController.text.trim(), // Using same name for driver
        mobile: _phoneController.text.trim(),
        city: _cityController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tow truck profile created successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
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
    const Color primaryGreen = Color(0xFF4CAF50); // Material green 500
    final Color lightGreenBackground = primaryGreen.withOpacity(0.06); // subtle background

    final inputDecoration = (IconData icon, String hint) => InputDecoration(
          prefixIcon: Icon(icon, color: primaryGreen),
          hintText: hint,
          filled: true,
          fillColor: lightGreenBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        );

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.initialName?.isNotEmpty == true ? 'Edit Tow Truck Profile' : 'Add Tow Truck Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            // Business Name Field
            TextFormField(
              controller: _nameController,
              decoration: inputDecoration(Icons.business, 'Business Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter business name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            // City Field
            TextFormField(
              controller: _cityController,
              decoration: inputDecoration(Icons.location_city, 'City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            // Mobile Number Field
            TextFormField(
              controller: _phoneController,
              decoration: inputDecoration(Icons.phone_android, 'Mobile Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                // Add more phone number validation if needed
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _getButtonText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
