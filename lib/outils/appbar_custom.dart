import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_badge.dart';

class AnimatedSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showCustomBackButton;
  final VoidCallback? onCustomBackButtonPressed;

  const AnimatedSearchAppBar({
    super.key,
    this.showCustomBackButton = false,
    this.onCustomBackButtonPressed,
  });

  @override
  _AnimatedSearchAppBarState createState() => _AnimatedSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedSearchAppBarState extends State<AnimatedSearchAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.showCustomBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                widget.onCustomBackButtonPressed?.call();
              },
            )
          : null,
      backgroundColor: AppColors.loginbg,
      elevation: 2,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.showCustomBackButton ? 0.0 : 16.0),
        child: Text(
          'app_title'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        // Animated Search Field
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isSearching ? 150 : 0, // Only expands a bit
          curve: Curves.easeInOut,
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _isSearching
              ? Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.iconsappbar),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'search_hint'.tr(),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 16),
                        onSubmitted: (query) {
                          if (query.trim().isNotEmpty) {
                            // URI encode the query to handle special characters in the path
                            final encodedQuery = Uri.encodeComponent(query.trim());
                            context.go('/search-results/$encodedQuery');
                            // Optionally, close search bar after submission
                            // setState(() {
                            //   _isSearching = false;
                            //   _searchController.clear();
                            // });
                          }
                        },
                      ),
                    ),
                  ],
                )
              : null,
        ),
        // Search Icon
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: AppColors.iconsappbar,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchController.clear();
            });
          },
        ),
        // Notification Icon with Badge
        Consumer(
          builder: (context, ref, _) {
            final unreadCount = ref.watch(unreadCountProvider);
            
            return unreadCount.when(
              data: (count) => IconButton(
                icon: NotificationBadge(
                  count: count,
                  child: const Icon(Icons.notifications_none, color: AppColors.iconsappbar),
                ),
                onPressed: () {
                  ref.read(unreadCountProvider.notifier).refresh();
                  context.goNamed('notifications');
                },
              ),
              loading: () => const IconButton(
                icon: Icon(Icons.notifications_none, color: AppColors.iconsappbar),
                onPressed: null,
              ),
              error: (_, __) => IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.iconsappbar),
                onPressed: () {
                  ref.read(unreadCountProvider.notifier).refresh();
                  context.goNamed('notifications');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
