import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/car_post.dart';
import 'post_menu_dialog.dart';
import '../services/share_service.dart';

class CarPostCard extends StatelessWidget {
  final CarPost post;
  final Function(bool)? onWishlistPressed;
  // Removed onMenuPressed as we're handling it directly in the PopupMenuButton
  final bool isFavoriteSeller;
  final bool isPostNotificationsActive;
  final Function(bool)? onFavoriteSellerChanged;
  final Function(bool)? onPostNotificationsChanged;

  const CarPostCard({
    Key? key,
    required this.post,
    this.onWishlistPressed,
    this.isFavoriteSeller = false,
    this.isPostNotificationsActive = false,
    this.onFavoriteSellerChanged,
    this.onPostNotificationsChanged,
  }) : super(key: key);

  void _navigateToDetail(BuildContext context) {
    context.push('/car-detail', extra: post);
  }
  
  String _formatPrice(double price) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(price)} DA';
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.96; // Slightly narrower for better margins
    
    return Center(
      child: SizedBox(
        width: cardWidth,
        child: GestureDetector(
          onTap: () => _navigateToDetail(context),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image section - taller and full width
                SizedBox(
                  height: 280, // Increased height for better image display
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image slideshow
                      ImageSlideshow(
                        width: double.infinity,
                        height: 280,
                        initialPage: 0,
                        indicatorColor: Colors.blue,
                        indicatorBackgroundColor: Colors.grey[300],
                        children: post.images
                            .map((image) => Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 280,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                                  ),
                                ))
                            .toList(),
                      ),
                      
                      // Gradient overlay at bottom for text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                      ),
                      
                      // Price and type tag
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 80,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: post.isForSale ? Colors.blue[600] : Colors.green[600],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                post.type.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Wishlist button
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            if (onWishlistPressed != null) {
                              onWishlistPressed!(!post.isWishlisted);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                post.isWishlisted ? Icons.favorite : Icons.favorite_border,
                                color: post.isWishlisted ? Colors.red : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Seller info overlay at top
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Seller name
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                (post.sellerName ?? 'Seller').toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            
                            // Menu button
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                                padding: const EdgeInsets.all(8),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Drag handle
                                          Container(
                                            width: 40,
                                            height: 4,
                                            margin: const EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          // Title
                                          
                                          // Favorite seller option
                                          ListTile(
                                            leading: Icon(
                                              isFavoriteSeller ? Icons.favorite : Icons.favorite_border,
                                              color: isFavoriteSeller ? Colors.red : null,
                                            ),
                                            title: Text(
                                              isFavoriteSeller 
                                                  ? 'Remove from Favorite Sellers' 
                                                  : 'Add to Favorite Sellers',
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (onFavoriteSellerChanged != null) {
                                                onFavoriteSellerChanged!(!isFavoriteSeller);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      isFavoriteSeller 
                                                          ? 'Removed from favorite sellers' 
                                                          : 'Added to favorite sellers',
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          // Post notifications option
                                          ListTile(
                                            leading: Icon(
                                              isPostNotificationsActive 
                                                  ? Icons.notifications_active 
                                                  : Icons.notifications_off_outlined,
                                              color: isPostNotificationsActive ? Theme.of(context).primaryColor : null,
                                            ),
                                            title: Text(
                                              isPostNotificationsActive 
                                                  ? 'Turn Off Post Notifications' 
                                                  : 'Turn On Post Notifications',
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              if (onPostNotificationsChanged != null) {
                                                onPostNotificationsChanged!(!isPostNotificationsActive);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      isPostNotificationsActive 
                                                          ? 'Post notifications turned off' 
                                                          : 'Post notifications activated',
                                                    ),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                         
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Car details section - more compact
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Car title
                          Text(
                            '${post.brand} ${post.model} ${post.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                
                              ),
                              child: Text(
                                _formatPrice(post.price),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          
                        ],
                      ),
// Share button
                          GestureDetector(
                            onTap: () => ShareService.shareCarPost(context, post),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.share,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
