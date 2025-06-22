class SparePartsSearchParams {
  final String brand;
  final String model;
  final String sparePartsCategory;
  final String sparePartsSubcategory;
  final String city;

  SparePartsSearchParams({
    required this.brand,
    required this.model,
    required this.sparePartsCategory,
    required this.sparePartsSubcategory,
    this.city = '',
  });

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
        'spare_parts_category': sparePartsCategory,
        'spare_parts_subcategory': sparePartsSubcategory,
        'city': city,
      };
}

class SparePartsProfile {
  final String storeName;
  final String mobile;
  final String city;
  final int userId;

  SparePartsProfile({
    required this.storeName,
    required this.mobile,
    required this.city,
    required this.userId,
  });

  factory SparePartsProfile.fromJson(Map<String, dynamic> json) {
    return SparePartsProfile(
      storeName: json['store_name'] ?? '',
      mobile: json['mobile'] ?? '',
      city: json['city'] ?? '',
      userId: json['user_id'] ?? 0,
    );
  }
}

class SparePartsSearchResponse {
  final String message;
  final List<SparePartsProfile> profiles;

  SparePartsSearchResponse({
    required this.message,
    required this.profiles,
  });

  factory SparePartsSearchResponse.fromJson(Map<String, dynamic> json) {
    return SparePartsSearchResponse(
      message: json['message'] ?? '',
      profiles: (json['data'] as List?)
              ?.map((e) => SparePartsProfile.fromJson(e))
              .toList() ??
          [],
    );
  }
}
