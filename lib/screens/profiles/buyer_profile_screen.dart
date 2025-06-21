import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/providers/spare_parts_profile_provider.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';
import 'package:icar_instagram_ui/widgets/spare_parts_posts_grid.dart';

class BuyerProfileScreen extends ConsumerWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sparePartsProfileAsync = ref.watch(sparePartsProfileProvider);
    final sellerPartsAsync = ref.watch(
      sellerSparePartsProvider(sparePartsProfileAsync.value?.id ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('my_spare_parts_profile'.tr()),
      ),
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
                  partName: profile.storeName,
                  price: '', // Empty price since this is a store info card
                  condition: '', // Not used for store info
                  location: profile.city.isNotEmpty ? profile.city : 'N/A',
                  sellerName: profile.mobile.isNotEmpty ? 'Phone: ${profile.mobile}' : 'N/A',
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
