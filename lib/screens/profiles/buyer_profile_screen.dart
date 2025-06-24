import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:icar_instagram_ui/providers/spare_parts_profile_provider.dart';
import 'package:icar_instagram_ui/providers/spare_parts_posts_provider.dart';
import 'package:icar_instagram_ui/services/api/services/spare_parts_service.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';
import 'package:icar_instagram_ui/widgets/dialogs/edit_store_info_dialog.dart';
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
                // Store Info Card with Edit Button
                SparePartsCard(
                  partName: profile.storeName.isNotEmpty ? profile.storeName : 'Store',
                  location: profile.city.isNotEmpty ? profile.city : 'N/A',
                  mobileNumber: profile.mobile,
                  partId: '${profile.storeName}_${profile.mobile}', // Generate a unique ID for the store
                  showFavoriteButton: false, // Hide favorite button for store info
                  showEditButton: true, // Show edit button
                  showShareButton: false, // Hide share button
                  onTap: () {
                    // TODO: Implement store details navigation if needed
                  },
                  onEdit: () => _showEditStoreInfoDialog(context, ref, profile),
                ),
                const SizedBox(height: 24),
                
                // Spare Parts Posts Grid
                SparePartsPostsGrid(
                  onShare: () => _shareStoreInfo(
                    context,
                    profile.storeName.isNotEmpty ? profile.storeName : 'Store',
                    profile.city.isNotEmpty ? profile.city : 'N/A',
                    profile.mobile,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareStoreInfo(
    BuildContext context,
    String storeName,
    String location,
    String? mobileNumber,
  ) async {
    final text = 'Check out $storeName' +
        (location.isNotEmpty ? ' in $location' : '') +
        (mobileNumber != null ? ' - Contact: $mobileNumber' : '');

    await Share.share(
      text,
      subject: 'Store: $storeName',
    );
  }

  Future<void> _showEditStoreInfoDialog(
    BuildContext context,
    WidgetRef ref,
    SparePartsProfile profile,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dragging handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              // Dialog content
              Flexible(
                child: EditStoreInfoDialog(
                  initialStoreName: profile.storeName,
                  initialMobile: profile.mobile,
                  initialCity: profile.city,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result == true && context.mounted) {
      ref.invalidate(sparePartsProfileProvider);
    }
  }
}
