import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/car_post.dart';
import '../services/share_service.dart' as share_service;
import '../services/api/services/favorite_seller_service.dart';

class CarPostCard extends StatefulWidget {
  final CarPost post;
  final Function(bool)? onWishlistPressed;
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

  @override
  State<CarPostCard> createState() => _CarPostCardState();
}

class _CarPostCardState extends State<CarPostCard> {
  late bool _isFavorite;
  bool _isLoading = false;
  final FavoriteSellerService _favoriteService = FavoriteSellerService();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavoriteSeller;
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (widget.post.sellerId == null) return;
    
    setState(() => _isLoading = true);
    try {
      final isFavorite = await _favoriteService.isFavoriteSeller(int.parse(widget.post.sellerId!));
      if (mounted) {
        setState(() => _isFavorite = isFavorite);
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (widget.post.sellerId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await _favoriteService.toggleFavorite(
        int.parse(widget.post.sellerId!),
      );

      if (mounted) {
        final isNowFavorite = response['action'] == 'added';
        setState(() => _isFavorite = isNowFavorite);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNowFavorite 
                  ? 'Added to favorite sellers' 
                  : 'Removed from favorite sellers',
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        widget.onFavoriteSellerChanged?.call(isNowFavorite);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update favorite status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToDetail(BuildContext context) {
    context.push('/car-detail', extra: widget.post);
  }
  
  String _formatPrice(double price) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(price)} DA';
  }

  Widget _buildDetailChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.96;
    
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
                // Image section
                SizedBox(
                  height: 280,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image slideshow
                      widget.post.images.isEmpty
                          ? Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                              ),
                            )
                          : ImageSlideshow(
                              width: double.infinity,
                              height: 280,
                              initialPage: 0,
                              indicatorColor: Colors.blue,
                              indicatorBackgroundColor: Colors.grey[300],
                              autoPlayInterval: 3,
                              isLoop: true,
                              children: widget.post.images
                                  .map<Widget>((image) => Image.network(
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
                          decoration: const BoxDecoration(
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
                                color: widget.post.isForSale ? Colors.blue[600] : Colors.green[600],
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
                                widget.post.type.toUpperCase(),
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
                            if (widget.onWishlistPressed != null) {
                              widget.onWishlistPressed!(!widget.post.isWishlisted);
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
                                widget.post.isWishlisted ? Icons.favorite : Icons.favorite_border,
                                color: widget.post.isWishlisted ? Colors.red : Colors.white,
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
                                (widget.post.sellerName ?? 'seller'.tr()).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            
                            // Menu button
                            _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2.0,
                                  )
                                : PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                                    onSelected: (value) {
                                      if (value == 'favorite') {
                                        _toggleFavorite();
                                      } else if (value == 'notifications') {
                                        widget.onPostNotificationsChanged?.call(!widget.isPostNotificationsActive);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value: 'favorite',
                                        child: Row(
                                          children: [
                                            Icon(
                                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: _isFavorite ? Colors.red : null,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(_isFavorite ? 'remove_from_favorite_sellers'.tr() : 'add_to_favorite_sellers'.tr()),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'notifications',
                                        child: Row(
                                          children: [
                                            Icon(
                                              widget.isPostNotificationsActive 
                                                  ? Icons.notifications_off 
                                                  : Icons.notifications_none,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.isPostNotificationsActive 
                                                  ? 'turn_off_post_notifications'.tr()
                                                  : 'turn_on_post_notifications'.tr(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                            '${widget.post.brand} ${widget.post.model} ${widget.post.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatPrice(widget.post.price),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      // Share button
                      GestureDetector(
                        onTap: () => share_service.ShareService.shareCarPost(context, widget.post),
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
}
