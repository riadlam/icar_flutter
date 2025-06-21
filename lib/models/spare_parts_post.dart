class SparePartsPost {
  final int id;
  final int userId;
  final String brand;
  final String model;
  final String sparePartsCategory;
  final String sparePartsSubcategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  SparePartsPost({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.sparePartsCategory,
    required this.sparePartsSubcategory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SparePartsPost.fromJson(Map<String, dynamic> json) {
    return SparePartsPost(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      sparePartsCategory: json['spare_parts_category'] as String,
      sparePartsSubcategory: json['spare_parts_subcategory'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
