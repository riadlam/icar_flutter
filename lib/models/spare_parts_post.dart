import 'package:flutter/foundation.dart';

class SparePartsPost {
  final int id;
  final int userId;
  final String brand;
  final String model;
  final String sparePartsCategory;
  final String sparePartsSubcategory;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  SparePartsPost({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.sparePartsCategory,
    required this.sparePartsSubcategory,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SparePartsPost.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('Parsing SparePartsPost from JSON: $json');
      print('is_available type: ${json['is_available']?.runtimeType}');
      print('is_available value: ${json['is_available']}');
    }
    
    // Handle is_available field more robustly
    bool isAvailable = true; // Default to true if not specified
    if (json['is_available'] != null) {
      if (json['is_available'] is bool) {
        isAvailable = json['is_available'] as bool;
      } else if (json['is_available'] is int) {
        isAvailable = json['is_available'] == 1;
      } else if (json['is_available'] is String) {
        isAvailable = json['is_available'] == '1' || 
                     json['is_available'].toLowerCase() == 'true';
      }
    }
    
    if (kDebugMode) {
      print('Parsed isAvailable: $isAvailable');
    }
    
    return SparePartsPost(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] as int,
      userId: json['user_id'] is String ? int.tryParse(json['user_id']) ?? 0 : json['user_id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      sparePartsCategory: json['spare_parts_category'] as String,
      sparePartsSubcategory: json['spare_parts_subcategory'] as String,
      isAvailable: isAvailable,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
