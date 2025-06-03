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
        for (var i = 0; i < newImages.length; i++) {
          try {
            final image = newImages[i];
            final fileExtension = image.path.split('.').last.toLowerCase();
            final mimeType = fileExtension == 'png' 
                ? 'image/png' 
                : fileExtension == 'jpg' || fileExtension == 'jpeg'
                    ? 'image/jpeg'
                    : 'image/*';
                    
            final file = await http.MultipartFile.fromPath(
              'images[]',  // Using images[] to match the API
              image.path,
              contentType: MediaType.parse(mimeType),
            );
            
            request.files.add(file);
            
            if (kDebugMode) {
              print('Added image ${i + 1}: ${image.path}');
              print('  - MIME type: $mimeType');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error adding image ${newImages[i].path}: $e');
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

  /// Filters cars based on the provided criteria
  /// 
  /// [brand] - Filter by car brand
  /// [model] - Filter by car model
  /// [type] - Filter by listing type ('sale' or 'rent')
  /// [year] - Filter by manufacturing year
  /// [transmission] - Filter by transmission type
  /// [fuelType] - Filter by fuel type
  /// [mileage] - Filter by maximum mileage
  /// [priceMin] - Filter by minimum price
  /// [priceMax] - Filter by maximum price
  /// Returns a list of cars matching the criteria
  Future<List<CarPost>> filterCars({
    String? brand,
    String? model,
    String? type,
    int? year,
    String? transmission,
    String? fuelType,
    int? mileage,
    double? priceMin,
    double? priceMax,
  }) async {
    print('🚀 filterCars called with:');
    print('  - brand: $brand');
    print('  - model: $model');
    print('  - type: $type');
    print('  - year: $year');
    print('  - transmission: $transmission');
    print('  - fuelType: $fuelType');
    print('  - mileage: $mileage');
    print('  - priceMin: $priceMin');
    print('  - priceMax: $priceMax');
    try {
      // Debug log all input parameters
      if (kDebugMode) {
        print('🔍 filterCars called with parameters:');
        print('  - brand: $brand');
        print('  - model: $model');
        print('  - type: $type');
        print('  - year: $year');
        print('  - transmission: $transmission');
        print('  - fuelType: $fuelType');
        print('  - mileage: $mileage');
        print('  - priceMin: $priceMin');
        print('  - priceMax: $priceMax');
      }
      
      // Build request body with case-insensitive matching and debug logging
      final Map<String, dynamic> requestBody = {};
      
      // Add brand if provided
      if (brand != null && brand != 'all') {
        final brandValue = brand.toLowerCase();
        requestBody['brand'] = brandValue;
        if (kDebugMode) print('✅ Added brand to request: $brandValue');
      }
      
      // Add model if provided
      if (model != null && model.isNotEmpty) {
        final modelValue = model.toLowerCase();
        requestBody['model'] = modelValue;
        if (kDebugMode) print('✅ Added model to request: $modelValue');
      } else {
        if (kDebugMode) print('ℹ️ No model provided or model is empty');
      }
      
      // Add other filters
      if (type != null && type != 'all') {
        requestBody['type'] = type;
        if (kDebugMode) print('✅ Added type to request: $type');
      }
      if (year != null) {
        requestBody['year'] = year;
        if (kDebugMode) print('✅ Added year to request: $year');
      }
      if (transmission != null && transmission != 'all') {
        requestBody['transmission'] = transmission;
        if (kDebugMode) print('✅ Added transmission to request: $transmission');
      }
      if (fuelType != null && fuelType != 'all') {
        requestBody['fuel_type'] = fuelType;
        if (kDebugMode) print('✅ Added fuelType to request: $fuelType');
      }
      if (mileage != null) {
        requestBody['mileage'] = mileage;
        if (kDebugMode) print('✅ Added mileage to request: $mileage');
      }
      if (priceMin != null) {
        requestBody['price_min'] = priceMin;
        if (kDebugMode) print('✅ Added priceMin to request: $priceMin');
      }
      if (priceMax != null) {
        requestBody['price_max'] = priceMax;
        if (kDebugMode) print('✅ Added priceMax to request: $priceMax');
      }
      
      // Debug log the request body before sending
      if (kDebugMode) {
        print('📦 Final request body before encoding: $requestBody');
        print('🔢 Number of parameters in request body: ${requestBody.length}');
      }

      final endpoint = '${ApiEndpoints.baseUrl}${ApiEndpoints.cars}/filter';
      final uri = Uri.parse(endpoint);
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Enhanced debug logging
      if (kDebugMode) {
        print('\n📡 API FILTER REQUEST');
        print('├─ Endpoint: $endpoint');
        print('├─ Method: POST');
        print('├─ Headers:');
        headers.forEach((key, value) => print('│  ├─ $key: $value'));
        print('├─ Request Body:');
        final encoder = JsonEncoder.withIndent('  ');
        print(encoder.convert(requestBody).split('\n').map((line) => '│  $line').join('\n'));
        print('└──────────────────────────────────────────────────────────────\n');
      }

      final response = await _httpClient.post(
        uri,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Enhanced response logging
      if (kDebugMode) {
        final responseTime = DateTime.now();
        print('\n📡 API FILTER RESPONSE');
        print('├─ Status Code: ${response.statusCode} ${response.reasonPhrase}');
        print('├─ Response Time: $responseTime');
        print('├─ Headers:');
        response.headers.forEach((key, value) => print('│  ├─ $key: $value'));
        print('├─ Response Body:');
        try {
          final jsonResponse = json.decode(response.body);
          final encoder = JsonEncoder.withIndent('  ');
          print(encoder.convert(jsonResponse).split('\n').map((line) => '│  $line').join('\n'));
        } catch (e) {
          print('│  ${response.body.replaceAll('\n', '\n│  ')}');
        }
        print('└──────────────────────────────────────────────────────────────\n');
      }

      // Successfully processed filterCars response logging, now checking status code
      if (response.statusCode == 200) {
  // THIS IS THE END OF THE ORIGINAL filterCars METHOD's try block before error handling or returning
  // The new searchCars method will be inserted AFTER the entire filterCars method.
  // The actual insertion point will be after the closing brace of filterCars.
  // THIS CHUNK IS JUST FOR LOCATING THE END OF filterCars.
  // The REAL TargetContent for insertion should be the closing brace of filterCars.

        final responseData = json.decode(utf8.decode(response.bodyBytes));
        
        if (responseData is Map && responseData['success'] == true) {
          final List<dynamic> carsData = responseData['data'] ?? [];
          final cars = carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
          
          if (kDebugMode) {
            print('╔══════════════════════════════════════════════════════════════');
            print('║ 🚗 PARSED CARS DATA');
            print('╟──────────────────────────────────────────────────────────────');
            print('║ Found ${cars.length} cars');
            if (cars.isNotEmpty) {
              print('║ First car details:');
              print('║   • ID: ${cars.first.id}');
              print('║   • Brand: ${cars.first.brand}');
              print('║   • Model: ${cars.first.model}');
              print('║   • Year: ${cars.first.year}');
              print('║   • Price: ${cars.first.price}');
            }
            print('╚══════════════════════════════════════════════════════════════');
          }
          
          return cars;
        } else {
          final errorMsg = 'Invalid response format: ${response.body}';
          if (kDebugMode) print('❌ $errorMsg');
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to filter cars: ${response.statusCode} - ${response.body}';
        if (kDebugMode) print('❌ $errorMsg');
        throw Exception(errorMsg);
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in filterCars: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in filterCars: $e');
      }
      rethrow;
    }
  }

  /// Searches for cars based on a query string
  Future<List<CarPost>> searchCars(String query) async {
    try {
      if (kDebugMode) {
        print('Searching cars with query: $query');
      }

      // Construct the URI with the query parameter
      final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.searchCars}').replace(queryParameters: {'q': query});

      final response = await _httpClient.get(
        uri,
        headers: await getAuthHeaders(), // Assuming getAuthHeaders() is available from BaseApiService or similar
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData is Map && responseData['success'] == true) {
          final List<dynamic> carsData = responseData['data'] ?? [];
          if (kDebugMode) {
            print('Search successful, found ${carsData.length} cars.');
          }
          return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
        } else {
          if (kDebugMode) {
            print('Search response format unexpected or success false: ${response.body}');
          }
          if (responseData is Map && responseData.containsKey('data') && responseData['data'] is List) {
             final List<dynamic> carsData = responseData['data'];
             return carsData.map((carJson) => CarPost.fromJson(carJson)).toList();
          }
          return []; 
        }
      } else {
        if (kDebugMode) {
          print('Failed to search cars: ${response.statusCode} - ${response.body}');
        }
        throw Exception('Failed to search cars: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Network error in searchCars: $e');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('Error in searchCars: $e');
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
