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
  final DateTime? createdAt;
  final bool isFavorite;
  final bool isWishlisted;
  final bool enabled;
  final DateTime? updatedAt;
  
  // Computed properties
  String get name => '$brand $model'.trim();
  bool get isForSale => type.toLowerCase() == 'sale';
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
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
    this.createdAt,
    this.isFavorite = false,
    this.isWishlisted = false,
    this.enabled = true,
    this.updatedAt,
  });

  factory CarPost.fromJson(Map<String, dynamic> json) {
    return CarPost(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString().toLowerCase() ?? 'sale',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      price: (json['price'] is int ? json['price'].toDouble() : json['price'] as double?) ?? 0.0,
      mileage: (json['mileage'] as int?) ?? 0,
      year: (json['year'] as int?) ?? DateTime.now().year,
      transmission: (json['transmission'] as String?)?.toLowerCase() ?? 'automatic',
      fuel: (json['fuel'] as String?)?.toLowerCase() ?? 'gasoline',
      description: json['description']?.toString() ?? '',
      imageUrls: List<String>.from((json['images'] as List<dynamic>?)?.map((e) => e.toString()) ?? []),
      sellerId: json['user_id']?.toString(),
      sellerName: json['full_name']?.toString() ?? 'Seller ${json['user_id']?.toString() ?? ''}',
      sellerPhone: null, // Not provided in the API response
      fullName: json['full_name']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
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