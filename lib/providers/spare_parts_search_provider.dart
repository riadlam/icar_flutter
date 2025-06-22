import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/spare_parts_search_params.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';

// State notifier for managing spare parts search state
class SparePartsSearchNotifier extends StateNotifier<AsyncValue<SparePartsSearchResponse>> {
  SparePartsSearchNotifier() : super(const AsyncValue.loading());

  // Method to update the state directly
  void update(AsyncValue<SparePartsSearchResponse> Function(AsyncValue<SparePartsSearchResponse>) fn) {
    state = fn(state);
  }

  // Method to perform search
  Future<void> search({
    required String brand,
    required String model,
    required String category,
    required String subcategory,
    String city = '',
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await serviceLocator.sparePartsService.searchSparePartsProfiles(
        brand: brand,
        model: model,
        category: category,
        subcategory: subcategory,
        city: city,
      );
      state = AsyncValue.data(response);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  void reset() {
    state = const AsyncValue.loading();
  }
}

// Provider for the search notifier
final sparePartsSearchProvider = StateNotifierProvider.autoDispose<SparePartsSearchNotifier, AsyncValue<SparePartsSearchResponse>>(
  (ref) => SparePartsSearchNotifier(),
);

// Provider for search parameters
final sparePartsSearchParamsProvider = StateProvider.autoDispose<SparePartsSearchParams?>((ref) => null);
