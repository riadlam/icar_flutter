import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/providers/spare_parts_profile_provider.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';
import 'package:icar_instagram_ui/widgets/spare_parts_posts_grid.dart';
import 'package:icar_instagram_ui/widgets/two%20truck/menu_navbar/tow_truck_navbar.dart';

class BuyerProfileScreen extends ConsumerWidget {
  BuyerProfileScreen({super.key});
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sparePartsProfileAsync = ref.watch(sparePartsProfileProvider);
    final sellerPartsAsync = ref.watch(
      sellerSparePartsProvider(sparePartsProfileAsync.value?.id ?? 0),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: TowTruckNavBar(
        scaffoldKey: _scaffoldKey,
        title: 'app_title'.tr(),
      ),
      endDrawer: TowTruckNavBar.buildDrawer(context),
      body: sparePartsProfileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('error_loading_profile'.tr()),
        ),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Info Card
                SparePartsCard(
                  partName: profile.storeName.isNotEmpty ? profile.storeName : 'Store',
                  location: profile.city.isNotEmpty ? profile.city : 'N/A',
                  mobileNumber: profile.mobile,
                  showFavoriteButton: false, // Hide favorite button for store info
                  onTap: () {
                    // TODO: Implement store details navigation if needed
                  },
                ),
                const SizedBox(height: 24),
                
                // Spare Parts Posts Grid
                const SparePartsPostsGrid(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Removed _buildInfoRow as it's no longer needed
}
