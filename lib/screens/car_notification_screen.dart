import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/services/api/services/notification_service.dart';
import 'package:icar_instagram_ui/models/notification_item.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/widgets/common/loading_widget.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart'; // Import the custom app bar

class CarNotificationScreen extends StatefulWidget {
  const CarNotificationScreen({super.key});

  @override
  State<CarNotificationScreen> createState() => _CarNotificationScreenState();
}

class _CarNotificationScreenState extends State<CarNotificationScreen> {
  late Future<List<NotificationItem>> _notificationsFuture;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.getNotifications();
  }

  void _navigateToCarDetail(NotificationCarData carData) {
    try {
      // Convert NotificationCarData to a format compatible with CarPost
      final carPost = CarPost(
        id: carData.id.toString(),
        type: carData.type ?? 'sale',
        brand: carData.brand ?? '',
        model: carData.model ?? '',
        price: carData.price?.toDouble() ?? 0.0,
        mileage: carData.mileage?.toInt() ?? 0,
        year: carData.year ?? DateTime.now().year,
        transmission: carData.transmission?.toLowerCase() ?? 'automatic',
        fuel: carData.fuel?.toLowerCase() ?? 'gasoline',
        description: carData.description ?? '',
        imageUrls: carData.images ?? [],
        sellerId: carData.userId?.toString(),
        // Include seller information from the notification data
        sellerName: carData.fullName,
        fullName: carData.fullName,
        sellerPhone: carData.mobile,
        city: carData.city,
        createdAt: carData.createdAt != null ? DateTime.tryParse(carData.createdAt!) : null,
        updatedAt: carData.updatedAt != null ? DateTime.tryParse(carData.updatedAt!) : null,
      );
      
      // Include the car ID in the route path
      context.go('/car-detail/${carData.id}', extra: carPost);
    } catch (e) {
      if (kDebugMode) {
        print('Error navigating to car detail: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load car details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedSearchAppBar(
        showCustomBackButton: true,
        onCustomBackButtonPressed: () {
          context.go('/home');
        },
      ), // Use the custom app bar with back button
      body: FutureBuilder<List<NotificationItem>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Consider a localized error message
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('no_notifications_found'.tr()));
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              DateTime createdAtDate;
              try {
                createdAtDate = DateTime.parse(notification.createdAt);
              } catch (e) {
                // Handle cases where createdAt might not be a valid date string
                // Or provide a default/fallback display
                print('Error parsing notification createdAt date: ${notification.createdAt} - $e');
                createdAtDate = DateTime.now(); // Fallback, or handle differently
              }
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                elevation: 2.0,
                child: ListTile(
                  leading: Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.primary),
                  title: Text(notification.message, style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                  onTap: () async {
                    // Mark the notification as read
                    await _notificationService.markAsRead(notification.id);
                    // Navigate to car detail
                    _navigateToCarDetail(notification.carData);
                  },
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
