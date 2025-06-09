import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';

class TowTruckService {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  
  TowTruckService({
    required http.Client client,
    required FlutterSecureStorage storage,
  })  : _client = client,
        _storage = storage;

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, dynamic>> createOrUpdateTowTruckProfile({
    required String businessName,
    required String driverName,
    required String mobile,
    required String city,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/api/tow-truck-profiles/create');
      
      final response = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'business_name': businessName,
          'driver_name': driverName,
          'mobile': mobile,
          'city': city,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create tow truck profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating tow truck profile: $e');
    }
  }
}
