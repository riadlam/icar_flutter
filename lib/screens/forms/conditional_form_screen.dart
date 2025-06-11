import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/user_role.dart' as models;
import 'package:icar_instagram_ui/providers/role_provider.dart';
import 'package:icar_instagram_ui/services/api/services/user_service.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'dart:convert'; // For JSON encoding

final _log = Logger('ConditionalFormScreen');

class ConditionalFormScreen extends ConsumerStatefulWidget {
  final models.UserRole role;
  const ConditionalFormScreen({super.key, required this.role});

  @override
  ConsumerState<ConditionalFormScreen> createState() => _ConditionalFormScreenState();
}

class _ConditionalFormScreenState extends ConsumerState<ConditionalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _privacyChecked = false;

  // Form fields
  final Map<String, dynamic> formData = {};
  bool _isSubmitting = false;
  
  // Services for garage role
  final List<String> _garageServices = [
    'Body Repair Technician',
    'Automotive Diagnostic',
    'Mechanic',
    'Tire Technician',
  ];
  List<String> _selectedServices = [];
  
  // Get services
  late final UserService _userService = serviceLocator.userService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('confirm_details'.tr()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // resizeToAvoidBottomInset true by default, so keyboard avoids overlay
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ..._buildFields(widget.role),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _privacyChecked,
                                onChanged: (v) =>
                                    setState(() => _privacyChecked = v ?? false),
                                activeColor: Colors.pinkAccent,
                              ),
                              GestureDetector(
                                onTap: () => _showPrivacyPolicy(context),
                                child:  Text(
                                  'privacy_policy_agree'.tr(),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => context.go('/role-selection'),
                                child: Text('back'.tr().toUpperCase()),
                              ),
                              ElevatedButton(
                                onPressed: _isSubmitting ? null : () async {
                                  try {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      if (!_privacyChecked) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('please_accept_privacy_policy'.tr())),
                                          );
                                        }
                                        return;
                                      }

                                      setState(() => _isSubmitting = true);

                                      try {
                                        // Prepare clean form data based on role
                                        final Map<String, dynamic> cleanFormData = {};
                                        
                                        // Common fields for all roles
                                        cleanFormData['mobile'] = formData['mobile']?.toString() ?? '';
                                        cleanFormData['city'] = formData['city']?.toString() ?? '';
                                        
                                        // Role-specific fields
                                        switch (widget.role) {
                                          case models.UserRole.seller:
                                            cleanFormData['full_name'] = formData['fullName']?.toString() ?? '';
                                            cleanFormData['showroom_name'] = formData['showroom_name']?.toString() ?? 
                                                (formData['fullName']?.isNotEmpty == true 
                                                    ? '${formData['fullName']}\'s Showroom' 
                                                    : 'My Showroom');
                                            break;
                                          case models.UserRole.buyer:
                                            cleanFormData['store_name'] = formData['storeName']?.toString() ?? '';
                                            break;
                                          case models.UserRole.mechanic:
                                          case models.UserRole.other:
                                            cleanFormData['driver_name'] = formData['driverName']?.toString() ?? '';
                                            if (formData['services'] != null) {
                                              cleanFormData['services'] = formData['services'];
                                            }
                                            break;
                                        }
                                        
                                        // Save clean form data to SharedPreferences
                                        final prefs = await SharedPreferences.getInstance();
                                        final formDataJson = jsonEncode(cleanFormData);
                                        await prefs.setString('user_profile_data_${widget.role.name}', formDataJson);
                                        
                                        // Save the selected role to the role provider
                                        final roleNotifier = ref.read(roleProvider.notifier);
                                        await roleNotifier.setRole(widget.role);
                                        
                                        // Log form data to terminal
                                        _log.info('=== FORM DATA TO BE SUBMITTED ===');
                                        cleanFormData.forEach((key, value) {
                                          _log.info('$key: $value');
                                        });
                                        _log.info('Role: ${widget.role}');
                                        _log.info('==============================');

                                        // Submit the clean form data using the service
                                        await _userService.submitProfileData(widget.role, cleanFormData);
                                        
                                        // Log successful submission
                                        _log.info('=== PROFILE SAVED SUCCESSFULLY ===');
                                        _log.info('Role: ${widget.role}');
                                        _log.info('Saved to SharedPreferences with key: user_profile_data_${widget.role.name}');
                                        _log.info('==============================');
                                        
                                        // Show success message
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('profile_saved_successfully'.tr()),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          
                                          // Navigate to home after a short delay
                                          await Future.delayed(const Duration(seconds: 1));
                                          if (mounted) {
                                            context.go('/home');
                                          }
                                        }
                                      } on FormatException catch (e) {
                                        _log.severe('Format error: ${e.message}');
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('invalid_data_format'.tr()),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        _log.severe('Error submitting profile', e);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('error_submitting_form'.tr()),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isSubmitting = false);
                                        }
                                      }
                                    }
                                  } catch (e, stackTrace) {
                                    _log.severe('Unexpected error in form submission', e, stackTrace);
                                    if (mounted) {
                                      setState(() => _isSubmitting = false);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('unexpected_error'.tr()),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text('finish'.tr().toUpperCase()),
                              ),
                            ],
                          ),
                          // Add bottom padding equal to keyboard height to prevent overlay
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  List<Widget> _buildFields(models.UserRole role) {
    switch (role) {
      case models.UserRole.seller:
        // Initialize form fields with empty strings if not set
        formData['fullName'] ??= '';
        formData['mobile'] ??= '';
        formData['city'] ??= '';
        // Set default showroom name based on full name
        if (formData['fullName']?.isNotEmpty == true) {
          formData['showroom_name'] = '${formData['fullName']}\'s Showroom';
        } else {
          formData['showroom_name'] = 'My Showroom';
        }
        
        return [
          _textField('full_name'.tr(), (v) => formData['fullName'] = v ?? '', 
              initialValue: formData['fullName']?.toString() ?? ''),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v ?? '', 
              keyboardType: TextInputType.phone,
              initialValue: formData['mobile']?.toString() ?? ''),
          _textField('city'.tr(), (v) => formData['city'] = v ?? '',
              initialValue: formData['city']?.toString() ?? ''),
        ];
      case models.UserRole.buyer:
        return [
          _textField('store_name'.tr(), (v) => formData['storeName'] = v),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v, keyboardType: TextInputType.phone),
          _textField('city'.tr(), (v) => formData['city'] = v),
        ];
      case models.UserRole.mechanic:
        return [
          _textField('business_driver_name'.tr(), (v) => formData['driverName'] = v),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v, keyboardType: TextInputType.phone),
          _textField('city'.tr(), (v) => formData['city'] = v),
        ];
      case models.UserRole.other:
        return [
          _textField('mechanic_name'.tr(), (v) => formData['driverName'] = v),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v, keyboardType: TextInputType.phone),
          _textField('city'.tr(), (v) => formData['city'] = v),
          _buildServiceDropdown(),
        ];
    }
  }

  Widget _textField(String label, void Function(String) onSaved, 
      {TextInputType? keyboardType, String initialValue = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        validator: (v) => (v == null || v.isEmpty) ? 'required_field'.tr() : null,
        onChanged: onSaved,
      ),
    );
  }

  Widget _buildServiceDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Services (Multiple)'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ..._garageServices.map((service) {
                  bool isSelected = _selectedServices.contains(service);
                  return CheckboxListTile(
                    title: Text(service),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedServices.add(service);
                        } else {
                          _selectedServices.remove(service);
                        }
                        // Update form data with the list of selected services
                        formData['services'] = List<String>.from(_selectedServices);
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                }).toList(),
              ],
            ),
          ),
          if (_selectedServices.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _selectedServices.map((service) {
                return Chip(
                  label: Text(service),
                  onDeleted: () {
                    setState(() {
                      _selectedServices.remove(service);
                      formData['services'] = List<String>.from(_selectedServices);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  bool _canFinish() {
    if (!_privacyChecked) return false;
    
    // Default return value
    bool canFinish = false;

    switch (widget.role) {
      case models.UserRole.seller:
        // Set default showroom name if not set
        if (formData['showroom_name']?.isEmpty ?? true) {
          formData['showroom_name'] = formData['fullName']?.isNotEmpty == true 
              ? '${formData['fullName']}\'s Showroom' 
              : 'My Showroom';
        }
        
        canFinish = (formData['fullName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false);
        break;
      case models.UserRole.buyer:
        canFinish = (formData['storeName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false);
        break;
      case models.UserRole.mechanic:
      case models.UserRole.other:
        canFinish = (formData['driverName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false) &&
            (_selectedServices.isNotEmpty); // Validate at least one service is selected
        break;
    }
    
    return canFinish;
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('privacy_policy'.tr()),
        content: Text('privacy_policy_content'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close'.tr()),
          ),
        ],
      ),
    );
  }
}
