import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/providers/wishlist_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import '../outils/appbar_custom.dart' show AnimatedSearchAppBar;

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AnimatedSearchAppBar(),

      body: wishlist.isEmpty
          ? const Center(
              child: Text('Your wishlist is empty'),
            )
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final service = wishlist[index];
                return GarageServiceCard(
                  service: service,
                  onTap: () {
                    // Handle tap on wishlist item
                  },
                  // The card handles the favorite state internally
                );
              },
            ),
    );
  }
}
