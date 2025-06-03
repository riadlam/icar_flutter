import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/providers/car_service_provider.dart'; // Assuming you have this
import 'package:flutter/foundation.dart';

/// Provider for searching cars.
/// It takes a search query string as a parameter.
final carSearchProvider = FutureProvider.autoDispose.family<List<CarPost>, String>((ref, query) async {
  // If the query is empty, return an empty list immediately without hitting the API.
  if (query.trim().isEmpty) {
    if (kDebugMode) {
      print('CarSearchProvider: Query is empty, returning empty list.');
    }
    return [];
  }

  try {
    final carService = ref.watch(carServiceProvider); // Depends on carServiceProvider
    if (kDebugMode) {
      print('CarSearchProvider: Searching for query "$query"');
    }
    final cars = await carService.searchCars(query);
    
    if (kDebugMode) {
      print('CarSearchProvider: Found ${cars.length} cars for query "$query"');
    }
    return cars;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error in carSearchProvider for query "$query": $e');
      print('Stack trace: $stackTrace');
    }
    // Propagate the error to be handled by the UI
    // You might want to return an empty list or a specific error state object
    // depending on how you want to handle errors in the UI.
    // For FutureProvider, rethrowing allows AsyncValue.error to be handled by widgets.
    rethrow; 
  }
});
