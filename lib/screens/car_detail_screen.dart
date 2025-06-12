import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:icar_instagram_ui/providers/notification_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/screens/seller_profile_screen.dart';
import 'package:icar_instagram_ui/services/api/service_locator.dart';
import 'package:icar_instagram_ui/services/api/services/car_service.dart';
import 'package:icar_instagram_ui/services/api/services/user_service.dart';
import 'package:icar_instagram_ui/providers/car_wishlist_provider.dart';

// Using the existing StringCasingExtension instead of defining a new one
// This avoids the duplicate extension member conflict

class CarDetailScreen extends StatelessWidget {
  final CarPost post;
  final CarService carService;
  final UserService userService;

  CarDetailScreen({
    Key? key, 
    required this.post,
    CarService? carService,
    UserService? userService,
  }) : carService = carService ?? serviceLocator.carService,
       userService = userService ?? serviceLocator.userService,
       super(key: key);

  // Helper method to show error message
  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Handle view profile action
  Future<void> _handleViewProfile(BuildContext context) async {
    try {
      // Log post object details
      log('Post object details:');
      log('  - ID: ${post.id}');
      log('  - Type: ${post.type}');
      log('  - Brand: ${post.brand}');
      log('  - Model: ${post.model}');
      log('  - Price: ${post.price}');
      log('  - Seller ID: ${post.sellerId}');
      log('  - Seller Name: ${post.fullName}');
      log('  - Seller Phone: ${post.sellerPhone}');
      log('  - City: ${post.city}');
      log('  - Images: ${post.images}');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        log('Fetching seller profile...');
        
        // Get seller's cars using the post's seller ID
        log('Fetching seller cars...');
        List<CarPost> sellerCars = [];
        
        if (post.sellerId != null) {
          try {
            sellerCars = await carService.getCarsByUserId(post.sellerId!);
            log('Fetched ${sellerCars.length} cars for seller ${post.sellerId}');
          } catch (e) {
            log('Error fetching seller cars: $e');
            // Continue with empty list if cars can't be loaded
          }
        } else {
          log('No seller ID available for this post');
        }

        if (!context.mounted) return;
        
        // Dismiss loading dialog
        Navigator.of(context).pop();
        
        // Navigate to seller profile with the filtered cars
        if (!context.mounted) return;
        
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SellerProfileScreen(
              sellerName: post.fullName ?? 'Seller ${post.sellerId ?? 'Unknown'}' ,
              sellerPhone: post.sellerPhone ?? '',
              city: post.city,
              sellerCars: sellerCars,
            ),
          ),
        );
        
        debugPrint('Navigation completed successfully');
      } catch (e, stackTrace) {
        log('Error in _handleViewProfile', error: e, stackTrace: stackTrace);
        if (context.mounted) {
          Navigator.of(context).pop(); // Dismiss loading dialog
          _showErrorSnackBar(context, 'Failed to open profile: ${e.toString()}');
        }
      }
    } catch (e) {
      log('Unexpected error: $e');
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog if still showing
        _showErrorSnackBar(context, 'An unexpected error occurred');
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.35,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () async {
                // Refresh notifications before navigating back
                final container = ProviderScope.containerOf(context);
                try {
                  await container.read(unreadCountProvider.notifier).refresh();
                } catch (e) {
                  debugPrint('Error refreshing notifications: $e');
                }
                if (context.mounted) {
                  context.go('/home');
                }
              },
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {
                  // Share functionality
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                ImageSlideshow(
                  width: double.infinity,
                  height: double.infinity,
                  initialPage: 0,
                  indicatorColor: Colors.blue,
                  indicatorBackgroundColor: Colors.grey[300],
                  children: (post.images?.isNotEmpty ?? false)
                      ? post.images!.map((image) => Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.error_outline)),
                          ))
                          .toList()
                      : [
                          Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                        ],
                ),
                // Gradient Overlay
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Car Name - Bottom Left
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Wishlist Button - Bottom Right
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final isWishlisted = ref.watch(carWishlistProvider).contains(post.id);
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            final notifier = ref.read(carWishlistProvider.notifier);
                            notifier.toggleWishlist(post.id);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  !isWishlisted
                                      ? 'added_to_wishlist'.tr()
                                      : 'removed_from_wishlist'.tr(),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.formattedPrice,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: post.isForSale
                              ? Colors.green.withOpacity(0.9)
                              : Colors.blue.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          post.isForSale ? 'for_sale'.tr() : 'for_rent'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: (size.width - size.width * 0.1 - 8) / 2,
                        child: _buildDetailItem(Icons.speed, 'mileage'.tr(), post.formattedMileage),
                      ),
                      SizedBox(
                        width: (size.width - size.width * 0.1 - 8) / 2,
                        child: _buildDetailItem(Icons.calendar_today, 'year'.tr(), post.formattedYear),
                      ),
                      SizedBox(
                        width: (size.width - size.width * 0.1 - 8) / 2,
                        child: _buildDetailItem(Icons.settings, 'transmission'.tr(), post.transmissionType),
                      ),
                      SizedBox(
                        width: (size.width - size.width * 0.1 - 8) / 2,
                        child: _buildDetailItem(Icons.local_gas_station, 'fuel_type'.tr(), post.fuel.toTitleCase()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description Section
                  if (post.description?.isNotEmpty ?? false) ...[
                    Text(
                      'description'.tr().toUpperCase(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                      ),
                      child: Text(
                        post.description ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Seller Information
                  Text(
                    'seller_information'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: Text(
                        (post.sellerName != null && post.sellerName!.isNotEmpty)
                            ? post.sellerName![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      post.sellerName ?? 'Seller',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    subtitle: Text(post.sellerPhone ?? ''),
                    trailing: TextButton(
                      onPressed: () => _handleViewProfile(context),
                      style: TextButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'view_profile'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                 
                  const SizedBox(height: 8),
                 
                  const SizedBox(height: 24),
                  
                 
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Call
                  },
                  icon: const Icon(Icons.phone),
                  label: Text('call'.tr()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Message
                  },
                  icon: const Icon(Icons.message),
                  label: Text('message'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}