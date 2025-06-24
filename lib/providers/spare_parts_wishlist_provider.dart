import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/spare_parts_search_params.dart';

class SparePartsWishlistNotifier extends StateNotifier<Map<String, SparePartsProfile>> {
  SparePartsWishlistNotifier() : super({});

  bool isInWishlist(String partId) => state.containsKey(partId);

  void toggleWishlist(SparePartsProfile profile) {
    final partId = '${profile.storeName}_${profile.mobile}';
    debugPrint('Toggling wishlist for partId: $partId');
    
    if (state.containsKey(partId)) {
      final newState = Map<String, SparePartsProfile>.from(state)..remove(partId);
      state = newState;
    } else {
      final newState = Map<String, SparePartsProfile>.from(state)..[partId] = profile;
      state = newState;
    }
    
    debugPrint('New wishlist state: ${state.keys.toList()}');
  }
  
  List<SparePartsProfile> get wishlistedItems => state.values.toList();
}

final sparePartsWishlistProvider = StateNotifierProvider<SparePartsWishlistNotifier, Map<String, SparePartsProfile>>(
  (ref) => SparePartsWishlistNotifier(),
);

final sparePartsWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(sparePartsWishlistProvider).length;
});

final sparePartsWishlistItemsProvider = Provider<List<SparePartsProfile>>((ref) {
  return ref.watch(sparePartsWishlistProvider.notifier).wishlistedItems;
});
