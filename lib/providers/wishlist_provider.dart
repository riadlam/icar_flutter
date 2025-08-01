import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class WishlistNotifier extends StateNotifier<List<GarageService>> {
  WishlistNotifier() : super([]) {
    _loadWishlist();
  }

  static const _prefsKey = 'garage_services_wishlist';

  Future<void> _loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_prefsKey) ?? [];

      if (kDebugMode) {
        print(
            '🔧 Garage services wishlist loading from SharedPreferences: ${jsonList.length} items');
      }

      final loaded = <GarageService>[];
      for (final jsonStr in jsonList) {
        try {
          final service = GarageService.fromJson(json.decode(jsonStr));
          loaded.add(service);

          if (kDebugMode) {
            print('   Loaded: ${service.businessName} (ID: ${service.id})');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error parsing garage service: $e');
            print('   JSON string: $jsonStr');
          }
        }
      }
      state = loaded;

      if (kDebugMode) {
        print(
            '✅ Garage services wishlist loaded successfully: ${loaded.length} items');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading garage services wishlist: $e');
      }
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList =
          state.map((service) => json.encode(service.toJson())).toList();
      await prefs.setStringList(_prefsKey, jsonList);

      if (kDebugMode) {
        print(
            '💾 Garage services wishlist saved to SharedPreferences: ${state.length} items');
        if (state.isNotEmpty) {
          print(
              '   Items: ${state.map((s) => '${s.businessName} (${s.id})').join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving garage services wishlist: $e');
      }
    }
  }

  bool isInWishlist(GarageService service) {
    return state.any((item) => item.id == service.id);
  }

  void toggleWishlist(GarageService service) {
    final wasInWishlist = isInWishlist(service);

    if (kDebugMode) {
      print(
          '🔄 Garage service wishlist toggled: ${service.businessName} (ID: ${service.id})');
      print('   Action: ${wasInWishlist ? 'removing' : 'adding'}');
    }

    if (wasInWishlist) {
      state = state.where((item) => item.id != service.id).toList();
    } else {
      state = [...state, service];
    }

    if (kDebugMode) {
      print('   Total items after toggle: ${state.length}');
    }

    _saveWishlist();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<GarageService>>(
  (ref) => WishlistNotifier(),
);

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});
