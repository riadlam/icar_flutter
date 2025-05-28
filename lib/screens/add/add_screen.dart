import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/models/user_role.dart';
import 'package:icar_instagram_ui/providers/role_provider.dart';
import 'package:icar_instagram_ui/screens/add/buyer_add_screen.dart';
import 'package:icar_instagram_ui/screens/add/seller_add_screen.dart';
import 'package:icar_instagram_ui/screens/add/mechanic_add_screen.dart';
import 'package:icar_instagram_ui/screens/add/garage_add_screen.dart';

class AddScreen extends ConsumerWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    
    // Return the appropriate add screen based on the selected role
    switch (role) {
      case UserRole.buyer:
        return const BuyerAddScreen();
      case UserRole.seller:
        return const SellerAddScreen();
      case UserRole.mechanic:
        return const MechanicAddScreen();
      case UserRole.other:
        return const GarageAddScreen();
      case null:
        // If no role is selected, show a message to select a role first
        return Scaffold(
          appBar: AppBar(
            title: Text('add_new'.tr()),
          ),
          body: Center(
            child: Text('select_role_first'.tr()),
          ),
        );
    }
  }
}
