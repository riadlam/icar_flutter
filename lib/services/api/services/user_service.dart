import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icar_instagram_ui/models/user_role.dart';
import '../endpoints/api_endpoints.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {
  UserService({
    required super.client,
    required super.storage,
  });

  /// Updates the user's role
  /// 
  /// [roleIndex] - The index of the role to update to
  /// Returns a Future that completes with the server response
  Future<Map<String, dynamic>> updateUserRole(int roleIndex) async {
    try {
      final response = await post(
        ApiEndpoints.updateRole,
        body: {'role_index': roleIndex},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Submits profile data based on user role
  /// 
  /// [role] - The user's role
  /// [formData] - Map containing the form data
  /// Returns a Future that completes with the server response
  /// Fetches the current user's profile information
  /// Returns a Future that completes with the user's profile data
  /// Fetches the user's role from the backend
  /// Returns a Future that completes with the user's role as a String
  Future<String> getUserRole() async {
    try {
      print('Fetching user role from: ${ApiEndpoints.userRole}');
      final response = await get(ApiEndpoints.userRole);
      print('Received response for user role: $response');
      
      if (response is! Map<String, dynamic>) {
        print('Error: Expected Map<String, dynamic> but got ${response.runtimeType}');
        throw Exception('Invalid response format');
      }
      
      if (response['role'] == null) {
        print('Error: No role found in response. Full response: $response');
        throw Exception('No role found in response');
      }
      
      final role = response['role'] as String;
      print('Successfully parsed role: $role');
      return role;
    } catch (e) {
      print('Error in getUserRole(): $e');
      rethrow;
    }
  }

  /// Fetches the current user's profile information
  /// Returns a Future that completes with the user's profile data
  /// Fetches the seller's profile data from the backend and saves it to SharedPreferences
  /// Returns a Future that completes with the seller's profile data
  Future<Map<String, dynamic>> getSellerProfile() async {
    try {
      print('Fetching seller profile from: ${ApiEndpoints.sellerProfile}');
      final response = await get(ApiEndpoints.sellerProfile);
      print('Received seller profile response: $response');
      
      if (response is! Map<String, dynamic> || response['success'] != true) {
        print('Error: Invalid response format or unsuccessful response');
        throw Exception('Failed to fetch seller profile');
      }
      
      final profileData = response['data'] as Map<String, dynamic>;
      print('Successfully parsed seller profile data: $profileData');
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile_data_seller', jsonEncode(profileData));
      print('Successfully saved seller profile to SharedPreferences');
      
      return profileData;
    } catch (e) {
      print('Error in getSellerProfile(): $e');
      rethrow;
    }
  }

  /// Fetches the current user's profile data from the generic /profile endpoint
  /// The backend will return the appropriate data based on the user's role
  /// [role] - The user's role (used for logging and storage key)
  /// Returns a Future that completes with the user's profile data
  Future<Map<String, dynamic>> getUserProfileByRole(String role) async {
    try {
      print('\n📡 [PROFILE] Fetching profile from: ${ApiEndpoints.profile}');
      final response = await get(ApiEndpoints.profile);
      
      // Log raw response
      print('\n📦 [PROFILE] Raw API Response:');
      print('----------------------------------------');
      response.forEach((key, value) {
        print('$key: $value');
      });
      print('----------------------------------------\n');
      
      if (response is! Map<String, dynamic>) {
        throw Exception('❌ [PROFILE] Invalid response format: Expected Map<String, dynamic>');
      }
      
      // The backend returns the profile data directly, not wrapped in a 'data' field
      final profileData = response;
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storageKey = 'user_profile_data_${role.toLowerCase()}';
      final jsonData = jsonEncode(profileData);
      
      // Log before saving
      print('\n💾 [STORAGE] Saving profile data to SharedPreferences:');
      print('----------------------------------------');
      print('🔑 Storage Key: $storageKey');
      print('👤 User ID: ${profileData['user_id'] ?? 'N/A'}');
      print('👥 Role: $role');
      print('📊 Data length: ${jsonData.length} characters');
      print('----------------------------------------\n');
      
      // Save the data
      await prefs.setString(storageKey, jsonData);
      
      // Save user_id if available
      if (profileData['user_id'] != null) {
        final userId = profileData['user_id'].toString();
        await prefs.setString('user_id', userId);
        print('✅ [STORAGE] Saved user_id: $userId');
      } else {
        print('⚠️ [STORAGE] No user_id found in profile data');
      }
      
      // Save the role if not already set
      final currentRole = prefs.getString('user_role');
      if (currentRole == null || currentRole.isEmpty) {
        await prefs.setString('user_role', role);
        print('✅ [STORAGE] Saved user_role: $role');
      } else {
        print('ℹ️ [STORAGE] Role already set to: $currentRole');
      }
      
      // Verify the saved data
      final savedData = prefs.getString(storageKey);
      if (savedData != null) {
        print('\n🔍 [VERIFICATION] Successfully verified saved data');
        print('----------------------------------------');
        print('🔑 Storage Key: $storageKey');
        print('📏 Data length: ${savedData.length} characters');
        print('----------------------------------------\n');
      } else {
        print('❌ [VERIFICATION] Failed to verify saved data!');
      }
      
      print('✅ [PROFILE] Successfully processed and saved profile data');
      return profileData;
    } catch (e) {
      print('❌ Error in getUserProfileByRole($role): $e');
      rethrow;
    }
  }

  /// Fetches the current user's profile information
  /// Returns a Future that completes with the user's profile data
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    try {
      final role = await getUserRole();
      print('Current user role: $role');
      
      return await getUserProfileByRole(role);
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  /// Submits profile data based on user role
  /// 
  /// [role] - The user's role
  /// [formData] - Map containing the form data
  /// Returns a Future that completes with the server response
  Future<Map<String, dynamic>> submitProfileData(UserRole role, Map<String, dynamic> formData) async {
    try {
      // Map the form data to the expected API format based on role
      Map<String, dynamic> requestData = {};
      
      switch (role) {
        case UserRole.buyer:
          requestData = {
            'full_name': formData['fullName'],
            'showroom_name': 'showrooom',
            'mobile': formData['mobile'],
            'city': formData['city'],
          };
          break;
        case UserRole.seller:
          requestData = {
            'full_name': formData['full_name'],
            'showroom_name': formData['showroom_name'],
            'mobile': formData['mobile'],
            'city': formData['city'],
          };
          break;
        case UserRole.mechanic:
          requestData = {
            'business_name': formData['driver_name'] ?? 'Mechanic Business',
            'driver_name': formData['driver_name'],
            'mobile': formData['mobile'],
            'city': formData['city'],
            // No services for mechanics
          };
          break;
        case UserRole.other:
          requestData = {
            'business_name': formData['driver_name'] ?? 'Garage Business',
            'driver_name': formData['driver_name'],
            'mobile': formData['mobile'],
            'city': formData['city'],
            'services': formData['services'] ?? [],
          };
          break;
      }
      
      final response = await post(
        ApiEndpoints.profile,
        body: requestData,
      );
      
      // Save user_id to SharedPreferences if it exists in the response
      if (response is Map<String, dynamic> && 
          response['data'] != null && 
          response['data']['user_id'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', response['data']['user_id'].toString());
        print('Saved user_id: ${response['data']['user_id']} to SharedPreferences');
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
