import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarWishlistNotifier extends StateNotifier<Set<String>> {
  CarWishlistNotifier() : super({});

  bool isInWishlist(String carId) => state.contains(carId);

  void toggleWishlist(String carId) {
    state = state.contains(carId)
        ? state.where((id) => id != carId).toSet()
        : {...state, carId};
  }
}

final carWishlistProvider = StateNotifierProvider<CarWishlistNotifier, Set<String>>(
  (ref) => CarWishlistNotifier(),
);

final carWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(carWishlistProvider).length;
});
