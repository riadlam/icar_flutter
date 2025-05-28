import 'package:flutter/material.dart';

class PostMenuDialog extends StatelessWidget {
  final bool isFavoriteSeller;
  final bool isPostNotificationsActive;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onNotificationsPressed;

  const PostMenuDialog({
    Key? key,
    this.isFavoriteSeller = false,
    this.isPostNotificationsActive = false,
    this.onFavoritePressed,
    this.onNotificationsPressed,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    bool isFavoriteSeller = false,
    bool isPostNotificationsActive = false,
    VoidCallback? onFavoritePressed,
    VoidCallback? onNotificationsPressed,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PostMenuDialog(
          isFavoriteSeller: isFavoriteSeller,
          isPostNotificationsActive: isPostNotificationsActive,
          onFavoritePressed: onFavoritePressed,
          onNotificationsPressed: onNotificationsPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add to favorite sellers option
            ListTile(
              leading: Icon(
                isFavoriteSeller ? Icons.favorite : Icons.favorite_border,
                color: isFavoriteSeller ? Colors.red : null,
              ),
              title: Text(
                isFavoriteSeller 
                    ? 'Remove from favorite sellers' 
                    : 'Add to favorite sellers',
              ),
              onTap: () {
                Navigator.pop(context);
                onFavoritePressed?.call();
              },
            ),
            // Toggle post notifications option
            ListTile(
              leading: Icon(
                isPostNotificationsActive 
                    ? Icons.notifications_off_outlined 
                    : Icons.notifications_active,
                color: isPostNotificationsActive ? Colors.red : null,
              ),
              title: Text(
                isPostNotificationsActive 
                    ? 'Disable new posts notifications' 
                    : 'Enable new posts notifications',
                style: TextStyle(
                  color: isPostNotificationsActive ? Colors.red : null,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onNotificationsPressed?.call();
              },
            ),
            // Cancel button
            ListTile(
              title: const Text('Cancel', textAlign: TextAlign.center),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
