import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class TowTruckWishlistNotifier extends StateNotifier<Set<String>> {
  TowTruckWishlistNotifier() : super({}) {
    _loadWishlist();
  }

  static const _prefsKey = 'tow_truck_wishlist';

  Future<void> _loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(_prefsKey) ?? [];
      state = ids.toSet();

      if (kDebugMode) {
        print(
            '🚛 Tow truck wishlist loaded from SharedPreferences: ${ids.length} items');
        if (ids.isNotEmpty) {
          print('   Items: ${ids.join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading tow truck wishlist: $e');
      }
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, state.toList());

      if (kDebugMode) {
        print(
            '💾 Tow truck wishlist saved to SharedPreferences: ${state.length} items');
        if (state.isNotEmpty) {
          print('   Items: ${state.join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving tow truck wishlist: $e');
      }
    }
  }

  bool isInWishlist(String serviceId) => state.contains(serviceId);

  void toggleWishlist(String serviceId) {
    final wasInWishlist = state.contains(serviceId);
    state = state.contains(serviceId)
        ? state.where((id) => id != serviceId).toSet()
        : {...state, serviceId};

    if (kDebugMode) {
      print(
          '🔄 Tow truck wishlist toggled: $serviceId ${wasInWishlist ? 'removed' : 'added'}');
      print('   Total items: ${state.length}');
    }

    _saveWishlist();
  }
}

final towTruckWishlistProvider =
    StateNotifierProvider<TowTruckWishlistNotifier, Set<String>>(
  (ref) => TowTruckWishlistNotifier(),
);

final towTruckWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(towTruckWishlistProvider).length;
});
