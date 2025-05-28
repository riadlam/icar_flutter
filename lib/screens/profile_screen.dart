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
    final role = ref.watch(roleProvider);
    
    // Return the appropriate profile screen based on the selected role
    switch (role) {
      case UserRole.buyer:
        return const SellerProfileScreen();
      case UserRole.seller:
        return const BuyerProfileScreen();
      case UserRole.mechanic:
        return const MechanicProfileScreen();
      case UserRole.other:
        return const GarageProfileScreen();
      case null:
        // If no role is selected, show a message to select a role first
        return Scaffold(
          appBar: AppBar(
            title: Text('profile'.tr()),
          ),
          body: Center(
            child: Text('select_role_first'.tr()),
          ),
        );
    }
  }
}
