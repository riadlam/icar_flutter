import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/providers/car_service_provider.dart';

/// Provider for fetching all cars from the public endpoint
final allCarsProvider = FutureProvider.autoDispose<List<CarPost>>((ref) async {
  try {
    final carService = ref.watch(carServiceProvider);
    final cars = await carService.getAllCars();
    
    // Log the number of cars fetched for debugging
    if (cars.isNotEmpty) {
      print('Fetched ${cars.length} cars from public endpoint');
    } else {
      print('No cars found in public endpoint');
    }
    
    return cars;
  } catch (e, stackTrace) {
    print('Error in allCarsProvider: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
