import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';

class CarProfileService {
  final String baseUrl = ApiEndpoints.baseUrl;
  final http.Client client;
  final FlutterSecureStorage _storage;
  final _logger = Logger('CarProfileService');
  bool _isInitialized = false;
  static const String _tokenKey = 'auth_token';

  CarProfileService({
    required this.client,
    required FlutterSecureStorage storage,
  }) : _storage = storage;
  
  // Initialize the service
  Future<void> initialize() async {
    if (!_isInitialized) {
      _logger.info('Initializing CarProfileService');
      _isInitialized = true;
    }
  }

  Future<String?> _getAuthToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      _logger.severe('Error reading auth token', e);
      return null;
    }
  }

  /// Fetches additional phone numbers for a user
  /// Returns a list of phone numbers with their IDs
  Future<Map<String, dynamic>> getUserAdditionalPhones(String userId) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      _logger.info('Fetching additional phone numbers for user: $userId');
      
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await client.get(
        Uri.parse('$baseUrl/api/users/$userId/additional-phones'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      final responseBody = utf8.decode(response.bodyBytes);
      _logger.fine('Response status: ${response.statusCode}');
      _logger.fine('Response body: $responseBody');
      
      final responseData = jsonDecode(responseBody);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to fetch phone numbers';
        _logger.warning('Failed to fetch phone numbers: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
          'data': null,
        };
      }
    } catch (e, stackTrace) {
      _logger.severe('Error fetching phone numbers', e, stackTrace);
      throw Exception('Failed to fetch phone numbers: $e');
    }
  }

  /// Adds an additional phone number to the user's profile.
  /// The phone number is sent as a string with the key 'phone_number'.
  Future<Map<String, dynamic>> addPhoneNumber(String phoneNumber) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      _logger.info('Adding additional phone number: $phoneNumber');
      
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Get current user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Create the request body as per the new API
      final requestBody = {
        'phone_number': phoneNumber.toString()
      };
      
      final requestBodyJson = jsonEncode(requestBody);
      _logger.fine('Sending request with body: $requestBodyJson');

      // Use the new API endpoint for additional phone numbers with the current user's ID
      final response = await client.post(
        Uri.parse('$baseUrl/api/users/$userId/additional-phones'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBodyJson,
      );
      
      final responseBody = utf8.decode(response.bodyBytes);
      _logger.fine('Response status: ${response.statusCode}');
      _logger.fine('Response body: $responseBody');
      
      final responseData = jsonDecode(responseBody);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Phone number added successfully',
          'data': responseData['data'],
        };
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to add phone number';
        _logger.warning('Failed to add phone number: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
          'data': responseData,
        };
      }
    } catch (e, stackTrace) {
      _logger.severe('Error adding phone number', e, stackTrace);
      throw Exception('Failed to add phone number: $e');
    }
  }

  /// Deletes an additional phone number from the user's profile.
  /// Requires the phone number ID to be deleted.
  Future<Map<String, dynamic>> deletePhoneNumber(String phoneId) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      _logger.info('Deleting phone number with ID: $phoneId');
      
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Get current user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId == null) {
        throw Exception('No user ID found in shared preferences');
      }

      _logger.fine('Deleting phone number for user ID: $userId');
      
      final response = await client.delete(
        Uri.parse('$baseUrl/api/users/$userId/additional-phones/$phoneId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      final responseBody = utf8.decode(response.bodyBytes);
      _logger.fine('Response status: ${response.statusCode}');
      _logger.fine('Response headers: ${response.headers}');
      _logger.fine('Response body: $responseBody');
      
      final responseData = jsonDecode(responseBody);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Phone number deleted successfully',
          'data': responseData['data'],
        };
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to delete phone number';
        _logger.warning('Failed to delete phone number: $errorMessage');
        return {
          'success': false,
          'message': errorMessage,
          'data': responseData,
        };
      }
    } catch (e, stackTrace) {
      _logger.severe('Error deleting phone number', e, stackTrace);
      throw Exception('Failed to delete phone number: $e');
    }
  }

  // Add other car profile related methods here as needed
}
