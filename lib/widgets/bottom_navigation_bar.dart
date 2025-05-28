import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
            Tooltip(
              message: 'wishlist'.tr(),
              child: IconButton(
                icon: Icon(
                  currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                  color: currentIndex == 1 ? Colors.pinkAccent : Colors.grey,
                  size: 28,
                ),
                onPressed: () => onTap(1),
              ),
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
