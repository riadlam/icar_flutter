import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/providers/car_service_provider.dart';
import 'package:flutter/foundation.dart';

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

/// Filter parameters for car search
class CarFilterParams {
  final String? brand;
  final String? type;
  final int? year;
  final String? transmission;
  final String? fuelType;
  final int? mileage;

  const CarFilterParams({
    this.brand,
    this.type,
    this.year,
    this.transmission,
    this.fuelType,
    this.mileage,
  });

  bool get hasFilters => 
      brand != null || 
      type != null || 
      year != null || 
      transmission != null || 
      fuelType != null || 
      mileage != null;

  CarFilterParams copyWith({
    String? brand,
    String? type,
    int? year,
    String? transmission,
    String? fuelType,
    int? mileage,
  }) {
    return CarFilterParams(
      brand: brand ?? this.brand,
      type: type ?? this.type,
      year: year ?? this.year,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'type': type,
      'year': year,
      'transmission': transmission,
      'fuel_type': fuelType, // Changed from 'fuelType' to 'fuel_type' to match API
      'mileage': mileage,
    };
  }
}

/// Provider for filtered cars
final filteredCarsProvider = FutureProvider.family<List<CarPost>, CarFilterParams>((ref, params) async {
  try {
    final carService = ref.watch(carServiceProvider);
    
    // Debug log the filter parameters
    debugPrint('Filtering cars with params: ${params.toMap()}');
    
    // If no filters are applied, return all cars
    if (!params.hasFilters) {
      debugPrint('No filters applied, returning all cars');
      return carService.getAllCars();
    }
    
    // Otherwise, apply filters
    debugPrint('Applying filters: ${params.toMap()}');
    final filteredCars = await carService.filterCars(
      brand: params.brand,
      type: params.type,
      year: params.year,
      transmission: params.transmission,
      fuelType: params.fuelType,
      mileage: params.mileage,
    );
    
    debugPrint('Found ${filteredCars.length} cars matching the filters');
    return filteredCars;
  } catch (e, stackTrace) {
    debugPrint('Error in filteredCarsProvider: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
});
