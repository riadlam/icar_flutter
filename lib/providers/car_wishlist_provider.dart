import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CarWishlistNotifier extends StateNotifier<Set<String>> {
  CarWishlistNotifier() : super({}) {
    _loadWishlist();
  }

  static const _prefsKey = 'car_wishlist';

  Future<void> _loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(_prefsKey) ?? [];
      state = ids.toSet();
      if (kDebugMode) {
        print(
            '🚗 Car wishlist loaded from SharedPreferences: ${ids.length} items');
        if (ids.isNotEmpty) {
          print('   Items: ${ids.join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading car wishlist: $e');
      }
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, state.toList());
      if (kDebugMode) {
        print(
            '💾 Car wishlist saved to SharedPreferences: ${state.length} items');
        if (state.isNotEmpty) {
          print('   Items: ${state.join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving car wishlist: $e');
      }
    }
  }

  bool isInWishlist(String carId) => state.contains(carId);

  void toggleWishlist(String carId) {
    final wasInWishlist = state.contains(carId);
    state = state.contains(carId)
        ? state.where((id) => id != carId).toSet()
        : {...state, carId};

    if (kDebugMode) {
      print(
          '🔄 Car wishlist toggled: $carId ${wasInWishlist ? 'removed' : 'added'}');
      print('   Total items: ${state.length}');
    }

    _saveWishlist();
  }
}

final carWishlistProvider =
    StateNotifierProvider<CarWishlistNotifier, Set<String>>(
  (ref) => CarWishlistNotifier(),
);

final carWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(carWishlistProvider).length;
});
