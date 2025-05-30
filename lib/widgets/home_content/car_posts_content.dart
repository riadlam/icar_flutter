import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/car_post.dart';
import '../../providers/all_cars_provider.dart' as car_providers;
import '../../widgets/car_post_card.dart';
import 'car_filter_modal.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart' as custom_error;
import 'package:flutter/foundation.dart';

class CarPostsContent extends ConsumerStatefulWidget {
  const CarPostsContent({super.key});

  @override
  ConsumerState<CarPostsContent> createState() => _CarPostsContentState();
}

class _CarPostsContentState extends ConsumerState<CarPostsContent> {
  car_providers.CarFilterParams? _filterParams;

  @override
  void initState() {
    super.initState();
    _filterParams = car_providers.CarFilterParams();
  }

  Future<void> _onRefresh() async {
    // Refresh the data
    ref.invalidate(car_providers.allCarsProvider);
    if (_filterParams != null) {
      ref.invalidate(car_providers.filteredCarsProvider(_filterParams!));
    }
  }

  Future<void> _showFilterModal() async {
    print('Showing filter modal...');
    
    // Use a try-catch to handle any navigation errors
    try {
      final filters = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => CarFilterModal(
            onApplyFilters: (filters) {
              print('Applying filters: $filters');
              Navigator.of(context).pop(filters);
            },
          ),
        ),
      );

      if (filters != null && mounted) {
        print('Received filters in CarPostsContent: $filters');
        setState(() {
          _filterParams = car_providers.CarFilterParams(
            brand: filters['brand'] as String?,
            type: filters['type'] as String?,
            year: filters['year'] is int 
                ? filters['year'] as int? 
                : (filters['year'] is double 
                    ? (filters['year'] as double).toInt() 
                    : null),
            transmission: filters['transmission'] as String?,
            fuelType: filters['fuelType'] as String?,
            mileage: filters['mileage'] is int 
                ? filters['mileage'] as int? 
                : (filters['mileage'] is double 
                    ? (filters['mileage'] as double).toInt() 
                    : null),
          );
          print('Created new filter params: ${_filterParams?.toMap()}');
          print('Has filters: ${_filterParams?.hasFilters}');
        });
      } else if (mounted) {
        print('No filters applied or modal was dismissed');
      }
    } catch (e, stackTrace) {
      print('Error in filter modal: $e');
      print('Stack trace: $stackTrace');
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building CarPostsContent with filter params: ${_filterParams?.toMap()}');
    final carsAsync = _filterParams?.hasFilters ?? false
        ? ref.watch(car_providers.filteredCarsProvider(_filterParams!))
        : ref.watch(car_providers.allCarsProvider);

    return Column(
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
                    side: BorderSide(
                      color: _filterParams?.hasFilters ?? false
                          ? Theme.of(context).primaryColor 
                          : Colors.grey.shade300,
                      width: (_filterParams?.hasFilters ?? false) ? 2.0 : 1.0,
                    ),
                  ),
                ),
              ),
              if (_filterParams?.hasFilters ?? false) ...[
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _filterParams = car_providers.CarFilterParams();
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Cars list
        Expanded(
          child: carsAsync.when(
            loading: () => const Center(child: LoadingWidget()),
            error: (error, stack) {
              debugPrint('Error loading cars: $error');
              debugPrint('Stack trace: $stack');
              return Center(
                child: custom_error.CustomErrorWidget(
                  message: 'Failed to load cars. Please try again.',
                  onRetry: _filterParams?.hasFilters ?? false 
                      ? () => ref.refresh(car_providers.filteredCarsProvider(_filterParams!).future)
                      : () => ref.refresh(car_providers.allCarsProvider.future),
                ),
              );
            },
            data: (cars) {
              if (cars.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.car_rental, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No cars found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (_filterParams?.hasFilters ?? false) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Filters applied',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        _filterParams?.hasFilters ?? false 
                            ? 'Try adjusting your filters or search again.'
                            : 'No cars available at the moment.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }
              return _CarPostsList(
                cars: cars,
                onRefresh: _onRefresh,
              );
            },
          ),
        ),
      ],
    );
  }

  // _showFilterModal is already defined above, no need for a duplicate

  void _resetFilters() {
    setState(() {
      _filterParams = car_providers.CarFilterParams();
    });
  }
}

class _CarPostsList extends StatelessWidget {
  final List<CarPost> cars;
  final Future<void> Function()? onRefresh;

  const _CarPostsList({
    required this.cars,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final content = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final post = cars[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CarPostCard(
            key: ValueKey(post.id),
            post: post,
            onWishlistPressed: (isWishlisted) {
              // This would be handled by the parent widget
            },
            isFavoriteSeller: false,
            isPostNotificationsActive: false,
            onFavoriteSellerChanged: (isFavorite) {
              // Handle favorite seller change
            },
            onPostNotificationsChanged: (isActive) {
              // Handle post notifications change
            },
          ),
        );
      },
    );

    return onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: content,
          )
        : content;
  }
}
