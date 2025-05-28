import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../endpoints/api_endpoints.dart';
import 'base_api_service.dart';
import 'package:icar_instagram_ui/models/car_post.dart';

class CarService extends BaseApiService {
  final FlutterSecureStorage _storage;
  final http.Client _httpClient;
  
  CarService({
    required http.Client client,
    required FlutterSecureStorage storage,
  }) : _storage = storage,
       _httpClient = client,
       super(client: client, storage: storage);

  /// Creates a new car listing
  /// 
  /// [type] - Type of listing ('sale' or 'rent')
  /// [brand] - Car brand
  /// [model] - Car model
  /// [price] - Price of the car
  /// [mileage] - Mileage of the car
  /// [year] - Manufacturing year
  /// [transmission] - Transmission type
  /// [fuel] - Fuel type
  /// [description] - Car description
  /// [images] - List of image files to upload
  /// Returns a Future that completes with the server response
  /// Creates a new car listing
  Future<Map<String, dynamic>> createCar({
    required String type,
    required String brand,
    required String model,
    required double price,
    required int mileage,
    required int year,
    required String transmission,
    required String fuel,
    required String description,
    required List<File> images,
  }) async {
    try {
      if (kDebugMode) {
        print('Preparing to create car listing...');
      }
      
      // Create multipart request
      final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cars}');
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers['Accept'] = 'application/json';
      
      // Add authorization header
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add text fields
      request.fields.addAll({
        'type': type,
        'brand': brand,
        'model': model,
        'price': price.toString(),
        'mileage': mileage.toString(),
        'year': year.toString(),
        'transmission': transmission,
        'fuel': fuel,
        'description': description,
      });

      // Add image files with 'images[]' format for Laravel array handling
      for (var i = 0; i < images.length; i++) {
        final file = images[i];
        final fileExtension = file.path.split('.').last.toLowerCase();
        final mimeType = fileExtension == 'png' 
            ? 'image/png' 
            : fileExtension == 'jpg' || fileExtension == 'jpeg'
                ? 'image/jpeg'
                : 'image/*';
                
        final multipartFile = await http.MultipartFile.fromPath(
          'images[]',  // Note the brackets [] to match Laravel's array format
          file.path,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      }

      if (kDebugMode) {
        print('Sending car creation request with ${images.length} images');
      }

      // Send the request using the http client
      final streamedResponse = await _httpClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (kDebugMode) {
          print('Car created successfully: $responseData');
        }
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create car: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating car: $e');
      }
      rethrow;
    }
  }

  /// Fetches the list of cars listed by the currently authenticated seller
  Future<List<Map<String, dynamic>>> getSellerCars() async {
    try {
      if (kDebugMode) {
        print('Fetching seller cars...');
      }
      
      final response = await get('${ApiEndpoints.cars}/me');
      
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else if (response is Map<String, dynamic>) {
        // Handle case where the API returns a single car object
        return [response];
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching seller cars: $e');
      }
      rethrow;
    }
  }

  /// Fetches all cars listed by the authenticated user
  Future<List<CarPost>> getUserCars() async {
    try {
      // Get the auth token from secure storage
      final token = await _storage.read(key: 'auth_token');
      
      // Make the request using the class's http client
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.userCars}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map && responseData.containsKey('data')) {
          final List<dynamic> carsData = responseData['data'];
          return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else if (responseData is List) {
          // Handle case where the API returns a direct array
          return responseData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to load user cars: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in getUserCars: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in getUserCars: $e');
      }
      rethrow;
    }
  }
}
