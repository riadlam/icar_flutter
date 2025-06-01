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
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    try {
      print('Fetching profile from: ${ApiEndpoints.profile}');
      final response = await get(ApiEndpoints.profile);
      print('Profile API Response: $response');
      
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
            'showroom_name': formData['showroomName'],
            'mobile': formData['mobile'],
            'city': formData['city'],
          };
          break;
        case UserRole.seller:
          requestData = {
            'store_name': formData['storeName'],
            'mobile': formData['mobile'],
            'city': formData['city'],
          };
          break;
        case UserRole.mechanic:
        case UserRole.other:
          requestData = {
            'business_name': formData['businessName'] ?? 'Mechanic Business',
            'driver_name': formData['driverName'],
            'mobile': formData['mobile'],
            'city': formData['city'],
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
