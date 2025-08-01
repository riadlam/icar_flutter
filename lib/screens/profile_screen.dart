import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/models/user_role.dart';
import 'package:icar_instagram_ui/providers/role_provider.dart';
import 'package:icar_instagram_ui/screens/profiles/buyer_profile_screen.dart';
import 'package:icar_instagram_ui/screens/profiles/seller_profile_screen.dart';
import 'package:icar_instagram_ui/screens/profiles/mechanic_profile_screen.dart';
import 'package:icar_instagram_ui/screens/profiles/garage_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(roleProvider);

    return roleAsync.when(
      data: (role) {
        // If no role is set, show role selection screen
        if (role == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('profile'.tr()),
            ),
            body: Center(
              child: Text('select_role_first'.tr()),
            ),
          );
        }

        // Otherwise show the appropriate profile based on role
        switch (role) {
          //cars
          case UserRole.buyer:
            return SellerProfileScreen();
          //spare parts
          case UserRole.seller:
            return BuyerProfileScreen();
          case UserRole.mechanic:
            return const MechanicProfileScreen();
          case UserRole.other:
            return const GarageProfileScreen();
        }
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('profile'.tr()),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: Text('profile'.tr()),
        ),
        body: Center(
          child: Text('Error loading role: $error'.tr()),
        ),
      ),
    );
  }
}
