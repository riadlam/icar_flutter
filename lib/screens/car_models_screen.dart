import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/constants/filter_constants.dart';
import 'package:icar_instagram_ui/constants/brand_images.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';

class CarModelsScreen extends StatelessWidget {
  // Helper widget to show brand name when image is not available
  Widget _buildBrandNameFallback() {
    return Center(
      child: Text(
        brand,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
  final String brand;
  final String category;
  final String subcategory;

  const CarModelsScreen({
    Key? key,
    required this.brand,
    this.category = '',
    this.subcategory = '',
  }) : super(key: key);

  // Get brand image path from static map
  String? get _brandImagePath => BrandImages.getBrandImagePath(brand);

  // Helper method to get models case-insensitively
  List<String> _getModelsForBrand(String brandName) {
    debugPrint('Looking up models for brand: "$brandName"');
    
    // First try exact match
    if (brandModels.containsKey(brandName)) {
      debugPrint('Found exact match for brand: "$brandName"');
      return brandModels[brandName]!;
    }
    
    // If no exact match, try case-insensitive match
    final normalizedBrand = brandName.toLowerCase();
    debugPrint('No exact match, trying case-insensitive match for: "$normalizedBrand"');
    
    for (final entry in brandModels.entries) {
      if (entry.key.toLowerCase() == normalizedBrand) {
        debugPrint('Found case-insensitive match: "${entry.key}" -> ${entry.value.length} models');
        return entry.value;
      }
    }
    
    // Debug: Print available brand names for comparison
    debugPrint('No match found. Available brand names:');
    brandModels.keys.take(10).forEach((key) => debugPrint('  - $key'));
    if (brandModels.length > 10) {
      debugPrint('  ... and ${brandModels.length - 10} more');
    }
    
    debugPrint('Returning empty list for brand: "$brandName"');
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final models = _getModelsForBrand(brand);
    
    // Debug log to help diagnose issues
    debugPrint('Brand: $brand, Models found: ${models.length}');
    
    return Scaffold(
      appBar: AnimatedSearchAppBar(),
      body: Column(
        children: [
         
          // Models List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: models.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      models[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      context.push(
                        '/spare-parts-list',
                        extra: {
                          'brand': brand,
                          'model': models[index],
                          'category': category,
                          'subcategory': subcategory,
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
