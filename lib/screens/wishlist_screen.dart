import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/models/spare_parts_search_params.dart';
import 'package:icar_instagram_ui/outils/appbar_custom.dart';
import 'package:icar_instagram_ui/providers/wishlist_provider.dart';
import 'package:icar_instagram_ui/providers/tow_truck_wishlist_provider.dart';
import 'package:icar_instagram_ui/providers/car_wishlist_provider.dart';
import 'package:icar_instagram_ui/providers/spare_parts_wishlist_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
import 'package:icar_instagram_ui/widgets/cards/spare_parts_card.dart';
import 'package:icar_instagram_ui/widgets/car_post_card.dart';
import '../models/tow_truck_service.dart' as tow_truck_model;
import '../services/api/service_locator.dart' as service_locator;

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garageWishlist = ref.watch(wishlistProvider);
    final towTruckWishlist = ref.watch(towTruckWishlistProvider);
    final carWishlist = ref.watch(carWishlistProvider);
    final sparePartsWishlist = ref.watch(sparePartsWishlistItemsProvider);
    
    return Scaffold(
      appBar: AnimatedSearchAppBar(),
      body: _buildCombinedWishlist(
        garageWishlist, 
        towTruckWishlist, 
        carWishlist,
        sparePartsWishlist,
        ref,
      ),
    );
  }

  Widget _buildCombinedWishlist(
    List<GarageService> garageWishlist,
    Set<String> towTruckWishlist,
    Set<String> carWishlist,
    List<SparePartsProfile> sparePartsWishlist,
    WidgetRef ref,
  ) {
    final hasGarageItems = garageWishlist.isNotEmpty;
    final hasTowTruckItems = towTruckWishlist.isNotEmpty;
    final hasCarItems = carWishlist.isNotEmpty;
    final hasSparePartsItems = sparePartsWishlist.isNotEmpty;
    debugPrint('Spare parts in wishlist: ${sparePartsWishlist.length}');

    if (!hasGarageItems && !hasTowTruckItems && !hasCarItems && !hasSparePartsItems) {
      return const Center(
        child: Text('Your wishlist is empty'),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: service_locator.serviceLocator.towTruckService.getAllTowTruckProfiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading tow trucks: ${snapshot.error}'));
        }

        final towTruckProfiles = snapshot.data ?? [];
        final towTruckServices = towTruckProfiles
            .where((profile) => towTruckWishlist.contains(profile['id'].toString()))
            .map((profile) => tow_truck_model.TowTruckService(
                  id: profile['id'].toString(),
                  businessName: profile['business_name'] ?? 'Unnamed Business',
                  driverName: profile['driver_name'] ?? 'No Name',
                  phoneNumber: profile['mobile'] ?? 'No Phone',
                  location: profile['city'] ?? 'No Location',
                  imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be',
                  isFavorite: true,
                ))
            .toList();

        // Fetch car posts for wishlisted cars
        return FutureBuilder<List<CarPost>>(
          future: _fetchWishlistedCars(carWishlist, ref),
          builder: (context, carSnapshot) {
            final isLoadingCars = carSnapshot.connectionState == ConnectionState.waiting;

            if (isLoadingCars && !hasGarageItems && !hasTowTruckItems) {
              return const Center(child: CircularProgressIndicator());
            }

            final carPosts = carSnapshot.data ?? [];

            // Get spare parts profiles for wishlisted items
          return FutureBuilder<List<SparePartsProfile>>(
            future: _fetchWishlistedSparePartsProfiles(sparePartsWishlist, ref),
            builder: (context, sparePartsSnapshot) {
              final isLoadingSpareParts = sparePartsSnapshot.connectionState == ConnectionState.waiting;
              final sparePartsProfiles = sparePartsSnapshot.data ?? [];
              final hasSpareParts = sparePartsWishlist.isNotEmpty; // Check the wishlist, not the loaded profiles
              
              debugPrint('hasSpareParts: $hasSpareParts, sparePartsWishlist: $sparePartsWishlist, loadedProfiles: ${sparePartsProfiles.length}');
              
              // Only show loading if there are no other items to show
              if ((isLoadingSpareParts || isLoadingCars) && !hasGarageItems && !hasTowTruckItems) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasCarItems) ...[
                      ...carPosts.map((car) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: CarPostCard(
                          post: car,
                          onWishlistPressed: null,
                        ),
                      )).toList(),
                    ],
                    
                    if (hasGarageItems) ...[
                      ...garageWishlist.map((service) => GarageServiceCard(
                        service: service,
                        onTap: () {
                          // Handle tap on garage service
                        },
                      )),
                    ],
                    
                    if (hasTowTruckItems) ...[
                      ...towTruckServices.map((service) => TowTruckServiceCard(
                        service: service,
                        onTap: () {
                          // Handle tap on tow truck service
                        },
                      )),
                    ],
                    
                    // Show spare parts section if there are items in the wishlist
                    if (hasSparePartsItems) ...[
                      
                      ...sparePartsWishlist.map((profile) {
                        final partId = '${profile.storeName}_${profile.mobile}';
                        debugPrint('Displaying spare part in wishlist: $partId');
                        return SparePartsCard(
                          partName: profile.storeName,
                          location: profile.city,
                          mobileNumber: profile.mobile,
                          partId: partId,
                          profile: profile,
                          imageUrl: 'https://via.placeholder.com/150',
                          showFavoriteButton: true,
                        );
                      }).toList(),
                    ],
                  ],
                ),
              );
            },
          );
          },
        );
      },
    );
  }

  Future<List<CarPost>> _fetchWishlistedCars(Set<String> carWishlist, WidgetRef ref) async {
    if (carWishlist.isEmpty) return [];
    
    try {
      final carService = service_locator.serviceLocator.carService;
      final allCars = await carService.getAllCars();
      
      // Filter cars that are in the wishlist
      return allCars.where((car) => carWishlist.contains(car.id)).toList();
    } catch (e) {
      debugPrint('Error fetching wishlisted cars: $e');
      return [];
    }
  }
  
  // No longer need to fetch spare parts profiles as they're now stored in the provider
  // We'll just return the wishlisted profiles directly from the provider
  Future<List<SparePartsProfile>> _fetchWishlistedSparePartsProfiles(
    List<SparePartsProfile> sparePartsWishlist, 
    WidgetRef ref
  ) async {
    debugPrint('Returning ${sparePartsWishlist.length} wishlisted spare parts');
    return sparePartsWishlist;
  }
}
