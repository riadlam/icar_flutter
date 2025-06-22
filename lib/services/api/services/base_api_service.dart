import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../endpoints/api_endpoints.dart';

typedef JsonMap = Map<String, dynamic>;

class BaseApiService {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  
  BaseApiService({
    required http.Client client,
    required FlutterSecureStorage storage,
  })  : _client = client,
        _storage = storage;

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final headers = await getAuthHeaders();
      
      if (kDebugMode) {
        debugPrint('GET $uri');
        debugPrint('Headers: $headers');
      }
      
      final response = await _client.get(uri, headers: headers)
          .timeout(ApiEndpoints.receiveTimeout);
          
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GET request failed: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final headers = await getAuthHeaders();
      final encodedBody = body != null ? json.encode(body) : null;
      
      if (kDebugMode) {
        debugPrint('POST $uri');
        debugPrint('Headers: $headers');
        debugPrint('Body: $encodedBody');
      }
      
      final response = await _client.post(
        uri,
        headers: headers,
        body: encodedBody,
      ).timeout(ApiEndpoints.receiveTimeout);
          
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('POST request failed: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final headers = await getAuthHeaders();
      
      if (kDebugMode) {
        debugPrint('DELETE $uri');
        debugPrint('Headers: $headers');
      }
      
      final response = await _client.delete(
        uri,
        headers: headers,
      ).timeout(ApiEndpoints.receiveTimeout);
          
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('DELETE request failed: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final headers = await getAuthHeaders();
      final encodedBody = body != null ? json.encode(body) : null;
      
      if (kDebugMode) {
        debugPrint('PUT $uri');
        debugPrint('Headers: $headers');
        debugPrint('Body: $encodedBody');
      }
      
      final response = await _client.put(
        uri,
        headers: headers,
        body: encodedBody,
      ).timeout(ApiEndpoints.receiveTimeout);
          
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('PUT request failed: $e');
      }
      rethrow;
    }
  }


  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 404:
        throw NotFoundException('Not Found');
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while communicating with the server',
        );
    }
  }
}

// Custom Exceptions
class AppException implements Exception {
  final String? message;
  AppException([this.message]);

  @override
  String toString() => message ?? 'An error occurred';
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message);
}
