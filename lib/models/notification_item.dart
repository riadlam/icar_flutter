class NotificationCarData {
  final String? type;
  final String? brand;
  final String? model;
  final num? price; // Can be int or double
  final num? mileage; // Can be int or double
  final int? year;
  final String? transmission;
  final String? fuel;
  final String? description;
  final List<String>? images;
  final int? userId; // Seller ID
  final String? updatedAt;
  final String? createdAt;
  final int id; // Car ID
  final String? fullName; // Seller's full name
  final String? mobile; // Seller's phone number
  final String? city; // Seller's city

  NotificationCarData({
    this.type,
    this.brand,
    this.model,
    this.price,
    this.mileage,
    this.year,
    this.transmission,
    this.fuel,
    this.description,
    this.images,
    this.userId,
    this.updatedAt,
    this.createdAt,
    required this.id,
    this.fullName,
    this.mobile,
    this.city,
  });

  factory NotificationCarData.fromJson(Map<String, dynamic> json) {
    return NotificationCarData(
      type: json['type'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      price: json['price'] as num?,
      mileage: json['mileage'] as num?,
      year: json['year'] as int?,
      transmission: json['transmission'] as String?,
      fuel: json['fuel'] as String?,
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      userId: json['user_id'] as int?,
      updatedAt: json['updated_at'] as String?,
      createdAt: json['created_at'] as String?,
      id: json['id'] as int,
      fullName: json['full_name'] as String?,
      mobile: json['mobile'] as String?,
      city: json['city'] as String?,
    );
  }
}

class NotificationItem {
  final int id;
  final int? userId;
  final String message;
  final NotificationCarData carData;
  final String? readAt;
  final String createdAt;
  final String updatedAt;

  NotificationItem({
    required this.id,
    this.userId,
    required this.message,
    required this.carData,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      message: json['message'] as String,
      carData: NotificationCarData.fromJson(json['data'] as Map<String, dynamic>),
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
