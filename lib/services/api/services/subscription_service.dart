import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart'; // For getAuthHeaders

class SubscriptionService extends BaseApiService {
  SubscriptionService({
    required http.Client client,
    required FlutterSecureStorage storage,
  }) : super(client: client, storage: storage);

  Future<Map<String, dynamic>> toggleSubscription(int sellerId) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.userSubscription(sellerId)}');
    if (kDebugMode) {
      print('Toggling subscription for seller ID: $sellerId at $uri');
    }

    final response = await post(
      ApiEndpoints.userSubscription(sellerId),
      body: {}, // Empty body for POST, as per cURL
    );
    if (response.containsKey('action')) {
      return response; // Return the full response map
    } else {
      print('Subscription toggle response did not contain an "action" field: $response');
      throw Exception('Failed to toggle subscription: Invalid response format from server.');
    }
  }

  Future<bool> checkSubscriptionStatus(int sellerId) async {
    try {
      final response = await get(ApiEndpoints.userSubscriptionStatus(sellerId));
      if (response.containsKey('is_subscribed') && response['is_subscribed'] is bool) {
        return response['is_subscribed'] as bool;
      }
      print('Subscription status check response did not contain a boolean "is_subscribed" field or was malformed: $response');
      return false;
    } catch (e) {
      print('Error checking subscription status for seller $sellerId: $e');
      return false; 
    }
  }
}
