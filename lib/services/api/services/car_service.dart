import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Get auth token from secure storage
      final token = await _storage.read(key: 'auth_token');
      
      // Get user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }
      
      if (kDebugMode) {
        print('Getting cars for user ID: $userId');
      }

      // Make the request using the class's http client
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.userCarsList}'),
        headers: {
          'Accept': 'application/json',
          'user_id': userId,  // Add user_id to headers as per API requirement
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        
        if (responseData is Map && responseData['success'] == true) {
          // Handle successful response with data array
          final List<dynamic> carsData = responseData['data'] ?? [];
          return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else if (responseData is List) {
          // Fallback: Handle direct array response if the API changes
          return responseData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to load cars: ${response.statusCode} - ${response.body}');
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
  
  /// Fetches all cars listed by a specific user
  Future<List<CarPost>> getCarsByUserId(String userId) async {
    try {
      // Get the auth token from secure storage
      final token = await _storage.read(key: 'auth_token');
      
      if (kDebugMode) {
        print('Getting cars for user ID: $userId');
      }
      
      // Make the request using the class's http client
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.userCarsList}'),
        headers: {
          'Accept': 'application/json',
          'user_id': userId,
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        
        if (responseData is Map && responseData['success'] == true) {
          final List<dynamic> carsData = responseData['data'] ?? [];
          return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to load user cars: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in getCarsByUserId: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in getCarsByUserId: $e');
      }
      rethrow;
    }
  }
  
  /// Fetches all cars listed by all users (public endpoint)
  /// Updates an existing car listing
  /// 
  /// [carId] - ID of the car to update
  /// [updates] - Map of fields to update
  /// Returns the updated CarPost
  Future<CarPost> updateCar({
    required String carId,
    required Map<String, dynamic> updates,
    List<File>? newImages,
    List<String>? removedImageUrls,
  }) async {
    try {
      if (kDebugMode) {
        print('Updating car $carId with data: $updates');
      }
      
      // Get the auth token from secure storage
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Use POST with _method=PUT for Laravel's form method spoofing
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cars}/$carId');
      final request = http.MultipartRequest('POST', url);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      // Add _method=PUT for Laravel's form method spoofing
      request.fields['_method'] = 'PUT';
      
      // Add all fields from updates
      updates.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      
      // Add new images if any
      if (newImages != null && newImages.isNotEmpty) {
        for (var image in newImages) {
          try {
            final file = await http.MultipartFile.fromPath('new_images[]', image.path);
            request.files.add(file);
          } catch (e) {
            if (kDebugMode) {
              print('Error adding image ${image.path}: $e');
            }
          }
        }
      }
      
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Update response status: ${response.statusCode}');
        print('Update response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        
        if (responseData is Map && responseData['success'] == true) {
          return CarPost.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to update car: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in updateCar: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateCar: $e');
      }
      rethrow;
    }
  }

  Future<List<CarPost>> getAllCars() async {
    try {
      if (kDebugMode) {
        print('Fetching all cars from public endpoint');
      }
      
      // Make the request to the public endpoint without authentication
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cars}'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if (kDebugMode) {
        print('All cars response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        
        if (responseData is Map && responseData['success'] == true) {
          // Handle successful response with data array
          final List<dynamic> carsData = responseData['data'] ?? [];
          return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else if (responseData is List) {
          // Fallback: Handle direct array response if the API changes
          return responseData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }
      } else {
        throw Exception('Failed to load all cars: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in getAllCars: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in getAllCars: $e');
      }
      rethrow;
    }
  }
}
