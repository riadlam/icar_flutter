import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/providers/car_service_provider.dart';

final carDetailProvider = FutureProvider.autoDispose.family<CarPost, int>((ref, carId) async {
  final carService = ref.watch(carServiceProvider);
  return carService.getCarById(carId);
});
