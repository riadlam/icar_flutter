import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

// Provider for the posts data
final sparePartsPostsProvider = FutureProvider.autoDispose<List<SparePartsPost>>((ref) async {
  return _fetchSparePartsPosts();
});

// Provider for the refresh functionality
final sparePartsRefreshProvider = Provider<SparePartsRefresh>((ref) {
  return SparePartsRefresh(ref);
});

class SparePartsRefresh {
  final Ref _ref;
  
  SparePartsRefresh(this._ref);
  
  Future<void> refresh() async {
    // Invalidate the provider to trigger a refresh
    _ref.invalidate(sparePartsPostsProvider);
    
    // Force a new fetch and ignore the result since we're just refreshing
    await _ref.refresh(sparePartsPostsProvider.future).then((_) => null);
  }
}

Future<List<SparePartsPost>> _fetchSparePartsPosts() async {
  try {
    final response = await serviceLocator.sparePartsService.getMySparePartsPosts();
    return response;
  } catch (e) {
    rethrow;
  }
}
