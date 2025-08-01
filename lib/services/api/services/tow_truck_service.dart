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
      throw Exception('Error creating tow truck profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateTowTruckProfile({
    required String id,
    String? businessName,
    String? driverName,
    String? mobile,
    String? city,
  }) async {
    try {
      print('Updating tow truck profile with ID: $id');
      final headers = await _getAuthHeaders();
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/api/tow-truck-profiles/$id');
      
      final Map<String, dynamic> body = {};
      if (businessName != null) body['business_name'] = businessName;
      if (driverName != null) body['driver_name'] = driverName;
      if (mobile != null) body['mobile'] = mobile;
      if (city != null) body['city'] = city;
      
      print('Request body: $body');
      print('Headers: $headers');
      
      final response = await _client.put(
        uri,
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Update successful: $responseData');
        return responseData;
      } else {
        final error = 'Failed to update tow truck profile: ${response.statusCode} - ${response.body}';
        print(error);
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Error updating tow truck profile: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getTowTruckProfiles() async {
    try {
      final headers = await _getAuthHeaders();
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/api/tow-truck-profiles');
      
      final response = await _client.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch tow truck profiles');
        }
      } else {
        throw Exception('Failed to fetch tow truck profiles: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching tow truck profiles: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTowTruckProfiles({String? city}) async {
    try {
      final headers = await _getAuthHeaders();
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/api/tow-truck-profiles/all')
          .replace(queryParameters: city != null ? {'city': city} : null);
      
      final response = await _client.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch all tow truck profiles');
        }
      } else {
        throw Exception('Failed to fetch all tow truck profiles: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching all tow truck profiles: $e');
    }
  }

  Future<Map<String, dynamic>> deleteTowTruckProfile(String id) async {
    try {
      print('Deleting tow truck profile with ID: $id');
      
      // First verify we have a valid auth token
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        throw Exception('Authentication required. Please log in again.');
      }
      
      final headers = await _getAuthHeaders();
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/api/tow-truck-profiles/$id');
      
      print('DELETE Request to: $uri');
      print('Headers: $headers');
      
      final response = await _client.delete(
        uri,
        headers: headers,
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        print('Delete successful: $responseData');
        return responseData;
      } else if (response.statusCode == 403) {
        // Handle 403 Forbidden specifically
        final message = responseData['message'] ?? 'You do not have permission to delete this profile';
        throw Exception(message);
      } else if (response.statusCode == 401) {
        // Handle 401 Unauthorized
        throw Exception('Session expired. Please log in again.');
      } else {
        final error = responseData['message'] ?? 'Failed to delete profile';
        throw Exception(error);
      }
    } on FormatException {
      throw Exception('Invalid response from server');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // For any other type of error
      throw Exception('Failed to delete profile: ${e.toString()}');
    }
  }
}
