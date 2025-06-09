import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/tow_truck_wishlist_provider.dart';

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
                  color: currentIndex == 0 ? Colors.pinkAccent : Colors.grey,
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
                final totalWishlistCount = garageWishlistCount + towTruckWishlistCount;
                return Tooltip(
                  message: 'wishlist'.tr(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                          color: currentIndex == 1 ? Colors.pinkAccent : Colors.grey,
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
                              color: Colors.red,
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
                child: Container(
                  width: 48,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.orangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
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
                    color: currentIndex == 3 ? Colors.pinkAccent : Colors.grey,
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
