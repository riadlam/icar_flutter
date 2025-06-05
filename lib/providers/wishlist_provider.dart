import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';

class WishlistNotifier extends StateNotifier<List<GarageService>> {
  WishlistNotifier() : super([]);

  bool isInWishlist(GarageService service) {
    return state.any((item) => item.id == service.id);
  }

  void toggleWishlist(GarageService service) {
    if (isInWishlist(service)) {
      state = state.where((item) => item.id != service.id).toList();
    } else {
      state = [...state, service];
    }
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<GarageService>>(
  (ref) => WishlistNotifier(),
);

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});
