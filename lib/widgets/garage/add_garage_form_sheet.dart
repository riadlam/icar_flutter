import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';

class AddGarageFormSheet extends StatefulWidget {
  final String? initialName;
  final String? initialCity;
  final String? initialPhone;
  final List<String>? initialServices;
  final Function(String, String, String, List<String>) onSubmit;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final int? profileId; // Add profileId parameter

  final List<String> availableServices = const [
    'Body Repair Technician',
    'Automotive Diagnostic',
    'Mechanic',
    'Tire Technician',
  ];

  const AddGarageFormSheet({
    Key? key,
    this.initialName,
    this.initialCity,
    this.initialPhone,
    this.initialServices,
    required this.onSubmit,
    this.showDeleteButton = false,
    this.onDelete,
    this.profileId, // Add profileId to constructor
  }) : super(key: key);

  @override
  _AddGarageFormSheetState createState() => _AddGarageFormSheetState();
}

class _AddGarageFormSheetState extends State<AddGarageFormSheet> {
  late final TextEditingController _nameController;
  String? _selectedCity;
  late final TextEditingController _phoneController;
  final List<String> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedCity = widget.initialCity; // Can be null or empty initially
    _phoneController = TextEditingController(text: widget.initialPhone);
    _selectedServices.addAll(widget.initialServices ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _cityController.dispose(); // No longer needed
    _phoneController.dispose();
    super.dispose();
  }

  String _getButtonText() {
    return widget.initialName?.isNotEmpty == true ? 'update'.tr() : 'submit'.tr();
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.trim().isEmpty ||
        _selectedCity == null ||
        _selectedCity!.isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedServices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_fill_required_fields'.tr())),
        );
      }
      return;
    }

    // Store the current context
    final currentContext = context;
    
    try {
      print('Attempting to create/update garage profile...');

      // Show loading indicator
      showDialog(
        context: currentContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Ensure the dialog is shown before proceeding
      await Future.delayed(const Duration(milliseconds: 100));

      // Call the API
      final response = widget.profileId != null && widget.profileId! > 0
          ? await serviceLocator.garageService.updateGarageProfile(
              id: widget.profileId!, // Use the provided profileId
              businessName: _nameController.text.trim(),
              mechanicName: _nameController.text.trim(),
              mobile: _phoneController.text.trim(),
              city: _selectedCity ?? '',
              services: _selectedServices,
            )
          : await serviceLocator.garageService.createGarageProfile(
              businessName: _nameController.text.trim(),
              mechanicName: _nameController.text.trim(),
              mobile: _phoneController.text.trim(),
              city: _selectedCity ?? '',
              services: _selectedServices,
            );
      
      debugPrint('Using profile ID: ${widget.profileId} for update');

      print('API Response: $response');

      if (!mounted) return;

      // Close loading dialog safely
      if (Navigator.of(currentContext, rootNavigator: true).canPop()) {
        Navigator.of(currentContext, rootNavigator: true).pop();
      }

      // Prepare data for parent
      final garageData = {
        'name': _nameController.text.trim(),
        'city': _selectedCity ?? '',
        'phone': _phoneController.text.trim(),
        'services': _selectedServices,
      };

      // Close the form sheet first
      if (Navigator.of(currentContext).canPop()) {
        Navigator.of(currentContext).pop(garageData);
      }

      // Call the parent callback after the form is closed
      if (mounted) {
        widget.onSubmit(
          _nameController.text.trim(),
          _selectedCity ?? '',
          _phoneController.text.trim(),
          _selectedServices,
        );
      }
    } catch (e) {
      print('Error in _handleSubmit: $e');
      
      if (!mounted) return;
      
      // Close loading dialog if it's still open
      if (Navigator.of(currentContext, rootNavigator: true).canPop()) {
        Navigator.of(currentContext, rootNavigator: true).pop();
      }

      // Show error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            SnackBar(content: Text('error_with_reason'.tr(args: [e.toString()]))),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = AppColors.loginbg; // Material blue 700
    final Color lightBlueBackground =
        primaryBlue.withOpacity(0.06); // subtle background

    final inputDecoration = (IconData icon, String hint) => InputDecoration(
          prefixIcon: Icon(icon, color: primaryBlue),
          hintText: hint,
          filled: true,
          fillColor: lightBlueBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        );

    return Padding(
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
              widget.initialName?.isNotEmpty == true
                  ? 'edit_garage_details'.tr()
                  : 'add_garage_details'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: inputDecoration(Icons.business, 'garage_name'.tr()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCity?.isNotEmpty == true ? _selectedCity : null,
              decoration: inputDecoration(Icons.location_city, 'City'),
              items: FilterConstants.garageCities
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: inputDecoration(Icons.phone_android, 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: lightBlueBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
                    child: Text(
                      'Services *',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: widget.availableServices.map((service) {
                      final isSelected = _selectedServices.contains(service);
                      return FilterChip(
                        label: Text(service),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              if (!_selectedServices.contains(service)) {
                                _selectedServices.add(service);
                              }
                            } else {
                              _selectedServices.remove(service);
                            }
                          });
                        },
                        selectedColor: primaryBlue.withOpacity(0.2),
                        backgroundColor: Colors.white,
                        checkmarkColor: primaryBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? primaryBlue : Colors.black87,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                isSelected ? primaryBlue : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_selectedServices.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _selectedServices
                          .map((service) => Chip(
                                label: Text(service),
                                backgroundColor: primaryBlue.withOpacity(0.1),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  setState(() {
                                    _selectedServices.remove(service);
                                  });
                                },
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.showDeleteButton && widget.onDelete != null) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text(
                        'delete'.tr(),
                        style: const TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _handleSubmit,
                    child: Text(
                      _getButtonText().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
