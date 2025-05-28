import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/services/navigation_service.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/user_role.dart' as models;
import 'package:icar_instagram_ui/services/api/services/user_service.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'dart:convert'; // For JSON encoding

final _log = Logger('ConditionalFormScreen');

class ConditionalFormScreen extends StatefulWidget {
  final models.UserRole role;
  const ConditionalFormScreen({super.key, required this.role});

  @override
  State<ConditionalFormScreen> createState() => _ConditionalFormScreenState();
}

class _ConditionalFormScreenState extends State<ConditionalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _privacyChecked = false;

  // Form fields
  final Map<String, dynamic> formData = {};
  bool _isSubmitting = false;
  
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
                                        // Save form data to SharedPreferences
                                        final prefs = await SharedPreferences.getInstance();
                                        final formDataJson = jsonEncode(formData);
                                        await prefs.setString('user_profile_data_${widget.role.name}', formDataJson);
                                        
                                        // Log form data to terminal
                                        _log.info('=== FORM DATA TO BE SUBMITTED ===');
                                        formData.forEach((key, value) {
                                          _log.info('$key: $value');
                                        });
                                        _log.info('Role: ${widget.role}');
                                        _log.info('==============================');

                                        // Submit the form data using the service
                                        await _userService.submitProfileData(widget.role, formData);
                                        
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
      case models.UserRole.buyer:
        return [
          _textField('full_name'.tr(), (v) => formData['fullName'] = v),
          _textField('showroom_name'.tr(), (v) => formData['showroomName'] = v),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v, keyboardType: TextInputType.phone),
          _textField('city'.tr(), (v) => formData['city'] = v),
        ];
      case models.UserRole.seller:
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
          _textField('business_name'.tr(), (v) => formData['businessName'] = v),
          _textField('mechanic_name'.tr(), (v) => formData['driverName'] = v),
          _textField('mobile_number'.tr(), (v) => formData['mobile'] = v, keyboardType: TextInputType.phone),
          _textField('city'.tr(), (v) => formData['city'] = v),
        ];
    }
  }

  Widget _textField(String label, Function(String) onSaved, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
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

  bool _canFinish() {
    if (!_privacyChecked) return false;
    
    // Default return value
    bool canFinish = false;

    switch (widget.role) {
      case models.UserRole.buyer:
        canFinish = (formData['fullName']?.toString().isNotEmpty ?? false) &&
            (formData['showroomName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false);
        break;
      case models.UserRole.seller:
        canFinish = (formData['storeName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false);
        break;
      case models.UserRole.mechanic:
      case models.UserRole.other:
        canFinish = (formData['businessName']?.toString().isNotEmpty ?? false) &&
            (formData['driverName']?.toString().isNotEmpty ?? false) &&
            (formData['mobile']?.toString().isNotEmpty ?? false) &&
            (formData['city']?.toString().isNotEmpty ?? false);
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
