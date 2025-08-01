import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart' as models;
import '../providers/role_provider.dart';
import '../services/auth_service.dart';

final _log = Logger('RoleSelectionScreen');

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    super.initState();
    _setRegistrationPhaseTrue();
  }

  Future<void> _setRegistrationPhaseTrue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('registration_phase', true);
  }

  models.UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('i_register_to'.tr()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This hides the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roleTile('rent_sell_car'.tr(), Icons.directions_car,
                        models.UserRole.buyer),
                    _roleTile('spare_parts_store'.tr(), Icons.shopping_cart,
                        models.UserRole.seller),
                    _roleTile('list_tow_truck'.tr(), Icons.local_shipping,
                        models.UserRole.mechanic),
                    _roleTile(
                        'garage'.tr(), Icons.build, models.UserRole.other),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _selectedRole == null ? null : _handleNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.loginbg,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('next'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleTile(String title, IconData icon, models.UserRole role) {
    String? imagePath;
    if (role == models.UserRole.buyer) {
      imagePath = 'assets/images/car1.png';
    } else if (role == models.UserRole.seller) {
      imagePath = 'assets/images/shopcart.png';
    } else if (role == models.UserRole.mechanic) {
      imagePath = 'assets/images/towtruck_icon.png';
    } else if (role == models.UserRole.other) {
      imagePath = 'assets/images/car2.png';
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: imagePath != null
            ? Image.asset(
                imagePath,
                width: 26,
                height: 26,
                color: AppColors.loginbg,
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Radio<models.UserRole>(
          value: role,
          groupValue: _selectedRole,
          onChanged: (models.UserRole? value) {
            setState(() {
              _selectedRole = value;
            });
          },
          activeColor: AppColors.loginbg,
        ),
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _handleNextPressed() async {
    if (_selectedRole == null) {
      // Show error if no role is selected
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_role'.tr())),
        );
      }
      return;
    }

    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Update user role in the backend
      await authService.updateUserRole(_selectedRole!.index);

      // Save the selected role using the provider
      if (mounted) {
        final container = ProviderScope.containerOf(context, listen: false);
        container.read(roleProvider.notifier).setRole(_selectedRole!);

        // Navigate to the form screen with the selected role
        if (mounted) {
          Navigator.of(context).pop(); // Dismiss loading dialog
          context.go('/form', extra: _selectedRole);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failed_to_update_role'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
      _log.severe('Error updating role', e);
    }
  }
}
