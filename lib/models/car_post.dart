import 'package:flutter/foundation.dart';

extension StringCasingExtension on String {
  String toTitleCase() {
    if (length <= 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class CarPost {
  final String id;
  final String type; // 'sale' or 'rent'
  final String brand;
  final String model;
  final double price;
  final int mileage;
  final int year;
  final String transmission;
  final String fuel;
  final String description;
  final List<String> imageUrls;

  // For backward compatibility with existing code
  List<String> get images => imageUrls;
  final String? sellerId;
  final String? sellerName;
  final String? sellerPhone;
  final String? fullName;
  final String? city;
  final DateTime? createdAt;
  final bool isFavorite;
  final bool isWishlisted;
  final bool enabled;
  final DateTime? updatedAt;

  // Computed properties
  String get name => '$brand $model'.trim();
  bool get isForSale => type.toLowerCase() == 'sale';
  String get formattedPrice => 'DZD${price.toStringAsFixed(2)}';
  String get formattedMileage => '${mileage.toStringAsFixed(0)} km';
  String get formattedYear => year.toString();
  String get transmissionType => transmission.toTitleCase();

  CarPost({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.price,
    required this.mileage,
    required this.year,
    required this.transmission,
    required this.fuel,
    required this.description,
    required this.imageUrls,
    this.sellerId,
    this.sellerName,
    this.sellerPhone,
    this.fullName,
    this.city,
    this.createdAt,
    this.isFavorite = false,
    this.isWishlisted = false,
    this.enabled = true,
    this.updatedAt,
  });

  factory CarPost.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      
      try {
        // Try parsing the date string directly
        final parsed = DateTime.tryParse(date.toString());
        if (parsed != null) return parsed;
        
        // If direct parsing fails, try to handle potential formats
        final dateStr = date.toString();
        if (dateStr.contains('T')) {
          // Handle ISO 8601 format with T separator
          return DateTime.parse(dateStr);
        } else {
          // Handle other formats if needed
          final parts = dateStr.split(' ');
          if (parts.length >= 2) {
            return DateTime.parse('${parts[0]}T${parts[1]}Z');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing date $date: $e');
        }
      }
      
      return null;
    }
    
    if (kDebugMode) {
      print('Parsing CarPost from JSON:');
      print('  created_at: ${json['created_at']} (${json['created_at']?.runtimeType})');
      if (json['created_at'] != null) {
        final parsedDate = parseDate(json['created_at']);
        print('  Parsed date: $parsedDate');
      }
    }
    
    return CarPost(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString().toLowerCase() ?? 'sale',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      price: (json['price'] is int
              ? json['price'].toDouble()
              : json['price'] as double?) ??
          0.0,
      mileage: (json['mileage'] as int?) ?? 0,
      year: (json['year'] as int?) ?? DateTime.now().year,
      transmission:
          (json['transmission'] as String?)?.toLowerCase() ?? 'automatic',
      fuel: (json['fuel'] as String?)?.toLowerCase() ?? 'gasoline',
      description: json['description']?.toString() ?? '',
      imageUrls: List<String>.from(
          (json['images'] as List<dynamic>?)?.map((e) => e.toString()) ?? []),
      sellerId: json['user_id']?.toString(),
      sellerName: json['full_name']?.toString() ??
          'Seller ${json['user_id']?.toString() ?? ''}',
      sellerPhone: json['mobile']?.toString(),
      fullName: json['full_name']?.toString(),
      city: json['city']?.toString(),
      createdAt: json['created_at'] != null
          ? parseDate(json['created_at']) ?? DateTime.now()
          : null,
      updatedAt: json['updated_at'] != null
          ? parseDate(json['updated_at'])
          : null,
      isFavorite: false, // Not provided in the API response
      isWishlisted: false, // Not provided in the API response
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'price': price,
      'mileage': mileage,
      'year': year,
      'transmission': transmission,
      'fuel': fuel,
      'description': description,
      'images': imageUrls,
      'seller_id': sellerId,
      'full_name': fullName,
      'mobile': sellerPhone,
      'city': city,
      'created_at': createdAt?.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  CarPost copyWith({
    String? id,
    String? type,
    String? brand,
    String? model,
    double? price,
    int? mileage,
    int? year,
    String? transmission,
    String? fuel,
    String? description,
    List<String>? imageUrls,
    String? sellerId,
    DateTime? createdAt,
    bool? isFavorite,
    bool? isWishlisted,
    bool? enabled,
    DateTime? updatedAt,
  }) {
    return CarPost(
      id: id ?? this.id,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      price: price ?? this.price,
      mileage: mileage ?? this.mileage,
      year: year ?? this.year,
      transmission: transmission ?? this.transmission,
      fuel: fuel ?? this.fuel,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerId: sellerId ?? this.sellerId,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
