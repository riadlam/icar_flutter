import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../models/favorite_seller.dart';

class FavoriteSellerListService {
  final String baseUrl = 'http://app.icaralgerie.com/api';
  final _storage = const FlutterSecureStorage();

  Future<List<FavoriteSeller>> getFavoriteSellers() async {
    final token = await _storage.read(key: 'auth_token');
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/favorite-sellers'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        final List<dynamic> sellers = data['data'];
        return sellers.map((json) => FavoriteSeller.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite sellers');
      }
    } else {
      throw Exception('Failed to load favorite sellers: ${response.statusCode}');
    }
  }
}
