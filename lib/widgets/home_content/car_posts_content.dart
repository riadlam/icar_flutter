import 'package:flutter/material.dart';
import '../../models/car_post.dart';
import '../../services/api/service_locator.dart';
import '../../services/api/services/car_service.dart';
import '../../widgets/car_post_card_new.dart';
import 'car_filter_modal.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart' as custom_error;

class CarPostsContent extends StatefulWidget {
  const CarPostsContent({Key? key}) : super(key: key);

  @override
  _CarPostsContentState createState() => _CarPostsContentState();
}

class _CarPostsContentState extends State<CarPostsContent> {
  late final CarService _carService;
  bool _isLoading = true;
  String? _errorMessage;
  List<CarPost> _posts = [];

  @override
  void initState() {
    super.initState();
    _carService = serviceLocator.carService;
    _loadCars();
  }

  Future<void> _loadCars() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cars = await _carService.getUserCars();
      if (!mounted) return;
      
      setState(() {
        _posts = cars;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = e.toString().contains('401')
            ? 'Authentication required. Please log in again.'
            : 'Failed to load cars. Please check your connection and try again.';
        _isLoading = false;
      });
      
      debugPrint('Error loading cars: $e');
    }
  }

  Future<void> _toggleWishlist(int index, bool isWishlisted) async {
    if (index < 0 || index >= _posts.length) return;
    
    try {
      final post = _posts[index];
      
      // Optimistically update the UI
      setState(() {
        _posts[index] = post.copyWith(isWishlisted: isWishlisted);
      });
      
      // Show a snackbar to provide feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isWishlisted 
                  ? 'Added to wishlist' 
                  : 'Removed from wishlist',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      // Call the API to update the wishlist status
      // await _carService.toggleWishlist(post.id, isWishlisted);
      
    } catch (e) {
      // Revert the UI if the API call fails
      if (context.mounted) {
        setState(() {
          final post = _posts[index];
          _posts[index] = post.copyWith(isWishlisted: !isWishlisted);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update wishlist. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      debugPrint('Error toggling wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: LoadingWidget(),
      );
    }

    if (_errorMessage != null) {
      return custom_error.CustomErrorWidget(
        message: _errorMessage!,
        onRetry: _loadCars,
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Text('No cars found'),
      );
    }

    void _showFilterModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => CarFilterModal(
            onApplyFilters: (filters) {
              // Handle filters here
              print('Applied filters: $filters');
            },
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCars,
      child: Column(
        children: [
          // Filter Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFilterModal,
                    icon: const Icon(Icons.filter_list, size: 20),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Posts List
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CarPostCard(
                      key: ValueKey(post.id),
                      post: post,
                      onWishlistPressed: (isWishlisted) {
                        // Update wishlist status
                        _toggleWishlist(index, isWishlisted);
                      },
                      // Add other required parameters here
                      isFavoriteSeller: false, // Set this based on your app's state
                      isPostNotificationsActive: false, // Set this based on your app's state
                      onFavoriteSellerChanged: (isFavorite) {
                        // Handle favorite seller change
                      },
                      onPostNotificationsChanged: (isActive) {
                        // Handle post notifications change
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
