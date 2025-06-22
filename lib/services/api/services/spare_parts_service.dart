import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';
import 'package:icar_instagram_ui/models/spare_parts_search_params.dart';

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
    final response = await get('/api/spare-parts/my-posts');
    return (response['data'] as List).map((post) => SparePartsPost.fromJson(post)).toList();
  }

  /// Create a new spare parts post
  Future<void> createSparePartsPost({
    required String brand,
    required String model,
    required String spare_parts_category,
    required List<String> spare_parts_subcategories,
  }) async {
    final response = await post(
      '/api/spare-parts/posts',
      body: {
        'brand': brand,
        'model': model,
        'spare_parts_category': spare_parts_category,
        'spare_parts_subcategories': spare_parts_subcategories,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }
  }

  /// Search for spare parts profiles based on criteria
  Future<SparePartsSearchResponse> searchSparePartsProfiles({
    required String brand,
    required String model,
    required String category,
    required String subcategory,
  }) async {
    final response = await post(
      '${ApiEndpoints.apiPrefix}/spare-parts/search',
      body: {
        'brand': brand,
        'model': model,
        'spare_parts_category': category,
        'spare_parts_subcategory': subcategory,
      },
    );

    if (response is Map<String, dynamic>) {
      return SparePartsSearchResponse.fromJson(response);
    } else {
      throw Exception('Unexpected response format');
    }
  }

  /// Update a spare parts post
  /// 
  /// [postId] The ID of the post to update
  /// [brand] The updated brand
  /// [model] The updated model
  /// [sparePartsCategory] The updated category
  /// [sparePartsSubcategory] The updated subcategory
  /// Returns true if the update was successful
  Future<bool> updateSparePartsPost({
    required int postId,
    required String brand,
    required String model,
    required String sparePartsCategory,
    required String sparePartsSubcategory,
  }) async {
    try {
      print('Updating post with ID: $postId');
      final response = await put(
        '/api/spare-parts/posts/$postId',
        body: {
          'brand': brand,
          'model': model,
          'spare_parts_category': sparePartsCategory,
          'spare_parts_subcategory': sparePartsSubcategory,
        },
      );

      print('Update response: $response');
      
      // Check different possible success responses
      if (response is Map<String, dynamic>) {
        // Check for success message in the response
        final message = response['message']?.toString().toLowerCase() ?? '';
        if (message.contains('updated') && message.contains('success')) {
          return true;
        }
        
        // Check other possible success indicators
        return response['success'] == true || 
               response['updated'] == true ||
               response['status'] == 'success';
      }
      
      // If we get here, the response format wasn't as expected
      // but we'll still consider it a success if we didn't get an error
      return true;
    } catch (e, stackTrace) {
      print('Error in updateSparePartsPost: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Delete a spare parts post
  /// 
  /// [postId] The ID of the post to delete
  /// Returns true if the deletion was successful
  Future<bool> deleteSparePartsPost(int postId) async {
    try {
      print('Deleting post with ID: $postId');
      final response = await delete(
        '/api/spare-parts/posts/$postId',
      );

      print('Delete response: $response');
      
      // Check different possible success responses
      if (response is Map<String, dynamic>) {
        // Check for success message in the response
        final message = response['message']?.toString().toLowerCase() ?? '';
        if (message.contains('deleted') && message.contains('success')) {
          return true;
        }
        
        // Check other possible success indicators
        return response['success'] == true || 
               response['deleted'] == true ||
               response['status'] == 'success';
      }
      
      // If we get here, the response format wasn't as expected
      // but we'll still consider it a success if we didn't get an error
      return true;
    } catch (e, stackTrace) {
      print('Error in deleteSparePartsPost: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
