import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/models/garage_service.dart';
import 'package:icar_instagram_ui/models/car_post.dart';
import 'package:icar_instagram_ui/providers/wishlist_provider.dart';
import 'package:icar_instagram_ui/providers/tow_truck_wishlist_provider.dart';
import 'package:icar_instagram_ui/providers/car_wishlist_provider.dart';
import 'package:icar_instagram_ui/widgets/cards/garage_service_card.dart';
import 'package:icar_instagram_ui/widgets/cards/tow_truck_service_card.dart';
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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),
      body: _buildCombinedWishlist(
        garageWishlist, 
        towTruckWishlist, 
        carWishlist,
        ref,
      ),
    );
  }

  Widget _buildCombinedWishlist(
    List<GarageService> garageWishlist,
    Set<String> towTruckWishlist,
    Set<String> carWishlist,
    WidgetRef ref,
  ) {
    final hasGarageItems = garageWishlist.isNotEmpty;
    final hasTowTruckItems = towTruckWishlist.isNotEmpty;
    final hasCarItems = carWishlist.isNotEmpty;

    if (!hasGarageItems && !hasTowTruckItems && !hasCarItems) {
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
                ],
              ),
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
}
