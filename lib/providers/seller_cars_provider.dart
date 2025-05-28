import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'car_service_provider.dart';

final sellerCarsProvider = FutureProvider.autoDispose<List<CarPost>>((ref) async {
  try {
    final carService = ref.watch(carServiceProvider);
    final cars = await carService.getUserCars();
    
    // Log image URLs for debugging
    for (var car in cars) {
      if (car.images.isNotEmpty) {
        print('Car ID: ${car.id} - Image URLs:');
        for (var url in car.images) {
          print('  - $url');
        }
      } else {
        print('Car ID: ${car.id} - No images available');
      }
    }
    
    return cars;
  } catch (e, stackTrace) {
    // Log error or handle it appropriately
    print('Error in sellerCarsProvider: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
});
