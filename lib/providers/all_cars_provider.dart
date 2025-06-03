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
  final String? model;
  final String? type;
  final int? year;
  final String? transmission;
  final String? fuelType;
  final int? mileage;
  final double? priceMin;
  final double? priceMax;

  const CarFilterParams({
    this.brand,
    this.model,
    this.type,
    this.year,
    this.transmission,
    this.fuelType,
    this.mileage,
    this.priceMin,
    this.priceMax,
  });

  bool get hasFilters {
    final hasFilters = brand != null ||
        model != null ||
        type != null ||
        year != null ||
        transmission != null ||
        fuelType != null ||
        mileage != null ||
        priceMin != null ||
        priceMax != null;
        
    print('🔍 hasFilters: $hasFilters');
    if (hasFilters) {
      print('   - brand: $brand');
      print('   - model: $model');
      print('   - type: $type');
      print('   - year: $year');
      print('   - transmission: $transmission');
      print('   - fuelType: $fuelType');
      print('   - mileage: $mileage');
      print('   - priceMin: $priceMin');
      print('   - priceMax: $priceMax');
    }
    
    return hasFilters;
  }

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
    final map = <String, dynamic>{};
    
    if (brand != null) {
      map['brand'] = brand;
      print('📝 toMap() - Added brand: $brand');
    }
    
    if (model != null) {
      map['model'] = model;
      print('📝 toMap() - Added model: $model');
    } else {
      print('📝 toMap() - No model to add');
    }
    
    if (type != null) {
      map['type'] = type;
      print('📝 toMap() - Added type: $type');
    }
    
    if (year != null) {
      map['year'] = year;
      print('📝 toMap() - Added year: $year');
    }
    
    if (transmission != null) {
      map['transmission'] = transmission;
      print('📝 toMap() - Added transmission: $transmission');
    }
    
    if (fuelType != null) {
      map['fuel_type'] = fuelType;
      print('📝 toMap() - Added fuelType: $fuelType');
    }
    
    if (mileage != null) {
      map['mileage'] = mileage;
      print('📝 toMap() - Added mileage: $mileage');
    }
    
    if (priceMin != null) {
      map['price_min'] = priceMin;
      print('📝 toMap() - Added priceMin: $priceMin');
    }
    
    if (priceMax != null) {
      map['price_max'] = priceMax;
      print('📝 toMap() - Added priceMax: $priceMax');
    }
    
    print('📋 Final toMap() result: $map');
    return map;
  }
}

/// Provider for filtered cars
final filteredCarsProvider = FutureProvider.family<List<CarPost>, CarFilterParams>((ref, params) async {
  try {
    final carService = ref.watch(carServiceProvider);
    
    // Debug log the filter parameters
    print('\n🔍 filteredCarsProvider called with params:');
    print('  - brand: ${params.brand}');
    print('  - model: ${params.model}');
    print('  - type: ${params.type}');
    print('  - year: ${params.year}');
    print('  - transmission: ${params.transmission}');
    print('  - fuelType: ${params.fuelType}');
    print('  - mileage: ${params.mileage}');
    print('  - priceMin: ${params.priceMin}');
    print('  - priceMax: ${params.priceMax}');
    
    final paramsMap = params.toMap();
    print('📋 Converted to map: $paramsMap');
    
    // If no filters are applied, return all cars
    if (!params.hasFilters) {
      print('ℹ️ No filters applied, returning all cars');
      return carService.getAllCars();
    }
    
    // Otherwise, apply filters
    print('\n🎯 Calling filterCars with:');
    print('  - brand: ${params.brand}');
    print('  - model: ${params.model}');
    print('  - type: ${params.type}');
    print('  - year: ${params.year}');
    print('  - transmission: ${params.transmission}');
    print('  - fuelType: ${params.fuelType}');
    print('  - mileage: ${params.mileage}');
    print('  - priceMin: ${params.priceMin}');
    print('  - priceMax: ${params.priceMax}');
    
    final filteredCars = await carService.filterCars(
      brand: params.brand,
      model: params.model,
      type: params.type,
      year: params.year,
      transmission: params.transmission,
      fuelType: params.fuelType,
      mileage: params.mileage,
      priceMin: params.priceMin,
      priceMax: params.priceMax,
    );
    
    print('✅ filterCars returned ${filteredCars.length} cars');
    
    if (kDebugMode) {
      print('🔎 Applied filters to find cars:');
      print('   - Brand: ${params.brand}');
      print('   - Model: ${params.model}');
      print('   - Type: ${params.type}');
      print('   - Year: ${params.year}');
      print('   - Transmission: ${params.transmission}');
      print('   - Fuel Type: ${params.fuelType}');
      print('   - Mileage: ${params.mileage}');
      print('   - Price Range: ${params.priceMin} - ${params.priceMax}');
      print('   - Found ${filteredCars.length} cars');
    }
    
    debugPrint('Found ${filteredCars.length} cars matching the filters');
    return filteredCars;
  } catch (e, stackTrace) {
    debugPrint('Error in filteredCarsProvider: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
});
