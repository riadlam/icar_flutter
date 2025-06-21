import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';

class SparePart {
  final int id;
  final String name;
  final String price;
  final String condition;
  final String location;
  final String? imageUrl;
  final String? sellerName;
  final String? description;

  SparePart({
    required this.id,
    required this.name,
    required this.price,
    required this.condition,
    required this.location,
    this.imageUrl,
    this.sellerName,
    this.description,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'].toString(),
      condition: json['condition'] as String? ?? 'Used',
      location: json['location'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String?,
      sellerName: json['seller_name'] as String?,
      description: json['description'] as String?,
    );
  }
}

class SparePartsProfile {
  final int id;
  final int userId;
  final String storeName;
  final String mobile;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SparePart>? parts;

  SparePartsProfile({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.mobile,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    this.parts,
  });

  factory SparePartsProfile.fromJson(Map<String, dynamic> json) {
    return SparePartsProfile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      storeName: json['store_name'] as String,
      mobile: json['mobile'] as String? ?? '',
      city: json['city'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      parts: json['parts'] != null
          ? (json['parts'] as List)
              .map((part) => SparePart.fromJson(part as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class SparePartsService extends BaseApiService {
  SparePartsService({
    required http.Client client,
    required FlutterSecureStorage storage,
  }) : super(client: client, storage: storage);

  /// Get the spare parts profile for the current user
  Future<SparePartsProfile> getSparePartsProfile() async {
    try {
      final response = await get('/api/spare-parts/my-profile');
      return SparePartsProfile.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Get spare parts by seller ID
  Future<List<SparePart>> getSparePartsBySeller(int sellerId) async {
    try {
      final response = await get('/api/spare-parts/seller/$sellerId');
      final List<dynamic> partsData = response['data'] as List<dynamic>;
      return partsData
          .map((part) => SparePart.fromJson(part as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Search for spare parts
  Future<List<SparePart>> searchSpareParts(String query) async {
    try {
      final response = await get('/api/spare-parts/search?q=$query');
      final List<dynamic> partsData = response['data'] as List<dynamic>;
      return partsData
          .map((part) => SparePart.fromJson(part as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user's spare parts posts
  Future<List<SparePartsPost>> getMySparePartsPosts() async {
    try {
      final response = await get('/api/spare-parts/my-posts');
      final List<dynamic> postsData = response['data'] as List<dynamic>;
      return postsData
          .map((post) => SparePartsPost.fromJson(post as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
