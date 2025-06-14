import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';
import 'package:icar_instagram_ui/models/garage_profile.dart';

class GarageService extends BaseApiService {
  // Hardcoded list of available cities
  static const List<String> availableCities = [
    'City 1',
    'City 2',
    'City 3',
  ];

  // Hardcoded list of available services
  static const List<String> availableServices = [
    'Body Repair Technician',
    'Automotive Diagnostic',
    'Mechanic',
    'Tire Technician',
  ];
  
  final http.Client client;
  final FlutterSecureStorage storage;

  GarageService({
    required this.client,
    required this.storage,
  }) : super(client: client, storage: storage);

  Future<List<GarageProfile>> getGarageProfiles() async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Fetching garage profiles from API...');
      }
      
      final response = await get('/api/garage-profiles');
      
      if (kDebugMode) {
        debugPrint('✅ API Response received');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response data: $response');
      }
      
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          final List<dynamic> data = response['data'] is List ? response['data'] : [];
          
          if (kDebugMode) {
            debugPrint('📊 Found ${data.length} garage profiles');
            if (data.isNotEmpty) {
              debugPrint('First profile data: ${data.first}');
            }
          }
          
          try {
            final profiles = data.map<GarageProfile>((json) {
              if (json is Map<String, dynamic>) {
                return GarageProfile.fromJson(json);
              }
              throw const FormatException('Invalid profile data format');
            }).toList();
            
            if (kDebugMode) {
              debugPrint('✅ Successfully parsed ${profiles.length} garage profiles');
            }
            
            return profiles;
          } catch (e, stackTrace) {
            debugPrint('❌ Error parsing garage profiles: $e');
            debugPrint('Stack trace: $stackTrace');
            rethrow;
          }
        } else {
          final errorMsg = response['message']?.toString() ?? 'Unknown error';
          debugPrint('❌ API Error: $errorMsg');
          throw Exception('Failed to load garage profiles: $errorMsg');
        }
      } else {
        debugPrint('❌ Invalid response format: Expected Map<String, dynamic>');
        throw const FormatException('Invalid API response format');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in getGarageProfiles: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

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

  Future<Map<String, dynamic>> updateGarageProfile({
    required int id,
    required String businessName,
    required String mechanicName,
    required String mobile,
    required String city,
    required List<String> services,
  }) async {
    try {
      debugPrint('1. Reading auth token from storage...');
      final token = await storage.read(key: 'auth_token');
      
      if (token == null) {
        throw Exception('No authentication token found. Please log in again.');
      }
      
      debugPrint('2. Token found. Preparing update request...');
      final url = Uri.parse('http://192.168.1.8:8000/api/garage-profiles/$id');
      debugPrint('3. Update URL: $url');
      
      final requestBody = {
        'business_name': businessName,
        'mechanic_name': mechanicName,
        'mobile': mobile,
        'city': city,
        'services': services,
      };
      
      debugPrint('4. Request body: $requestBody');
      
      final response = await client.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      
      debugPrint('5. Response status: ${response.statusCode}');
      debugPrint('6. Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error in updateGarageProfile: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<GarageProfile>> getPublicGarageProfiles({
    String? city,
    String? service,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 [GarageService] Fetching public garage profiles from API...');
      }
      
      // Build query parameters
      final params = <String, String>{};
      if (city != null && city.isNotEmpty) {
        // Convert city to lowercase to match API expectations
        params['city'] = city.trim().toLowerCase();
      }
      if (service != null && service.isNotEmpty) {
        params['service'] = service.trim();
      }
      
      // Build the URL with query parameters using ApiEndpoints
      final endpoint = '${ApiEndpoints.baseUrl}/api/garage-profiles/all';
      final uri = Uri.parse(endpoint).replace(
        queryParameters: params.isNotEmpty ? params : null,
      );
      
      if (kDebugMode) {
        debugPrint('🌐 [GarageService] Request URL: $uri');
        debugPrint('🔧 [GarageService] Query parameters: $params');
        debugPrint('🔑 [GarageService] Using base URL: ${ApiEndpoints.baseUrl}');
      }
      
      // Add error handling for the request
      http.Response response;
      try {
        response = await client.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 30));
      } catch (e) {
        debugPrint('❌ [GarageService] Network error: $e');
        rethrow;
      }
      
      if (kDebugMode) {
        debugPrint('✅ [GarageService] API Response received');
        debugPrint('📊 [GarageService] Status code: ${response.statusCode}');
        debugPrint('📝 [GarageService] Response headers: ${response.headers}');
        debugPrint('📦 [GarageService] Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body) as Map<String, dynamic>;
          
          if (responseData['success'] == true) {
            final List<dynamic> data = responseData['data'] is List ? responseData['data'] : [];
            
            if (kDebugMode) {
              debugPrint('📊 [GarageService] Found ${data.length} public garage profiles');
            }
            
            try {
              final profiles = data.map<GarageProfile>((json) {
                if (json is Map<String, dynamic>) {
                  return GarageProfile.fromJson(json);
                }
                throw FormatException('Invalid profile data format: $json');
              }).toList();
              
              if (kDebugMode) {
                debugPrint('✅ [GarageService] Successfully parsed ${profiles.length} profiles');
              }
              
              return profiles;
            } catch (e, stackTrace) {
              debugPrint('❌ [GarageService] Error parsing profiles: $e');
              debugPrint('Stack trace: $stackTrace');
              debugPrint('Problematic data: $data');
              rethrow;
            }
          } else {
            final errorMsg = responseData['message']?.toString() ?? 'Unknown error';
            debugPrint('❌ [GarageService] API Error: $errorMsg');
            debugPrint('Response data: $responseData');
            throw Exception('Failed to load garage profiles: $errorMsg');
          }
        } catch (e, stackTrace) {
          debugPrint('❌ [GarageService] Error parsing response: $e');
          debugPrint('Response body: ${response.body}');
          debugPrint('Stack trace: $stackTrace');
          throw Exception('Failed to parse garage profiles response: $e');
        }
      } else {
        String errorBody = 'No response body';
        try {
          errorBody = response.body;
        } catch (e) {
          debugPrint('Failed to read error response body: $e');
        }
        
        debugPrint('❌ [GarageService] Server error: ${response.statusCode}');
        debugPrint('Error response: $errorBody');
        throw Exception('Server error: ${response.statusCode}\n$errorBody');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in getPublicGarageProfiles: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
