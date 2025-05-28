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
    this.createdAt,
    this.isFavorite = false,
    this.isWishlisted = false,
    this.enabled = true,
    this.updatedAt,
  });

  factory CarPost.fromJson(Map<String, dynamic> json) {
    return CarPost(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'sale',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      mileage: json['mileage'] ?? 0,
      year: json['year'] ?? DateTime.now().year,
      transmission: json['transmission'] ?? 'Automatic',
      fuel: json['fuel'] ?? 'Gasoline',
      description: json['description'] ?? '',
      imageUrls: List<String>.from(json['images'] ?? []),
      sellerId: json['seller_id']?.toString(),
      sellerName: json['seller_name']?.toString() ?? 'Unknown Seller',
      sellerPhone: json['seller_phone']?.toString(),
      createdAt: json['created_at'] != null 
          ? json['created_at'] is DateTime 
              ? json['created_at'] as DateTime
              : DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : null,
      isFavorite: json['is_favorite'] ?? false,
      isWishlisted: json['is_wishlisted'] ?? false,
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