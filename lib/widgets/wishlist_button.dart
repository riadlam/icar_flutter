import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/providers/car_wishlist_provider.dart';

class WishlistButton extends ConsumerWidget {
  final String carId;
  final double? size;
  final Color? color;

  const WishlistButton({
    Key? key,
    required this.carId,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(carWishlistProvider).contains(carId);
    
    return IconButton(
      icon: Icon(
        isWishlisted ? Icons.favorite : Icons.favorite_border,
        color: isWishlisted ? Colors.red : (color ?? Colors.white),
        size: size,
      ),
      onPressed: () {
        ref.read(carWishlistProvider.notifier).toggleWishlist(carId);
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
