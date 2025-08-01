import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/car_post.dart';
import 'car_detail_screen.dart';
import '../providers/car_wishlist_provider.dart';

class SellerProfileScreen extends StatelessWidget {
  // Helper to format the time difference between createdAt and now
  String _formatTimeAgo(DateTime? createdAt) {
    if (createdAt == null) return '';
    try {
      final created = createdAt.toLocal();
      final now = DateTime.now();
      final diff = now.difference(created);
      if (diff.inMinutes < 1) {
        return 'just now';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
      } else {
        final weeks = (diff.inDays / 7).floor();
        return '$weeks week${weeks == 1 ? '' : 's'} ago';
      }
    } catch (e) {
      return '';
    }
  }

  final String sellerName;
  final String sellerPhone;
  final String? city;
  final List<CarPost> sellerCars;

  const SellerProfileScreen({
    Key? key,
    required this.sellerName,
    required this.sellerPhone,
    this.city,
    required this.sellerCars,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get seller info from the first car if not provided directly
    final effectiveName = sellerName.isNotEmpty ? sellerName : sellerCars.isNotEmpty ? sellerCars.first.fullName ?? 'Seller' : 'Seller';
    final effectivePhone = sellerPhone.isNotEmpty ? sellerPhone : sellerCars.isNotEmpty ? sellerCars.first.sellerPhone ?? '' : '';
    final effectiveCity = city?.isNotEmpty ?? false ? city : sellerCars.isNotEmpty ? sellerCars.first.city : null;
    
    // Log seller information
    debugPrint('=== SELLER PROFILE INFO ===');
    debugPrint('Direct - Name: $sellerName, Phone: $sellerPhone, City: $city');
    debugPrint('From Cars - Name: ${sellerCars.isNotEmpty ? sellerCars.first.fullName : 'N/A'}, ' 
        'Phone: ${sellerCars.isNotEmpty ? sellerCars.first.sellerPhone : 'N/A'}, '
        'City: ${sellerCars.isNotEmpty ? sellerCars.first.city : 'N/A'}');
    debugPrint('Effective - Name: $effectiveName, Phone: $effectivePhone, City: $effectiveCity');
    debugPrint('Number of seller cars: ${sellerCars.length}');
    
    // Log first few cars for verification
    for (var i = 0; i < sellerCars.length && i < 3; i++) {
      final car = sellerCars[i];
      debugPrint('Car ${i + 1}: ${car.brand} ${car.model} (ID: ${car.id})');
      debugPrint('  - City: ${car.city}');
      debugPrint('  - Phone: ${car.sellerPhone}');
      debugPrint('  - Full Name: ${car.fullName}');
    }
    
    // Log the seller's cars data
    debugPrint('SellerProfileScreen - Building with ${sellerCars.length} cars');
    for (var i = 0; i < sellerCars.length; i++) {
      final car = sellerCars[i];
      debugPrint('Car $i: ${car.brand} ${car.model} (${car.id}) - ${car.images.length} images');
      if (car.images.isNotEmpty) {
        debugPrint('  First image URL: ${car.images.first}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'seller_profile'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.primaryColor.withOpacity(0.2),
                        child: Text(
                          sellerName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              effectiveName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (effectivePhone.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(
                                      effectivePhone,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                           
                            Row(
                              children: [
                                _buildInfoChip('${sellerCars.length} Cars', Icons.directions_car),
                                const SizedBox(width: 8),
                                _buildInfoChip(
                                  (effectiveCity?.isNotEmpty ?? false) ? effectiveCity! : 'Unknown City',
                                  Icons.circle,
                                  iconSize: 8,
                                  iconColor: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final phone = effectivePhone.replaceAll(RegExp(r'\s+'), '');
                            final uri = Uri(scheme: 'tel', path: phone);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              _showErrorSnackBar(context, 'Could not launch phone app');
                            }
                          },
                          icon: const Icon(Icons.phone, size: 20),
                          label: Text('call'.tr()),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final phone = effectivePhone.replaceAll(RegExp(r'\s+'), '');
                            final uri = Uri(scheme: 'sms', path: phone);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              _showErrorSnackBar(context, 'Could not launch SMS app');
                            }
                          },
                          icon: const Icon(Icons.message, size: 20),
                          label: Text('message'.tr()),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
            // Seller Cars Grid
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  const SizedBox(height: 12),
                  sellerCars.isEmpty 
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No cars found for this seller',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: sellerCars.length,
                        itemBuilder: (context, index) {
                          final car = sellerCars[index];
                          debugPrint('Building car card for: ${car.brand} ${car.model} (${car.id})');
                          return _buildCarCard(context, car, index);
                        },
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, {double iconSize = 16, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _carInfoIconText(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarPost car, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailScreen(post: car),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    car.images.first,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error_outline, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: car.type == 'sale' ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          car.type == 'sale' ? 'buy'.tr() : 'rent'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatTimeAgo(car.createdAt),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final isWishlisted = ref.watch(carWishlistProvider).contains(car.id);
                      
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                         
                        ),
                        child: IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            final notifier = ref.read(carWishlistProvider.notifier);
                            notifier.toggleWishlist(car.id);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.formattedPrice,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _carInfoIconText(Icons.speed, '${car.mileage} km'),
                        const SizedBox(width: 8),
                        _carInfoIconText(Icons.calendar_today, '${car.year}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
