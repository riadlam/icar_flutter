import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoriteSellerService {
  final String baseUrl = 'http://app.icaralgerie.com/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Check if a seller is in favorites
  Future<bool> isFavoriteSeller(int sellerId) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('$baseUrl/favorite-sellers/check'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': sellerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_favorite'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<Map<String, dynamic>> toggleFavorite(int sellerId) async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.post(
        Uri.parse('$baseUrl/favorite-sellers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': sellerId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to update favorite status');
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
}
