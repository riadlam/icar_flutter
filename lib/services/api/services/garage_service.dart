import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart';

class GarageService extends BaseApiService {
  final http.Client client;
  final FlutterSecureStorage storage;

  GarageService({
    required this.client,
    required this.storage,
  }) : super(client: client, storage: storage);

  Future<Map<String, dynamic>> createGarageProfile({
    required String businessName,
    required String mechanicName,
    required String mobile,
    required String city,
    required List<String> services,
  }) async {
    try {
      print('1. Reading auth token from storage...');
      final token = await storage.read(key: 'auth_token');
      
      if (token == null) {
        throw Exception('No authentication token found. Please log in again.');
      }
      
      print('2. Token found. Preparing request...');
      final url = Uri.parse('http://192.168.1.8:8000/api/garage-profiles/create-new');
      print('3. Request URL: $url');
      
      final requestBody = {
        'business_name': businessName,
        'mechanic_name': mechanicName,
        'mobile': mobile,
        'city': city,
        'services': services,
      };
      
      print('4. Request body: $requestBody');
      
      final response = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      
      print('5. Response status: ${response.statusCode}');
      print('6. Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('Error in createGarageProfile: $e');
      if (e is! FormatException) {
        print('Stack trace: ${e.toString()}');
      }
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create garage profile: ${response.statusCode}');
    }
  }
}
