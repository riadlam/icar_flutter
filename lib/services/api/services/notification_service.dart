import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:icar_instagram_ui/models/notification_item.dart';
import 'package:icar_instagram_ui/services/api/endpoints/api_endpoints.dart';
import 'package:icar_instagram_ui/services/api/services/base_api_service.dart';

class NotificationService extends BaseApiService {
  NotificationService({
    http.Client? client,
    FlutterSecureStorage? storage,
  }) : super(
          client: client ?? http.Client(),
          storage: storage ?? const FlutterSecureStorage(),
        );

  Future<List<NotificationItem>> getNotifications() async {
    final response = await get(ApiEndpoints.notifications);

    if (response.containsKey('data') && response['data'] is List) {
      final List<dynamic> notificationsJson = response['data'] as List<dynamic>;
      return notificationsJson
          .map((json) => NotificationItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load notifications: Invalid response format.');
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      // The post method from BaseApiService already handles the response
      await post(
        '${ApiEndpoints.notifications}/$notificationId/read',
        body: {}, // Empty body as per the curl example
      );
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error marking notification as read: $e');
      }
      return false;
    }
  }

  Future<int> getUnreadCount() async {
    final response = await get('${ApiEndpoints.notifications}/unread-count');
    
    if (response.containsKey('success') && response['success'] == true) {
      return response['unread_count'] as int;
    } else {
      throw Exception('Failed to load unread count');
    }
  }
}
