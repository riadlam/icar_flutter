import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

// Provider for the selected category
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Provider for the posts data
final sparePartsPostsProvider = FutureProvider.autoDispose.family<List<SparePartsPost>, String?>(
  (ref, category) async {
    // This will automatically re-fetch when the category changes
    return _fetchSparePartsPosts(category);
  },
);

// Provider for the refresh functionality
final sparePartsRefreshProvider = Provider<SparePartsRefresh>((ref) {
  return SparePartsRefresh(ref);
});

class SparePartsRefresh {
  final Ref _ref;
  
  SparePartsRefresh(this._ref);
  
  Future<void> refresh() async {
    // Get the current category to maintain it during refresh
    final currentCategory = _ref.read(selectedCategoryProvider);
    
    // Invalidate the provider to trigger a refresh
    _ref.invalidate(sparePartsPostsProvider(currentCategory));
    
    // Force a new fetch and ensure the result is used
    final result = _ref.refresh(sparePartsPostsProvider(currentCategory).future);
    await result;
  }
}

// Helper function to get the current posts provider with the selected category
final currentSparePartsPostsProvider = Provider.autoDispose<AsyncValue<List<SparePartsPost>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  return ref.watch(sparePartsPostsProvider(selectedCategory));
});

Future<List<SparePartsPost>> _fetchSparePartsPosts(String? category) async {
  try {
    print('🔍 [DEBUG] Fetching posts with category filter: ${category ?? 'All categories'}');
    final response = await serviceLocator.sparePartsService.getMySparePartsPosts();
    
    if (category == null || category.isEmpty) {
      print('✅ [DEBUG] No category filter applied, returning all ${response.length} posts');
      return response;
    }
    
    print('🔎 [DEBUG] Filtering posts for category: $category');
    print('📋 [DEBUG] Available categories in response: ${response.map((p) => p.sparePartsCategory).toSet().toList()}');
    
    final filtered = response.where((post) {
      final matches = post.sparePartsCategory.toLowerCase() == category.toLowerCase();
      if (matches) {
        print('   ✅ [DEBUG] Match found - Post ID: ${post.id}, Category: ${post.sparePartsCategory}');
      }
      return matches;
    }).toList();
    
    print('📊 [DEBUG] Filter results: Found ${filtered.length} of ${response.length} posts match category \'$category\'');
    return filtered;
  } catch (e) {
    rethrow;
  }
}
