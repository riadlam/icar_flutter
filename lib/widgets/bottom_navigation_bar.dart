import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/tow_truck_wishlist_provider.dart';
import '../../providers/car_wishlist_provider.dart';
import '../../providers/spare_parts_wishlist_provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showProfile;

  const BottomNavigationBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.showProfile = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home icon
            Tooltip(
              message: 'home'.tr(),
              child: IconButton(
                icon: Icon(
                  currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  color: currentIndex == 0 ? AppColors.loginbg : Colors.grey,
                  size: 28,
                ),
                onPressed: () => onTap(0),
              ),
            ),

            // Favorite/Wishlist icon
            Consumer(
              builder: (context, ref, _) {
                final garageWishlistCount = ref.watch(wishlistCountProvider);
                final towTruckWishlistCount = ref.watch(towTruckWishlistCountProvider);
                final carWishlistCount = ref.watch(carWishlistCountProvider);
                final sparePartsWishlistCount = ref.watch(sparePartsWishlistCountProvider);
                final totalWishlistCount = garageWishlistCount + towTruckWishlistCount + carWishlistCount + sparePartsWishlistCount;
                return Tooltip(
                  message: 'wishlist'.tr(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                          color: currentIndex == 1 ? AppColors.loginbg : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () {
                          onTap(1);
                          context.go('/wishlist');
                        },
                      ),
                      if (totalWishlistCount > 0)
                        Positioned(
                          right: 8,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.loginbg,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              totalWishlistCount > 9 ? '9+' : '$totalWishlistCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            // Center big add button with gradient background
            Tooltip(
              message: 'add'.tr(),
              child: GestureDetector(
                onTap: () => onTap(2),
                child: 
                IconButton(
                  icon: Icon(
                    currentIndex == 2 ? Icons.add : Icons.add,
                    color: currentIndex == 2 ? AppColors.loginbg : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () => onTap(2),
                ),
                
                
              ),
            ),

            // Profile icon
            if (showProfile)
              Tooltip(
                message: 'profile'.tr(),
                child: IconButton(
                  icon: Icon(
                    currentIndex == 3 ? Icons.person : Icons.person_outline,
                    color: currentIndex == 3 ? AppColors.loginbg : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () => onTap(3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
