import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/car_post.dart';
import '../../providers/all_cars_provider.dart';
import '../../widgets/car_post_card_new.dart';
import 'car_filter_modal.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart' as custom_error;

class CarPostsContent extends ConsumerWidget {
  const CarPostsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsAsync = ref.watch(allCarsProvider);

    return carsAsync.when(
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) {
        print('Error loading cars: $error');
        print('Stack trace: $stack');
        return Center(
          child: custom_error.CustomErrorWidget(
            message: 'Failed to load cars. Please try again.',
            onRetry: () => ref.refresh(allCarsProvider.future),
          ),
        );
      },
      data: (cars) {
        if (cars.isEmpty) {
          return const Center(child: Text('No cars available'));
        }
        return _CarPostsContent(cars: cars);
      },
    );
  }
}

class _CarPostsContent extends StatefulWidget {
  final List<CarPost> cars;

  const _CarPostsContent({required this.cars});

  @override
  _CarPostsContentState createState() => _CarPostsContentState();
}

class _CarPostsContentState extends State<_CarPostsContent> {
  List<CarPost> _posts = [];

  @override
  void initState() {
    super.initState();
    _posts = widget.cars;
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
    if (_posts.isEmpty) {
      return const Center(
        child: Text('No cars available'),
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

    Future<void> _onRefresh() async {
      if (mounted) {
        setState(() {
          _posts = widget.cars;
        });
      }
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
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
