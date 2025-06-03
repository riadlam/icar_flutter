import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/providers/car_search_provider.dart';
import 'package:icar_instagram_ui/widgets/car_post_card.dart';
import 'package:icar_instagram_ui/widgets/common/loading_widget.dart';
import 'package:icar_instagram_ui/widgets/common/error_widget.dart' as custom_error;
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';

class CarSearchResultsScreen extends ConsumerWidget {
  final String searchQuery;

  const CarSearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(carSearchProvider(searchQuery));

    return Scaffold(
      appBar: AnimatedSearchAppBar(
        showCustomBackButton: true,
        onCustomBackButtonPressed: () {
          context.go('/home');
        },
        // If you want to pass the dynamic search query to the app bar title,
        // AnimatedSearchAppBar would need a 'titleText' or similar parameter.
        // For now, it will use its default 'app_title'.
      ),
      body: searchResultsAsync.when(
        data: (cars) {
          if (cars.isEmpty) {
            return Center(
              child: Text(
                'no_cars_found_for_query'.tr(args: [searchQuery]),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final carPost = cars[index];
              // Assuming CarPostCard can handle potential nulls or has defaults
              return CarPostCard(post: carPost);
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) {
          // Log the error for debugging
          print('Error in CarSearchResultsScreen for query "$searchQuery": $error');
          print('Stack trace: $stackTrace');
          return custom_error.CustomErrorWidget(
            message: 'error_loading_search_results'.tr(),
            onRetry: () {
              // Invalidate the provider to refetch
              ref.invalidate(carSearchProvider(searchQuery));
            },
          );
        },
      ),
    );
  }
}
