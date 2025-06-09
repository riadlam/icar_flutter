import 'package:flutter_riverpod/flutter_riverpod.dart';

class TowTruckWishlistNotifier extends StateNotifier<Set<String>> {
  TowTruckWishlistNotifier() : super({});

  bool isInWishlist(String serviceId) => state.contains(serviceId);

  void toggleWishlist(String serviceId) {
    state = state.contains(serviceId)
        ? state.where((id) => id != serviceId).toSet()
        : {...state, serviceId};
  }
}

final towTruckWishlistProvider = StateNotifierProvider<TowTruckWishlistNotifier, Set<String>>(
  (ref) => TowTruckWishlistNotifier(),
);

final towTruckWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(towTruckWishlistProvider).length;
});
