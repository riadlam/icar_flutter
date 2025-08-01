import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car_post.dart';
import '../screens/car_detail_screen.dart';
import '../services/share_service.dart' as share_service;
import '../services/api/services/favorite_seller_service.dart';
import '../services/api/services/subscription_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/car_wishlist_provider.dart';

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
  late final PageController _pageController;
  int _currentPage = 0;
  late bool _isFavorite;
  bool _isLoading = false;
  final FavoriteSellerService _favoriteService = FavoriteSellerService();
  final SubscriptionService _subscriptionService = SubscriptionService(client: http.Client(), storage: const FlutterSecureStorage());

  bool _isSubscribed = false; // Initial state before checking API
  bool _isSubscriptionLoading = true; // Start loading as we will check status in initState

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavoriteSeller; // Keep this for favorite sellers
    _pageController = PageController();
    // _isSubscribed will be set by _checkSubscriptionStatus
    _checkFavoriteStatus();
    _checkSubscriptionStatus();
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

  Future<void> _checkSubscriptionStatus() async {
    if (widget.post.sellerId == null) {
      if (mounted) setState(() => _isSubscriptionLoading = false);
      return;
    }
    if (mounted) setState(() => _isSubscriptionLoading = true);

    try {
      final currentStatus = await _subscriptionService.checkSubscriptionStatus(
        int.parse(widget.post.sellerId!),
      );
      if (mounted) {
        setState(() {
          _isSubscribed = currentStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Failed to check initial subscription status: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubscriptionLoading = false);
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

  // Placeholder: Replace with your actual method to get the current user's ID
  Future<String?> _getCurrentUserId() async {
    // Example: Fetch from a service or secure storage
    // final userId = await YourAuthService.instance.getCurrentUserId();
    // For now, returning a placeholder. Replace this with actual logic.
    // If your user ID is an int, adjust the return type and comparison.
    // FlutterSecureStorage storage = const FlutterSecureStorage();
    // return await storage.read(key: 'user_id'); 
    print('Placeholder: _getCurrentUserId() needs to be implemented.');
    return null; // Or some default if not available / not logged in
  }

  Future<void> _toggleSubscription() async {
    if (widget.post.sellerId == null) return;

    // Check for self-subscription
    final currentUserId = await _getCurrentUserId(); // Assuming this returns String ID
    if (currentUserId != null && currentUserId == widget.post.sellerId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('cant_subscribe_to_self'.tr()),
            backgroundColor: Colors.orange, // Or your preferred color for warnings
          ),
        );
      }
      return; // Prevent further action
    }

    setState(() => _isSubscriptionLoading = true);
    try {
      final response = await _subscriptionService.toggleSubscription(
        int.parse(widget.post.sellerId!),
      );

      if (mounted) {
        final isNowSubscribed = response['action'] == 'subscribed';
        setState(() => _isSubscribed = isNowSubscribed);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNowSubscribed 
                  ? '${'subscribed_to_notifications_from'.tr()} ${widget.post.sellerName ?? 'this seller'}' 
                  : '${'unsubscribed_from_notifications_from'.tr()} ${widget.post.sellerName ?? 'this seller'}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        widget.onPostNotificationsChanged?.call(isNowSubscribed);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failed_to_update_subscription_status'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error toggling subscription: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubscriptionLoading = false);
      }
    }
  }

  void _navigateToDetail(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      pageBuilder: (context, _, __) {
        return Material(
          type: MaterialType.transparency,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CarDetailScreen(post: widget.post),
          ),
        );
      },
    );
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
    
    return Consumer(
      builder: (context, ref, _) {
        final isWishlisted = ref.watch(carWishlistProvider).contains(widget.post.id);
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
                          : Column(
  children: [
    Expanded(
      child: PageView.builder(
        itemCount: widget.post.images.length,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final image = widget.post.images[index];
          return Image.network(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 280,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.error_outline, color: Colors.grey, size: 48),
            ),
          );
        },
      ),
    ),
    if (widget.post.images.length > 1)
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.post.images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 10 : 7,
              height: _currentPage == index ? 10 : 7,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
  ],
),
                      
                      
                      // Gradient overlay at bottom for text readability
                      PositionedDirectional(
                        bottom: 0,
                        start: 0,
                        end: 0,
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
                     
                      // Wishlist button
                      Positioned(
                        bottom: 10,
                        right: 16,
                        child: Container(
                          
                          child: IconButton(
                            icon: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? Colors.red : Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              final notifier = ref.read(carWishlistProvider.notifier);
                              notifier.toggleWishlist(widget.post.id);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
                                        _toggleSubscription(); // Call the new toggle method
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                     
                                      PopupMenuItem(
                                        value: 'notifications',
                                        enabled: !_isSubscriptionLoading, // Disable item if subscription action is loading
                                        child: _isSubscriptionLoading
                                          ? Row(
                                              children: [
                                                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                                                const SizedBox(width: 8),
                                                Text('loading'.tr()), // Assuming 'loading' key exists
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Icon(
                                                  _isSubscribed ? Icons.notifications_active : Icons.notifications_none,
                                                  color: _isSubscribed ? Theme.of(context).primaryColor : Colors.grey,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _isSubscribed 
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
                Container(
                  color: Colors.white,
                  child: Padding(
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
                        // Share button and posted date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => share_service.ShareService.shareCarPost(context, widget.post),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/sharebutton.webp',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                            if (widget.post.createdAt != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, right: 8.0),
                                child: Text(
                                  'posted_since'.tr(
                                    namedArgs: {'date': DateFormat('y-MM-dd').format(
                                      widget.post.createdAt!.toLocal()
                                    )}
                                  ),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }
}
