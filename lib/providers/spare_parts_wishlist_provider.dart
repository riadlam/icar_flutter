import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/spare_parts_search_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SparePartsWishlistNotifier
    extends StateNotifier<Map<String, SparePartsProfile>> {
  SparePartsWishlistNotifier() : super({}) {
    _loadWishlist();
  }

  static const _prefsKey = 'spare_parts_wishlist';

  Future<void> _loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_prefsKey) ?? [];
      final Map<String, SparePartsProfile> loaded = {};

      if (kDebugMode) {
        print(
            '🔧 Spare parts wishlist loading from SharedPreferences: ${jsonList.length} items');
      }

      for (final jsonStr in jsonList) {
        try {
          final map = json.decode(jsonStr);
          final profile = SparePartsProfile.fromJson(map);
          final partId = '${profile.storeName}_${profile.mobile}';
          loaded[partId] = profile;

          if (kDebugMode) {
            print('   Loaded: $partId (${profile.storeName})');
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error parsing spare part profile: $e');
            print('   JSON string: $jsonStr');
          }
        }
      }
      state = loaded;

      if (kDebugMode) {
        print(
            '✅ Spare parts wishlist loaded successfully: ${loaded.length} items');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading spare parts wishlist: $e');
      }
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList =
          state.values.map((profile) => json.encode(profile.toJson())).toList();
      await prefs.setStringList(_prefsKey, jsonList);

      if (kDebugMode) {
        print(
            '💾 Spare parts wishlist saved to SharedPreferences: ${state.length} items');
        if (state.isNotEmpty) {
          print('   Items: ${state.keys.join(', ')}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving spare parts wishlist: $e');
      }
    }
  }

  bool isInWishlist(String partId) => state.containsKey(partId);

  void toggleWishlist(SparePartsProfile profile) {
    final partId = '${profile.storeName}_${profile.mobile}';
    final wasInWishlist = state.containsKey(partId);

    if (kDebugMode) {
      print('🔄 Spare parts wishlist toggled: $partId');
      print('   Store: ${profile.storeName}');
      print('   Mobile: ${profile.mobile}');
      print('   Action: ${wasInWishlist ? 'removing' : 'adding'}');
    }

    if (wasInWishlist) {
      final newState = Map<String, SparePartsProfile>.from(state)
        ..remove(partId);
      state = newState;
    } else {
      final newState = Map<String, SparePartsProfile>.from(state)
        ..[partId] = profile;
      state = newState;
    }

    if (kDebugMode) {
      print('   Total items after toggle: ${state.length}');
    }

    _saveWishlist();
  }

  List<SparePartsProfile> get wishlistedItems => state.values.toList();
}

final sparePartsWishlistProvider = StateNotifierProvider<
    SparePartsWishlistNotifier, Map<String, SparePartsProfile>>(
  (ref) => SparePartsWishlistNotifier(),
);

final sparePartsWishlistCountProvider = Provider<int>((ref) {
  return ref.watch(sparePartsWishlistProvider).length;
});

final sparePartsWishlistItemsProvider =
    Provider<List<SparePartsProfile>>((ref) {
  return ref.watch(sparePartsWishlistProvider.notifier).wishlistedItems;
});
