import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

class AddGarageFormSheet extends StatefulWidget {
  final String? initialName;
  final String? initialCity;
  final String? initialPhone;
  final List<String>? initialServices;
  final Function(String, String, String, List<String>) onSubmit;

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
  }) : super(key: key);

  @override
  _AddGarageFormSheetState createState() => _AddGarageFormSheetState();
}

class _AddGarageFormSheetState extends State<AddGarageFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _phoneController;
  final List<String> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _cityController = TextEditingController(text: widget.initialCity);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _selectedServices.addAll(widget.initialServices ?? []);
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
    if (_nameController.text.trim().isEmpty || 
        _cityController.text.trim().isEmpty || 
        _phoneController.text.trim().isEmpty ||
        _selectedServices.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
      return;
    }

    try {
      print('Attempting to create garage profile...');
      
      // Show loading indicator
      showDialog(
        context: context,
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
      final response = await serviceLocator.garageService.createGarageProfile(
        businessName: _nameController.text.trim(),
        mechanicName: _nameController.text.trim(), // Using same as business name for now
        mobile: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        services: _selectedServices,
      );
      
      print('API Response: $response');

      // Close loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        
        // Prepare data for parent
        final garageData = {
          'name': _nameController.text.trim(),
          'city': _cityController.text.trim(),
          'phone': _phoneController.text.trim(),
          'services': _selectedServices,
        };
        
        // Close the form sheet first
        Navigator.of(context).pop(garageData);
        
        // Call the parent callback after the form is closed
        if (mounted) {
          widget.onSubmit(
            _nameController.text.trim(),
            _cityController.text.trim(),
            _phoneController.text.trim(),
            _selectedServices,
          );
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Garage profile created successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1976D2); // Material blue 700
    final Color lightBlueBackground = primaryBlue.withOpacity(0.06); // subtle background

    final inputDecoration = (IconData icon, String hint) => InputDecoration(
          prefixIcon: Icon(icon, color: primaryBlue),
          hintText: hint,
          filled: true,
          fillColor: lightBlueBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
              widget.initialName?.isNotEmpty == true ? 'Edit Garage Details' : 'Add Garage Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: inputDecoration(Icons.business, 'Garage Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: inputDecoration(Icons.location_city, 'Location'),
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
                            color: isSelected ? primaryBlue : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_selectedServices.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _selectedServices.map((service) => Chip(
                        label: Text(service),
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _selectedServices.remove(service);
                          });
                        },
                        labelStyle: const TextStyle(color: Colors.black87),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleSubmit,
              child: Text(
                _getButtonText(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
